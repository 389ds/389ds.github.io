---
title: "Releases/1.3.4.9"
---
389 Directory Server 1.3.4.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.9.

Fedora packages are available from the Fedora 22 and 23 repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.9-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.4.9.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.9

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.9-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.9-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.8

-   Ticket 48759 - no plugin calls in tombstone purging
-   Ticket 48757 - License tag does not match actual license of code
-   Ticket 48746 - Crash when indexing an attribute with a matching rule
-   ticket 48497 - extended search without MR indexed attribute prevents later indexing with that MR
-   Ticket 48368 - Resolve the py.test conflicts with the create_test.py issue
-   Ticket 48420 - change severity of some messages related to "keep alive" entries
-   Ticket 48748 - Fix memory_leaks test suite teardown failure
-   Ticket 48270 - fail to index an attribute with a specific matching rule



