---
title: "Releases/1.4.1.8"
---

389 Directory Server 1.4.1.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.8

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=37877213> - Fedora 31

<https://koji.fedoraproject.org/koji/taskinfo?taskID=37877234> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-656e22bd16> - Fedora 31

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-ab85eef8cc> - Fedora 30

The new packages and versions are:

- 389-ds-base-1.4.1.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.8.tar.bz2)

### Highlights in 1.4.1.8

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

|Configuration Tab|Functional|Written in ReactJS |
|-----------------|----------|-------------------|
|Server Tab       |Yes       |No                 |
|Security Tab     |Yes       |Yes                |
|Database Tab     |Yes       |Yes                |
|Replication Tab  |Yes       |No (coming soon!)  |
|Schema Tab       |Yes       |No                 |
|Plugin Tab       |Yes       |Yes                |
|Monitor Tab      |Yes       |Yes                |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.1.8
- Issue 50545 - Port repl-monitor.pl to lib389 CLI
- Issue 50620 - Fix regressions from 50506 (slapi_enry_attr_get_ref)

- Bump version to 1.4.1.7
- Issue 50581 - ns-slapd crashes during ldapi search
- Issue 50604 - Fix UI validation
- Issue 50593 - Investigate URP handling on standalone instance
- Issue 50506 - Fix regression for relication stripattrs
- Issue 50546 - fix more UI issues(part 2)
- Issue 50546 - fix more UI issues
- Issue 50546 - Fix various issues in UI
- Issue 50576 - Same proc uid/gid maps to rootdn for ldapi sasl
- Issue 50567, 50568 - strict host check disable and display container version
- Issue 50550 - DS installer debug messages leaking to ipa-server-install
- Issue 50545 - Port fixup-memberuid and add the functionality to CLI and UI
- Issue 50572 - After running cl-dump dbdir/cldb/*ldif.done are not deleted
- Issue 50578 - Add SKIP_AUDIT_CI flag for Cockpit builds
- Issue 50349 - filter schema validation
- Issue 48055 - CI test-(Plugin configuration should throw proper error messages if not configured properly)
- Issue 49324 - idl_new fix assert
- Issue 50564 - Fix rust libraries by default and improve docker
- Issue 50206 - Refactor lock, unlock and status of dsidm account/role
- Issue 49324 - idl_new report index name in error conditions
- Issue 49761 - Fix CI test suite issues
- Issue 50506 - Fix regression from slapi_entry_attr_get_ref refactor
- Issue 50499 - Audit fix - Update npm 'eslint-utils' version
- Issue 49624 - modrdn silently fails if DB deadlock occurs
- Issue 50542 - fix crash in filter tests
- Issue 49761 - Fix CI test suite issues
- Issue 50542 - Entry cache contention during base search
- Issue 50462 - Fix CI tests
- Issue 50490 - objects and memory leaks
- Issue 50538 - Move CI test to individual file
- Issue 50538 - cleanAllRUV task limit is not enforced for replicated tasks
- Issue 50536 - Audit log heading written to log after every update
- Issue 50525 - nsslapd-defaultnamingcontext does not change when the assigned suffix gets deleted
- Issue 50534 - CLI change schema edit subcommand to replace
- Issue 50506 - cont Fix invalid frees from pointer reference calls
- Issue 50507 - Fix Cockpit UI styling for PF4
- Issue 48851 - investigate and port TET matching rules filter tests(indexing final)
- Issue 48851 - Add more test cases to the match test suite(mode replace)
- Issue 50530 - Directory Server not RFC 4511 compliant with requested attr "1.1"
- Issue 50529 - LDAP server returning PWP controls in different sequence
- Issue 50506 - Fix invalid frees from pointer reference calls.
- Issue 50506 - Replace slapi_entry_attr_get_charptr() with slapi_entry_attr_get_ref()
- Issue 50521 - Add regressions in CI tests
- Issue 50510 - etime can contain invalid nanosecond value
- Issue 50488 - Create a monitor for disk space usagedisk-space-mon
- Issue 50511 - lib389 PosixGroups type can not handle rdn properly
- Issue 50508 - UI - fix local password policy form

