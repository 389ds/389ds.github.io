---
title: "Releases/1.4.2.10"
---

389 Directory Server 1.4.2.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.10

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42725457> - Fedora 31

Bodhi

<>

The new packages and versions are:

- 389-ds-base-1.4.2.10-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.10.tar.bz2)

### Highlights in 1.4.2.10

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

The Web UI is finally **complete**, and fully ported to React JS.


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.10
- Issue 50966 - UI - Database indexes not using typeAhead correctly
- Issue 50974 - UI - wrong title in "Delete Suffix" popup
- Issue 50972 - Fix cockpit plugin build
- Issue 50800 - wildcards in rootdn-allow-ip attribute are not accepted
- Issue 50963 - We should bundle *.min.js files of Console

---
title: "Releases/1.4.2.11"
---

389 Directory Server 1.4.2.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.11

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42951806> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-bdf0f2d0d7>

The new packages and versions are:

- 389-ds-base-1.4.2.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.11.tar.bz2)

### Highlights in 1.4.2.11

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.11
- Issue 50994 - Fix latest UI bugs found by QE
- Issue 50337 - Replace exec() with setattr()
- Issue 50984 - Memory leaks in disk monitoring
- Issue 50975 - Revise UI branding with new minimized build
- Issue 49437 - Fix memory leak with indirect COS
- Issue 50976 - Clean up Web UI source directory from unused files
- Issue 50744 - -n option of dbverify does not work
- Issue 50952 - SSCA lacks basicConstraint:CA


---
title: "Releases/1.4.2.12"
---

389 Directory Server 1.4.2.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.12

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=43476746>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-57d6e31060>

The new packages and versions are:

- 389-ds-base-1.4.2.12-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.12.tar.bz2)

### Highlights in 1.4.2.12

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.12
- Issue 50337 - Replace exec() with setattr()
- Issue 50545 - the check for the ds version for the backend config was broken
- Issue 50875 - Refactor passwordUserAttributes's and passwordBadWords's code
- Issue 51014 - slapi_pal.c possible static buffer overflow
- Issue 50545 - remove dbmon "incr" option from arg parser
- Issue 50545 - Port dbmon.sh to dsconf
- Issue 50905 - intermittent SSL hang with rhds
- Issue 50952 - SSCA lacks basicConstraint:CA
- Issue 50640 - Database links: get_monitor() takes 1 positional argument but 2 were given
- Issue 50869 - Setting nsslapd-allowed-sasl-mechanisms truncates the value

---
title: "Releases/1.4.2.13"
---

389 Directory Server 1.4.2.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.13

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=44236196>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-43914ebb85>

The new packages and versions are:

- 389-ds-base-1.4.2.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.13.tar.bz2)

### Highlights in 1.4.2.13

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.13
- Issue 50787 - fix implementation of attr unique
- Issue 51078 - Add nsslapd-enable-upgrade-hash to the schema
- Issue 51068 - deadlock when updating the schema
- Issue 51060 - unable to set sslVersionMin to TLS1.0
- Issue 51064 - Unable to install server where IPv6 is disabled
- Issue 51051 - CLI fix consistency issues with confirmations
- Issue 51047 - React deprecating ComponentWillMount
- Issue 50499 - fix npm audit issues
- Issue 51035 - Heavy StartTLS connection load can randomly fail with err=1
- Issue 51031 - UI - transition between two instances needs improvement

---
title: "Releases/1.4.2.14"
---

389 Directory Server 1.4.2.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.14

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=45153610>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-0a057b856f>

The new packages and versions are:

- 389-ds-base-1.4.2.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.14.tar.bz2)

