---
title: "Releases/1.4.3.23"
---

389 Directory Server 1.4.3.23
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.23

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=67913862> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-1353c15043> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.23-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.23.tar.gz)

### Highlights in 1.4.3.23

- Bug and Security fixes

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

- Bump version to 1.4.3.23
- Issue 4725 - RFE - Update the password policy to support Temporary Password Rules (#4727)
- Issue 4759 - Fix coverity issue (#4760)
- Issue 4656 - Fix cherry pick error around replication enabling
- Issue 4701 - RFE - Exclude attributes from retro changelog (#4723) (#4746)
- Issue 4742 - UI - should always use LDAPI path when calling CLI
- Issue 4667 - incorrect accounting of readers in vattr rwlock (#4732)
- Issue 4711 - Security Fix - SIGSEV with sync_repl
- Issue 4649 - fix testcase importing ContentSyncPlugin
- Issue 2736 - Warnings from automatic shebang munging macro
- Issue 4706 - negative wtime in access log for CMP operation

