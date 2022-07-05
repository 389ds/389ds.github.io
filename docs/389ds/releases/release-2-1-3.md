---
title: "Releases/2.1.3"
---

389 Directory Server 2.1.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.1.3

Fedora packages are available on Fedora 36

<https://koji.fedoraproject.org/koji/taskinfo?taskID=89124762>

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-e9b27d8c48> - Bodhi


The new packages and versions are:

- 389-ds-base-2.1.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.3.tar.gz)

### Highlights in 2.1.3

- Bug fixes
- Transition from BDB(libdb) to LMDB begun.  BDB is still the default backend, but it can be changed to LMDB for early testing.

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

- Bump version to 2.1.3
- Issue 5221 - fix covscan (#5359)
- Issue 5353 - CLI - dsconf backend export breaks with multiple backends
- Issue 5345 - BUG - openldap migration fails when ppolicy is active (#5347)
- Issue 5323 - BUG - improve skipping of monitor db (#5340)
- Issue 5323 - BUG - Fix issue in mdb tests with monitor (#5326)
- Issue 5329 - Improve replication extended op logging
- Issue 5343 - Various improvements to winsync
- Issue 4932 - CLI - add parser aliases to long arg names
- Issue 5332 - BUG - normalise filter as intended
- Issue 5126 - Memory leak in slapi_ldap_get_lderrno (#5153)
- Issue 5311 - Missing Requires for acl in the spec file
- Issue 5333 - 389-ds-base fails to build with Python 3.11

