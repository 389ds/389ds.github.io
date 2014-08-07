---
title: "LDAP Transactions"
---

# LDAP Transactions
-------------------

{% include toc.md %}

Introduction
------------

### LDAP Transactions

As of this writing (August 3, 2010), LDAP Transactions (LDAPTXN) is an experimental RFC. The latest revision can be found at <http://tools.ietf.org/rfc/rfc5805.txt>

### Samba Requirements

In addition, Samba4 has some requirements in addition to the draft:

-   Read Your Writes - Samba needs to be able to read uncommitted "dirty" writes

    Entry A at state 1    
    Start Transaction    
    Modify Entry A - now at state 2    
    Read Entry A - returns data at state 2    
    Abort Transaction - rolls back Entry A to state 1    
    Read Entry A - returns data at state 1    

This is primarily to support the following case:

    One slightly strange thing we do is to allow for reads inside the    
    transaction after the first commit phase. This is used to allow us to    
    find the sequence number change of the whole transaction without race    
    conditions. Writes are refused after the first commit phase.    

-   Support for limited Two Phase Commit (2PC)

In Samba parlance, this doesn't mean distributed RDBMS 2PC, just across the partitions in a local database. In 389 terms, this means that the transaction may span more than one database instance.

    The reason we initially added 2PC for ldb was that we divide our    
    database into multiple partitions. Each partition is a separate local    
    database. To make commit safe, we do the first phase on all DBs, then    
    the 2nd phase on all DBs. That way if there is a problem with any one    
    of the local databases all of them will get a cancel.    

-   Lock out of other writers - Samba would prefer to have exclusive access to the data store throughout the duration of the transaction

-   Queuing - operations submitted while the database is locked should queue up rather than return with an error code like LDAP\_BUSY

Considerations
--------------

