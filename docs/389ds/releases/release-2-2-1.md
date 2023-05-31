---
title: "Releases/2.2.1"
---

389 Directory Server 2.2.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.1

Fedora packages are available on Rawhide (f37)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=87838342>


The new packages and versions are:

- 389-ds-base-2.2.1-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.1.tar.gz)

### Highlights in 2.2.1

- Enhancement, Bug, and Security fixes
- Transition from BDB(libdb) to LMDB begun.  BDB is still the default backend, but it can be changed to LMDB for early testing.

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

- Bump version to 2.2.1
- Issue 5323 - BUG - Fix issue in mdb tests with monitor (#5326)
- Issue 5170 - BUG - incorrect behaviour of filter test (#5315)
- Issue 5324 - plugin acceptance test needs hardening
- Issue 5319 - dsctl_tls_test.py fails with openssl-3.x
- Issue 5323 - BUG - migrating database for monitoring interface lead to crash (#5321)
- Issue 5304 - Need a compatibility option about sub suffix handling (#5310)
- Issue 5313 - dbgen test uses deprecated -h HOST and -p PORT options for ldapmodify
- Issue 5311 - Missing Requires for acl in the spec file
- Issue 5305 - OpenLDAP version autodetection doesn't work
- Issue 5307 - VERSION_PREREL is not set correctly in CI builds
- Issue 5302 - Release tarballs don't contain cockpit webapp
- Issue 5170 - RFE - improve filter logging to assist debugging (#5301)
- Issue 5299 - jemalloc 5.3 released
- Issue 5175 - Remove stale zlib-devel dependency declaration (#5173)
- Issue 5294 - Report Portal 5 is not processing test results XML file
- Issue 5170 - BUG - ldapsubentries were incorrectly returned (#5285)
- Issue 5291 - Harden ReplicationManager.wait_for_replication (#5292)
- Issue  379 - RFE - Compress rotated logs (fix linker)
- Issue  379 - RFE - Compress rotated logs
- Issue 5281 - HIGH - basic test does not run
- Issue 5284 - Replication broken after password change (#5286)
- Issue 5279 - dscontainer: TypeError: unsupported operand type(s) for /: 'str' and 'int'
- Issue 5170 - RFE - Filter optimiser (#5171)
- Issue 5276 - CLI - improve task handling
- Issue 5126 - Memory leak in slapi_ldap_get_lderrno (#5153)
- Issue 3 - ansible-ds - Prefix handling fix (#5275)
- Issue 5273 - CLI - add arg completer for instance name
- Issue 2893 - CLI - dscreate - add options for setting up replication
- Issue 4866 - CLI - when enabling replication set changelog trimming by default
- Issue 5241 - UI - Add account locking missing functionality (#5251)
- Issue 5180 - snmp_collator tries to unlock NULL mutex (#5266)
- Issue 4904 - Fix various small issues
- lib389 prerequisite for ansible-ds (#5253)
- Issue 5260 - BUG - OpenLDAP allows multiple names of memberof overlay (#5261)
- Issue 5252 - During DEL, vlv search can erroneously return NULL candidate (#5256)
- Issue 5254 - dscreate create-template regression due to 5a3bdc336 (#5255)
- Issue 5210 - Python undefined names in lib389
- Issue 5065 - Crash in suite plugins - test_dna_max_value (#5108)
- Issue 5247 - BUG - Missing attributes in samba schema (#5248)
- Issue 5242- Craft message may crash the server (#5243)
- Issue 4775 -plugin entryuuid failing (#5229)
- Issue 5239 - Nightly copr builds are broken
- Issue 5237 - audit-ci: Cannot convert undefined or null to object
- Issue 5234 - UI - rename Users and Groups tab
- Issue 5227 - UI - No way to move back to Get Started step (#5233)
- Issue 5217 - Simplify instance creation and administration by non root user (#5224)

