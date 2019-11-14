---
title: "Releases/1.4.1.10"
---

389 Directory Server 1.4.1.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.10

Fedora packages are available on Fedora 30.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38978324> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-1bc68862f0> - Fedora 30

The new packages and versions are:

- 389-ds-base-1.4.1.10-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.10.tar.bz2)

### Highlights in 1.4.1.10

- Security fix and Bug fixes

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

|Configuration Tab|Functional|Written in ReactJS |
|-----------------|----------|-------------------|
|Server Tab       |Yes       |No                 |
|Security Tab     |Yes       |Yes                |
|Database Tab     |Yes       |Yes                |
|Replication Tab  |Yes       |Yes                |
|Schema Tab       |Yes       |No                 |
|Plugin Tab       |Yes       |Yes                |
|Monitor Tab      |Yes       |Yes                |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.1.10
- Issue 50712 - Version comparison doesn't work correctly on git builds
- Issue 50706 - Missing lib389 dependency - packaging
- Issue 50499 - Fix npm audit issues
- Issue 50699 - Add Disk Monitor to CLI and UI
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50696 - Fix various UI bugs
- Issue 50689 - Failed db restore task does not report an error

