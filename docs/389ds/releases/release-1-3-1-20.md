---
title: "Releases/1.3.1.20"
---
389 Directory Server 1.3.1.20
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.20.

Fedora packages are available from the Fedora 19 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.20-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.20.tar.bz2)

### Highlights in 1.3.1.20

-   Important security bugs were fixed with replication conflict issues.

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

### Detailed Changelog since 1.3.1.19

-   Ticket 47637 - rsa\_null\_sha should not be enabled by default
-   Ticket 47729 - Directory Server crashes if shutdown during a replication initialization
-   Ticket 47735 - e\_uniqueid fails to set if an entry is a conflict entry
-   Ticket 47737 - Under heavy stress, failure of turning a tombstone into glue makes the server hung
-   Ticket 47739 - directory server is insecurely misinterpreting authzid on a SASL/GSSAPI bind

