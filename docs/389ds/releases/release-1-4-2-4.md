---
title: "Releases/1.4.2.4"
---

389 Directory Server 1.4.2.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.4

Fedora packages are available on Fedora 31 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38997267> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38999035> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-bd427e30b5>

The new packages and versions are:

- 389-ds-base-1.4.2.4-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.4.tar.bz2)

### Highlights in 1.4.2.4

- Security and Bug fixes

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

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but every feature is available.

|Configuration Tab  |Functional  |Written in ReactJS |
|-------------------|------------|-------------------|
|Server Tab         |Yes         |No                 |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |No                 |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.2.4
- Issue 50634 - Fix CLI error parsing for non-string values
- Issue 50659 - AddressSanitizer: SEGV ... in bdb_pre_close
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50644 - fix regression with creating sample entries
- Issue 50699 - Add Disk Monitor to CLI and UI
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50536 - After audit log file is rotated, DS version string is logged after each update
- Issue 50712 - Version comparison doesn't work correctly on git builds
- Issue 50706 - Missing lib389 dependency - packaging
- Issue 49761 - Fix CI test suite issues
- Issue 50683 - Makefile.am contains unused RPM-related targets
- Issue 50696 - Fix various UI bugs
- Issue 50641 - Update default aci to allows users to change their own password
- Issue 50007, 50648 - improve x509 handling in dsctl
- Issue 50689 - Failed db restore task does not report an error
- Issue 50199 - Disable perl by default
- Issue 50633 - Add cargo vendor support for offline builds
- Issue 50499 - Fix npm audit issues



