---
title: "Releases/1.4.0.13"
---

389 Directory Server 1.4.0.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.13

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28468953>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28469862>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-f6a8f8036d>

The new packages and versions are:

- 389-ds-base-1.4.0.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.13.tar.bz2)

### Highlights in 1.4.0.13

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

- Bump version to 1.4.0.13
- Ticket 49854 - ns-slapd should create run_dir and lock_dir directories at startup
- Ticket 49806 - Add SASL functionality to CLI/UI
- Ticket 49789 - backout originali security fix from 1.4.0.12 as it caused a regression in FreeIPA
- Ticket 49857 - RPM scriptlet for 389-ds-base-legacy-tools throws an error

