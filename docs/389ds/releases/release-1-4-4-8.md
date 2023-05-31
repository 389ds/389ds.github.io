---
title: "Releases/1.4.4.8"
---

389 Directory Server 1.4.4.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.8

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=55146435> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-54dfdbe3f6> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.8.tar.gz)

### Highlights in 1.4.4.8

- Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.4.8
- Issue 4415 - unable to query schema if there are extra parenthesis
- Issue 4176 - replication change log trimming causes high CPU

