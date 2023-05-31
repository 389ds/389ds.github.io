---
title: "Releases/1.4.4.6"
---

389 Directory Server 1.4.4.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.6

Fedora packages are available on Fedora 33 and Rawhide (Fedora 34).

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=54270607> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-a998e68006> - Bohdi

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46829414>



The new packages and versions are:

- 389-ds-base-1.4.4.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.6.tar.bz2)

### Highlights in 1.4.4.6

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

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.4.6
- Issue 4262 - Remove legacy tools subpackage (final cleanup)
- Issue 4262 - Remove legacy tools subpackage (restart instances after rpm install)
- Issue 4262 - Remove legacy tools subpackage
- Issue 2526 - revert API change in slapi_be_getsuffix()
- Issue 4363 - Sync repl: per thread structure was incorrectly initialized (#4395)
- Issue 4392 - Update create_test.py
- Issue 2820 - Fix CI tests (#4365)
- Issue 2526 - suffix management in backends incorrect
- Issue 4389 - errors log with incorrectly formatted message parent_update_on_childchange
- Issue 4295 - Fix a closing quote issue (#4386)
- Issue 1199 - Misleading message in access log for idle timeout (#4385)
- Issue 3600 - RFE - openldap migration tooling (#4318)
- Issue 4176 - import ldif2cl task should not close all changelogs
- Issue 4159 - Healthcheck code DSBLE0002 not returned on disabled suffix
- Issue 4379 - allow more than 1 empty AttributeDescription for ldapsearch, without the risk of denial of service (#4380)
- Issue 4329 - Sync repl - if a serie of updates target the same entry then the cookie get wrong changenumber (#4356)
- Issue 3555 - Fix npm audit issues (#4370)
- Issue 4372 - BUG - Chaining DB did not validate bind mech parameters (#4374)
- Issue 4334 - RFE - Task timeout may cause larger dataset imports to fail (#4359)
- Issue 4361 - RFE - add - dscreate --advanced flag to avoid user confusion
- Issue 4368 - ds-replcheck crashes when processing glue entries
- Issue 4366 - lib389 - Fix account status inactivity checks
- Issue 4265 - UI - Make the secondary plugins read-only (#4364)
- Issue 4360 - password policy max sequence sets is not working as expected
- Issue 4348 - Add tests for dsidm
- Issue 4350 - One line, fix invalid type error in tls_cacertdir check (#4358)


