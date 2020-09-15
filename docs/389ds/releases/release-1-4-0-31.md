---
title: "Releases/1.4.0.31"
---

389 Directory Server 1.4.0.31
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.31

Fedora packages are available on Fedora 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38980725>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-95d4df2047>


The new packages and versions are:

- 389-ds-base-1.4.0.31-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.31.tar.bz2)

### Highlights in 1.4.0.31

Security and bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is fully functional!  There are still parts that need to be converted to ReactJS, but everything works.

|Configuration Tab| Functional | Written in ReactJS |
|-----------------|------------|--------------------|
|Server Tab       |Yes         |No                  |
|Security Tab     |Yes         |Yes                 |
|Database Tab     |Yes         |Yes                 |
|Replication Tab  |Yes         |Yes                 |
|Schema Tab       |Yes         |No                  |
|Plugin Tab       |Yes         |Yes                 |
|Monitor Tab      |Yes         |Yes                 |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.31
- Issue 50499 - Fix npm audit issues
- Issue 50699 - Add Disk Monitor to CLI and UI
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50696 - Fix various UI bugs
- Issue 50689 - Failed db restore task does not report an error

