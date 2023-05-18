---
title: "Releases/2.4.0"
---

389 Directory Server 2.4.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.0

Fedora packages are available on Rawhide (f39)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=101287079>

The new packages and versions are:

- 389-ds-base-2.4.0-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.4.0.tar.gz)

### Highlights in 2.4.0

- LDAP Alias Entries plugin
- New Password Administrator feature to skip updating the target entry's password state attributes
- New Account Policy plugin features allows you to to enforce both inactivity and expiration at the same time
- UI - replication monitor report can be loaded and saved in the .dsrc file
- Provide a history for LastLoginTime


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

- Bump version to 2.4.1
- Issue 5770 - RFE - Extend Password Adminstrators to allow skipping password info updates
- Issue 5768 - CLI/UI - cert checks are too strict, and other issues
- Issue 5722 - fix compilation warnings (#5771)
- Issue 5765 - Improve installer selinux handling
- Issue 152  - RFE - Add support for LDAP alias entries
- Issue 5052 - BUG - Custom filters prevented entry deletion (#5060)
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5753)
- Issue 5722 - RFE When a filter contains 'nsrole', improve response time by rewriting the filter (#5723)
- Issue 5704 - crash in sync_refresh_initial_content (#5720)
- Issue 5738 - RFE - UI - Read/write replication monitor info to .dsrc file
- Issue 5156 - build warnings (#5758)
- Issue 5749 - RFE - Allow Account Policy Plugin to handle inactivity and expiration at the same time
- Issue 5743 - Disabling replica crashes the server (#5746)
- Issue 2562 - Copy config files into backup directory
- Issue 5156 - fix build breakage from slapi-memberof commit
- Issue 4758 - Add tests for WebUI

- Bump version to 2.4.0
- Issue 5156 - RFE that implement slapi_memberof (#5694)
- Issue 5734 - RFE - Exclude pwdFailureTime and ContextCSN (#5735)
- Issue 5726 - ns-slapd crashing in ldbm_back_upgradednformat (#5727)
- Issue 4758 - Add tests for WebUI
- Issue 5718 - Memory leak in connection table (#5719)
- Issue 5705 - Add config parameter to close client conns on failed bind (#5712)
- Issue 4758 - Add tests for WebUI
- Issue 5643 - Memory leak in entryrdn during delete (#5717)
- Issue 5714 - UI - fix typo, db settings, log settings, and LDAP editor paginations
- Issue 5701 - CLI - Fix referral mode setting (#5708)
- Bump openssl from 0.10.45 to 0.10.48 in /src (#5709)
- Issue 5710 - subtree search statistics for index lookup does not report ancestorid/entryrdn lookups (#5711)
- Issue 5697 - Obsolete nsslapd-ldapimaprootdn attribute (#5698)
- Issue 1081 - Stop schema replication from overwriting x-origin
- Issue 4812 - Listener thread does not scale with a high num of established connections (#5706)
- Issue 4812 - Listener thread does not scale with a high num of established connections (#5681)
- Bump webpack from 5.75.0 to 5.76.0 in /src/cockpit/389-console (#5699)
- Issue 5598 - (3rd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5692)
- Issue 5598 - (2nd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5691)
- Issue 5687 - UI - sensitive information disclosure
- Issue 5661 - LMDB hangs while Rebuilding the replication changelog RUV (#5676)
- Issue 5554 - Add more tests to security_basic_test suite
- Issue 4583 - Update specfile to skip checks of ASAN builds
- Issue 4758 - Add tests for WebUI
- Issue 3604 - UI - Add support for Subject Alternative Names in CSR
- Issue 5600 - buffer overflow when enabling sync repl plugin when dynamic plugins is enabled
- Issue 5640 - Update logconv for new logging format
- Issue 5162 - CI - fix error message for invalid pem file
- Issue 5598 - In 2.x, SRCH throughput drops by 10% because of handling of referral (#5604)
- Issue 5671 - covscan - clang warning (#5672)
- Issue 5267 - CI - Fix issues with nsslapd-return-original-entrydn
- Issue 5666 - CLI - Add timeout parameter for tasks
- Issue 5567 - CLI - make ldifgen use the same default ldif name for all options
- Issue 5647 - Fix unused variable warning from previous commit (#5670)
- Issue 5162 - Lib389 - verify certificate type before adding
- Issue 5642 - Build fails against setuptools 67.0.0
- Issue 5630 - CLI - need to add logging filter for stdout
- Issue 5646 - CLI/UI - do not hardcode password storage schemes
- Issue 5640 - Update logconv for new logging format
- issue 5647 - covscan: memory leak in audit log when adding entries (#5650)
- Issue 5658 - CLI - unable to add attribute with matching rule
- Issue 5653 - covscan - fix invalid dereference
- Issue 5652 - Libasan crash in replication/cascading_test (#5659)
- Issue 5628 - Handle graceful timeout in CI tests (#5657)
- Issue 5648 - Covscan - Compiler warnings (#5651)
- Issue 5630 - CLI - error messages should goto stderr
- Issue 2435 - RFE - Raise IDL Scan Limit to INT_MAX (#5639)
- Issue 5632 - CLI - improve error handling with db2ldif
- Issue 5517 - Replication conflict CI test sometime fails (#5518)
- Issue 5634 - Deprecated warning related to github action workflow code (#5635)
- Issue 5637 - Covscan - fix Buffer Overflows (#5638)
- Issue 5624 - RFE - UI - export certificates, and import text base64 encoded certificates
- Bump tokio from 1.24.1 to 1.25.0 in /src (#5629)
- Issue 4577 - Add LMDB pytest github action (#5627)
- Issue 4293 - RFE - CLI - add dsrc options for setting user and group subtrees
- Remove stale libevent(-devel) dependency
- Issue 5578 - dscreate ds-root does not normaile paths (#5613)
- Issue 5497 - boolean attributes should be case insensitive


