---
title: "Database Backend Redesign"
---

# Database Backend Redesign
------------------

{% include toc.md %}

Motivation
==========

The current implementation of 389-ds uses the BerkeleyDB libdb database for storage of data. There
are two reasons to think about using an alternative database library

- Oracle channged the licence model for the recent versions so that they are no longer compatible with 389-ds and we would have to stay at 5.x
- There have been many issues with the transaction model in BDB leading to blocking read access during writes or leading to deadlocks. It is time
to offer the choice of an implementation which uses copy on write and where readers are not blocked by writes

High level summary
==================

It is not possible to immediately replace the BDB backend compeltely by an other database lib (eg LMDB), we need to support BDB as is and in parallel can provide an other option.
But allowing the coexistence of different database implementation requires several changes which affect configuration and upgrade - even if the functionality is not changed.

The main changes are:

- The configuration of the ldbm database is split into a generic database configuration and an implpementation specific subdatabase
- The MMR replication chnagelog has to be integrated into the main database
- The usage of exec modee of ns-slapd and database related tasks can be affected
- The install and upgrade has to handle the new configuration

Current solution
==================

## Configuration

### Backends and suffixes

The configuration of DS lists all the suffixes this DS will service, it is specified in

    cn=<suffix>,cn=mapping tree,cn=config

Each suffix has a multivalued attribute which determines where the data for this suffix are stored:

    nsslapd-backend: <backendname>

It can have multiple backends only if a distribution function is defined and the suffix is distributed over multiple backends.

But no two suffixes can point to the same backend and a backend can only contain data for one suffix. So, in the usual case without distribution, there is a 1:1 relationship between a suffix and a backend

There are several types of backends:

     internal (dse, schema, config)
     chaining
     database

This document will only deal with database backends


### Database Configuration

A database backend is implemented as a plugin and the configuration is at two levels:

    cn=ldbm database,cn=plugins,cn=config

which defines the plugin library and plugin initilaization function, and a configuration for the specific implementation:

    cn=config,cn=ldbm database,cn=plugins,cn=config

Each backend implemented by this plugin is listed as a child of the plugin definition:

    cn=<backend_1>,cn=ldbm database,cn=plugins,cn=config


## Database Plugin

All functionality to access and manage the database are implemented as pluging functions, this includes import/export, backup/restore, search and modify access for data in the database and some more
 
### Defined plugin entrypoints

The plugin functionality is exposed by registerd functions which are published to the plugin substructutre of the pblock, more precisely the daatabase sub struct.

These plugin entry points can be classified into several groups and will be discussed next.

#### Plugin management

These functions will be callesd when the plugin subsystem starts or closes

    SLAPI_PLUGIN_START_FN, (void *)ldbm_back_start);
    SLAPI_PLUGIN_CLOSE_FN, (void *)ldbm_back_close);
    SLAPI_PLUGIN_CLEANUP_FN, (void *)ldbm_back_cleanup);

#### Functions called by ldap operation.

The processing of any ldap operation will at some point need access to the database and call a backend function, for each
LDAP operation there is one or more backend entry point:

    SLAPI_PLUGIN_DB_BIND_FN, (void *)ldbm_back_bind);
    SLAPI_PLUGIN_DB_UNBIND_FN, (void *)ldbm_back_unbind);
    SLAPI_PLUGIN_DB_SEARCH_FN, (void *)ldbm_back_search);
    SLAPI_PLUGIN_DB_NEXT_SEARCH_ENTRY_FN, (void *)ldbm_back_next_search_entry);
    SLAPI_PLUGIN_DB_NEXT_SEARCH_ENTRY_EXT_FN, (void *)ldbm_back_next_search_entry_ext);
    SLAPI_PLUGIN_DB_COMPARE_FN, (void *)ldbm_back_compare);
    SLAPI_PLUGIN_DB_MODIFY_FN, (void *)ldbm_back_modify);
    SLAPI_PLUGIN_DB_MODRDN_FN, (void *)ldbm_back_modrdn);
    SLAPI_PLUGIN_DB_ADD_FN, (void *)ldbm_back_add);
    SLAPI_PLUGIN_DB_DELETE_FN, (void *)ldbm_back_delete);
    SLAPI_PLUGIN_DB_ABANDON_FN, (void *)ldbm_back_abandon);

Specific for paged result searches:

    SLAPI_PLUGIN_DB_SEARCH_RESULTS_RELEASE_FN, (void *)ldbm_back_search_results_release);
    SLAPI_PLUGIN_DB_PREV_SEARCH_RESULTS_FN, (void *)ldbm_back_prev_search_results);

Not used, should be removed

    SLAPI_PLUGIN_DB_ENTRY_RELEASE_FN, (void *)ldbm_back_entry_release);


### Plugin usage

### Internal representation and setup

Required Changes
================

## configuration changes

### database subtype

### move existing ldbm config to subtypes

## implement database subtypes

## define methods for database access

### environment

### transactions

### database operation

### database cursor and cursor operation

## define methods for higher level functions

### backup/restore

### import/export

### reindex

## Integrate MMR changelog








=======
* Ticket [\#49476](https://pagure.io/389-ds-base/issue/49476) refactor ldbm backend to allow replacement of BDB

Related tickets: 
* Ticket [\#49469](https://pagure.io/389-ds-base/issue/49469)  cleanup backend code (1)
* Ticket [\#49481](https://pagure.io/389-ds-base/issue/49481) remove unused or unnecessary database plugin functions
* Ticket [\#49483](https://pagure.io/389-ds-base/issue/49483) investigate if backend get|set entrypoint is needed
* Ticket [\#49487](https://pagure.io/389-ds-base/issue/49487)  remove ldbm_back_entry_release
* Ticket [\#49488](https://pagure.io/389-ds-base/issue/49488)  remove old idl format
* Ticket [\#49489](https://pagure.io/389-ds-base/issue/49489)  is upgrade dn format still needed ?
* Ticket [\#49490](https://pagure.io/389-ds-base/issue/49490)  stop support for old entrydn index
