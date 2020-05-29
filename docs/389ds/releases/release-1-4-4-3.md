---
title: "Releases/1.4.4.3"
---

389 Directory Server 1.4.4.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.3

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=45152302>

The new packages and versions are:

- 389-ds-base-1.4.4.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.3.tar.bz2)

### Highlights in 1.4.4.3

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

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.4.3
- Issue 50931 - RFE AD filter rewriter for ObjectCategory
- Issue 50860 - Port Password Policy test cases from TET to python3 part1
- Issue 51113 - Allow using uid for replication manager entry
- Issue 51095 - abort operation if CSN can not be generated
- Issue 51110 - Fix ASAN ODR warnings
- Issue 49850 - ldbm_get_nonleaf_ids() painfully slow for databases with many non-leaf entries
- Issue 51102 - RFE - ds-replcheck - make online timeout configurable
- Issue 51076 - remove unnecessary slapi entry dups
- Issue 51086 - Improve dscreate instance name validation
- Issue:51070 - Port Import TET module to python3 part1
- Issue 51037 - compiler warning
- Issue 50989 - ignore pid when it is ourself in protect_db
- Issue 51037 - RFE AD filter rewriter for ObjectSID
- Issue 50499 - Fix some npm audit issues
- Issue 51091 - healthcheck json report fails when mapping tree is deleted
- Issue 51079 - container pid start and stop issues
- Issue 49761 - Fix CI tests
- Issue 50610 - Fix return code when it's nothing to free
- Issue 50610 - memory leaks in dbscan and changelog encryption
- Issue 51076 - prevent unnecessarily duplication of the target entry
- Issue 50940 - Permissions of some shipped directories may change over time
- Issue 50873 - Fix issues with healthcheck tool
- Issue 51082 - abort when a empty valueset is freed
- Issue 50201 - nsIndexIDListScanLimit accepts any value


