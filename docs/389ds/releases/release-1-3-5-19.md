---
title: "Releases/1.3.5.19"
---

389 Directory Server 1.3.5.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.19.

Fedora packages are available from the Fedora 25.

The new packages and versions are:

-   389-ds-base-1.3.5.19-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.19.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.19

-   Bugand security fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl -u** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as: 

F25 <https://bodhi.fedoraproject.org/updates/FEDORA-2017-4333359de8>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump verison to 1.3.5.19
- Ticket 49336 - SECURITY 1.3.5.x: Locked account provides different return code
- Ticket 49330 - Improve ndn cache performance 1.3.5