### Highlights in 1.4.2.14

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.14
- Issue 51113 - Allow using uid for replication manager entry
- Issue 51095 - abort operation if CSN can not be generated
- Issue 51110 - Fix ASAN ODR warnings
- Issue 51102 - RFE - ds-replcheck - make online timeout configurable
- Issue 51076 - remove unnecessary slapi entry dups
- Issue 51086 - Improve dscreate instance name validation
- Issue 50989 - ignore pid when it is ourself in protect_db
- Issue 50499 - Fix some npm audit issues
- Issue 51091 - healthcheck json report fails when mapping tree is deleted
- Issue 51079 - container pid start and stop issues
- Issue 50610 - Fix return code when it's nothing to free
- Issue 51082 - abort when a empty valueset is freed
- Issue 50610 - memory leaks in dbscan and changelog encryption
- Issue 51076 - prevent unnecessarily duplication of the target entry
- Issue 50940 - Permissions of some shipped directories may change over time

---
title: "Releases/1.4.2.15"
---

389 Directory Server 1.4.2.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.15

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=45761486>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-7b44e02730>

The new packages and versions are:

- 389-ds-base-1.4.2.15-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.15.tar.bz2)

### Highlights in 1.4.2.15

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.15
- Issue 51072 - Set the default minimum worker threads
- Issue 51100 - Correct numSubordinates value for cn=monitor
- Issue 51136 - dsctl and dsidm do not errors correctly when using JSON
- Issue 51132 - Winsync setting winSyncWindowsFilter not working as expected
- Issue 51072 - improve autotune defaults
- Issue 50746 - Add option to healthcheck to list all the lint reports
- Issue 51118 - UI - improve modal validation when creating an instance

---
title: "Releases/1.4.2.16"
---

389 Directory Server 1.4.2.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.16

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46843300>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-7546332207>

The new packages and versions are:

- 389-ds-base-1.4.2.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.16.tar.bz2)

### Highlights in 1.4.2.16

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.16
- Issue 51159 - dsidm ou delete fails
- Issue 51165 - add more logconv stats for the new access log keywords
- Issue 51165 - add new access log keywords for wtime and optime
- Issue 50696 - Fix Allowed and Denied Ciphers lists - WebUI
- Issue 51169 - UI - attr uniqueness - selecting empty subtree crashes cockpit
- Issue 49256 - log warning when thread number is very different from autotuned value
- Issue 51157 - Reindex task may create abandoned index file
- Issue 51166 - Log an error when a search is fully unindexed
- Issue 51161 - fix SLE15.2 install issps
- Issue 51144 - dsctl fails with instance names that contain slapd-
- Issue 50984 - Memory leaks in disk monitoring
---
title: "Releases/1.4.2.2"
---

389 Directory Server 1.4.2.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.2

Fedora packages are available on Fedora (rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=37707859> - Rawhide


The new packages and versions are:

- 389-ds-base-1.4.2.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.2.tar.bz2)

### Highlights in 1.4.2.2

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

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>
- Bump version to 1.4.2.2
- Issue 50627 - Add ASAN logs to HTML report
- Issue 50545 - Port repl-monitor.pl to lib389 CLI
- Issue 50622 - ds_selinux_enabled may crash on suse
- Issue 50595 - remove syslog.target requirement
- Issue 50617 - disable cargo lock
- Issue 50620 - Fix regressions from 50506 (slapi_enry_attr_get_ref)
- Issue 50615 - Log current test name to journald
- Issue 50610 - memory leak in dbscan
- Bump version to 1.4.2.1
- Issue 50581 - ns-slapd crashes during ldapi search
- Issue 50604 - Fix UI validation
- Issue 50510 - etime can contain invalid nanosecond value
- Issue 50593 - Investigate URP handling on standalone instance
- Issue 50506 - Fix regression for relication stripattrs
- Issue 50580 - Perl can't be disabled in configure
- Issue 50584, 49212 - docker healthcheck and configuration
- Issue 50546 - fix more UI issues(part 2)
- Lib389 - Do not use comparision with "is" for empty value
- Issue 50546 - fix more UI issues
- Issue 50586 - lib389 - Fix DSEldif long line processing
- Issue 50173 - Add the validate-syntax task to the dsconf schema
- Issue 50546 - Fix various issues in UI
- Bump version to 1.4.2.0
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
- Issue 50542 - Fix crashes in filter tests
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



