---
title: "Releases/1.4.1.2"
---

389 Directory Server 1.4.1.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.2

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=33820830> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=33820510> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-caf75e133e>


The new packages and versions are:

-   389-ds-base-1.4.1.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.2.tar.bz2)

### Highlights in 1.4.1.2

- Version change

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, to install the UI Cockpit plugin use **dnf install cockpit-389-ds**  After install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab|Finished|Written in ReachJS |
|-----------------|--------|-------------------|
|Server Tab|Yes|No|
|Security Tab|No||
|Database Tab|Yes|Yes|
|Replication Tab|Yes||No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|No||


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.1.2-1
- Ticket 50308 - Revise memory leak fix
- Ticket 50308 - Fix memory leaks for repeat binds and replication
- Ticket 40067 - Use PKG_CHECK_MODULES to detect libraries
- Ticket 49873 - (cont 3rd) cleanup debug log
- Ticket 49873 - (cont 2nd) Contention on virtual attribute lookup
- Ticket 50292 - Fix Plugin CLI and UI issues
- Ticket 50112 - Port ACI test suit from TET to python3(misc and syntax)
- Ticket 50289 - Fix various database UI issues
- Ticket 49463 - After cleanALLruv, replication is looping on keep alive DEL
- Ticket 50300 - Fix memory leak in automember plugin
- Ticket 50265 - the warning about skew time could last forever
- Ticket 50260 - Invalid cache flushing improvements
- Ticket 49561 - MEP plugin, upon direct op failure, will delete twice the same managed entry
- Ticket 50077 - Do not automatically turn automember postop modifies on
- Ticket 50282 - OPERATIONS ERROR when trying to delete a group with automember members
- Ticket 49715 - extend account functionality
- Ticket 49873 - (cont) Contention on virtual attribute lookup
- Ticket 50260 - backend txn plugins can corrupt entry cache
- Ticket 50255 - Port password policy test to use DSLdapObject
- Ticket 49667 - 49668 - remove old spec files
- Ticket 50276 - 389-ds-console is not built on RHEL8 if cockpit_dist is already present
- Ticket 50112 - Port ACI test suit from TET to python3(Search)
- Ticket 50259 - implement dn construction test
- Ticket 50273 - reduce default replicaton agmt timeout
- Ticket 50208 - lib389- Fix issue with list all instances
- Ticket 50112 - Port ACI test suit from TET to python3(Global Group)
- Ticket 50041 - Add CLI functionality for special plugins
- Ticket 50263 - LDAPS port not listening after installation
- Ticket 49575 - Indicate autosize value errors and corrective actions
- Ticket 50137 - create should not check in non-stateful mode for exist
- Ticket 49655 - remove doap file
- Ticket 50197 - Fix dscreate regression
- Ticket 50234 - one level search returns not matching entry
- Ticket 50257 - lib389 - password policy user vs subtree checks are broken
- Ticket 50253 - Making an nsManagedRoleDefinition type in src/lib389/lib389/idm/nsrole.py
- Ticket 49029 - [RFE] improve internal operations logging
- Ticket 50230 - improve ioerror msg when not root/dirsrv
- Ticket 50246 - Fix the regression in old control tools
- Ticket 50197 - Container integration part 2
- Ticket 50197 - Container init tools
- Ticket 50232 - export creates not importable ldif file
- Ticket 50215 - UI - implement Database Tab in reachJS
- Ticket 50243 - refint modrdn stress test
- Ticket 50238 - Failed modrdn can corrupt entry cache
- Ticket 50236 - memberOf should be more robust
- Ticket 50213 - fix list instance issue
- Ticket 50219 - Add generic filter to DSLdapObjects
- Ticket 50227 - Making an cosClassicDefinition type in src/lib389/lib389/cos.py
- Ticket 50112 - Port ACI test suit from TET to python3(modify)
- Ticket 50224 - warnings on deprecated API usage
- Ticket 50112 - Port ACI test suit from TET to python3(valueaci)
- Ticket 50112 - Port ACI test suit from TET to python3(Aci Atter)
- Ticket 50208 - make instances mark off based on dse.ldif not sysconfig
- Ticket 50170 - composable object types for nsRole in lib389
- Ticket 50199 - disable perl by default
- Ticket 50211 - Making an actual Anonymous type in lib389/idm/account.py
- Ticket 50155 - password history check has no way to just check the current password
- Ticket 49873 - Contention on virtual attribute lookup
- Ticket 50197 - Container integration improvements
- Ticket 50195 - improve selinux error messages in interactive
- Ticket 49658 - In replicated topology a single-valued attribute can diverge
- Ticket 50111 - Use pkg-config to detect icu
- Ticket 50165 - Fix issues with dscreate
- Ticket 50177 - import task should not be deleted too rapidely after import finishes to be able to query the status
- Ticket 50140 - Use high ports in container installs
- Ticket 50184 - Add cli tool parity to dsconf/dsctl
- Ticket 50159 - sssd and config display



