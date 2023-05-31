---
title: "Releases/1.4.3.16"
---

389 Directory Server 1.4.3.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.16

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=55552447> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-3a8c3e12be> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.16.tar.gz)

### Highlights in 1.4.3.16

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

- Bump version to 1.4.3.16
- Issue 4432 - After a failed online import the next imports are very slow
- Issue 4281 - dsidm user status fails with Error: 'nsUserAccount' object has no attribute 'is_locked'
- Issue 4429 - NULL dereference in revert_cache()
- Issue 4391 - DSE config modify does not call be_postop (#4394)
- Issue 4329 - Sync repl - if a serie of updates target the same entry then the cookie get wrong changenumber (#4356)
- Issue 4412 - Fix CLI repl-agmt requirement for parameters (#4422)
- Issue 4415 - unable to query schema if there are extra parenthesis
- Issue 4350 - One line, fix invalid type error in tls_cacertdir check (#4358)
- Issue 4350 - dsrc should warn when tls_cacertdir is invalid (#4353)
- Issue 4351 - improve generated sssd.conf output (#4354)



