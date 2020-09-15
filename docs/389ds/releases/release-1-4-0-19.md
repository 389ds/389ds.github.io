---
title: "Releases/1.4.0.19"
---

389 Directory Server 1.4.0.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.19

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30902290>

Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30903702>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30903727>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-84b6b36c4d>

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-e9447b1910>


The new packages and versions are:

- 389-ds-base-1.4.0.19-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.19.tar.bz2)

### Highlights in 1.4.0.19

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.19
- Ticket 50026 - audit logs does not capture the operation where nsslapd-lookthroughlimit is modified
- Ticket 50020 - during MODRDN referential integrity can fail erronously while updating large groups
- Ticket 49999 - Finish up the transfer to React
- Ticket 50004 - lib389 - improve X-ORIGIN schema parsing
- Ticket 50013 - Log warn instead of ERR when aci target does not exist.
- Ticket 49975 - followup for broken prefix deployment
- Ticket 49999 - Add dist-bz2 target for Koji build system
- Ticket 49814 - Add specfile requirements for python3-libselinux
- Ticket 49814 - Add specfile requirements for python3-selinux
- Ticket 49999 - Integrate React structure into cockpit-389-ds
- Ticket 49995 - Fix issue with internal op logging
- Ticket 49997 - RFE: ds-replcheck could validate suffix exists and it's replicated
- Ticket 49985 - memberof may silently fails to update a member
- Ticket 49967 - entry cache corruption after failed MODRDN
- Ticket 49975 - Add missing include file to main.c
- Ticket 49814 - skip standard ports for selinux labelling
- Ticket 49814 - dscreate should set the port selinux labels
- Ticket 49856 - Remove backend option from bak2db
- Ticket 49926 - Fix various issues with replication UI
- Ticket 49975 - SUSE rpmlint issues
- Ticket 49939 - Fix ldapi path in lib389
- Ticket 49978 - Add CLI logging function for UI
- Ticket 49929 - Modifications required for the Test Case Management System
- Ticket 49979 - Fix regression in last commit
- Ticket 49979 - Remove dirsrv tests subpackage
- Ticket 49928 - Fix various small WebUI schema issues
- Ticket 49926 - UI - comment out dev cli patchs
- Ticket 49926 - Add replication functionality to UI



