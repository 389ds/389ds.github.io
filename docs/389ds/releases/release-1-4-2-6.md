---
title: "Releases/1.4.2.6"
---

389 Directory Server 1.4.2.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.6

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=40494075> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-5f27470985>

The new packages and versions are:

- 389-ds-base-1.4.2.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.6.tar.bz2)

### Highlights in 1.4.2.6

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

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but every feature is available.

|Configuration Tab  |Functional  |Written in ReactJS |
|-------------------|------------|-------------------|
|Server Tab         |Yes         |No                 |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |No (coming soon)   |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.6
- Issue 50798 - incorrect bytes in format string
- Issue 50545 - Add the new replication monitor functionality to UI
- Issue 50806 - Fix minor issues in lib389 health checks
- Issue 50754 - Add Restore Change Log option to CLI
- Issue 50727 - change syntax validate by default in 1.4.2
- Issue 50667 - dsctl -l did not respect PREFIX
- Issue 50780 - More CLI fixes
- Issue 50780 - Fix UI issues
- Issue 50727 - correct mistaken options in filter validation patch
- Issue 50779 - lib389 - conflict compare fails for DN's with spaces
- Issue 49761 - Fix CI test suite issues
- Issue 50499 - Fix npm audit issues
- Issue 50774 - Account.enroll_certificate() should not check for DS version
- Issue 50771 - 1.4.2.5 doesn't compile due to error ModuleNotFoundError: No module named 'pkg_resources.extern'
- Issue 50758 - Need to enable CLI arg completion
- Issue 50710 `Ticket 50709: Several memory leaks reported by Valgrind for 389-ds 1.3.9.1-10`
- Issue 50709 - Several memory leaks reported by Valgrind for 389-ds 1.3.9.1-10
- Issue 50690 - Port Password Storage test cases from TET to python3(create required types in password_plugins)
- Issue 48851 - Investigate and port TET matching rules filter tests(last test cases for match index)
- Issue 50761 - Parametrized tests are missing ':parametrized' value


