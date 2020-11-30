---
title: "Releases/1.4.3.17"
---

389 Directory Server 1.4.3.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.17

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=56455191> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-b73e7caaa7> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.17-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.17.tar.gz)

### Highlights in 1.4.3.17

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.3.17
- Issue 4384 - Use MONOTONIC clock for all timing events and conditions
- Issue 4449 - Add dsconf replication monitor test case (gitHub issue 4449) in  1.4.3 branch
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4467)
- Issue 4112 - Added a CI test (#4441)
- Issue 4460 - BUG  - lib389 should use system tls policy
- Issue 3657 - Add options to dsctl for dsrc file
- Issue 3986 - UI - Handle objectclasses that do not have X-ORIGIN set
- Issue 4297 - 2nd fix for on ADD replication URP issue internal searches with filter containing unescaped chars (#4439)
- Issue 4187 - improve mutex alloc in conntable
- Issue 3986 - Fix OID change between 10rfc2307 and 10rfc2307compat
- Issue 3986 - Update 2307compat.ldif
- Issue 4449 - dsconf replication monitor fails to retrieve database RUV - consumer (Unavailable) (#4451)
- Issue 4440 - BUG - ldifgen with --start-idx option fails with unsupported operand (#4444)
- Issue 4427 - do not add referrals for masters with different data generation #2054 (#4427)
- Issue 2058 - Add keep alive entry after on-line initialization - second version (#4399)
- Issue 4373 - BUG - Mapping Tree nodes can be created that are invalid
- Issue 4428 - BUG Paged Results with critical false causes sigsegv in chaining
- Issue 4428 - Paged Results with Chaining Test Case
- Issue 4383 - Do not normalize escaped spaces in a DN
- Issue 4425 - Backport tests from master branch, fix failing tests

