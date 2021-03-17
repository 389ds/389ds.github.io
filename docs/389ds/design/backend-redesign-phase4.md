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

* the mdb plugin implementation over dbimpl API

Current state
=============

Working on Design (in other words very unstable draft)

## Naming ##
  plugin directory: .../back-ldbm/db-mdb
  sources files are prefixed with mdb_
  lmdb lib: are got from packages: lmdb-devel lmdb-doc lmdb-libs 

## Design ##
  The plan with this phase is to minimize as much as possible impacts outside of the mdb plugin
  so we do not provide pointer on db mmap outside of the plugin
  The global plugin design is similar to bdb plugin 

## Architecteure choices ##

###  creating a single MDB_env versus one MDB_env per backend ###
    - Max Dbs question: (txn cost depends linearly of the max number of dbs )
      if we split per suuffix we can keep it smaller 
  - Consistency of txn across suffixes
      The question is important for write txn as there is no way to commit them
      in a single step  (Is there write txn across different suffixes ?)
  - Consistency of changelog (Not an issue as the changelog is already per suffix)
  - Consistency with existing bdb model (today bdb_make_env  is called once:
      (with the <INSTALLDIR>/var/lib/dirsrv/slapd-<INSTANCE>/db path )

  ==> I suspect  that we will have to go for a single MDB_env in first phase

### db filename list ###
  The whole db is a single mmap file and lmdb des not provides any interface 
   to list the db names 
  two solutions - use a specific db to keep the name list 
    (probably using backendname - db file record)
   peek the data from mdb struct (but that involving looking in opaque struct)
  ==> This will impact dbstat tool too as we cannot looks for file anymore
      and we needs a way to list existings suffix and existsing files in suffixes
  

 
     

### mdb specific config parameters ##
	MAXDBS  (cf mdb_env_set_maxdb)
	DBMAXSIZE (cf mdb_env_set_maxdbs)
	mdb_env_set_maxreaders: 1 per working threads + 1 per agmt
     These needs to close the db env when changed (i.e: restart in first implementation)

## mdb limitations ##
  mdb_env_get_maxkeysize  How do we handle the oversized keys ?


      

mdb_env_set_maxdb issue (

### mdb-env-open flags ###

### Type Mapping ###
Alternative:
    Have a single mdb_env
        Pro: Similar to bdb implementation
           : Can have a txn that spreads among suffixes


    Have one per suffix
    dbi_env_t : 

typedef void dbi_env_t;         /* the global database framework context */
typedef void dbi_db_t;          /* A database instance context */
typedef void dbi_txn_t;         /* A transaction context */



## TXN and value Handling ##

is:
	if a txn is provided by dblayer: it is a write txn and should be used for the operation
    in the other case: 

    in all cases, data that are read from the db are strdup/copied in dbi_val_t
    (in phase 4a no pointers towards memory mmap are kept outside db-mdb plugin)

## VLV and RECNO


## bulk operation ##

## monitoring ### 


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

