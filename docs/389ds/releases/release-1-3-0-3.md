---
title: "Releases/1.3.0.3"
---
389 Directory Server 1.3.0.3
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.0.3.

Fedora packages are available from the Fedora 18 Testing repositories. It will move to the Fedora 18 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/FEDORA-2013-2485/389-ds-base-1.3.0.3-1.fc18) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.0.3-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.3.tar.bz2)

### Highlights in 1.3.0.3

-   Fix crash during password deletion for a non-existent entry.
-   Fix crash during suffix deletion.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds**

`yum install 389-ds`

After install completes, run **setup-ds-admin.pl** to set up your directory server.

`setup-ds-admin.pl`

To upgrade, use **yum upgrade**

`yum upgrade`

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

`setup-ds-admin.pl -u`

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.0.2

Mark Reynolds (1):

-   [Ticket 562 - Crash when deleting suffix](https://fedorahosted.org/389/ticket/562)

Noriko Hosoi (2):

-   [Ticket \#584 - Existence of an entry is not checked when its password is to be deleted](https://fedorahosted.org/389/ticket/584)
-   bump version to 1.3.0.3

