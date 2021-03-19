---
title: "Releases/1.4.3.22"
---

389 Directory Server 1.4.3.22
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.22

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=64103798> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-35654cb13a> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.22-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.22.tar.gz)

### Highlights in 1.4.3.22

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

- Bump version to 1.4.3.22
- Issue 4671 - UI - Fix browser crashes
- lib389 - Add ContentSyncPlugin class
- Issue 4656 - lib389 - fix cherry pick error
- Issue 4229 - Fix Rust linking
- Issue 4658 - monitor - connection start date is incorrect
- Issue 2621 - lib389 - backport ds_supports_new_changelog()
- Issue 4656 - Make replication CLI backwards compatible with role name change
- Issue 4656 - Remove problematic language from UI/CLI/lib389
- Issue 4459 - lib389 - Default paths should use dse.ldif if the server is down
- Issue 4663 - CLI - unable to add objectclass/attribute without x-origin

