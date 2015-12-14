---
title: "Releases/1.3.1.6"
---
389 Directory Server 1.3.1.6
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.6.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.6-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.6-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.6.tar.bz2)

### Highlights in 1.3.1.6

An import task crash bug found in the previous version was fixed.

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

### Detailed Changelog since 1.3.1.5

-   Ticket 47450 - Fix compiler formatting warning errors for 32/64 bit arch
-   Ticket 47455 - valgrind - value mem leaks, uninit mem usage
-   fix coverity 11895 - null deref - caused by fix to ticket 47392
-   fix coverity 11915 - dead code - introduced with fix for ticket 346
-   fix compiler warnings
-   fix compiler warning in posix winsync code for posix\_group\_del\_memberuid\_callback
-   fix compiler warnings for Ticket 47395 and 47397
-   fix compiler warning (cherry picked from commit 904416f4631d842a105851b4a9931ae17822a107)
-   fix compiler warning (cherry picked from commit ec6ebc0b0f085a82041d993ab2450a3922ef5502)

