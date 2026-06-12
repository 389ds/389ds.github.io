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
The shard index comes from the middle bits of the key's hash, which leaves the
low bits free for hashbrown's bucket index and the high bits for its SIMD tag.
The shard struct is padded to 128 bytes so neighbouring locks do not share
a cache line. Layout:

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
the steady-state lookup path and shard contention. Four variants ran
back-to-back on one VM and one build: cache disabled, concread as shipped,
concread with quiesce tuning (reader quiesce off, a dedicated quiesce
thread, a shorter look-back), and S3-FIFO. The size sweep did not change
the direction of the result: across the small (1.05 MB), fit (1.55 MB), and
large (6.87 MB) cache sizes, with 16, 32, and 64 threads, S3-FIFO stayed
about 12% to 21% ahead on ops/s, with lower p95 in the same runs.

The generated benchmark dataset was about 10,220 entries, or about 1.7 MB
using the same 150~168-byte planning estimate (which is generous) as
the cache-size knob.

The enabled-cache rows reported a full NDN hit ratio, so this table is
mainly a warm-cache lookup-path comparison:

```
cache size        threads        ops/s vs concread             p95 vs concread
small (1.05 MB)   16 / 32 / 64   +12.8% / +13.6% / +11.7%     -13.9% / -14.0% / -11.7%
fit (1.55 MB)     16 / 32 / 64   +16.8% / +15.1% / +18.4%     -36.1% / -14.3% / -18.1%
large (6.87 MB)   16 / 32 / 64   +14.3% / +21.0% / +13.5%     -28.6% / -16.0% / -11.7%
```

For p95, negative means lower latency. In every cell the slowest S3-FIFO
repetition beats the fastest concread repetition. S3-FIFO also beats the
cache-disabled baseline in all nine cells; concread is slower than no cache
in eight of nine. The quiesce-tuned concread stays inside the as-shipped
concread's spread on this workload.

The hot-DN server test is the weak server-level shape for hash sharding.
It is not a pure single-key cache benchmark; the measured run still had a small
stable cache working set. Across small, fit, and large at 16, 32, and 64
threads:

```
cache size        threads        ops/s vs concread
small (1.05 MB)   16 / 32 / 64   -1.1% / -14.2% / -5.2%
fit (1.55 MB)     16 / 32 / 64   -0.2% / -2.9% / -2.1%
large (6.87 MB)   16 / 32 / 64   -6.3% / -2.0% / +4.6%
```

Per-rep spread on this test reaches 12-15%, so most cells overlap. The
-14.2% cell is the noisiest one: concread's five reps span 904 to 1049
ops/s against S3-FIFO's 847 to 966, so the medians exaggerate a gap the
distributions mostly share. The cache-disabled baseline lands in the same
band as both caches, so this stays a bounded weak case rather than a clear
win or loss.

The Criterion capacity sweep is supporting data for the cache hot path, not the
primary evidence. At 124,830 entries, which roughly corresponds to the 20 MiB default
using the 168-byte planning estimate, S3-FIFO remained ahead of the isolated
ARCache comparator on the threaded runs.

```
workload          threads 16 / 64   s3fifo vs isolated ARCache comparator
Zipf 1.3          16 / 64           2.96x / 2.27x
scan              16 / 64           11.95x / 5.52x
memberOf cascade  16 / 64           18.10x / 7.59x
```

Applying the quiesce tuning to the comparator helps it but does not change
the ordering: S3-FIFO stays 2.1x to 11.3x ahead on the same cells.
One-thread runs narrow the gap further, and the tuned comparator can edge
ahead under single-threaded eviction pressure and on a single-hot-key
microbenchmark; the threaded multi-DN shapes above are the NDN target case.

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
