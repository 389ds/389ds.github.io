---
title: "Improving the entry cache eviction"
---

# Improving the entry cache eviction

{% include toc.md %}

## Why changing things ?

Computing the acl involving large groups is costly. So we had better keep them in the acl cache. Some of the reason are:

- creating acl cache for large group is costly a group is evicted out of the acl if its entry pointer changed. (i.e that the group was removed from the entry cache then reloaded)

- If values are not already sorted, the time spent to sort the membership values is significant.

A way to improvie thing is to try to keep the large group entries in the entry cache as long as possible.

## Changes

- The main idea is to add a list holding a configured number of entries having the highest weight (based upon load time and group size)
  that pin the entries instead of storing them in the LRU where they could be evicted.
- Handling a new flag in the entries for PINNED entries to avoid looking in pinned entries list for not pinned entries
- Refactor the monitoring data to use a struct instead of lots of paramaters
- Expose average entry load time (in microseconds) and pinned-entry metrics in cache monitoring output.

## New config parameters

New parameters in the backend config entry

| Parameter                       | Type         | Default value | Description                                                                                                               | Comments                                                                                                  |
|:------------------------------- |:------------ |:------------- |:------------------------------------------------------------------------------------------------------------------------- |:--------------------------------------------------------------------------------------------------------- |
| nsslapd-cache-preserved-entries | Integer >= 0 | 10            | Number of entries that are preserved from eviction                                                                        | Should stay reasonably small because pinned entries consume memory that cannot be used for something else |
| nsslapd-cache-debug-pattern     | String       | NULL          | Debug feature allowing to log INFO message when an entry whose dn matches the value is added/removed from the entry cache | Intended for the CI tests and not really usefull for the users                                            |

## Internal Data changes

| Struct         | field name                | Description                                                                                                                                                             |
|:-------------- |:------------------------- |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| backentry      | ep\_weight                | Entry weight (load time in microseconds)                                                                                                                                |
| cache          | c\_stats(\*)              | cache\_stats statistics                                                                                                                                                 |
| cache          | c\_lrus[2]                | LRU queues anchor                                                                                                                                                       |
| cache          | c\_inst                   | ldbm\_instance struct (to access the config parameters)                                                                                                                 |
| ldbm\_instance | cache\_preserved\_entries | number of entries to preserve                                                                                                                                           |
| ldbm\_instance | cache\_debug\_pattern     | nsslapd-cache-debug-pattern  value (may be NULL): Regular expression used to log INFO messages in error log when adding/removing entries in cache (if their dn matches) |
| ldbm\_instance | cache\_debug\_re          | Compiled version of cache\_debug\_pattern                                                                                                                               |

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

## Test

dirsrvtests/tests/suites/features/entrycache_eviction_test.py verifying pinned-entry caching and eviction thresholds.

## Alternatives

### Alternatives rejected after testing them

These alternatives have been implemented and rejected because of the tests results:

#### LRU eviction algorithm version 1

##### Implementation

Entry weight is the elapsed time (in microseconds) while loading the entry in the cache.
Have a configurable factor
While evicting the entries from the cache keep all entry whose loading time is higher than the configurable factor multiplied by the average loading time. (The idea behind that is that if the entry is long to load we want to try to keep it)
We can store (in the backentry) the time needed to compute an entry when reading it if not in the cache (and probably also when adding it in the cache too)
(Simply by getting current time when getting the original backentry then just before replacing it.) and compute statistics like the average time (by keeping the number of entry (which is already done) and the total time of all the entries that are in the cache) and determine a threshold (tunable ?) about when we keep an entry in the cache
IMHO a 100 or 1000 factor will do .
Comparing average time to entry time has an advantage: big group entries get naturally evicted if too many of them are in the cache (because in such case, the average building time will then increase until some of the protected entry are no more protected from eviction)

##### Rejection cause:

But after the first tests I discovered that it is pretty hard to determine the right value for the threshold to get reliable results. The value is between 1.2 and 1.5

#### LRU eviction algorithm version 2

##### Implementation

While evicting the entries:

- build an array of preserved entries.
  
  - Taking the first n entries in LRU queue walking the LRU queue from its head.
  - Sorting them

- while walking the entry to evict (stating from the queue tail):
  
  - insert the costly entry in the array if neeeded.
    At the end put back the remainding entries in the head of LRU (which tend to sort the LRU queue by putting the hight weight around the head (and avoid trying to evict them)
    
    ##### Rejection reason
    
    Behavior is more predictable than first version but moving the entries has some drawback:

- some entries that should be eveicted are no more evicted (i.e in practice more than n entries get preserved
  
  #### Weight computation version 1
  
  ##### Implementation
  
  My first trials were done using the elapsed time while loading the entry in micro seconds as weight
  
  ##### Rejection reason
  
  Noise caused by the cpu context switch makes too many regular entry having higher load time than the large groups
  
  ### Alternatives considered but rejected
  
  Some other alternatives has been rejected without being impmlemented
  
  ##### Use a flag instead of a weight
  
  ##### Implementation
  
  Having a flag for large groups in the backentry and simply skip them.
  
  ##### Rejection reason
  
  Cannot prioritize which group will be preserved (between two large groups) and could get in trouble if there are two many large groups. (no more spaces for regular entries)
  
  #### Using getrusage instead of clock_gettime
  
  ##### Implementation
  
  Using getrusage(RUSAGE\_THREAD, \&usage) instead of clock\_gettime
  
  ##### Rejection reason
  
  Although it provides more accurate data and limit the cpu context switch noise, getrusage is 10 times more costly than clock\_gettime.
  
  #### Using weight variance to decide if evicting the entry
  
  ##### Implementation
  
  checking if w \> a+y\*v would allow to preserve x% of the entries
  
  ##### Rejection reason
  
  it seems an overhead especially since we need to compute a square root to do that. maybe checking w2 \> a2\+y\*v2 will do something but I am not convinced
  
  #### Using number of members as weight
  
  ##### Implementation
  
  Use the number of members as weight instead of the loading time.
  
  ##### Rejection reason
  
  We may perhaps also preserve some other complex entries

#### Pinning group entries by their dn

##### Implementation

  Have a parameter holding a list of DN and never put the entries having these dn 
  in the LRU (or skip these DN while evicting entries)

##### Rejection reason

- Comparing DNs may slow things especially if the list contains more than a few dns
- Admin have to explicitly specifies the groups list

#### Handling pinned entries within the LRU

##### Implementation

Embedding the handling of the pinned entries within the LRU code as originally intented

##### Rejection reason

Would make more difficult the replacement of LRU by something more efficient like ARC
