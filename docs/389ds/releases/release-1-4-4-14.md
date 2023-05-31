---
title: "Releases/1.4.4.14"
---

389 Directory Server 1.4.4.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.14

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=64115273> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-3eed313617> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.14.tar.gz)

### Highlights in 1.4.4.14

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

- Bump version to 1.4.4.14
- Issue 4671 - UI - Fix browser crashes
- Issue 4229 - Fix Rust linking
- Issue 4658 - monitor - connection start date is incorrect
- Issue 4656 - Make replication CLI backwards compatible with role name change
- Issue 4656 - Remove problematic language from UI/CLI/lib389
- Issue 4459 - lib389 - Default paths should use dse.ldif if the server is down
- Issue 4661 - RFE - allow importing openldap schemas (#4662)
- Issue 4659 - restart after openldap migration to enable plugins (#4660)
- Issue 4663 - CLI - unable to add objectclass/attribute without x-origin
- Issue 4169 - UI - updates on the tuning page are not reflected in the UI
- Issue 4588 - BUG - unable to compile without xcrypt (#4589)
- Issue 4513 - Fix replication CI test failures (#4557)
- Issue 4646 - CLI/UI - revise DNA plugin management
- Issue 4644 - Large updates can reset the CLcache to the beginning of the changelog (#4647)
- Issue 4649 - crash in sync_repl when a MODRDN create a cenotaph (#4652)
- Issue 4513 - CI - make acl ip address tests more robust
- Issue 4619 - remove pytest requirement from lib389
- Issue 4615 - log message when psearch first exceeds max threads per conn

