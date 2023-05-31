---
title: "Releases/2.0.9"
---

389 Directory Server 2.0.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.9

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=74820225> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-ed495101a1> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.9.tar.gz)

### Highlights in 2.0.9

- Bug & Security fixes
- Cockpit UI fully migrated to Patternfly 4

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

- Bump version to 2.0.9
- Issue 4887 - UI - Update webpack.config.js and package.json (security fixes)
- Issue 4149 - UI - Migrate the remaining components to PF4
- Issue 4875 - CLI - Add some verbosity to installer
- Issue 4884 - server crashes when dnaInterval attribute is set to zero

