---
title: "Releases/2.3.7"
---

389 Directory Server 2.3.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.3.7

Fedora packages are available on Fedora f38

Fedora 38:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=104579000>

Bodhi:

<https://bodhi.fedoraproject.org/updates/FEDORA-2023-0680e2e886>

The new packages and versions are:

- 389-ds-base-2.3.7-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.3.7.tar.gz)

### Highlights in 2.3.7

- Alarming messages logged by account policy plugin
- Server may crash at startup

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
- bump version to 2.3.7
- Issue 4551 - Part 2 - Fix build warning of previous PR (#5888)
- Issue 5834 - AccountPolicyPlugin erroring for some users (#5866)
- Issue 5872 - part 2 - fix is_dbi regression (#5887)
- Issue 5848 - dsconf should prevent setting the replicaID for hub and consumer roles (#5849)
- Issue 5870 - ns-slapd crashes at startup if a backend has no suffix (#5871)
- Issue 5883 - Remove connection mutex contention risk on autobind (#5886)
- Issue 5872 - `dbscan()` in lib389 can return bytes

- Bump version to 2.3.6
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
- Issue 3555 - UI - Fix audit issue with npm - stylelint (#5836)

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

