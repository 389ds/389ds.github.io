---
title: "Releases/2.2.8"
---

389 Directory Server 2.2.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.8

Fedora packages are available on Fedora 37

<https://koji.fedoraproject.org/koji/taskinfo?taskID=101293586>

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-560cd47894> - Bohdi


The new packages and versions are:

- 389-ds-base-2.2.8-2

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.8.tar.gz)

### Highlights in 2.2.8

- New LDAP Alias Entries plugin
- Provide a history for LastLoginTime
- New Password Administrator feature to skip updating the target entry's password state attributes
- New Account Policy plugin features allows you to to enforce both inactivity and expiration at the same time
- UI - replication monitor report can be loaded and saved in the .dsrc file

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

- Bump version to 2.2.8
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5753)
- Issue 5770 - RFE - Extend Password Adminstrators to allow skipping password info updates
- Issue 5768 - CLI/UI - cert checks are too strict, and other issues
- Issue 5765 - Improve installer selinux handling
- Issue 5643 - Memory leak in entryrdn during delete (#5717)
- Issue 152  - RFE - Add support for LDAP alias entries
- Issue 5052 - BUG - Custom filters prevented entry deletion (#5060)
- Issue 5704 - crash in sync_refresh_initial_content (#5720)
- Issue 5738 - RFE - UI - Read/write replication monitor info to .dsrc file
- Issue 5749 - RFE - Allow Account Policy Plugin to handle inactivity and expiration at the same time

- Bump version to 2.2.7-2
- Issue 5734 - RFE - Exclude pwdFailureTime and ContextCSN (#5735)
- Issue 5726 - ns-slapd crashing in ldbm_back_upgradednformat (#5727)
- Issue 5714 - UI - fix typo, db settings, log settings, and LDAP editor paginations
- Issue 5710 - subtree search statistics for index lookup does not report ancestorid/entryrdn lookups (#5711)
- Issue 1081 - Stop schema replication from overwriting x-origin
- Bump webpack from 5.75.0 to 5.76.0 in /src/cockpit/389-console (#5699)
- Issue 5598 - (3rd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5692)
- Issue 5598 - (2nd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5691)
- Issue 5687 - UI - sensitive information disclosure
- Issue 4583 - Update specfile to skip checks of ASAN builds
- Issue 5550 - dsconf monitor crashes with Error math domain error (#5553)
- Issue 3604 - UI - Add support for Subject Alternative Names in CSR
- Issue 5600 - buffer overflow when enabling sync repl plugin when dynamic plugins is enabled
- Fix build break
- Issue 5640 - Update logconv for new logging format
- Issue 5545 - A random crash in import over lmdb (#5546)
- Issue 5490 - tombstone in entryrdn index with lmdb but not with bdb (#5498)
- Issue 5408 - lmdb import is slow (#5481)
- Issue 5162 - CI - fix error message for invalid pem file
- Issue 5598 - In 2.x, SRCH throughput drops by 10% because of handling of referral (#5604)
- Issue 5671 - covscan - clang warning (#5672)
- Issue 5267 - CI - Fix issues with nsslapd-return-original-entrydn
- Issue 5666 - CLI - Add timeout parameter for tasks
- Issue 5567 - CLI - make ldifgen use the same default ldif name for all options
- Issue 5162 - Lib389 - verify certificate type before adding
- Issue 5630 - CLI - need to add logging filter for stdout
- Issue 5646 - CLI/UI - do not hardcode password storage schemes
- Issue 5640 - Update logconv for new logging format
- Issue 5652 - Libasan crash in replication/cascading_test (#5659)
- Issue 5658 - CLI - unable to add attribute with matching rule
- Issue 5653 - covscan - fix invalid dereference
- Issue 5648 - Covscan - Compiler warnings (#5651)
- Issue 5630 - CLI - error messages should goto stderr
- Issue 2435 - RFE - Raise IDL Scan Limit to INT_MAX (#5639)
- Issue 5632 - CLI - improve error handling with db2ldif
- Issue 5578 - dscreate ds-root does not normalize paths (#5613)
- Issue 5560 - dscreate run by non superuser set defaults requiring superuser privilege (#5579)
- Issue 5624 - RFE - UI - export certificates, and import text base64 encoded certificates
- Issue 4293 - RFE - CLI - add dsrc options for setting user and group subtrees
- Issue 5497 - boolean attributes should be case insensitive


