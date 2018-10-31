---
title: "Releases/1.3.9.0"
---

389 Directory Server 1.3.9.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.9.0

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30581994>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-8adbba96b5>


The new packages and versions are:

-   389-ds-base-1.3.9.0-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.9.0.tar.bz2)

### Highlights in 1.3.9.0

- Bug and security fixes

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

- Branching 1.3.8 to 1.3.9
- Ticket 49967 - entry cache corruption after failed MODRDN
- Ticket 49968 - Confusing CRITICAL message: list_candidates - NULL idl was recieved from filter_candidates_ext
- Ticket 49915 - fix compiler warnings (2nd)
- Ticket 49915 - fix compiler warnings
- Ticket 49915 - Master ns-slapd had 100% CPU usage after starting replication and replication cannot finish



