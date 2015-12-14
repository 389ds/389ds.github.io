---
title: "Releases/1.3.3.13"
---
389 Directory Server 1.3.3.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.13.

Fedora packages are available from the Fedora 21 repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.13-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.13.tar.bz2)

### Highlights in 1.3.3.13

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.13-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.12

-   Ticket 48265 - Complex filter in a search request doen't work as expected. (regression)
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as invalid when there are multiple suffixes
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48254 - CLI db2index fails with usage errors
-   Ticket 47831 - remove debug logging from retro cl
-   Ticket 48245 - Man pages and help for remove-ds.pl doesn't display "-a" option
-   Ticket 47931 - Fix coverity issues
-   Ticket 47931 - memberOf & retrocl deadlocks
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48215 - update dbverify usage in main.c
-   Ticket 48215 - update dbverify usage
-   Ticket 48215 - verify_db.pl doesn't verify DB specified by -a option
-   Ticket 47810 - memberOf plugin not properly rejecting updates
-   Ticket 48231 - logconv autobind handling regression caused by 47446
-   Ticket 48232 - winsync lastlogon attribute not syncing between DS and AD.
-   Ticket 48206 - Crash during retro changelog trimming
-   Ticket 48224 - redux 2 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48224 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48212 - Dynamic nsMatchingRule changes had no effect on the attrinfo thus following reindexing, as well.
-   Ticket 48195 - Slow replication when deleting large quantities of multi-valued attributes
-   Ticket 48175 - Avoid using regex in ACL if possible
