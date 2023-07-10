---
title: "Releases/2.3.5"
---

389 Directory Server 2.3.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.3.5

Fedora packages are available on Fedora f38

Fedora 38:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=103184033>

Bodhi:

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-c92be0dfa0>

The new packages and versions are:

- 389-ds-base-2.3.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.3.5.tar.gz)

### Highlights in 2.3.5

- Managed Role performance improvement
- Memory leak fixes

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
- Bump version to 2.3.5
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5807)
- Issue 5793 - UI - fix suffix selection in export modal
- Issue 5793 - UI - Fix minor crashes (#5827)
- Issue 5825 - healthcheck - password storage scheme warning needs more info
- Issue 5822 - Allow empty export path for db2ldif
- Issue 5755 - Massive memory leaking on update operations (#5824)
- Issue 5551 - Almost empty and not loaded ns-slapd high cpu load
- Issue 5156 - RFE that implement slapi_memberof (#5694)
- Issue 5722 - RFE When a filter contains 'nsrole', improve response time by rewriting the filter (#5723)
- Issue 5755 - The Massive memory leaking on update operations (#5803)
- Issue 5752 - CI - Add more tests for lastLoginHistorySize RFE (#5802)
- Issue 2375 - CLI - Healthcheck - revise and add new checks
- Issue 5793 - UI - move from webpack to esbuild bundler
- Issue 5781 - Bug handling return code of pre-extended operation plugin.
- Issue 5785 - move bash completion to post section of specfile
- Issue 5646 - Various memory leaks (#5725)
- Issue 5789 - Improve ds-replcheck error handling
- Issue 5786 - CLI - registers tools for bash completion
- Issue 5778 - UI - Remove error message if .dsrc is missing
- Issue 4758 - Add tests for WebUI
- Issue 5751 - Cleanallruv task crashes on consumer (#5775)
- Issue 5743 - Disabling replica crashes the server (#5746)

- Bump version to 2.3.4
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5753)
- Issue 5770 - RFE - Extend Password Administrators to allow skipping password info updates
- Issue 5768 - CLI/UI - cert checks are too strict, and other issues
- Issue 5765 - Improve installer selinux handling
- Issue 5643 - Memory leak in entryrdn during delete (#5717)
- Issue 152  - RFE - Add support for LDAP alias entries
- Issue 5052 - BUG - Custom filters prevented entry deletion (#5060)
- Issue 5704 - crash in sync_refresh_initial_content (#5720)
- Issue 5738 - RFE - UI - Read/write replication monitor info to .dsrc file
- Issue 5749 - RFE - Allow Account Policy Plugin to handle inactivity and expiration at the same time
- Issue 2562 - Copy config files into backup directory


