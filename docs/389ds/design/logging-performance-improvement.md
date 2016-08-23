---
title: "Logging Performance Improvement"
---

# Logging Performance Improvement
---------------------------------------------

{% include toc.md %}

Overview
========

As a security service it is imperative that we provide high quality, reliable and performant logging.

The current design of the logging system relies on a fixed sized buffer. If the size of the buffer is filled, we must flush the log. Additionally, this buffer must be locked to prevent issues during updates.

However, because of the design of our search code this creates an artificial serialisation point within the code. As well, when the buffer must be flushed, we prevent the progress of all threads on their current work.

We can use nunc stans and lfds to create a lockless logging system, that is buffered and prevents stalls.

Current Logging Design
======================

This will discuss the design of the current access log: the error and audit log are identical with the exception that they are NOT buffered.

When an event in a search (search.c, opshared.c, result.c) requires logging a call is made to slapi_log_access. Important to note that we log:

* When the bind is first made: BIND
* At the begining of the search request: SRCH
* When the search result is complete: RESULT

An excerpt of this is here:

    [01/Jul/2016:10:22:12.979987495 +1000] conn=62 op=0 BIND dn="cn=Directory Manager" method=128 version=3
    [01/Jul/2016:10:22:12.980133170 +1000] conn=62 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="cn=directory manager"
    [01/Jul/2016:10:22:12.980413329 +1000] conn=62 op=1 SRCH base="dc=tgt,dc=example,dc=com" scope=2 filter="(uid=tuser2)" attrs="cn nsAccountLock nsRoleDN"
    [01/Jul/2016:10:22:12.980867297 +1000] conn=62 op=1 RESULT err=0 tag=101 nentries=1 etime=0

So to complete this, the logging code follows the following path:

    slapi_log_access
        vslapd_log_access
            - Time stamps are collected
            - The message is formatted
            log_append_buffer2
                - Lock the buffer
                - If the buffer has space:
                    - Insert the message
                - If the buffer does NOT have space:
                    - Flush all buffer contents to disk
                    - Insert this message to the top of the empty buffer
                - Unlock


Critical to note:

* We are locking and unlocking a single contention point, the access log buffer.
* If we need to flush the buffer we do it in the CURRENT thread.

What does this mean?

First, *ALL* operations are serialised over this lock. During a BIND, you must acquire and release the lock to the access log once, and once more for the RESULT. Same for search. This means that no searches can actually be processed in parallel, while we have the access log designed like this, they are all serialised!

Second, because all searches are serialised, when the buffer fills, and the lock is held, the log is flushed. This causes *ALL* threads currently waiting on the access log to stall until the buffer is written.

This second behaviour especially can be seen while running ldclt. You will have a number of threads perform well, followed by a drop, then high numbers resume. Here is a sample of an access log where you can see this:

    [29/Jun/2016:10:09:40 +0200] conn=419 op=14150 RESULT err=0 tag=101 nentries=1 etime=0.001000
    [29/Jun/2016:10:09:40 +0200] conn=419 op=14151 RESULT err=0 tag=101 nentries=1 etime=0.000000
    [29/Jun/2016:10:09:41 +0200] conn=419 op=14152 RESULT err=0 tag=101 nentries=1 etime=0.001000
    [29/Jun/2016:10:09:41 +0200] conn=419 op=14153 RESULT err=0 tag=101 nentries=1 etime=0.005000
    [29/Jun/2016:10:09:41 +0200] conn=419 op=14154 RESULT err=0 tag=101 nentries=1 etime=0.202000
    [29/Jun/2016:10:09:41 +0200] conn=419 op=14155 RESULT err=0 tag=101 nentries=1 etime=0.064000
    [29/Jun/2016:10:09:41 +0200] conn=419 op=14156 RESULT err=0 tag=103 nentries=0 etime=0.011000
    [29/Jun/2016:10:09:42 +0200] conn=419 op=14157 RESULT err=0 tag=101 nentries=1 etime=0.678000
    [29/Jun/2016:10:09:42 +0200] conn=419 op=14158 RESULT err=0 tag=101 nentries=1 etime=0.005000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14159 RESULT err=0 tag=101 nentries=1 etime=0.593000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14160 RESULT err=0 tag=101 nentries=1 etime=0.063000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14161 RESULT err=0 tag=103 nentries=0 etime=0.008000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14162 RESULT err=0 tag=101 nentries=1 etime=0.448000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14163 RESULT err=0 tag=101 nentries=1 etime=0.063000
    [29/Jun/2016:10:09:43 +0200] conn=419 op=14164 RESULT err=0 tag=103 nentries=0 etime=0.065000
    [29/Jun/2016:10:09:47 +0200] conn=419 op=14166 RESULT err=0 tag=101 nentries=1 etime=0.001000
    [29/Jun/2016:10:09:48 +0200] conn=419 op=14168 RESULT err=0 tag=101 nentries=1 etime=0.001000
    [29/Jun/2016:10:09:49 +0200] conn=419 op=14169 RESULT err=0 tag=101 nentries=1 etime=0.001000

