---
title: "Releases/1.4.3.18"
---

389 Directory Server 1.4.3.18
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.18

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=59774017> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-19b143e4a5> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.18-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.18.tar.gz)

### Highlights in 1.4.3.18

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

- Bump version to 1.4.3.18
- Issue 4513 - CI Tests - fix test failures
- Issue 4528 - Fix cn=monitor SCOPE_ONE search (#4529)
- Issue 4504 - insure that repl_monitor_test use ldapi (for RHEL) - fix merge issue (#4533)
- Issue 4315 - performance search rate: nagle triggers high rate of setsocketopt
- Issue 4504 - Insure ldapi is enabled in repl_monitor_test.py (Needed on RHEL) (#4527)
- Issue 4506 - BUG - Fix bounds on fd table population (#4520)
- Issue 4521 - DS crash in deref plugin if dereferenced entry exists but is not returned by internal search (#4525)
- Issue 4418 - lib389 - fix ldif2db import_cl parameter
- Issue 4384 - Separate eventq into REALTIME and MONOTONIC
- Issue 4418 - ldif2db - offline. Warn the user of skipped entries
- Issue 4414 - disk monitoring - prevent division by zero crash
- Issue 4507 - Improve csngen testing task (#4508)
- Issue 4486 - Remove random ldif file generation from import test (#4487)
- Issue 4489 - Remove return statement from a void function (#4490)
- Issue 4419 - Warn users of skipped entries during ldif2db online import (#4476)
- Issue 4418 - ldif2db - offline. Warn the user of skipped entries
- Issue 4504 - Fix pytest test_dsconf_replication_monitor (#4505)
- Issue 4480 - Unexpected info returned to ldap request (#4491)
- Issue 4373 - BUG - one line cleanup, free results in mt if ent 0 (#4502)
- Issue 4500 - Add cockpit enabling to dsctl
- Issue 4272 - RFE - add support for gost-yescrypt for hashing passwords (#4497)
- Issue 1795 - RFE - Enable logging for libldap and libber in error log (#4481)
- Issue 4492 - Changelog cache can upload updates from a wrong starting point (CSN)
- Issue 4373 - BUG - calloc of size 0 in MT build (#4496)
- Issue 4483 - heap-use-after-free in slapi_be_getsuffix
- Issue 4315 - performance search rate: nagle triggers high rate of setsocketopt (#4437)
- Issue 4243 - Fix test (4th): SyncRepl plugin provides a wrong (#4475)
- Issue 4460 - BUG - add machine name to subject alt names in SSCA (#4472)
- Issue 4284 - dsidm fails to delete an organizationalUnit entry
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4466)

