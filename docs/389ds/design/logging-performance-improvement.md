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

We should extract our logging from the core of the server, and how it works and design it to be able to function seperately (so it can be used in ns/sds).

We would have a logging system that accepts various live reconfiguration options. By default, the logging system would be:

* synchronous
* write to stdout/stderr

Then when directed, the server could reconfigure this to use files and buffered logginging in queues. The writing thread would be self managed by the logging
system, as to prevent ns-workers getting filled up, and to allow async events.

### Message processing

This is the same *regardless* of sync/async

First, we take a clone of the config. This is the config for the "duration" of the logging event. IE we dont want someone to change log file, or something else from under us.

We make a logevent structure that would contain:

* timestamp
* the message
* the level
* the service we came from (access,err, audit).

Now we look at the config to determine if this was sync or async.

### Sync processing

If this was a sync message, we would take the output lock, and write to our various outputs, perform filerotation. Basically, we bypass the queue step. This step would also perform formatting of the timestamp.

### Async processing

We take the logevent structure (and before we do string processing etc), we push it to the logevent queue. we then send a condvar notify to the logging thread to wake up and write the message. The caller now returns.

The logging thread when it recievs the condvar message is either already awake, or it woke because of the condvar notify.

When we wake, we take a clone of the config, and until we sleep again, we keep using it.

We would loop over the queue, dequeuing log events, and then running the sync write on the events.

As we are about to sleep, we would release our config.

If a reconfiguration happened from async->sync, because we hold the output lock, we would finish flushing all our queued messages before we gave up to the sync logger.

### Reconfiguration

Because the configuration is cloned by the caller, this means we can reconfigure at anytime, and inflight messages are still logged by the old config, but new ones get the new config.



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