This log was using the same search repeatedly. You can see that during some RESULT's the etime is past half a second in duration, while for others it is well below this.

In summary, the current logging design in Directory Server is a bottleneck that limits our servers performance. To improve the performance of Directory Server we must change this.

Future Logging Design
=====================

The design I propose for logging is based on nunc-stans and liblfds. At server startup a multiple producer multiple consumer queue is created from lfds.

See: http://liblfds.org/mediawiki/index.php?title=r7.1.0:Queue_%28unbounded,_many_producer,_many_consumer%29

Current threads would still write to slapi_log_access as they do currently.

slapi_log_access would then carry out the following operations.

    Check logging is enabled, and at this level
    Collect the current time data
    Create a "log event" with the time data and unformated message.
    Queue the log event to the access_log queue.

We still have to serialise into the queue, but as can be seen in the benchmarks, the mpmcq in almost all cases outperforms mutexes across a high number of threads. We are also doing minimal processing inline with the operation thread, which already provides a performance improvement.

At server start up a job is created in nunc-stans on a timer. This job is the log writer.

It would wake, and begin to consume the events from the queue. The log writer does the formatting of the strings, timestamps, and writing to the log. Once it has emptied the queue it would rearm itself on a timer for a few seconds later, and would repeat this activity.

This solves the issues with the current log design by:

* Removing the locks, and using the much faster queue from liblfds.
* Moves all string formating and manipulation out of the search / result thread, and pushes the work to a dedicated logging thread. This way we do not impact the performance of operations.
* We no longer stall operation threads due to needing to flush the log while they are working.

This would also be useful to create a buffered audit log and or error log depending on circumstance.

For un-buffered logs, we would either:

* Still need a mutex, and just call the log writer, bypassing the queue.
* Add the log event to the queue, but run the logging thread more frequently.

Initial Benchmarks
==================

This is a test of a stock Directory Server, compared to a server where slapi_log_access immediately returns 0. As a result, this isn't going to indicate the future performance, but should show the effect of logging on the threads and that there is peformance to be gained.

This was run on EL7.2 lenovo t450s.

Basic install, searched with:

    /opt/dirsrv/bin/ldclt-bin -h localhost -p 38932 -b 'dc=tgt,dc=example,dc=com' -e esearch -f '(objectClass=*)'

With default logging:

    ldclt[215]: Average rate: 2005.10/thr  (2005.10/sec), total:  20051
    ldclt[215]: Average rate: 2054.10/thr  (2054.10/sec), total:  20541
    ldclt[215]: Average rate: 1972.10/thr  (1972.10/sec), total:  19721
    ldclt[215]: Average rate: 1900.60/thr  (1900.60/sec), total:  19006
    ldclt[215]: Average rate: 1845.50/thr  (1845.50/sec), total:  18455
    ldclt[215]: Average rate: 1922.80/thr  (1922.80/sec), total:  19228
    ldclt[215]: Average rate: 1939.30/thr  (1939.30/sec), total:  19393
    ldclt[215]: Average rate: 1844.90/thr  (1844.90/sec), total:  18449
    ldclt[215]: Average rate: 1874.80/thr  (1874.80/sec), total:  18748
    ldclt[215]: Average rate: 1824.50/thr  (1824.50/sec), total:  18245

Directory Server with logging "compiled out":

    ldclt[5994]: Average rate: 2057.00/thr  (2057.00/sec), total:  20570
    ldclt[5994]: Average rate: 2128.30/thr  (2128.30/sec), total:  21283
    ldclt[5994]: Average rate: 2044.90/thr  (2044.90/sec), total:  20449
    ldclt[5994]: Average rate: 2071.60/thr  (2071.60/sec), total:  20716
    ldclt[5994]: Average rate: 1999.30/thr  (1999.30/sec), total:  19993
    ldclt[5994]: Average rate: 2011.60/thr  (2011.60/sec), total:  20116
    ldclt[5994]: Average rate: 1987.30/thr  (1987.30/sec), total:  19873
    ldclt[5994]: Average rate: 1952.80/thr  (1952.80/sec), total:  19528
    ldclt[5994]: Average rate: 1983.30/thr  (1983.30/sec), total:  19833
    ldclt[5994]: Average rate: 2008.20/thr  (2008.20/sec), total:  20082

In summary, the first test was able to complete 191837 operations, while the second was able to complete 202443. This is a 6% improvement in performance.

This is a *very* artifical test, with a small dataset, and a complete removal of the access log lock. On a larger dataset, and a system with more cores (especially numa region traversal), with higher utilisation, it may improve more. Remember, more cores == more contention on locks == higher cost to take the lock.

It should be taken as a preliminary, and not considered as the final result of what this change could bring.

Author
======

William Brown <wibrown at redhat.com>

