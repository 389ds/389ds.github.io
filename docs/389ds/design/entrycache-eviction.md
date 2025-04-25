# Improving the entry cache eviction

## Why changing things ?

Computing the acl involving large groups is costly. So we had better keep them in the acl cache. Some of the reason are:

- creating acl cache for large group is costly a group is evicted out of the acl if its entry pointer changed. (i.e that the group was removed from the entry cache then reloaded)

- If values are not already sorted,  the time spent to sort the membership values is significant.

A way to improvie thing is to try to keep the large group entries in the entry cache as long as possible.

## How to change things ?

My first idea is to keep all entry whose loading time is higher than a configurable factor of the average loading time. (if the entry is long to load we want to try to keep it)
We can store (in the backentry) the time needed to compute an entry when reading it if not in the cache (and probably also when adding it in the cache too)
 (Simply by getting current time when getting the original backentry then
   just before replacing it.)
and compute statistics like the average time (by keeping the number of entry (which is already done) and the total time of all the entries that are in the cache)
and determine a threshold (tunable ?) about when we keep an entry in  the cache
IMHO a 100 or 1000 factor will do .
Comparing average time to entry time has an advantage:
big group entries get naturally evicted if too many of them are in the cache (because in such case, the average building time will then increase until some of the protected entry are no more protected from eviction)

But after the first tests I discovered that it is pretty hard to determine the right value for the threshold. So the idea evolved:
Still computing weight from the loading time in microseconds I still compute the average loading time because it is an interresting statistics in monitoring tools

There is no more any configurable threshold: it is replaced by a configurable number of entries.

