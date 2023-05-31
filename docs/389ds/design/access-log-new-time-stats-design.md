---
title: "New 'time' Keywords in the Access Log"
---
    
# New "time" Keywords in the Access Log RESULT Message
----------------

## Background

Previously the only performance statistic in the access log was in the **RESULT** message using the keyword **etime**.  The *etime* stands for elapsed time, and it covers the time the operation was received by the server to when the result was sent back to the client.  The problem with **etime** is that it is not telling the whole story of the operation.  When an operation is received it is placed into a work queue, and later it is picked up by a worker thread and processed.  With *etime* we do not know how long it waited in the work queue, and we do not know how the long the operation actually took to fulfill its task.

    [23/Jun/2020:16:30:27.388006333 -0400] conn=20 op=5 SRCH base="dc=example,dc=com" scope=2 filter="(&(objectClass=top)(objectClass=ldapsubentry)(objectClass=passwordpolicy))" attrs="distinguishedName"
    [23/Jun/2020:16:30:27.390881301 -0400] conn=20 op=5 RESULT err=0 tag=101 nentries=0 etime=0.002911121

## The Improvement

From a debugging and performance analysis perspective *etime* is insufficient.  We have now added two more "time" keywords to the **RESULT** message in the access log.

- **wtime** - This is the amount of time the operation was waiting in the work queue before being picked up by a worker thread.
- **optime** - This is the amount of time it took for the actual operation to perform its task (Bind, Add, Search, Modify, Modrdn, or Delete).

If you add **wtime** and **optime** together it should *approximately* add up to the **etime**.

    [23/Jun/2020:16:30:27.388006333 -0400] conn=20 op=5 SRCH base="dc=example,dc=com" scope=2 filter="(&(objectClass=top)(objectClass=ldapsubentry)(objectClass=passwordpolicy))" attrs="distinguishedName"
    [23/Jun/2020:16:30:27.390881301 -0400] conn=20 op=5 RESULT err=0 tag=101 nentries=0 wtime=0.000035342 optime=0.002877749 etime=0.002911121

Tests show if you add them up they are slightly longer than the actual etime, but this is just due to the timing of when these stats are gathered and where it is located in the source code.  Regardless, it's very close.

    0.000035342 + 0.002877749 = 0.002913091 (actual etime 0.002911121 -> difference of 0.00000197)
    
This difference is not important, what is important is that **wtime** and **optime** are accurate and provide insightful information as to how the server is handling load and processing operations.


## Origin

https://github.com/389ds/389-ds-base/issues/4218

## Author

<mreynolds@redhat.com>

