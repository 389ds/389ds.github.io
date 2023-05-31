---
title: "Releases/2.3.3"
---

389 Directory Server 2.3.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.3.3

Fedora packages are available on Fedora f38

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=100387023>

Bodhi:

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-834b89af31>

The new packages and versions are:

- 389-ds-base-2.3.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.3.3.tar.gz)

### Highlights in 2.3.3

- Enhancements, Security and Bug fixes

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
- Bump version to 2.3.3
- Issue 5726 - ns-slapd crashing in ldbm_back_upgradednformat (#5727)
- Issue 5718 - Memory leak in connection table (#5719)
- Issue 5705 - Add config parameter to close client conns on failed bind (#5712)
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

- Bump version to 2.3.2
- Issue 5547 - automember plugin improvements
- Issue 5607, 5351, 5611 - UI/CLI - fix various issues
- Issue 5610 - Build failure on Debian
- Issue 5608 - UI - need to replace some "const" with "let"
- Issue 5560 - dscreate run by non superuser set defaults requiring superuser privilege (#5579)
- Issue 3604 - Create a private key/CSR with dsconf/Cockpit (#5584)
- Issue 5605 - Adding a slapi_log_backtrace function in libslapd (#5606)
- Issue 5602 - UI - browser crash when trying to modify read-only variable
- Issue 5581 - UI - Support cockpit dark theme
- Issue 5593 - CLI - dsidm account subtree-status fails with TypeError
- Issue 5591 - BUG - Segfault in cl5configtrim with invalid confi (#5592)
- Fix latest npm audit failures
- Issue 5599 - CI - webui tests randomly fail
- Issue 5348 - RFE - CLI - add functionality to do bulk updates to entries
- Issue 5588 - Fix CI tests
- Issue 5585 - lib389 password policy DN handling is incorrect (#5587)
- Issue 5521 - UI - Update plugins for new split PAM and LDAP pass thru auth
- Bump json5 from 2.2.1 to 2.2.3 in /src/cockpit/389-console
- Issue 5236 - UI add specialized group edit modal
- Issue 5550 - dsconf monitor crashes with Error math domain error (#5553)
- Issue 5278 - CLI - dsidm asks for the old password on password reset
- Issue 5531 - CI - use universal_lines in capture_output
- Issue 5425 - CLI - add confirmation arg when deleting backend
- Issue 5558 - non-root instance fails to start on creation (#5559)
- Issue 5545 - A random crash in import over lmdb (#5546)
- Issue 3615 - CLI - prevent virtual attribute indexing
- Update specfile and rust crates
- Issue 5413 - Allow multiple MemberOf fixup tasks with different bases/filters
- Issue 5554 - Add more tests to security_basic_test suite (#5555)
- Issue 5561 - Nightly tests are failing
- Issue 5521 - RFE - split pass through auth cli
- Issue 5521 - BUG - Pam PTA multiple issues
- Issue 5544 - Increase default task TTL
- Issue 5526 - RFE - Improve saslauthd migration options (#5528)
- Issue 5539 - Make logger's parameter name unified (#5540)
- Issue 5541 - Fix typo in lib389.cli_conf.backend._get_backend (#5542)
- Issue 3729 - (cont) RFE Extend log of operations statistics in access log (#5538)
- Issue 5534 - Fix a rebase typo (#5537)
- Issue 5534 - Add copyright text to the repository files

