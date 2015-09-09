---
title: "Releases/1.3.4.4"
---
389 Directory Server 1.3.4.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.4.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.4.4.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.4

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.4-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.4-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.1

-   Ticket 48255 - total update request can be lost
-   Ticket 48263 - allow plugins to detect tombstone operations
-   Ticket 48265 - Complex filter in a search request doen't work as expected. (regression)
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as invalid when there are multiple suffixes
-   Ticket 48204 - Convert all python scripts to support python3
-   Ticket 48258 - dna plugin needs to handle binddn groups for authorization
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 47757 - Unable to dereference unqiemember attribute because it is dn [#UID] not dn syntax
-   Ticket 48254 - Shell CLI fails with usage errors if an argument containing white spaces is given
-   Ticket 48254 - CLI db2index fails with usage errors
-   Ticket 47831 - remove debug logging from retro cl
-   Ticket 48243 - replica upgrade failed in starting dirsrv service due to upgrade scripts did not run
-   Ticket 48233 - Server crashes in ACL_LasFindFlush during shutdown if ACIs contain IP addresss restrictions
-   Ticket 48250 - Slapd crashes reported from latest build
-   Ticket 48249 - sync_repl uuid may be invalid
-   Ticket 48245 - Man pages and help for remove-ds.pl doesn't display "-a" option
-   Ticket 47511 - bashisms in 389-ds-base admin scripts
-   Ticket 47686 - removing chaining database links trigger valgrind read errors
-   Ticket 47931 - memberOf & retrocl deadlocks
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48215 - update dbverify usage in main.c
-   Ticket 48215 - verify_db.pl doesn't verify DB specified by -a option
-   Ticket 47810 - memberOf plugin not properly rejecting updates
-   Ticket 48231 - logconv autobind handling regression caused by 47446
-   Ticket 48232 - winsync lastlogon attribute not syncing between DS and AD.
-   Ticket 48204 - Add Python 3 compatibility to ds-logpipe
-   Ticket 48010 - winsync range retrieval gets only 5000 values upon initialization
-   Ticket 48206 - Crash during retro changelog trimming
-   Ticket 48224 - redux 2 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 47910 - logconv.pl - check that the end time is greater than the start time
-   Ticket 48179 - Starting a replica agreement can lead to  deadlock
-   Ticket 48226 - CI test: added test cases for ticket 48226
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48203 - Fix coverity issues - 07/14/2015
-   Ticket 48194 - CI test: fixing test cases for ticket 48194
-   Ticket 48224 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 47910 - logconv.pl - validate start and end time args
-   Ticket 48223 - Winsync fails when AD users have multiple spaces (two)inside the value of the rdn attribute
-   Ticket 47878 - Remove warning suppression in 1.3.4
-   Ticket 48119 - Silent install needs to properly exit when INF file is missing
-   Ticket 48216 - crash in ns-slapd when deleting winSyncSubtreePair from sync agreement
-   Ticket 48217 - cleanAllRUV hangs shutdown if not all of the  replicas are online
-   Ticket 48013 - Inconsistent behaviour of DS when LDAP Sync is used with an invalid cookie
-   Ticket 47799 - Any negative LDAP error code number reported as Illegal error by ldclt.
-   Ticket 48208 - CleanAllRUV should completely purge changelog
-   Ticket 48203 - Fix coverity issues - 07/07/2015
-   Ticket 48119 - setup-ds.pl does not log invalid --file path errors the same way as other errors.
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48214 - CI test: added test cases for ticket 48213
-   Ticket 48214 - ldapsearch on nsslapd-maxbersize returns 0 instead of current value
-   Ticket 48212 - CI test: added test cases for ticket 48212
-   Ticket 48212 - Dynamic nsMatchingRule changes had no effect on the attrinfo thus following reindexing, as well.
-   Ticket 48195 - Slow replication when deleting large quantities of multi-valued attributes
