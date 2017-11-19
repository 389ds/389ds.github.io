---
title: "Releases/1.3.1.13"
---
389 Directory Server 1.3.1.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.13.

Fedora packages are available from the Fedora 19 Testing repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.13-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.13.tar.bz2)

### Highlights in 1.3.1.13

-   enhancement in slapi API slapi\_back\_transaction\_begin.
-   bug fixes in DNA plug-in, logconv utility, and fixup memberof task.
-   server hung and crash bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1.12

-   Ticket 47329 - Improve slapi\_back\_transaction\_begin() return code when transactions are not available
-   Ticket 47379 - DNA plugin failed to fetch replication agreement
-   Ticket 47550 - logconv: failed logins: Use of uninitialized value in numeric comparison at logconv.pl line 949
-   Ticket 47559 - hung server - related to sasl and initialize
-   Ticket 47560 - fixup memberof task does not work: task entry not added
-   Ticket 47577 - crash when removing entries from cache
-   Ticket 47581 - Winsync plugin segfault during incremental backoff
-   Coverity Fixes

