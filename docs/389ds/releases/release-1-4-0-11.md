---
title: "Releases/1.4.0.11"
---

389 Directory Server 1.4.0.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.11

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27738498>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27738822>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-b3f2f29e65>

The new packages and versions are:

- 389-ds-base-1.4.0.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.11.tar.bz2)

### Highlights in 1.4.0.11

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.11
- Ticket 49788 - Add test for ticket #49788
- Ticket 49788 - Fixing 4-byte UTF-8 character validation
- Ticket 49777 - add config subcommand to dsconf
- Ticket 49712 - lib389 CLI tools should return a result code on failures
- Ticket 49588 - Add py3 support for tickets : part-2
- Remove old RHEL/fedora version checking from upstream specfile
- Ticket 48204 - remove python2 from scripts
- Ticket 49576 - ds-replcheck: fix certificate directory verification
- Bug 1591761 - 389-ds-base: Remove jemalloc exports

