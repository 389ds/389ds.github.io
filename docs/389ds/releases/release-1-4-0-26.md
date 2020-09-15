---
title: "Releases/1.4.0.26"
---

389 Directory Server 1.4.0.26
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.26

Fedora packages are available on Fedora 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36350217>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-6957eea289>


The new packages and versions are:

- 389-ds-base-1.4.0.26-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.26.tar.bz2)

### Highlights in 1.4.0.26

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.

To install the Cockput UI plugin use **dnf install cockpit-389-ds**

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but it is fully functional.

|Configuration Tab| Finished | Written in ReachJS |
|-----------------|----------|---------|
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

- Bump version to 1.4.0.26
- Issue 50499 - Fix audit issues and remove jquery from the whitelist
- Issue 50355 - SSL version min and max not correctly applied
- Issue 50325 - Add Security tab to UI
- Issue 50177 - Add a new CI test case, also added fixes in lib389

