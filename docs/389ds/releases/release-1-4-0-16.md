---
title: "Releases/1.4.0.16"
---

389 Directory Server 1.4.0.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.16

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1139175>

Fedora 29

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1139177>

Fedora 28

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1139176>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-aaf73e583d>

The new packages and versions are:

- 389-ds-base-1.4.0.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.16.tar.bz2)

### Highlights in 1.4.0.16

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

- Bump version to 1.4.0.16
- Revert "Ticket 49372 - filter optimisation improvements for common queries"
- Revert "Ticket 49432 - filter optimise crash"
- Ticket 49887 - Fix SASL map creation when --disable-perl
- Ticket 49858 - Add backup/restore and import/export functionality to WebUI/CLI


