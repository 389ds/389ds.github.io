---
title: "Releases/1.4.3.4"
---

389 Directory Server 1.4.3.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.4

Fedora packages are available on Fedora 32 adn Rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42538967> - Rawhide (Fedora 33)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42538377> - Fedora 32

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-4520326fbb> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.4.tar.bz2)

### Highlights in 1.4.3.4

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

The new UI is complete and fully ported to ReactJS

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.3.4
- Issue 50954 - Port buildnum.pl to python(part 2)
- Issue 50955 - Fix memory leaks in chaining plugin
- Issue 50954 - Port buildnum.pl to python
- Issue 50947 - change 00core.ldif objectClasses for openldap migration
- Issue 50755 - setting nsslapd-db-home-directory is overriding db_directory
- Issue 50937 - Update CLI for new backend split configuration
- Issue 50860 - Port Password Policy test cases from TET to python3 pwp.sh
- Issue 50945 - givenname alias of gn from openldap
- Issue 50935 - systemd override in lib389 for dscontainer
- Issue 50499 - Fix npm audit issues
- Issue 49761 - Fix CI test suite issues
- Issue 50618 - clean compiler warning and log level
- Issue 50889 - fix compiler issues
- Issue 50884 - Health check tool DSEldif check fails
- Issue 50926 - Remove dual spinner and other UI fixes
- Issue 50928 - Unable to create a suffix with countryName
- Issue 50758 - Only Recommend bash-completion, not Require
- Issue 50923 - Fix a test regression
- Issue 50904 - Connect All React Components And Refactor the Main Navigation Tab Code
- Issue 50920 - cl-dump exit code is 0 even if command fails with invalid arguments
- Issue 50923 - Add test - dsctl fails to remove instances with dashes in the name
- Issue 50919 - Backend delete fails using dsconf
- Issue 50872 - dsconf can't create GSSAPI replication agreements
- Issue 50912 - RFE - add password policy attribute pwdReset
- Issue 50914 - No error returned when adding an entry matching filters for a non existing automember group
- Issue 50889 - Extract pem files into a private namespace
- Issue 50909 - nsDS5ReplicaId cant be set to the old value it had before
- Issue 50686 - Port fractional replication test cases from TET to python3 final
- Issue 49845 - Remove pkgconfig check for libasan
- Issue:50860 - Port Password Policy test cases from TET to python3 bug624080
- Issue:50860 - Port Password Policy test cases from TET to python3 series of bugs
- Issue 50786 - connection table freelist
- Issue 50618 - support cgroupv2
- Issue 50900 - Fix cargo offline build
- Issue 50898 - ldclt core dumped when run with -e genldif option


