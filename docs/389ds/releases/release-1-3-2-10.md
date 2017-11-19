---
title: "Releases/1.3.2.10"
---
389 Directory Server 1.3.2.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.10.

Fedora packages are available from the Fedora 20 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.10-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.2.10.tar.bz2)

### Highlights in 1.3.2.10

-   Enhancement: Need a way to allow users to create entries assigned to themselves
-   Bug fixes including an invalid schema.

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

### Detailed Changelog since 1.3.2.9

-   Ticket 447 - Possible to add invalid attribute to nsslapd-allowed-to-delete-attrs
-   Ticket 47634 - support AttributeTypeDescription USAGE userApplications distributedOperation dSAOperation
-   Ticket 47645 - reset stack, op fields to NULL - clean up stacks at shutdown - free unused plugin config entries
-   Ticket 47647 - remove bogus definition in 60rfc3712.ldif
-   Ticket 47653 - Need a way to allow users to create entries assigned to themselves

