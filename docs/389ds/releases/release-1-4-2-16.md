---
title: "Releases/1.4.2.16"
---

389 Directory Server 1.4.2.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.16

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46843300>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-7546332207>

The new packages and versions are:

- 389-ds-base-1.4.2.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.16.tar.bz2)

### Highlights in 1.4.2.16

- Bug fixes, and UI completion

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.16
- Issue 51159 - dsidm ou delete fails
- Issue 51165 - add more logconv stats for the new access log keywords
- Issue 51165 - add new access log keywords for wtime and optime
- Issue 50696 - Fix Allowed and Denied Ciphers lists - WebUI
- Issue 51169 - UI - attr uniqueness - selecting empty subtree crashes cockpit
- Issue 49256 - log warning when thread number is very different from autotuned value
- Issue 51157 - Reindex task may create abandoned index file
- Issue 51166 - Log an error when a search is fully unindexed
- Issue 51161 - fix SLE15.2 install issps
- Issue 51144 - dsctl fails with instance names that contain slapd-
- Issue 50984 - Memory leaks in disk monitoring
