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
But allowing the coexistence of different database implementation requires several changes which affect configuration and upgrade - even if th efunctionality is not changed.

The main changes are:

- The configuration of the ldbm database is split into a generic database configuration and an implpementation specific subdatabase
- The MMR replication chnagelog has to be integrated into the main database
- The usage of exec modee of ns-slapd and database related tasks can be affected
- The install and upgrade has to handle the new configuration
 
Current solution
==================

## Configuration

### Backends and suffixes

### Database Configuration


## Database Plugin

### Defined plugin entrypoints

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
