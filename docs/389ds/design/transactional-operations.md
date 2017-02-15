---
title: "Transactional operations in server"
---
{% include toc.md %}

## Overview
-----------

This design really aims to target a number of issues that have arisen in the server over time.

* Ability to adopt new technologies. LMDB requires a different processing model to take advantage of it.
* Safety. Historically we have been very poor at multi thread safety.
* Performance. To combat our safety issues, we have seen an explosion of "fine grained" locks, that create serialisation points everywhere.
* Plugins aren't really plugins. They can't just "work on an operation" safely, they are having to worry about multithread issues: Our API doesn't make guarantees that we should!
* plugin api is showing it's age. It evolved rather than being designed, which now shows in the pblock code.

## Current Architecture
-----------------------

The current design of the server has operations proceed in a semi-parallel and semi-serialised fashion. Lets consider an "add" operation:

    Operation Begins
            |
            V
    Run PRE_ADD plugins
            |
            V
    Begin backend transaction
            |
            V
    Check Access Controls
            |
            V
    Run BETXN_PRE_ADD plugins
            |
            V
    Tentative add to DB
            |
            V
    Run BETXN_POST_ADD plugins
            |
            V
    Commit TXN to DB
            |
            V
    Run POST_ADD plugins
            |
            V
    Result returned to client

Now, we have to consider that these can be running in parallel, and now we have to add many interactions into this process.

* Plugin list. This can change due to another operation adding/modifying plugins, so we need a way to keep this consistent. This means there is a lock there.
* Backend transaction. Only one operation can be in a transaction at a time.
** If in PRE_ADD, outside of the transaction we do a search this creates and IMPLIED transaction, and calls plugins. Now we have the backend transaction and plugin locks out of order (causes lots of deadlocks in the past)
* Access Controls. Another thread could change these, so these are locked too.
* Cache in the backend. This is a hashmap, so has to be locked, which means we block searches. Only one thread in BETXN at a time!
* Plugins themself may contain a lock, because another thread could change their config (which does NOT happen under a backend lock), so as a result, we have to lock inside a plugin.
* Schema needs a lock, as another thread might change it part way through the operation.
* The server config is able to be changed outside of a transaction, so that needs a lock if we ever access it.
* Writing a message to the logs needs a lock.

So below is the same chart with only *some* of the locks added in:


    (locks denoted by x)

    Operation Begins
            |
            V
    Run PRE_ADD plugins X
            |
            V
    Begin backend transaction X
            |
            V
    Check Access Controls X
            |
            V
    Run BETXN_PRE_ADD plugins X
            |
            V
    Tentative add to DB
            |
            V
    Run BETXN_POST_ADD plugins X
            |
            V
    Commit TXN to DB
            |
            V
    Run POST_ADD plugins X
            |
            V
    Result returned to client


Now imagine we are runnig 30 threads or more. Every single log message, plugin call, acl check, backend operation, all need locks. We are serialised for both reads and writes effectively at many points of our operation!

### Current server conditions
-----------------------------

As a result, we have the following server environment:

* Only one thread may be working in the database at a time (read or write)
* Plugins must internally lock to prevent thread sync issues
* Only one thread may be sending a log message at a time -- (note, sometimes writing to the log means you flush and write ALL buffers causing more latency!)
* Only one thread may be accessing ACL's at a time
* Only one thread may be accessing Schema at a time
* Only one thread may access system configuration values at a time
* Transactions aborts may leave the server inconsistent (known bug in some cases)
* Plugin list for an operation is guaranteed at the start of the operation (this is good!)
* many undefined cases with dynamic plugins and changing configurations midway during operations (asan picks these up regularly)

### What do we want?
-------------------

We need a way for many of these subsystems to be able to operate either in a lockless, or protected manner, without impacting other threads. The final goal is:

* Many reads may be operating at a single point in time (without blocking a write)
* Only one write may occur at a time (without blocking reads)
* Faster access to logging messages (async buffer flush)
* Multiple reads to schema, acl, configuration at a time.
* Unblocked write to schema, acl, configuration at a time. (ie writes do not block reads, nor reads writes)
* Change to acl, schema, configuration or database, should not alter contents of an existing read (isolation between threads)
* Abort of a transaction can correctly rollback all changes of the operation
* Plugin list for an operation is guaranteed at the start of the operation
* Plugins can be disabled or enabled during an operation without affecting current operations.

