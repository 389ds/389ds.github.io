---
title: "Releases/1.4.4.9"
---

389 Directory Server 1.4.4.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.9

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=56470736> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-5f9a6218fa> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.9.tar.gz)

### Highlights in 1.4.4.9

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

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.4.9
- Issue 4105 - Remove python.six (fix regression)
- Issue 4384 - Use MONOTONIC clock for all timing events and conditions
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4467)
- Issue 4460 - BUG  - lib389 should use system tls policy
- Issue 3657 - Add options to dsctl for dsrc file
- Issue 3986 - UI - Handle objectclasses that do not have X-ORIGIN set
- Issue 4297 - 2nd fix for on ADD replication URP issue internal searches with filter containing unescaped chars (#4439)
- Issue 4449 - dsconf replication monitor fails to retrieve database RUV - consumer (Unavailable) (#4451)
- Issue 4105 - Remove python.six from lib389 (#4456)
- Issue 4440 - BUG - ldifgen with --start-idx option fails with unsupported operand (#4444)
- Issue 2054 - do not add referrals for masters with different data generation #2054 (#4427)
- Issue 2058 - Add keep alive entry after on-line initialization - second version (#4399)
- Issue 4373 - BUG - Mapping Tree nodes can be created that are invalid
- Issue 4428 - BUG Paged Results with critical false causes sigsegv in chaining
- Issue 4428 - Paged Results with Chaining Test Case
- Issue 4383 - Do not normalize escaped spaces in a DN
- Issue 4432 - After a failed online import the next imports are very slow
- Issue 4404 - build problems at alpine linux
- Issue 4316 - performance search rate: useless poll on network send callback (#4424)
- Issue 4429 - NULL dereference in revert_cache()
- Issue 4391 - DSE config modify does not call be_postop (#4394)
- Issue 4412 - Fix CLI repl-agmt requirement for parameters (#4422)


