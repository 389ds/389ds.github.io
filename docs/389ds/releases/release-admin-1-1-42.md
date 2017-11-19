---
title: "Releases/AdminServer-1.1.42"
---
389 Admin Server 1.1.42
-----------------------------

The 389 Directory Server team is proud to announce 389-admin version 1.1.42 and 389-adminutil version 1.1.22.

Fedora packages are available from the EPEL7, Fedora 21, Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-admin-1.1.42-1
-   389-adminutil-1.1.22-1

Source tarballs are available for download at [Download Admin Source]({{ site.binaries_url }}/binaries/389-admin-1.1.42.tar.bz2) and 
[Download Adminutil Source]({{ site.binaries_url }}/binaries/389-adminutil-1.1.22.tar.bz2).

### Highlights in 389-admin-1.1.42 and 389-adminutil-1.1.22

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

-   <https://admin.fedoraproject.org/updates/389-admin-1.1.42-1.el7>
-   <https://admin.fedoraproject.org/updates/389-admin-1.1.42-1.fc21>
-   <https://admin.fedoraproject.org/updates/389-admin-1.1.42-1.fc22>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.22-1.el7>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.22-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.22-1.fc21>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-admin-1.1.38

-   Ticket 47548 - register-ds-admin - silent file incorrectly processed 
-   Ticket 47493 - Configuration Tab does not work with FIPS mode enabled 
-   Ticket 48186 - register-ds-admin.pl script prints clear text password in the terminal 
-   Ticket 47548 - register-ds-admin.pl fails to set local bind DN and password 
-   Ticket 47467 - Improve Add CRL/CKL dialog and errors 
-   Ticket 48171 - remove-ds-admin.pl removes files in the rpm 
-   Ticket 48153 - [adminserver] support NSS 3.18 

### Detailed Changelog since 389-adminutil-1.1.21

-   Ticket 48152 - support NSS 3.18

