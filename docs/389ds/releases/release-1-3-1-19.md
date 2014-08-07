---
title: "Releases/1.3.1.19"
---
389 Directory Server 1.3.1.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.19.

Fedora packages are available from the Fedora 19 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.19-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.19.tar.bz2)

### Highlights in 1.3.1.19

-   Bugs including unresolved symbol in the ACL library and Windows Sync group issues were fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1.18

-   Ticket 408 - create a normalized dn cache
-   Ticket 415 - winsync doesn't sync DN valued attributes if DS DN value doesn't exist
-   Ticket 525 - Replication retry time attributes cannot be added
-   Ticket 571 - Empty control list causes LDAP protocol error is thrown (dup 47361)
-   Ticket 47642 - Windows Sync group issues
-   Ticket 47677 - Size returned by slapi\_entry\_size is not accurate
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 47704 - invalid sizelimits in aci group evaluation
-   Ticket 47709 - package issue in 389-ds-base

