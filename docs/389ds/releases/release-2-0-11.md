---
title: "Releases/2.0.11"
---

389 Directory Server 2.0.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.11

Fedora packages are available on Fedora 34 and Rawhide

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=79178995> - Koji

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=79181056> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-dcccb24c55> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=79181078> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-fd5fe50a28> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.11.tar.gz)

### Highlights in 2.0.11

- Bug fixes
- Cockpit UI - LDAP editor (database editor) has been started, but it is far from complete.  Please do not file any issues against it as it's a WIP.

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 2.0.11
- Issue 4962 - Fix various UI bugs - Settings and Monitor (#5016)
- Issue 5014 - UI - Add group creation to LDAP editor
- Issue 5006 - UI - LDAP editor tree not being properly updated
- Issue 5001 - Update CI test for new availableSASLMechs attribute
- Issue 4959 - Invalid /etc/hosts setup can cause isLocalHost to fail.
- Issue 5001 - Fix next round of UI bugs:
- Issue 4962 - Fix various UI bugs - dsctl and ciphers (#5000)
- Issue 4978 - use more portable python command for checking containers
- Issue 4678 - RFE automatique disable of virtual attribute checking (#4918)
- Issue 4972 - gecos with IA5 introduces a compatibility issue with previous (#4981)
- Issue 4978 - make installer robust
- Issue 4976 - Failure in suites/import/import_test.py::test_fast_slow_import
- Issue 4973 - update snmp to use /run/dirsrv for PID file
- Issue 4962 - Fix various UI bugs - Plugins (#4969)
- Issue 4973 - installer changes permissions on /run
- Issue 4092 - systemd-tmpfiles warnings
- Issue 4956 - Automember allows invalid regex, and does not log proper error
- Issue 4731 - Promoting/demoting a replica can crash the server
- Issue 4962 - Fix various UI bugs part 1
- Issue 3584 - Fix PBKDF2_SHA256 hashing in FIPS mode (#4949)
- Issue 4943 - Fix csn generator to limit time skew drift (#4946)
- Issue 2790 - Set db home directory by default
- Issue 4299 - Merge LDAP editor code into Cockpit UI
- Issue 4938 - max_failure_count can be reached in dscontainer on slow machine with missing debug exception trace
- Issue 4921 - logconv.pl -j: Use of uninitialized value (#4922)
- Issue 4847 - BUG - potential deadlock in replica (#4936)
- Issue 4513 - fix ACI CI tests involving ip/hostname rules
- Issue 4925 - Performance ACI: targetfilter evaluation result can be reused (#4926)
- Issue 4916 - Memory leak in ldap-agent



