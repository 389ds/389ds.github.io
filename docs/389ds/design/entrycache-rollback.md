---
title: "Improving entry cache rollback"
---

# Improving entry cache rollback

{% include toc.md %}

## Overview

When a backend transaction (betxn) plugin fails during an update operation, the server must
make sure that the entry cache and the DN cache do not keep any entry reflecting changes that
were rolled back in the database. Today this is done by `revert_cache()`, which flushes a
large part of the caches. This document describes how to make this rollback more precise and
cheaper, so that only the cache entries actually impacted by the failing operation are evicted
(or restored).

This work is a subpart of the wider transaction model redesign (aimed at better matching the
LMDB transaction model), but it is independent and can be implemented on its own.

## Current behavior

`revert_cache()` is called by `ldbm_back_add`, `ldbm_back_delete`, `ldbm_back_modify` and
`ldbm_back_modrdn` when a betxn callback fails, and only for the parent (top-level) operation:

- At the beginning of the parent operation, the current time is stored in `parent_time`
  (`parent_time = slapi_current_rel_time_hr()`).
- Every time an entry is inserted in a cache hash table (`add_hash()`), its `ep_create_time`
  is set to the current time.
- On betxn failure, `revert_cache(inst, &parent_time)` calls `flush_hash()` on the entry cache
  (id and dn hash tables) and on the DN cache. `flush_hash()` walks **all** the hash table
  slots and evicts every entry whose `ep_create_time` is greater or equal to `parent_time`
  (entries still referenced are flagged `ENTRY_STATE_INVALID` and removed when released).

Note that a betxn failure is not an exceptional case: for example the attribute uniqueness
plugin returning `LDAP_CONSTRAINT_VIOLATION` because of a duplicate value triggers it.

### Drawbacks

- Entries/DNs that are not impacted by the failing operation (nor by its associated plugins)
  may get evicted, typically entries read or modified by other operations running
  concurrently. Reloading them has a performance cost, which is especially high when the entry
  was pinned (see [Entry cache pinned entries](entrycache-pinned.html)): large groups are
  costly to load and their ACL cache data is lost.
- Entries/DNs that were only read by the failing operation (but not modified) are also
  evicted, which is not needed.
- Walking the whole cache to check the creation time is costly by itself (with the cache lock
  held), even when the operation did not change anything in the cache.
- Getting the high resolution time for each operation and each cache insertion is not free.

## First phase (planned work)

The first phase is limited to three changes that are cheap in terms of development cost and
clearly improve performance in some cases:

| Task | Description                                       | Benefit                                                                                                                                 | Cost                                                                         |
|:---- |:------------------------------------------------- |:--------------------------------------------------------------------------------------------------------------------------------------- |:---------------------------------------------------------------------------- |
| 1    | Skip the revert when there is nothing to revert   | Avoids the whole cache walk in some cases (typically attribute uniqueness rejecting the operation before any cache update)            | Negligible (basic flag handling)                                             |
| 2    | Ownership instead of start time                   | Only the entries changed (or loaded) by the failing operation get evicted                                                              | Similar or better than the current code (atomic increment vs getting time) |
| 3    | Revert the pinned entries instead of evicting them | Pinned entries (large groups) are costly to load in the cache and their ACL cache data is preserved                                   | Moderate (the number of pinned entries is small)                             |

