---
title: "DSGW 1.1.10"
---

# 389 Directory Server Gateway 1.1.10
-----------------------------------

The 389 Directory Server team is proud to announce 389-dsgw version 1.1.10.

Fedora packages are available from the Fedora 18 Testing repositories. It will move to the Fedora 18 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/FEDORA-2013-2485/389-dsgw-1.1.10-1.fc18) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-dsgw-1.1.10-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-dsgw-1.1.10.tar.bz2)

### Highlights in 1.1.10

-   Fixed format string errors that allowed for buffer overflows.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-dsgw**

`yum install 389-dsgw`

To upgrade, use **yum upgrade**

`yum upgrade`

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.1.9

Mark Reynolds (2):

-   bump version to 1.1.10
-   [Ticket 606 - Format string errors](https://fedorahosted.org/389/ticket/606)

