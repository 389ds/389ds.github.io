---
title: "Releases/1.4.2.14"
---

389 Directory Server 1.4.2.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.14

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=45153610>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-0a057b856f>

The new packages and versions are:

- 389-ds-base-1.4.2.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.14.tar.bz2)

### Highlights in 1.4.2.14

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

- Bump version to 1.4.2.14
- Issue 51113 - Allow using uid for replication manager entry
- Issue 51095 - abort operation if CSN can not be generated
- Issue 51110 - Fix ASAN ODR warnings
- Issue 51102 - RFE - ds-replcheck - make online timeout configurable
- Issue 51076 - remove unnecessary slapi entry dups
- Issue 51086 - Improve dscreate instance name validation
- Issue 50989 - ignore pid when it is ourself in protect_db
- Issue 50499 - Fix some npm audit issues
- Issue 51091 - healthcheck json report fails when mapping tree is deleted
- Issue 51079 - container pid start and stop issues
- Issue 50610 - Fix return code when it's nothing to free
- Issue 51082 - abort when a empty valueset is freed
- Issue 50610 - memory leaks in dbscan and changelog encryption
- Issue 51076 - prevent unnecessarily duplication of the target entry
- Issue 50940 - Permissions of some shipped directories may change over time

