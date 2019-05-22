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
* If we need to flush the buffer we do it in the CURRENT thread - this delays the operation.

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

In a worse situation, the error log does not even have a buffer so as a result, we are generally unable to activate the error log on customer sites to get important debugging information,
and during our own development builds, we can't enable it for fear of causing other interactions and effects.

Future Logging Design
=====================

An important question, is what do we *want* from logs? To detail the information we would like:

* Statistics about operations (IE timing, entry counts, memory usage, number of connections, status akin to cn=monitor).
* Auditing of operations performed by clients (searchs, binds, modifications etc)
* Debugging of operations (ACL decisions, plugin states, why and what happened)
* Reporting of errors within the server framework outside of normal operations context (IE disk full).
* Debugging of server framework (Connections, Replication, Disk Usage)
* Detailing of the current server operation state (business as usual, highlevel information, notification when resource limits hit thresholds like 80% max conns).

To contrast, what we have today, is a small amount of auditing (access, audit), and minimal server
framework debugging (error, hindered by performance so we can't enable higher levels).

To accomodate the larger amount of data we wish to handle,
the logging system should be fully async, and should accepted structured log data, which is built
into a whole log-message unit. These log-units are sent to a queue for processing. As the log-unit
is a structured element, we can then extract each of the types of information out into relevant
logs. For example, imagine a (fake, hypothetical) log-unit containing:

    [
       { timestamp, operation start },
       { timestamp, modify },
       { timestamp, bind dn },
       { timestamp, ACL decision is .... },
       { timestamp, nentries = 5 },
       { timestamp, dn=x modify cn },
       { timestamp, dn=y modify uid },
       { timestamp, plugin memberOf err=??? },
    ]

This would be sent as a block to the log thread, and we could then process it out such that:

    [
       { timestamp, operation start },  -> access
       { timestamp, modify }, -> access
       { timestamp, bind dn }, -> access
       { timestamp, ACL decision is .... },
       { timestamp, nentries = 5 }, -> access
       { timestamp, dn=x modify cn }, -> audit
       { timestamp, dn=y modify uid }, -> audit
       { timestamp, plugin memberOf err=??? }, -> error
    ]

The entire structure itself, with all timing data would then be submitted to an operation log. This
way the operation log would support statistics and debbugging of operations. This begins to fill
in many of the logging gaps we have today.

At start up we would create a log thread, which is written in Rust and would handle
all incoming log-units to be written. It would also handle log rotation and renaming.
The log thread would also be able to write to other output types like syslog, stdout/stderr.

The log configuration would be "sent" to the log thread, to allow dynamic (live) configuration
of the logging system.

At the start of an operation, we would request a new log-unit, and add it to the operation
structure. We would then have slapi\_log\_op calls, which are Rust functions, externed for C compatability.
These would write to the operation log-unit, along with timing and file-line data.

And the end of the operation, we would submit the log-unit to the log-thread where it will be
processed and formatted for writing.

In the future, we could modify slapi_log_err/access/audit, to also create messages that are able
to be sent to the log-unit structure, and they could be written as required to their respective log
files on processing by the log-thread.

In initial development, If we want to disable the operation log, we would have a libglobs config item that would disable this.
It's likely we would achieve this by having the new log-unit request return an empty/NULL
pointer, which slapi\_log\_op calls would then NOOP on.

However, once we commit further, it's more likely that disabling of the operation log would simply
cause the data in the log-unit to just be filtered out and not written at all.

### Why Rust

See the main [Rust Integration](rust.html) document for more detail. The tl;dr is safe, fast
and modern development language which will help to make features easier and safer to write.

### Possible idea

If total duration > x, log

### What happens in a crash?

This is a valid concern - in a crash case we'll be missing the data of the events that led to that failure. However this is already true because:

* We have no ability to enable error logging.
* The access log is buffered by default.

To accomodate this situation, we can develop a GDB python extension capable of dumping the in-memory log queues from the async logging system. This should
be developed as part of the feature.

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

It should be taken as a preliminary, and not considered as the final result of what this change could bring. Importantly, we have to consider that the individual operation performance
will improve due to no buffer-flush stalls, and we will have the confidence to enable and get debugging information from the system without penalty.

Author
======

William Brown <wibrown at redhat.com>

