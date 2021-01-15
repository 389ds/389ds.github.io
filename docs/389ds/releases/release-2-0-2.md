---
title: "Releases/2.0.2"
---

389 Directory Server 2.0.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.2

Fedora packages are available on Rawhide (Fedora 34).


Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=59725113>


The new packages and versions are:

- 389-ds-base-2.0.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.2.tar.gz)

### Highlights in 2.0.2

- Bug & security fixes

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

- Bump version to 2.0.2
- Issue 4539 - BUG - no such file if no overlays in openldap during migration (#4540)
- Issue 4528 - Fix cn=monitor SCOPE_ONE search (#4529)
- Issue 4535 - lib389 - healthcheck throws exception if backend is not replicated
- Issue 4537 - Use KRB5_CLIENT_KTNAME for client keytabs (#4523)
- Issue 4513 - CI Tests - fix test failures
- Issue 4504 - insure that repl_monitor_test use ldapi (for RHEL) - fix merge issue (#4533)
- Issue 4315 - performance search rate: nagle triggers high rate of setsocketopt
- Issue 4504 - pytest test_dsconf_replication_monitor fails on RHEL - Fix merging issue (#4530)
- Issue 4504 - Insure ldapi is enabled in repl_monitor_test.py (Needed on RHEL) (#4527)
- Issue 4506 - BUG - Fix bounds on fd table population (#4520)
- Issue 4521 - DS crash in deref plugin if dereferenced entry exists but is not returned by internal search (#4525)
- Issue 4219 - Log internal unindexed searches (notes=A)
- Issue 4384 - Separate eventq into REALTIME and MONOTONIC
- Issue 4381 - RFE - LDAPI authentication DN rewritter
- Issue 4513 - Fix schema test and lib389 task module (#4514)
- Issue 4414 - disk monitoring - prevent division by zero crash
- Issue 4517 - BUG: Multiple systemd pin warnings (#4518)
- Issue 4507 - Improve csngen testing task (#4508)
- Issue 4498 - BUG - entryuuid replication may not work (#4503)
- Issue 4480 - Unexpected info returned to ldap request (Security fix)
- Issue 4504 - Fix pytest test_dsconf_replication_monitor (#4505)
- Issue 4373 - BUG - one line cleanup, free results in mt if ent 0 (#4502)
- Issue 4500 - Add cockpit enabling to dsctl
- Issue 4272 - RFE - add support for gost-yescrypt for hashing passwords (#4497)
- Issue 1795 - RFE - Enable logging for libldap and libber in error log (#4481)
- Issue 3522 - Remove DES to AES conversion code
- Issue 4492 - Changelog cache can upload updates from a wrong starting point (CSN) (#4493)
- Issue 4373 - BUG - calloc of size 0 in MT build (#4496)
- Issue 4483 - heap-use-after-free in slapi_be_getsuffix
- Issue 4486 - Remove random ldif file generation from import test (#4487)
- Issue 4224 - cleanup specfile after libsds removal
- Issue 4421 - Unable to build with Rust enabled in closed environment
- Issue 4489 - Remove return statement from a void function (#4490)
- Issue 4229 - RFE - Improve rust linking and build performance (#4474)
- Issue 4224 - openldap can become confused with entryuuid
- Issue 4313 - improve tests and improve readme re refdel
- Issue 4313 - fix potential syncrepl data corruption
- Issue 4419 - Warn users of skipped entries during ldif2db online import (#4476)
- Issue 4243 - Fix test (4th): SyncRepl plugin provides a wrong (#4475)
- Issue 4315 - performance search rate: nagle triggers high rate of setsocketopt (#4437)
- Issue 4460 - BUG - add machine name to subject alt names in SSCA (#4472)
- Issue 4446 - RFE - openldap password hashers
- Issue 4284 - dsidm fails to delete an organizationalUnit entry
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4466) (#4466)
- Issue 4464 - RFE - clang with ds+asan+rust
- Issue 4105 - Remove python.six (fix regression)
- Issue 4384 - Use MONOTONIC clock for all timing events and conditions
- Issue 4418 - ldif2db - offline. Warn the user of skipped entries
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4467)
- Issue 4460 - BUG  - lib389 should use system tls policy
- Issue 3657 - Add options to dsctl for dsrc file
- Issue 4454 - RFE - fix version numbers to allow object caching
- Issue 3986 - UI - Handle objectclasses that do not have X-ORIGIN set
- Issue 4297 - 2nd fix for on ADD replication URP issue internal searches with filter containing unescaped chars (#4439)
- Issue 4112 - Added a CI test (#4441)
- Issue 4449 - dsconf replication monitor fails to retrieve database RUV - consumer (Unavailable) (#4451)
- Issue 4105 - Remove python.six from lib389 (#4456)
- Issue 4440 - BUG - ldifgen with --start-idx option fails with unsupported operand (#4444)
- Issue 4410 - RFE - ndn cache with arc in rust
- Issue 4373 - BUG - Mapping Tree nodes can be created that are invalid
- Issue 4428 - BUG Paged Results with critical false causes sigsegv in chaining
- Issue 4428 - Paged Results with Chaining Test Case
- Issue 2054 - do not add referrals for masters with different data generation
- Issue 4383 - Do not normalize escaped spaces in a DN
- Issue 4432 - After a failed online import the next imports are very slow
- Issue 4316 - performance search rate: useless poll on network send callback (#4424)
- Issue 4281 - dsidm user status fails with Error: 'nsUserAccount' object has no attribute 'is_locked'
- Issue 4429 - NULL dereference in revert_cache()
- Issue 4412 - Fix CLI repl-agmt requirement for parameters (#4422)
- Issue 4407 - RFE - remove http client and presence plugin (#4409)
- Issue 4398 - build problems at alpine linux
- Issue 4415 - unable to query schema if there are extra parenthesis


