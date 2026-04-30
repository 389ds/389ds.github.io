---
title: "Releases/3.2.1"
---

389 Directory Server 3.2.1
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.2.1.

Fedora packages are available on Fedora 45 (rawhide):

<https://koji.fedoraproject.org/koji/taskinfo?taskID=144971802> - Koji

The new packages and versions are:

- 389-ds-base-3.2.1

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.2.1)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.2.1/389-ds-base-3.2.1.tar.bz2>

### Highlights in 3.2.1

- Enhancements
  - Issue [7307](https://github.com/389ds/389-ds-base/issues/7307) - RFE - Expose work queue and worker utilization metrics
  - Issue [7300](https://github.com/389ds/389-ds-base/issues/7300) - RFE - Add OS-level thread names to all server threads
  - Issue [7281](https://github.com/389ds/389-ds-base/issues/7281) - RFE - CLI - add support to managing additional encryption module
  - Issue [6951](https://github.com/389ds/389-ds-base/issues/6951) - RFE - Dynamic Certificates Refresh
- Security fixes
  - Update dependency uuid to v14
  - Update Rust crate openssl to v0.10.78
  - Security fix for CVE-2025-14905
  - Bump lodash from 4.17.21 to 4.17.23 in /src/cockpit/389-console (#7203)
- Bug fixes

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

Changelog between 389-ds-base-3.2.0 and 389-ds-base-3.2.1:

- Bump version to 3.2.1
- Issue 6942 - Crash in `slapi_sdn_get_ndn()` (#7318)
- Issue 6753 - Porting ticket 48312 test
- Issue 6753 - Port ticket 48270 test
- Issue 7431 - password policy - passwordBadWords is ignored in local policies
- Update dependency uuid to v14 [SECURITY] (#7456)
- Issue 7440 - Substring index produces empty results and can crash when non-default nsSubStrBegin/nsSubStrEnd lengths are configured (#7441)
- Update Rust crate openssl to v0.10.78 [SECURITY] (#7455)
- Update cockpit-389-ds-npm (major) (#7448)
- Update rust-dependencies to v1 (major) (#7449)
- Issue 7426 - logconv.py is out of sync with server-emitted note codes (#7427)
- Migrate config .github/renovate.json (#7450)
- Issue 7437 - LeakSanitizer: memory leaks in CoS cache error paths (#7438)
- Issue 7365 - Add integration with Renovate (#7439)
- Issue 7412 - Report thread pool saturation on per-operation access log RESULT lines (#7413)
- Issue 7417 - UI - global password policy syntax settings missing passwordMaxRepeats
- Issue 7420 - Inconsistencies in the password policy log messages (#7421)
- Issue 7389 - Fix CONFIG_CHARRAY crash (#7415)
- Issue 7375 - CI - Fix flaky dsconf_tasks_test watch output (#7410)
- Issue 3555 - UI - Fix audit issue with npm - brace-expansion (#7411)
- Issue 7088 - Change log level for "Can't locate CSN" error message
- Issue 7423 - cleanup pblock after freeing pre/post entries
- Issue 7418 - Use-after-free in deferred memberof (#7419)
- Issue 7407 - dbscan -k option display entries that do not match the specified key
- Issue 7404 - fix latest compiler warnings
- Issue 4148 - Add unit tests for CSN clock error handling (#7330)
- Issue 7227 - CI - Fix flaky dynamic certificates test crash (#7382)
- Issue 7119 - CI - Fix flaky test_dna_shared_config_replication (#7385)
- Issue 7394 - UI - Manual typing of ports can leave out digits (#7395)
- Issue 7396 - Testimony failure in monitor_test.py (#7397)
- Issue 6753 - Port ticket 48170 test (#7387)
- Issue 6753 - Port ticket 48265 test (#7388)
- Issue 7277 - UI - Fix Japanese translation errors errors in Cockpit UI (#7386)
- Issue 7389 - Allow to ignore criticality flags for specific controls (#7390)
- Issue 7353 - CI - Fix checks for plugins/accpol_test.py::test_glinact_nsact
- Issue 7360 - Expose stats from deferred memberof (#7361)
- Issue 7327 - dsctl healthcheck DSMOLE0001 inaccurate recommendations with multiple backends (#7328)
- Issue 7370 - Runtime LSan/TSan injection for pytest (#7371)
- Issue 7378 - Make sure suffix entry always gets assigned ID 1
- Issue 7380 - Internal op with negative wtime and large optime (#7381)
- Issue 7375 - CI - Fix clu/dsconf_tasks_test (#7376)
- Issue 7362 - UI - Some FormSelect onChange parameters are reversed
- Issue 7368 - UI - global password policy page is missing passwordmintokenlength
- Issue 7366 - Memory leaks in syncrepl plugin during persistent search operations (#7367)
- Issue 7053 - Add tests for duplicate member operations (#7345)
- Issue 6724 - Log fine grained details of operation timing (#7350)
- Issue 3658 - UI/CLI - show progress of db tasks
- Issue 7284 - CI - Fix test_grace_limit_section after pwpolicy validation fix (#7357)
- Issue 7271 - Add test for retrocl trimming shutdown crash (#7356)
- Issue 3555 - UI - Fix audit issue with npm - flatted, picomatch (#7364)
- Issue 7358 - NSACLPlugin - acl_access_allowed - Missing aclpb 1 (#7359)
- Issue 7126 - WARN - keys2idl - received NULL idl from index_read_ext_allids (#7127)
- Issue 7337 - UI - refactor all error handling to use getApiErrorMessge
- Issue 1704 - DNA plugin creates invalid shared config entry with port 0 (#7352)
- Issue 7348 - CI - Fix failing dsconf security CLI add cert test (#7349)
- Issue 7322 - Reject adding a replication agreement that points to itself
- Issue 7333 - Fail open condition in ACL (#7334)
- Issue 7312 - UI - Database Maximum Size cannot be easily set by typing (#7313)
- Issue 7342 - CI - repl config regression (#7343)
- Issue 7346 - DS does not handle escape char in bind user (#7347)
- Issue 6753 - Remove ticket 48013 test (#7344)
- Issue 6753 - Port ticket 48005 test (#7340)
- Issue 7339 - Return the exact DN during export
- Issue 6753 - Port ticket 47976 test
- Issue 7331 - UI - Improve suffix import LDIF table
- Issue 7325 - UI - new error parser missing import
- Issue 7325 - UI - create an error parser for cockpit spawn errors
- Issue 7319 - Action menu for certificates remains in empty certificate list (#7320)
- Issue 6753 - Port ticket 47980 and 47981 tests (#7323)
- Issue 7265 - CI - fix retro changelog maxage validation test
- Issue 7093 - A password policy can be created even when an identical policy already exists (#7283)
- Issue 7316 - UI - update npm module immutable
- Issue 7314 - UI - Add progress steppers to Security, Database, and Replication tabs
- Issue 7281 - UI - Add encryption module management
- Issue 7302 - dblib bdb2mdb fails on F43 -> F43 upgrade (#7303)
- Issue 7296 - Introduce time limits for GH Actions (#7297)
- Issue 7307 - RFE - Expose work queue and worker utilization metrics (#7308)
- Issue 7300 - RFE - Add OS-level thread names to all server threads (#7301)
- Issue 7271 - Add new plugin pre-close function check to plugin_invoke_plugin_pb
- Issue 7304 - retrocl should not cache DN
- Issue 7265 - Add dse modify callback to validate retrocl trimming settings
- Issue 3555 - UI - Fix audit issue with npm - ajv, minimatch (#7298)
- Issue 7291 - Crash when configuring a replica with an incorrect nsds5ReplicaRoot (#7292)
- Issue 7271 - implement a pre-close plugin function
- Issue 7061 - Test for improved error message
- Issue 7281 - RFE - CLI - add support to managing additional encryption modules
- Issue 7265 - changelog maxage validation is not strict enough
- Issue 6220 - Add Packit configuration (#6221)
- Issue 7284 - Creating local password policy succeeds with incorrect passwordInHistory value (#7285)
- Issue 7277 - UI - Fix Japanese translation for "Successfully updated group" in Cockpit UI (#7278)
- Issue 7267 - MDB_BAD_VALSIZE error when updating index (#7268)
- Security fix for CVE-2025-14905
- Issue 7246 - correct formatting of 'Gen as CSN' in dsctl get-nsstate output (#7247)
- Issue 7275 - UI - Improve password policy field validation in Cockpit UI (#7276)
- Issue 7279 - UI - Fix typo in export certificate dialog (#7280)
- Issue 7273 - In a chaining environment binding as remote user causes an invalid error in the logs
- Issue 7271 - plugins that create threads need to update  active thread count
- Issue 5853 - Update concread to 0.5.10
- Issue 6753 - Port ticket 49039 test
- Issue 7236 - Fix GSSAPI tests (#7237)
- Issue 7223 - Remove integerOrderingMatch requirement for parentid (#7264)
- Issue 6758 - Fix Enable Replication dropdown not opening (#7262)
- Issue 7243 - UI - add support for hot certificates
- Issue 7066/7052 - allow password history to be set to zero and remove history
- Issue 3134 - Fix build break (#7260)
- Issue 7223 - Use lexicographical order for ancestorid (#7256)
- Issue 7213 - (2nd) MDB_BAD_VALSIZE error while handling VLV (#7258)
- Issue 7184 - (2nd) argparse.HelpFormatter _format_actions_usage() is deprecated (#7257)
- Issue 6951 - Dynamic Certificas Refresh - CI tests (#7238)
- Issue 7252 - PQC - Need to iterate on SECOidTag instead of using OID (#7254)
- Issue 7250 - CLI - dsctl db2index needs some hardening with MBD
- Issue 7248 - CLI - attribute uniqueness - fix usage for exclude subtree option
- Issue 7231 - Sync repl tests fail in FIPS mode due to non FIPS compliant crypto (#7232)
- Issue 7241 - Drop dateutil (#7242)
- Issue 7233 - test_produce_division_by_zero fails with IsADirectoryError in conftest.py (#7234)
- Issue 7221 - CI tests - fix some flaky tests
- Issue 3555 - UI - Fix audit issue with npm - @isaacs/brace-expansion (#7228)
- Issue 7230 - Regression in healtcheck NssCheck (#7235)
- Issue 7223 - Add dsctl index-check command for offline index repair
- Issue 7223 - Detect and log index ordering mismatch during backend startup
- Issue 7223 - Add upgrade function to remove ancestorid index config entry
- Issue 7223 - Add upgrade function to remove nsIndexIDListScanLimit from parentid
- Issue 7223 - Revert index scan limits for system indexes
- Issue 7121 - (2nd) LeakSanitizer: various leaks during replication (#7212)
- Issue 7178 - Bundled jemalloc fails to build with GCC 15 (#7216)
- Issue 7224 - CI Test - Simplify test_reserve_descriptor_validation (#7225)
- Issue 6951 - Dynamic Certificate refresh phase 4 - Update lib389 and dsconf (#7171)
- Issue 7076 - Fix revert_cache() never called in modrdn (#7220)
- Issue 6810 - Fix PAM PTA test (#7219)
- Issue 6753 - Port ticket 48896 test
- Issue 7194 - Repl Log Analysis - Add CSN propagation details (#7195)
- Issue 6753 - Port ticket 47781 test (#7210)
- Issue 7213 - MDB_BAD_VALSIZE error while handling VLV (#7214)
- Issue 7027 - (2nd) 389-ds-base OpenScanHub Leaks Detected (#7211)
- Issue 7206 - Should log whether TLS key is PQC or not (#7207)
- Issue 7096 - (2nd) During replication online total init the function idl_id_is_in_idlist is not scaling with large database (#7205)
- Issue 7201 - Syscall overhead in LMDB import writer thread (#7204)
- Issue 6947 - Revise time skew check in healthcheck tool - add tests (#7208)
- Issue 7184 - argparse.HelpFormatter _format_actions_usage() is deprecated
- Issue 7014 - memberOf - ignored deferred updates with LMDB
- Issue 7198 - Web console doesn't show sub-suffix when parent-suffix points to an entry (#7202)
- Bump lodash from 4.17.21 to 4.17.23 in /src/cockpit/389-console (#7203)
- Issue 7170 - Support of PQC keys (#7188)
- Issue 7189 - DSBLE0007 generates incorrect remediation commands for scan limits
- Issue 7196 - DynamicCertificates returns empty DER (#7197)
- Issue 6758 - Use OUIA selectors for WebUI plugin tests (#7182)
- Issue 7169 - Fix automember_plugin CI test failures (#7181)
- Issue 7152 - ns-slapd fails to shutdown when deferred memberof update is in progress (#7187)
- Issue 6753 - Port ticket 548 test (#7101)
- Issue 7172 - (2nd) Index ordering mismatch after upgrade (#7180)
- Issue 7172 - Index ordering mismatch after upgrade (#7173)
- Issue 7108 - Fix shutdown crash in entry cache destruction (#7163)
- Issue 7118 - Revise paged result search locking
- Issue 7096 - During replication online total init the function idl_id_is_in_idlist is not scaling with large database (#7145)


