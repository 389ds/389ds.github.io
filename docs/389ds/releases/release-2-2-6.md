---
title: "Releases/2.2.6"
---

389 Directory Server 2.2.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.6

Fedora packages are available on Fedora 37

<https://koji.fedoraproject.org/koji/taskinfo?taskID=96571111>

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-6b79d79829> - Bohdi


The new packages and versions are:

- 389-ds-base-2.2.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.6.tar.gz)

### Highlights in 2.2.6

- Enhancements, and Bug fixes

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

- Bump version to 2.2.6
- Issue 5607, 5351, 5611 - UI/CLI - fix various issues
- Issue 5608 - UI - need to replace some "const" with "let"
- Issue 3604 - UI - Create a private key/CSR with dsconf/Cockpit (#5584)
- Issue 5602 - UI - browser crash when trying to modify read-only variable
- Issue 5581 - UI - Support cockpit dark theme
- Issue 5593 - CLI - dsidm account subtree-status fails with TypeError
- Issue 5591 - BUG - Segfault in cl5configtrim with invalid confi (#5592)
- Fix latest npm audit failures
- Issue 5599 - CI - webui tests randomly fail
- Issue 5348 - RFE - CLI - add functionality to do bulk updates to entries
- Issue 5526 - RFE - Improve saslauthd migration options (#5528)
- Issue 5588 - Fix CI tests
- Issue 5585 - lib389 password policy DN handling is incorrect (#5587)
- Issue 5521 - UI - Update plugins for new split PAM and LDAP pass thru auth

