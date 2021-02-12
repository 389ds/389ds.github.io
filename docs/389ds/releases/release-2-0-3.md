---
title: "Releases/2.0.3"
---

389 Directory Server 2.0.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.3

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=61843474>

Bodhi:

None

The new packages and versions are:

- 389-ds-base-2.0.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.3.tar.gz)

### Highlights in 2.0.3

- Bug & security fixes

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

- Bump version to 2.0.3
- Issue 4619 - remove pytest requirement from lib389
- Issue 4615 - log message when psearch first exceeds max threads per conn
- Issue 4469 - Backend redesing phase 3a - implement dbimpl API and use it in back-ldbm (#4618)
- Issue 4324 - Some architectures the cache line size file does not exist
- Issue 4593 - RFE - Print help when nsSSLPersonalitySSL is not found (#4614)
- Issue 4469 - Backend redesign phase 3a - bdb dependency removal from back-ldbm
- PR 4564 - Update dscontainer
- Issue 4149 - UI - port TreeView and opther components to PF4
- Issue 4577 - Add GitHub actions
- Issue 4591 - RFE - improve openldap_to_ds help and features (#4607)
- issue 4612 - Fix pytest fourwaymmr_test for non root user (#4613)
- Issue 4609 - CVE - info disclosure when authenticating
- Issue 4348 - Add tests for dsidm
- Issue 4571 - Stale libdb-utils dependency
- Issue 4600 - performance modify rate: reduce lock contention on the object extension factory (#4601)
- Issue 4577 - Add GitHub actions
- Issue 4588 - BUG - unable to compile without xcrypt (#4589)
- Issue 4579 - libasan detects heap-use-after-free in URP test (#4584)
- Issue 4581 - A failed re-indexing leaves the database in broken state (#4582)
- Issue 4348 - Add tests for dsidm
- Issue 4577 - Add GitHub actions
- Issue 4563 - Failure on s390x: 'Fails to split RDN "o=pki-tomcat-CA" into components' (#4573)
- Issue 4093 - fix compiler warnings and update doxygen
- Issue 4575 - Update test docstrings metadata
- Issue 4526 - sync_repl: when completing an operation in the pending list, it can select the wrong operation (#4553)
- Issue 4324 - Performance search rate: change entry cache monitor to recursive pthread mutex (#4569)
- Issue 4513 - Add DS version check to SSL version test (#4570)
- Issue 5442 - Search results are different between RHDS10 and RHDS11
- Issue 4396 - Minor memory leak in backend (#4558)
- Issue 4513 - Fix replication CI test failures (#4557)
- Issue 4513 - Fix replication CI test failures (#4557)
- Issue 4153 - Added a CI test (#4556)
- Issue 4506 - BUG - fix oob alloc for fds (#4555)
- Issue 4548 - CLI - dsconf needs better root DN access control plugin validation
- Issue 4506 - Temporary fix for io issues (#4516)
- Issue 4535 - lib389 - Fix log function in backends.py
- Issue 4534 - libasan read buffer overflow in filtercmp (#4541)
- Issue 4544 - Compiler warnings on krb5 functions (#4545)
- Update rpm.mk for RUST tarballs