---
title: "Releases/1.4.2.2"
---

389 Directory Server 1.4.2.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.2

Fedora packages are available on Fedora (rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=37898643> - Rawhide


The new packages and versions are:

- 389-ds-base-1.4.2.2-3

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.2.tar.bz2)

### Highlights in 1.4.2.2

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

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>
- Bump version to 1.4.2.2
- Issue 50627 - Add ASAN logs to HTML report
- Issue 50545 - Port repl-monitor.pl to lib389 CLI
- Issue 50622 - ds_selinux_enabled may crash on suse
- Issue 50595 - remove syslog.target requirement
- Issue 50617 - disable cargo lock
- Issue 50620 - Fix regressions from 50506 (slapi_enry_attr_get_ref)
- Issue 50615 - Log current test name to journald
- Issue 50610 - memory leak in dbscan
- Bump version to 1.4.2.1
- Issue 50581 - ns-slapd crashes during ldapi search
- Issue 50604 - Fix UI validation
- Issue 50510 - etime can contain invalid nanosecond value
- Issue 50593 - Investigate URP handling on standalone instance
- Issue 50506 - Fix regression for relication stripattrs
- Issue 50580 - Perl can't be disabled in configure
- Issue 50584, 49212 - docker healthcheck and configuration
- Issue 50546 - fix more UI issues(part 2)
- Lib389 - Do not use comparision with "is" for empty value
- Issue 50546 - fix more UI issues
- Issue 50586 - lib389 - Fix DSEldif long line processing
- Issue 50173 - Add the validate-syntax task to the dsconf schema
- Issue 50546 - Fix various issues in UI
- Bump version to 1.4.2.0
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
- Issue 50542 - Fix crashes in filter tests
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



---
title: "Releases/1.4.2.3"
---

389 Directory Server 1.4.2.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.3

Fedora packages are available on Fedora (rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38746765> - Rawhide


The new packages and versions are:

- 389-ds-base-1.4.2.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.3.tar.bz2)

### Highlights in 1.4.2.3

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
|Replication Tab  |Yes       |Yes                |
|Schema Tab       |Yes       |No                 |
|Plugin Tab       |Yes       |Yes                |
|Monitor Tab      |Yes       |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.3
- Issue 50592 - Port Replication Tab to ReactJS
- Issue 50680 - Remove branding from upstream spec file
- Issue 50669 - Remove nunc-stans in favour of reworking current conn code (add.)
- Issue 48055 - CI test - automember_plugin(part1)
- Issue 50677 - Map subtree searches with NULL base to default naming context
- Issue 50669 - Fix RPM build
- Issue 50669 - remove nunc-stans
- Issue 49850 - cont -fix crash in ldbm_non_leaf
- Issue 50634 - Clean up CLI errors output - Fix wrong exception
- Issue 50660 - Build failure on Fedora 31
- Issue 50634 - Clean up CLI errors output
- Issue 48851 - Investigate and port TET matching rules filter tests(match more test cases)
- Issue 50428 - Log the actual base DN when the search fails with "invalid attribute request"
- Issue 49850 -  ldbm_get_nonleaf_ids() slow for databases with many non-leaf entries
- Issue 50655 - access log etime is not properly formatted
- Issue 50653 -  objectclass parsing fails to log error message text
- Issue 50646 - Improve task handling during shutdowns
- Issue 50627 - Support platforms without pytest_html
- Issue 49476 - backend refactoring phase1, fix failing tests
- Issue 49476 - refactor ldbm backend to allow replacement of BDB
- Issue 50349 - additional fix: filter schema check must handle subtypes
- Issue 48851 - investigate and port TET matching rules filter tests(indexing more test cases)
- Issue 50638 - RecursionError: maximum recursion depth exceeded while calling a Python object
- Issue 50636 - Crash during sasl bind
- Issue 50632 - Add ensure attr state so that diffs are easier from 389-ds-portal
- Issue 50619 - extend commands to have more modify options
- Issue 50499 - Fix npm audit issues




