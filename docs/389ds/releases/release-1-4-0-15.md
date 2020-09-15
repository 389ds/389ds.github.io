---
title: "Releases/1.4.0.15"
---

389 Directory Server 1.4.0.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.15

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=29119556>

Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=29120673>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=29121909>


The new packages and versions are:

- 389-ds-base-1.4.0.15-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.15.tar.bz2)

### Highlights in 1.4.0.15

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.15
- Ticket 49029 - Internal logging thread data needs to allocate int pointers
- Ticket 48061 - CI test - config
- Ticket 48377 - Only ship libjemalloc.so.2
- Ticket 49885 - On some platform fips does not exist


