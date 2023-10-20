---
title: "BerkeleyDB backend deprecation"

---

# FAQ about BerkeleyDB backend deprecation and using LMDB backend

Since 389-ds-base 2.1.0, The 389 ldap directory server supports two kind of underlying database:

- Berkeley Database (BerkeleyDB)

- Lightning Memory-Mapped Database Manager (LMDB)

Starting from version 3.0.0 New instances are no longer created with BerkeleyDB by default but with LMDB.

Newly created instances are still created with BerkeleyDB by default while libdb is flagged as [deprecated since Fedora 33]([Changes/Libdb deprecated - Fedora Project Wiki](https://fedoraproject.org/wiki/Changes/Libdb_deprecated)), this change is about to:

- create LMDB instances by default.

- warn that BerkeleyDB is deprecated and may be removed in future versions.

{% include toc.md %}

## Why deprecating BerkeleyDB backend ?

Because the underlying library implementing the BerkeleyDB version used by 389-ds-base is no longer supported upstream and it is already deprecated in some OS:

- [Changes/Libdb deprecated - Fedora Project Wiki](https://fedoraproject.org/wiki/Changes/Libdb_deprecated)

## How the database implementation switch is implemented ?

The database implementation is determined by the `nsslapd-backend-implement` attribute of `cn=config,cn=ldbm database,cn=plugins,cn=config` entry
Its value determines the database type and the config entry (containing the database specific parameters) that is used:

| Database   | Value | Config entry                                           |
| ---------- | ----- | ------------------------------------------------------ |
| BerkeleyDB | bdb   | cn=bdb,cn=config,cn=ldbm database,cn=plugins,cn=config |
| LMDB       | mdb   | cn=mdb,cn=config,cn=ldbm database,cn=plugins,cn=config |

## How to configure a new instance with LMDB or BerkeleyDB ?

There are several ways:

1. Using `dscreate interactive`:
   Select the proper implementation when the following question is asked:
   
   ```
   Choose whether mdb or bdb is used.
   ```

2. Using `dscreate from-file`:
   Set the following stanza in the template file:
   
   ```
   [slapd]
   db_lib = mdb (or bdb)
   ```

3. Using `dscreate` with an environment variable.
   Setting `NSSLAPD_DB_LIB` environment variable to `bdb` or `mdb` changes the backend implementation chosen by default

Set  `db_lib = mdb` (or `bdb`) in `[slapd]` section of `dscreate` template file

## Can I mix different implementations ?

Mixing implementations limitations are:

- The `nsslapd-backend-implement` is global to the instance.
- backup / restore formats are tied to the db implementation so you cannot use a backup to restore an instance with a different implementation. (ldif export/import and initializing through the replication do not have this limitation)

| Question                                                                    | Answer |
| --------------------------------------------------------------------------- | ------ |
| Can I mix backends with different implementations in an instance ?          | No     |
| Can I mix instances with different backends implementations on an host      | Yes    |
| Can I mix replicas with different implementation in a replicated topology ? | Yes    |

## How to migrate between database implementation ?

There are several ways to do that.

### Automatic method

- `dsctl instanceName dblib bdb2mdb`

- `dsctl instanceName dblib mdb2bdb`

Note: these tools do not cleanup the old data (so you can revert by simply changing nsslapd-backend-implement back).
To remove the old database, after verifying that everything is working as expected, the following command should be run:

- `dsctl instanceName dblib cleanup`

#### Manual Method - export to ldif

[A] Export all the backends to ldif

[B] This step should be skipped when migrationg from LMDB to BerkeleyDB.
Determine the LMDB database maximum size. A way to do that could be
to compute the existing databases size and add a safety margin:

- Add the results of
  
  ```
    du -hs  /var/lib/dirsrv/slapd-instanceName/db/*/.
  ```
  
  - Add a 20% Margin

[C] Change `nsslapd-backend-implement`:

```
dsconf instanceName backend config set --db-lib mdb
dsctl instanceName restart
```

[D] This step should be skipped when migrationg from LMDB to BerkeleyDB.
Set `mdb-max-size` to the value computed in step [B]

```
dsconf instanceName backend config set --mdb-max-size 2G
dsctl instanceName restart
```

[E] Import the ldif on all backends

[F] This step should be skipped when migrationg from BerkeleyDB.Optionally to LMDB.
Usually the default values are good enough but optionnaly some BerkeleyDB database parameters may need to be tuned. (Typically the database cache size)

### Manual method - initialize through replication

Same as the export method with the following changes:

skip step [A]

replace step [E] by: initialize all backends through replication from another supplier

## What is the plan for OS that does not anymore provide libdb ?

We plan to provide a tool that will still be able to read the BerkeleyDB databases to
export the data in ldif

## What are the impact of using LMDB ?

Underlying database implementation is controlled by the `nsslapd-backend-implement`
config attribute.

Most functionalities and interfaces are not impacted by switching its value from `bdb` to `mdb` but there are still some impacts:

- Backend configuration attributes
- Backend monitoring attributes
- Performances

### Backend configuration attributes impact

Some configuration parameters are used or unused depending of the underlying database:

| nsslapd-backend-implement | Config attribute name                 |
| ------------------------- | ------------------------------------- |
| mdb only                  | nsslapd-mdb-max-size                  |
| mdb only                  | nsslapd-mdb-max-readers               |
| mdb only                  | nsslapd-mdb-max-dbs                   |
| bdb only                  | nsslapd-dbcachesize                   |
| bdb only                  | nsslapd-dbncache                      |
| bdb only                  | nsslapd-db-logdirectory               |
| bdb only                  | nsslapd-db-circular-logging           |
| bdb only                  | nsslapd-db-transaction-wait           |
| bdb only                  | nsslapd-db-checkpoint-interval        |
| bdb only                  | nsslapd-db-compactdb-interval         |
| bdb only                  | nsslapd-db-compactdb-time             |
| bdb only                  | nsslapd-db-transaction-batch-val      |
| bdb only                  | nsslapd-db-transaction-batch-min-wait |
| bdb only                  | nsslapd-db-transaction-batch-max-wait |
| bdb only                  | nsslapd-db-logbuf-size                |
| bdb only                  | nsslapd-db-page-size                  |
| bdb only                  | nsslapd-db-index-page-size            |
| bdb only                  | nsslapd-db-logfile-size               |
| bdb only                  | nsslapd-db-trickle-percentage         |
| bdb only                  | nsslapd-db-spin-count                 |
| bdb only                  | nsslapd-db-verbose                    |
| bdb only                  | nsslapd-db-debug                      |
| bdb only                  | nsslapd-db-locks                      |
| bdb only                  | nsslapd-db-locks-monitoring-enabled   |
| bdb only                  | nsslapd-db-locks-monitoring-threshold |
| bdb only                  | nsslapd-db-locks-monitoring-pause     |
| bdb only                  | nsslapd-db-named-regions              |
| bdb only                  | nsslapd-db-private-mem                |
| bdb only                  | nsslapd-db-private-import-mem         |
| bdb only                  | nsslapd-db-shm-key                    |
| bdb only                  | nsslapd-db-debug-checkpointing        |
| bdb only                  | nsslapd-db-lockdown                   |
| bdb only                  | nsslapd-db-tx-max                     |
| bdb only                  | nsslapd-online-import-encrypt         |
| bdb only                  | nsslapd-db-deadlock-policy            |
| bdb or mdb                | nsslapd-db-home-directory             |
| bdb or mdb                | nsslapd-db-durable-transaction        |
| bdb or mdb                | nsslapd-db-transaction-logging        |
| bdb or mdb                | nsslapd-db-idl-divisor                |
| bdb or mdb                | nsslapd-db-old-idl-maxids             |

### Backend monitoring attribute impact

Attribute in `cn=monitor,cn=*backend_name*,cn=ldbm database,cn=plugins,cn=config` entries also change depending of the underlying database

| nsslapd-backend-implement | Monitoring attribute name     |
| ------------------------- | ----------------------------- |
| mdb                       | abortROtxn                    |
| mdb                       | abortRWtxn                    |
| mdb                       | activeROtxn                   |
| mdb                       | activeRWtxn                   |
| mdb                       | commitROtxn                   |
| mdb                       | commitRWtxn                   |
| bdb or mdb                | currentDnCacheCount           |
| bdb or mdb                | currentDnCacheSize            |
| bdb or mdb                | currentEntryCacheCount        |
| bdb or mdb                | currentEntryCacheSize         |
| bdb or mdb                | currentNormalizedDnCacheCount |
| bdb or mdb                | currentNormalizedDnCacheSize  |
| bdb or mdb                | database                      |
| bdb                       | dbCacheHitRatio               |
| bdb                       | dbCacheHits                   |
| bdb                       | dbCachePageIn                 |
| bdb                       | dbCachePageOut                |
| bdb                       | dbCacheROEvict                |
| bdb                       | dbCacheRWEvict                |
| bdb                       | dbCacheTries                  |
| mdb                       | dbenvLastPageNo               |
| mdb                       | dbenvLastTxnId                |
| mdb                       | dbenvMapMaxSize               |
| mdb                       | dbenvMapSize                  |
| mdb                       | dbenvMaxReaders               |
| mdb                       | dbenvNumDBIs                  |
| mdb                       | dbenvNumReaders               |
| bdb                       | dbFileCacheHit-%d             |
| bdb                       | dbFileCacheMiss-%d            |
| bdb                       | dbFilename-%d                 |
| bdb                       | dbFilePageIn-%d               |
| bdb                       | dbFilePageOut-%d              |
| mdb                       | dbiBranchPages                |
| mdb                       | dbiBranchPages-%d             |
| mdb                       | dbiEntries-%d                 |
| mdb                       | dbiFlags-%d                   |
| mdb                       | dbiLeafPages                  |
| mdb                       | dbiLeafPages-%d               |
| mdb                       | dbiName-%d                    |
| mdb                       | dbiOverflowPages              |
| mdb                       | dbiOverflowPages-%d           |
| mdb                       | dbiPageSize                   |
| mdb                       | dbiPageSize-%d                |
| mdb                       | dbiTreeDepth                  |
| mdb                       | dbiTreeDepth-%d               |
| bdb or mdb                | dnCacheHitRatio               |
| bdb or mdb                | dnCacheHits                   |
| bdb or mdb                | dnCacheTries                  |
| bdb or mdb                | entryCacheHitRatio            |
| bdb or mdb                | entryCacheHits                |
| bdb or mdb                | entryCacheTries               |
| mdb                       | grantTimeROtxn                |
| mdb                       | grantTimeRWtxn                |
| mdb                       | lifeTimeROtxn                 |
| mdb                       | lifeTimeRWtxn                 |
| bdb or mdb                | maxDnCacheCount               |
| bdb or mdb                | maxDnCacheSize                |
| bdb or mdb                | maxEntryCacheCount            |
| bdb or mdb                | maxEntryCacheSize             |
| bdb or mdb                | maxNormalizedDnCacheSize      |
| bdb or mdb                | NormalizedDnCacheEvictions    |
| bdb or mdb                | normalizedDnCacheHitRatio     |
| bdb or mdb                | normalizedDnCacheHits         |
| bdb or mdb                | normalizedDnCacheMisses       |
| bdb or mdb                | NormalizedDnCacheThreadSize   |
| bdb or mdb                | NormalizedDnCacheThreadSlots  |
| bdb or mdb                | normalizedDnCacheTries        |
| bdb or mdb                | readOnly                      |
| mdb                       | waitingROtxn                  |
| mdb                       | waitingRWtxn                  |

### Performances impact

Several points related to the implementation differences between LMDB and BerkeleyDB

impacts the performances

[A] LMDB does not support `DB_RECNUM` database.
This impacts the VLV searches (there is no fast way to get a record by using its position,
  we have to traverse all the records and count them so even if VLV searches are still working with LMDB, they are very slow).

[B] The locking mechanism is very different. There can only be a single write transaction at a given time.

The fact that the writes needs to be serialized  impacts:

- The import performances because the database write needs to be serialized.

- The multiple backends write performances

[C] The fact that all the database is in virtual memory instead of using a database cache

- The impact seems to be very limited. (So far we have not noticed any performance degradation on random search nor on modify operations)
