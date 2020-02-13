---
title: "Releases/1.4.3.3"
---

389 Directory Server 1.4.3.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.3

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=41484528> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-2131928cb1> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.3.tar.bz2)

### Highlights in 1.4.3.3

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

|Configuration Tab  |Functional  |Written in ReactJS |
|-------------------|------------|-------------------|
|Server Tab         |Yes         |Yes                |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |Yes                |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |
|Navigation Tab     |Yes         |No                 |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.3.3
- Issue 50855 - remove unused file from UI
- Issue 50855 - UI: Port Server Tab to React
- Issue 49845 - README does not contain complete information on building
- Issue 50686 - Port fractional replication test cases from TET to python3 part 1
- Issue 49623 - cont cenotaph errors on modrdn operations
- Issue 50882 - Fix healthcheck errors for instances that do not have TLS enabled
- Issue 50886 - Typo in the replication debug message
- Issue 50873 - Fix healthcheck and virtual attr check
- Issue 50873 - Fix issues with healthcheck tool
- Issue 50028 - Add a new CI test case
- Issue 49946 - Add a new CI test case
- Issue 50117 - Add a new CI test case
- Issue 50787 - fix implementation of attr unique
- Issue 50859 - support running only with ldaps socket
- Issue 50823 - dsctl doesn't work with 'slapd-' in the instance name
- Issue 49624 - cont - DB Deadlock on modrdn appears to corrupt database and entry cache
- Issue 50867 - Fix minor buildsys issues
- Issue 50737 - Allow building with rust online without vendoring
- Issue 50831 - add cargo.lock to allow offline builds
- Issue 50694 - import PEM certs on startup
- Issue 50857 - Memory leak in ACI using IP subject
- Issue 49761 - Fix CI test suite issues
- Issue 50853 - Fix NULL pointer deref in config setting
- Issue 50850 - Fix dsctl healthcheck for python36
- Issue 49990 - Need to enforce a hard maximum limit for file descriptors
- Issue 48707 - ldapssotoken for authentication

