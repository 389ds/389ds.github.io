---
title: "Releases/1.4.0.23"
---

389 Directory Server 1.4.0.23
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.23

Fedora packages are available on Fedora 28, and 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35036509>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35036511>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-5283c79c6b>

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-ef4d555898>


The new packages and versions are:

- 389-ds-base-1.4.0.23-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.23.tar.bz2)

### Highlights in 1.4.0.23

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.

To install the Cockput UI plugin use **dnf install cockpit-389-ds**

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab| Finished | Written in ReachJS |
|-----------------|----------|---------|
|Server Tab|Yes|No|
|Security Tab|No||
|Database Tab|Yes|Yes|
|Replication Tab|Yes|No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.23
- Ticket 50041 - Add the rest UI Plugin tabs - Part 2
- Ticket 50340 - 2nd try - structs for diabled plugins will not be freed
- Ticket 50393 - maxlogsperdir accepting negative values
- Ticket 50396 - Crash in PAM plugin when user does not exist
- Ticket 50390 - Add Managed Entries Plug-in Config Entry schema
- Ticket 50251 - clear text passwords visable in CLI verbose mode logging
- Ticket 50378 - ACI's with IPv4 and IPv6 bind rules do not work for IPv6 clients
- Ticket 50370 - CleanAllRUV task crashing during server shutdown
- Ticket 50340 - structs for disabled plugins will not be freed
- Ticket 50363 - ds-replcheck incorrectly reports error out of order multi-valued attributes
- Ticket 50329 - revert fix
- Ticket 50340 - structs for diabled plugins will not be freed
- Ticket 50327 - Add replication conflict support to UI
- Ticket 50327 - Add replication conflict entry support to lib389/CLI
- Ticket 50329 - Possible Security Issue: DOS due to ioblocktimeout not applying to TLS
- Ticket 49990 - Increase the default FD limits
- Ticket 50291 - Add monitor tab functionality to Cockpit UI
- Ticket 50305 - Revise CleanAllRUV task restart process
- Ticket 50303 - Add task creation date to task data
- Ticket 50240 - Improve task logging

