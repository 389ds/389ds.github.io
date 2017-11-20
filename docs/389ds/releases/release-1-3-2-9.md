---
title: "Releases/1.3.2.9"
---
389 Directory Server 1.3.2.9
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.9.

Fedora packages are available from the Fedora 20 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.9-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.2.9.tar.bz2)

### Highlights in 1.3.2.9

-   Bug fixes: objectclass definition in schema, invalid SASL mechanism, and setting nsds5ReplicaProtocolTimeout.
-   Enhancements: plug-in library path validation, replication logging, changelog trimming interval, and referential integrity.
-   A couple of memory leak bugs and a crash bug were fixed.

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

### Detailed Changelog since 1.3.2.8

-   Ticket 47313 - Indexed search with filter containing '&' and "!" with attribute subtypes gives wrong result
-   Ticket 47601 - Plugin library path validation prevents intentional loading of out-of-tree modules
-   Ticket 47606 - replica init/bulk import errors should be more verbose
-   Ticket 47613 - Issues setting allowed mechanisms
-   Ticket 47617 - allow configuring changelog trim interval
-   Ticket 47620 - 389-ds rejects nsds5ReplicaProtocolTimeout attribute
-   Ticket 47620 - Fix cherry-pick error for 1.3.2 and 1.3.1
-   Ticket 47620 - Config value validation improvement
-   Ticket 47620 - Fix logically dead code.
-   Ticket 47620 - Fix dereferenced NULL pointer in agmtlist\_modify\_callback()
-   Ticket 47620 - Fix missing left bracket
-   Ticket 47621 - v2 make referential integrity configuration more flexible
-   Ticket 47622 - Automember betxnpreoperation - transaction not aborted when group entry does not exist
-   Ticket 47623 - fix memleak caused by 47347
-   Ticket 47623 - fix memleak caused by 47347
-   Ticket 47627 - changelog iteration should ignore cleaned rids when getting the minCSN
-   Ticket 47627 - Fix replication logging
-   Ticket 47631 - objectclass may, must lists skip rest of objectclass once first is found in sup

