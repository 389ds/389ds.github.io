---
title: "Releases/1.4.0.30"
---

389 Directory Server 1.4.0.30
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.30

Fedora packages are available on Fedora 29


Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38715661>

Bodhi

F29 <>


The new packages and versions are:

- 389-ds-base-1.4.0.29-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.29.tar.bz2)

### Highlights in 1.4.0.29

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is fully functional!  There are still parts that need to be converted to ReactJS, but everything works.

|Configuration Tab| Functional | Written in ReachJS |
|-----------------|------------|--------------------|
|Server Tab       |Yes         |No                  |
|Security Tab     |Yes         |Yes                 |
|Database Tab     |Yes         |Yes                 |
|Replication Tab  |Yes         |Yes                 |
|Schema Tab       |Yes         |No                  |
|Plugin Tab       |Yes         |Yes                 |
|Monitor Tab      |Yes         |Yes                 |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.30
- Fix cherry-pick error in lib389
- Bump version to 1.4.0.29
- Issue 50592 - Port Replication Tab to ReactJS
- Issue 50067 - Fix krb5 dependency in a specfile
- Issue 50545 - Port repl-monitor.pl to lib389 CLI
- Issue 50497 - Port cl-dump.pl tool to Python using lib389
- Issue 49850 - cont -fix crash in ldbm_non_leaf
- Issue 50634 - Clean up CLI errors output - Fix wrong exception
- Issue 50634 - Clean up CLI errors output
- Issue 49850 - ldbm_get_nonleaf_ids() slow for databases with many non-leaf entries
- Issue 50655 - access log etime is not properly formatted
- Issue 50653 - objectclass parsing fails to log error message text
- Issue 50646 - Improve task handling during shutdowns
- Issue 50622 - ds_selinux_enabled may crash on suse

