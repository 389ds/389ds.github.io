---
title: "Releases/1.4.0.5"
---

389 Directory Server 1.4.0.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.5

Fedora packages are available on Fedora 28(rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=24602683>

The new packages and versions are:

-   389-ds-base-1.4.0.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.5.tar.bz2)

### Highlights in 1.4.0.5

- Security and bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.5
- CVE-2017-15134 389-ds-base: Remote DoS via search filters in slapi_filter_sprintf
- Ticket 49554 - Update Makefile for README.md
- Ticket 49554 - update readme
- Ticket 49546 - Fix broken snmp MIB file
- Ticket 49400 - Make CLANG configurable
- Ticket 49530 - Add pseudolocalization option for dbgen
- Ticket 49523 - Fixed skipif marker, topology fixture and log message
- Ticket 49544 - Double check pw prompts
- Ticket 49548 - Cockpit UI - installer should also setup Cockpit


