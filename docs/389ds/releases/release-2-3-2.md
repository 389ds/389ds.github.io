---
title: "Releases/2.3.2"
---

389 Directory Server 2.3.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.3.2

Fedora packages are available on Rawhide (f38)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=96566979>

The new packages and versions are:

- 389-ds-base-2.3.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.3.2.tar.gz)

### Highlights in 2.3.2

- Enhancements, and Bug fixes

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

