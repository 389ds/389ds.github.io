---
title: "Releases/1.3.3.14"
---
389 Directory Server 1.3.3.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.14.

Fedora packages are available from the Fedora 21 repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.14-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.14.tar.bz2)

### Highlights in 1.3.3.14

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.14-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.13

-   Ticket 47553 - Automated the verification procedure
-   Ticket 47957 - Add replication test suite for a wait async feature
-   Ticket 47976 - deadlock in mep delete post op
-   Ticket 47978 - Deadlock between two MODs on the same entry between entry cache and backend lock
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48208 - CleanAllRUV should completely purge changelog
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48264 - Ticket 47553 tests refactoring
-   Ticket 48266 - Fractional replication evaluates several times the same CSN
-   Ticket 48266 - coverity issue
-   Ticket 48266 - do not free repl keep alive entry on error
-   Ticket 48266 - Online init crashes consumer
-   Ticket 48273 - Update lib389 tests for new valgrind functions
-   Ticket 48283 - many attrlist_replace errors in connection with cleanallruv
-   Ticket 48284 - free entry when internal add fails
-   Ticket 48299 - pagedresults - when timed out, search results could have been already freed.
-   Ticket 48304 - ns-slapd - LOGINFO:Unable to remove file
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48325 - Add lib389 test script
-   Ticket 48325 - Replica promotion leaves RUV out of order
-   Ticket 48338 - SimplePagedResults -- abandon could happen between the abandon check and sending results
