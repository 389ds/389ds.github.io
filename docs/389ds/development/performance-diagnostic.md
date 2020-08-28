---
title: "Performance diagnostic"
---

# Performance diagnostic
------------

{% include toc.md %}

## Introduction
------------


## structure contention
-------

### cache alignment of hot structure

Shared structures are structures (locks, counters,...) that are accessed by many threads. A shared structure becomes hot when a CPU that access the structure has to retrieve it from another CPU that hold it in its cache.
A lock is usually a hot structure accessed from all CPU, it can create contention and this is normal. A lock is located into a CPU cache line, so a CPU need to acquire to cache line that is located in another CPU (**HITM**). A problem is if the cache line contains **several hot structures**. In such case there is a **useless** extra contention on structure **A** due to false cacheline sharing with **B** not related to **A**. To prevent this behavior we should monitor *cache line* heat and **align** hot structure so that each of them fit into a dedicated cache line.




