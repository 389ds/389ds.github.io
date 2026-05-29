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
run for a few years, this design proposes a sharded S3-FIFO cache written in
Rust and called from the same C entry points (`ndn_cache_lookup`, `ndn_cache_add`).

The product interface does not change. The existing
`nsslapd-ndn-cache-enabled` and `nsslapd-ndn-cache-max-size` settings remain
the NDN cache controls.

The 2017 [cache redesign vision](https://www.port389.org/docs/389ds/design/cache_redesign.html)
(William Brown) focused on parallel reads, low LRU maintenance cost, dynamic
resizing, and enforced size bounds. This design keeps the same product-facing
shape while changing the NDN cache internals to sharded S3-FIFO. Size remains 
controlled through the existing NDN cache size setting.

Use Cases
---------

The bind path normalizes the user-supplied DN to find the entry, and the
same bind DNs recur across sessions. Filters and assertions that hold
DN-syntax values (`member`, `uniqueMember`, `owner`, `seeAlso`) normalize
assertion values. Sorted valuesets avoid normalizing every stored value for
normal equality searches, so the per-value cost is mostly in entry parse/import,
MOD_ADD/MOD_DEL of these attributes, and memberOf update paths. A modify of a
nested group cascades through parent groups, keeping a small working set very hot. 
Replication conflict-resolution path normalizes the same DNs occasionally.

Production servers run this cache at over 99% hit ratio in steady state,
with millions of tries between restarts.

Design
------

Keys are raw DN byte strings, values are normalized DN byte strings, and
`slapi_dn_normalize_ext` is deterministic, so the cache is a pure-function
lookup table. An evicted entry can be recomputed for the cost of one
normalize call. Eviction only changes whether the normalized DN is cached.

The cache is split into 64 shards. Each shard runs the eviction algorithm
independently over its own hash table and its own lock, so reads on
different shards run in parallel and a writer on one shard blocks readers
only on that shard. Shards are selected by key hash, not by worker thread.
The shard index comes from the low bits of the key's hash, which leaves the
high bits free for hashbrown's SIMD tag. The shard struct is padded to 128
bytes so neighbouring locks do not share a cache line. Layout:

```rust
struct S3FifoShard {
    table:     HashTable<Arc<S3Entry>>,
    small:     VecDeque<(u64, Arc<[u8]>)>,
    main:      VecDeque<(u64, Arc<[u8]>)>,
    ghost:     VecDeque<u64>,
    ghost_set: HashSet<u64>,
    small_cap: usize,
    main_cap:  usize,
    ghost_cap: usize,
    hits:      AtomicU64,
    misses:    AtomicU64,
    evictions: AtomicU64,
}
```

- `table` — per-shard hash table keyed by the key's hash. Each `S3Entry`
  holds the raw DN, the normalized DN value, and a 2-bit frequency
  counter stored in an `AtomicU8`.
- `small`, `main` — the S and M FIFO queues. Each queue entry stores the
  key hash and an `Arc<[u8]>` pointing at the same key bytes as the matching
  `S3Entry.key` in `table`, so the key allocation is shared and queue
  eviction does not need to re-hash the key.
- `ghost` — the G FIFO queue, holding 64-bit key hashes only.
- `ghost_set` — the same hashes held as a `HashSet` so membership lookup
  is O(1).
- `small_cap`, `main_cap`, `ghost_cap` — configured size limits for the
  three queues; `ghost_cap` equals `main_cap`.
- `hits`, `misses`, `evictions` — per-shard counters. Stats are aggregated
  by walking the shards, so read-path stats updates do not bounce one global
  counter line across all threads.

Each shard runs [S3-FIFO](https://dl.acm.org/doi/10.1145/3600006.3613147)
(Yang, Zhang, Qiu, Yue, Rashmi, SOSP 2023). New entries land in a small
FIFO queue S (10% of the shard's capacity). Entries that prove popular
get promoted from S to a main FIFO queue M (the remaining 90%). Hashes of
entries that fell out of S without earning promotion live for a while in
a ghost queue G (sized like M, hashes only, no values). Each cached entry
carries a 2-bit frequency counter that saturates at 3 and is bumped with
a compare-and-swap until it saturates. After that the hot entry avoids the
CAS and the hit path is a relaxed load plus the per-shard stats update.

The counter is atomic because several readers can hit the same entry under
the shared shard read lock. Relaxed ordering is enough here because the
counter only guides eviction; it does not protect the table or queue
structure.

On a miss, the inserter takes the shard's write lock. If the key's hash
is in G (the entry was evicted recently and the caller came back for it),
the new entry goes straight into M. Otherwise it goes into S. Either way
the counter starts at 0. Insertion enforces the target queue capacity before
inserting, so S cannot grow past its probation size just because M still
has headroom.

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
if re-requested while still in G. A fixup sweep over many one-hit DNs is
therefore biased toward eviction from S/G instead of displacing the hot set
already resident in M.

The S3-FIFO paper reports that one-hit objects become much more common in the
short windows a bounded cache sees: median 26% over full traces, 72% in
10%-of-objects windows. memberOf updates, fixup tasks, and subtree scans have a
similar shape: many DNs are touched once, while a smaller set is reused.

A visualisation of the algorithm lives at <https://s3fifo.com>.

Alternatives Considered
-----------------------

Concread's [`ARCache`](https://github.com/kanidm/concread/blob/master/CACHE.md)
is the current backend. It is valuable when a cache needs transactional
reader/writer behavior. This proposal is narrower: the NDN value is
`normalize(key)`, and the benchmark section compares the current NDN path
against the S3-FIFO replacement. The Criterion section also includes an
isolated ARCache comparator as supporting data, so those results do not only
measure the current integration path.

[`moka`](https://crates.io/crates/moka) implements W-TinyLFU and reaches
higher hit ratios on some workloads. For NDN, a miss means recomputing a
normalized DN. This design therefore favors lower lookup cost, scan behavior,
and a smaller dependency surface over adding a larger general-purpose cache
dependency.

[SIEVE](https://www.usenix.org/conference/nsdi24/presentation/zhang-yazhuo)
(Zhang, Yang, Qiu, Vigfusson, Rashmi, NSDI 2024) comes from the same
research group as S3-FIFO and has a similar simplicity profile, but its
authors do not position it as scan-resistant in the same way as S3-FIFO, so
it is a less direct fit for the NDN-cache scan/fixup concern.

[`quick_cache`](https://crates.io/crates/quick_cache) implements a Clock-PRO
variant and would be a reasonable off-the-shelf option. The NDN cache only
needs the narrower behavior described above, so the in-tree S3-FIFO module
keeps the dependency set small while matching the workload.

Benchmarks
----------

The integration and server benchmarks are the primary evidence. Criterion
microbenchmarks are useful for isolating cache hot-path behavior, but they do
not model the full LDAP server path, plugin work, backend behavior, scheduler
effects, or operation-level contention.

End-to-end memberOf performance suite (`dirsrvtests/tests/perf/memberof_test.py`,
total pytest wall time):

```
backend     total
disabled    5440.96 s   (1:30:40)
concread    5569.46 s   (1:32:49)
s3fifo      4880.70 s   (1:21:20)
```

S3-FIFO finishes 12.4% sooner than the concread run on the same suite.

The recent multithreaded (on 16-vCPU VM) memberOf cascade run mainly tests
the steady-state lookup path and shard contention. The size sweep did not change
the direction of the result: across the small (4 MiB), fit (14.5 MiB), and
large (64 MiB) cache sizes, with 16, 32, and 64 threads, S3-FIFO stayed
about 11% to 13% ahead on ops/s, with lower p95 in the same runs.

The generated benchmark dataset was about 100,200 entries, or about 15 MiB
using the same 150~168-byte planning estimate (which is generous) as
the cache-size knob.

The enabled-cache rows reported a full NDN hit ratio, so this table is
mainly a warm-cache lookup-path comparison:

```
cache size        threads        ops/s vs concread             p95 vs concread
small (4 MiB)     16 / 32 / 64   +11.5% / +12.6% / +11.4%     -11.0% / -12.8% / -15.0%
fit (14.5 MiB)    16 / 32 / 64   +12.2% / +11.6% / +11.3%     -12.5% / -13.2% / -13.2%
large (64 MiB)    16 / 32 / 64   +12.7% / +11.8% / +12.7%     -12.8% / -12.4% / -12.7%
```

For p95, negative means lower latency.

The hot-DN server test is the weak server-level shape for hash sharding.
It is not a pure single-key cache benchmark; the measured run still had a small
stable cache working set. Across small, fit, and large at 16, 32, and 64
threads, S3-FIFO stayed within about 3.4% of concread either way:

```
cache size        threads        ops/s vs concread
small (4 MiB)     16 / 32 / 64   +1.1% / +3.4% / +2.3%
fit (14.5 MiB)    16 / 32 / 64   -3.1% / -0.9% / -0.3%
large (64 MiB)    16 / 32 / 64   -2.1% / +1.1% / +3.1%
```

The Criterion capacity sweep is supporting data for the cache hot path, not the
primary evidence. At 124,830 entries, which roughly corresponds to the 20 MiB default
using the 168-byte planning estimate, S3-FIFO remained ahead of the isolated
ARCache comparator on the threaded runs:

```
workload          threads 16 / 64   s3fifo vs isolated ARCache comparator
Zipf 1.3          16 / 64           6.62x / 6.15x
scan              16 / 64           7.52x / 4.77x
memberOf cascade  16 / 64           13.14x / 8.09x
```

Major Configuration Options and Enablement
------------------------------------------

The configuration stays the same. Only the implementation is changed.

| Attribute                    | Default              | Effect                                                                                                      |
| ---------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- |
| `nsslapd-ndn-cache-enabled`  | `on`                 | Turns the cache on or off. Restart required.                                                                |
| `nsslapd-ndn-cache-max-size` | `20971520` (20 MB)   | Maximum cache bytes. Converted to an entry count using a 168-byte per-entry estimate. Restart required.     |

The cache uses 64 shards. That is above the hardware thread count in the runs
above (16-vCPU VM, 14-core M4 Pro) and keeps shard metadata small. The shard
count is fixed in this design; the existing cache-size knob remains the only
product-facing sizing control.

Known Tradeoffs
---------------

The main tradeoff is the hot-DN case. A hot DN concentrates traffic on the same
shard, so that workload does not benefit from hash sharding as much as a
multi-DN workload does. The recent server data shows this as a bounded weak
case rather than a general failure: performance stays close to concread, but it
is not where S3-FIFO's sharding helps.

Another thing, S3-FIFO is not a zero-write read path. It records hits in
a small per-entry counter until the counter saturates, and lookup still
updates stats. The hot-DN and cascade server tests cover this case from two sides: concentrated reads stayed close to concread, and the multi-key memberOf cascade
stayed ahead across the tested cache sizes.

The known adversarial case is also clear: if many objects are accessed exactly
twice, and the second access arrives after the entry has fallen out of S and G,
S3-FIFO can miss where another policy may retain the object. For NDN, that risk
is bounded by recomputation cost and not that likely to happen as visible through
existing near 1.0 NDN hit ratio.

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
