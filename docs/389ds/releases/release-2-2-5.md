---
title: "Releases/2.2.5"
---

389 Directory Server 2.2.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.5

Fedora packages are available on Fedora 37

<https://koji.fedoraproject.org/koji/taskinfo?taskID=95739655>

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-991458fbec> - Bohdi


The new packages and versions are:

- 389-ds-base-2.2.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.5.tar.gz)

### Highlights in 2.2.5

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

- Bump version to 2.2.5
- Issue 5236 - UI add specialized group edit modal
- Issue 5278 - CLI - dsidm asks for the old password on password reset
- Issue 5531 - CI - use universal_lines in capture_output
- Issue 5505 - Fix compiler warning (#5506)
- Issue 3615 - CLI - prevent virtual attribute indexing
- Issue 5413 - Allow multiple MemberOf fixup tasks with different bases/filters
- Issue 5561 - Nightly tests are failing
- Issue 5521 - RFE - split pass through auth cli
- Issue 5521 - BUG - Pam PTA multiple issues
- Issue 5544 - Increase default task TTL
- Issue 5541 - Fix typo in `lib389.cli_conf.backend._get_backend` (#5542)
- Issue 5539 - Make logger's parameter name unified (#5540)
- Issue 3729 - (cont) RFE Extend log of operations statistics in access log (#5538)
- Issue 5534 - Fix a rebase typo (#5537)
- Issue 5534 - Add copyright text to the repository file

