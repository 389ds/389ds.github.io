---
title: "Releases/2.1.8"
---

389 Directory Server 2.1.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.1.8

Fedora packages are available on Fedora 36

<https://koji.fedoraproject.org/koji/taskinfo?taskID=100382283>

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-1c19398137> - Bodhi


The new packages and versions are:

- 389-ds-base-2.1.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.8.tar.gz)

### Highlights in 2.1.8

- Enhancements, Security, and Bug fixes

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

- Bump version to 2.1.8
- Issue 5734 - RFE - Exclude pwdFailureTime and ContextCSN (#5735)
- Issue 5726 - ns-slapd crashing in ldbm_back_upgradednformat (#5727)
- Issue 5714 - UI - fix typo, db settings, log settings, and LDAP editor paginations
- Issue 1081 - Stop schema replication from overwriting x-origin
- Bump webpack from 5.75.0 to 5.76.0 in /src/cockpit/389-console (#5699)
- Issue 5598 - fix testcase
- Issue 5598 - (3rd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5692)
- Issue 5598 - (2nd) In 2.x, SRCH throughput drops by 10% because of handling of referral (#5691)
- Issue 5687 - UI - sensitive information disclosure
- Issue 4583 - Update specfile to skip checks of ASAN builds
- Issue 5550 - dsconf monitor crashes with Error math domain error (#5553)
- Issue 3604 - UI - Add support for Subject Alternative Names in CSR
- Fix build break
- Issue 5640 - Update logconv for new logging format
- Issue 5545 - A random crash in import over lmdb (#5546)
- Issue 5490 - tombstone in entryrdn index with lmdb but not with bdb (#5498)
- Issue 5408 - lmdb import is slow (#5481)
- Issue 5162 - CI - fix error message for invalid pem file
- Issue 5598 - In 2.x, SRCH throughput drops by 10% because of handling of referral (#5604)
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
- Issue 5578 - dscreate ds-root does not normaile paths (#5613)
- Issue 5560 - dscreate run by non superuser set defaults requiring superuser privilege (#5579)
- Issue 5624 - RFE - UI - export certificates, and import text base64 encoded certificates
- Issue 4293 - RFE - CLI - add dsrc options for setting user and group subtrees
- Issue 5497 - boolean attributes should be case insensitive

- Bump version to 2.1.7
- Issue 5607, 5351, 5611 - UI/CLI - fix various issues
- Issue 5608 - UI - need to replace some "const" with "let"
- Issue 3604 - Create a private key/CSR with dsconf/Cockpit (#5584)
- Issue 5602 - UI - browser crash when trying to modify read-only variable
- Issue 5581 - UI - Support cockpit dark theme
- Issue 5593 - CLI - dsidm account subtree-status fails with TypeError
- Issue 5591 - BUG - Segfault in cl5configtrim with invalid confi (#5592)
- Fix latest npm audit failures
- Issue 5599 - CI - webui tests randomly fail
- Issue 5348 - RFE - CLI - add functionality to do bulk updates to entries
- Issue 5526 - RFE - Improve saslauthd migration options (#5528)
- Issue 5588 - Fix CI tests
- Issue 5585 - lib389 password policy DN handling is incorrect (#5587)
- Issue 5521 - UI - Update plugins for new split PAM and LDAP pass thru auth
- Issue 5236 - UI add specialized group edit modal
- Issue 5278 - CLI - dsidm asks for the old password on password reset
- Issue 5531 - CI - use universal_lines in capture_output
- Issue 5505 - Fix compiler warning (#5506)
- Issue 3615 - CLI - prevent virtual attribute indexing
- Issue 5413 - Allow mutliple MemberOf fixup tasks with different bases/filters
- Issue 5561 - Nightly tests are failing
- Issue 5521 - RFE - split pass through auth cli
- Issue 5521 - BUG - Pam PTA multiple issues
- Issue 5544 - Increase default task TTL
- Issue 5541 - Fix typo in `lib389.cli_conf.backend._get_backend` (#5542)
- Issue 5539 - Make logger's parameter name unified (#5540)
- Issue 5534 - Fix a rebase typo (#5537)
- Issue 5534 - Add copyright text to the repository files


