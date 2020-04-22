---
title: "Releases/1.4.3.7"
---

389 Directory Server 1.4.3.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.7

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=43653374> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-cb6e7e5799> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.7-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.7.tar.bz2)

### Highlights in 1.4.3.7

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

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.3.7
- Issue 51024 - syncrepl_entry callback does not contain attributes added by postoperation plugins
- Issue 51035 - Heavy StartTLS connection load can randomly fail with err=1
- Issue 49731 - undo db_home_dir under /dev/shm/dirsrv for now
- Issue 51031 - UI - transition between two instances needs improvement


