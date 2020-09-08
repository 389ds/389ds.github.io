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

Shared structures are structures (locks, counters,...) that are accessed by many threads. A shared structure becomes more and more hot when a CPU that access the structure has to retrieve it more and more frequently from another CPU that **modified** it in its cache.
A lock is usually a hot structure accessed from all CPU, it can create contention and this is normal. A lock is located into a CPU cache line, so a CPU needs to acquire to cache line that is located in another CPU (**HITM**). A problem is if the cache line contains **several hot structures**. In such case there is a **useless** extra contention on structure **A** due to false cacheline sharing with **B** not related to **A**. To prevent this behavior we should monitor *cache line* heat and **align** hot structure so that each of them fit into a dedicated cache line.

A tool to monitor cache line heat is **perf c2c**.

    perf c2c record --call-graph dwarf -p `pidof ns-slapd` -o perf_call_c2c # after 4-5sec key ^C
    perf c2c report -i perf_call_c2c --stdio > perf_call_c2c.rep
    
    vi perf_call_c2c.rep
    
    =================================================
               Shared Data Cache Line Table
    =================================================
    #
    #        ----------- Cacheline ----------    Total      Tot  ----- LLC Load Hitm -----  ---- Store Reference ----  --- Load Dram ----      LLC    Total  ----- Core Load Hit -----  -- LLC Load Hit --
    # Index             Address  Node  PA cnt  records     Hitm    Total      Lcl      Rmt    Total    L1Hit   L1Miss       Lcl       Rmt  Ld Miss    Loads       FB       L1       L2       Llc       Rmt
    # .....  ..................  ....  ......  .......  .......  .......  .......  .......  .......  .......  .......  ........  ........  .......  .......  .......  .......  .......  ........  ........
    #
          0      0x7fa6882e1f80     0    1624     4789    6.50%      648      648        0     1211      667      544         0         0        0     3578     2380      125        1       424         0
                 #
                 # database mutex: __db_tas_mutex_lock
                 #
          1      0x7fa69aa23340     0    1464     2331    4.33%      432      432        0      582      582        0         0         0        0     1749      695      503        1       118         0
                 #
                 # 389DS plugins global lock
                 #
          2      0x7fa69aaf5480     0    3237     4606    3.84%      383      383        0     1076     1053       23         0         0        0     3530     1828     1164        0       155         0
                 #
                 # 389DS entrycache lock
                 #
          3      0x7fa6882e1440     0     743     1682    1.85%      185      185        0      686      540      146         0         0        0      996      721       32        0        58         0
                 #
                 # database mutex: __db_tas_mutex_lock
                 #
          4      0x7fa69aaf5500     0     395     1042    1.81%      181      181        0      361      356        5         0         0        0      681       30      428        0        42         0
                 #
                 # 389DS entrycache lock
                 #
          5      0x7fa6882e1f40     0     586     2732    1.54%      154      154        0     1570     1553       17         0         0        0     1162        0      969        0        39         0
                 #
                 # database mutex: __db_tas_mutex_lock
                 #
          6      0x7fa65d462140     0      87      175    1.51%      151      151        0       10        5        5         0         0        0      165        1        0        0        13         0
                 #
                 # database cursor: __db_cursor_int
                 #
          7      0x7fa669c722c0     0       1      431    1.49%      149      149        0      275      128      147         0         0        0      156        1        2        0         4         0
                 #
                 # database memory pool: _memp_fput
                 #
          8      0x7fa669c72200     0     172      329    1.44%      144      144        0        8        8        0         0         0        0      321      163        7        0         7         0
                 #
                 # database memory pool: _memp_fget
                 #
          9      0x7fa695ad9c00     0     740     1243    1.34%      134      134        0      318      318        0         0         0        0      925      449      295        1        46         0
                 #
                 # 389 VLV index
                 #
    


## host activity

Those are examples of commands to monitor the activity at the host level

### perf top

