---
title: "Releases/2.8.1"
---

389 Directory Server 2.8.1
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.8.1.

- 389-ds-base-2.8.1

Source tarball: [GitHub Releases](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.8.1)

### Highlights in 2.8.1

- Security fix for [CVE-2026-9064](https://access.redhat.com/security/cve/CVE-2026-9064) by limiting controls per operation.
- Fix large subtree moddn crashes and obsolete `entrydn` index handling.
- Add thread names, work queue metrics, and support for additional `dsidm` user types.
- Fix MemberOf deferred-update crashes, replication-agreement validation, and substring index failures.
- Improve password policy controls and WebUI replication management.

See [Download](https://www.port389.org/docs/389ds/download.html) for package installation and [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for setup.

Changelog between 389-ds-base-2.8.0 and 389-ds-base-2.8.1:

- Bump version to 2.8.1
- Issue [7519](https://github.com/389ds/389-ds-base/issues/7519) - Ignore obsolete entrydn index when entryrdn is enabled [#7526](https://github.com/389ds/389-ds-base/pull/7526)
- Issue [7514](https://github.com/389ds/389-ds-base/issues/7514) - Crash when doing moddn on very large subtree
- Issue [7516](https://github.com/389ds/389-ds-base/issues/7516) - dblayer\_bulk\_nextdata should not return an error when maxrecords is hit
- Issue [7503](https://github.com/389ds/389-ds-base/issues/7503) - [CVE-2026-9064](https://access.redhat.com/security/cve/CVE-2026-9064) - Add a limit to the number controls per operation
- Issue [7300](https://github.com/389ds/389-ds-base/issues/7300) - RFE - Add OS-level thread names to all server threads [#7301](https://github.com/389ds/389-ds-base/pull/7301)
- Issue [7307](https://github.com/389ds/389-ds-base/issues/7307) - RFE - Expose work queue and worker utilization metrics [#7308](https://github.com/389ds/389-ds-base/pull/7308)
- Issue [7464](https://github.com/389ds/389-ds-base/issues/7464) - CLI - allow dsidm to work with other user types
- Issue [7457](https://github.com/389ds/389-ds-base/issues/7457) - Refactor memberOf perf test [#7458](https://github.com/389ds/389-ds-base/pull/7458)
- Issue [7452](https://github.com/389ds/389-ds-base/issues/7452) - UI - password polices - reorganize settings
- Issue [7431](https://github.com/389ds/389-ds-base/issues/7431) - password policy - passwordBadWords is ignored in local policies
- Issue [7155](https://github.com/389ds/389-ds-base/issues/7155) - build\_candidate\_list - Database error 11 with range search [#7156](https://github.com/389ds/389-ds-base/pull/7156)
- Issue [7417](https://github.com/389ds/389-ds-base/issues/7417) - UI - global password policy syntax settings missing passwordMaxRepeats
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - brace-expansion [#7411](https://github.com/389ds/389-ds-base/pull/7411)
- Issue [7088](https://github.com/389ds/389-ds-base/issues/7088) - Change log level for "Can't locate CSN" error message
- Issue [7423](https://github.com/389ds/389-ds-base/issues/7423) - cleanup pblock after freeing pre/post entries
- Issue [7418](https://github.com/389ds/389-ds-base/issues/7418) - Use-after-free in deferred memberof [#7419](https://github.com/389ds/389-ds-base/pull/7419)
- Issue [7407](https://github.com/389ds/389-ds-base/issues/7407) - dbscan -k option display entries that do not match the specified key
- Issue [7394](https://github.com/389ds/389-ds-base/issues/7394) - UI - Manual typing of ports can leave out digits [#7395](https://github.com/389ds/389-ds-base/pull/7395)
- Issue [7277](https://github.com/389ds/389-ds-base/issues/7277) - UI - Fix Japanese translation errors errors in Cockpit UI [#7386](https://github.com/389ds/389-ds-base/pull/7386)
- Issue [7126](https://github.com/389ds/389-ds-base/issues/7126) - WARN - keys2idl - received NULL idl from index\_read\_ext\_allids [#7127](https://github.com/389ds/389-ds-base/pull/7127)
- Issue [7246](https://github.com/389ds/389-ds-base/issues/7246) - correct formatting of 'Gen as CSN' in dsctl get-nsstate output [#7247](https://github.com/389ds/389-ds-base/pull/7247)
- Issue [7370](https://github.com/389ds/389-ds-base/issues/7370) - Runtime LSan/TSan injection for pytest [#7371](https://github.com/389ds/389-ds-base/pull/7371)
- Issue [7378](https://github.com/389ds/389-ds-base/issues/7378) - Make sure suffix entry always gets assigned ID 1
- Issue [7380](https://github.com/389ds/389-ds-base/issues/7380) - Internal op with negative wtime and large optime [#7381](https://github.com/389ds/389-ds-base/pull/7381)
- Issue [7362](https://github.com/389ds/389-ds-base/issues/7362) - UI - Some FormSelect onChange parameters are reversed
- Issue [7368](https://github.com/389ds/389-ds-base/issues/7368) - UI - global password policy page is missing passwordmintokenlength
- Issue [7366](https://github.com/389ds/389-ds-base/issues/7366) - Memory leaks in syncrepl plugin during persistent search operations [#7367](https://github.com/389ds/389-ds-base/pull/7367)
- Issue [7271](https://github.com/389ds/389-ds-base/issues/7271) - Add test for retrocl trimming shutdown crash [#7356](https://github.com/389ds/389-ds-base/pull/7356)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - flatted, picomatch [#7364](https://github.com/389ds/389-ds-base/pull/7364)
- Issue [7277](https://github.com/389ds/389-ds-base/issues/7277) - UI - Fix Japanese translation for "Successfully updated group" in Cockpit UI [#7278](https://github.com/389ds/389-ds-base/pull/7278)
- Issue [7275](https://github.com/389ds/389-ds-base/issues/7275) - UI - Improve password policy field validation in Cockpit UI [#7276](https://github.com/389ds/389-ds-base/pull/7276)
- Issue [7279](https://github.com/389ds/389-ds-base/issues/7279) - UI - Fix typo in export certificate dialog [#7280](https://github.com/389ds/389-ds-base/pull/7280)
- Issue [6758](https://github.com/389ds/389-ds-base/issues/6758) - Fix Enable Replication dropdown not opening [#7262](https://github.com/389ds/389-ds-base/pull/7262)
- Issue [6758](https://github.com/389ds/389-ds-base/issues/6758) - Use OUIA selectors for WebUI plugin tests [#7182](https://github.com/389ds/389-ds-base/pull/7182)
- Issue [6758](https://github.com/389ds/389-ds-base/issues/6758) - Fix WebUI monitoring test failure due to FormSelect component deprecation [#7004](https://github.com/389ds/389-ds-base/pull/7004)
- Issue [6758](https://github.com/389ds/389-ds-base/issues/6758) - Fix failing webUI tests
- Issue [1704](https://github.com/389ds/389-ds-base/issues/1704) - DNA plugin creates invalid shared config entry with port 0 [#7352](https://github.com/389ds/389-ds-base/pull/7352)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Removing ticket 477828 test and porting to DSLdapObject [#6989](https://github.com/389ds/389-ds-base/pull/6989)
- Issue [7346](https://github.com/389ds/389-ds-base/issues/7346) - DS does not handle escape char in bind user [#7347](https://github.com/389ds/389-ds-base/pull/7347)
- Issue [7322](https://github.com/389ds/389-ds-base/issues/7322) - Fix cherry-pick error (reject repl agmt that points to itself)
- Issue [7322](https://github.com/389ds/389-ds-base/issues/7322) - Reject adding a replication agreement that points to itself
- Issue [7342](https://github.com/389ds/389-ds-base/issues/7342) - CI - repl config regression [#7343](https://github.com/389ds/389-ds-base/pull/7343)
- Issue [7291](https://github.com/389ds/389-ds-base/issues/7291) - Crash when configuring a replica with an incorrect nsds5ReplicaRoot [#7292](https://github.com/389ds/389-ds-base/pull/7292)
- Issue - UI - Improve suffix import LDIF table
- Issue [7325](https://github.com/389ds/389-ds-base/issues/7325) - UI - new error parser missing import
- Issue [7325](https://github.com/389ds/389-ds-base/issues/7325) - UI - create an error parser for cockpit spawn errors
- Issue [7319](https://github.com/389ds/389-ds-base/issues/7319) - Action menu for certificates remains in empty certificate list [#7320](https://github.com/389ds/389-ds-base/pull/7320)
- Issue [7265](https://github.com/389ds/389-ds-base/issues/7265) - CI - fix retro changelog maxage validation test
- Issue [7093](https://github.com/389ds/389-ds-base/issues/7093) - A password policy can be created even when an identical policy already exists [#7283](https://github.com/389ds/389-ds-base/pull/7283)
- Issue [7233](https://github.com/389ds/389-ds-base/issues/7233) - test\_produce\_division\_by\_zero fails with IsADirectoryError in conftest.py [#7234](https://github.com/389ds/389-ds-base/pull/7234)
- Issue [7271](https://github.com/389ds/389-ds-base/issues/7271) - Add new plugin pre-close function check to plugin\_invoke\_plugin\_pb
- Issue [7304](https://github.com/389ds/389-ds-base/issues/7304) - retrocl should not cache DN
- Issue [7265](https://github.com/389ds/389-ds-base/issues/7265) - Add dse modify callback to validate retrocl trimming settings
- Issue [7152](https://github.com/389ds/389-ds-base/issues/7152) - ns-slapd fails to shutdown when deferred memberof update is in progress [#7187](https://github.com/389ds/389-ds-base/pull/7187)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - ajv, minimatch [#7298](https://github.com/389ds/389-ds-base/pull/7298)
- Issue [7271](https://github.com/389ds/389-ds-base/issues/7271) - implement a pre-close plugin function
- Issue [7295](https://github.com/389ds/389-ds-base/issues/7295) - changelog max age validation cherry-pick error
- Issue [7265](https://github.com/389ds/389-ds-base/issues/7265) - changelog maxage validation is not strict enough
- Security fix for [CVE-2025-14905](https://access.redhat.com/security/cve/CVE-2025-14905)
- Issue [7273](https://github.com/389ds/389-ds-base/issues/7273) - In a chaining environment binding as remote user causes an invalid error in the logs
- Issue [7271](https://github.com/389ds/389-ds-base/issues/7271) - plugins that create threads need to update
- Issue [5853](https://github.com/389ds/389-ds-base/issues/5853) - Update concread to 0.5.10
- Issue [7053](https://github.com/389ds/389-ds-base/issues/7053) - Remove memberof\_del\_dn\_from\_groups from MemberOf plugin [#7064](https://github.com/389ds/389-ds-base/pull/7064)
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Remove integerOrderingMatch requirement for parentid [#7264](https://github.com/389ds/389-ds-base/pull/7264)
- Issue [7243](https://github.com/389ds/389-ds-base/issues/7243) - UI - fix certificate table and modal
- Issue [7066](https://github.com/389ds/389-ds-base/issues/7066)/7052 - allow password history to be set to zero and remove history
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Use lexicographical order for ancestorid [#7256](https://github.com/389ds/389-ds-base/pull/7256)
- Issue [7213](https://github.com/389ds/389-ds-base/issues/7213) - (2nd) MDB\_BAD\_VALSIZE error while handling VLV [#7258](https://github.com/389ds/389-ds-base/pull/7258)
- Issue [7184](https://github.com/389ds/389-ds-base/issues/7184) - (2nd) argparse.HelpFormatter \_format\_actions\_usage() is deprecated [#7257](https://github.com/389ds/389-ds-base/pull/7257)
- Issue - CLI - dsctl db2index needs some hardening with MBD
- Issue [7248](https://github.com/389ds/389-ds-base/issues/7248) - CLI - attribute uniqueness - fix usage for exclude subtree option
- Issue [7231](https://github.com/389ds/389-ds-base/issues/7231) - Sync repl tests fail in FIPS mode due to non FIPS compliant crypto [#7232](https://github.com/389ds/389-ds-base/pull/7232)
- Issue [7224](https://github.com/389ds/389-ds-base/issues/7224) - CI Test - Simplify test\_reserve\_descriptor\_validation [#7225](https://github.com/389ds/389-ds-base/pull/7225)
- Issue [7150](https://github.com/389ds/389-ds-base/issues/7150) - Compressed access log rotations skipped, accesslog-list out of sync [#7151](https://github.com/389ds/389-ds-base/pull/7151)
- Issue [7121](https://github.com/389ds/389-ds-base/issues/7121) - (2nd) LeakSanitizer: various leaks during replication [#7212](https://github.com/389ds/389-ds-base/pull/7212)
- Issue [6947](https://github.com/389ds/389-ds-base/issues/6947) - Fix health\_system\_indexes\_test.py
- Issue [7076](https://github.com/389ds/389-ds-base/issues/7076) - Fix revert\_cache() never called in modrdn [#7220](https://github.com/389ds/389-ds-base/pull/7220)
- Issue [7076](https://github.com/389ds/389-ds-base/issues/7076), 6992, 6784, 6214 - Fix CI test failures [#7077](https://github.com/389ds/389-ds-base/pull/7077)
- Issue [7096](https://github.com/389ds/389-ds-base/issues/7096) - (2nd) During replication online total init the function idl\_id\_is\_in\_idlist is not scaling with large database [#7205](https://github.com/389ds/389-ds-base/pull/7205)
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Add dsctl index-check command for offline index repair
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Detect and log index ordering mismatch during backend startup
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Add upgrade function to remove ancestorid index config entry
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Add upgrade function to remove nsIndexIDListScanLimit from parentid
- Issue [7223](https://github.com/389ds/389-ds-base/issues/7223) - Revert index scan limits for system indexes
- Issue [6476](https://github.com/389ds/389-ds-base/issues/6476) - Fix build failure with GCC 15
- Issue [6542](https://github.com/389ds/389-ds-base/issues/6542) - RPM build errors on Fedora 42
- Issue [7213](https://github.com/389ds/389-ds-base/issues/7213) - MDB\_BAD\_VALSIZE error while handling VLV [#7214](https://github.com/389ds/389-ds-base/pull/7214)
- Issue [7027](https://github.com/389ds/389-ds-base/issues/7027) - (2nd) 389-ds-base OpenScanHub Leaks Detected [#7211](https://github.com/389ds/389-ds-base/pull/7211)
- Issue [7184](https://github.com/389ds/389-ds-base/issues/7184) - argparse.HelpFormatter \_format\_actions\_usage() is deprecated
- Issue [7189](https://github.com/389ds/389-ds-base/issues/7189) - DSBLE0007 generates incorrect remediation commands for scan limits
- Issue [7172](https://github.com/389ds/389-ds-base/issues/7172) - (2nd) Index ordering mismatch after upgrade [#7180](https://github.com/389ds/389-ds-base/pull/7180)
- Issue [7172](https://github.com/389ds/389-ds-base/issues/7172) - Index ordering mismatch after upgrade [#7173](https://github.com/389ds/389-ds-base/pull/7173)
- Issue - Revise paged result search locking
- Issue [7096](https://github.com/389ds/389-ds-base/issues/7096) - During replication online total init the function idl\_id\_is\_in\_idlist is not scaling with large database [#7145](https://github.com/389ds/389-ds-base/pull/7145)
- Issue [7049](https://github.com/389ds/389-ds-base/issues/7049) - RetroCL plugin generates invalid LDIF
