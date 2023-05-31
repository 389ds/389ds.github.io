---
title: "Releases/2.0.13"
---

389 Directory Server 2.0.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.13

Fedora packages are available on Fedora 34, 35, and Rawhide

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=81773299> - Koji

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=81773041> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-7f62add497> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=81773433> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-90be8dbcb6> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.13.tar.gz)

### Highlights in 2.0.13

- Bug and Security fixes
- Cockpit UI - ACI editor finished

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

- Bump version to 2.0.13
- Issue 5132 - Update Rust crate lru to fix - CVE-2021-45720
- Issue 3555 - UI - fix audit issue with npm nanoid
- Issue 4299 - UI - Add ACI editing features
- Issue 4299 - UI - LDAP editor - add "edit" and "rename" functionality
- Issue 5127 - run restorecon on /dev/shm at server startup
- Issue 5124 - dscontainer fails to create an instance
- Issue 4312 - fix compiler warnings
- Issue 5115 - AttributeError: type object 'build_manpages' has no attribute 'build_manpages'
- Issue 4312 - performance search rate: contention on global monitoring counters (#4940)
- Issue 5105 - During a bind, if the target entry is not reachable the operation may complete without sending result (#5107)
- Issue 5095 - sync-repl with openldap may send truncated syncUUID (#5099)
- Issue 3584 - Add is_fips check to password tests (#5100)
- Issue 5074 - retro changelog cli updates (#5075)
- Issue 4994 - Revert retrocl dependency workaround (#4995)


