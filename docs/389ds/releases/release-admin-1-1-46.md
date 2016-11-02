---
title: "Releases/AdminServer-1.1.46"
---
389 Admin Server 1.1.46
-----------------------------

The 389 Directory Server team is proud to announce 389-admin version 1.1.46.

Fedora packages are available from the EPEL7, Fedora 24, Fedora 25 and Rawhide repositories.

The new packages and versions are:

-   389-admin-1.1.46-1

Source tarballs are available for download at [Download Admin Source]({{ site.baseurl }}/binaries/389-admin-1.1.46.tar.bz2) and 

### Highlights in 389-admin-1.1.46

-   Single bug fix in register-ds-admin.pl.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   [389-admin-1.1.46-1.fc25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-9b83b14ff5)
-   [389-admin-1.1.46-1.fc24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-0b00fb5555)
-   [389-admin-1.1.46-1.el7](https://bodhi.fedoraproject.org/updates/FEDORA-EPEL-2016-7b134b993d)


### Detailed Changelog since 389-admin-1.1.45

-   Ticket 49015 - register-ds-admin - silent registration does not register local instances

