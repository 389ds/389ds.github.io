---
title: "Releases/1.3.4.14"
---
389 Directory Server 1.3.4.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.14.

Fedora packages are available from the Fedora 23 repository.

The new packages and versions are:

-   389-ds-base-1.3.4.14-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.4.14.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.14

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.14-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.9

-   CVE-2016-4992 389-ds-base: Information disclosure via repeated use of LDAP ADD operation, etc.
-   Ticket 47538 - Fix repl-monitor color and lag times
-   Ticket 47538 - repl-monitor.pl legend not properly sorted
-   Ticket 47538 - repl-monitor.pl not displaying correct color code for lag time
-   Ticket 47819 - RFE - improve tombstone purging performance
-   Ticket 47888 - DES to AES password conversion fails if a backend is empty
-   Ticket 47888 - Add CI test
-   Ticket 48078 - CI test - paged_results - TET part
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48497 - uncomment pytest from CI test
-   Ticket 48636 - Fix config validation check
-   Ticket 48636 - Improve replication convergence
-   Ticket 48752 - Page result search should return empty cookie if there is no returned entry
-   Ticket 48752 - Add CI test
-   Ticket 48755 - moving an entry could make the online init fail
-   Ticket 48766 - Replication changelog can incorrectly skip over updates
-   Ticket 48767 - flow control in replication also blocks receiving results
-   Ticket 48795 - Make various improvements to create_test.py
-   Ticket 48798 - Enable DS to offer weaker DH params in NSS
-   Ticket 48799 - objectclass values could be dropped on the consumer
-   Ticket 48799 - Test cases for objectClass values being dropped.
-   Ticket 48808 - Add test case
-   Ticket 48808 - Paged results search returns the blank list of entries
-   Ticket 48813 - password history is not updated when an admin resets the password
-   Ticket 48848 - modrdn deleteoldrdn can fail to find old attribute value, perhaps due to case folding
-   Ticket 48854 - Running db2index with no options breaks replication
-   Ticket 48862 - At startup DES to AES password conversion causes timeout in start script
-   Ticket 48889 - ldclt - fix man page and usage info
-   Ticket 48898 - Crash during shutdown if nunc-stans is enabled
-   Ticket 48900 - Add connection perf stats to logconv.pl
-   Ticket 48922 - Fix crash when deleting backend while import is running
-   Ticket 48924 - Fixup tombstone task needs to set proper flag when updating tombstones
-   Ticket 48930 - Paged result search can hang the server
-   Ticket 48935 - Update dirsrv.systemd file
