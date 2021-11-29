---
title: "Database Backend Redesign - Phase 4"
---

# Database Backend Redesign - Phase 4
-------------------------------------

{% include toc.md %}

Status
==========
Date: 2021 Mar, 4th

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

* the lmdb plugin implementation over dbimpl API

Current state
=============

Working on Design (in other words very unstable draft)

## Naming ##
    plugin directory: .../back-ldbm/db-mdb
    sources files are prefixed with mdb_
    function names are prefixed with dbmdb_  (Could not use mdb_ that conflicts with ldbm libraries)
    lmdb lib: are got from packages: lmdb-devel lmdb-doc lmdb-libs 

Note: lmdb documentation is in [file:///usr/share/doc/lmdb-doc/html/index.html](file:///usr/share/doc/lmdb-doc/html/index.html) once lmdb-doc is installed.

## Design ##
  The plan with this phase is to minimize as much as possible impacts outside of the mdb plugin
  so we do not provide pointer on db mmap outside of the plugin
  The global plugin design is similar to bdb plugin 

## Architecteure choices ##

###  creating a single MDB_env versus one MDB_env per backend ###
    - Max Dbs question: (txn cost depends linearly of the max number of dbs )
      if we split per suffix we can keep it smaller 
    - Consistency of txn across suffixes
      The question is important for write txn as there is no way to commit them
      in a single step  (Is there write txn across different suffixes ?)
    - Consistency of changelog (Not an issue as the changelog is already per suffix)
    - Consistency with existing bdb model (today bdb_make_env  is called once:
      (with the <INSTALLDIR>/var/lib/dirsrv/slapd-<INSTANCE>/db path )

==> I suspect that we will have to go for a single MDB_env in first phase

### db filename list ###
  The whole db is a single mmap file and lmdb does not provide any interface 
   to list the db names 
  two solutions
- use a specific db to keep the name list 
    (probably using "backendname --> db file name" records)
- get the data from mdb struct (but that means getting knowledge of 
  mdb opaque struct (which is usually not a good idea)

==> This will impact dbstat tool too as we cannot looks for file anymore
      and we needs a way to list existings suffix and existsing files in suffixes
  

### mdb specific config parameters ##
    - MAXDBS  (cf mdb_env_set_maxdb)
    - DBMAXSIZE (cf mdb_env_set_maxdbs)
    - mdb_env_set_maxreaders: should be around 1 per working threads +
       1 per agmt 
          so we could have an auto tuning value that will use the number ofr
              working threads + 30 

Note: changing these parameters requires db env closure (i.e: restart the instance in first implementation)

## mdb limitations ##

Here are the limits That I measured in my test.

| Database type  | Key max  | Data max
|-|-|-
| No dup Support | 511 | > 6 GB
|---
| Dup Support | 511 | 511
|---

511 is the mdb_env_get_maxkeysize(env) hardcoded limit
Got a bit more than 6  GB in a db with size = 10GB
		


- mdb_env_get_maxkeysize 511 bytes hardcoded limit:
How do we handle the oversized keys ?
    - Ignore it (return DBI_NOT_FOUND when looking for it) 
       and reject it when trying to set the key
    - Split the key and have a continuation mechansim. For example:
        {<Prefix>KeyPart0   ---> idPart1 (where <Prefix> is = ~ :id: as usual)
        .<idPart1>.Keypart1 ---> idPart2
        .<idPartN>}KeypartN ---> idEntry
        #MaxPartID --> idPartN (or something else anyway that is the max id )
    - Have a specific table for oversized keys in which we store:
		key hash -> id + key 
    - use a specific index hash key prefix (h?) followed by the orignal (i.e equality or approximate) key prefix and hashed value in hexa as key for binary object whose size > max key size
         (and mark the search as disabling  filter bypass) (the filter check will then remove the hash duplicates)
      Pro: it does not requires much change in the way index are looked 
           it probably speed up the db lookup (but that could be mitigated by the fact that filter checking is needed)
      Cons: Range search should be seen as unindexed ( unable to use index while performing range search when oversized keys exists )
           ==> This could be done with a simple lookup of key stating with hash prefix followed by equality prefix
           h{hash} --> id and a filter check is needed 
- data are also limited to 511 bytes for DUPSORT databases
    but that should not be an issue: because DUPSORT files are indexes (and their values are a plain entryId)
    Large data may be entries or changes and  id2entry, changelog, and retrochagelog have unique keys
    (and mdb limit (4GB) is greater than bdb ones)

       
** Note from Thierry : **  pierre: regarding LMDB keylen, IPA is using 'eq' index on attributes (usercertificate, publickey,..) with keys that >500bytes

### Other mbd limitations ###
- There must not ever be two concurrent transactions using mdb_dbi_open.
- LMDB does no internal bookkeeping of named databases, and you will have to ensure yourself that you open named databases with the same flags every time.
MDB_RDONLY is useful because you can have multiple read-only transactions open, but only ever one write transaction.
   So adding/removing/opening db should be serialized by a global mutex
- Only a single read txn per threads (child txn are ok as long as the parent txn is not used while child txn is open)
- Only a single write txn active at a time (the other will wait until the active one is complete)
- Only a single env per process




### mdb-env-open flags ###
    - db2ldif/db2bak MDB_RDONLY
    - ns-slapd 0
    - offline bak2db/ldif2db MDB_NOSYNC 
use mdb_env_sync() and fflush(mdb_env_get_fd()) before closing the env
(depending of the ldif file or the mmap size we may also use MDB_WRITEMAP flag)
    - online bak2db (and maybe online db2ldif) duplicate the environment
    - reindex (should probably be 0 to avoid breaking the whole db in case of error)
   Note we may be in trouble if ldif2db fails and there is multiple bakends 
    and the single env strategy id used ...

### db format ###

| db | open flags | key | value
|---
| id2entry | MDB_INTEGERKEY + MDB_CREATE | entryId | entry or 'HUGE entryId nbParts'
|---
| entrydn | MDB_DUPSORT | normalized dn | Flag.entryId
|---
| index | MDB_DUPSORT + MDB_DUPFIXED + MDB_CREATE | PrefixIndex | Flag.entryId
|---
| vlvindex | MDB_DUPSORT + MDB_DUPFIXED + MDB_CREATE | PrefixIndex | Flag.entryId
|---
| changelog/retrochangelog | MDB_CREATE | csn | change
|---
| #dbname | MDB_CREATE | bename/dbfilename | openFlags
|---
| #huge | MDB_CREATE | bename'/'dbname':'ContKeyId'.'n | EntryId.complete Key value
|  |  | #maxKeyId | max ContKeyId value | 


PrefixIndex is the usual index type prefix (ie: '=' or '*' or '?' or ':MatchingRuleOID:') concat with the key value 
Flag.entryId is:      
- '0' followed by entry id ==> usual entryID
- '2' followed by continuation key id ==> Long Key (note: the key is truncated to fulfill the limit)



### Type Mapping ###
- dbi_env_t --> MDB_env
- dbi_db_t --> MDB_dbi
- dbi_txn_t --> MDB_txn



## TXN and value Handling ##

is:
	if a txn is provided by dblayer: it is a write txn and should be used for the operation
    in the other case: 

    in all cases, data that are read from the db are strdup/copied in dbi_val_t
    (in phase 4a no pointers towards memory mmap are kept outside db-mdb plugin)

## VLV and RECNO
 BDB implement vlv index by using an index with key based on entry value and the vlv search sort order i
 (So that the vlv index records are directly sorted according the vlv sort order) The data is the entry ID.
 note: the key is usually acceeded by its position in the tree (i.e RECNO) rather than by its value.

 unlike bdb, ldbm does not implement a recno lookup. So we cannot use that.
 We use a VLV index as in bdb and for each VLV index have a second database used a cache.
 The cache will contains:
    
  For each VLV index have a second database "vlv cache" database that contains the following records:
   Key:  D{key}{data}{key-size}  Data: {key-size}{data-size}{recno}{key}{data}
   Key:  R{recno}                Data: {key-size}{data-size}{recno}{key}{data}
   Key:  OK                      Data: OK
The data and recno records exists for all vlv records whose recno modulo RECNO_CACHE_INTERVAL(1000) is 1 

When looking up in the cache for recno, we perform a lookup for nearest key smaller or equal to R{recno}
Then we lookup for key/data in vlv index and move the vlv index cursor by one until we got the wanted recno.  

When removing/adding a key from vlv index the cache is cleared and rebuilt at next query.

## bulk operation ##

BDB is supporting to kind of bulk read operations:
- bulk data read to get all (or part) duplicates for a given key. This is typically used to compute an ID list.
- bulk record read to get a set of key/data pair. This is typically used to build the changelog cache.

In MDB there is not much support for bulk read operations (not very surprising because read operations
    are pretty fast anyway)
  The interresting point is that we could avoid copy overhead for bulk operation 
  (because in bdb the returned data are stored in a local buffer and no more used once 
    the cursor is released so: 
- bulk_buffer should only store the cursor
- dbi_val_t key/data from dblayer_bulk_nextdata/dblayer_bulk_nextrecord does directly point towards mmmap values.

*** IMPORTANT NOTE *** The above descrption is not doable for bulk record read: The issue is that in changelog case
    the cursor get closed between the value retrival phase and the result iteration phase
     ==> nether keeping cursor reference of pointer towards the mmap is safe.
     ==> Will have to copy the keys and data into the buffer until reaching one of the following:
    * End of cursor
    * Buffer size limit
    * Number of record in bulk operation limit


## monitoring ### 
Here are available values
- unsigned int 	ms_psize
- unsigned int 	ms_depth
- size_t 	ms_branch_pages
- size_t 	ms_leaf_pages
- size_t 	ms_overflow_pages
- size_t 	ms_entries

- size_t 	me_mapsize  ( Max maximum size )
- size_t 	map used size  ( provided by stat(db) (i.e as in ls -l) )
- unsigned int 	me_maxreaders
- unsigned int 	me_numreaders
- number of db (number of entries in #dbnames db)
- max number of db (from config)

Here are what openldap monitors:

| Attribute | Description | IMHO Notes
|-|-
| olmDbDirectory | Path name of the directory where the database environment resides | should not be a monitored value but a config one
|---
| olmMDBPagesMax | Maximum number of pages | 
|---
| olmMDBPagesUsed | Number of pages in use | 
|---
| olmMDBPagesFree | Number of free pages | 
|---
| olmMDBReadersMax | Maximum number of readers | Is also a config attribute
|---
| olmMDBReadersUsed | Number of readers in use | 
|---
| olmMDBEntries | Number of entries in DB | 

## Handling oversized index keys ##

mdb hardcode some limits about the record size:
- keys are limited to mdb_env_get_maxkeysize(env) which is 511 with the default lmdb build.
- the total key+data size has the same limit for DUPSORT database
This mainly impact the equality, approximate and specific matching rules index keys.
This also impact the AVA max size in DN (because of entryrdn index)
 but it should not a real issue in practice (using huge rdn is suboptimal in term of performance anyway ...)
Note:
- The changelog / retrochangelog / id2entry / entrydn databases have fixed key size and are not impacted by the issue.
- DUPSORT flags is only used for the indexes databases and indexes data are ID (fixed size)

** Note from Thierry : **  pierre: regarding LMDB keylen, IPA is using 'eq' index on attributes (usercertificate, publickey,..) with keys that >500bytes.
So we have to somehow support search on long keys.

### implemented solution

A solution is to replace the long key value by a smaller one (typically an hash)
just before encrypting the keys (i.e in attrcrypt_encrypt_index_key) if needed:

if the key is too long: 
Before checking if key value must be encrypted , check the key lenght is smaller than max_key_size if it is the case:
    replace the value by: HASH_PREFIX ORIGINAL_KEY_PREFIX bin2hexa(hash(original_key_value))
    disable filterbypass

At implementation level it means:
- Add a max_key_size in ldbminfo initialzed to UINT_MAX
- While starting bdb: set max_key_size to mdb_env_get_maxkeysize(env) - sizeof (ID)
- When searching for a key: do as usual (key will be hashed too)
- When reading index ranges IDs, if max_key_size is smaller than UINT_MAX
 lets try to lookup for key starting with "HASH_PREFIX EQ_PREFIX". If found then mark the search as unindexed and returns AllIds, otherwise range could be performed as usual.   

### rejected alternatives
    - Ignore it (return DBI_NOT_FOUND when looking for it) 
       and reject it when trying to set the key
    - Split the key and have a continuation mechansim. For example:
        {<Prefix>KeyPart0   ---> idPart1 (where <Prefix> is = ~ :id: as usual)
        .<idPart1>.Keypart1 ---> idPart2
        .<idPartN>}KeypartN ---> idEntry
        #MaxPartID --> idPartN (or something else anyway that is the max id )
    - Have a specific table for oversized keys in which we store:
		key hash -> id + key 
    - use a specific index type bases on hash 
## ldif import/export ##
    mdb architecture impacted both the ldif export and ldif import:
    - on export size the change is minor and due to the fact that the entries read from id2entry 
      are direct pointer towards the read-only memory map (but ldif_getline libldap function that 
       reads entry from ldif was directly modifying the memory to remove \\r) 
      The ldif_getline_ro function was rewritten without tampering the memory
      and a dup_ldif_line also add to copy the line in a berval
    - several issues impacted the ldif import (mostly related that we can only have 1 open write txn at a time
    - and some write operation should be done in a synchronous way while most the others may be
      asynchronous. (typically the operation needed to determine the children/parent relationship)
    - to limit the code impact at backend level the back_txn struct was modify to add a callback
       (back_special_handling_fn)
    - The backend code:
        - BTXNACT_INDEX_ADD,            /* data is a index_update_t */
        - BTXNACT_INDEX_DEL,            /* data is a index_update_t */
        - BTXNACT_VLV_ADD,              /* data is an entry ID */
        - BTXNACT_VLV_DEL,              /* data is an entry ID */
        - BTXNACT_ID2ENTRY_ADD,         /* data is the entry */
        - BTXNACT_ENTRYRDN_ADD,         /* key is a srdn, data is an id */
        - BTXNACT_ENTRYRDN_DEL          /* key is a srdn, data is an id */
      is modified to call the callback (if set) with the caller location (as listed above) 
      instead writing in the database.
    - at db-mdb level:
        - A new "writing thread is created among the threads pool that handles two operations queues"
        - The usual foreman and worthreads now use a pseudo_back_txn_t (a back_txn with the callback set followed by some context to identify to worker info and the target file) when calling back the dblayer functions and they queues directly the open or write action in the right writing thread queues
 (and wait for success/failure if it is the synchronous queue (i.e entryid, parentid and entryrdn ) 
       - The pseudo_back_txn_t callback also queue the operation in the right queue as above
       - and the writing threads loops waiting on available operations
           for each opeartion on synchronous queue: perform the operation and send the result to the calling worker thread else perform asynchronous operation.
            
     BTW There is a third queue needed to handle the very special case of upgrade (when entries needs to be rewritten - in this case a temporary file is used to queue the operation 
(but thinking more about it, if will probably be safer to duplicate the id2entry toward a special db then clear id2entry and wire the provider on that special db (rather than id2entry) and perform import as usual - anyway there is nothing to upgrade right now so we have time to change that)


# Config entry #
Entry:  cn=bdb,cn=config,cn=ldbm database,cn=plugins,cn=config

Parameter similar to bdb one:

| Name | Default Value | Comment |
|-|-|-|
| nsslapd-db-home-directory |  <INSTALL_DIR>/var/lib/dirsrv/slapd-<InstanceName>/db | |
|---
| nsslapd-search-bypass-filter-test | on | More a backend parameter than a bdb one |
|---
| nsslapd-serial-lock  | on | More a backend parameter than a bdb one |

mdb specific parameters:

| Name | Default Value | Comment |
|-|-|-|
| nsslapd-mdb-max-size | 0 | 0 means disk remaining size (when creating the db) |
| | | supponted value: a number followed by a suffix (typically M/G/T) |
| | | note:  value is rounded down to a multiple of 10Mb |
|---
| nsslapd-mdb-max-readers | 0 | 0 means number of working threads + 30 |
|---
| nsslapd-mdb-max-dbs | 128 |  | 

## debuging ##

Added a few debugging modules
   to trace: 
- lmdb API calls 
- transaction handling
- import writing queue opeartions

The debug module sources are in mdb_debug.* files and trigered by:
- DBMDB_DEBUG conditionnal compilation flag
- dbgmdb_level variable whose value is a set of DBGMDB_LEVEL_MDBAPI, DBGMDB_LEVEL_TXN, DBGMDB_LEVEL_IMPORT flags

# Phases #

- 1) Build db-mdb plugin skeleton. Should be able to built
- 2) DB Initialisation / Adding - Removing instance - Listing instances - dbscan changes (done early to have a test tool). Should be able to add/remove backend.
- 3) Standard operation (dbimpl API in mdb)layer.c). Should be able to create/delete suffix an add/remove entries
- 4) Import/Export. Sould be able to run some of the basic py.test
- 5) Backup/Restore. Should be able to run most of the py.tests
- 6) VLV 
- 7) Monitoring and performance counters
- 8) New Hash index type (for large binaryobject)
- 9) Verify / Version / Upgrade





