---
title: "Releases/1.4.3.12"
---

389 Directory Server 1.4.3.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.12

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=48296695> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-e2cb297f95> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.12-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.12.tar.bz2)

### Highlights in 1.4.3.12

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

### New UI Progress (Cockpit plugin)

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.3.12
- Issue 51222 - It should not be allowed to delete Managed Entry manually
- Issue 51129 - SSL alert: The value of sslVersionMax "TLS1.3" is higher than the supported version
- Issue 51086 - Fix instance name length for interactive install
- Issue 51136 - JSON Error output has redundant messages
- Issue 51059 - If dbhome directory is set online backup fails
- Issue 51000 - Separate the BDB backend monitors
- Issue 49300 - entryUSN is duplicated after memberOf operation
- Issue 50984 - Fix disk_mon_check_diskspace types


