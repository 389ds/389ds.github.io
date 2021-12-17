---
title: "Releases/2.0.12"
---

389 Directory Server 2.0.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.12

Fedora packages are available on Fedora 34 and Rawhide

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=80099149> - Koji

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=80099152> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-8589d08c94> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=80099303> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-71738c2354> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.12-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.12.tar.gz)

### Highlights in 2.0.12

- Bug fixes
- Cockpit UI - LDAP editor (database editor) has been started, finished "edit" and "rename".  ACI, COS, and Roles remaining to be finished.

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

- Bump version to 2.0.12
- Issue 4299 - UI LDAP editor - add "edit" and "rename" functionality
- Issue 4962 - Fix various UI bugs - Database and Backups (#5044)
- Issue 5046 - BUG - update concread (#5047)
- Issue 5043 - BUG - Result must be used compiler warning (#5045)
- Issue 4165 - Don't apply RootDN access control restrictions to UNIX connections
- Issue 4931 - RFE: dsidm - add creation of service accounts
- Issue 5024 - BUG - windows ro replica sigsegv (#5027)
- Issue 5020 - BUG - improve clarity of posix win sync logging (#5021)
- Issue 5008 - If a non critical plugin can not be loaded/initialized, bootstrap should succeeds (#5009)


