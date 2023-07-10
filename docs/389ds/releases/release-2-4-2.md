---
title: "Releases/2.4.2"
---

389 Directory Server 2.4.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.2

Fedora packages are available on Rawhide (f39)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=103182381>

The new packages and versions are:

- 389-ds-base-2.4.2-2

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.4.2.tar.gz)

### Highlights in 2.4.2

- HA Proxy Support 
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
- Bump version to 2.4.2
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5807)
- Issue 4719 - CI - Add dsconf add a PTA URL test
- Issue 5793 - UI - fix suffix selection in export modal
- Issue 5793 - UI - Fix minor crashes (#5827)
- Issue 5825 - healthcheck - password storage scheme warning needs more info
- Issue 5822 - Allow empty export path for db2ldif
- Issue 5755 - Massive memory leaking on update operations (#5824)
- Issue 5701 - CI - Add more tests for referral mode fix (#5810)
- Issue 5551 - Almost empty and not loaded ns-slapd high cpu load
- Issue 5755 - The Massive memory leaking on update operations (#5803)
- Issue 2375 - CLI - Healthcheck - revise and add new checks
- Bump openssl from 0.10.52 to 0.10.55 in /src
- Issue 5793 - UI - move from webpack to esbuild bundler
- Issue 5752 - CI - Add more tests for lastLoginHistorySize RFE (#5802)
- Issue 3527 - Fix HAProxy x390x compatibility and compiler warnings (#5801)
- Issue 5798 - CLI - Add multi-valued support to dsconf config (#5799)
- Issue 5781 - Bug handling return code of pre-extended operation plugin.
- Issue 5785 - move bash completion to post section of specfile
- Issue 5156 - (cont) RFE slapi_memberof reusing memberof values (#5744)
- Issue 4758 - Add tests for WebUI
- Issue 3527 - Add PROXY protocol support (#5762)
- Issue 5789 - Improve ds-replcheck error handling
- Issue 5786 - CLI - registers tools for bash completion
- Issue 5786 - Set minimal permissions on GitHub Workflows (#5787)
- Issue 5646 - Various memory leaks (#5725)
- Issue 5778 - UI - Remove error message if .dsrc is missing
- Issue 5751 - Cleanallruv task crashes on consumer (#5775)

- Bump version to 2.4.1
- Issue 5770 - RFE - Extend Password Adminstrators to allow skipping password info updates
- Issue 5768 - CLI/UI - cert checks are too strict, and other issues
- Issue 5722 - fix compilation warnings (#5771)
- Issue 5765 - Improve installer selinux handling
- Issue 152  - RFE - Add support for LDAP alias entries
- Issue 5052 - BUG - Custom filters prevented entry deletion (#5060)
- Issue 5752 - RFE - Provide a history for LastLoginTime (#5753)
- Issue 5722 - RFE When a filter contains 'nsrole', improve response time by rewriting the filter (#5723)
- Issue 5704 - crash in sync_refresh_initial_content (#5720)
- Issue 5738 - RFE - UI - Read/write replication monitor info to .dsrc file
- Issue 5156 - build warnings (#5758)
- Issue 5749 - RFE - Allow Account Policy Plugin to handle inactivity and expiration at the same time
- Issue 5743 - Disabling replica crashes the server (#5746)
- Issue 2562 - Copy config files into backup directory
- Issue 5156 - fix build breakage from slapi-memberof commit
- Issue 4758 - Add tests for WebUI

