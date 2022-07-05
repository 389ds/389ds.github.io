---
title: "Releases/2.0.16"
---

389 Directory Server 2.0.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.16

Fedora packages are available on Fedora 35

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=89131293> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-f0087e233f> - Bodhi


The new packages and versions are:

- 389-ds-base-2.0.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.16.tar.gz)

### Highlights in 2.0.16

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

- Bump version to 2.0.16
- Issue 5221 - fix covscan (#5359)
- Issue 4984 - BUG - pid file handling (#4986)
- Issue 5353 - CLI - dsconf backend export breaks with multiple backends
- Issue 5345 - BUG - openldap migration fails when ppolicy is active (#5347)
- Issue 5323 - BUG - improve skipping of monitor db (#5340)
- Issue 5323 - BUG - Fix issue in mdb tests with monitor (#5326)
- Issue 5329 - Improve replication extended op logging
- Issue 5343 - Various improvements to winsync
- Issue 4932 - CLI - add parser aliases to long arg names
- Issue 5332 - BUG - normalise filter as intended
- Issue 5126 - Memory leak in slapi_ldap_get_lderrno (#5153)
- Issue 5311 - Missing Requires for acl in the spec file
- Issue 5333 - 389-ds-base fails to build with Python 3.11
- Issue 5170 - BUG - incorrect behaviour of filter test (#5315)
- Issue 5324 - plugin acceptance test needs hardening
- Issue 5323 - BUG - migrating database for monitoring interface lead to crash (#5321)
- Issue 5304 - Need a compatibility option about sub suffix handling (#5310)
- Issue 5302 - Release tarballs don't contain cockpit webapp
- Issue 5237 - audit-ci: Cannot convert undefined or null to object
- Issue 5170 - BUG - ldapsubentries were incorrectly returned (#5285)
- Issue 4970 - Add support for recursively deleting subentries
- Issue 5284 - Replication broken after password change (#5286)
- Issue 5291 - Harden ReplicationManager.wait_for_replication (#5292)
- Issue 5279 - dscontainer: TypeError: unsupported operand type(s) for /: 'str' and 'int'
- Issue 5170 - RFE - Filter optimiser (#5171)
- Issue 5276 - CLI - improve task handling
- Issue 5273 - CLI - add arg completer for instance name
- Issue 2893 - CLI - dscreate - add options for setting up replication
- Issue 4866 - CLI - when enabling replication set changelog trimming by default
- Issue 5241 - UI - Add account locking missing functionality (#5251)
- Issue 5180 - snmp_collator tries to unlock NULL mutex (#5266)
- Issue 5098 - Fix cherry-pick error
- Issue 4904 - Fix various small issues
- Issue 5260 - BUG - OpenLDAP allows multiple names of memberof overlay (#5261)
- Issue 5252 - During DEL, vlv search can erroneously return NULL candidate (#5256)
- Issue 5210 - Python undefined names in lib389
- Issue 4959 - BUG - Invalid /etc/hosts setup can cause isLocalHost (#4960)
- Issue 5249 - dscontainer: ImportError: cannot import name 'get_default_db_lib' from 'lib389.utils'
- Issue 5242 - SECURITY_FIX - Craft message may crash the server (#5243)
- Issue 5234 - UI - rename Users and Groups tab
- Issue 5217 - Simplify instance creation and administration by non root user (#5224)
- Issue 5227 - UI - No way to move back to Get Started step (#5233)

