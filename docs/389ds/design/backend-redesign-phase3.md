---
title: "Database Backend Redesign - Phase 3"
---

# Database Backend Redesign - Phase 3
-------------------------------------

{% include toc.md %}

Status
==========
Date: 2020 Nov, 26th

Staus: Mostly Implemented

Tickets: [https://issues.redhat.com/browse/IDMDS-302](https://issues.redhat.com/browse/IDMDS-302)

Motivation
==========

See [backend redesign (initial phases)](https://www.port389.org/docs/389ds/design/backend-redesign.html)

High level summary
==================

This document is the continuation of ludwig's work about Berkeley database removal.
[backend redesign (initial phases)](https://www.port389.org/docs/389ds/design/backend-redesign.html)

It focus on:

* the removal of <libdb/db.h> dependency within the backend and replication plugins
* the dbimpl API: that interface the database implementation plugins (and is used by the dblayer interface)

Current state
=============

* Phase 3a: pushed in upstream bramch
* Phase 3b: under review
* Phase 3c: Coded but need rebase and review once phase 3b is done
* Phase 3d: Cancelled - we keep the db plugin implementation within libback-ldbm for now 
* Phase 3e: Coded but need rebase and review once phase 3b is done


### Specific issues (solved in this phase) ###
* dblayer\_log\_print ==> must be moved in implementation dependant plugin ==> should remove the callback
* Values compare call back ==> must be moved in implementation dependant plugin as they works directly on db values
    * idl\_new\_compare\_dups -
    * entryrdn\_compare\_dups
* Same with compare key callback ????
* Should also move use of DBTcmp within the db-bdb plugin 
* References to the Berkeley Database include (i.e &lt;libdb/db.h&gt;) types and data and macros.<br />
      They are spread among the backend and replication changelog code while only bdb plugin should use it.
* Some of the code specific to bdb implementation needs to be moved inside the bdb plugin
      (typically the part of the database monitoring code that gather the statistics and reset them)
	* Error code handling and logging. Should find a way to get it independent of the database implementation while still be able to provide relevant data in case of unexpected trouble
      (Common errors are handled by dbimpl API - unusual errors are logged within the db plugin )

	* removal of bdb specific features that are not available on the other databases:
	* dblayer\_in\_import checks the presence of a db region to detect that an import is running. An implementation agnostic method should be used instead.
        * Note: if fact according to my test (longduration/db_protect_long_test.py) this check is useless and could be removed safely.
	* VLV uses record number.
	  The only numer that we have is the one of the last record.
	  The bad thing is that they are propagated up to the VLV ldap request. (it relates to the index and contentCount within the VLV control)
not sure we can handle that as efficiently than with BDB (so far the only methods i am able to think about are:
		* skip to next cursor n times
		* build the complete idl and use the idl index counter
	* Have a database implementation plugin API instead of direct reference to berkeley db components. Note: part of this is already implemented:

* rename the BDB types and definitions that are used widely in the backend and replication code.
(Although we could keep current names, that would be quite confusing for code readers)
This should be done in a separate commit (using temporary #define wrapper to remap the new back to libdb) to simplify the reviewer job (it is plain sed substitution that impacts most backend and replication changelog source files. So it is better to keep it separate from the real changes)
* move the monitoring statistics in bdb plugin and add wrapper at dblayer level
      * perfctrs\_update should be moved in bdb and wrapper added
      * perfctrs\_terminate: should be split: memory cleanup should stay at backend level but statistics should be clear at bdb plugin level. This will also allow to get rid of the dblayer\_db\_uses\_* functions that checks for existing feature
      * remove old macros in dblayer that are already useless:
         * DB\_OPEN
         * TXN\_BEGIN
         * TXN\_COMMIT
         * TXN\_ABORT
         * TXN\_CHECKPOINT
         * MEMP\_STAT
         * MEMP\_TRICKLE
         * LOG\_ARCHIVE
         * LOG\_FLUSH

* dblayer\_in\_import: replace the check about db region by something else
(I am thinking about using a file lock in the backend directory instead. No real reason to rely on the db architecture to know whether an import process is running)
* Note: There are some work to do about the transaction handling:
	    * Need a read txn for read operation while in bdb most read operation were transactionless
    * Need to remove recursive transaction handling (or at least handle them explicitly as nested when creating/commiting/aborting
          because lmdb does not support nested txn (so nested txn will be the parent txn and the commit/abort of nested txn should do nothing)

## VERY HIGH LEVEL API ##

dbimpl API is part of libback-ldbm and
dbimpl API users needs to include dbimpl.h and link with libback-ldbm 

When initializing the dblayer API (or when requesting a private access to a file), the value of nsslapd-backend-implement configuration parameter is used to call *value*\_init function (within libback-ldbm) that fills a set of callbacks in li-\>priv.

## API ##

Include file: dbimpl.h

### struct typedef ###

| Name | Role | Opaque | Old bdb name
|-|-|-|-
| dbi\_env\_t | The global environment | PseudoOpaque<sup>(1)</sup> | DB\_ENV
|---
| dbi\_db\_t | A database instance | PseudoOpaque<sup>(1)</sup> | DB
|---
| dbi\_txn\_t | A transaction | Yes<sup>(3)</sup> | DB\_TXN
|---
| dbi\_cursor\_t | A cursor (i.e: iterator on DB data) | PseudoOpaque<sup>(1)</sup> | DBC
|---
| dbi\_data\_t | A key or a value | No | DBT
|---
| dbi\_cb\_t | Contains all DB implementation callbacks | No | N/A


<sup>(1) </sup>DB\_ENV is used as opaque struct except dbenv-&gt;get\_open\_flags that is used in db\_uses\_feature that should be moved in bdb plugin anyway

<sup>(2) </sup>already used as an opaque struct

PseudoOpaque type are:
	Typedef struct {
		DBI\_CB *cb;The callbacks
		void *&lt;name&gt;;The implementation opaque struct (name is env,db or cursor)
		void *plg\_ctx;A context that implementation plugin is free to use. (may be not needed)
	} PseudoOpaque

They are used because the code sometime use function that only have access to underlying element
And not the upper layer context (i.e cursor without backend or li\_instance)<br />


	typedef struct {
        DBI\_CB *cb;
		DBI\_MEM\_OPTION flags;
		void *data;
		size\_t size;
		void *ctx;						/* Context handled by db implementation plugin */
	} DBI_DATA;

	typedef struct {
		struct DBI\_CB *cb;
		void *cursor;
	} DBI_CURSOR;

### Enum values ###

*DBI\_OP* /* Represents a cursor operation */

| 'Name' | 'Role' | 'Old bdb function' | 'Old bdb value'
|-
| DBI\_OP\_MOVE\_TO\_KEY | Move cursor to first record having the key and get its value | c\_get | DB\_SET
|-
| DBI\_OP\_MOVE\_NEAR\_KEY | Move cursor to record having smallest key greater or equal than the specified one. Then it gets the record | c\_get | DB\_SET\_RANGE
|-
| DBI\_OP\_MOVE\_TO\_DATA | Move cursor to key+value record | c\_get | DB\_GET\_BOTH
|-
| DBI\_OP\_MOVE\_NEAR\_DATA | Move cursor to record having specified key and smallest data greater or equal than the specified data and get the value| c\_get | DB\_GET\_BOTH\_RANGE
|-
| DBI\_OP\_MOVE\_TO\_RECNO | Move record to specified record number then get it.  | c\_get | DB\_SET\_RECNO
|-
| DBI\_OP\_MOVE\_TO\_FIRST | Move cursor to first record then get it.  | c\_get | DB\_FIRST
|-
| DBI\_OP\_MOVE\_TO\_LAST | Move cursor to last record then get it.  | c\_get | DB\_LAST
|-
| DBI\_OP\_GET | Get current record number.  | get | DB\_GET
|-
| DBI\_OP\_GET\_RECNO | Get current record number.  | c\_get | DB\_GET\_RECNO
|-
| DBI\_OP\_NEXT | Move cursor to next record then get it.  | c\_get | DB\_NEXT
|-
| DBI\_OP\_NEXT\_DATA | Move cursor to next record having the same key then get the value.  | c\_get | DB\_NEXT\_DUP
|-
| DBI\_OP\_NEXT\_KEY | Move cursor to next record having different key then get the record.  | c\_get | DB\_NEXT\_NODUP
|-
| DBI\_OP\_PREV | Move cursor to previous record then get it.  | c\_get | DB\_PREV
|-
| DBI\_OP\_PUT | Insert new key-data | put | DB\_PUT
|-
| DBI\_OP\_REPLACE | Overwrite current position value | c\_put | DB\_CURRENT
|-
| DBI\_OP\_ADD | Insert new key-data if it does not already exists | put | DB\_NODUPDATA
|-
| DBI\_OP\_ADD | Insert new key-data if it does not already exists | c\_put | DB\_NODUPDATA
|-
| DBI\_OP\_DEL | Delete key-data record | del | 0
|-
| DBI\_OP\_DEL | Delete record at cursor position | c\_del | 0
|-
| DBI\_OP\_CLOSE | Close cursor | c\_close | N/A
|-

*dbi_val_t flags*

| Name | Role | Berkeley db flags |
|-
|0|data should be alloc or realloc|DB_DBT_MALLOC (if data is NULL) or DB_DBT_REALLOC|
|-
|DBI_VF_PROTECTED|data should not be freed||
|-
|DBI_VF_DONTGROW|data should not be realloced|N/A|
|-
|DBI_VF_DONTGROW+DBI_VF_PROTECTED|data should not be realloced|DB_DBT_USERMEM|
|-
|DBI_VF_READONLY|data should not be modified|DB_DBT_READONLY|

*dbi_val_t flags to DBT flags mapping*

| 'dbi_val_t' | 'DBT' |
|-
|0|DB_DBT_MALLOC ( or DB_DBT_REALLOC|
|-
|DBI_VF_PROTECTED|data should not be freed|


*dbi_bulk_t flags*

| Name | Role |
|-
|DBI_VF_BULK_DATA|Bulk operation on data only|
|-
|DBI_VF_BULK_RECORD|Bulk operation on key+data|


*error codes*

| Name | Role | Old bdb value
|-
| DBI\_RC\_SUCCESS | No error | 0
|-
| DBI\_RC\_NOMEM | Memory allocation error<br /> (usually it does not happen because slapi\_ch\_malloc cannot returns NULL) | DB\_BUFFER\_SMALL
|-
| DBI\_RC\_KEYEXIST | Key exists and duplicate keys are not allowed.  | DB\_KEYEXIST
|-
| DBI\_RC\_RETRY | Transient error: operation should be retried.  | DB\_LOCK\_DEADLOCK
|-
| DBI\_RC\_NOTFOUND | Record not found: Key does not exists.  | DB\_NOTFOUND
|-
| DBI\_RC\_RUNRECOVERY | Recovery must be performed.  | DB\_RUNRECOVERY
|-
| DBI\_RC\_OTHER | Other database errors | N/A

Note: the implementation plugin should log an error with error code and error text when getting an error that cannot be mapped
  ( To ease diagnostic in case of unexpected error )



### Callbacks ###

  (TODO: get the callback name and prototype from dblayer.h and put them in this document to have the full API

| Name | Role | Old bdb value
|-
| dblayer\_start\_fn\_t *dblayer\_start\_fn ||
|-
| dblayer\_close\_fn\_t *dblayer\_close\_fn ||
|-
| dblayer\_instance\_start\_fn\_t *dblayer\_instance\_start\_fn ||
|-
| dblayer\_backup\_fn\_t *dblayer\_backup\_fn ||
|-
| dblayer\_verify\_fn\_t *dblayer\_verify\_fn ||
|-
| dblayer\_db\_size\_fn\_t *dblayer\_db\_size\_fn ||
|-
| dblayer\_ldif2db\_fn\_t *dblayer\_ldif2db\_fn ||
|-
| dblayer\_db2ldif\_fn\_t *dblayer\_db2ldif\_fn ||
|-
| dblayer\_db2index\_fn\_t *dblayer\_db2index\_fn ||
|-
| dblayer\_cleanup\_fn\_t *dblayer\_cleanup\_fn ||
|-
| dblayer\_upgradedn\_fn\_t *dblayer\_upgradedn\_fn ||
|-
| dblayer\_upgradedb\_fn\_t *dblayer\_upgradedb\_fn ||
|-
| dblayer\_restore\_fn\_t *dblayer\_restore\_fn ||
|-
| dblayer\_txn\_begin\_fn\_t *dblayer\_txn\_begin\_fn ||
|-
| dblayer\_txn\_commit\_fn\_t *dblayer\_txn\_commit\_fn ||
|-
| dblayer\_txn\_abort\_fn\_t *dblayer\_txn\_abort\_fn ||
|-
| dblayer\_get\_info\_fn\_t *dblayer\_get\_info\_fn ||
|-
| dblayer\_set\_info\_fn\_t *dblayer\_set\_info\_fn ||
|-
| dblayer\_back\_ctrl\_fn\_t *dblayer\_back\_ctrl\_fn ||
|-
| dblayer\_get\_db\_fn\_t *dblayer\_get\_db\_fn ||
|-
| dblayer\_delete\_db\_fn\_t *dblayer\_delete\_db\_fn ||
|-
| dblayer\_rm\_db\_file\_fn\_t *dblayer\_rm\_db\_file\_fn ||
|-
| dblayer\_import\_fn\_t *dblayer\_import\_fn ||
|-
| dblayer\_load\_dse\_fn\_t *dblayer\_load\_dse\_fn ||
|-
| dblayer\_config\_get\_fn\_t *dblayer\_config\_get\_fn ||
|-
| dblayer\_config\_set\_fn\_t *dblayer\_config\_set\_fn ||
|-
| instance\_config\_set\_fn\_t *instance\_config\_set\_fn ||
|-
| instance\_config\_entry\_callback\_fn\_t *instance\_add\_config\_fn ||
|-
| instance\_config\_entry\_callback\_fn\_t *instance\_postadd\_config\_fn ||
|-
| instance\_config\_entry\_callback\_fn\_t *instance\_del\_config\_fn ||
|-
| instance\_config\_entry\_callback\_fn\_t *instance\_postdel\_config\_fn ||
|-
| instance\_cleanup\_fn\_t *instance\_cleanup\_fn ||
|-
| instance\_create\_fn\_t *instance\_create\_fn ||
|-
| instance\_create\_fn\_t *instance\_register\_monitor\_fn ||
|-
| instance\_search\_callback\_fn\_t *instance\_search\_callback\_fn ||
|-
| dblayer\_auto\_tune\_fn\_t *dblayer\_auto\_tune\_fn ||
|-
| dblayer\_cursor\_op(DBI\_CUR *cur, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Move cursor and get record | cursor-&gt;c\_get
|-
| dblayer\_cursor\_op(DBI\_CUR *cur, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Add/replace a record | cursor-&gt;c\_put
|-
| dblayer\_cursor\_op(DBI\_CUR *cur, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Remove a record | cursor-&gt;c\_del
|-
| dblayer\_cursor\_op(DBI\_CUR *cur, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Close a record | cursor-&gt;c\_close
|-
| dblayer\_new\_cursor(be,db,txn, cursor) | Should store the backend in cldb\_Handle to retrieve it.  | db-&gt;cursor(db, db\_txn, &amp;cursor, 0);
|-
| dblayer\_db\_op(DBI\_DB *db, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Move cursor and get record | db-\>get
|-
| dblayer\_db\_op(be, DBI\_DB *db, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Add/replace a record | db-\>put
|-
| dblayer\_db\_op(be, DBI\_DB *db, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Delete a record | db-\>del
|-
| dblayer\_get\_db\_id | | db-&gt;fname
|-
| dblayer\_init\_bulk\_op(DBI\_DATA *bulk) | Initialize iterator for bulk operation | DB\_MULTIPLE\_INIT |
|-
| dblayer\_next\_bulk\_op(DBI\_DATA *bulk, DBI\_DATA *key, DBI\_DATA *data) | Get next operation from bulk operation | DB\_MULTIPLE\_NEXT |

## db-bdb plugin  ##

That is the plugin that implements the dbimpl API callbacks and calls libdb functions. The important points are:
* DBT versus dbi_var_t handling.
    * Typical data handing for most db operation is:
    <PRE>
    bdb_dbival2dbt(key, &bdb_key, PR_FALSE);   /* Convert dbi_val_t to DBT before the libdb call */
    bdb_dbival2dbt(data, &bdb_data, PR_FALSE);
    rc=some_native_libdb_function(..., &bdb_key, &bdb_data, ...);
    bdb_dbt2dbival(&bdb_key, key, PR_TRUE);    /* Convert back the DBT to dbi_val after the libdb call */
    bdb_dbt2dbival(&bdb_data, data, PR_TRUE);
    return bdb_map_error(__FUNCTION__, rc);
    </PRE>

    * When calling backend function from the plugin (with DBT values):
    <PRE>
    bdb_dbt2dbival(&key, &dbikey, PR_FALSE);
    idl = idl_fetch(be, db, &dbikey, NULL, NULL, &ret);
    bdb_dbival2dbt(&dbikey, &key, PR_TRUE);
    </PRE>

Note: In both case <I>isresponse</I> is set to PR_FALSE before the operation and PR_TRUE after it.
if a key or data get alloced/realloced, the original key/data get freed (if the value flags allows it)

* dup_cmp_fn callback
As these callbacks are directly called within libdb (i.e using DBT)
they have been moved within the dnb-bdb plugin and rather than directly
setting the callback in upper layer, there is a dbimpl function to set some
specific function.

* bdb_map_error function
  convert some well known error to the DBI counterpart.
  for other error a generic value is returned after having logged
  the bdb native error.

* value handling:



## Alternatives ##

* Redesign the cursor handling code:
	* (no sure that ldbm supports bulk operation when reading data)
	* (quite sure that ldbm does not support the recno)


* Error handling:

Proposed solution

    * Solution 1
        * Remap the errors to generic values
        * Add a function in bdb that remap the value (should be a simple switch)
If the value cannot be mapped we could:
            * add a string in thread local storage and return DBI\_RC\_OTHER
The string should contains the original return code and its associated message (i.e: bdb error code: %d : %s&quot;, native\_rc, db\_strerror(native\_rc))
            * Modify dblayer\_strerror to print a message for generic errors and if DBI\_RC\_OTHER to generate a message from the thread local data string.
    * This solution has the advantage that:
	        * it does not impact the back-ldm/changelog code (except for dblayer\_strerror)
	        * It is quite efficient in the usual case as it handles a switch with few values
	        * Keep the ability to diagnose errors in the unexpected case
        * The drawbacks:
            * Message can be wrong if creative error handling is performed (i.e
<PRE>
          rc1 = dblayer\_xxx(li, ...)
          rc2 = dblayer\_xxx(li, ...)
          log(dblayer\_strerror(rc1)) prints rc2 message if both values are are DBI\_RC\_OTHER)<br />
</PRE>
Should double check that when hitting unexpected errors we just logs an error message and aborts the operation (as it is possible that we abort the txn before logging the errr)

            * Error handling should be done in the same thread than the operation (This is IMHO the case)

    * Solution 2
I thought about keeping the db code as it, but then it implies a lot of changes as we need to access the db plugin to determine what action to do or to log the error. (but the dblayer instance context is not always easily available when the message is logged)
    * Solution 3
Same as solution 1 but without storing data in thread local storage: problem is that we got clueless in case of unexpected database error. (unless an error message is logged by the plugin 
(Note: that is finally the implemented solution))

* I wondered about API name and though about several names:
	* dbimpl ?   ( That was the chosen name )
	* gdb ?      (confusion with debugger)
	* gendb ?    (confusion with ldap database generation tool)
	* Plgdb ?    (plugable database)
* Typedef name format ?
	* &lt;PREFIX&gt;\_&lt;NAME&gt;
	* &lt;prefix&gt;\_&lt;name&gt;\_t ( That was the chosen format )

* Callback initialization
I wonder if we should keep the callback definition. at the dblayer level.
IMHO it should be better to define a callback struct in dbimpl.h i.e DBI\_CB because:
    * the db implementation plugin should not need to know about the dblayer or backend API
    * That allows to define a static callback struct in the plugin rather than explicitly set every callbacks in init function.
    * the callback could be refered from the data that needs it (like values)

## Open Questions ##

These questions will need to be solved in phase 4.

* VLV and RECNO
	Not an issue for this phase but it will be an issue when writing the lmdb implementation plugin. (i.e Phase4)
    (So far I have no idead how how to implement efficiently the DBI_OP_GET_RECNO (i.e: DB_GET_RECNO) and
      DBI_OP_MOVE_TO_RECNO (i.e DB_SET_RECNO) operation on lmdb

	VLV search the index records by record number bdb is able to do that on btree database but lmdb does not offer this feature.
      The bad thing is that this numbering is directly brought by the VLV LDAP RFC draft so that is not something that we can
        easely change.
    * An idea is to count the records usign cursor next operation.
		( a way to improve thing a bit would be to keep a record number <-> key association in a cache to avoid having
		to recount from the first record every time )<br />
	* Another way would be to build the complete idl list (and keep it in a cache )<br />
	  but the drawback is that entries added between two requests would not be seen.

	I wonder if having vlv index would still then be useful ( maybe only to avoid having to sort the entries )<br />
	(And paged control could also benefit of the chache to avoid having to rebuild the complete request. <br />
* Read transaction support
    ns-slapd do not use read only txn with bdb (read operation are transactionless)
     while lmdb requires them.
    We should determine the txn strategy:
        * Having a single read txn for the whole ldap read operation.
        * Having a read txn for every db read operation (is that efficient ?)
        * Mixed approch: having a read txn for specific functions (like building idl from an index)
    Anyway it is not an issue for this phase (The only concern in phase 3 is that the architecture
    should be flexible enough to easely support that evolution)
My feeling is that in phase 4 we simply use the read txn inside the
  lmdb plugin:
        * generating a read txn for single db operation if no txn is provided
        * generating a read txn for single cursor creation until cursor deletion if no txn is provided
 and copy the db keys and values results in the dbi_val_t buffer (as bdb does with the DBT buffer)
 This is not the most performant but it is fast to implement and it mimick current bdb behavior.
Then once bdb is out we could have a perf improvement phase to boost the read
 operation by using global txn and avoid needing to duplicate the key and values.  (no need to duplicate the data returned by the db as they stays mmaped
until txn is aborted/commited) and offer a better consistency than current model.
But we cannot do it while bdb plugin is still around because of the risk of deadlock and excesive retries on bdb


## Phasing ##

*The phase 3 is about being able to remove the bdb dependencies
(i.e being able to build ns-slapd libbck-ldbm and replication without the bdb include and lib)
Due to the size of these changes (FYI: Phase 3a already impacts 53 files), it seems better to split the phase
in sub phases:
   * phase 3a:
        * Implements dbimpl API in back-ldbm (dbimpl.*h and proto-back-ldbm.h)
        * Implements dbimpl API callbacks in bdb plugin (back-ldbm/db-bdb/bdb_layer.*)
        * Move most of the monitor code in db-bdb (because it contained code to the bdb statistic)
        * Remove Reference to bdb data/cursor/db/txn from back-ldbm/*.[ch] (use the dbimpl API instead).
   * phase 3b:
        * Remove Reference to bdb data/cursor/db/txn from replication-plugin (use the dbimpl API instead).
   * phase 3c:
        * Remove specific depencies to bdb (like the check on db region to determine if an import/backup is in progress in another process).
        * Remove #include <db.h> from dbimpl.h
   * phase 3d:
        * Build and package db-bdb as a separate plugin that is independent of libback-ldbm
   * phase 3e:
        * Remove specific depencies to bdb in dbscan tool (use the dbimpl API instead. That imply to have a parameter to select the db plugin)
        * Remove #include <db.h> from dbimpl.h
* phase 4 is about the lmdb plugin (and maybe some specific tools)
* phase 5 is about the db-bdb plugin removal
* phase 6 Improve the current txn model which is adapted to bdb but not optimum for lmdb.
