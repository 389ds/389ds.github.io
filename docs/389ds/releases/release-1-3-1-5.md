---
title: "Releases/1.3.1.5"
---
389 Directory Server 1.3.1.5
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.5.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.5-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.5-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.5.tar.bz2)

### Highlights in 1.3.1.5

In this version, a security bug in ACL, a crash bug in replication, a deadlock issue as well as several important bugs were fixed. Functionalities such as Disk Monitoring and logconv were improved. Also, memory management issues reported by valgrind and compiler warnings were fixed.

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

### Detailed Changelog since 1.3.1.4

-   Ticket 47378 - fix recent compiler warnings
-   Ticket 47405 - CVE-2013-2219 ACLs inoperative in some search scenarios
-   Ticket 47427 - Overflow in nsslapd-disk-monitoring-threshold
-   Ticket 47440 - Fix compilation warnings and header files
-   Ticket 47441 - Disk Monitoring not checking filesystem with logs
-   Ticket 47447 - logconv.pl man page missing -m,-M,-B,-D
-   Ticket 47448 - Segfault in 389-ds-base-1.3.1.4-1.fc19 when setting up FreeIPA replication
-   Ticket 47449 - deadlock after adding and deleting entries
-   Ticket 47455 - valgrind - value mem leaks, uninit mem usage
-   Ticket 47456 - delete present values should append values to deleted values

