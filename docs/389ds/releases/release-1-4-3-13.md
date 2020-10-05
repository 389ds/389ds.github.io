---
title: "Releases/1.4.3.13"
---

389 Directory Server 1.4.3.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.13

Fedora packages are available on Fedora 32.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=52811659> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-f7a1de9dec> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.13.tar.bz2)

### Highlights in 1.4.3.13

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

- Bump version to 1.4.3.13
- Issue 4342 - UI - additional fixes for creation instance modal
- Issue 3996 - Add dsidm rename option (#4338)
- Issue 4258 - Add server version information to UI
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (UI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (CLI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4319 - Performance search rate: listener may be erroneously waken up (#4323)
- Ticket 51190 - SyncRepl plugin provides a wrong cookie
- Ticket 51253 - dscreate should LDAPI to bootstrap the config
- Ticket 51228 - Fix lock/unlock wording and lib389 use of methods
- Ticket 51229 - Server Settings page gets into an unresponsive state
- Ticket 51165 - Set the operation start time for extended ops
- Ticket 51228 - Clean up dsidm user status command
- Ticket 51233 - ds-replcheck crashes in offline mode
- Ticket 50260 - Fix test according to #51222 fix


