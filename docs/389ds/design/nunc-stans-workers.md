---
title: "Nunc Stans worker support in 389"
---

# Nunc Stans worker support in 389
-----------------------------------

Overview
--------

[Nunc Stans](nunc-stans.html) is our solution to the C10k problem. It already has
been integrated into 389 Directory Server today and can handle connection acceptance
for the server, allowing us to scale much better.

But bottlenecks still exist.

The listening socket recieves the io event, which triggers nunc-stans to dispatch a job.
That job then runs the connection accept code. The connection is inserted into the
connection table, and the acceptance code rearmed for a new connection.

At this point, nunc-stans leaves the picture. We still iterate over the connection
table and are polling on the fd to find new work. This is very expensive, requiring
a lock on the table, locking the connection. This has certainly showed issues even
recently, with some connections blocked on io, which prevents processing io for
any other connection even when they are ready to proceed.

For example, looking at do_search, we can see:

    #0  do_search (pb=0x7f7cb0dca9f0) at /home/william/development/389ds/ds/ldap/servers/slapd/search.c:37
    #1  0x000000000041f8b8 in connection_dispatch_operation (conn=0x7f7cb15f7200, op=0x61400005fc40, pb=0x7f7cb0dca9f0) at /home/william/development/389ds/ds/ldap/servers/slapd/connection.c:651
    #2  0x00000000004251ac in connection_threadmain () at /home/william/development/389ds/ds/ldap/servers/slapd/connection.c:1759
    #3  0x00007f7cc46027df in _pt_root (arg=0x612000096040) at ../../../nspr/pr/src/pthreads/ptthread.c:216
    #4  0x00007f7cc43c26ba in start_thread (arg=0x7f7cb0dcb700) at pthread_create.c:333
    #5  0x00007f7cc40fd3cf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105

Even with nunc-stans enabled today, we still use the existing threading system,
rather than the nunc-stans event dispatch and queues.


Proposed solution
-----------------

We would remove the connection table, in favour of a connection "tree". (Avl, b+tree).

Instead of using the current start_thread()/connection_threadmain() code, we would
accept the connection, and create it as an  ns_add_io_timeout_job. At the same time
we insert the new connection into the tree.

When the connection has work to process, the event framework would wake, and send
the job to nunc-stans, where a worker would pick it up. This would then call a
function to create the pb, and dispatch to connection_read_operation(). No locks
needed! When the operation is handled, we would re-arm with ns_add_io_timeout_job
(unless we had a need to close the connection).

When a connection times out, or is closed, the nunc-stans framework would again
wake. We would detect the close / timeout, remove the connection from the tree,
and just don't re-arm the job.

If we need a summary of all connections, we could walk the tree. B+Tree is a good
choice here, as it builds a linked list across the base, just through the process
of insertion. Iterations over the connection tree would be infrequent, as we no
longer need to iterate to poll, we would only need it for tracking what connections
exist.

Other benefits
--------------

The slapi_async_task() call, and some of the database space tracking jobs could
be converted to nunc-stans timeout jobs, that re-arm themselves after they
have completed the task if they need persistence. This would make it possible
to easily add async processing to various types of jobs that the server must
operate on. This means, less native thread handling, and more focus on tasks.

Concerns
--------

Lfds requires cpu specific instructions to operate. We propose contributing to lfds
that on an unsupported arch, it falls back to mutex operation on datastructures.
This won't be "optimal", but it will mean that we don't break uncommon platforms.

Depends on
----------

Nunc Stans must be upgraded to lfds 710 before this should be considered.

Author
------

William Brown:  wibrown at redhat.com
