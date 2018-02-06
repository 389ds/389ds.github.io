---
title: "Integrate changelog and backen database"
---

# Integrate Changelog and Backend Database
------------------

{% include toc.md %}

Motivation
==========

On masters and hubs the multimaster replication plugin maintains a changelog database containing the changes to be 
replayed to other servers. Historically this was a  separate databse environment, but with the need to write the changelog
in the same transaction as the change operation it was changed to use the main database environment.

But it still maintains the changelog for all backends in a single directory and manages th file names to open and close the 
changelog database files. This has an overhead in many respects, but it also prevents the move to a replacable backend database
library, eg LMDB does not allow the use of dedicated database files.

Therfore, as a first step, the changlog database files should be fulkly integrated to the backend database.

High level summary
==================

The changelog database file will be located in the database directory of the backend, it will be managed like an index file and naturally be 
included in backup and restore.
For acces by the replication plugin a few access methods to get the database handle, to open or close the file will be exposed.


Changelog Configuration
=======================

## Current configuration


Currently the changelog configuration is stored in the following entry:

     dn: cn=changelog5,cn=config
     cn: changelog5
     objectClass: top
     objectClass: nsChangelogConfig
     nsslapd-changelogdir: /var/lib/dirsrv/slapd-master2/changelogdb

where the changelogdir is the only required attribute. Additional configuration attributes are:


     nsslapd-changelogmaxentries: minimum number of records to keep in the changelog

     nsslapd-changelogmaxage: minimum time to keep a record in the changelog

     nsslapd-changelogcompactdb-interval: time between two attempts to compact the changelog

     nsslapd-changelogtrim-interval: time between two attempts to trim the changelog

     nsslapd-encryptionalgorithm: algorithm to use for changelog encryption, presence turns encryption n

     nsSymmetricKey: key used for encrypt/decrypt (encrypted by server cert)

This changelog configuration is global, there is no way to enable trimming or encryption for only a specific backend. The maxentries value is a sum accross all chnagelogs.

 

## New configuration


With the new changelog management the configuration attributes are no longer needed or can be defined for each replica. If a changelog database 
file is maintained for a a replica is define by the nsds5ReplicaFlags attribute, which determines if changes are logged.


     nsslapd-changelogdir - no longer needed, the changelog file is part of the backend database 

     trimming configuration - defined by replica in the replica object. 

     encryption - can be enabled per replica, the key probably no longer has to be stored, see ticket #xxxxx

     compaction - BDB specific database compaction, its use is questionable as in a changelog the write will append records 
                  at the end and trimming will free pages and free pages will be reused.
                  There is compaction in the main db, so a specific handling for the changelog can be removed 


Upgrade Mechanism
=================

The change to the new handling and location should be smooth and without required interaction.

For new installations no cn=changelog5 entry is created and the creation of a replica will set default values
for changelog related attributes. The new admin gui will support this.

If an existing instance is upgraded the following action will be done during startup when multimaster_replication_start() is called.

    check if cn=changelog5,cn=config exist
        if not done

    read changelog dir and config parameters

    enumerate all replicas
        if the replica logs changes:
            check if db file for replica exists in changelog dir
            move db to instannce database dir

                NOTE1: this has to be done using the database API
                NOTE2: sepatate changelog files only exist for BDB, upgrade only to BDB

            merge config parameters to replica config

            remove old changelog dir

            remove changelog5 config entry



Changelog Database Access
=========================

AS long as the changelog database was maintained independedently from the main database a complex mechanism was
implemented to ensure that the database environment does not go away while the changelog was used. With the new method
the changelog db file is part of the main database and we can rely on the plugin dependency and the order of startup and shutdown:
the multimaster replication plugin will start after the database plugin and close earlier.

This chapter will handle all the accessors of the changelog and the scenarios where the changelog can become unavailable.

## Functions operating on the changelog

### Writing the changelog

The changelog is updated for each changelog in write_changelog_and_ruv(). It is called in the txn postop phase of each update operation:
add, delete, modify, modrdn. Since these operations themselves require the database to be online it is available to write to the changelog

### Replaying the changelog

Each replication agreement for a replica spawns a thread implementing the replication protocol.

backend offline --> replica offline --> agmt pause ?


### Trimming the changelog


### Cleaning the changelog

in cleanallruv

### Exporting the changelog


## State changes affecting changelog

### Startup and Shutdown

### Backend state change

### replication config change

#### replica flags

#### trimming configuration


Impacted areas
==============

## Export and Import of Database


## Backup  and Restore of Database

=======
* Ticket [\#49476](https://pagure.io/389-ds-base/issue/49476) refactor ldbm backend to allow replacement of BDB

Related tickets: 
* Ticket [\#49469](https://pagure.io/389-ds-base/issue/49469)  cleanup backend code (1)
