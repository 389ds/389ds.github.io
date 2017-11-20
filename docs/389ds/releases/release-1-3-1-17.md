---
title: "Releases/1.3.1.17"
---
389 Directory Server 1.3.1.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.17.

Fedora packages are available from the Fedora 19 Testing repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.17-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.17.tar.bz2)

### Highlights in 1.3.1.17

-   Hard coded limit of 64 masters has been eliminated.
-   Attribute encryption has been improved.
-   Replication and SASL configuration has been improved.
-   Error logging has been improved.
-   fixed memory leaks.

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

### Detailed Changelog since 1.3.1.16

-   Ticket 342 - better error message when cache overflows (phase 2)
-   Ticket 447 - Possible to add invalid attribute to nsslapd-allowed-to-delete-attrs
-   Ticket 571 (dup 47361) - Empty control list causes LDAP protocol error is thrown
-   Ticket 47587 - hard coded limit of 64 masters in agreement and changelog code
-   Ticket 47591 - entries with empty objectclass attribute value can be hidden
-   Ticket 47592 - automember plugin task memory leaks
-   Ticket 47596 - attrcrypt fails to find unlocked key
-   Ticket 47599 - fix memory leak
-   Ticket 47606 - replica init/bulk import errors should be more verbose
-   Ticket 47611 - Add script to build patched RPMs
-   Ticket 47611 - Add make rpms build target
-   Ticket 47613 - Issues setting allowed mechanisms
-   Ticket 47613 - Impossible to configure nsslapd-allowed-sasl-mechanisms
-   Ticket 47614 - Possible to specify invalid SASL mechanism in nsslapd-allowed-sasl-mechanisms
-   Ticket 47620 - Fix missing left bracket
-   Ticket 47620 - Fix dereferenced NULL pointer in agmtlist\_modify\_callback()
-   Ticket 47620 - Fix logically dead code.
-   Ticket 47620 - Config value validation improvement
-   Ticket 47620 - Fix cherry-pick error for 1.3.2 and 1.3.1
-   Ticket 47620 - 389-ds rejects nsds5ReplicaProtocolTimeout attribute
-   Ticket 47622 - Automember betxnpreoperation - transaction not aborted when group entry does not exist
-   Ticket 47623 - fix memleak caused by 47347
-   Ticket 47627 - Fix replication logging
-   Ticket 47627 - changelog iteration should ignore cleaned rids when getting the minCSN

