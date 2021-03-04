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

Working on Design 

## Phasing ##
I plan for 2 phases:

* phase 4a: having a working implementation fot mdb
* phase 4b: improving performance for mdb (Note: phase 4b should probably be done once bdb is gone)
*  (to avoid the complexity of maintenaing compatibility for both db )


## Naming ##
  plugin directory: .../back-ldbm/db-mdb
  sources files are prefixed with mdb_
  lmdb lib: got from packages: lmdb-devel lmdb-doc lmdb-libs 


## TXN and value Handling ##

The idea (to avoid impacting current backend txn scheme in phase 4a):
is:
	if a txn is provided by dblayer: it is a write txn and should be used for the operation
    in the other case: 

    in all cases, data that are read from the db are strdup/copied in dbi_val_t
    (in phase 4a no pointers towards memory mmap are kept outside db-mdb plugin)


 

