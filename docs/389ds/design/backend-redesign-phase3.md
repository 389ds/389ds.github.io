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

This document is the continuation of ludwig's work about Berkeley database removal.
[backend redesign (initial phases)](https://www.port389.org/docs/389ds/design/backend-redesign.html)

It focus on:

* the removal of <libdb/db.h> dependency within the backend and replication plugins
* the dbimpl API: that interface the database implementation plugins (and is used by the dblayer interface)

Current state
=============

Part of the changes are already pushed in the upstream branch. 

( The plugin implementation and most dblayer wrapper are already coded)
When initializing the dblayer API, the value of nsslapd-backend-implement configuration parameter is used to load *value* plugin then to call *value*\_init function that fills a set of callbacks in li-\>priv.


The dependency that remains are:

* References to the Berkeley Database include (i.e &lt;libdb/db.h&gt;) types and data and macros.<br />
They are spread among the backend and replication changelog code while only bdb plugin should use it.
* Some of the code specific to bdb implementation needs to be moved inside the bdb plugin
(typically the part of the database monitoring code that gather the statistics and reset them)
	* Error code handling and logging. Should find a way to get it independent of the database implementation while still be able to provide relevant data in case of unexpected trouble
	* removal of bdb specific features that are not available on the other databases:
	* dblayer\_in\_import checks the presence of a db region to detect that an import is running. An implementation agnostic method should be used instead.
	* VLV uses record number.
	  The only numer that we have is the one of the last record.
	  The bad thing is that they are propagated up to the VLV ldap request. (it relates to the index and contentCount within the VLV control)
not sure we can handle that as efficiently than with BDB (so far the only methods i am able to think about are:
		* skip to next cursor n times
		* build the complete idl and use the idl index counter
	* Have a database implementation plugin API instead of direct reference to berkeley db components. Note: part of this is already implemented: 

## Remaining work ##

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

## API ##

Include file: dbimpl.h

###struct typedef ###

| Name | Role | Opaque | Old bdb name
|-|-|-|-
| DBI\_ENV | The global environment | PseudoOpaque<sup>(1)</sup> | DB\_ENV
|---
| DBI\_DB | A database instance | PseudoOpaque<sup>(1)</sup> | DB
|---
| DBI\_TXN | A transaction | Yes<sup>(3)</sup> | DB\_TXN
|---
| DBI\_CURSOR | A cursor (i.e: iterator on DB data) | PseudoOpaque<sup>(1)</sup> | DBC
|---
| DBI\_DATA | A key or a value | No | DBT
|---
| DBI\_BULK\_DATA | A set of keys or values | No | DBT
|---
| DBI\_CB | Contains all DB implementation callbacks | No | N/A


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

*DBI\_OPERATION* /* Represents a cursor operation */

| 'Name' | 'Role' | 'Old bdb function' | 'Old bdb value'
|-
| DBI\_OP\_MOVE\_EQ\_EQ | Move cursor to key+value record | c\_get | DB\_GET\_BOTH
|-
| DBI\_OP\_MOVE\_EQ\_GE | Move cursor to key+valueB such as valueB is the smallest value greater or equal to the specified value | c\_get | DB\_GET\_BOTH\_RANGE
|-
| DBI\_OP\_GET\_RECNO | Get current record number.  | c\_get | DB\_GET\_RECNO
|-
| DBI\_OP\_LAST | Move cursor to last record then get it.  | c\_get | DB\_LAST
|-
| DBI\_OP\_NEXT | Move cursor to next record then get it.  | c\_get | DB\_NEXT
|-
| DBI\_OP\_NEXT\_EQ | Move cursor to next record having the same key then get it.  | c\_get | DB\_NEXT\_DUP
|-
| DBI\_OP\_NEXT\_NE | Move cursor to next record having different key then get it.  | c\_get | DB\_NEXT\_NODUP
|-
| DBI\_OP\_PREV | Move cursor to previous record then get it.  | c\_get | DB\_PREV
|-
| DBI\_OP\_MOVE\_EQ | Move cursor to first record having the key and get its value | c\_get | DB\_SET
|-
| DBI\_OP\_MOVE\_GE | Move cursor to smallest record having a key greater or equal than the specified one. Then it gets the record | c\_get | DB\_SET\_RANGE
|-
| DBI\_OP\_MOVE\_RECNO | Move record to specified record number then get it.  | c\_get | DB\_SET\_RECNO
|-
| DBI\_OP\_PUT\_VALUE | Overwrite current position value | c\_put | DB\_CURRENT
|-
| DBI\_OP\_PUT\_UNIQUE\_REC | Insert new key-data if it does not alreadyb exists | c\_put | DB\_NODUPDATA
|-
| DBI\_OP\_DEL | Delete current key-data | c\_del | 0
|-
| DBI\_OP\_CLOSE | Close cursor | c\_close | N/A
| DBI\_BULKOP\_NEXT | Get next block of records | c\_get | DB\_NEXT\_DUP | DB\_MULTIPLE Or DB\_NEXT\_DUP + DB\_MULTIPLE\_KEY
|-
| DBI\_BULKOP\_MOVE | Get block of records | c\_get | DB\_SET | DB\_MULTIPLE<br /> Or DB\_SET + DB\_MULTIPLE\_KEY

*Value handling options*

| 'Name' | 'Role' | 'Old bdb value'
|-
| DBI\_MEM\_USER | Tell impl plugin to neither alloc nor free the memory | DB\_DBT\_USERMEM
|-
| DBI\_MEM\_MALLOC | Tell impl plugin to alloc and free the memory | DB\_DBT\_MALLOC
|-
| DBI\_MEM\_REALLOC | Tell impl plugin to reuse or realloc the memory | DB\_DBT\_REALLOC

*error codes*

| 'Name' | 'Role' | 'Old bdb value'
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
-
| dblayer\_start\_fn\_t *dblayer\_start\_fn ||
-
| dblayer\_close\_fn\_t *dblayer\_close\_fn ||
-
| dblayer\_instance\_start\_fn\_t *dblayer\_instance\_start\_fn ||
-
| dblayer\_backup\_fn\_t *dblayer\_backup\_fn ||
-
| dblayer\_verify\_fn\_t *dblayer\_verify\_fn ||
-
| dblayer\_db\_size\_fn\_t *dblayer\_db\_size\_fn ||
-
| dblayer\_ldif2db\_fn\_t *dblayer\_ldif2db\_fn ||
-
| dblayer\_db2ldif\_fn\_t *dblayer\_db2ldif\_fn ||
-
| dblayer\_db2index\_fn\_t *dblayer\_db2index\_fn ||
-
| dblayer\_cleanup\_fn\_t *dblayer\_cleanup\_fn ||
-
| dblayer\_upgradedn\_fn\_t *dblayer\_upgradedn\_fn ||
-
| dblayer\_upgradedb\_fn\_t *dblayer\_upgradedb\_fn ||
-
| dblayer\_restore\_fn\_t *dblayer\_restore\_fn ||
-
| dblayer\_txn\_begin\_fn\_t *dblayer\_txn\_begin\_fn ||
-
| dblayer\_txn\_commit\_fn\_t *dblayer\_txn\_commit\_fn ||
-
| dblayer\_txn\_abort\_fn\_t *dblayer\_txn\_abort\_fn ||
-
| dblayer\_get\_info\_fn\_t *dblayer\_get\_info\_fn ||
-
| dblayer\_set\_info\_fn\_t *dblayer\_set\_info\_fn ||
-
| dblayer\_back\_ctrl\_fn\_t *dblayer\_back\_ctrl\_fn ||
-
| dblayer\_get\_db\_fn\_t *dblayer\_get\_db\_fn ||
-
| dblayer\_delete\_db\_fn\_t *dblayer\_delete\_db\_fn ||
-
| dblayer\_rm\_db\_file\_fn\_t *dblayer\_rm\_db\_file\_fn ||
-
| dblayer\_import\_fn\_t *dblayer\_import\_fn ||
-
| dblayer\_load\_dse\_fn\_t *dblayer\_load\_dse\_fn ||
-
| dblayer\_config\_get\_fn\_t *dblayer\_config\_get\_fn ||
-
| dblayer\_config\_set\_fn\_t *dblayer\_config\_set\_fn ||
-
| instance\_config\_set\_fn\_t *instance\_config\_set\_fn ||
-
| instance\_config\_entry\_callback\_fn\_t *instance\_add\_config\_fn ||
-
| instance\_config\_entry\_callback\_fn\_t *instance\_postadd\_config\_fn ||
-
| instance\_config\_entry\_callback\_fn\_t *instance\_del\_config\_fn ||
-
| instance\_config\_entry\_callback\_fn\_t *instance\_postdel\_config\_fn ||
-
| instance\_cleanup\_fn\_t *instance\_cleanup\_fn ||
-
| instance\_create\_fn\_t *instance\_create\_fn ||
-
| instance\_create\_fn\_t *instance\_register\_monitor\_fn ||
-
| instance\_search\_callback\_fn\_t *instance\_search\_callback\_fn ||
-
| dblayer\_auto\_tune\_fn\_t *dblayer\_auto\_tune\_fn ||
|-


| Name | Role | Old bdb value
-
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
| dblayer\_db\_op(DBI\_DB *db, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Add/replace a record | db-\>put
|-
| dblayer\_db\_op(DBI\_DB *db, DBI\_OP op, DBI\_DATA *key, DBI\_DATA *data) | Delete a record | db-\>del
|-
| dblayer\_get\_db\_id | | db-&gt;fname
|-
| dblayer\_init\_bulk\_op(DBI\_DATA *bulk) | Initialize iterator for bulk operation | DB\_MULTIPLE\_INIT |
|-
| dblayer\_next\_bulk\_op(DBI\_DATA *bulk, DBI\_DATA *key, DBI\_DATA *data) | Get next operation from bulk operation | DB\_MULTIPLE\_NEXT |
| 


I wonder if we should keep the callback definition. at the dblayer level.

 IMHO it should be better to define a callback struct in dbimpl.h i.e DBI\_CB because:
* the db implementation plugin should not need to know about the dblayer or backend API
* That allows to define a static callback struct in the plugin rather than explicitly set every callbacks in init function. 
* the callback could be refered from the data that needs it (like values)



##Alternatives##

* Redesign the cursor handling code:
	* (no sure that ldbm supports bulk operation when reading data)
	* (quite sure that ldbm does not support the recno)


<span id="anchor-21"></span>Error handling

<span id="anchor-22"></span>Proposed solution

* Remap the errors to generic values
* Add a function in bdb that remap the value (should be a simple switch)<br />
If the value cannot be mapped:<br />
   add a string in thread local storage and return DBI\_RC\_OTHER<br />
   The string should contains the original return code and its associated message (i.e:<br />
bdb error code: %d : %s&quot;, native\_rc, db\_strerror(native\_rc))
* Modify dblayer\_strerror to print a message for generic errors and if DBI\_RC\_OTHER to generate a message from the thread local data string.

<ul>
<li><blockquote><p>This solution has the advantage that:</p></blockquote>
<ul>
<li>it does not impact the back-ldm/changelog code (except for dblayer\_strerror) </li>
<li>It is quite efficient in the usual case as it handles a switch with few values</li>
<li>Keep the ability to diagnose errors in the unexpected case</li></ul>
</li>
<li><blockquote><p>The drawbacks:</p></blockquote>
<ul>
<li>Message can be wrong if creative error handling is performed (i.e </li></ul>
</li></ul>

          rc1 = dblayer\_xxx(li, ...)

          rc2 = dblayer\_xxx(li, ...)

          log(dblayer\_strerror(rc1)) prints rc2 message if both values are are DBI\_RC\_OTHER)<br />
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
<li><blockquote><p>&lt;PREFIX&gt;\_&lt;NAME&gt;</p></blockquote></li>
<li><blockquote><p>&lt;prefix&gt;\_&lt;name&gt;\_t</p></blockquote></li></ol>
</li></ol>



 



