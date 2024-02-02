---
title: "Releases/3.0.1"
---

389 Directory Server 3.0.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.0.1

Fedora packages are available on RawHide. (For Fedora 40)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=112619489> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2024-88f958bb2c> - Bodhi


The new packages and versions are:

- 389-ds-base-3.0.1

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.0.1)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.0.1/389-ds-base-3.0.1.tar.bz2>

### Highlights in 3.0.1

- Lightning Memory-Mapped Database Manager (LMDB) is now used by default when creating new instances instead of
Berkeley Database that is deprecated (but still usable)
For more informations, see: [FAQ about BerkeleyDB backend deprecation and using LMDB backend](../FAQ/Berkeley-DB-deprecation.html)
- The fact of using lmdb instead of Berkeley DB may greatly change the server dynamic so we decided
to change the major version but in practice for instances that are still using Berkeley database,
it is only a minor update.
- Enhancements and Bug fixes

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

Please provide feedback and comments to the 
 - 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
 - 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 3.0.1
- Issue 6043, 6044 - Enhance Rust and JS bundling and add SPDX licenses for both (#6045)
- Issue 3555 - Remove audit-ci from dependencies (#6056)
- Issue 6052 - Paged results test sets hostname to `localhost` on test collection
- Issue 6051 - Drop unused pytest markers
- Issue 6049 - lmdb - changelog is wrongly recreated by reindex task (#6050)
- Issue 6047 - Add a check for tagged commits
- Issue 6041 - dscreate ds-root - accepts relative path (#6042)
- Switch default backend to lmdb and bump version to 3.0 (#6013)
- Issue 6032 - Replication broken after backup restore (#6035)
- Issue 6037 - Server crash at startup in vlvIndex_delete (#6038)
- Issue 6034 - Change replica_id from str to int
- Issue 6028 - vlv index keys inconsistencies (#6031)
- Issue 5989 - RFE support of inChain Matching Rule (#5990)
- Issue 6022 - lmdb inconsistency between vlv index and vlv cache names (#6026)
- Issue 6015 - Fix typo remeber (#6014)
- Issue 6016 - Pin upload/download artifacts action to v3
- Issue 5939 - During an update, if the target entry is reverted in the entry cache, the server should not retry to lock it (#6007)
- Issue 4673 - Update Rust crates
- Issue 6004 - idletimeout may be ignored (#6005)
- Issue 5954 - Disable Transparent Huge Pages
- Issue 5997 - test_inactivty_and_expiration CI testcase is wrong (#5999)
- Issue 5993 - Fix several race condition around CI tests (#5996)
- Issue 5944 - Reversion of the entry cache should be limited to BETXN plugin failures (#5994)
- Bump openssl from 0.10.55 to 0.10.60 in /src (#5995)
- Issue 5980 - Improve instance startup failure handling (#5991)
- Issue 5976 - Fix freeipa install regression with lmdb (#5977)
- Issue 5984 - Crash when paged result search are abandoned - fix2 (#5987)
- Issue 5984 - Crash when paged result search are abandoned (#5985)
- Issue 5947 - CI test_vlv_recreation_reindex fails on LMDB (#5979)
