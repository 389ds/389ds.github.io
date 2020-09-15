---
title: "Releases/1.4.0.7"
---

389 Directory Server 1.4.0.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.7

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26398181>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26398269>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-3c1ec0b939>

The new packages and versions are:

-   389-ds-base-1.4.0.7-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.7.tar.bz2)

### Highlights in 1.4.0.7

- Bug fixes and merging of srvcore package

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.7
- Ticket 49477 - Missing pbkdf python
- Ticket 49552 - Fix the last of the build issues on F28/29
- Ticket 49522 - Fix build issues on F28
- Ticket 49631 - same csn generated twice
- Ticket 49585 - Add py3 support to password test suite : part-3
- Ticket 49585 - Add py3 support to password test suite : part-2
- Ticket 48184 - revert previous patch around unuc-stans shutdown crash
- Ticket 49585 - Add py3 support to password test suite
- Ticket 46918 - Fix compiler warnings on arm
- Ticket 49601 - Replace HAVE_SYSTEMD define with WITH_SYSTEMD in svrcore
- Ticket 49619 - adjustment of csn_generator can fail so next generated csn can be equal to the most recent one received
- Ticket 49608 - Add support for gcc/clang sanitizers
- Ticket 49606 - Improve lib389 documentation
- Ticket 49552 - Fix build issues on F28
- Ticket 49603 - 389-ds-base package rebuilt on EPEL can't be installed due to missing dependencies
- Ticket 49593 - NDN cache stats should be under the global stats
- Ticket 49599 - Revise replication total init status messages
- Ticket 49596 - repl-monitor.pl fails to find db tombstone/RUV entry
- Ticket 49589 - merge svrcore into 389-ds-base
- Ticket 49560 - Add a test case for extract-pemfiles
- Ticket 49239 - Add a test suite for ds-replcheck tool RFE
- Ticket 49369 - merge svrcore into 389-ds-base


