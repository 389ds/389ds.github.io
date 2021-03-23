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
| No dup Support | 511 | 10M
|---
| Dup Support | 511 | 511
|---

511 is the mdb_env_get_maxkeysize(env) hardcoded limit
10M is stat.ms_psize with mdb_env_stat(env, &stat)
		


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
       
** Note from Thierry : **  pierre: regarding LMDB keylen, IPA is using 'eq' index on attributes (usercertificate, publickey,..) with keys that >500bytes

** Note from myself ** Should check how duplicate keys are handled and what are the limits


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
| #dbname | MDB_CREATE | bename/dbfilename | N/A 
|---
| #huge | MDB_CREATE | 'bename'/entryId:'entryId'.'n | n th part of entry
|  |  | bename'/'dbname':'ContKeyId'.'n | EntryId.complete Key value
|  |  | #maxKeyId | max ContKeyId value | 


PrefixIndex is the usual index type prefix (ie: '=' or '*' or '?' or ':MatchingRuleOID:') concat with the key value 
Flag.entryId is:      
- '0' followed by entry id ==> usual entryID
- '1' followed by entry id ==> Huge entryID
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
 ldbm does not implement a recno lookup as bdb does so we cannot use that .
 We will have to use a cursor starting from first records and counting
 the records we could have a cache that store count -> key every thousand of entries or so 


## bulk operation ##
  
  There is no support for  bulk read operation (not very surprising because read operations
    are pretty fast anyway)
  The interresting point is that we could avoid copy overhead for bulk operation 
  (because in bdb the returned data are stored in a local buffer and no more used once 
    the cursor is released so: 
- bulk_buffer should only store the cursor
- dbi_val_t key/data from dblayer_bulk_nextdata/dblayer_bulk_nextrecord does directly point towards mmmap values.

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


# Config entry #
Entry:  cn=bdb,cn=config,cn=ldbm database,cn=plugins,cn=config

Parameter similar to bdb one:
| Name | Default Value | Comment
|---
| nsslapd-db-home-directory |  <INSTALL_DIR>/var/lib/dirsrv/slapd-<InstanceName>/db |
|---
| nsslapd-search-bypass-filter-test | on | More a backend parameter than a bdb one
|---
| nsslapd-serial-lock  | on | More a backend parameter than a bdb one
|---

mdb specific parameters:

| Name | Default Value | Comment
|---
| nsslapd-mdb-max-size | 0 | 0 means disk remaining size (when creating the db) 
 supponted value: a number followed by a suffix (typically M/G/T)
 note:  value is rounded down to a multiple of 10Mb
|---
| nsslapd-mdb-max-readers | 0 | 0 means number of working threads + 30 
|---
| nsslapd-mdb-max-dbs | 128 | 
|---





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

