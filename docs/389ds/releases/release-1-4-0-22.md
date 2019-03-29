---
title: "Releases/1.4.0.22"
---

389 Directory Server 1.4.0.22
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.22

Fedora packages are available on Fedora 28, and 29


Fedora 29

<http://koji.fedoraproject.org/koji/buildinfo?buildID=1240342>

Fedora 28

<http://koji.fedoraproject.org/koji/buildinfo?buildID=1240341>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-35ca2e35b3>

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-351b02e21e>


The new packages and versions are:

- 389-ds-base-1.4.0.22-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.22.tar.bz2)

### Highlights in 1.4.0.22

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  To install the Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab| Finished | Demo Mode | Written in ReachJS |
|-----------------|----------|-----------|---------|
|Server Tab|Yes||No|
|Security Tab||X||
|Database Tab|Yes||Yes|
|Replication Tab|Yes||No|
|Schema Tab|Yes||No|
|Plugin Tab|Yes||Yes|
|Monitor Tab||X||

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.22
- Ticket 50308 - Revise memory leak fix
- Ticket 50308 - Fix memory leaks for repeat binds and replication
- Ticket 49873 - (cont 3rd) cleanup debug log
- Ticket 49873 - (cont 2nd) Contention on virtual attribute lookup
- Ticket 50292 - Fix Plugin CLI and UI issues
- Ticket 50289 - Fix various database UI issues
- Ticket 50300 - Fix memory leak in automember plugin
- Ticket 50265 - the warning about skew time could last forever
- Ticket 50260 - Invalid cache flushing improvements
- Ticket 49561 - MEP plugin, upon direct op failure, will delete twice the same managed entry
- Ticket 50077 - Do not automatically turn automember postop modifies on
- Ticket 50282 - OPERATIONS ERROR when trying to delete a group with automember members
- Ticket 49873 - (cont) Contention on virtual attribute lookup
- Ticket 50260 - backend txn plugins can corrupt entry cache
- Ticket 50041 - Add CLI functionality for special plugins
- Ticket 50273 - reduce default replicaton agmt timeout
- Ticket 50234 - one level search returns not matching entry
- Ticket 50232 - export creates not importable ldif file
- Ticket 50215 - UI - implement Database Tab in reachJS
- Ticket 50238 - Failed modrdn can corrupt entry cache
- Ticket 50236 - memberOf should be more robust
- Ticket 50151 - lib389 support cli add/replace/delete on objects
- Ticket 50155 - password history check has no way to just check the current password
- Ticket 49873 - Contention on virtual attribute lookup
- Ticket 49658 - In replicated topology a single-valued attribute can diverge
- Ticket 50177 - import task should not be deleted too rapidely after import finishes to be able to query the status
- Ticket 50165 - Fix issues with dscreate

