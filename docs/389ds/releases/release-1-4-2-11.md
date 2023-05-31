---
title: "Releases/1.4.2.11"
---

389 Directory Server 1.4.2.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.11

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42951806> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-bdf0f2d0d7>

The new packages and versions are:

- 389-ds-base-1.4.2.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.11.tar.bz2)

### Highlights in 1.4.2.11

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

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.11
- Issue 50994 - Fix latest UI bugs found by QE
- Issue 50337 - Replace exec() with setattr()
- Issue 50984 - Memory leaks in disk monitoring
- Issue 50975 - Revise UI branding with new minimized build
- Issue 49437 - Fix memory leak with indirect COS
- Issue 50976 - Clean up Web UI source directory from unused files
- Issue 50744 - -n option of dbverify does not work
- Issue 50952 - SSCA lacks basicConstraint:CA


