---
title: "Releases/1.3.5.3"
---
389 Directory Server 1.3.5.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.3.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.3-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.3.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.3

-   Bug fixes and enhancements.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-2.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.5.1

-   Ticket 47536 - Allow usage of OpenLDAP libraries that don't use NSS for crypto
-   Ticket 47536 - CI test: added test cases for ticket 47536
-   Ticket 47840 - default instance scripts if undefined.
-   Ticket 47888 - Add CI test
-   Ticket 47888 - DES to AES password conversion fails if a backend is empty
-   Ticket 47951 - Fix startpid from altering dev/null
-   Ticket 47968 - Disable journald logs by default
-   Ticket 47982 - HR Log timers, regression fix for subsystem logging
-   Ticket 48078 - CI test - paged_results - TET part
-   Ticket 48144 - Add /usr/sbin/status-dirsrv script to get the status of the directory server instance.
-   Ticket 48269 - ns-accountstatus status message improvement
-   Ticket 48342 - DNA: deadlock during DNA_EXTEND_EXOP_REQUEST_OID
-   Ticket 48342 - DNA Deadlock test cases
-   Ticket 48342 - Prevent transaction abort if a transaction has not begun
-   Ticket 48350 - Integrate ASAN into our rpm build process
-   Ticket 48374 - entry cache locks not released in error conditions
-   Ticket 48410 - 389-ds-base - Unable to remove / unregister a DS instance from admin server
-   Ticket 48447 - with-initddir should accept no
-   Ticket 48450 - Systemd password agent support
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48597 - Deadlock when rebuilding the group of authorized replication managers
-   Ticket 48662 - db2index with no attribute args fail.
-   Ticket 48710 - auto-dn-suffix unrecognized option
-   Ticket 48769 - Fix white space in extendedop.c
-   Ticket 48769 - RFE: Be_txn extended operation plugin type
-   Ticket 48770 - Improve extended op plugin handling
-   Ticket 48775 - If nsSSL3 is on, even if SSL v3 is not really enabled, a confusing message is logged.
-   Ticket 48779 - Remove startpidfile check in start-dirsrv
-   Ticket 48781 - Vague error message: setup_ol_tls_conn - failed: unable to create new TLS context
-   Ticket 48782 - Make sure that when LDAP_OPT_X_TLS_NEWCTX is set, the value is set to zero.
-   Ticket 48783 - Fix ns-accountstatus.pl syntax error
-   Ticket 48784 - CI test: added test cases for ticket 48784
-   Ticket 48784 - Make the SSL version set to the client library configurable.
-   Ticket 48798 - Enable DS to offer weaker DH params in NSS
-   Ticket 48799 - objectclass values could be dropped on the consumer
-   Ticket 48800 - Cleaning up error buffers
-   Ticket 48801 - ASAN errors during tests
-   Ticket 48802 - Compilation warnings from clang
-   Ticket 48808 - Add test case
-   Ticket 48808 - Paged results search returns the blank list of entries
-   Ticket 48813 - password history is not updated when an admin resets the password
-   Ticket 48815 - ns-accountstatus.sh does handle DN's with single quotes
-   Ticket 48818 - In docker, no one can hear your process hang.
-   Ticket 48822 - (389-ds-base-1.3.5) Fixing coverity issues.
-   Ticket 48824 - Cleanup rpm.mk and 389 specfile
