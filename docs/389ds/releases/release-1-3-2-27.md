---
title: "Releases/1.3.2.27"
---
389 Directory Server 1.3.2.27
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.27.

Fedora packages are available from the Fedora 20 repository.

The new packages and versions are:

-   389-ds-base-1.3.2.27-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.27.tar.bz2)

### Highlights in 1.3.2.27

-   Several bugs are fixed including security bugs -- stop using old SSL version.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.2.27-1.fc20>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.2.26

-   Bug 1199675 - CVE-2014-8112 CVE-2014-8105 389-ds-base: various flaws [fedora-all]
-   Ticket 48001 - ns-activate.pl fails to activate account if it was disabled on AD
-   Ticket 48027 - revise the rootdn plugin configuration validation
