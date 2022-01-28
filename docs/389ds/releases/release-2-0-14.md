---
title: "Releases/2.0.14"
---

389 Directory Server 2.0.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.14

Fedora packages are available on Fedora 34, and 35

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=82032930> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-5aee32fbab> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=82034969> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-081d784a9c> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.14.tar.gz)

### Highlights in 2.0.14

- Bug and Security fixes


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

- Bump version to 2.0.14
- Issue 5127 - ds_selinux_restorecon.sh: always exit 0
- Issue 5037 - in OpenQA changelog trimming can crashes (#5070)
- Issue 4992 - BUG - slapd.socket container fix (#4993)
- Issue 5079 - BUG - multiple ways to specific primary (#5087)
- Issue 5080 - BUG - multiple index types not handled in openldap migration (#5094)
- Issue 5135 - UI - Disk monitoring threshold does update properly
- Issue 5129 - BUG - Incorrect fn signature in add_index (#5130)

