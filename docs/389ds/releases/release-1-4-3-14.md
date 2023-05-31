---
title: "Releases/1.4.3.14"
---

389 Directory Server 1.4.3.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.14

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=54261773> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-9dddffb6a2> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.14.tar.bz2)

### Highlights in 1.4.3.14

- Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.3.14
- Issue 2526 - revert API change in slapi_be_getsuffix()
- Issue 4372 - BUG - Chaining DB did not validate bind mech parameters (#4374)
- Issue 4334 - RFE - Task timeout may cause larger dataset imports to fail (#4359)
- Issue 4363 - Sync repl: per thread structure was incorrectly initialized (#4395)
- Issue 2526 - suffix management in backends incorrect
- Issue 1199 - Misleading message in access log for idle timeout (#4385)
- Issue 4295 - Fix a closing quote issue (#4386)
- Issue 4389 - errors log with incorrectly formatted message parent_update_on_childchange
- Issue 4297 - On ADD replication URP issue internal searches with filter containing unescaped chars (#4355)
- Issue 4379 - allow more than 1 empty AttributeDescription for ldapsearch, without the risk of denial of service (#4380)
- Issue 4159 - Healthcheck code DSBLE0002 not returned on disabled suffix
- Issue 4265 - UI - Make the secondary plugins read-only (#4364)
- Issue 4361 - RFE - add - dscreate --advanced flag to avoid user confusion
- Issue 4368 - ds-replcheck crashes when processing glue entries
- Issue 4366 - lib389 - Fix account status inactivity checks
- Issue 4360 - password policy max sequence sets is not working as expected