Note that with these changes the whole cache is still walked when something has to be
reverted. Avoiding that walk is a [future improvement](#future-potential-improvements).

### Task 1: skip useless reverts

A thread-local boolean flags whether the current parent operation changed something in the
caches.

- New thread-local variable `cur_txn_modified` (boolean), reset when the parent operation
  starts.
- Set to true whenever an entry or DN is tagged with the current transaction tag (cache add,
  tentative add or replace done in the operation context).
- `revert_cache()` returns immediately, without walking the caches, if `cur_txn_modified` is
  false.

### Task 2: ownership instead of start time

Each cache entry is tagged with the identifier of the parent operation (the "transaction tag")
that added or replaced it, instead of relying on the time.

- New field `ep_owner` (`uint64_t`) in `struct backcommon`, and the matching field in
  `struct backentry` and `struct backdn` (the common part of these structs must stay
  identical).
- New global atomic counter used to generate the transaction tags, and thread-local
  `cur_txn_tag` variable.
- `ldbm_back_add`, `ldbm_back_delete`, `ldbm_back_modify` and `ldbm_back_modrdn`: for the
  parent operation, increment the counter and store the value in `cur_txn_tag` instead of
  computing `parent_time`. Nested (internal) operations run by the plugins in the same thread
  share the same tag. The tag (and the `cur_txn_modified` flag) is reset to 0 when the parent
  operation completes.
- `add_hash()` / cache add and replace functions set `ep_owner` from `cur_txn_tag` (0 for
  threads not running an update operation).
- `revert_cache()` / `flush_hash()` select the entries to evict by comparing `ep_owner` with
  the current tag instead of comparing `ep_create_time` with the start time.
  `ep_create_time` may then be removed if it has no other use.

Entries loaded from the database into the cache by the thread holding the write transaction
are tagged too, as they may reflect uncommitted changes done earlier in the same transaction.
Entries already present in the cache and only looked up are not tagged.

### Task 3: reverting the pinned entries

- When `cache_replace()` replaces a pinned entry in the context of an update operation, the old
  entry is kept (with a reference held so it cannot be freed) in a thread-local list
  (a bit like what `modify_unswitch_entries()` does, but generalized).
- On rollback, the entries of this list whose replacement is still owned by the current
  transaction are switched back (old entry put back in the cache and in the pinned list)
  instead of being evicted.
- On success (or once reverted), the references on the old entries are released and the list
  is cleared.

### Logging

Entries reverted or evicted by the rollback are logged using `LOGPATTERN` (i.e. when their DN
matches `nsslapd-cache-debug-pattern`), so that CI tests can check which entries were evicted.
The existing `SLAPI_LOG_CACHE` messages in `flush_hash()` are kept.

### Internal data changes

| Struct / scope        | Field / variable    | Description                                                                         |
|:--------------------- |:------------------- |:----------------------------------------------------------------------------------- |
| backcommon            | ep\_owner           | Transaction tag of the parent operation that added/replaced the entry (0: no owner) |
| backentry             | ep\_owner           | Same as backcommon (common part of the structs must stay identical)                 |
| backdn                | ep\_owner           | Same as backcommon                                                                  |
| global                | txn tag counter     | Atomic counter used to generate unique transaction tags                             |
| thread-local          | cur\_txn\_tag       | Tag of the parent update operation running in the thread (0 if none)                |
| thread-local          | cur\_txn\_modified  | True if the current parent operation changed something in the caches                |
| thread-local          | pinned revert list  | Old versions of the pinned entries replaced by the current parent operation         |

### Configuration changes

None.

### Test plan

#### Goals

The tests must prove two different things:

- **Correctness (non-regression):** after a betxn failure, no LDAP client (search, compare, later
  update, internal operation) ever sees data from the rolled back operation, through the entry
  cache (id and dn hash tables) or through the DN cache. These tests must pass with **both** the
  current code and the new code.
- **Precision (the improvement):** entries not impacted by the failing operation stay in the cache,
  pinned entries are reverted instead of evicted, and the cache walk is skipped when there is
  nothing to revert. Some of these tests are expected to **fail with the current code**, which
  shows that they really detect the improvement. Each test below is tagged *[both]* (passes before
  and after) or *[new]* (fails before the change).

All tests run with both the BDB and the LMDB backends (`NSSLAPD_DB_LIB=bdb` / `mdb`).

#### Observation tools

| What is checked                                  | How                                                                                                                                                                                     |
|:------------------------------------------------ |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Whether the cache was walked (Task 1)            | The existing `WARN - flush_hash - Upon BETXN callback failure, entry cache is flushed during` message. It must only be logged when a walk really happens.                                |
| Which entries were evicted or reverted           | `nsslapd-cache-debug-pattern` set on the test backend plus the new `LOGPATTERN` rollback messages (an evict message and a revert message, wording fixed in subtask C before writing the tests) and the existing `entrycache_add_int` / `entrycache_remove_int` / pinned add/remove `CACHE DEBUG` messages. |
| That an entry stayed in the cache                | Backend monitor (`cn=monitor,cn=<be>,cn=ldbm database`): `entrycachehits` / `entrycachetries` deltas around a base search on the entry, `currententrycachecount`, and the `dncache*` counters. No `entrycache_add_int` debug message for the entry on that search. |
| Data correctness                                 | Base searches / compares on the entries touched by the failing operation (old DN, new DN, attribute values, `memberOf`, `numSubordinates`, `entryrdn`-based lookups via one-level searches). |
| Reference leaks of the pinned revert list (Task 3) | `currententrycachecount` / `currententrycachesize` back to their initial values after the operations, and the suite run once in an ASAN build (no leak, no use after free).            |

To make every eviction caused by the rollback, and not by the LRU, the test backend's entry cache
is sized so that it holds all the test entries (`nsslapd-cache-autosize: 0`, large
`nsslapd-cachememsize` / `nsslapd-cachesize`), except in the pinned entry tests, which reuse the
setup of `features/entrycache_eviction_test.py` (large groups, `nsslapd-cache-pinned-entries`).

#### How to make a betxn plugin fail

| Failure point                          | Trigger                                                                                                                                                                                 | Cache state when it fails                          |
|:-------------------------------------- |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |:-------------------------------------------------- |
| betxn **pre**-op, MODIFY               | Attribute uniqueness plugin on a non-RDN attribute (`employeeNumber` duplicate) returns `LDAP_CONSTRAINT_VIOLATION`                                                                     | Nothing changed yet (Task 1 skip expected)         |
| betxn **pre**-op, ADD / MODRDN         | Same, on an ADD (MODRDN behaves the same way)                                                                                                                                           | Tentative entry already added by `cache_add_tentative` (before the betxn pre-op plugins in `ldbm_back_add` and `ldbm_back_modrdn`), so a walk is still expected |
| betxn **post**-op, ADD / MODIFY / MODRDN | memberOf with `memberOfAutoAddOC: account` and a member entry that cannot hold `memberOf` (as in `betxns/betxn_test.py::test_revert_cache`) returns `OBJECT_CLASS_VIOLATION`         | Parent entry replaced/added, nested updates already done |
| betxn **post**-op, DELETE              | Referential integrity (betxn) configured on `aliasedObjectName`: deleting an entry referenced by an `alias` entry makes the nested modify remove a MUST attribute (`member` cannot be used: it is MAY in 389's `groupOfNames`) | Tombstone/parent replaced, nested updates possible |

A small dedicated test plugin (betxn pre/post op failing when the target entry has a given
`description` value) would give full control over the failure point and the nested operations.
It is optional: it needs build and packaging work, because the sample plugins under
`ldap/servers/slapd/test-plugins/` are not built today.

#### Test cases

New test module `dirsrvtests/tests/suites/features/entrycache_rollback_test.py` (tier1), plus the
existing `betxns/betxn_test.py` suite. All the log patterns, error codes and failure triggers the
tests depend on are module variables (`FLUSH_WARN_LOG`, `CACHE_ADD_LOG`, `ROLLBACK_EVICT_LOG`,
`ROLLBACK_REVERT_LOG`, `UNIQUE_ATTR`, `MEMBEROF_AUTOADDOC`, `REFERINT_ATTR`, ...) so they can be
adapted when the code changes; setting `ROLLBACK_EVICT_LOG` / `ROLLBACK_REVERT_LOG` to `None`
skips the checks of the new rollback messages. Cases 1.2, 1.4, 1.6 and 2.10 have no new test:
1.2 behaves like 1.3 (tentative add before the pre-op plugins), and 1.4, 1.6 and 2.10 are already
covered by `betxns/betxn_test.py` (`test_revert_cache`, `test_revert_cache_noloop`).

**Task 1: skip useless reverts**

| #   | Test                                         | Steps                                                                                                                                         | Expected result                                                                                                  |
|:--- |:-------------------------------------------- |:--------------------------------------------------------------------------------------------------------------------------------------------- |:---------------------------------------------------------------------------------------------------------------- |
| 1.1 | MODIFY rejected by uniqueness *[new]*        | Uniqueness on `employeeNumber`, create two users, modify user2 to use user1's value                                                                   | `CONSTRAINT_VIOLATION`; no `flush_hash` WARN; user1/user2 still cache hits                                       |
| 1.2 | MODRDN rejected by uniqueness *[both]*       | Uniqueness on the RDN attribute, rename user2 to `uid=user1` in another subtree in the uniqueness scope                                       | `CONSTRAINT_VIOLATION`; a walk is still expected (tentative add); not automated, same as 1.3                     |
| 1.3 | ADD rejected by uniqueness *[both]*          | Add an entry with a duplicate `uid`                                                                                                           | `CONSTRAINT_VIOLATION`; the walk happens (tentative entry); the entry is not in the cache: a base search returns `NO_SUCH_OBJECT` and adding it again with a unique uid succeeds |
| 1.4 | Plain error, not a betxn failure *[both]*    | Schema violation (as in `test_revert_cache` step 3)                                                                                           | No `flush_hash` WARN (revert_cache not called at all)                                                            |
| 1.5 | Flag reset between operations *[new]*        | `nsslapd-threadnumber: 1` (all operations on the same worker thread): successful modify, then test 1.1 again                                   | No `flush_hash` WARN for the failing operation (the flag set by the successful operation was reset)             |
| 1.6 | Post-op failure still walks *[both]*         | memberOf failure (`test_revert_cache`)                                                                                                        | `flush_hash` WARN is logged; the group does not hold the new member                                              |

**Task 2: ownership**

| #   | Test                                                   | Steps                                                                                                                                                                                                                     | Expected result                                                                                                                          |
|:--- |:------------------------------------------------------ |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |:---------------------------------------------------------------------------------------------------------------------------------------- |
| 2.1 | MODIFY rollback correctness *[both]*                   | memberOf failure on a group MODIFY adding a member                                                                                                                                                                        | The group has its old `member` values; the debug log shows the group evicted (or reverted if pinned)                                    |
| 2.2 | Nested operations share the tag *[both]*               | Group MODIFY adding member A (memberOf can be added, the nested modify succeeds) then member B (fails). Check member ordering so that A is processed first                                                                  | A has no `memberOf` value for the group (the nested change done by the same thread was evicted); the group is unchanged               |
| 2.3 | ADD rollback correctness *[both]*                      | ADD a group whose member cannot hold `memberOf`                                                                                                                                                                           | `OBJECT_CLASS_VIOLATION`; the group DN gives `NO_SUCH_OBJECT` (entry cache and DN cache); the parent's `numSubordinates` is unchanged; adding the group again after fixing the member succeeds |
| 2.4 | MODRDN rollback correctness *[both]*                   | Rename a member of a group with the memberOf failure (`test_betxn_modrdn_memberof_cache_corruption` scenario), also with a new superior                                                                                    | Old DN found, new DN `NO_SUCH_OBJECT`, `numSubordinates` of both parents unchanged, one-level searches under both parents correct       |
| 2.5 | Subtree MODRDN rollback (DN cache) *[both]*            | Rename an OU holding several children, failing in a betxn post-op                                                                                                                                                         | Children found with their old DNs, none with the new DNs (the DN cache entries of the children are evicted)                             |
| 2.6 | DELETE rollback correctness *[both]*                   | DELETE failing through referint (see trigger table)                                                                                                                                                                       | Entry still found with all its attributes; no tombstone visible; the parent's `numSubordinates` is unchanged                           |
| 2.7 | Entries only read by the failing op *[both]*           | Load entry R in the cache (base search). Failing operation whose plugins read R (for example R is a group containing the member, read by memberOf)                                                                         | R is not evicted (no evict message, cache hit on next search)                                                                           |
| 2.8 | Concurrent readers are not evicted *[new]*             | Entries under `ou=readers` match the debug pattern and are **not** in the cache. Thread 1 loops on failing updates on another subtree. Thread 2 does base searches on `ou=readers` entries (each loads one entry). Run long enough to overlap (for example 200 failures) | No `entrycache_remove_int` / evict message for any `ou=readers` entry. With the current code some are evicted, so the test is *[new]* (it may need several runs or a larger set of reader entries to fail reliably before the change) |
| 2.9 | Concurrent writers are not evicted *[new]*             | Same as 2.8 but thread 2 does successful modifies on `ou=readers` entries                                                                                                                                                 | Their entries are not evicted by the other thread's rollback, and they have their new values                                            |
| 2.10 | Concurrent update of a rolled back entry *[both]*     | `test_revert_cache_noloop`                                                                                                                                                                                                | Unchanged behavior (`cache_is_reverted_entry` still detected, no infinite retry loop)                                                   |
| 2.11 | Nested update in another backend *[both]*             | Failing operation whose plugin updates an entry in a second backend (memberOf with a scope spanning two backends, or the retro changelog)                                                                                    | Same behavior as today; document the result (`revert_cache()` only reverts the caches of the instance of the parent operation)        |
| 2.12 | Non-update threads (tag 0) *[both]*                    | Entries loaded by searches, by tasks (for example memberOf fixup), by replication and by import/reindex, then a failing operation                                                                                         | None of them are evicted by the rollback                                                                                                 |

**Task 3: reverting pinned entries**

Setup: large groups pinned in the cache as in `entrycache_eviction_test.py`
(`nsslapd-cache-pinned-entries` > 0, debug pattern on `ou=groups`).

| #   | Test                                              | Steps                                                                                                                                      | Expected result                                                                                                                                                        |
|:--- |:------------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 3.1 | Pinned group reverted *[new]*                     | Load the groups (pinned). MODIFY a pinned group adding a member that triggers the memberOf failure                                         | Revert message for the group, no `Removing entry ... from pinned entries`; the next base search on the group is a cache hit (no `entrycache_add_int`) and returns the old member list |
| 3.2 | Pinned group modified twice in one operation *[new]* | Failing parent operation that modifies the pinned group and whose nested operation modifies it again (for example a member rename where referint updates the group, then a later plugin fails; or the test plugin) | The **original** version is put back (neither of the intermediate versions)                                                                                            |
| 3.3 | Replacement no longer owned *[both]*              | While the failing operation runs, the replaced pinned entry gets evicted or replaced again (concurrent thread, or a cache size reduction)    | The old entry is not switched back; no crash; the pinned list and the LRU stay consistent (`pinned_verify` in a debug build)                                           |
| 3.4 | Success path releases the list *[both]*           | 1000 successful modifies of pinned groups                                                                                                  | `currententrycachecount` / size stable; no leak in the ASAN run; groups still pinned                                                                                   |
| 3.5 | Pinned entry deleted / renamed then rolled back *[new]* | Failing DELETE and failing MODRDN of a pinned group                                                                                  | The group is back in the pinned list with its old DN and content                                                                                                       |
| 3.6 | Unpinned entry, same operation *[both]*           | One failing operation that modifies both a pinned group and a normal entry                                                                 | Group reverted, normal entry evicted                                                                                                                                   |

**Robustness and existing tests**

- Run unchanged, with both backends: `betxns/betxn_test.py`, `features/entrycache_eviction_test.py`,
  `memberof_plugin/`, `plugins/referint_test.py`, `plugins/attruniq_test.py`, `automember_plugin/`,
  `mep_plugin/`, `replication/conflict_resolve_test.py` and `replication/acceptance_test.py`
  (replication URP uses nested internal operations and a known cache corruption once showed up in
  this area).
- Run the new module in an ASAN build (refcounts of the pinned revert list, no use after free of
  entries flagged `ENTRY_STATE_INVALID`).
- Run the concurrency tests (2.8, 2.9, 3.3) in a loop (for example 20 times) to catch races.

**Performance (manual, not in CI)**

- Workload with many uniqueness rejections on MODIFY (`ldclt` or a Python loop) against a backend
  with a large, full entry cache: throughput and the `flush_hash` etime before and after (Task 1).
- Mixed workload with periodic post-op failures and concurrent searches: entry cache hit ratio
  before and after (Task 2), and the reload count of the large groups (Task 3).
- Check that successful updates are not slower (atomic counter instead of
  `slapi_current_rel_time_hr()`).

## Future potential improvements

The following improvements were considered but their benefit is more dubious compared to their
cost. They are postponed until a need for them is found, and could be implemented in that
order.

### Tracking the changes in a journal

Avoids walking the whole cache when reverting. Keep, per parent operation, a journal of the
cache changes: type (entry or DN), old entry, and key (entry id or DN). The journal pointer is
stored in a thread-local variable.

Impacted functions:

| Function              | Action                                                                                                                 |
|:--------------------- |:---------------------------------------------------------------------------------------------------------------------- |
| cache\_add\_tentative | Log the change in the journal (no old entry) and set ownership on the new entry                                        |
| cache\_add            | Log the change in the journal (no old entry) and set ownership on the new entry                                        |
| cache\_replace        | Log the change in the journal with the old entry and set ownership on the new entry                                    |
| revert\_cache         | Walk the journal, look up the associated cache entry, check that the ownership still matches, then evict or revert it |

Points to take into account:

- Pointers to cache entries cannot easily be kept in the journal because the entries may have
  been evicted/replaced in the meantime, leaving dangling pointers. Hence the lookup by key and
  the ownership double check.
- Managing the journal must not cost more than walking the whole cache. A limited journal size
  seems reasonable (falling back to the full walk if the journal overflows).

### Reverting all modified entries

Generalize task 3 to all entries: keep the old entry pointer for every `cache_replace()` and put
the old entry back in the cache on rollback instead of evicting the new one.

### Thread-private cache for updated entries

Entries modified during a write transaction are read from the common cache and written into a
private cache only visible from the thread holding the write transaction. That thread first
looks up its private cache, then falls back to the common cache. On abort the private cache is
simply freed; on commit it is flushed into the common cache just before committing (the list of
flushed entries must be kept to revert them if the flush or the commit fails).

## Related documents

- [Entry cache pinned entries - limit large groups eviction](entrycache-pinned.html)
- [Cache Redesign](cache_redesign.html)

## Author

<progier@redhat.com>