Under heavy SRCH load, the servers shows high syscalls rate (futex): <b>perf top -g -d 10</b>

    Samples: 2M of event 'cycles', 4000 Hz, Event count (approx.): 496734082490 lost: 0/0 drop: 0/0
      Children      Self  Shared Object               Symbol
    -   22.15%     0.27%  [kernel]                    [k] entry_SYSCALL_64_after_hwframe                                                                                                        ◆
       - 21.89% entry_SYSCALL_64_after_hwframe                                                                                                                                                  ▒
          - do_syscall_64                                                                                                                                                                       ▒
             + 4.15% __x64_sys_futex                                                                                                                                                            ▒
             + 3.83% __x64_sys_setsockopt                                                                                                                                                       ▒
             + 3.60% __x64_sys_poll                                                                                                                                                             ▒
             + 2.77% __x64_sys_sendto                                                                                                                                                           ▒
             + 1.88% ksys_write                                                                                                                                                                 ▒
             + 1.24% __x64_sys_recvfrom                                                                                                                                                         ▒
             + 0.70% syscall_slow_exit_work                                                                                                                                                     ▒
    -   21.89%     2.93%  [kernel]                    [k] do_syscall_64                                                                                                                         ▒
       - 18.96% do_syscall_64                                                                                                                                                                   ▒
          + 4.15% __x64_sys_futex                                                                                                                                                               ▒
          + 3.83% __x64_sys_setsockopt                                                                                                                                                          ▒
          + 3.60% __x64_sys_poll                                                                                                                                                                ▒
          + 2.77% __x64_sys_sendto                                                                                                                                                              ▒
          + 1.88% ksys_write                                                                                                                                                                    ▒
          + 1.24% __x64_sys_recvfrom                                                                                                                                                            ▒
          + 0.69% syscall_slow_exit_work                                                                                                                                                        ▒
       - 0.52% __poll
    +    4.93%     0.08%  libc-2.28.so                       [.] __poll                                                                                                                         ▒
    +    4.79%     0.06%  libc-2.28.so                       [.] __GI___setsockopt                                                                                                              ▒
    +    4.75%     4.60%  libdb-5.3.so                       [.] __db_tas_mutex_lock                                                                                                            ▒
    +    4.19%     0.02%  perf                               [.] hist_entry_iter__add                                                                                                           ▒
    +    4.14%     0.13%  [kernel]                           [k] __x64_sys_futex                                                                                                                ▒
    +    4.01%     0.14%  [kernel]                           [k] do_idle                                                                                                                        ▒
    +    4.00%     0.14%  [kernel]                           [k] do_futex                                                                                                                       ▒
    +    3.82%     0.00%  [unknown]                          [.] 0000000000000000                                                                                                               ▒
    +    3.79%     0.03%  [kernel]                           [k] __x64_sys_setsockopt                                                                                                           ▒
    +    3.76%     0.05%  [kernel]                           [k] __sys_setsockopt                                                                                                               ▒
    +    3.64%     0.05%  libpthread-2.28.so                 [.] __libc_send                                                                                                                    ▒
    +    3.57%     0.25%  libpthread-2.28.so                 [.] pthread_cond_signal@@GLIBC_2.3.2                                                                                               ▒
    +    3.56%     0.08%  [kernel]                           [k] __x64_sys_poll

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
    
### Trace the DS worker syscalls

After selecting a worker LWP (using pstack), you may trace (for 3-4 sec) the syscalls done by the thread

     Summary of events:

     ns-slapd (108026), 1784094 events, 100.0%

       syscall            calls    total       min       avg       max      stddev
                                   (msec)    (msec)    (msec)    (msec)        (%)
       --------------- -------- --------- --------- --------- ---------     ------
       futex             328704  3054.546     0.000     0.009   346.687     17.23%
       setsockopt        124702   656.760     0.001     0.005     0.034      0.14%
       poll              125437   655.709     0.002     0.005   100.141     15.28%
       sendto            124501   464.307     0.001     0.004     0.039      0.14%
       write             125026   462.438     0.001     0.004     0.031      0.10%
       recvfrom           62799   248.383     0.002     0.004     0.030      0.11%
       madvise                3     0.066     0.014     0.022     0.034     26.97%
       sched_yield           10     0.043     0.004     0.004     0.004      1.69%


### What the server is doing

The following command shows a sorted list of routines (kernel and user) where the server spend the most of the time.

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

## Bugs

https://pagure.io/389-ds-base/issue/51255: performance search rate: checking if an entry is a referral is expensive
