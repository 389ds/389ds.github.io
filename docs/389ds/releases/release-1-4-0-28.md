---
title: "Releases/1.4.0.28"
---

389 Directory Server 1.4.0.28
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.28

Fedora packages are available on Fedora 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=37708286>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-23ddca9ca8>


The new packages and versions are:

- 389-ds-base-1.4.0.28-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.28.tar.bz2)

### Highlights in 1.4.0.28

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is fully functional!  There are still parts that need to be converted to ReactJS, but everything works.

|Configuration Tab| Functional | Written in ReachJS |
|-----------------|------------|--------------------|
|Server Tab       |Yes         |No                  |
|Security Tab     |Yes         |Yes                 |
|Database Tab     |Yes         |Yes                 |
|Replication Tab  |Yes         |No                  |
|Schema Tab       |Yes         |No                  |
|Plugin Tab       |Yes         |Yes                 |
|Monitor Tab      |Yes         |Yes                 |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.28
- Issue 50581 - ns-slapd crashes during ldapi search
- Issue 50499 - Audit fix - Update npm 'eslint-utils' version
- Issue 49624 - modrdn silently fails if DB deadlock occurs
- Issue 50542 - Fix crash in filter tests
- Issue 49232 - Truncate the message when buffer capacity is exceeded
- Issue 50542 - Entry cache contention during base search
- Issue 50538 - cleanAllRUV task limit is not enforced for replicated tasks
- Issue 50536 - Audit log heading written to log after every update
- Issue 50525 - nsslapd-defaultnamingcontext does not change when the assigned suffix gets deleted
- Issue 50534 - CLI change schema edit subcommand to replace
- Issue 50534 - backport UI schema editing fix


