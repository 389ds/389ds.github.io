---
title: "Performance diagnostic"
---

# Performance diagnostic
------------

{% include toc.md %}

## Introduction
------------

## Test considerations
------------

### Scenario 1: srch rate on 10K
------------

#### Server

Numa:

    cat /usr/lib/systemd/system/dirsrv@.service
    ...
    ExecStart=numactl  --cpunodebind=0 /usr/sbin/ns-slapd -D /etc/dirsrv/slapd-%i -i /run/dirsrv/slapd-%i.pid
    
    systemctl daemon-reload

Tuning:
10K database entry. entry/db 1G/400Mb. workers = 8.
client = --bindDN **'cn=Directory Manager'** --baseDN dc=example,dc=com --scope sub --filter '(uid=use[1-10000])' --attribute givenName --attribute sn --attribute mail --numThreads **30**

#### Client
Run client on another host else the server take all CPU and wait for clients

## structure contention
-------

### cache alignment of hot structure

Shared structures are structures (locks, counters,...) that are accessed by many threads. A shared structure becomes more and more hot when a CPU that access the structure has to retrieve it more and more frequently from another CPU that holds it in its cache.
A lock is usually a hot structure accessed from all CPU, it can create contention and this is normal. A lock is located into a CPU cache line, so a CPU needs to acquire to cache line that is located in another CPU (**HITM**). A problem is if the cache line contains **several hot structures**. In such case there is a **useless** extra contention on structure **A** due to false cacheline sharing with **B** not related to **A**. To prevent this behavior we should monitor *cache line* heat and **align** hot structure so that each of them fit into a dedicated cache line.

A tool to monitor cache line heat is **perf c2c**.

## server activity

### workqueue size

Monitoring the workqueue with 'cn=monitor' (-b "cn=monitor" -s base opsinitiated opscompleted readwaiters) is too impacting (locking the connections/conntable). Prefere

    gdb  -ex 'set confirm off' -ex 'set pagination off' -ex 'print work_q_size' -ex 'print work_q_size_max' -ex 'print *ops_initiated' -ex 'print *ops_completed' -ex 'quit' /usr/sbin/ns-slapd `pidof ns-slapd`


### pstack

pstack impacts a lot (almost stop) the server. It can be usefull if a thread is spending a lot of time in a same area of code

### cpudist

The tool shows how much time each tread is spending offcpu. Here the listener *38701* is pretty active but can sleep up to 255usec

    /usr/share/bcc/tools/cpudist -POL -p `pidof ns-slapd` 1 1
    
    tid = 38701 ns-slapd
    
         usecs               : count     distribution
             0 -> 1          : 837      |**                                      |
             2 -> 3          : 15145    |**************************************  |
             4 -> 7          : 15696    |****************************************|
             8 -> 15         : 12510    |*******************************         |
            16 -> 31         : 4895     |************                            |
            32 -> 63         : 1854     |****                                    |
            64 -> 127        : 0        |                                        |
           128 -> 255        : 16       |                                        |
    
    tid = 38756 ns-slapd
    
         usecs               : count     distribution
             0 -> 1          : 0        |                                        |
             2 -> 3          : 0        |                                        |
             4 -> 7          : 0        |                                        |
             8 -> 15         : 0        |                                        |
            16 -> 31         : 0        |                                        |
            32 -> 63         : 0        |                                        |
            64 -> 127        : 0        |                                        |
           128 -> 255        : 0        |                                        |
           256 -> 511        : 0        |                                        |
           512 -> 1023       : 0        |                                        |
          1024 -> 2047       : 198      |****************************************|
    

### What the server is doing

    perf top -t 65457 (for a worker)
    
    Samples: 486K of event 'cycles', 4000 Hz, Event count (approx.): 257233768218 lost: 0/0 drop: 0/0
    Overhead  Shared Object               Symbol
       2.84%  [kernel]                    [k] do_syscall_64
       2.50%  libslapd.so.0.1.0           [.] slapi_pblock_get
       2.09%  libpthread-2.28.so          [.] __pthread_mutex_lock
       2.08%  libdb-5.3.so                [.] __db_tas_mutex_lock
       1.43%  libdb-5.3.so                [.] __db_tas_mutex_unlock
       1.32%  libpthread-2.28.so          [.] __pthread_mutex_unlock_usercnt
       1.30%  libjemalloc.so.2            [.] free
       1.30%  libslapd.so.0.1.0           [.] attrlist_find
       1.25%  libslapd.so.0.1.0           [.] slapi_pblock_set
       1.08%  libc-2.28.so                [.] vfprintf
       1.06%  [kernel]                    [k] entry_SYSCALL_64
       1.03%  libslapd.so.0.1.0           [.] slapi_log_error
       0.99%  [kernel]                    [k] syscall_return_via_sysret
       0.94%  [kernel]                    [k] __fget

