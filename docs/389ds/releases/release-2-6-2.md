---
title: "Releases/2.6.2"
---

389 Directory Server 2.6.2
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.6.2.

The new packages and versions are:

- 389-ds-base-2.6.2

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.6.2)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.6.2/389-ds-base-2.6.2.tar.bz2>

### Highlights in 2.6.2

- Enhancements
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

Changelog between 389-ds-base-2.6.1 and 389-ds-base-2.6.2:
- Bump version to 2.6.2
- Issue [6736](https://github.com/389ds/389-ds-base/issues/6736) - Exception thrown by dsconf instance repl get\_ruv [#6742](https://github.com/389ds/389-ds-base/pull/6742)
- Issue [6819](https://github.com/389ds/389-ds-base/issues/6819) - Incorrect pwdpolicysubentry returned for an entry with user password policy
- Issue [6553](https://github.com/389ds/389-ds-base/issues/6553) - Update concread to 0.5.6 [#6824](https://github.com/389ds/389-ds-base/pull/6824)
- Issue [1081](https://github.com/389ds/389-ds-base/issues/1081) - Add a CI test [#6063](https://github.com/389ds/389-ds-base/pull/6063)
- Issue [6761](https://github.com/389ds/389-ds-base/issues/6761) - Password modify extended operation should skip password policy checks when executed by root DN
- Issue [6064](https://github.com/389ds/389-ds-base/issues/6064) - bdb2mdb shows errors [#6341](https://github.com/389ds/389-ds-base/pull/6341)
- Issue [6641](https://github.com/389ds/389-ds-base/issues/6641) - modrdn fails when a user is member of multiple groups [#6643](https://github.com/389ds/389-ds-base/pull/6643)
- Issue [6776](https://github.com/389ds/389-ds-base/issues/6776) - Enabling audit log makes slapd coredump
- Issue [6534](https://github.com/389ds/389-ds-base/issues/6534) - CI fails with Fedora 41 and DNF5
- Issue [6787](https://github.com/389ds/389-ds-base/issues/6787) - Improve error message when bulk import connection is closed
- Issue [6727](https://github.com/389ds/389-ds-base/issues/6727) - RFE - database compaction interval should be persistent
- Issue [6438](https://github.com/389ds/389-ds-base/issues/6438) - Add basic dsidm organizational unit tests
- Issue [6439](https://github.com/389ds/389-ds-base/issues/6439) - Fix dsidm service get\_dn option
- Issue [5120](https://github.com/389ds/389-ds-base/issues/5120) - ns-slapd doesn't start in referral mode [#6763](https://github.com/389ds/389-ds-base/pull/6763)
- Issue [6764](https://github.com/389ds/389-ds-base/issues/6764) - statistics about index lookup report a wrong duration [#6765](https://github.com/389ds/389-ds-base/pull/6765)
- Issue [4989](https://github.com/389ds/389-ds-base/issues/4989) - Confusing error message from dsconf plugin set --enabled [#6750](https://github.com/389ds/389-ds-base/pull/6750)
- Issue [6614](https://github.com/389ds/389-ds-base/issues/6614) - CLI - Error when trying to display global DB stats with LMDB [#6622](https://github.com/389ds/389-ds-base/pull/6622)
- Issue [6321](https://github.com/389ds/389-ds-base/issues/6321) - lib389 get\_db\_lib function may returns the wrong db type [#6322](https://github.com/389ds/389-ds-base/pull/6322)
- Issue [6276](https://github.com/389ds/389-ds-base/issues/6276) - UI - schema editing and memberof shared config not working correctly
- Issue [6734](https://github.com/389ds/389-ds-base/issues/6734) - BUG - format strings may not contain backslash [#6749](https://github.com/389ds/389-ds-base/pull/6749)
- Issue [6505](https://github.com/389ds/389-ds-base/issues/6505)- CI - backport changes for check\_value\_in\_log
- Issue [6744](https://github.com/389ds/389-ds-base/issues/6744) - BUG - memory accounting is not always enabled [#6745](https://github.com/389ds/389-ds-base/pull/6745)
- Issue [6501](https://github.com/389ds/389-ds-base/issues/6501) - CLI - dsidm role rename was not working
- Issue [6492](https://github.com/389ds/389-ds-base/issues/6492)/6493 - CLI - dsdim can not create nested/filtered roles
- Issue #6740 Certificate verify fails in FIPS mode
- Issue [5356](https://github.com/389ds/389-ds-base/issues/5356) - Set DEFAULT\_PASSWORD\_STORAGE\_SCHEME to PBKDF2-SHA512 in tests
- Issue [6603](https://github.com/389ds/389-ds-base/issues/6603) - Release tarballs ship a different Cargo.lock
- Issue [6743](https://github.com/389ds/389-ds-base/issues/6743) - CLI - dsidm add option to list DN's
- Issue [6735](https://github.com/389ds/389-ds-base/issues/6735) - CLI - dsidm provide option to set decription when creating an entry
- Issue [6059](https://github.com/389ds/389-ds-base/issues/6059) - HTML-formatted strings are displayed as is
- Bump tokio from 1.43.0 to 1.44.2 in /src [#6732](https://github.com/389ds/389-ds-base/pull/6732)
- Issue [6728](https://github.com/389ds/389-ds-base/issues/6728) - CLI - Issue with user rename operation [#6729](https://github.com/389ds/389-ds-base/pull/6729)
- Issue [6515](https://github.com/389ds/389-ds-base/issues/6515) - CLI - dsidm get\_dn does not return JSON format
- Bump openssl from 0.10.70 to 0.10.72 in /src [#6730](https://github.com/389ds/389-ds-base/pull/6730)
- Issue [6660](https://github.com/389ds/389-ds-base/issues/6660) - UI - Replication Monitoring Lag Report Feature [#6661](https://github.com/389ds/389-ds-base/pull/6661)
- Issue [6713](https://github.com/389ds/389-ds-base/issues/6713) - ns-slapd crash during mdb offline import [#6714](https://github.com/389ds/389-ds-base/pull/6714)
- Issue [6720](https://github.com/389ds/389-ds-base/issues/6720) - Remove BDB attribute from MDB DB Monitor [#6721](https://github.com/389ds/389-ds-base/pull/6721)
- Issue [6715](https://github.com/389ds/389-ds-base/issues/6715) - dsconf backend replication monitor fails if replica id starts with 0 [#6716](https://github.com/389ds/389-ds-base/pull/6716)
- Issue [6562](https://github.com/389ds/389-ds-base/issues/6562) - Fix issues around slapi\_filter\_sprintf [#6725](https://github.com/389ds/389-ds-base/pull/6725)
- Issue [6481](https://github.com/389ds/389-ds-base/issues/6481) - When ports that are in use are used to update a DS instance the error message is not helpful [#6723](https://github.com/389ds/389-ds-base/pull/6723)
- Issue [6626](https://github.com/389ds/389-ds-base/issues/6626) - Ignore replica busy condition in healthcheck [#6630](https://github.com/389ds/389-ds-base/pull/6630)
- Issue [6693](https://github.com/389ds/389-ds-base/issues/6693) - Fix error messages inconsistencies [#6694](https://github.com/389ds/389-ds-base/pull/6694)
- Issue [6464](https://github.com/389ds/389-ds-base/issues/6464) - UI - Fixed spelling in cockpit messages  
- Issue [6672](https://github.com/389ds/389-ds-base/issues/6672) - Fix test - clu/dbscan\_test.py::test\_dbscan\_destructive\_actions fails on BDB [#6717](https://github.com/389ds/389-ds-base/pull/6717)
- Issue [6700](https://github.com/389ds/389-ds-base/issues/6700) - CLI/UI - include superior objectclasses' allowed and requires attrs
- Issue [6710](https://github.com/389ds/389-ds-base/issues/6710) - test\_vlv\_scope\_one\_on\_two\_backends fails in 2.6 [#6711](https://github.com/389ds/389-ds-base/pull/6711)
- Issue [6571](https://github.com/389ds/389-ds-base/issues/6571) - (2nd) Nested group does not receive memberOf attribute [#6697](https://github.com/389ds/389-ds-base/pull/6697)
- Issue [6686](https://github.com/389ds/389-ds-base/issues/6686) - CLI - Re-enabling user accounts that reached inactivity limit fails with error [#6687](https://github.com/389ds/389-ds-base/pull/6687)
- Issue [6288](https://github.com/389ds/389-ds-base/issues/6288) - dsidm crash with account policy when alt-state-attr is disabled [#6292](https://github.com/389ds/389-ds-base/pull/6292)
- Issue [6617](https://github.com/389ds/389-ds-base/issues/6617) - test\_vlv\_as\_freeipa\_backup\_restore fails [#6618](https://github.com/389ds/389-ds-base/pull/6618)
- Issue [6704](https://github.com/389ds/389-ds-base/issues/6704) - UI - Add error log buffering config
- Issue [6698](https://github.com/389ds/389-ds-base/issues/6698) - NPE after configuring invalid filtered role [#6699](https://github.com/389ds/389-ds-base/pull/6699)
- Issue [6695](https://github.com/389ds/389-ds-base/issues/6695) - UI - fix more minor issues
- Security fix for [CVE-2025-2487](https://access.redhat.com/security/cve/CVE-2025-2487)
- Issue [6500](https://github.com/389ds/389-ds-base/issues/6500) - Fix covscan and ASAN issue
- Issue [6571](https://github.com/389ds/389-ds-base/issues/6571) - Nested group does not receive memberOf attribute [#6679](https://github.com/389ds/389-ds-base/pull/6679)
- Issue [6676](https://github.com/389ds/389-ds-base/issues/6676) - Add GitHub workflow action and fix pbkdf2 tests [#6677](https://github.com/389ds/389-ds-base/pull/6677)
- Issue [6623](https://github.com/389ds/389-ds-base/issues/6623) - UI - Generic updates [#6624](https://github.com/389ds/389-ds-base/pull/6624)
- Issue [6665](https://github.com/389ds/389-ds-base/issues/6665) - UI - Need to refresh log settings after saving
- Issue [6568](https://github.com/389ds/389-ds-base/issues/6568) - Fix failing webUI tests
- Issue [6090](https://github.com/389ds/389-ds-base/issues/6090) - dbscan: use bdb by default
- Issue [6656](https://github.com/389ds/389-ds-base/issues/6656) - UI - Enhance Monitor Log Viewer with Patternfly LogViewer component [#6657](https://github.com/389ds/389-ds-base/pull/6657)
- Issue [6655](https://github.com/389ds/389-ds-base/issues/6655) - fix replication release replica decoding error
- Issue  6653 - Cleanup error messages
- Issue [6429](https://github.com/389ds/389-ds-base/issues/6429) - UI - clicking on a database suffix under the Monitor tab crashes UI [#6610](https://github.com/389ds/389-ds-base/pull/6610)
- Issue [6632](https://github.com/389ds/389-ds-base/issues/6632) - Replication init fails with ASAN build
- Issue [6436](https://github.com/389ds/389-ds-base/issues/6436) - MOD on a large group slow if substring index is present [#6437](https://github.com/389ds/389-ds-base/pull/6437)
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - various fixes part 3
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - fix next round of bugs
- Issue [6625](https://github.com/389ds/389-ds-base/issues/6625) - UI - fix various issues with LDAP browser, etc
- Issue [6553](https://github.com/389ds/389-ds-base/issues/6553) - Update concread to 0.5.4 and refactor statistics tracking [#6607](https://github.com/389ds/389-ds-base/pull/6607)
- Bump esbuild from 0.24.0 to 0.25.0 in /src/cockpit/389-console [#6602](https://github.com/389ds/389-ds-base/pull/6602)
- Issue [6207](https://github.com/389ds/389-ds-base/issues/6207) - Random crash in test\_long\_rdn CI test [#6215](https://github.com/389ds/389-ds-base/pull/6215)
- Issue [6561](https://github.com/389ds/389-ds-base/issues/6561) - TLS 1.2 stickiness in FIPS mode
- Issue [6554](https://github.com/389ds/389-ds-base/issues/6554) - During import of entries without nsUniqueId, a supplier generates duplicate nsUniqueId (LMDB only) [#6582](https://github.com/389ds/389-ds-base/pull/6582)
- Issue [6229](https://github.com/389ds/389-ds-base/issues/6229) - After an initial failure, subsequent online backups fail [#6230](https://github.com/389ds/389-ds-base/pull/6230)
- Bump openssl from 0.10.66 to 0.10.70 in /src
- Issue [6258](https://github.com/389ds/389-ds-base/issues/6258) - Mitigate race condition in paged\_results\_test.py [#6433](https://github.com/389ds/389-ds-base/pull/6433) 
- Issue [6566](https://github.com/389ds/389-ds-base/issues/6566) - RI plugin failure to handle a modrdn for rename of member of multiple groups [#6567](https://github.com/389ds/389-ds-base/pull/6567)
- Issue [6489](https://github.com/389ds/389-ds-base/issues/6489) - After log rotation refresh the FD pointer
- Issue [6375](https://github.com/389ds/389-ds-base/issues/6375) - UI - Update cockpit.js code to the latest version [#6376](https://github.com/389ds/389-ds-base/pull/6376)
- Issue [6465](https://github.com/389ds/389-ds-base/issues/6465) - Create optional meta-package for replication reporting dependencies [#6560](https://github.com/389ds/389-ds-base/pull/6560)
- Issue [6090](https://github.com/389ds/389-ds-base/issues/6090) - Fix dbscan options and man pages [#6315](https://github.com/389ds/389-ds-base/pull/6315)
- Revert "Issue [6090](https://github.com/389ds/389-ds-base/issues/6090) - Fix dbscan options and man pages [#6315](https://github.com/389ds/389-ds-base/pull/6315)"
- Issue [6090](https://github.com/389ds/389-ds-base/issues/6090) - Fix dbscan options and man pages [#6315](https://github.com/389ds/389-ds-base/pull/6315)
- Issue [6374](https://github.com/389ds/389-ds-base/issues/6374) - nsslapd-mdb-max-dbs autotuning doesn't work properly [#6400](https://github.com/389ds/389-ds-base/pull/6400)
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - Fix building for older versions of Python
- Issue [4815](https://github.com/389ds/389-ds-base/issues/4815) - RFE - Add Replication Log Analysis Tool with CLI Support [#6466](https://github.com/389ds/389-ds-base/pull/6466)
- Issue [6446](https://github.com/389ds/389-ds-base/issues/6446) - Fix test\_acct\_policy\_consumer test to wait enough for lastLoginHistory update [#6530](https://github.com/389ds/389-ds-base/pull/6530)

