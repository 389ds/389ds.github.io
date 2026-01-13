---
title: "Releases/2.8.0"
---

389 Directory Server 2.8.0
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.8.0.

The new packages and versions are:

- 389-ds-base-2.8.0

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.8.0)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.8.0/389-ds-base-2.8.0.tar.bz2>

### Highlights in 2.8.0

- Enhancements
  - Issue [1793](https://github.com/389ds/389-ds-base/issues/1793) - RFE - Implement dynamic lists
  - Issue [7044](https://github.com/389ds/389-ds-base/issues/7044) - RFE - index sudoHost by default
  - Issue [7035](https://github.com/389ds/389-ds-base/issues/7035) - RFE - memberOf - adding scoping for specific groups
  - Issue [6805](https://github.com/389ds/389-ds-base/issues/6805) - RFE - RFE - Multiple backend entry cache tuning
  - Issue [6181](https://github.com/389ds/389-ds-base/issues/6181) - RFE - Allow system to manage uid/gid at startup
- Bug fixes
- Security fixes

### Installation and Upgrade

See [Download](https://www.port389.org/docs/389ds/download.html) for information about setting up your DNF repositories.

To install the server use `dnf install 389-ds-base`

To install the Cockpit UI plugin use `dnf install cockpit-389-ds`

After rpm install completes, run `dscreate interactive`

For upgrades, simply install the package. There are no further steps required.

There are no upgrade steps besides installing the new rpms.

See [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for more information about the initial installation and setup.

See [Source](https://www.port389.org/docs/389ds/development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments here:
 - 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
 - 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

Changelog between 389-ds-base-2.7.0 and 389-ds-base-2.8.0:

- Bump version to 2.8
- Fix UI for dynamic lists in MDB
- Issue 1793 - RFE - Dynamic lists - UI and CLI updates
- Issue 7119 - Fix DNA shared config replication test (#7143)
- Issue 7081 - Repl Log Analysis - Implement data sampling with performance and timezone fixes (#7086)
- Issue 1793 - RFE - Implement dynamic lists
- Issue 7128 - memory corruption in alias entry plugin (#7131)
- Issue 7091 - Duplicate local password policy entries listed (#7092)
- Issue 7124 - BDB cursor race condition with transaction isolation (#7125)
- Issue 7132 - Keep alive entry updated too soon after an offline import (#7133)
- Issue 7121 - LeakSanitizer: various leaks during replication (#7122)
- Issue 7115 - LeakSanitizer: leak in `slapd_bind_local_user()` (#7116)
- Issue 7109 - AddressSanitizer: SEGV ldap/servers/slapd/csnset.c:302 in csnset_dup (#7114)
- Issue 7056 - DSBLE0007 doesn't generate remediation steps for missing indexes
- Issue 7119 - Harden DNA plugin locking for shared server list operations (#7120)
- Issue 7084 - UI - schema - sorting attributes breaks expanded row
- Issue 7007 - Improve paged result search locking
- Issue 3555 - UI - Fix audit issue with npm - glob (#7107)
- Issue 6846 - Attribute uniqueness is not enforced with modrdn (#7026)
- Issue 6901 - Update changelog trimming logging - fix tests
- Issue 6901 - Update changelog trimming logging
- Issue 7097 - Bump js-yaml from 4.1.0 to 4.1.1 in /src/cockpit/389-console (#7097)
- Issue 7069 - Fix error reporting in HAProxy trusted IP parsing (#7094)
- Issue 7042 - Enable global_backend_lock when memberofallbackend is enabled (#7043)
- Issue 7055 - Online initialization of consumers fails with error -23 (#7075)
- Issue 7078 - audit json logging does not encode binary values
- Issue 7069 - Add Subnet/CIDR Support for HAProxy Trusted IPs (#7070)
- Issue 6660 - CLI, UI - Improve replication log analyzer usability (#7062)
- Issue 7065 - A search filter containing a non normalized DN assertion does not return matching entries (#7068)
- Issue 7071 - search filter (&(cn:dn:=groups)) no longer returns results
- Issue 7073 - Add NDN cache size configuration and enforcement tests (#7074)
- Issue 7041 - CLI/UI - memberOf - no way to add/remove specific group filters
- Issue 7061 - CLI/UI - Improve error messages for dsconf localpwp list
- Issue 7059 - UI - unable to upload pem file
- Issue 7032 - The new ipahealthcheck test ipahealthcheck.ds.backends.BackendsCheck raises CRITICAL issue (#7036)
- Issue 7047 - MemberOf plugin logs null attribute name on fixup task completion (#7048)
- Issue 7044 - RFE - index sudoHost by default (#7046)
- Issue 6979 - Improve the way to detect asynchronous operations in the access logs (#6980)
- Issue 7035 - RFE - memberOf - adding scoping for specific groups
- Issue - CLI/UI - Add option to delete all replication conflict entries
- Issue 7033 - lib389 -  basic plugin status not in JSON
- Issue 6753 - Port ticket tests
- Issue 6753 - Port and fix ticket 47823 tests
- Issue 6753 - Add 'add_exclude_subtree' and 'remove_exclude_subtree' methods to Attribute uniqueness plugin
- Issue 6753 - Port ticket test 48026
- Issue 7023 - UI - if first instance that is loaded is stopped it breaks parts of the UI
- Issue 7027 - 389-ds-base OpenScanHub Leaks Detected (#7028)
- Issue 6966 - On large DB, unlimited IDL scan limit reduce the SRCH performance (#6967)
- Issue 6660 - UI - Improve replication log analysis charts and usability (#6968)
- Issue 6982 - UI - MemberOf shared config does not validate DN properly (#6983)
- Issue 7021 - Units for changing MDB max size are not consistent across different tools (#7022)
- Issue 7018 - BUG - prevent stack depth being hit (#7019)
- Issue 6954 - do not delete referrals on chain_on_update backend
- Issue 6928 - The parentId attribute is indexed with improper matching rule
- Issue 6933 - When deferred memberof update is enabled after the server crashed it should not launch memberof fixup task by default (#6935)
- Issue 7014 - memberOf - ignored deferred updates with LMDB
- Issue 7012 - improve dscrl dbverify result when backend does not exists (#7013)
- Issue 6929 - Compilation failure with rust-1.89 on Fedora ELN
- Issue 6977 - UI - Show error message when trying to use unavailable ports (#6978)
- Issue 6990 - UI - Replace deprecated Select components with new TypeaheadSelect (#6996)
- Issue 6990 - UI - Fix typeahead Select fields losing values on Enter keypress (#6991)
- Issue 6956 - More UI fixes
- Issue 6947 - Revise time skew check in healthcheck tool and add option to exclude checks
- UI - update Radio handlers and LDAP entries last modified time
- Issue 6660 - UI - Fix minor typo (#6955)
- Issue 6910 - Fix latest coverity issues
- Issue 6919 - numSubordinates/tombstoneNumSubordinates are inconsisten… (#6920)
- Issue 6940 - dsconf monitor server fails with ldapi:// due to absent server ID (#6941)
- Issue 6936 - Make user/subtree policy creation idempotent (#6937)
- Issue 6768 - ns-slapd crashes when a referral is added (#6780)
- Issue 6865 - AddressSanitizer: leak in agmt_update_init_status
- Issue 6848 - AddressSanitizer: leak in do_search
- Issue 6850 - AddressSanitizer: memory leak in mdb_init
- Issue 6778 - Memory leak in roles_cache_create_object_from_entry part 2
- Issue 6778 - Memory leak in roles_cache_create_object_from_entry
- Issue 6181 - RFE - Allow system to manage uid/gid at startup
- Issues 6913, 6886, 6250 - Adjust xfail marks (#6914)
- Issue 6468 - CLI - Fix default error log level
- Issue 6339 - Address Coverity scan issues in memberof and bdb_layer (#6353)
- Issue 6897 - Fix disk monitoring test failures and improve test maintainability (#6898)
- Issue 6884 - Mask password hashes in audit logs (#6885)
- Issue 6594 - Add test for numSubordinates replication consistency with tombstones (#6862)
- Issue 6250 - Add test for entryUSN overflow on failed add operations (#6821)
- Issue 6895 - Crash if repl keep alive entry can not be created
- Issue 6893 - Log user that is updated during password modify extended operation
- Issue 6772 - dsconf - Replicas with the "consumer" role allow for viewing and modification of their changelog. (#6773)
- Issue 6680 - instance read-only mode is broken (#6681)
- Issue 6878 - Prevent repeated disconnect logs during shutdown (#6879)
- Issue 6872 - compressed log rotation creates files with world readable permission
- Issue 6859 - str2filter is not fully applying matching rules
- Issue 6756 - CLI, UI - Properly handle disabled NDN cache (#6757)
- Issue 6868 - UI - schema attribute table expansion break after moving to a new page
- Issue 6857 - uiduniq: allow specifying match rules in the filter
- Issue 6838 - lib389/replica.py is using nonexistent datetime.UTC in Python 3.9
- Issue 6377 - syntax error in setup.py (#6378)
- Issue 6822 - Backend creation cleanup and Database UI tab error handling (#6823)
- Issue 6782 - Improve paged result locking
- Issue 6119 - Synchronise accept_thread with slapd_daemon (#6120)
- Issue 6825 - RootDN Access Control Plugin with wildcards for IP addre… (#6826)

