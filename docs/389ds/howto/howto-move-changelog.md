---
title: "Move Changelog"
---

# Move Replication Changelog
----------------

{% include toc.md %}

Background
==========

Improved performance, robustness and consistency

-   Having a separated BDB environment adds Directory Server extra memory for db cache as well as log, log caches (13MB +).
-   Backup/Restore the main DB does not include changelog DB. After restoring the main DB from the backup, running consumer initialization is MUST to regenerate the changelog.

By sharing the main DB's dbEnv with the replication changelog, the above issues are solved.

Note: the version which supports merged changelog is v1.2.7 or newer

Implementation
==============

\_cl5AppInit (replication/cl5\_api.c) retrieves dbEnv and pagesize from the backend plugin (back-ldbm) using the newly introduced slapi API slapi\_back\_get\_info. The rest of the logic handling changelog db remains intact. By sharing the backend DB env, we could eliminate the following changelog db configuration parameters under cn=changelog5,cn=config:

    nsslapd-cachesize    
    nsslapd-cachememsize    
    nsslapd-db-checkpoint-interval    
    nsslapd-db-circular-logging    
    nsslapd-db-logfile-size    
    nsslapd-db-max-txn    
    nsslapd-db-verbose    
    nsslapd-db-debug    
    nsslapd-db-trickle-percentage    
    nsslapd-db-spin-count    
    nsslapd-db-locks    

Note: the following parameters are still available.

    nsslapd-changelogdir    
    nsslapd-changelogmaxentries    
    nsslapd-changelogmaxage    
    nsslapd-changelogmaxconcurrentwrites    

**Backup/Restore:** db2bak and bak2db backs up and restores the changelogs in the changelog directory if the changelog entry (cn=changelog5,cn=config) as well as the value of nsslapd-changelogdir in the entry exist, the directory is copied to the backup directory under the directory .repl\_changelog\_backup. The changelog items are guaranteed to be synchronized with the main DB.
**Upgrade:** an upgrade script calls db\_checkpoint against the changelog db files, then remove the DB env files and transaction log files.

New APIs
========

    int slapi_back_get_info(Slapi_Backend *be, int cmd, void **info);    
    * Get backend info based upon cmd    
    *    
    * parameters    
    * be Backend from which the information will be retrieved    
    * cmd macro to specify the information type    
    * info pointer to store the information    
    * return values    
    * 0 if the operation was successful    
    * non-0 if the operation was not successful    
    *    
    * Implemented cmd:    
    * BACK_INFO_DBENV - Get the dbenv    

    int slapi_back_set_info(Slapi_Backend *be, int cmd, void *info);    
    * Set info to backend based upon cmd    
    *    
    * parameters    
    * be Backend to which the information will be set    
    * cmd macro to specify the information type    
    * info pointer to the information    
    * parameters    
    * 0 if the operation was successful    
    * non-0 if the operation was not successful    
    *    
    * Warning: No cmd is defined yet.    

Test Scenario
=============

-   Install 389 v1.2.6.
-   Configure single master - single replica.
-   Check changelogdir.

        # ls -l /var/lib/dirsrv/slapd-ID/changelogdb/    
        total 1860    
        -rw-------. 1 user group    24576 Sep  7 14:24 __db.001    
        -rw-------. 1 user group  1048576 Sep  7 14:28 __db.002    
        -rw-------. 1 user group 13115392 Sep  7 14:24 __db.003    
        -rw-------. 1 user group   163840 Sep  7 14:28 __db.004    
        -rw-------. 1 user group   802816 Sep  7 14:24 __db.005    
        -rw-------. 1 user group    90112 Sep  7 14:26 __db.006    
        -rw-------. 1 user group       30 Sep  7 14:24 DBVERSION    
        -rw-------. 1 user group 10485760 Sep  7 14:26 log.0000000001    

-   Add/modify/delete entries and check the operations are replicated to the consumer.
-   Shutdown the master.

        #service dirsrv stop    

-   Run dbscan -f /var/lib/dirsrv/slapd-*ID*/changelogdb/<changelog>.db4.
-   Run yum upgrade 389-ds-base or rpm -Uvh 389-ds-base; setup-ds.pl -u; start the server.

        # ls -l /var/lib/dirsrv/slapd-ID/changelogdb/    
        total 84    
        -rw-------. 1 user group 73728 Sep  7 14:35 xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx_xxxxxxxxxxxxxxxxxxxx.db4    
        -rw-------. 1 user group    30 Sep  7 14:24 DBVERSION    

-   Add/modify/delete entries and check the operations are replicated to the consumer.
-   Make backups on each server. (\*)

        # /usr/lib64/dirsrv/slapd-ID/db2bak |& egrep changelog    
        Back up directory: /var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME
        [..] - Backing up file 32 (/var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME/.repl_changelog_backup/changelogdb/xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx_xxxxxxxxxxxxxxxxxxxx.db4)    
        [..] - Copying /var/lib/dirsrv/slapd-ID/changelogdb/xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx_xxxxxxxxxxxxxxxxxxxx.db4 to /var/lib/dirsrv/slapd-ID/bak/ID- DATE_TIME/.repl_changelog_backup/changelogdb/xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx_xxxxxxxxxxxxxxxxxxxx.db4    
        [..] - Backing up file 33 (/var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME    .repl_changelog_backup/changelogdb/DBVERSION)    
        [..] - Copying /var/lib/dirsrv/slapd-ID/changelogdb/DBVERSION to /var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME/.repl_changelog_backup/changelogdb/DBVERSION    
        # /usr/lib[64]/dirsrv/slapd-ID0/db2bak -q    
        Back up directory: /var/lib/dirsrv/slapd-ID0/bak/ID0-DATE_TIME