---
title: "Releases/1.4.2.4"
---

389 Directory Server 1.4.2.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.4

Fedora packages are available on Fedora 31 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39012835> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39012772> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-bd427e30b5>

The new packages and versions are:

- 389-ds-base-1.4.2.4-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.4.tar.bz2)

### Highlights in 1.4.2.4

- Security and Bug fixes

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
|Schema Tab         |Yes         |No                 |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.4
- Issue 50634 - Fix CLI error parsing for non-string values
- Issue 50659 - AddressSanitizer: SEGV ... in bdb_pre_close
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50644 - fix regression with creating sample entries
- Issue 50699 - Add Disk Monitor to CLI and UI
- Issue 50716 - CVE-2019-14824 (BZ#1748199) - deref plugin displays restricted attributes
- Issue 50536 - After audit log file is rotated, DS version string is logged after each update
- Issue 50712 - Version comparison doesn't work correctly on git builds
- Issue 50706 - Missing lib389 dependency - packaging
- Issue 49761 - Fix CI test suite issues
- Issue 50683 - Makefile.am contains unused RPM-related targets
- Issue 50696 - Fix various UI bugs
- Issue 50641 - Update default aci to allows users to change their own password
- Issue 50007, 50648 - improve x509 handling in dsctl
- Issue 50689 - Failed db restore task does not report an error
- Issue 50199 - Disable perl by default
- Issue 50633 - Add cargo vendor support for offline builds
- Issue 50499 - Fix npm audit issues



---
title: "Releases/1.4.2.5"
---

389 Directory Server 1.4.2.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.5

Fedora packages are available on Fedora 31 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39454569> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39454576> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-ad190c32de>

The new packages and versions are:

- 389-ds-base-1.4.2.5-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.5.tar.bz2)

### Highlights in 1.4.2.5

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

