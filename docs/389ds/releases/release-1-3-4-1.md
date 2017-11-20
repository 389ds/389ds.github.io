---
title: "Releases/1.3.4.1"
---
389 Directory Server 1.3.4.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.1.

Fedora packages are available from the Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.1-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.1.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.1

-   Bugs reported by Coverity are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.1-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.0

-   Enable nunc-stans only for x86_64.
-   Ticket 48203 - Fix coverity issues - 06/22/2015
-   Bug 1234277 - distro-wide architecture set overriden by buildsystem; Upgrade nunc-stans to 0.1.5.