# Ideas about future improvements #

These are raw ideas (that would needs some benefit/cost evaluation)
- Splitting the single database into one db per suffix
- Keeping pointer to the db mmap in dbi_val_t 
    (avoid to duplicate each values)
    Could have a single txn operation wide for all operations except
     the search - for search operations we could 
       use the read txn and cursor reopen feature 
     after each entries (or group of entries) 

- Improving the way the data are stored in the db to limit the 
   overhead (Maybe using directly ber ? (at least for the attribute) ) 
    and avoid duplicating things
- adding cache for vlv search (and avoid to walk all records every time)
- Having a mecanism to handle config change
    (i.e: Take backend lock in write mode on all dbs 
         then closing alls dbs then the env 
         change the env config and reopen everything  )
- Having bulk write operations (mainly when handling: reindex / import)
   (i.e: that means grouping a bunch of write operation in a single txn)
- Simplifying the changelog iterator (we may want to keep the cache 
    to limit to cost of opening a txn and a cursor but we would only copy
    the relevant changes to the buffer 
  Another idea would be to keep the cursor open and close it every N changes 
   (but we should double check that it does not lead to uncontrolled database growth) 
   
   **Note**: issue [4939](https://github.com/389ds/389-ds-base/issues/4939) leaded to redesign the ldif export (see [the new design](https://directory.fedoraproject.org/docs/389ds/design/lmdb-import-design.html))
