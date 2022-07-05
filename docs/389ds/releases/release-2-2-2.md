---
title: "Releases/2.2.2"
---

389 Directory Server 2.2.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.2

Fedora packages are available on Rawhide (f37)

Rawhide:

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1996683>


The new packages and versions are:

- 389-ds-base-2.2.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.2.tar.gz)

### Highlights in 2.2.2

- Enhancement, and Bug fixes

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

- Bump version to 2.2.2
- Issue 5221 - fix covscan (#5359)
- Issue 5294 - Report Portal 5 is not processing an XML file with (#5358)
- Issue 5353 - CLI - dsconf backend export breaks with multiple backends
- Issue 5346 - New connection table fails with ASAN failures (#5350)
- Issue 5345 - BUG - openldap migration fails when ppolicy is active (#5347)
- Issue 5323 - BUG - improve skipping of monitor db (#5340)
- Issue 5329 - Improve replication extended op logging
- Issue 5343 - Various improvements to winsync
- Issue 4932 - CLI - add parser aliases to long arg names
- Issue 5332 - BUG - normalise filter as intended
- Issue 5327 - Validate test metadata
- Issue 4812 - Scalability with high number of connections (#5090)
- Issue 4348 - Add tests for dsidm
- Issue 5333 - 389-ds-base fails to build with Python 3.11
