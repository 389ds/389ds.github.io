---
title: "Using LMDB"
---

# Using LMDB
-----------------

{% include toc.md %}

Introduction
------------
Issue 4699 - PR 4716 (Aug 2021) implements an experimental feature allowing to replace Berkeley Database (bdb) by Open LDAP Lightning Memory-Mapped Database Manager (lmdb)

Pre-requisites
--------------

This work was integrated on Fedora master branch. (Not yet in REHL but planned for 9.1 or 9.2)

You now need to install both lmdb-libs and libdb to run 389ds
( and lmdb-devel and libdb-devel to build 389ds )

# Basic configuration
---------------------

In the configuration berkeley database is identified as "bdb"
and Open LDAP Lightning Memory-Mapped Database Manager as "mdb" 
 ( mdb is prefered instead of lmdb to avoid the confusion with ldbm (which is the 389ds module that implements the backend of the database (and that prefix some config parameters))

## Checking which lib is active: ##
    dsconf instance backend config get | grep nsslapd-backend-implement
        ( should be bdb or mdb )

## Switch which lib is used by default ##
For CI tests and dscreate tool there are two way to proceed:
    - Setting environment variable: NSSLAPD_DB_LIB=mdb
    - Modifying lib389: DEFAULT_DB_LIB = 'mdb' in src/lib389/lib389/_constants.py:

## Switch a single instance ##
    - dsconf instance backend config set --db_lib bdb
    - dsconf instance backend config set --db_lib mdb
Notes:
	- this require a server restarts
	- the first time the lib is changed, the db will be empty 
      (so all backends should be exported in ldif from the old lib and
       reimported in the new lib)
    - If you want to revert, if all backends are replicated and changelog
expiration is long enough, replication should be able to resync the database

# Known impacts #
There are a few behavior differences between bdb and mdb due to the architecture of both dbs 
    - on line import/reindex does strongly impact ldap write operation performance (because mdb accepts only a single open write transaction at any time)
    - A range search on attribute with equality index become unindexed if of the the attribute value is longer than 507 bytes. (
   the reason is that the value is hashed to comply with mdb key size limit, and hash fnction does not preserve lexicographic order)


# mdb specific parameters #

There are a few parameters specific to mdb:
 TBC

