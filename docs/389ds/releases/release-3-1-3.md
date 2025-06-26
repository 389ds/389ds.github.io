---
title: "Releases/3.1.3"
last_modified_at: 2020-01-01 10:00:00
---

389 Directory Server 3.1.3
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.1.3.

Fedora packages are available on Fedora 42:

<https://koji.fedoraproject.org/koji/buildinfo?buildID=2744383> - Koji
<br>
<https://bodhi.fedoraproject.org/updates/FEDORA-2025-d29c5b8a34> - Bodhi

The new packages and versions are:

- 389-ds-base-3.1.3

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.1.3)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.1.3/389-ds-base-3.1.3.tar.bz2>

### Highlights in 3.1.3

- Enhancements
  - Issue [6755](https://github.com/389ds/389-ds-base/issues/6755) - RFE use of Session Tracking Control in replication agreement [#6766](https://github.com/389ds/389-ds-base/pull/6766)
  - Issue [6727](https://github.com/389ds/389-ds-base/issues/6727) - RFE - database compaction interval should be persistent
  - Issue [6663](https://github.com/389ds/389-ds-base/issues/6663) - RFE - Add option to write error log in JSON
  - Issue [4815](https://github.com/389ds/389-ds-base/issues/4815) - RFE - Add Replication Log Analysis Tool with CLI Support [#6466](https://github.com/389ds/389-ds-base/pull/6466)
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

Changelog between 389-ds-base-3.1.2 and 389-ds-base-3.1.3:
- Bump version to 3.1.3
- Issue [6825](https://github.com/389ds/389-ds-base/issues/6825) - RootDN Access Control Plugin with wildcards for IP addre… [#6826](https://github.com/389ds/389-ds-base/pull/6826)
- Issue [6767](https://github.com/389ds/389-ds-base/issues/6767) - Package lib389 on PyPI [#6786](https://github.com/389ds/389-ds-base/pull/6786)
- Issue [6819](https://github.com/389ds/389-ds-base/issues/6819) - Incorrect pwdpolicysubentry returned for an entry with user password policy
- Issue [6553](https://github.com/389ds/389-ds-base/issues/6553) - Update concread to 0.5.6 [#6824](https://github.com/389ds/389-ds-base/pull/6824)
- Issue [6758](https://github.com/389ds/389-ds-base/issues/6758) - Fix failing webUI tests
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 47640 test
- Issue [1081](https://github.com/389ds/389-ds-base/issues/1081) - Add a CI test [#6063](https://github.com/389ds/389-ds-base/pull/6063)
- Issue [6761](https://github.com/389ds/389-ds-base/issues/6761) - Password modify extended operation should skip password policy checks when executed by root DN
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket test 48026
- Issue [6791](https://github.com/389ds/389-ds-base/issues/6791) - crash in liblmdb during instance shutdown [#6793](https://github.com/389ds/389-ds-base/pull/6793)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket test 48370
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket test 48233
- Issue [6755](https://github.com/389ds/389-ds-base/issues/6755) - RFE use of Session Tracking Control in replication agreement [#6766](https://github.com/389ds/389-ds-base/pull/6766)
- Issue [6641](https://github.com/389ds/389-ds-base/issues/6641) - modrdn fails when a user is member of multiple groups [#6643](https://github.com/389ds/389-ds-base/pull/6643)
- Issue [6776](https://github.com/389ds/389-ds-base/issues/6776) - Enabling audit log makes slapd coredump
- Issue [6534](https://github.com/389ds/389-ds-base/issues/6534) - CI fails with Fedora 41 and DNF5
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket test 47619
- Issue [6787](https://github.com/389ds/389-ds-base/issues/6787) - Improve error message when bulk import connection is closed
- Issue [6778](https://github.com/389ds/389-ds-base/issues/6778) - Memory leak in roles\_cache\_create\_object\_from\_entry
- Issue [4253](https://github.com/389ds/389-ds-base/issues/4253) - Container bind mount schema
- Issue [6727](https://github.com/389ds/389-ds-base/issues/6727) - RFE - database compaction interval should be persistent
- Issue [5120](https://github.com/389ds/389-ds-base/issues/5120) - ns-slapd doesn't start in referral mode [#6763](https://github.com/389ds/389-ds-base/pull/6763)
- Issue [6764](https://github.com/389ds/389-ds-base/issues/6764) - statistics about index lookup report a wrong duration [#6765](https://github.com/389ds/389-ds-base/pull/6765)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket test 47560
- Issue [4989](https://github.com/389ds/389-ds-base/issues/4989) - Confusing error message from dsconf plugin set --enabled [#6750](https://github.com/389ds/389-ds-base/pull/6750)
- Issue [6614](https://github.com/389ds/389-ds-base/issues/6614) - CLI - Error when trying to display global DB stats with LMDB [#6622](https://github.com/389ds/389-ds-base/pull/6622)
- Issue [6276](https://github.com/389ds/389-ds-base/issues/6276) - UI - schema editing and memberof shared config not working correctly
- Issue [6734](https://github.com/389ds/389-ds-base/issues/6734) - BUG - format strings may not contain backslash [#6749](https://github.com/389ds/389-ds-base/pull/6749)
- Issue [6736](https://github.com/389ds/389-ds-base/issues/6736) - Exception thrown by dsconf instance repl get\_ruv [#6742](https://github.com/389ds/389-ds-base/pull/6742)
- Issue [6501](https://github.com/389ds/389-ds-base/issues/6501) - CLI - dsidm role rename was not working
- Issue [6744](https://github.com/389ds/389-ds-base/issues/6744) - BUG - memory accounting is not always enabled [#6745](https://github.com/389ds/389-ds-base/pull/6745)
- Issue [6492](https://github.com/389ds/389-ds-base/issues/6492)/6493 - CLI - dsdim can not create nested/filtered roles
- Issue #6740 Certificate verify fails in FIPS mode
- Issue [6603](https://github.com/389ds/389-ds-base/issues/6603) - Release tarballs ship a different Cargo.lock
- Issue [6743](https://github.com/389ds/389-ds-base/issues/6743) - CLI - dsidm add option to list DN's
- Issue [6595](https://github.com/389ds/389-ds-base/issues/6595) - Regression test in betxn\_test.py failing due to busy LDAP server [#6709](https://github.com/389ds/389-ds-base/pull/6709)
- Issue [6669](https://github.com/389ds/389-ds-base/issues/6669) - logconv.py updates [#6673](https://github.com/389ds/389-ds-base/pull/6673)
- Issue [5356](https://github.com/389ds/389-ds-base/issues/5356) - Set DEFAULT\_PASSWORD\_STORAGE\_SCHEME to PBKDF2-SHA512 in tests
- Issue [6735](https://github.com/389ds/389-ds-base/issues/6735) - CLI - dsidm provide option to set decription when creating an entry
- Bump tokio from 1.43.0 to 1.44.2 in /src [#6732](https://github.com/389ds/389-ds-base/pull/6732)
- Issue [6728](https://github.com/389ds/389-ds-base/issues/6728) - CLI - Issue with user rename operation [#6729](https://github.com/389ds/389-ds-base/pull/6729)
- Issue [6515](https://github.com/389ds/389-ds-base/issues/6515) - CLI - dsidm get\_dn does not return JSON format
- Issue [6660](https://github.com/389ds/389-ds-base/issues/6660) - UI - Replication Monitoring Lag Report Feature [#6661](https://github.com/389ds/389-ds-base/pull/6661)
- Bump openssl from 0.10.70 to 0.10.72 in /src [#6730](https://github.com/389ds/389-ds-base/pull/6730)
- Issue [6713](https://github.com/389ds/389-ds-base/issues/6713) - ns-slapd crash during mdb offline import [#6714](https://github.com/389ds/389-ds-base/pull/6714)
- Issue [6720](https://github.com/389ds/389-ds-base/issues/6720) - Remove BDB attribute from MDB DB Monitor [#6721](https://github.com/389ds/389-ds-base/pull/6721)
- Issue [6715](https://github.com/389ds/389-ds-base/issues/6715) - dsconf backend replication monitor fails if replica id starts with 0 [#6716](https://github.com/389ds/389-ds-base/pull/6716)
- Issue [6562](https://github.com/389ds/389-ds-base/issues/6562) - Fix issues around slapi\_filter\_sprintf [#6725](https://github.com/389ds/389-ds-base/pull/6725)
- Issue [6481](https://github.com/389ds/389-ds-base/issues/6481) - When ports that are in use are used to update a DS instance the error message is not helpful [#6723](https://github.com/389ds/389-ds-base/pull/6723)
- lib389: Remove unused runtime requirement on setuptools [#6719](https://github.com/389ds/389-ds-base/pull/6719)
- Issue [6700](https://github.com/389ds/389-ds-base/issues/6700) - CLI/UI - include superior objectclasses' allowed and requires attrs
- Issue [6571](https://github.com/389ds/389-ds-base/issues/6571) - (2nd) Nested group does not receive memberOf attribute [#6697](https://github.com/389ds/389-ds-base/pull/6697)
- Issue [6686](https://github.com/389ds/389-ds-base/issues/6686) - CLI - Re-enabling user accounts that reached inactivity limit fails with error [#6687](https://github.com/389ds/389-ds-base/pull/6687)
- Issue [6704](https://github.com/389ds/389-ds-base/issues/6704) - UI - Add error log buffering config
- Issue [6698](https://github.com/389ds/389-ds-base/issues/6698) - NPE after configuring invalid filtered role [#6699](https://github.com/389ds/389-ds-base/pull/6699)
- Issue [6695](https://github.com/389ds/389-ds-base/issues/6695) - UI - fix more minor issues
- Issue [6693](https://github.com/389ds/389-ds-base/issues/6693) - Fix error messages inconsistencies [#6694](https://github.com/389ds/389-ds-base/pull/6694)
- Security fix for [CVE-2025-2487](https://access.redhat.com/security/cve/CVE-2025-2487)
- Issue [6500](https://github.com/389ds/389-ds-base/issues/6500) - Fix covscan and ASAN issue
- Issue [6571](https://github.com/389ds/389-ds-base/issues/6571) - Nested group does not receive memberOf attribute [#6679](https://github.com/389ds/389-ds-base/pull/6679)
- Issue [6676](https://github.com/389ds/389-ds-base/issues/6676) - Add GitHub workflow action and fix pbkdf2 tests [#6677](https://github.com/389ds/389-ds-base/pull/6677)
- Issue [6671](https://github.com/389ds/389-ds-base/issues/6671) - tombstone\_fixup\_test sometime fails on bdb
- Issue [6680](https://github.com/389ds/389-ds-base/issues/6680) - instance read-only mode is broken [#6681](https://github.com/389ds/389-ds-base/pull/6681)
- Issue [6683](https://github.com/389ds/389-ds-base/issues/6683) - test\_healthcheck\_replication\_out\_of\_sync\_broken mail fail [#6684](https://github.com/389ds/389-ds-base/pull/6684)
- Ignore replica busy condition in healthcheck [#6630](https://github.com/389ds/389-ds-base/pull/6630)
- Issue [6613](https://github.com/389ds/389-ds-base/issues/6613) - test\_reindex\_task\_creates\_abandoned\_index\_file fails [#6674](https://github.com/389ds/389-ds-base/pull/6674)
- Issue [6663](https://github.com/389ds/389-ds-base/issues/6663) - CLI - add error log JSON settings to dsconf
- Issue [6663](https://github.com/389ds/389-ds-base/issues/6663) - RFE - Add option to write error log in JSON
- Issue [6665](https://github.com/389ds/389-ds-base/issues/6665) - UI - Need to refresh log settings after saving
- Issue [6639](https://github.com/389ds/389-ds-base/issues/6639) - Fix crash in upgrade when removing subtree name attribute
- Issue [6656](https://github.com/389ds/389-ds-base/issues/6656) - UI - Enhance Monitor Log Viewer with Patternfly LogViewer component [#6657](https://github.com/389ds/389-ds-base/pull/6657)
- Issue [6655](https://github.com/389ds/389-ds-base/issues/6655) - fix replication release replica decoding error
- Issue  6653 - Cleanup error messages
- Issue [6639](https://github.com/389ds/389-ds-base/issues/6639) - remove all the code related to entryrdn\_get\_switch
- Issue [6429](https://github.com/389ds/389-ds-base/issues/6429) - UI - clicking on a database suffix under the Monitor tab crashes UI [#6610](https://github.com/389ds/389-ds-base/pull/6610)
- Issue [6632](https://github.com/389ds/389-ds-base/issues/6632) - Replication init fails with ASAN build
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - various fixes part 3
- Revert "Issue #6562 - Prevent undefined behaviour in in filter\_stuff\_func [#6563](https://github.com/389ds/389-ds-base/pull/6563)" [#6563](https://github.com/389ds/389-ds-base/pull/6563)
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - fix next round of bugs
- Issue [6599](https://github.com/389ds/389-ds-base/issues/6599) - Access JSON logging - lib389/CI/minor fixes
- Issue #6562 - Prevent undefined behaviour in in filter\_stuff\_func [#6563](https://github.com/389ds/389-ds-base/pull/6563)
- Bump esbuild from 0.24.0 to 0.25.0 in /src/cockpit/389-console [#6602](https://github.com/389ds/389-ds-base/pull/6602)
- Issue [6327](https://github.com/389ds/389-ds-base/issues/6327) - Fix incorrect sizeof() usage for pointer in get\_ip\_str() function [#6629](https://github.com/389ds/389-ds-base/pull/6629)
- Issue [6553](https://github.com/389ds/389-ds-base/issues/6553) - Update concread to 0.5.4 and refactor statistics tracking [#6607](https://github.com/389ds/389-ds-base/pull/6607)
- Issue [6619](https://github.com/389ds/389-ds-base/issues/6619) - test\_dblib\_migration fails on RHEL10 [#6620](https://github.com/389ds/389-ds-base/pull/6620)
- Issue [6617](https://github.com/389ds/389-ds-base/issues/6617) - test\_vlv\_as\_freeipa\_backup\_restore fails [#6618](https://github.com/389ds/389-ds-base/pull/6618)
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - fix various issues with LDAP browser, etc
- Issue [6623](https://github.com/389ds/389-ds-base/issues/6623) - UI - Generic updates [#6624](https://github.com/389ds/389-ds-base/pull/6624)
- Issue [6615](https://github.com/389ds/389-ds-base/issues/6615) - test\_custom\_path CI test fails [#6616](https://github.com/389ds/389-ds-base/pull/6616)
- Issue [6604](https://github.com/389ds/389-ds-base/issues/6604) - Fix coverity scan issues CID 1591261 - CID 1591269 [#6605](https://github.com/389ds/389-ds-base/pull/6605)
- Issue [6611](https://github.com/389ds/389-ds-base/issues/6611) - db\_home\_test.py CI tests should be skipped on lmdb [#6612](https://github.com/389ds/389-ds-base/pull/6612)
- Issue [6561](https://github.com/389ds/389-ds-base/issues/6561) - TLS 1.2 stickiness in FIPS mode
- Issue [6599](https://github.com/389ds/389-ds-base/issues/6599) - Implement option to write access log in jSON
- Issue [6596](https://github.com/389ds/389-ds-base/issues/6596) - BUG - Compilation Regresion [#6597](https://github.com/389ds/389-ds-base/pull/6597)
- Issue [6554](https://github.com/389ds/389-ds-base/issues/6554) - During import of entries without nsUniqueId, a supplier generates duplicate nsUniqueId (LMDB only) [#6582](https://github.com/389ds/389-ds-base/pull/6582)
- Issue [6555](https://github.com/389ds/389-ds-base/issues/6555) - V2 - Potential crash when deleting a replicated backend [#6585](https://github.com/389ds/389-ds-base/pull/6585)
- Issue [6574](https://github.com/389ds/389-ds-base/issues/6574) - Move pblock access from switch to func table
- Bump openssl from 0.10.66 to 0.10.70 in /src
- Issue [6566](https://github.com/389ds/389-ds-base/issues/6566) - RI plugin failure to handle a modrdn for rename of member of multiple groups [#6567](https://github.com/389ds/389-ds-base/pull/6567)
- Issue [6568](https://github.com/389ds/389-ds-base/issues/6568) - Fix failing webUI tests
- Issue [6489](https://github.com/389ds/389-ds-base/issues/6489) - After log rotation refresh the FD pointer
- Issue [6465](https://github.com/389ds/389-ds-base/issues/6465) - Create optional meta-package for replication reporting dependencies [#6560](https://github.com/389ds/389-ds-base/pull/6560)
- Issue [6555](https://github.com/389ds/389-ds-base/issues/6555) - Potential crash when deleting a replicated backend [#6559](https://github.com/389ds/389-ds-base/pull/6559)
- Issue [6436](https://github.com/389ds/389-ds-base/issues/6436) - MOD on a large group slow if substring index is present [#6437](https://github.com/389ds/389-ds-base/pull/6437)
- Issue [6476](https://github.com/389ds/389-ds-base/issues/6476) - Fix build failure with GCC 15
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - Fix building for older versions of Python
- Issue [4815](https://github.com/389ds/389-ds-base/issues/4815) - RFE - Add Replication Log Analysis Tool with CLI Support [#6466](https://github.com/389ds/389-ds-base/pull/6466)
- Issue [6544](https://github.com/389ds/389-ds-base/issues/6544) - logconv.py: python3-magic conflicts with python3-file-magic
- Issue [4596](https://github.com/389ds/389-ds-base/issues/4596) - Build with clang/lld fails when LTO enabled
- Issue [4596](https://github.com/389ds/389-ds-base/issues/4596) - BUG - lto linking issues
- Issue [6542](https://github.com/389ds/389-ds-base/issues/6542) - RPM build errors on Fedora 42
- Issue [6446](https://github.com/389ds/389-ds-base/issues/6446) - Fix test\_acct\_policy\_consumer test to wait enough for lastLoginHistory update [#6530](https://github.com/389ds/389-ds-base/pull/6530)

