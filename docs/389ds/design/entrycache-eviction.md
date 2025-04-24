# Improving the entry cache eviction

## Why changing things ?

Computing the acl involving large groups is costly. So we had better keep them in the acl cache. One of the reason that could evict a group from the acl cache is that its entry pointer changed. (i.e that the group was removed from the entry cache then reloaded)
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

## Other remarks

* Should we propagate the time from old entry to new entry in cache\_replace ?   
  Even if it is not always accurate, it seems a good idea because it prevents to reload a big group after modifying it  
* Adding a configuration parameter for the weight threshold: nsslapd-cache-weight-threshold  
* After some test I realize that nsslapd-cache-weight-threshold should be pretty small  
  maybe 2 or 3 so IMHO it is better to express it in % and check it is bigger than 100\. And finally loading a group a 6K users is sometime only 1.5 more costly than loading users  
  That said, removing a group from the entry cache has an impact on the acl cache so it is still worth keeping it. I finally used a value of 1.5 
* That said seeing that loading a big group of 6000K users is only 1.5 or 2 time longer than an user entry, I start to change my mean and we may perhaps use the number of members as weight. In that case the monitoring data are not so meaningful (except to debug the feature)

## New config parameters

New parameters in the backend config entry

| Parameter                      | Type           | Default value | Description                                                                                                                            |
|:------------------------------ |:-------------- |:------------- |:-------------------------------------------------------------------------------------------------------------------------------------- |
| nsslapd-cache-weight-threshold | Integer \> 100 | 150           | Entries whose weight (i.e their loading time in micro seconds) is greater than value/100\*cache\_average\_weight are kept in the cache |
| nsslapd-cache-debug-pattern    | String         | NULL          | Debug feature allowing to log INFO message when an entry whose dn matches the value is added/removed from the entry cache              |

## Internal Data changes

| Struct         | field name               | Description                                                                                                                                                             |
|:-------------- |:------------------------ |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| backentry      | ep\_weight               | Entry weight (load time in microseconds)                                                                                                                                |
| cache          | weight(\*)(\**)          | Weight of all entries in the cache                                                                                                                                      |
| cache          | nehw(\*)                 | Number of entries having weight \> 0                                                                                                                                    |
| cache          | c\_stats(\*)             | cache\_stats statistics                                                                                                                                                 |
| cache          | c\_inst                  | ldbm\_instance struct (to access the config parameters)                                                                                                                 |
| ldbm\_instance | cache\_weight\_threshold | nsslapd-cache-weight-threshold value:Ratio used to determine which entries are preserved by the lru                                                                    |
| ldbm\_instance | cache\_debug\_pattern    | nsslapd-cache-debug-pattern  value (may be NULL):Regular expression used to log INFO messages in error log when adding/removing entries in cache (if their dn matches) |
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
| id2entry                                                                 | compute time difference from start of function until the CACHE\_ADD callend of function and store it in the returned back-entry                                                                                                                                                                                                                                                                     |
| uint64\_t get\_time\_delta(struct timespec \* starttime, int multiplier) |                                                                                                                                                                                                                                                                                                                                                                                                      |
| entrycache\_add\_int                                                     | Add entry weight to cache total weight                                                                                                                                                                                                                                                                                                                                                               |
| entrycache\_replace                                                      | Propagate old entry weight to new entry                                                                                                                                                                                                                                                                                                                                                              |
| entrycache\_remove\_int                                                  | Remove entry weight to cache total weight                                                                                                                                                                                                                                                                                                                                                            |
| entrycache\_flush                                                        | Although the algorithm principle is the same, the function must be rewritten because the queue handling is different.Entries whose weight is above the limit are not removed so the invariant that all entries after the current one are removed from the cache is no longer true. Removed entries are now unlink from the lru queue and added in a freelist queue (that is returned to the caller) |
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

* Adding weight and number of pages having weight and average load time in cn=monitor,...  
  ( For most administrators only the average weight is interesting but having the intermediary values may be useful (for example to determine the ratio of entries whose weight is set )  
* Group cache monitored statistics in a struct 

## Alternatives

| Alternative                                                        | Rejection reason                                                                                                                                                                                                                                                                                      |
|:------------------------------------------------------------------ |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Have 2 LRU lists                                                   | More complex than simply skipping some entries in the current LRU. May be more efficient if lots of entries are skipped. But determining if we have to free some of the large group entries may get difficult while there is nothing to do if we compare the entry building time to the average time |
| Flags Large group entry                                            | Determining that we are handling a large group is not so easy and once again we will be in trouble if too many large group entries are stored in the cache                                                                                                                                            |
| Using getrusage(RUSAGE\_THREAD, \&usage) instead of clock\_gettime | Although it provides more accurate data, getrusage is 10 times more costly than clock\_gettime.                                                                                                                                                                                                       |
| Should we compute the variance and use it for the decision ?       | checking if w \> a+y\*v would allow to preserve x% of the entries but it seems an overhead especially since we need to compute a square root to do that. maybe checking w2 \> a2\+y\*v2 will do something but I am not convinced …                                                                   |
| Use the number of members as weight instead of the loading time.   | That is something to test. Anyway it should not change much the code (only the weight computation and the threshold default limit)                                                                                                                                                                    |
