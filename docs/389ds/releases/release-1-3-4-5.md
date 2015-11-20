---
title: "Releases/1.3.4.5"
---
389 Directory Server 1.3.4.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.5.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.5-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.4.5.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.5

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.5-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.5-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.4

-   Ticket 47511 - bashisms in 389-ds-base admin scripts
-   Ticket 47553 - Automated the verification procedure
-   Ticket 47761 - Added a few testcases to the basic testsuite
-   Ticket 47957 - Add replication test suite for a wait async feature
-   Ticket 47976 - deadlock in mep delete post op
-   Ticket 47978 - Deadlock between two MODs on the same entry between entry cache and backend lock
-   Ticket 48188 - segfault in ns-slapd due to accessing Slapi_DN freed in pre bind plug-in
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48204 - update lib389 test scripts for python 3
-   Ticket 48217 - cleanallruv - fix regression with server shutdown
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48227 - rpm.mk doesn't build srpms for 389-ds and nunc-stans
-   Ticket 48254 - Shell CLI fails with usage errors if an argument containing white spaces is given
-   Ticket 48264 - Ticket 47553 tests refactoring
-   Ticket 48266 - Fractional replication evaluates several times the same CSN
-   Ticket 48266 - coverity issue
-   Ticket 48266 - do not free repl keep alive entry on error
-   Ticket 48266 - Online init crashes consumer
-   Ticket 48267 - Add config setting to MO plugin to add objectclass
-   Ticket 48273 - Update lib389 tests for new valgrind functions
-   Ticket 48276 - initialize free_flags in reslimit_update_from_entry()
-   Ticket 48279 - Check NULL reference in nssasl_mutex_lock etc. (saslbind.c)
-   Ticket 48283 - many attrlist_replace errors in connection with cleanallruv
-   Ticket 48284 - free entry when internal add fails
-   Ticket 48298 - ns-slapd crash during ipa-replica-manage del
-   Ticket 48299 - pagedresults - when timed out, search results could have been already freed.
-   Ticket 48304 - ns-slapd - LOGINFO:Unable to remove file
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48311 - nunc-stans: Attempt to release connection that is not acquired
-   Ticket 48316 - Perl-5.20.3-328: Use of literal control characters in variable names is deprecated
-   Ticket 48325 - Add lib389 test script
-   Ticket 48325 - Replica promotion leaves RUV out of order
-   Ticket 48338 - SimplePagedResults -- abandon could happen between the abandon check and sending results
-   Ticket 48339 - Share nsslapd-threadnumber in the case nunc-stans is enabled, as well.
-   Ticket 48344 - acl - regression - trailing ', (comma)' in macro matched value is not removed.
-   Ticket 48348 - Running /usr/sbin/setup-ds.pl fails with Can't locate bigint.pm, plus two warnings
