---
title: "Releases/1.3.5.1"
---
389 Directory Server 1.3.5.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.1.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.1-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.5.1.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.1

-   Initial 389-ds-base-1.3.5 release.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Initial Changelog

-   nunc-stans - bump version to 0.1.8
-   Ticket 132   - Makefile.am must include header files and template scripts
-   Ticket 142   - [RFE] Default password syntax settings don't work with fine-grained policies
-   Ticket 548   - RFE: Allow AD password sync to update shadowLastChange
-   Ticket 47788 - Only check postop result if its a replication operation
-   Ticket 47840 - add configure option to disable instance specific scripts
-   Ticket 47968 - [RFE] Send logs to journald
-   Ticket 47977 - [RFE] Implement sd_notify mechanism
-   Ticket 47982 - improve timestamp resolution in logs
-   Ticket 48016 - search, matching rules and filter error "unsupported type 0xA9"
-   Ticket 48144 - Add /usr/sbin/status-dirsrv script to get the status of the directory server instance.
-   Ticket 48145 - RFE Add log file for rejected changes
-   Ticket 48147 - Unable to enable DS service for auto start
-   Ticket 48151 - Improve CleanAllRUV task logging
-   Ticket 48218 - cleanAllRUV - modify the existing "force" option to bypass the "replica online" checks
-   Ticket 48244 - No validation check for the value for nsslapd-db-locks.
-   Ticket 48257 - Fix coverity issues - 08/24/2015
-   Ticket 48263 - allow plugins to detect tombstone operations
-   Ticket 48269 - RFE: need an easy way to detect locked accounts locked by inactivity.
-   Ticket 48270 - fail to index an attribute with a specific matching rule/48269
-   Ticket 48280 - enable logging of internal ops in the audit log
-   Ticket 48285 - The dirsrv user/group should be created in rpm %pre, and ideally with fixed uid/gid
-   Ticket 48289 - 389-ds-base: ldclt-bin killed by SIGSEGV
-   Ticket 48290 - No man page entry for - option '-u' of dbgen.pl for adding group entries with uniquemembers
-   Ticket 48294 - Linked Attributes plug-in - won't update links after MODRDN operation
-   Ticket 48295 - Entry cache is not rolled back -- Linked Attributes plug-in - wrong behaviour when adding valid and broken links
-   Ticket 48311 - nunc-stans: Attempt to release connection that is not acquired
-   Ticket 48317 - SELinux port labeling retry attempts are excessive
-   Ticket 48326 - [RFE] it could be nice to have nsslapd-maxbersize default to bigger than 2Mb
-   Ticket 48350 - configure.ac add options for debbuging and security analysis / hardening.
-   Ticket 48351 - Fix buffer overflow error when reading url with len 0
-   Ticket 48363 - Support for rfc3673 '+' to return operational attributes
-   Ticket 48368 - Resolve the py.test conflicts with the create_test.py issue
-   Ticket 48369 - [RFE] response control for password age should be sent by default by RHDS
-   Ticket 48383 - import tasks with dynamic buffer sizes
-   Ticket 48384 - Server startup should warn about values consuming too much ram
-   Ticket 48386 - Clean up dsktune code
-   Ticket 48387 - ASAN invalid read in cos_cache.c
-   Ticket 48394 - lower password history minimum to 1
-   Ticket 48395 - ASAN - Use after free in uiduniq 7bit.c
-   Ticket 48398 - Coverity defect 13352 - Resource leak in auditlog.c
-   Ticket 48400 - ldclt - segmentation fault error while binding
-   Ticket 48420 - change severity of some messages related to "keep alive" entries
-   Ticket 48445 - keep alive entries can break replication
-   Ticket 48446 - logconv.pl displays negative operation speeds
-   Ticket 48497 - extended search without MR indexed attribute prevents later indexing with that MR
-   Ticket 48537 - undefined reference to `abstraction_increment'
-   Ticket 48566 - acl.c attrFilterArray maybe uninitialised.
-   Ticket 48662 - db2index with no attribute args fail.
-   Ticket 48665 - Prevent sefault in ldbm_instance_modify_config_entry
-   Ticket 48746 - Crash when indexing an attribute with a matching rule
-   Ticket 48747 - dirsrv service fails to start when nsslapd-listenhost is configured
-   Ticket 48748 - Fix memory_leaks test suite teardown failure
-   Ticket 48757 - License tag does not match actual license of code
-   Ticket 48759 - no plugin calls in tombstone purging
