---
title: "Releases/1.4.0.20"
---

389 Directory Server 1.4.0.20
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.20

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=31464161>

Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=31464159>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=31464058>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-0f3d7e9434>

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-cf250e9c09>


The new packages and versions are:

- 389-ds-base-1.4.0.20-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.20.tar.bz2)

### Highlights in 1.4.0.20

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

- Bump version to 1.4.0.20
- Ticket 49994 - Add test for backend/suffix CLI functions
- Ticket 50090 - refactor fetch_attr() to slapi_fetch_attr()
- Ticket 50091 - shadowWarning is not generated if passwordWarning is lower than 86400 seconds (1 day)
- Ticket 50056 - Fix CLI/UI bugs
- Ticket 49864 - Revised replication status messages for transient errors
- Ticket 50071 - Set ports in local_simple_allocate function
- Ticket 50065 - lib389 aci parsing is too strict
- Ticket 50061 - Improve schema loading in UI
- Ticket 50063 - Crash after attempting to restore a single backend
- Ticket 50062 - Replace error by warning in the state machine defined in repl5_inc_run
- Ticket 50041 - Set the React dataflow foundation and add basic plugin UI
- Ticket 50028 - Revise ds-replcheck usage
- Ticket 50057 - Pass argument into hashtable_new
- Ticket 50053 - improve testcase
- Ticket 50053 - Subtree password policy overrides a user-defined password policy
- Ticket 49974 - lib389 - List instances with initconfig_dir instead of sysconf_dir
- Ticket 49984 - Add an empty domain creation to the dscreate
- Ticket 49950 -  PassSync not setting pwdLastSet attribute in Active Directory after Pw update from LDAP sync for normal user
- Ticket 50046 - Remove irrelevant debug-log messages from CLI tools
- Ticket 50022, 50012, 49956, and 49800: Various dsctl/dscreate fixes
- Ticket 49927 - dsctl db2index does not work
- Ticket 49814 - dscreate should handle selinux ports that are in a range
- Ticket 49543 - fix certmap dn comparison
- Ticket 49994 - comment out dev paths
- Ticket 49994 - Add backend features to CLI
- Ticket 48081 - Add new CI tests for password



