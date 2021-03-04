---
title: "Releases/1.4.3.19"
---

389 Directory Server 1.4.3.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.19

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=61767145> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-e55a8d7545> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.19-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.19.tar.gz)

### Highlights in 1.4.3.19

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

### New UI Progress (Cockpit plugin)

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- bump version to 1.4.3.19
- Issue 4609 - CVE - info disclosure when authenticating
- Issue 4581 - A failed re-indexing leaves the database in broken state (#4582)
- Issue 4579 - libasan detects heap-use-after-free in URP test (#4584)
- Issue 4563 - Failure on s390x: 'Fails to split RDN "o=pki-tomcat-CA" into components' (#4573)
- Issue 4526 - sync_repl: when completing an operation in the pending list, it can select the wrong operation (#4553)
- Issue 4324 - Performance search rate: change entry cache monitor to recursive pthread mutex (#4569)
- Issue 5442 - Search results are different between RHDS10 and RHDS11
- Issue 4548 - CLI - dsconf needs better root DN access control plugin validation
- Issue 4513 - Fix schema test and lib389 task module (#4514)
- Issue 4534 - libasan read buffer overflow in filtercmp (#4541)