When we talk about Transactions, we mean that all of the operations must be [ACID](http://en.wikipedia.org/wiki/ACID). Maintaining ACID across all of the operations in a transaction will be tricky.

### Isolation

For LDAP Transactions, this has two parts:

-   Operations outside the transaction should see the original data until the commit is completed successfully
-   Operations inside the transaction must see the uncommitted data

The simplest way to guarantee this would be to sacrifice concurrency. That is, the transaction locks the whole database for the duration of the transaction. No other connection can read "dirty" data, nor modify the data out from under the transaction. Other connections would simply block (e.g. wait on a mutex) until the transaction is completed.

Berkeley DB 4.5 supports [Multiversion concurrency control](http://en.wikipedia.org/wiki/Multiversion_concurrency_control) or MVCC and [Snapshot isolation](http://en.wikipedia.org/wiki/Snapshot_isolation) - see [Degrees of isolation](http://www.oracle.com/technology/documentation/berkeley-db/db/programmer_reference/transapp_read.html) and the new flags [DB\_TXN\_SNAPSHOT](http://www.oracle.com/technology/documentation/berkeley-db/db/api_reference/C/txnbegin.html#txnbegin_DB_TXN_SNAPSHOT) and [DB\_MULTIVERSION](http://www.oracle.com/technology/documentation/berkeley-db/db/api_reference/C/dbopen.html#dbopen_DB_MULTIVERSION). This would allow transactions to see the data as modified in the transaction, yet still allow other operations to see the original data. We would still have to introduce locking at the entry level - if an entry is modified by a transaction, we would have to "lock" that entry until the transaction is committed - no other connection must be able to alter that entry. This includes the entry cache as well. We could then have multiple concurrent transactions and non-transaction operations. There is a trade off here too - keeping the "multiple versions" of the data will require more disk and RAM, and more locking - more thread contention could hurt performance, and we would have the possibility of more race conditions and deadlocks.

### Consistency

The tricky part here are the plugins. In order to get the final state of the data, we have to be able to execute the pre-operation plugins, to perform filtering and data validation (e.g. uid uniqueness) and to add missing data (e.g. DNA). But we cannot execute the post=operation plugins until the transaction has been committed. Another complication it is that a pre-operation plugin may submit write operations of their own (with appropriate loop detection), meaning that the above restriction applies to nested operations as well.

One solution would be to simply queue up the incoming operations for the transaction and apply them all when the End TXN request is received. However, that disallows the transaction to perform searches on the uncommitted data. For example, suppose the transaction adds a new entry, then wants to retrieve the UUID of that entry before submitting further operations. If that USN is generated via a pre-operation or a database pre-operation plugin, that plugin will have to be executed, and the result made available for searching for subsequent search operations. Therefore, the pre-operation and database pre-operation plugins will have to be executed as soon as the operation is received.

The post-operation plugins must be delayed until the transaction is either committed or rolled back successfully. Many post-operation plugins do some sort of notification e.g. replication, referential integrity, persistent search, retro changelog, etc. We cannot allow a write to be propagated to other servers early in a transaction if a later operation in that transaction would cause the transaction to be aborted. In general, we must delay all post-operation plugins until we know the result of the entire transaction.

Ideally, something like this: When the op is received, and is part of a transaction, set the txn data in the pblock. Part of the txn data would be the txn identifier, the actual DB TXN handle, and a flag that says which transaction phase we're in - UNCOMMITTED or COMMITTED. The txn id and DB handle would be assigned by the Start TXN operation. We would have to review **all** plugin code to add blocks like this:

    if (IS_UNCOMMITTED_TXN(pb)) {    
      do only actions applicable to uncommitted phase    
    }    

and

    if (IS_COMMITTED_TXN(pb)) {    
      do only actions applicable to committed phase    
    }    

I don't think that it is possible, in general, to determine which code can be executed without internal plugin knowledge.

### Searching

The current (December 4, 2009) LDAPTXN I-D says that the TXN control The control is "appropriate for update requests including Add, Delete, Modify, and ModifyDN (Rename) requests RFC4511, as well as the Password Modify requests RFC3062." However, in order to support the Samba requirement, the client must be able to issue a Search request that reads the data modified by the transaction. And to support the Isolation requirement, other clients should not be able to read the transaction modified data until after a successful commit. I think there are two ways to do this

-   clients must specify the TXN control for Search requests - this would be my preference
-   if a client issues a Search request within a TXN, the current TXN is applied - not ideal, but doable if we can live with
    -   no client has more than one transaction at a time
    -   all search requests issued within a transaction will return transaction data first
        -   that is, a search request that includes entries that have been modified by the transaction will return that modified entry

### Security

The current (December 4, 2009) LDAPTXN I-D only mentions this with respect to malicious clients that may hold a transaction for a long period of time to attack the server: "Transactions mechanisms may be the target of denial-of-service attacks, especially where implementation lock shared resources for the duration of a transaction." We should use timeouts and access control to restrict transactions.

#### Timeouts

There should be a default timeout for transactions. After the Start TXN request has been received, the server will Abort the transaction after this timeout period. The LDAPTXN I-D makes no mention of a client specified timeout. If in the future it does, the server should be able to specify a maximum timeout value.

#### Access Control

The server should be able to specify which users are authorized to use transactions. By default, anonymous users should not be authorized.

Design
------

### Plugins

Plugins should be re-written to be transaction aware and make use of transactions. For example, post-operation plugins such as referential integrity or memberOf should perform their updates as part of the transaction, to reduce the chances of database inconsistency. Attribute uniqueness could perform its search early in the transaction to ensure no duplicate entry was added. DNA could generate its values early in the transaction and make them available to other transacted plugins, and could roll back the values upon error. MMR plugins which perform URP operations could perform those operations inside the transaction.

In some cases, the plugin will have to be split and made into an "object" plugin type, in order to be both a postoperation and a betxnpostoperation plugin, or to be both a betxnpreoperation and a betxnpostoperation plugin.

### Berkeley DB Transactions

BDB transaction objects have most of the properties we desire.

-   Searching/Read Your Writes - if you specify a txn to a read operation, you can read the changes that have been made inside the transaction
    -   Behavior of other transactions or un-transacted read operations is that only committed changes can be seen - if another thread attempts to access the same page, the read/write operation will block until the transaction locking the page is complete
    -   This behavior is configurable with DB\_READ\_UNCOMMITTED (db, cursor, txn) but I don't think we want to allow other threads to see "dirty" data that may be rolled back
    -   We could also use Snapshot isolation, but I don't know what performance/disk usage impact that will have
-   Lock out other writers - we already lock the entire database for update operations
-   Queuing - operations already assigned to a thread will block on the database lock, and other operations will queue in the existing op queue
-   Limited 2PC - since we only have one database environment anyway, this may not be an issue

-   Timeouts - although transactions can be configured to timeout automatically, we will probably use some other method in order to have more control and for reporting errors to the log and the client
-   Sequence numbers - we use many different sequence numbers tied to an entry or an update - UUID, CSN, USN, uidNumber, gidNumber, SIDs, etc. - BDB has a DBSequence type - this will assign an auto-incremented integral value - this value can also be transacted, so that if the transaction fails, the number is also rolled back - this could be a big help for DNA uidNumber/gidNumber, USN, and other values which require monotonic atomic number generation.

### Entry Cache

We want to allow nested operations to see entries in the entry cache that have been modified by the parent transaction or nested transactions that have committed, but we do not want those changes to be seen by other threads. It looks as if the current directory server code allows dirty cache reads (e.g. perform a long search operation from one client - modify one of the entries in the search result set in another client - the search may return the modified entry). So this may not be a problem for transaction support.

### SLAPI changes

We will provide slapi\_txn\_begin, slapi\_txn\_commit, and slapi\_txn\_abort, which will be mostly just wrappers around dblayer\_txn\_begin, dblayer\_txn\_commit, and dblayer\_txn\_abort. This will allow plugins to create their own transactions. For example, an extended operation plugin may want to create a transaction to perform several operations.

### Flow

When the server receives the Start TXN Request, it will lock the database, create a new database transaction object, create a new, unique TXNID, and return the TXNID to the client.

When the server receives an operation with the transaction control with a valid TXNID, the server will store the operation in a list of operations for that transaction, store the transaction information in the pblock for the operation, and set a flag in the transaction information for the operation to indicate that this is the UNCOMMITTED phase. The server code knows this flag means to perform only those actions necessary to be done before the transaction is committed. Nested internal operations will also use the same transaction and phase.

When the server receives the End TXN request, it will commit the transaction in the database. Then it will loop through each of the saved operations, performing them again, this time with the flag set to COMMITTED.

### Transaction object

The transaction object contains fields for the transaction ID, the backend transaction structure, and a list of operations performed for this transaction.

The transaction ID can be 64-bit monotonic number.

### Connection

The connection will be extended with a field for the transaction object for the currently open transaction.

### Nested Operations

Internal operations must specify the transaction of the "parent" operation. We will have to extend the plugin API to allow for this extra data.

### Flow

|Client|Server front end|Server back end|
|------|----------------|---------------|
|send start TXN -\>|receive start TXN||
||request TXN-\>|lock database|
||get TXN|\<- create TXN|
||store TXN in connection||
|receive TXN resp|\<-start TXN response|
||

Initial Investigation
=====================

As part of the [Move\_changelog](../howto/howto-move-changelog.html) work to allow the changelog writes to use the same transaction as the main database, the code was converted.

Performance
-----------

For referential integrity, I observed that there were two fdatasync() calls. The internal referint call to modify the group entry calls id2entry\_add() at line 443 of ldbm\_modify.c. This eventually calls db-\>put (where db is the id2entry db), and this eventually calls fdatasync(). The reason is explained at this post [here](https://forums.oracle.com/forums/message.jspa?messageID=9433858#9433858) in the Oracle Berkeley DB forum.

Something about the fact that we are updating an overflow page, and bdb is going to truncate the log, and the overflow page is the last page, so it has to flush (by calling fdatasync()) the log so that it can give the page back to the OS. I'm not sure how to control this behavior - setting nsslapd-db-logbuf-size did not seem to make a difference.

