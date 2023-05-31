---
title: "Releases/1.4.3.5"
---

389 Directory Server 1.4.3.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.5

Fedora packages are available on Fedora 32 adn Rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42950158> - Rawhide (Fedora 33)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42950471> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-4b99fc12da> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.5.tar.bz2)

### Highlights in 1.4.3.5

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.3.5
- Issue 50994 - Fix latest UI bugs found by QE
- Issue 50933 - rfc2307compat.ldif
- Issue 50337 - Replace exec() with setattr()
- Issue 50984 - Memory leaks in disk monitoring
- Issue 50984 - Memory leaks in disk monitoring
- Issue 49731 - dscreate fails in silent mode because of db_home_dir
- Issue 50975 - Revise UI branding with new minimized build
- Issue 49437 - Fix memory leak with indirect COS
- Issue 49731 - Do not add db_home_dir to template-dse.ldif
- Issue 49731 - set and use db_home_directory by default
- Issue 50971 - fix BSD_SOURCE
- Issue 50744 - -n option of dbverify does not work
- Issue 50952 - SSCA lacks basicConstraint:CA
- Issue 50976 - Clean up Web UI source directory from unused files
- Issue 50955 - Fix memory leaks in chaining plugin(part 2)
- Issue 50966 - UI - Database indexes not using typeAhead correctly
- Issue 50974 - UI - wrong title in "Delete Suffix" popup
- Issue 50972 - Fix cockpit plugin build
- Issue 49761 - Fix CI test suite issues
- Issue 50971 - Support building on FreeBSD.
- Issue 50960 - RFE Advance options in RHDS Disk Monitoring Framework
- Issue 50800 - wildcards in rootdn-allow-ip attribute are not accepted
- Issue 50963 - We should bundle *.min.js files of Console
- Issue 50860 - Port Password Policy test cases from TET to python3 Password grace limit section.
- Issue 50860 - Port Password Policy test cases from TET to python3 series of bugs Port final
- Issue 50954 - buildnum.py - fix date formatting issue