- Bump version to 1.4.2.5
- Issue 50747 - Port readnsstate to dsctl
- Issue 50758 - Enable CLI arg completion
- Issue 50753 - Dumping the changelog to a file doesn't work
- Issue 50745 - ns-slapd hangs during CleanAllRUV tests
- Issue 50734 - lib389 creates non-SSCA cert DBs with misleading README.txt
- Issue 48851 - investigate and port TET matching rules filter tests(cert)
- Issue 50443 - Create a module in lib389 to Convert a byte sequence to a properly escaped for LDAP
- Issue 50664 - DS can fail to recover if an empty directory exists in db
- Issue 50736 - RetroCL trimming may crash at shutdown if trimming configuration is invalid
- Issue 50741 - bdb_start - Detected Disorderly Shutdown last time Directory Server was running
- Issue 50572 - After running cl-dump dbdir/cldb/*ldif.done are not deleted
- Issue 50701 - Fix type in lint report
- Issue 50729 - add support for gssapi tests on suse
- Issue 50701 - Add additional healthchecks to dsconf
- Issue 50711 - 'dsconf security' lacks option for setting nsTLSAllowClientRenegotiation attribute
- Issue 50439 - Update docker integration for Fedora
- Issue 48851 - Investigate and port TET matching rules filter tests(last test cases for match)
- Issue 50499 - Fix npm audit issues
- Issue 50722 - Test IDs are not unique
- Issue 50712 - Version comparison doesn't work correctly on git builds
- Issue 50499 - Fix npm audit issues
- Issue 50706 - Missing lib389 dependency - packaging



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


---
title: "Releases/1.4.2.7"
---

389 Directory Server 1.4.2.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.7

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=40930612> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-1afba1a0c2>

The new packages and versions are:

- 389-ds-base-1.4.2.7-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.7.tar.bz2)

### Highlights in 1.4.2.7

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
|Server Tab         |Yes         |No  (coming soon)  |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |Yes                |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.7
- Issue 49254 - Fix compiler failures and warnings
- Issue 50741 - cont bdb_start - Detected Disorderly Shutdown
- Issue 50836 - Port Schema UI tab to React
- Issue 50842 - Decrease 389-console Cockpit component size
- Issue 50790 - Add result text when filter is invalid
- Issue 50834 - Incorrectly setting the NSS default SSL version max
- Issue 50829 - Disk monitoring rotated log cleanup causes heap-use-after-free
- Issue 50709 - (cont) Several memory leaks reported by Valgrind for 389-ds 1.3.9.1-10
- Issue 50599 - Fix memory leak when removing db region files
- Issue 49395 - Set the default TLS version min to TLS1.2
- Issue 50818 - dsconf pwdpolicy get error
- Issue 50824 - dsctl remove fails with "name 'ensure_str' is not defined"
- Issue 50599 - Remove db region files prior to db recovery
- Issue 50812 - dscontainer executable should be placed under /usr/libexec/dirsrv/
- Issue 50816 - dsconf allows the root password to be set to nothing
- Issue 50798 - incorrect bytes in format string(fix import issue)


---
title: "Releases/1.4.2.8"
---

389 Directory Server 1.4.2.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.8

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=41483383> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-352407f784>

The new packages and versions are:

- 389-ds-base-1.4.2.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.8.tar.bz2)

### Highlights in 1.4.2.8

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
|Server Tab         |Yes         |Yes                |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |Yes                |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |
|Navigiation Bar    |Yes         |No                 |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.8
- Issue 50855 - remove unused file from UI
- Issue 50855 - UI: Port Server Tab to React
- Issue 49845 - README does not contain complete information on building
- Issue 49623 - cont cenotaph errors on modrdn operations
- Issue 50882 - Fix healthcheck errors for instances that do not have TLS enabled
- Issue 50886 - Typo in the replication debug message
- Issue 50873 - Fix healthcheck and virtual attr check
- Issue 50873 - Fix issues with healthcheck tool
- Issue 50857 - Memory leak in ACI using IP subject
- Issue 50823 - dsctl doesn't work with 'slapd-' in the instance name
- Issue 49624 cont - DB Deadlock on modrdn appears to corrupt database and entry cache
- Issue 50850 - Fix dsctl healthcheck for python36
- Issue 49990 - Need to enforce a hard maximum limit for file descriptors

- Issue 50798 - incorrect bytes in format string(fix import issue)


---
title: "Releases/1.4.2.9"
---

389 Directory Server 1.4.2.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.9

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=42536258> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-9d7e5f1469>

The new packages and versions are:

- 389-ds-base-1.4.2.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.9.tar.bz2)

### Highlights in 1.4.2.9

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

The UI is complete, and fully ported to React JS.


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.2.9
- Issue 50755 - setting nsslapd-db-home-directory is overriding db_directory
- Issue 50937 - Update CLI for new backend split configuration
- Issue 50499 - Fix npm audit issues
- Issue 50884 - Health check tool DSEldif check fails
- Issue 50926 - Remove dual spinner and other UI fixes
- Issue 49845 - Remove pkgconfig check for libasan
- Issue 50758 - Only Recommend bash-completion, not Require
- Issue 50928 - Unable to create a suffix with countryName
- Issue 50904 - Connect All React Components And Refactor the Main Navigation Tab Code
- Issue 50919 - Backend delete fails using dsconf
- Issue 50872 - dsconf can't create GSSAPI replication agreements
- Issue 50914 - No error returned when adding an entry matching filters for a non existing automember group
- Issue 50909 - nsDS5ReplicaId cant be set to the old value it had before
- Issue 50618 - support cgroupv2
- Issue 50898 - ldclt core dumped when run with -e genldif option


