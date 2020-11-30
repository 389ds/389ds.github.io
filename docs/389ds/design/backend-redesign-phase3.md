---
title: "Database Backend Redesign - Phase 3"
---

# Database Backend Redesign - Phase 3
-------------------------------------

{% include toc.md %}

Status
==========
Date: 2020 Nov, 26th
Staus: Draft 
Tickets: [https://issues.redhat.com/browse/IDMDS-302](https://issues.redhat.com/browse/IDMDS-302)

Motivation
==========

See [backend redesign (initial phases)](https://www.port389.org/docs/389ds/design/backend-redesign.html)

High level summary
==================

See [https://www.port389.org/docs/389ds/design/backend-redesign.html backend redesign (initial phases)]

This document is describing next phases of the 389 Directory Server changes needed to:
* remove hard dependency to the underlying database.
* offer an API that allow to use database implementation plugin
This document focus on:
* the removal of <libdb/db.h> dependency within the backend and replication plugins
* the dbimpl API: that interface the database implementation plugins (and is used by the dblayer interface)

Current state
=============

Part of the changes are already pushed in the upstream branch. 

( The plugin implementation and most dblayer wrapper are already coded)

The dependency that remains are:

* References to the Berkeley Database include (i.e &lt;libdb/db.h&gt;) types and data and macros.<br />
They are spread among the backend and replication changelog code while only bdb plugin should use it.
* Some of the code specific to bdb implementation needs to be moved inside the bdb plugin

(typically the part of the database monitoring code that gather the statistics and reset them)

<ul>
<li>Error code handling and logging. Should find a way to get it independent of the database implementation while still be able to provide relevant data in case of unexpected trouble</li>
<li><p>Some of the code use bdb feature that are not available on the other databases:</p>
<ul>
<li><blockquote><p>Dblayer_in_import checks the presence of a db region to detect that an import is running. An implementation agnostic method should be used instead.</p></blockquote></li>
<li><blockquote><p>VLV uses record number - the bad thing is that they are propagated up to the VLV ldap request<br />
(it relates to the index and contentCount within the VLV control)<br />
⇒ not sure we can handle that as efficiently than with BDB (so far the only method i am able to think about is to set the cursor on first record then “move it to next” n times )<br />
The only data that is available is the total number of records. (which is also needed for vlv)</p></blockquote></li></ul>
</li></ul>


<ul>
<li><blockquote><p>Have a database implementation plugin API instead of direct reference to berkeley db components</p></blockquote></li></ul>

<blockquote>Note: part of this is already implemented: 
</blockquote>
When initializing the dblayer API, the value of nsslapd-backend-implement configuration parameter is used to load *value* plugin then to call *value*_init function that fills a set of callbacks in li-&gt;priv.

<ul>
<li><blockquote><p>Implements bdb plugin (over Berkeley Database) to allow a smooth transition</p></blockquote></li>
<li><blockquote><p>Implements lmdb plugin (over LMDB Database) </p></blockquote></li>
<li><blockquote><p>Remove bdb plugin after a transition period.</p></blockquote></li></ul>

<span id="anchor-10"></span>This document scope

This document scope is about finishing the work about point 1) and 2) already started by ludwig:

* rename the BDB types and definitions that are used widely in the backend and replication code.<br />
(Although we could keep current names, that would be quite confusing for code readers)

This should be done in a separate commit (using temporary #define wrapper to remap the new back to libdb) to simplify the reviewer job (it is plain sed substitution that impacts most backend and replication changelog source files. So it is better to keep it separate from the real changes) 

<ul>
<li><p>move the monitoring statistics in bdb plugin and add wrapper at dblayer level</p>
<ul>
<li><blockquote><p>perfctrs_update should be moved in bdb and wrapper added</p></blockquote></li>
<li><blockquote><p>perfctrs_terminate: should be split: memory cleanup should stay at backend level but statistics should be clear at bdb plugin level</p></blockquote></li></ul>
</li></ul>

this will also allow to get rid of the dblayer_db_uses_* functions that checks for existing feature

<ul>
<li><p>remove old macros in dblayer that are already useless:</p>
<ul>
<li><blockquote><p>DB_OPEN</p></blockquote></li>
<li><blockquote><p>TXN_BEGIN</p></blockquote></li>
<li><blockquote><p>TXN_COMMIT</p></blockquote></li>
<li><blockquote><p>TXN_ABORT</p></blockquote></li>
<li><blockquote><p>TXN_CHECKPOINT</p></blockquote></li>
<li><blockquote><p>MEMP_STAT</p></blockquote></li>
<li><blockquote><p>MEMP_TRICKLE</p></blockquote></li>
<li><blockquote><p>LOG_ARCHIVE</p></blockquote></li>
<li><blockquote><p>LOG_FLUSH</p></blockquote></li></ul>
</li></ul>

* Dblayer_in_import: replace the check about db region by something else<br />
(I am thinking about using a file lock in the backend directory instead. No real reason to rely on the db architecture to know whether an import process is running) 
* 



<span id="anchor-11"></span>API

Include file: dbimpl.h

<span id="anchor-12"></span>Struct typedef



{|
| 'Name'
| 'Role'
| 'Opaque'
| 'Old bdb name'
|-
| DBI_ENV
| The global environment
| PseudoOpaque<sup>(1)</sup>
| DB_ENV
|-
| DBI_DB
| A database instance
| PseudoOpaque<sup>(1)</sup>
| DB
|-
| DBI_TXN
| A transaction
| Yes<sup>(3)</sup>
| DB_TXN
|-
| DBI_CURSOR
| A cursor (i.e: iterator on DB data)
| PseudoOpaque<sup>(1)</sup>
| DBC
|-
| DBI_DATA
| A key or a value
| No
| DBT
|-
| DBI_BULK_DATA
| A set of keys or values
| No
| DBT
|-
| DBI_CB
| Contains all DB implementation callbacks
| No
| N/A
|}





<sup>(1) </sup>DB_ENV is used as opaque struct except dbenv-&gt;get_open_flags that is used in db_uses_feature that should be moved in bdb plugin anyway

<sup>(2) </sup>already used as an opaque struct



PseudoOpaque type are:

Typedef struct {

DBI_CB *cb;The callbacks

Void *&lt;name&gt;;The implementation opaque struct (name is env,db or cursor)

Void *plg_ctx;A context that implementation plugin is free to use. (may be not needed)

} PseudoOpaque



 They are used because the code sometime use function that only have access to underlying element

 And not the upper layer context (i.e cursor without backend or li_instance)<br />


Typedef struct {

long reserved[5];<br />
} DBI_RESERVED;/* Some memory reserved for the implementation plugin to avoid malloc/free

                                       Should be large enough to store a bdb DBT */



typedef struct {

DBI_MEM_OPTION flags; 

void *data;

size_t size;

struct {

long reserved[5];

}

} DBI_DATA;



typedef struct {

Void (*init)(void);/* Reset the block of values iterator */ 

Int (*next)(void);/* Set data 

Void (*end)(void);/* Release Resources */<br />
DBI_DATA data;

Void *ctx;/* Implementation dependant context */

} DBI_BULK_DATA;



typedef struct {

        struct DBI_CB *cb;

        void *cursor;

} DBI_CURSOR;

<span id="anchor-13"></span>Enum values

<span id="anchor-14"></span>Cursor actions: DBI_ACTION



{|
| 'Name'
| 'Role'
| 'Old bdb function'
| 'Old bdb value'
|-
| DBI_ACT_MOVE_EQ_EQ
| Move cursor to key+value record
| c_get
| DB_GET_BOTH
|-
| DBI_ACT_MOVE_EQ_GE
| Move cursor to key+valueB such as valueB is the smallest value greater or equal to the specified value
| c_get
| DB_GET_BOTH_RANGE
|-
| DBI_ACT_GET_RECNO
| Get current record number.
| c_get
| DB_GET_RECNO
|-
| DBI_ACT_LAST
| Move cursor to last record then get it.
| c_get
| DB_LAST
|-
| DBI_ACT_NEXT
| Move cursor to next record then get it.
| c_get
| DB_NEXT
|-
| DBI_ACT_NEXT_EQ
| Move cursor to next record having the same key then get it.
| c_get
| DB_NEXT_DUP
|-
| DBI_ACT_NEXT_NE
| Move cursor to next record having different key then get it.
| c_get
| DB_NEXT_NODUP
|-
| DBI_ACT_PREV
| Move cursor to previous record then get it.
| c_get
| DB_PREV
|-
| DBI_ACT_MOVE_EQ
| Move cursor to first record having the key and get its value
| c_get
| DB_SET
|-
| DBI_ACT_MOVE_GE
| Move cursor to smallest record having a key greater or equal than the specified one. Then it gets the record
| c_get
| DB_SET_RANGE
|-
| DBI_ACT_MOVE_RECNO
| Move record to specified record number then get it.
| c_get
| DB_SET_RECNO
|-
| 
| 
| 
| 
|-
| 
| 
| 
| 
|-
| DBI_ACT_PUT_VALUE
| Overwrite current position value
| c_put
| DB_CURRENT
|-
| DBI_ACT_PUT_UNIQUE_REC
| Insert new key-data if it does not alreadyb exists
| c_put
| DB_NODUPDATA
|-
| DBI_ACT_DEL
| Delete current key-data
| c_del
| 0
|-
| DBI_ACT_CLOSE
| Close cursor
| c_close
| N/A
|-
| 
| 
| 
| 
|}



Cursor bulk action: DBI_BULK_ACTION

{|
| DBI_BULKACT_NEXT
| Get next block of records
| c_get
|
DB_NEXT_DUP | DB_MULTIPLE

Or<br />
DB_NEXT_DUP | DB_MULTIPLE_KEY
|-
| DBI_BULKACT_MOVE
| Get block of records
| c_get
| DB_SET | DB_MULTIPLE<br />
Or<br />
DB_SET | DB_MULTIPLE_KEY
|}



<span id="anchor-15"></span>Value handling options



{|
| 'Name'
| 'Role'
| 'Old bdb value'
|-
| DBI_MEM_USER
| Tell plugin to neither alloc nor free the memory
| DB_DBT_USERMEM
|-
| DBI_MEM_MALLOC
| Tell impl plugin to alloc and free the memory
| DB_DBT_MALLOC
|-
| DBI_MEM_REALLOC
| Tell impl plugin to reuse or realloc the memory
| DB_DBT_REALLOC
|}





Return codes



{|
| 'Name'
| 'Role'
| 'Old bdb value'
|-
| DBI_RC_NOMEM
| Memory allocation error<br />
(usually it does not happen because slapi_ch_malloc cannot returns NULL)
| DB_BUFFER_SMALL
|-
| DBI_RC_KEYEXIST
| Key exists and duplicate keys are not allowed.
| DB_KEYEXIST
|-
| DBI_RC_RETRY
| Transient error: operation should be retried.
| DB_LOCK_DEADLOCK
|-
| DBI_RC_NOTFOUND
| Record not found: Key does not exists.
| DB_NOTFOUND
|-
| DBI_RC_RUNRECOVERY
| Recovery must be performed.
| DB_RUNRECOVERY
|-
| DBI_RC_SUCCESS
| No error
| 0
|-
| DBI_RC_OTHER
| Other database errors
| N/A
|}



<span id="anchor-16"></span>Callbacks

  (TODO: get the callback name and prototype from dblayer.h and put them in this document to have the full API

     Which will be useful when writing the ldbm plugin for example)



Special macro must be implemented as call back 

* DB_MULTIPLE_INIT
* DB_MULTIPLE_NEXT
* 

{|
| 'Name'
| 'Role'
| 'Old bdb value'
|-
| 
| 
| cursor-&gt;c_get
|-
| 
| 
| cursor-&gt;c_put
|-
| 
| 
| cursor-&gt;c_del
|-
| dblayer_
| 
| cursor-&gt;c_close
|-
| bulk_data-&gt;init()
| 
|
|-
| bulk_data-&gt;next(bulk_data,key,value)
| 
|
|-
| dblayer_new_cursor(be,db,txn, cursor)
| Should store the backend in cldb_Handle to retrieve it.
| db-&gt;cursor(db, db_txn, &amp;cursor, 0);
|-
| 
| 
| 
|-
|
Dblayer_cursor_perform_action
| 
| 
|-
| Dblayer_cursor_perform_bulk_action_eq
| 
| 
|-
| Dblayer_cursor_perform_bulk_action
| 
| 
|-
| Dblayer_perform_action
| 
| db-&gt;put , db-&gt;get,db-&gt;del
|-
| dblayer_get_db_id
| 
| db-&gt;fname
|-
| 
| 
| 
|}

* 



I wonder if we should keep the callback definition. at the dblayer level.

 IMHO it should be better to define a callback struct in dbimpl.h 

That we refer (through a pointer or through a copy)

That allows to define a static callback struct in the plugin rather than explicitly set every callbacks in init function. 



<span id="anchor-17"></span>Cursor API

Since current code call directly bdb callbacks from cursor ⇒ the cursor handling must be rewritten

Note: As some function have only the DBC (and not the upper level abstraction like be nor li_instance ⇒

       we should be able to retrieve the callbacks from the cursor ⇒ Cannot use directly the implementation cursor

      ⇒ Must encapsulate it.



Dblayer_cursor_perform_action(DBI_CURSOR *cur, DBI_ACTION action, DBI_DATA *key, DBI_DATA *val)

Dblayer_cursor_perform_bulk_action_eq(DBI_CURSOR *cur, DBI_ACTION action, DBI_DATA *key, DBI_BULK_DATA *val)

Dblayer_cursor_perform_bulk_action(DBI_CURSOR *cur, DBI_ACTION action, DBI_BULK_DATA *key, DBI_BULK_DATA *val)

<span id="anchor-18"></span>Specific points:

<span id="anchor-19"></span>Cursor Handling

<s>In propose to use the same definition than bdb for the following:</s>

* <s>DBI_REC</s>
* <s>Cursor actions</s>
* <s>Value handling options</s>

<s>( To avoid having to change the code )</s>

<span id="anchor-20"></span>Alternatives

* Redesign the cursor handling code (no sure that ldbm supports bulk operation when reading data)

<span id="anchor-21"></span>Error handling

<span id="anchor-22"></span>Proposed solution

* Remap the errors to generic values
* Add a function in bdb that remap the value (should be a simple switch)<br />
If the value cannot be mapped:<br />
   add a string in thread local storage and return DBI_RC_OTHER<br />
   The string should contains the original return code and its associated message (i.e:<br />
bdb error code: %d : %s&quot;, native_rc, db_strerror(native_rc))
* Modify dblayer_strerror to print a message for generic errors and if DBI_RC_OTHER to generate a message from the thread local data string.

<ul>
<li><blockquote><p>This solution has the advantage that:</p></blockquote>
<ul>
<li>it does not impact the back-ldm/changelog code (except for dblayer_strerror) </li>
<li>It is quite efficient in the usual case as it handles a switch with few values</li>
<li>Keep the ability to diagnose errors in the unexpected case</li></ul>
</li>
<li><blockquote><p>The drawbacks:</p></blockquote>
<ul>
<li>Message can be wrong if creative error handling is performed (i.e </li></ul>
</li></ul>

          rc1 = dblayer_xxx(li, ...)

          rc2 = dblayer_xxx(li, ...)

          log(dblayer_strerror(rc1)) prints rc2 message if both values are are DBI_RC_OTHER)<br />
Should double check that when hitting unexpected errors we just logs an error message and aborts the operation (as it is possible that we abort the txn before logging the errr)

* ** Error handling should be done in the same thread than the operation (This is IMHO the case)

<span id="anchor-23"></span>Alternatives

* I thought about keeping the db code as it, but then it implies a lot of changes as we need to access the db plugin to determine what action to do or to log the error. (but the dblayer instance context is not always easily available when the message is logged) 
* Same as proposed solution but without storing data in thread local storage: problem is that we got clueless in case of unexpected database error. (unless an error message is logged by the plugin )<br />
Hum that may be the better solution ...

<span id="anchor-24"></span>Action Plan

The task to do in order to migrate to the new idea.

<span id="anchor-25"></span>Open Questions

<ol style="list-style-type: decimal;">
<li><p>API name ?</p>
<ol style="list-style-type: lower-alpha;">
<li><blockquote><p> dbimpl ? </p></blockquote></li>
<li><blockquote><p>gdb ? </p></blockquote></li>
<li><blockquote><p>gendb ?<br />
(IMHO these 2 last names (For generic database) are confusing)</p></blockquote></li>
<li><blockquote><p>Plgdb ? (plugable database)</p></blockquote></li></ol>
</li>
<li><p>Typedef name format ?</p>
<ol style="list-style-type: lower-alpha;">
<li><blockquote><p>&lt;PREFIX&gt;_&lt;NAME&gt;</p></blockquote></li>
<li><blockquote><p>&lt;prefix&gt;_&lt;name&gt;_t</p></blockquote></li></ol>
</li></ol>



 



