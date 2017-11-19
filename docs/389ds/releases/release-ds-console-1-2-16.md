---
title: "Releases/ds-console-1.2.16"
---
389 Ds Console 1.2.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-console version 1.2.16.

Fedora packages are available from the EPEL7, Fedora 24, Fedora 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-console-1.2.16-1

Source tarballs are available for download at 
[Download 389 Ds Console Source]({{ site.binaries_url }}/binaries/389-ds-console-1.2.16.tar.bz2), 

### Highlights in 389-ds-console-1.2.16

-   Several bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   EPEL 7 <https://bodhi.fedoraproject.org/updates/FEDORA-EPEL-2016-a76a90c2a3>
-   Fedora 24 <https://bodhi.fedoraproject.org/updates/FEDORA-2016-6754b499c8>
-   Fedora 25 <https://bodhi.fedoraproject.org/updates/FEDORA-2016-939fc9ed37>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-ds-console-1.2.15

-   Ticket 48743 - ds-console enables obsolete SSL ciphers by default