Keeping a separate array of preserved entries is complicated and would imply to greatly modify he cache code (every time we add/remove an entry from the LRU we will also have to check if it is preserved and handle things differently

So the idea is to behaves as of now except when flushing the backentry from entrycache:

- Start to allocate a preserved entry array if is is not  already done

- Populate it with the first (i.e the newest) entries of the lru (and remove these entries from the lru)

- Sort the preserved entry array (lighest entry first)

- While cache is full, walk the lru from older to newer entry

  - if the entry weight is higer than the lightest entry in preserved array

    - Move back the lightest entry in preserved array to head of lru

    - Insert the current entry in the preserved array

      (hifting the entry before insertion slot from 1 slot)

    - continue walking the lru queue from previous entry

  - remove the entry from the cache

- While cache is full start to iterate on preserved entries from lighest to heaviest

  - move back the entry in lru then remove it from the cache

- Continue iterating on preserved entries until there is no more

  - move back the entry in lru

- Detach the removed entries from lru queue and return the list of removed entries
  With this algorythm we avoid the complexity and the cost of handling two lru queues
  when acquiring/releasing entries
  Prefetching the newest entries and putting the preserved entries back in the head of the queue ensures that entries in the queue are either the newest ones or the more costly. but there is still the cost of building the array which is n*log(n)

## Other remarks

* Should we propagate the time from old entry to new entry in cache\_replace ?
  It is a bit inaccurate (especillay if lots of values are added/removed) but it still better than nothing. Usually only a fezw members are added/deleted from a large group and propagating its weight would avoid to have to recompute it twice

## New config parameters

New parameters in the backend config entry

| Parameter                       | Type         | Default value | Description                                                                                                               |
|:------------------------------- |:------------ |:------------- |:------------------------------------------------------------------------------------------------------------------------- |
| nsslapd-cache-preserved-entries | Integer >= 0 | 10            | Number of entries that are preserved from eviction                                                                        |
| nsslapd-cache-debug-pattern     | String       | NULL          | Debug feature allowing to log INFO message when an entry whose dn matches the value is added/removed from the entry cache |

## Internal Data changes

| Struct         | field name               | Description                                                                                                                                                             |
|:-------------- |:------------------------ |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| backentry      | ep\_weight               | Entry weight (load time in microseconds)                                                                                                                                |
| cache          | weight(\*)(\**)          | Weight of all entries in the cache                                                                                                                                      |
| cache          | nehw(\*)                 | Number of entries having weight \> 0                                                                                                                                    |
| cache          | c\_stats(\*)             | cache\_stats statistics                                                                                                                                                 |
| cache          | c\_inst                  | ldbm\_instance struct (to access the config parameters)                                                                                                                 |
| ldbm\_instance | cache\_weight\_threshold | nsslapd-cache-weight-threshold value: Ratio used to determine which entries are preserved by the lru                                                                    |
| ldbm\_instance | cache\_debug\_pattern    | nsslapd-cache-debug-pattern  value (may be NULL): Regular expression used to log INFO messages in error log when adding/removing entries in cache (if their dn matches) |
| ldbm\_instance | cache\_debug\_re         | Compiled version of cache\_debug\_pattern                                                                                                                               |

(\*) All statistics fields of struct cache are moved in new cache\_stats struct

(\*\*) Using the generic word **weight** instead of loadingtime because its meaning may change

#### Entry Cache statistics

 struct cache_stats

| Field               | Description                               |
| ------------------- | ----------------------------------------- |
| uint64\_t hits      | for analysis of hits/misses               |
| uint64\_t tries     | for analysis of hits/misses               |
| uint64\_t nentries  | current \# entries in cache               |
| int64\_t maxentries | max entries allowed (-1: no limit)        |
| uint64\_t size      | current size in bytes                     |
| uint64\_t maxsize   | max size in bytes                         |
| uint64\_t weight    | Total weight of all entries               |
| uint64\_t nehw      | current \# entries having weight in cache |

## Impacted functions

Time is get using: clock\_gettime(CLOCK\_MONOTONIC, struct timespec \*tp)

| Function                                                                 | Impact                                                                                                                                                                                                                                                                                                                                                                                               |
|:------------------------------------------------------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id2entry                                                                 | compute time difference from start of function until the CACHE\_ADD callend of function and store it in the returned back-entry                                                                                                                                                                                                                                                                     |
| uint64\_t get\_time\_delta(struct timespec \* starttime, int multiplier) |                                                                                                                                                                                                                                                                                                                                                                                                      |
| entrycache\_add\_int                                                     | Add entry weight to cache total weight                                                                                                                                                                                                                                                                                                                                                               |
| entrycache\_replace                                                      | Propagate old entry weight to new entry                                                                                                                                                                                                                                                                                                                                                              |
| entrycache\_remove\_int                                                  | Remove entry weight to cache total weight                                                                                                                                                                                                                                                                                                                                                            |
| entrycache\_flush                                                        | Although the algorithm principle is the same, the function must be rewritten because the queue handling is different. Entries whose weight is above the limit are not removed so the invariant that all entries after the current one are removed from the cache is no longer true. Removed entries are now unlink from the lru queue and added in a freelist queue (that is returned to the caller) |
| cache\_init                                                              | should store the ldbminfo in the cache to retrieve the config parameter                                                                                                                                                                                                                                                                                                                              |

## Other impacts

Should improve the debug log and monitored data.

### debug log

* Adding the entry weight and cache average weight in existing debug messages
* On the other hand enabling these logs tends to defeat the feature because the time to log the messages is accounted for in the entry weight (so it flatten the result … ).
  But we definitely need some logs to test the feature.
  Will see if we can add a new parameters to log less data.
  Typically a regular expression to log the entry whose dn match when adding/removing them from the entry cache so we can know when group whose dn follow some pattern are loaded/unloaded from the cache

### monitoring

* Adding average load time (in microseconds)  in cn=monitor,...
* Group cache monitored statistics in a struct

## Potential futur improvment

### Preserving a definite numbers of entries

If we want to preserve a given number N of entries
A way to do that wolud be to build a preserved entry sorted array while flushing the entrycache
Keeping the N entries with the highest weight
If the cache is still full when hitting the head of the lru queue,
  then starts evicting entries in the preserved table (starting with the smaller weight)
then link the remainging preserved entries back to the head of the lru queue.
 so they will not be checked again soon.
Note: avoiding to preserve the array outside of the lock will simpplify things
 Otherwise keeping the table consistent when removing an entry will be a pain:
  if we do not accept the risk of evicting entries that are with higher weight than the preserved one,
  we will then have to search the whole LRU queue to find the entry with the highest weight
   (to put in in the preserved entries table)

This will probably be slower than the initial proposal (because of the cost of building the array)
but the behavior will be more predictibale (i.e. easier to describe to the customers)

### Using a compsite weight

Storing both the loading time and the number of members in the backentry
and using them to compute the weight

## Alternatives

| Alternative                                                        | Rejection reason                                                                                                                                                                                                                 |
|:------------------------------------------------------------------ |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Have 2 LRU lists                                                   | More complex than proposed implementation                                                                                                                                                                                        |
| Have  weight thrshold                                              | Tests shows that it pretty hard to determine the right value (even using a ratio from average entry weight)                                                                                                                      |
| Flags Large group entry                                            | Determining that we are handling a large group is not so easy and once again we will be in trouble if too many large group entries are stored in the cache                                                                       |
| Using getrusage(RUSAGE\_THREAD, \&usage) instead of clock\_gettime | Although it provides more accurate data, getrusage is 10 times more costly than clock\_gettime.                                                                                                                                  |
| Should we compute the variance and use it for the decision ?       | checking if w \> a+y\*v would allow to preserve x% of the entries but it seems an overhead especially since we need to compute a square root to do that. maybe checking w2 \> a2\+y\*v2 will do something but I am not convinced |
| Use the number of members as weight instead of the loading time.   | That is something to test. Anyway it should not change much the code (only the weight computation and the threshold default limit)                                                                                               |
