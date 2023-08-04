---
title: "Releases/2.4.3"
---

389 Directory Server 2.4.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.3

Fedora packages are available on Rawhide (f39)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=104323615>

The new packages and versions are:

- 389-ds-base-2.4.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.4.3.tar.gz)

### Highlights in 2.4.3

- Memory leak fixes
- Paged Result Search performance improvement


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

- Bump version to 2.4.3-1
- Issue 5729 - Memory leak in factory_create_extension (#5814)
- Issue 5870 - ns-slapd crashes at startup if a backend has no suffix (#5871)
- Issue 5876 - CI Test random failure - Import (#5879)
- Issue 5877 - test_basic_ldapagent breaks test_setup_ds_as_non_root* tests
- Issue 5867 - lib389 should use filter for tarfile as recommended by PEP 706 (#5868)
- Issue 5853 - Update Cargo.lock and fix minor warning (#5854)
- Issue 5785 - CLI - arg completion is broken
- Issue 5864 - Server fails to start after reboot because it's unable to access nsslapd-rundir
- Issue 5856 - SyntaxWarning: invalid escape sequence
- Issue 5859 - dbscan fails with AttributeError: 'list' object has no attribute 'extends'
- Issue 3527 - UI - Add nsslapd-haproxy-trusted-ip to server setting (#5839)
- Issue 4551 - Paged search impacts performance (#5838)
- Issue 4758 - Add tests for WebUI
- Issue 4169 - UI - Fix retrochangelog and schema Typeaheads (#5837)
- issue 5833 - dsconf monitor backend fails on lmdb (#5835)
- Issue 3555 - UI - Fix audit issue with npm - stylelint (#5836)

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