-   Stop the servers.

        # service dirsrv stop    

-   Restore from backups.

        # /usr/lib[64]/dirsrv/slapd-ID/db2bak -q /var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME
        Back up directory: /var/lib/dirsrv/slapd-ID/bak/ID-DATE_TIME
        # /usr/lib[64]/dirsrv/slapd-ID0/db2bak -q /var/lib/dirsrv/slapd-ID0/bak/ID0-DATE_TIME
        Back up directory: /var/lib/dirsrv/slapd-ID0/bak/ID0-DATE_TIME

-   Start the servers.

        # service dirsrv start    

-   Add/modify/delete entries and check the operations are replicated to the consumer.
-   Backup and Restore needs to be tested using tasks with the server up and running, as well (either from Console or db2bak.pl/bak2db.pl).

(*) The changelog directory is backed up to the directory .repl\_changelog\_backup under the back up directory. For instance, if the back up dir is /var/lib/dirsrv/slapd-ID/bak/todaysbakup and changelogdir name is cldir, then it will be backed up in /var/lib/dirsrv/slapd-ID/bak/todaysbakup/.repl\_changelog\_backup/cldir. ".repl\_changelog\_backup" is chosen to avoid the conflict with the backend instance name (e.g., netscaperoot, userroot).

Backing up Changelog
====================

The changelog db is now a part of the main backend database. The backing up utility db2bak[.pl]/Back Up on Console includes the changelog db's in the backed up database. By design, changelog db stores the RUVs at the close time. When starting up the server, it reads the stored RUVs from the changelog, sets them in memory and deletes them from the changelog. That is, when the server is running, the changelog db does not contain the RUV information. If the changelog dbs which do not have the RUVs are backed up, the server with the restored changelog dbs from the backup behaves abnormally. To prevent the problem, this restriction has been introduced to the standalone utility db2bak. db2bak.pl and Console Back Up has no limitation.

    db2bak.pl and Console Back up    
      -- the instance has no changelogs --> back up main backend db    
      -- the instance has changelogs    --> add RUVs to changelog; back up main backend db & changelog db; delete RUVs from changelog    
    db2bak    
      -- the instance has no changelogs --> back up main backend db    
      -- the instance has changelogs    -- the server is down --> back up main backend db & changelog db, which stores the RUVs    
                                        -- the server is up   --> back up fails with this error:    
                                              [...] - db2archive: pre-backup-plugin failed (1).    
                                              [...] - ERROR: Standalone db2bak is not supported \    
                                              when a multimaster replication enabled server is coexisting.    
                                              Please use db2bak.pl, instead.    

To back up the database while the server is up, task version of the back up utility (db2bak.pl or Console) needs to be used. The standalone utility db2bak can be used either when the server is down or when the the server is not a master.

Transactions
============

Now that the changelog shares the main database environment, it can use the main database transaction for its writes. This will make it so that the changelog can never be out of sync with the main database. It should also speed up writes - if all writes are committed in a single transaction, that's a single call to fdatasync() instead of two.

Tasks
-----

-   Create new plugin types - *dbpreoptxn* and *dbpostoptxn* - these plugins are called while the main database transaction is active (between the call to dblayer\_txn\_begin and dblayer\_txn\_(commit\|abort))
    -   dbpreoptxn plugins are called just after dblayer\_txn\_begin
    -   dbpostop plugins are called just before dblayer\_txn\_commit or \_abort
    -   The code that calls these plugins sets SLAPI\_TXN to the transaction to use
    -   If a plugin wants the transaction to be aborted, the plugin function should return a non-zero return, and the plugins should set SLAPI\_PLUGIN\_OPRETURN to a non-zero code
-   Rewrite the current replication dbpostop code to refactor the code that writes the changelog into a dbpostoptxn code
-   Extend the cl5\_api to allow the replication code to pass in the SLAPI\_TXN from the pblock
-   Change the cl5 code to use the passed-in transaction
-   Ideally we could just extend this to all plugins - but we have to solve the problem of searching within a transaction, and what to do about entries that may be in the entry cache - see [LDAP\_Transactions](../design/ldap-transactions.html)
-   Note that writing the RUV entry at the base of the replicated area already has special purpose code (SLAPI\_TXN\_RUV\_MODS\_FN) that allows that write to use the main database transaction - would rather not add more special purpose code since we need a general mechanism for this

Related Bugs
============

[Bug 633168](https://bugzilla.redhat.com/show_bug.cgi?id=633168) - Share backend dbEnv with the replication changelog
[Bug 669205](https://bugzilla.redhat.com/show_bug.cgi?id=669205) - db2bak: backed up changelog should include RUVs
