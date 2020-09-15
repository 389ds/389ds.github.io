---
title: "Releases/1.4.1.9"
---

389 Directory Server 1.4.1.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.9

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38715880> - Fedora 31

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38715551> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-2efc25f4ff> - Fedora 31

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-87a9b13ffb> - Fedora 30

The new packages and versions are:

- 389-ds-base-1.4.1.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.9.tar.bz2)

### Highlights in 1.4.1.9

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

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.1.9
- Issue 50592 - Port Replication Tab to ReactJS
- Issue 49850 - cont -fix crash in ldbm_non_leaf
- Issue 50634 - Clean up CLI errors output - Fix wrong exception
- Issue 50634 - Clean up CLI errors output
- Issue 49850 - ldbm_get_nonleaf_ids() slow for databases with many non-leaf entries
- Issue 50655 - access log etime is not properly formatted
- Issue 50653 - objectclass parsing fails to log error message text
- Issue 50646 - Improve task handling during shutdowns
- Issue 50622 - ds_selinux_enabled may crash on suse
- Issue 50499 - Fix npm audit issues

