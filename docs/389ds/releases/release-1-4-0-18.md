---
title: "Releases/1.4.0.18"
---

389 Directory Server 1.4.0.18
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.18

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30170262>

Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30170314>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30170334>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-6bbce6f746>

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-5a691f3035>


The new packages and versions are:

- 389-ds-base-1.4.0.18-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.18.tar.bz2)

### Highlights in 1.4.0.18

Bug and security fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.18
- Ticket 49968 - Confusing CRITICAL message: list_candidates - NULL idl was recieved from filter_candidates_ext
- Ticket 49946 - upgrade of 389-ds-base could remove replication agreements.
- Ticket 49969 - DOS caused by malformed search operation (part 2)