## Proposed design
------------------

I propose that we use copy on write datastructures to achieve this design. A copy on write datastructure is one that allows a stable version of the tree to exist, while modifications are made on the copy. When the modifications are complete, the root node pointer of the tree is pivoted. Once the previously versions reference count drop to 0, elements for the previous tree are freed.

In the first image we see the original state of the tree. We have can take a read only transaction to txn_id 1 here.

![Initial](../../../cow_btree_1.svg)

In this image, we can see that we have a read only transaction to txn_id 1, and a write occuring in txn_id 2. Note the way that the tree branch is copied during the write, so the content of txn_id 1 is consistent through out it's operation. After this is commited, all new read transactions would begin on txn_id 2.

![RO txn and write](../../../cow_btree_2.svg)

Finally, we close the read transaction on txn_id 1. Since there are no more users of the txn, we can trim the unreferenced nodes, and continue with the tree state as txn_2

![Close](../../../cow_btree_3.svg)

Multiple read transactions states can be present. In other words if you do:

    Begin Read 1
    Write 2
    Begin Read 3
    Write 4
    Begin Read 4
    Write 5
    Close 1
    Close 3
    Close 4

Transaction 1, 3 and 4 are guaranteed to have their contents correct at the time the read transaction, despite there being multiple writes having occured even between read transactions.


Another property of this design is that memory placed into the tree, their lifetime is bound to the tree and it's transactions. The tree is provided with free functions, which are
correctly able to dispose of the pointers given to the tree. Provided your free function is correct, you can trust the tree to properly manage the lifetime of our references.

This means we can have the following situation. When an operation begins we can take a transaction of the active list of plugins in the tree right now. These are sorted by order of operation, so we can apply them by walking the tree. During this operation, another operation rapidly disables some plugin X from the server. The next operation would not use plugin X. The first operation would still have the reference to the node containing plugin X, so the plugin would still work. Once the use of the transaction drops to 0, the plugin would now be closed and freed as we can guarantee no future transactions are within the plugin code. If the plugin were re-opened at the same time, this would be a new plugin struct, so would not be affected by this close.

### Transactions
----------------

At the begining of a new connection, we take a write transaction on:

* Connection tree
* cn=config (ro, for connection params)

At the begining of a read operation by the client (not connection, operation) a set of transactions would be opened. This would be in:

* ACL list
* Plugin list
* Cache (ldbm)
* cn=config, cn=schema
* backends (lmdb)
* Connection tree

At the begining of a write operation (add, mod, del) a write transaction would open in:

* ACL list
* Plugin list
* Cache (ldbm)
* cn=config, cn=schema
* backends (lmdb)
* connection tree (ro)

### Plugin API
--------------

Due to the change related to transactions, plugins will need to operate differently.

