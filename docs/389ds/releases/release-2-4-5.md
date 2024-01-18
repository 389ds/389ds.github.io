---
title: "Releases/2.4.5"
---

389 Directory Server 2.4.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.5

Fedora packages are available on Fedora 39 and Rawhide.

Fedora 39:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=111921314> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2024-a6081ceaf9> - Bodhi


Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=111921327> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2024-2f482da5c8> - Bodhi


The new packages and versions are:

- 389-ds-base-2.4.5

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.4.5):
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.4.5/389-ds-base-2.4.5.tar.bz2>


### Highlights in 2.4.5

- Enhancements, and Bug fixes


### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package. There are no further steps required.

There are no upgrade steps besides installing the new rpms

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 2.4.5
- Issue 5989 - RFE support of inChain Matching Rule (#5990)
- Issue 5939 - During an update, if the target entry is reverted in the entry cache, the server should not retry to lock it (#6007)
- Issue 5944 - Reversion of the entry cache should be limited to BETXN plugin failures (#5994)
- Issue 5954 - Disable Transparent Huge Pages
- Issue 5984 - Crash when paged result search are abandoned - fix2 (#5987)
- Issue 5984 - Crash when paged result search are abandoned (#5985)
