---
title: "Nunc Stans Support in 389"
---

# Nunc Stans Support in 389
---------------------------

Overview
--------

Nunc Stans is our proposed solution to the
[C10K](http://www.kegel.com/c10k.html "C10K") problem.  Rather than writing
something to use epoll, etc. directly, we are using an event framework that
supports epoll and other event mechanisms with a high level, user-friendly API,
giving us the ability to easily support other high performance event mechanisms
now and in the future (e.g. Grand Central Dispatch, completion ports, etc.).
Also, rather than just using something like libevent directly, we decided to
use an event framework wrapper, with some addition thread safety and thread
pooling functionality, called [Nunc Stans](http://fedorahosted.org/nunc-stans
"Nunc Stans").

The "main loop" for 389 uses poll().  Before every poll call, the array of FDs
to pass to poll() is constructed by looping over a linked list of all of the
active connections.  Connections that need more polling are added, while
connections marked for deletion, or connections that have been idle for too
long, are not skipped and added back to the pool of available connections.
poll() is then called with this array, with a 250ms timeout, then all of the
active connections are looped over again.  Connections that have I/O are
notified, and closed or idle connections are cleaned up.  While this works fine
for up to a few hundred connections, it does not scale very well to a few
thousand.

There are better mechanisms than poll(), such as epoll(), that scale to
thousands of connections.  There are also event frameworks such as libevent,
libev, tevent, etc. that provide a user-friendly API, and abstract the
implementation details of the event mechanism from the application developer,
which allows support for many different event mechanisms.

One problem with using event frameworks is that some of them are not thread
safe.  You have to be careful not to add or delete events or call event
callbacks from multiple threads.  Or, even if they are thread safe, it may
introduce a lot of thread contention if many connections and events are
contenting for framework resources.  A lot of care needs to be taken when using
an event framework since 389 is multi-threaded.

Nunc Stans provides:

-   Support for multiple event frameworks.  It already supports libevent and
    tevent, and support for others can be added.
-   A thread safe wrapper around the event framework.
-   Support for I/O events with a timeout, which means we do not have to keep
    looping over active connections to look for idle ones.

Use Cases
---------

The main use case is to support 389 having several thousand active connections
with no performance degradation.

Design
------

389 will register its listeners with nunc-stans.  The 389 callbacks to handle
new connections and handle read/write ready on a connection will be wrapped
with a nunc-stans callback to try to reuse as much of that existing
code as possible.  These nunc-stans callbacks will _not_ be threaded, they will
run in the nunc-stans event loop thread, since the current code expects certain
operations on connections (create/initialize/cleanup) are done in a single
threaded environment.  There will be a nunc-stans callback explicitly for
connection closure/cleanup that will also not be threaded.  This will replace
the code that currently runs in the poll() main loop that cleans up and
reclaims connections.  The `Connection` object is the nunc-stans job callback
data.  When a connection is handed off to nunc-stans, the reference count of
the object will need to be incremented, and decremented when the nunc-stans
callback is called.  The closure/cleanup callback will need to use the refcount
to make sure no other thread is using the connection.  That closure/cleanup
will need to be done via a `ns_add_timeout_job` call, and will have to re-arm
itself if it attempts to close/cleanup a connection that is still being
referenced by another thread.  This callback will need to ensure that it does
not create a tight loop, so using the default 250ms timeout should be
adequate.

389 will not use persistent jobs for the `Connection` related events, I/O or
timeout, except for the listener jobs.  When an I/O callback is called, the job
is removed from nunc-stans.  This means that if the reader needs more data, it
needs to add a new job for the connection.  389 should always use the
nunc-stans function `ns_add_io_timeout_job` for a `Connection` that needs more
data to ensure that the connection will properly timeout if idle.

389 must always call `ns_job_done` in the nunc-stans job callback as the last
thing it does before returning, and the job must not be referenced after the
call e.g. do it last, or set the job to `NULL`.

When 389 runs out of file descriptors, it will need to remove one or more of
the listeners from nunc-stans until one or more connections close, at which
time the listeners should be added back.

Implementation
--------------

The new function `ns_connection_post_io_or_closing` is used to add a new
nunc-stans I/O timeout or closure timeout job.  389 code should use this method
rather than call `ns_add_io_timeout_job` or `ns_add_timeout_job` directly.
This function will either add an I/O timeout job for the
`ns_handle_pr_read_ready` callback, or if the connection has been marked for
closure, will add a timeout job for `ns_handle_closure`.

The function `ns_handle_new_connection` wraps `handle_new_connection` and does
very little extra except for checking for the too many FDs condition and
removing the listener if so.  It just calls `ns_connection_post_io_or_closing`
to add the connection to nunc-stans for I/O callback or closure.

The function `handle_pr_read_ready` could not be wrapped.  The function
`ns_handle_pr_read_ready` adds the connection to the queue for one of the
worker threads, or adds the closure job if the connection is marked for
closing, which is pretty much what `handle_pr_read_ready` does besides the
looping and checking for idle connections.

The function `ns_handle_closure` is the timeout job for cleaning up and
reclaiming connections.  It will re-arm itself if the connection could not be
closed because it is in use by another thread.  It will also ensure that only
one closure job is in progress at a time.

Since the `Connection` object carries the context, it needed to be changed to
carry some addition information:

    #ifdef ENABLE_NUNC_STANS
        struct connection_table     *c_ct; /* connection table that this connection belongs to */
        ns_thrpool_t                *c_tp; /* thread pool for this connection */
        int                         c_ns_close_jobs; /* number of current close jobs */
    #endif

The connection table is needed for cleanup, to add the closed connection back
to the connection_table for reuse by another thread.  The thread pool pointer
is required in order to add jobs i.e. if a thread needs more I/O on a
connection.  The close jobs flag is needed to ensure that there is only 1
outstanding closure job for a connection.  When the server receives an UNBIND
request, the client may close the connection before the server does.  In this
case, two different threads will attempt to mark the connection as closed and
add a timeout job for closure, and the order in which these two events happen
is not guaranteed.  The connection object keeps track of when the closure job
is added, and when another thread attempts to add a closure job for the same
connection, that attempt is rejected.

The function `disconnect_server_nomutex_ext` extends
`disconnect_server_nomutex`.  It will call `ns_connection_post_io_or_closing`
to add the closure job.  It also adds a flag `schedule_closure_job` so that the
function can also be used from within the `ns_handle_closure` if it detects
that a connection should be closed but has not been marked as closed yet.

In the old code, as soon as a connection was marked as readable by calling
`connection_make_readable_nolock`, it was availble for polling as soon as
possible.  With nunc-stans, we do this by calling
`ns_connection_post_io_or_closing` in `connection_make_readable_nolock` which
will add the I/O job (essentially, make the connection available for polling)
if the connection is not marked as closing.  If the connection is marked as
closing, the function `connection_release_nolock_ext` will call
`ns_connection_post_io_or_closing` to schedule a closure job.

### Known Problems

[Ticket #48184](https://fedorahosted.org/389/ticket/48184 "Ticket #48184")

The server relies on the idletimeout to add the I/O timeout job.  If there is
no idletimeout, or the user (e.g. directory manager) has no idletimeout, the
connection will be added to nunc-stans with no timeout.  If the client does not
close the connection, the connection will remain in nunc-stans indefinitely,
and will not be closed at shutdown.  We need some sort of mechanism in 389 (or
possibly in nunc-stans) that can be used to clean up these types of jobs at
shutdown.

Major configuration options and enablement
------------------------------------------

For building, the configure flag `--enable-nunc-stans` was added.  This adds
the define `ENABLE_NUNC_STANS` for the nunc-stans specific code.  The configure
flag `--with-nunc-stans=[path]` was added to specify the location of the
nunc-stans header and shared library.  If you build nunc-stans from source,
make sure that there are no `.a` and `.la` files in the `[path]/lib` directory
or the 389 build will fail.

At runtime, use the configuration attribute `nsslapd-enable-nunc-stans: on` to
enable nunc-stans in a server that has been built with `--enable-nunc-stans`.
The default value is `off`.

Replication
-----------

There is no impact on replication.  The "turbo mode" for incoming replication
connections should work exactly as it does without nunc-stans.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

389 will need the nunc-stans header and shared library.  nunc-stans itself
depends on NSPR, libevent, tevent, and talloc.

External Impact
---------------

Impact on other development teams and components

Author
------

Rich Megginson rmeggins@redhat.com

