---
title: "Releases/1.3.0.6"
---
389 Directory Server 1.3.0.6
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.0.6.

Fedora packages are available from the Fedora 18 Testing repositories. It will move to the Fedora 18 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.0.6-1.fc18) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.0.6-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.6.tar.bz2)

### Highlights in 1.3.0.6

-   Fix csn retrieval issue in cleanAllRuv task.
-   Fix crash caused by schema-reload utility.
-   Fix start up failure after upgrade.

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

### Detailed Changelog since 1.3.0.5

Mark Reynolds (1):

-   [Ticket 47318 - server fails to start after upgrade(schema error)](https://fedorahosted.org/389/ticket/47318)

Noriko Hosoi (3):

-   bump version to 1.3.0.6
-   [Ticket 623 - cleanAllRUV task fails to cleanup config upon completion (Coverity defect: 13161: Resource leak)](https://fedorahosted.org/389/ticket/623)
-   Coverity fix (13139 - Dereference after NULL check in slapi\_attr\_value\_normalize\_ext())

