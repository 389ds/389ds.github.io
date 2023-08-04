---
title: "Releases/2.2.9"
---

389 Directory Server 2.2.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.9

Fedora packages are available on Fedora 37

<https://koji.fedoraproject.org/koji/taskinfo?taskID=104325801>

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-0594ef094f> - Bohdi


The new packages and versions are:

- 389-ds-base-2.2.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.9.tar.gz)

### Highlights in 2.2.9

- Memory leak fixes
- Paged Result Search & Managed Role performance improvements
- Enhancement - Provide a history for LastLoginTime

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
- Bump version to 2.2.9
- Issue 5729 - Memory leak in factory_create_extension (#5814)
- Issue 5877 - test_basic_ldapagent breaks test_setup_ds_as_non_root* tests
- Issue 5853 - Update Cargo.lock and fix minor warning (#5854)
- Issue 5867 - lib389 should use filter for tarfile as recommended by PEP 706 (#5868)
- Issue 5864 - Server fails to start after reboot because it's unable to access nsslapd-rundir
- Issue 5856 - SyntaxWarning: invalid escape sequence
- Issue 5859 - dbscan fails with AttributeError: 'list' object has no attribute 'extends'
- Issue 4551 - Paged search impacts performance (#5838)
- Issue 4169 - UI - Fix retrochangelog and schema Typeaheads (#5837)
- issue 5833 - dsconf monitor backend fails on lmdb (#5835)
- Issue 3555 - UI - Fix audit issue with npm - semver and word-wrap
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5807)
- Issue 5793 - UI - fix suffix selection in export modal
- Issue 5825 - healthcheck - password storage scheme warning needs more info
- Issue 5822 - Allow empty export path for db2ldif
- Issue 5755 - Massive memory leaking on update operations (#5824)
- Issue 5551 - Almost empty and not loaded ns-slapd high cpu load
- Issue 5722 - RFE When a filter contains 'nsrole', improve response time by rewriting the filter (#5723)
- Issue 5755 - The Massive memory leaking on update operations (#5803)
- Issue 5752 - CI - Add more tests for lastLoginHistorySize RFE (#5802)
- Issue 2375 - CLI - Healthcheck - revise and add new checks
- Issue 5781 - Bug handling return code of pre-extended operation plugin.
- Issue 5646 - Various memory leaks (#5725)
- Issue 5789 - Improve ds-replcheck error handling
- Issue 5642 - Build fails against setuptools 67.0.0
- Issue 5778 - UI - Remove error message if .dsrc is missing
- Issue 5751 - Cleanallruv task crashes on consumer (#5775)
- Issue 5743 - Disabling replica crashes the server (#5746)

- Bump version to 2.2.8
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5753)
- Issue 5770 - RFE - Extend Password Adminstrators to allow skipping password info updates
- Issue 5768 - CLI/UI - cert checks are too strict, and other issues
- Issue 5765 - Improve installer selinux handling
- Issue 5643 - Memory leak in entryrdn during delete (#5717)
- Issue 152  - RFE - Add support for LDAP alias entries
- Issue 5052 - BUG - Custom filters prevented entry deletion (#5060)
- Issue 5704 - crash in sync_refresh_initial_content (#5720)
- Issue 5738 - RFE - UI - Read/write replication monitor info to .dsrc file
- Issue 5749 - RFE - Allow Account Policy Plugin to handle inactivity and expiration at the same time

