---
title: "Normalized DN Cache with sharded S3-FIFO"
---

# Normalized DN Cache with sharded S3-FIFO
--------------------------

Overview
--------

DN normalization is expensive. The same DNs flow through the server many times
per session. The normalized DN cache turns the repeated transform into a hash
lookup.

The [first NDN cache version](https://www.port389.org/docs/389ds/design/normalized-dn-cache.html)
(2014) used an NSPR hashtable with 2053 buckets and a linked-list LRU. On
overflow it evicted 10000 entries and kept a minimum of 1000. Then we
switched to the Adaptive Replacement Cache (ARC) through the
[`concread`](https://crates.io/crates/concread) crate (2017). After a good
run for a few years I propose a sharded S3-FIFO cache written in Rust and
called from the same C entry points (`ndn_cache_lookup`, `ndn_cache_add`).

The 2017 [cache redesign vision](https://www.port389.org/docs/389ds/design/cache_redesign.html)
(William Brown) listed five properties a server cache should have: parallel
reads, low LRU maintenance cost, dynamic resizing, enforced size bounds, and
low tuning burden. The new S3-FIFO algorithm satisfies all five for this
workload. The algorithm postdates the 2017 document.

Use Cases
---------

The bind path normalizes the user-supplied DN to find the entry, and the
same bind DNs recur across sessions. Filters and assertions that hold
DN-syntax values (`member`, `uniqueMember`, `owner`, `seeAlso`) normalize
each value on every search and modify, so one search over a group entry
runs as many normalizations as there are members. A modify of a nested
group cascades through every parent group and re-normalizes member DNs at
each step, keeping a small working set very hot. Replication CSN and
conflict-resolution paths normalize the same DNs occasionally.

Production servers run this cache at over 99% hit ratio in steady state,
with millions of tries between restarts.

Design
------

Keys are raw DN byte strings, values are normalized DN byte strings, and
`slapi_dn_normalize_ext` is deterministic, so the cache is a pure-function
lookup table. An evicted entry can be recomputed for the cost of one
normalize call. There is no transaction model, no snapshot semantics, and
no notion of stale entries.

The cache is split into 64 shards. Each shard runs the eviction algorithm
independently over its own hash table and its own lock, so reads on
different shards run in parallel and a writer on one shard blocks readers
only on that shard. The shard index comes from the low bits of the key's
hash, which leaves the high bits free for hashbrown's SIMD tag. The shard
struct is padded to 128 bytes so neighbouring locks do not share a cache
line. Layout:

```rust
struct S3FifoShard {
    table:     HashTable<Arc<S3Entry>>,
    small:     VecDeque<Arc<[u8]>>,
    main:      VecDeque<Arc<[u8]>>,
    ghost:     VecDeque<u64>,
    ghost_set: HashSet<u64>,
    small_cap: usize,
    main_cap:  usize,
    ghost_cap: usize,
}
```

- `table` — per-shard hash table keyed by the key's hash. Each `S3Entry`
  holds the raw DN, the normalized DN value, and a 2-bit frequency
  counter stored in an `AtomicU8`.
- `small`, `main` — the S and M FIFO queues. Each entry is an
  `Arc<[u8]>` pointing at the same key bytes as the matching
  `S3Entry.key` in `table`, so the key allocation is shared between the
  queue and the table entry, not duplicated.
- `ghost` — the G FIFO queue, holding 64-bit key hashes only.
- `ghost_set` — the same hashes held as a `HashSet` so membership lookup
  is O(1).
- `small_cap`, `main_cap`, `ghost_cap` — configured size limits for the
  three queues; `ghost_cap` equals `main_cap`.

Each shard runs [S3-FIFO](https://dl.acm.org/doi/10.1145/3600006.3613147)
(Yang, Zhang, Qiu, Yue, Rashmi, SOSP 2023). New entries land in a small
FIFO queue S (10% of the shard's capacity). Entries that prove popular
get promoted from S to a main FIFO queue M (the remaining 90%). Hashes of
entries that fell out of S without earning promotion live for a while in
a ghost queue G (sized like M, hashes only, no values). Each cached entry
carries a 2-bit frequency counter that saturates at 3 and is bumped with
a compare-and-swap on every hit.

On a miss, the inserter takes the shard's write lock. If the key's hash
is in G (the entry was evicted recently and the caller came back for it),
the new entry goes straight into M. Otherwise it goes into S. Either way
the counter starts at 0.

When S is full, eviction pops the head and reads its counter. A counter
above 1 means the entry was hit at least twice in S, so it gets promoted
to M (evicting M's head first if M is full). A counter at or below 1
means the entry never warmed up, so it is removed from the table and its
hash appended to G.

When M is full, eviction pops the head. A counter above 0 means at least
one hit since the entry entered M, so the counter is decremented and the
entry is re-appended at M's tail. A counter at 0 means the entry has
fallen out of use, so it is removed from the table. Eviction from M does
not write to G.

A scan inserts keys into S with the counter at 0; they reach the tail of
S without earning promotion and are evicted to G, and they reach M only
if re-requested while still in G. A fixup sweep over many DNs therefore
does not displace the hot set in M.

A visualisation of the algorithm lives at <https://s3fifo.com>.

Alternatives Considered
-----------------------

Concread's `ARCache` is a transactional, snapshot-consistent ARC: readers
take a transactional snapshot and writers copy-on-write a new version on
commit. That is the design for caches whose values can change during a
read, and it remains a candidate for the 389 DS entry cache. The NDN
cache does not need those guarantees, and on the memberOf suite below
S3-FIFO is 12% faster end-to-end and an order of magnitude faster on the
per-op microbench.

[`moka`](https://crates.io/crates/moka) implements W-TinyLFU and reaches
higher hit ratios on some workloads. At our 99% hit ratio the marginal
hit-ratio improvement is small, and `moka` pulls a larger Rust dependency
set than this component needs.

[SIEVE](https://www.usenix.org/conference/nsdi24/presentation/zhang-yazhuo)
(Zhang, Yang, Qiu, Vigfusson, Rashmi, NSDI 2024) comes from the same
research group as S3-FIFO and has a similar profile but as they note themselves
it's not scan resistant; hence, we skip it.

[`quick_cache`](https://crates.io/crates/quick_cache) implements a Clock-PRO
variant and would be a reasonable off-the-shelf choice. But one of the key
considerations was to have something to keep the dependency set minimal.
So our in-tree S3-FIFO module is simple enough to have minimal dependencies
and still fulfill its purpose.

Benchmarks
----------

End-to-end runs are on a Fedora 45 VM (kernel 7.1, 389-ds-base 3.2.1).
Microbenchmarks are on an Apple M4 Pro (14 cores) using `criterion`.

End-to-end memberOf performance suite (`dirsrvtests/tests/perf/memberof_test.py`,
22 tests, total pytest wall time):

```
backend     total
disabled    5440.96 s   (1:30:40)
concread    5569.46 s   (1:32:49)
s3fifo      4880.70 s   (1:21:20)
```

S3-FIFO finishes 12% sooner than the concread run on the same suite.

Slowest individual tests from the same run, in seconds:

```
test                                       concread    s3fifo
test_nestgrps_add[20000-50-50-10-10]        1882.71   1568.82
test_nestgrps_add[40000-40-20-10-10]         891.31    744.06
test_del_nestgrp[40000-400-100-20-20]        380.16    329.40
test_mod_nestgrp[40000-400-100-20-20]        238.34    218.90
test_nestgrps_import[40000-400-100-20-20]    196.55    166.05
```

The gaps are on the deeply nested-group tests, where memberOf cascades hit
the cache hardest.

Hit-path microbenchmark, Zipfian access (`zipf_1`, 50K-entry corpus,
criterion median of 30 samples):

```
threads   s3fifo       concread
1         179.81 µs    1.9131 ms
16        6.0811 ms    98.733 ms
64        24.982 ms    377.34 ms
```

The hit path never mutates a shared list, so the gap holds up as thread
count climbs. The VM result above shows the same effect on a real server.

Major Configuration Options and Enablement
------------------------------------------

The configuration stays the same. Only the implementation is changed.

| Attribute                    | Default              | Effect                                                                                                      |
| ---------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- |
| `nsslapd-ndn-cache-enabled`  | `on`                 | Turns the cache on or off. Restart required.                                                                |
| `nsslapd-ndn-cache-max-size` | `20971520` (20 MB)   | Maximum cache bytes. Converted to an entry count using a 168-byte per-entry estimate. Restart required.     |

The cache uses 64 shards, which is enough for the workloads we have seen
and can be raised in the future if needed.

External Impact
---------------

The existing `normalizedDNcache*` monitor counters are preserved.
`normalizedDNcachetries` equals hits plus misses, and
`normalizedDNcachehitratio` is computed from those two as before.

The `concread` crate is removed from `src/librslapd`, taking out its
`crossbeam-*` and `smallvec` transitive crates. The S3-FIFO module pulls
in `hashbrown`, `ahash`, and `parking_lot`.

Origin
------

<https://github.com/389ds/389-ds-base/issues/7489>

Author
------

spichugi@redhat.com
