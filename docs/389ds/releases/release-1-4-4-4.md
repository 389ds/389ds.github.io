---
title: "Releases/1.4.4.4"
---

389 Directory Server 1.4.4.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.4

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46829414>

The new packages and versions are:

- 389-ds-base-1.4.4.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.4.tar.bz2)

### Highlights in 1.4.4.4

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

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.4.4
- Issue 51175 - resolve plugin name leaking
- Issue 51187 - UI - stop importing Cockpit's PF css
- Issue 51192 - Add option to reject internal unindexed searches
- Issue 50840 - Fix test docstrings metadata-1
- Issue 50840 - Fix test docstrings metadata
- Issue 50980 - fix foo_filter_rewrite
- Issue 51165 - add more logconv stats for the new access log keywords
- Issue 50928 - Unable to create a suffix with countryName either via dscreate or the admin console
- Issue 51188 - db2ldif crashes when LDIF file can't be accessed
- Issue 50545 - Port remaining legacy tools to new python CLI
- Issue 51165 - add new access log keywords for wtime and optime
- Issue 49761 - Fix CI test suite issues ( Port remaning acceptance test suit part 1)
- Issue 51070 - Port Import TET module to python3 part2
- Issue 51142 - Port manage Entry TET suit to python 3 part 1
- Issue 50860 - Port Password Policy test cases from TET to python3 final
- Issue 50696 - Fix Allowed and Denied Ciphers lists - WebUI
- Issue 51169 - UI - attr uniqueness - selecting empty subtree crashes cockpit
- Issue 49256 - log warning when thread number is very different from autotuned value
- Issue 51157 - Reindex task may create abandoned index file
- Issue 50873 - Fix issues with healthcheck tool
- Issue 50860 - Port Password Policy test cases from TET to python3 part2
- Issue 51166 - Log an error when a search is fully unindexed
- Issue 50544 - OpenLDAP syncrepl compatability
- Issue 51161 - fix SLE15.2 install issps
- Issue 49999 - rpm.mk build-cockpit should clean cockpit_dist first
- Issue 51144 - dsctl fails with instance names that contain slapd-
- Issue 51155 - Fix OID for sambaConfig objectclass
- Issue 51159 - dsidm ou delete fails
- Issue 50984 - Memory leaks in disk monitoring
- Issue 51131 - improve mutex alloc in conntable
- Issue 49761 - Fix CI tests
- Issue 49859 - A distinguished value can be missing in an entry
- Issue 50791 - Healthcheck should look for notes=A/F in access log
- Issue 51072 - Set the default minimum worker threads
- Issue 51140 - missing ifdef
- Issue 50912 - pwdReset can be modified by a user
- Issue 50781 - Make building cockpit plugin optional
- Issue 51100 - Correct numSubordinates value for cn=monitor
- Issue 51136 - dsctl and dsidm do not errors correctly when using JSON
- Issue 137 - fix compiler warning
- Issue 50781 - Make building cockpit plugin optional
- Issue 51132 - Winsync setting winSyncWindowsFilter not working as expected
- Issue 51034 - labeledURIObject
- Issue 50545 - Port remaining legacy tools to new python CLI
- Issue 50889 - Extract pem files into a private namespace
- Issue 137 - Implement EntryUUID plugin
- Issue 51072 - improve autotune defaults
- Issue 51115 - enable samba3.ldif by default
- Issue 51118 - UI - improve modal validation when creating an instance
- Issue 50746 - Add option to healthcheck to list all the lint reports


