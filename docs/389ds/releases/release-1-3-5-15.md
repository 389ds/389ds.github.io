---
title: "Releases/1.3.5.15"
---
389 Directory Server 1.3.5.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.15.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.15-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.14.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.15

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

-   bz1358565 - Clear and unsalted password types are vulnerable to timing attack (SECURITY FIX)
-   Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
-   Ticket 48328 - Add missing dependency
-   Ticket 49009 - args debug logging must be more restrictive
-   Ticket 49014 - ns-accountstatus.pl shows wrong status for accounts inactivated by Account policy plugin
-   Ticket 47703 - remove search limit for aci group evaluation
-   Ticket 48909 - Replication stops working in FIPS mode
