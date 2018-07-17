---
title: "Releases/1.3.8.5"
---

389 Directory Server 1.3.8.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.5

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28375593>

<https://bodhi>


The new packages and versions are:

-   389-ds-base-1.3.8.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.5.tar.bz2)

### Highlights in 1.3.8.5

- Bug fixes and Security fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.8.5
- Ticket 49789 - By default, do not manage unhashed password (Security Fix)
- Ticket 49546 - Fix issues with MIB file
- Ticket 49840 - ds-replcheck command returns traceback errors against ldif files having garbage content when run in offline mode
- Ticket 48818 - For a replica bindDNGroup, should be fetched the first time it is used not when the replica is started
- Ticket 49780 - acl_copyEval_context double free
- Ticket 49830 - Import fails if backend name is "default"
- Ticket 49432 - filter optimise crash
- Ticket 49372 - filter optimisation improvements for common queries
- Update Source0 URL in rpm/389-ds-base.spec.in

