---
title: "Releases/1.3.2.13"
---
389 Directory Server 1.3.2.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.13.

Fedora packages are available from the Fedora 20 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.13-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.13.tar.bz2)

### Highlights in 1.3.2.13

-   Bugs including unresolved symbol in the ACL library and Windows Sync group issues were fixed.

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

### Detailed Changelog since 1.3.2.11

-   Ticket 408 - create a normalized dn cache
-   Ticket 525 - Replication retry time attributes cannot be added
-   Ticket 571 - Empty control list causes LDAP protocol error is thrown (dup 47361)
-   Ticket 47615 - Failed to compile the DS 389 1.3.2.3 version against Berkeley DB 4.2 version
-   Ticket 47642 - Windows Sync group issues
-   Ticket 47677 - Size returned by slapi\_entry\_size is not accurate
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 47699 - Propagate plugin precedence to all registered function types
-   Ticket 47700 - Unresolved external symbol references break loading of the ACL plugin
-   Ticket 47709 - package issue in 389-ds-base