Some plugins may require transactions (IE IPA's kerberos plugin.). They will be offered a plugin hook for read begin, read close, write begin, write abort and write commit. Plugins must not block read and writes, the same property we expect. This is due to the fact we may internall need a write from within a read transaction, which would cause a deadlock with pthread_rwlock. We may change this design decision later, but it is unlikely.

Plugins would be able to drop their internal locking of config etc, because they can guarantee they are they only instance in the critical segment during a write.

Plugins would be able to drop their internal locking in reads, because if they read their config from cn=config, this is guaranteed to be protected during the critical segment of a read (IE after the operation the new config would take effect).

## Risks and mitigation strategy
--------------------------------

### Binds
---------

Binds require to write post bind. There are three solutions.

* Binds are carried out in a write transaction.
* Binds are carried out in a read transaction with async write post result send.
* Binds are carried out in a read transaction, with blocking write post result send.

### Large code change
---------------------

This is a very large code change, with no guarantee of effectiveness.

Instead of doing this in one large change, we will do smaller changes that build towards this goal. Each change in isolation will help that component, but are working toward a final goal where we will be able to realise the full benefits of the changes.

For example, the change to a connection table will benefit us without the full set of changes. The change to having ACL in a tree will help us process operations with "less locking" contention.

### Key person risk
-------------------

It is key that as a team we distribute this work so we each have an understanding of the safety model of these structures (even if you can't implement it, you need to know how it works). This way, we are not reliant on a single person to understand the entire system.

### Serialisation of operations
-------------------------------

A concern is that we are serialising operations. This is already the case in directory server! The idea of this change is to serialise them in a way, where they are unblocked from reads, making each write individually faster, so we should see an improvement in write throughput.

Read throughput would be unblocked from writes, which should allow us to see an improvement in parallism.

## Related design documents
---------------------------

-   [Nunc Stans Workers](nunc-stans-workers.html)
-   [Cache Redesign](cache_redesign.html)
-   [High Contention with Entry Cache](high-contention-on-entry-cache-lock.html)
-   [Pblock Breakup](pblock-breakup.html)
-   [Plugin Version 4](plugin-v4.html)
-   [Password extensibility](password-extensibility.html)
-   [Logging Performance Improvement](logging-performance-improvement.html)

## Implementation plan
------------------------

Goals:

1) Core and clean up
2) Modularisation
3) Plugin version 4
4) Transactions

#### 1.3.6 (outside of DS)
--------------------------

* Finish COW B+Tree (4 https://pagure.io/libsds/issue/1 )
* Decouple transaction manager  (2 https://pagure.io/libsds/issue/9 )
* Write cache implementation   (4 https://pagure.io/libsds/issue/2 )
* Finish nunc-stans tickets   (2 https://pagure.io/nunc-stans )

#### 1.3.7
----------

* bundle libraries (svrcore, nunc-stans)  (2  )
* begin breakout of slapi platform abstraction library  (1, 2, https://pagure.io/389-ds-base/issue/49115)
* Introduce private only slapi v4 api to begin work. No public access, no need to support. (3  )
* Pblock clean up (1 https://pagure.io/389-ds-base/issue/49097 )
* Nunc-Stans worker threads  (1 https://pagure.io/389-ds-base/issue/49099 )
* COW B+Tree for connection management  (4 https://pagure.io/389-ds-base/issue/49098 )
* COW B+Tree for plugin management   (4  )

1.4.0

* cleanup source tree  (1  ):


    └── ds
        ├── configure.ac
        ├── docs
        │   └── ds.doxy
        ├── m4
        ├── Makefile.am
        ├── rfcs
        ├── rpm
        └── src
            ├── libsds
            ├── libslapd
            ├── libspal
            ├── ns-slapd
            │   └── plugins
            ├── ns-slapd-tools
            │   ├── dbscan
            │   ├── dsktune
            │   ├── infadd
            │   ├── ldclt
            │   ├── ldif
            │   ├── migratecred
            │   ├── mmldif
            │   ├── pwdhash
            │   └── rsearch
            └── nunc-stans

* Fix code white space  (1)
* Clean up headers and visibility (3 https://pagure.io/389-ds-base/issue/49124 )
* Symbol visibility   (1  )
* v4 api for RH only use  (3)
* clean configure with pkg-config over hard paths  (1 https://pagure.io/389-ds-base/issue/49119 )
* COW B+Tree for ACI internal storage  (4)
* COW B+Tree for fedse.c (cn=config, cn=schema)  (4)
* COW B+TRee for configuration variable storage  (4)
* Async logging improvements (1 https://pagure.io/389-ds-base/issue/48365 )

* NOTE!! Are there more places we need to make operate in parallel for this?

#### 1.4.1
----------

* Convert plugins to plugin v4 api (retaining locks) (3)

#### 1.4.2
----------

* COW B+Tree cache for LDBM before we have LMDB  (4 https://pagure.io/389-ds-base/issue/49096)
* LMDB  (4)
* Per-operation transactions for related transactional elements  (4 https://pagure.io/389-ds-base/issue/573 )

#### 1.4.3
----------

* Remove locks inside of plugins  (4)

## Author
---------

William Brown -- wibrown at redhat.com
