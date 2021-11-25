---
title: "LMDB Import Design"
---

# LMDB Import - Software Design Specification
-------------------------------------------------------

{% include toc.md %}

Introduction
------------

The first implementation of "import" functionality based on import for bdb has two major drawbacks:
    - bad performance compared to bdb import
    - database size grows out of control
This document present a proposal to fix theses issues.
By "import" I mean the ldif2db, reindex, total update and upgrade functionalities.

bdb import synopsys
--------------------
In bdb plugibn code there are two way to import things
    - reindex / upgrade 
    - import / total update 

## bdb reindex / upgrade synopsys
---------------------------------

reindex is handled by a single thread that read the entries then update the indexes.

## bdb import / total update  synopsys
--------------------------------------

importi/total update is handled by a set of threads:
|-|-
|thread|role|
|---
|ldif2db provider| read ldif entries and push them towards foreman|
|---
|total update provider| push added entry towards foreman|
|---
|foreman| write entry in db, update special indexes like entryrdn, push entry towards workers|
|---
|worker| There are one worker per attributes (regular or vlv) to index.  a worker thread is in charge of updating a single attribute|
|---
This is quite efficient because a thread handled all the write in a db instance. Infortunately lmdb allows only a single active write txn 
so the write cannot be parallelized (and by calling back some backend function, read txn are implicitely used which also cause trouble with lmdb )

Proposed lmdb import synopsys
-----------------------------
The idea is to have the same model for all functions with the following threads:
|-|-
|thread|role|
|---
|index/upgrade provider| read entries from id2entry (releasing the txn aftewards) and push them towards workers|
|---
|ldif2db provider| read ldif entries and push them towards workers|
|---
|total update provider| push added entry towards workers|
|---
|workers| Compute ancestors ids (from DN or from parent id) using entryrdn cache or entryrdn db instance
| | Push toward writer the 3 entryrdn keys (The entry, The parent entry, The child entry (of parent)) and data
| | Push toward writer the ancestorid keys and data
| | Push toward writer the id2entry  key and data
| | For toward writer all indexes push the indexes keys and data
|---
|writer| Wait until enough triplet (dbi, key, data) are in the queue the open a write txn 
| | put key,data in dbi then commit the txn and flush the entryrdn cache
|---
This way read txn are only used when looking up entryrdn (if not in cache) 
and write txn are not only serialized but handled in batch.
        

## Detailed Design

General Plugin Configuration
----------------------------


<br>

## Detailed Design of Account Inactivity
-------------------------------------

### Introduction


### Logging

### Enforcement Method

### Schema Changes

### Outstanding Issues

1.  User Interface
    1.  Will
    2.  If 

2.  Standards compliance
    1.  Should
    2.  As of

### Additional features

#### New attribute alwaysRecordLoginAttr
	
<b>Update lastLoginTime in Account Policy plugin if account lockout is based on passwordExpirationTime.</b>

### Schema Changes

TBD.

### Outstanding Issues

Mostly same as the Account Inactivation issues.

### Bibliography

(1) Prasanta Behera's password policy draft, 9th iteration (http://www.faqs.org/ftp/internet-drafts/draft-behera-ldap-password-policy-09.txt)
