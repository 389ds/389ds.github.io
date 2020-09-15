---
title: "Releases/1.4.1.6"
---

389 Directory Server 1.4.1.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.6

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36349721> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36350813> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-73802bbbc9>


The new packages and versions are:

- 389-ds-base-1.4.1.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.6.tar.bz2)

### Highlights in 1.4.1.6

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

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but it is fully functional.

|Configuration Tab|Finished|Written in ReactJS |
|-----------------|--------|-------------------|
|Server Tab|Yes|No|
|Security Tab|Yes|Yes|
|Database Tab|Yes|Yes|
|Replication Tab|Yes|No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.1.6 
- Issue 50355 - SSL version min and max not correctly applied 
- Issue 50497 - Port cl-dump.pl tool to Python using lib389 
- Issue 48851 - investigate and port TET matching rules filter tests(Final) 
- Issue 50417 - fix regression from previous commit 
- Issue 50425 - Add jemalloc LD_PRELOAD to systemd drop-in file 
- Issue 50325 - Add Security tab to UI 
- Issue 49789 - By default, do not manage unhashed password 
- Issue 49421 - Implement password hash upgrade on bind. 
- Issue 49421 - on bind password upgrade proof of concept 
- Issue 50493 - connection_is_free to trylock 
- Issue 50459 - Correct issue with allocation state 
- Issue 50499 - Fix audit issues and remove jquery from the whitelist 
- Issue 50459 - c_mutex to use pthread_mutex to allow ns sharing 
- Issue 50484 - Add a release build dockerfile and dscontainer improvements 
- Issue 50486 - Update jemalloc to 5.2.0




