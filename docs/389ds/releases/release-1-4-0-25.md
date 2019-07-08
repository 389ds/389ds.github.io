---
title: "Releases/1.4.0.25"
---

389 Directory Server 1.4.0.25
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.25

Fedora packages are available on Fedora 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36138415>

Bodhi

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2019-1bfca53248>


The new packages and versions are:

- 389-ds-base-1.4.0.25-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.25.tar.bz2)

### Highlights in 1.4.0.25

Bug fix

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
|Security Tab|No (coming soon)|No|
|Database Tab|Yes|Yes|
|Replication Tab|Yes|No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.25
- Issue 50431 - Fix regression from coverity fix (memberOf plugin crash)

