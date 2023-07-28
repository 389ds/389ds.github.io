---
title: "Integrate changelog and backen database"
---

# Integrate Changelog and Backend Database
------------------

{% include toc.md %}

Motivation
==========

On suppliers and hubs the multisupplier replication plugin maintains a changelog database containing the changes to be
replayed to other servers. Historically this was a  separate databse environment, but with the need to write the changelog
in the same transaction as the change operation it was changed to use the main database environment.

But it still maintains the changelog for all backends in a single directory and manages th file names to open and close the
changelog database files. This has an overhead in many respects, but it also prevents the move to a replacable backend database
library, eg LMDB does not allow the use of dedicated database files.

Therfore, as a first step, the changlog database files should be fully integrated to the backend database.

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
     nsslapd-changelogdir: /var/lib/dirsrv/slapd-supplier2/changelogdb

where the changelogdir is the only required attribute. Additional configuration attributes are:


     nsslapd-changelogmaxentries: minimum number of records to keep in the changelog

     nsslapd-changelogmaxage: minimum time to keep a record in the changelog

     nsslapd-changelogcompactdb-interval: time between two attempts to compact the changelog

     nsslapd-changelogtrim-interval: time between two attempts to trim the changelog

     nsslapd-encryptionalgorithm: algorithm to use for changelog encryption, presence turns encryption n

     nsSymmetricKey: key used for encrypt/decrypt (encrypted by server cert)

This changelog configuration is global, there is no way to enable trimming or encryption for only a specific backend. The maxentries value is a sum accross all changelogs.



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

If an existing instance is upgraded the following action will be done during startup when multisupplier_replication_start() is called.

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

As long as the changelog database was maintained independedently from the main database a complex mechanism was
implemented to ensure that the database environment does not go away while the changelog was used. With the new method
the changelog db file is part of the main database and we can rely on the plugin dependency and the order of startup and shutdown:
the multisupplier replication plugin will start after the database plugin and close earlier.

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

### Exporting the Changelog


## State changes affecting Changelog

### Startup and Shutdown

### Backend State Change

### Replication Config Change

#### Replica Flags

#### Trimming Configuration


Impacted areas
==============

## Export and Import of Database

In the current implemtation there are tasks for an ldif export of the changelog and for import of the changelog. But the reimport of an online export will in most cases
lead to an mismatch between changelog and database. The motivation for reimport was probably the case of encrypted changelog and certificate change or to comapct the chamgelog
database by reimporting.

The export/import of the changelog database does only make sense if it is done together with an export/import of the main database. Only then database and changelog will
match after import. Therefor the export and import modes will be extended and have an optional changleog export/import.

Also reimporting the changelog is only useful in connection with ldif exports including replication meta data. It requires the "-r" option.

The new option is:

     -R    export the changelog database
           this enforces -r for export of the main database
           if the ldif file for export is <ldif_file_name>.ldif the changelog will
           be exported to <ldif_file_name>_cl.ldif

## Backup  and Restore of Database

The changelog database is part of the backend directory and will automatically included in backup/restore.
All the extra code for handling the separate changelog directory cna be removed.
As the writing of the changelog RUV in a backup is also unnecessary this extra handling can also be removed, see ticket ....

=======
* Ticket [\#2621](https://github.com/389ds/389-ds-base/issues/2621) integrate changelog database to main database

Related tickets:
* Ticket [\#2535](https://github.com/389ds/389-ds-base/issues/2535) refactor ldbm backend to allow replacement of BDB
* Ticket [\#2609](https://github.com/389ds/389-ds-base/issues/2609) do not write changelog RUV in online backup
* Ticket [\#2584](https://github.com/389ds/389-ds-base/issues/2584) Improve attr encryption key rollover
