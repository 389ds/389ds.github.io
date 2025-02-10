---
title: "Releases/3.1.2"
---

389 Directory Server 3.1.2
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.1.2.

The new packages and versions are:

- 389-ds-base-3.1.2

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.1.2)

- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.1.2/389-ds-base-3.1.2.tar.bz2>

### Highlights in 3.1.2

- Enhancements
  - Issue [3342](https://github.com/389ds/389-ds-base/issues/3342) - RFE logconv.pl should have a replacement in CLI tools [#6444](https://github.com/389ds/389-ds-base/pull/6444)
  - Issue [6269](https://github.com/389ds/389-ds-base/issues/6269) - RFE - Add nsslapd-pwdPBKDF2Rounds configuration to PBKDF2-* plugins [#6447](https://github.com/389ds/389-ds-base/pull/6447)
  - Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - RFE - CLI - Add logging settings to dsconf
  - Issue [6367](https://github.com/389ds/389-ds-base/issues/6367) - RFE support of Session Tracking Control internet draft [#6403](https://github.com/389ds/389-ds-base/pull/6403)
  - Issue [6340](https://github.com/389ds/389-ds-base/issues/6340) - RFE - extract keys once [#6413](https://github.com/389ds/389-ds-base/pull/6413)
  - Issue [6349](https://github.com/389ds/389-ds-base/issues/6349) - RFE - Use previously extracted key path [#6363](https://github.com/389ds/389-ds-base/pull/6363)
  - Issue [6304](https://github.com/389ds/389-ds-base/issues/6304) - RFE when memberof is enabled, defer updates of members from the update of the group [#6305](https://github.com/389ds/389-ds-base/pull/6305)
  - Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - Add log buffering for error log

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

Changelog between 389-ds-base-3.1.1 and 389-ds-base-3.1.2:

- Bump version to 3.1.2
- Issue [3342](https://github.com/389ds/389-ds-base/issues/3342) - RFE logconv.pl should have a replacement in CLI tools [#6444](https://github.com/389ds/389-ds-base/pull/6444)
- Issue [6531](https://github.com/389ds/389-ds-base/issues/6531) - Fix CI Tests - Decrease mdb map size for large topologies [#6532](https://github.com/389ds/389-ds-base/pull/6532)
- Issue [6359](https://github.com/389ds/389-ds-base/issues/6359) - Fix incorrect License tag
- Issue [6424](https://github.com/389ds/389-ds-base/issues/6424) - Filling in dsidm group tests
- Issue [6516](https://github.com/389ds/389-ds-base/issues/6516) - Allow to configure the password scheme not updated on bind [#6517](https://github.com/389ds/389-ds-base/pull/6517)
- Issue [6521](https://github.com/389ds/389-ds-base/issues/6521) - Typo in dsidm (unique)group add\_member prompt
- Issue [6523](https://github.com/389ds/389-ds-base/issues/6523) - dsidm uniquegroup members not implemented
- Issue [6513](https://github.com/389ds/389-ds-base/issues/6513) - Add basic dsidm uniquegroup tests
- Issue [6525](https://github.com/389ds/389-ds-base/issues/6525) - Fix srpm generation in COPR
- Issue [6505](https://github.com/389ds/389-ds-base/issues/6505) - Add basic dsidm role tests
- Issue [6509](https://github.com/389ds/389-ds-base/issues/6509) - Race condition with Paged Result searches
- Issue [6507](https://github.com/389ds/389-ds-base/issues/6507) - changelog modifiers operation not displayed in dbscan [#6511](https://github.com/389ds/389-ds-base/pull/6511)
- Issue [6453](https://github.com/389ds/389-ds-base/issues/6453) - (cont) Fix memory leaks in entryrdn [#6504](https://github.com/389ds/389-ds-base/pull/6504)
- Issue [6481](https://github.com/389ds/389-ds-base/issues/6481) - UI - When ports that are in use are used to update a DS instance the error message is not helpful [#6482](https://github.com/389ds/389-ds-base/pull/6482)
- Issue [6497](https://github.com/389ds/389-ds-base/issues/6497) - lib389 - Configure replication for multiple suffixes [#6498](https://github.com/389ds/389-ds-base/pull/6498)
- Issue [6470](https://github.com/389ds/389-ds-base/issues/6470) - Some replication status data are reset upon a restart [#6471](https://github.com/389ds/389-ds-base/pull/6471)
- Issue [6453](https://github.com/389ds/389-ds-base/issues/6453) - Fix memory leaks in entryrdn
- Issue [6490](https://github.com/389ds/389-ds-base/issues/6490) - Add a new macro function and print rounds on startup [#6496](https://github.com/389ds/389-ds-base/pull/6496)
- Issue [6494](https://github.com/389ds/389-ds-base/issues/6494) - Various errors when using extended matching rule on vlv sort filter [#6495](https://github.com/389ds/389-ds-base/pull/6495)
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - (3rd) If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6480](https://github.com/389ds/389-ds-base/pull/6480)
- Issue [6490](https://github.com/389ds/389-ds-base/issues/6490) - Remove the rust error log message for pbkdf2 rounds
- Issue [6485](https://github.com/389ds/389-ds-base/issues/6485) - Fix double free in USN cleanup task
- Issue [6483](https://github.com/389ds/389-ds-base/issues/6483) - CI - fix filter\_test - test\_match\_large\_valueset
- Issue [6269](https://github.com/389ds/389-ds-base/issues/6269) - RFE - Add nsslapd-pwdPBKDF2Rounds configuration to PBKDF2-* plugins [#6447](https://github.com/389ds/389-ds-base/pull/6447)
- Issue [6478](https://github.com/389ds/389-ds-base/issues/6478) - fix compilation warning related to deferred memberof delay [#6479](https://github.com/389ds/389-ds-base/pull/6479)
- Issue [6372](https://github.com/389ds/389-ds-base/issues/6372) - Deadlock while doing online backup [#6475](https://github.com/389ds/389-ds-base/pull/6475)
- Issue [6438](https://github.com/389ds/389-ds-base/issues/6438) - Add basic dsidm organizational unit tests
- Issue [6439](https://github.com/389ds/389-ds-base/issues/6439) - Fix dsidm service get\_dn option
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - CLI - Remove security log settings that don't exist
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - RFE - CLI - Add logging settings to dsconf
- Issue [6472](https://github.com/389ds/389-ds-base/issues/6472) - CLI - Improve error message format
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - (2nd) If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6460](https://github.com/389ds/389-ds-base/pull/6460)
- Issue [6459](https://github.com/389ds/389-ds-base/issues/6459) - crash on 3.0/3.1 branch [#6461](https://github.com/389ds/389-ds-base/pull/6461)
- Issue [6368](https://github.com/389ds/389-ds-base/issues/6368) - Fix crash when testing access json logging
- Issue [6464](https://github.com/389ds/389-ds-base/issues/6464) - UI - Fixed spelling in cockpit messages  
- PR 6462 - UI - Fix spelling error in cockpit-389-ds certificateManagement.jsx
- Issue [6441](https://github.com/389ds/389-ds-base/issues/6441) - Add basic dsidm posixgroup tests
- Issue [6442](https://github.com/389ds/389-ds-base/issues/6442) - Fix latest covscan memory leaks (part 2)
- Issue [6442](https://github.com/389ds/389-ds-base/issues/6442) - Fix latest covscan memory leaks
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix issues reported by npm audit
- Issue [6368](https://github.com/389ds/389-ds-base/issues/6368) - fix basic test suite
- Issue [6446](https://github.com/389ds/389-ds-base/issues/6446) - on replica consumer, account policy plugin fails to manage the last login history [#6448](https://github.com/389ds/389-ds-base/pull/6448)
- Issue [6424](https://github.com/389ds/389-ds-base/issues/6424) - Add basic dsidm group tests
- Issue [6258](https://github.com/389ds/389-ds-base/issues/6258) - Mitigate race condition in paged\_results\_test.py [#6433](https://github.com/389ds/389-ds-base/pull/6433)
- Issue [6432](https://github.com/389ds/389-ds-base/issues/6432) - Crash during bind when acct policy plugin does not have "alwaysrecordlogin" set
- Issue [5798](https://github.com/389ds/389-ds-base/issues/5798) - Fix dsconf config multi-valued attr operations [#6426](https://github.com/389ds/389-ds-base/pull/6426)
- Issue [6302](https://github.com/389ds/389-ds-base/issues/6302) - Allow to run replication status without a prompt [#6410](https://github.com/389ds/389-ds-base/pull/6410)
- Issue [6368](https://github.com/389ds/389-ds-base/issues/6368) - UI - fix regression with onChange parameters for new
- Issue  6268 - write access log format infrastructure (part 1)
- Issue [6427](https://github.com/389ds/389-ds-base/issues/6427) - fix various memory leaks
- Issue [6375](https://github.com/389ds/389-ds-base/issues/6375) - UI - Update cockpit.js code to the latest version [#6376](https://github.com/389ds/389-ds-base/pull/6376)
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6418](https://github.com/389ds/389-ds-base/pull/6418)
- Issue [6367](https://github.com/389ds/389-ds-base/issues/6367) - RFE support of Session Tracking Control internet draft [#6403](https://github.com/389ds/389-ds-base/pull/6403)
- Issue [6422](https://github.com/389ds/389-ds-base/issues/6422) - test\_db\_home\_dir\_online\_backup CI test break other tests [#6423](https://github.com/389ds/389-ds-base/pull/6423)
- Issue [6340](https://github.com/389ds/389-ds-base/issues/6340) - RFE - extract keys once [#6413](https://github.com/389ds/389-ds-base/pull/6413)
- Issue [6415](https://github.com/389ds/389-ds-base/issues/6415) - BUG - Incorrect icu linking [#6416](https://github.com/389ds/389-ds-base/pull/6416)
- Issue [6420](https://github.com/389ds/389-ds-base/issues/6420) - Update dsidm user get\_dn test [#6421](https://github.com/389ds/389-ds-base/pull/6421)
- Issue [6258](https://github.com/389ds/389-ds-base/issues/6258) - Resolve race condition for two tests in health\_config.py
- Bump cross-spawn from 7.0.3 to 7.0.6 in /src/cockpit/389-console [#6407](https://github.com/389ds/389-ds-base/pull/6407)
- Issue [6386](https://github.com/389ds/389-ds-base/issues/6386) - backup/restore broken after db log rotation [#6406](https://github.com/389ds/389-ds-base/pull/6406)
- Issue [6401](https://github.com/389ds/389-ds-base/issues/6401) - Remove logging macros
- Issue [6404](https://github.com/389ds/389-ds-base/issues/6404) - UI - Add npm pretter package
- Issue [6374](https://github.com/389ds/389-ds-base/issues/6374) - nsslapd-mdb-max-dbs autotuning doesn't work properly [#6400](https://github.com/389ds/389-ds-base/pull/6400)
- Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - Add log buffering for error log
- Issue [6397](https://github.com/389ds/389-ds-base/issues/6397) - Remove deprecated setting for HR time stamps in logs
- Issue [6390](https://github.com/389ds/389-ds-base/issues/6390) - Adjust cleanAllRUV max per txn and interval limits
- Issue [6349](https://github.com/389ds/389-ds-base/issues/6349) - RFE - extract keys once [#6363](https://github.com/389ds/389-ds-base/pull/6363) [#6363](https://github.com/389ds/389-ds-base/pull/6363)
- Issue [6387](https://github.com/389ds/389-ds-base/issues/6387) - Use make macro in the spec file
- Issue [6359](https://github.com/389ds/389-ds-base/issues/6359) - Add exception to GPL license in license tag
- Issue [6381](https://github.com/389ds/389-ds-base/issues/6381) - CleanAllRUV - move changelog purging to the very end of the task
- Issue [5920](https://github.com/389ds/389-ds-base/issues/5920) - pamModuleIsThreadSafe is missing in the schema
- Issue [6377](https://github.com/389ds/389-ds-base/issues/6377) - syntax error in setup.py [#6378](https://github.com/389ds/389-ds-base/pull/6378)
- Issue [6349](https://github.com/389ds/389-ds-base/issues/6349) - RFE - Use previously extracted key path [#6363](https://github.com/389ds/389-ds-base/pull/6363)
- Issue [6067](https://github.com/389ds/389-ds-base/issues/6067) - Update dsidm to prioritize basedn from .dsrc over interactive input [#6362](https://github.com/389ds/389-ds-base/pull/6362)
- Issue [6347](https://github.com/389ds/389-ds-base/issues/6347) - better fix for desyncronized vlv cache [#6358](https://github.com/389ds/389-ds-base/pull/6358)
- Issue [6243](https://github.com/389ds/389-ds-base/issues/6243) - dsctl bdb2mdb should cleanly fail if bundled libdb is not available [#6351](https://github.com/389ds/389-ds-base/pull/6351)
- Issue [6331](https://github.com/389ds/389-ds-base/issues/6331) - UI - Instance fails to load when DB backup directory doesn't exist [#6332](https://github.com/389ds/389-ds-base/pull/6332)
- Issue [6356](https://github.com/389ds/389-ds-base/issues/6356) - On LMDB, after an update the impact VLV index, the vlv recno cache is not systematically cleared [#6357](https://github.com/389ds/389-ds-base/pull/6357)
- Issue [6056](https://github.com/389ds/389-ds-base/issues/6056) - WebUI supports only instances with BDB [#6299](https://github.com/389ds/389-ds-base/pull/6299)
- Issue [6339](https://github.com/389ds/389-ds-base/issues/6339) - Address Coverity scan issues in memberof and bdb\_layer [#6353](https://github.com/389ds/389-ds-base/pull/6353)
- Issue [6328](https://github.com/389ds/389-ds-base/issues/6328) - vlv control may not be logged [#6354](https://github.com/389ds/389-ds-base/pull/6354)
- Issue [6347](https://github.com/389ds/389-ds-base/issues/6347) - VLV search sometime fails with operation error [#6349](https://github.com/389ds/389-ds-base/pull/6349)
- Issue [6343](https://github.com/389ds/389-ds-base/issues/6343) - Improve online import robustness when the server is under load
- Issue [6345](https://github.com/389ds/389-ds-base/issues/6345) - Ensure all slapi\_log\_err calls end format strings with newline character \n [#6346](https://github.com/389ds/389-ds-base/pull/6346)
- Issue [6064](https://github.com/389ds/389-ds-base/issues/6064) - bdb2mdb shows errors [#6341](https://github.com/389ds/389-ds-base/pull/6341)
- Issue [6336](https://github.com/389ds/389-ds-base/issues/6336) - Fix failing CI tests (roles) due to slow import [#6337](https://github.com/389ds/389-ds-base/pull/6337)
- Fix duplicate detection logic by ensuring exact match on string length [#6333](https://github.com/389ds/389-ds-base/pull/6333)
- Issue [6304](https://github.com/389ds/389-ds-base/issues/6304) - RFE when memberof is enabled, defer updates of members from the update of the group [#6305](https://github.com/389ds/389-ds-base/pull/6305)
- Issue [6329](https://github.com/389ds/389-ds-base/issues/6329) - lmdb typo in error log notice message [#6330](https://github.com/389ds/389-ds-base/pull/6330)
- Issue [6324](https://github.com/389ds/389-ds-base/issues/6324) - Provide more information in the error message during setup\_ol\_tls\_conn() [#6325](https://github.com/389ds/389-ds-base/pull/6325)
- Issue [5965](https://github.com/389ds/389-ds-base/issues/5965) - UI, CLI - Fix Account Policy Plugin functionality issues [#6323](https://github.com/389ds/389-ds-base/pull/6323)
- Issue [6188](https://github.com/389ds/389-ds-base/issues/6188) - Check if nsslapd-haproxy-trusted-ip attribute is returned in default schema
- Issue [6319](https://github.com/389ds/389-ds-base/issues/6319) - bdb subpackage has `%description` in the wrong place
- Issue [6321](https://github.com/389ds/389-ds-base/issues/6321) - lib389 get\_db\_lib function may returns the wrong db type [#6322](https://github.com/389ds/389-ds-base/pull/6322)
- Issue [6245](https://github.com/389ds/389-ds-base/issues/6245) - Fix some other coverity scan regressions [#6273](https://github.com/389ds/389-ds-base/pull/6273)
- Issue [6316](https://github.com/389ds/389-ds-base/issues/6316) - lmdb reindex is broken if index type is specified [#6318](https://github.com/389ds/389-ds-base/pull/6318)
- Issue [6090](https://github.com/389ds/389-ds-base/issues/6090) - Fix dbscan options and man pages [#6315](https://github.com/389ds/389-ds-base/pull/6315)
- Issue [6307](https://github.com/389ds/389-ds-base/issues/6307) - Wrong set of entries returned for some search filters [#6308](https://github.com/389ds/389-ds-base/pull/6308)
- Issue [2472](https://github.com/389ds/389-ds-base/issues/2472) - Add a CI test [#6314](https://github.com/389ds/389-ds-base/pull/6314)
- Issue [6276](https://github.com/389ds/389-ds-base/issues/6276) - Schema lib389 object is not keeping custom schema data upon editing [#6279](https://github.com/389ds/389-ds-base/pull/6279)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - micromatch [#6310](https://github.com/389ds/389-ds-base/pull/6310)
- Issue [5843](https://github.com/389ds/389-ds-base/issues/5843) - Fix size formatting in dscreate output and enhance tests [#6309](https://github.com/389ds/389-ds-base/pull/6309)
-  Issue [6301](https://github.com/389ds/389-ds-base/issues/6301) - Fix long delay when setting replication agreement with dsconf [#6303](https://github.com/389ds/389-ds-base/pull/6303)
- Issue [6280](https://github.com/389ds/389-ds-base/issues/6280) - Changelog trims updates from a given RID even if a consumer has not received any of them [#6281](https://github.com/389ds/389-ds-base/pull/6281)
- Issue [6296](https://github.com/389ds/389-ds-base/issues/6296) - basic\_test.py::test\_conn\_limits fails in main branch [#6300](https://github.com/389ds/389-ds-base/pull/6300)
- Issue [6295](https://github.com/389ds/389-ds-base/issues/6295) - test\_password\_modify\_non\_utf8 should set default password storage scheme
- Issue [6294](https://github.com/389ds/389-ds-base/issues/6294) - Nightly copr builds are failing
- Issue [6288](https://github.com/389ds/389-ds-base/issues/6288) - dsidm crash with account policy when alt-state-attr is disabled [#6292](https://github.com/389ds/389-ds-base/pull/6292)
- Issue [2324](https://github.com/389ds/389-ds-base/issues/2324) - Add a CI test [#6289](https://github.com/389ds/389-ds-base/pull/6289)
- Issue [6284](https://github.com/389ds/389-ds-base/issues/6284) - BUG - freelist ordering causes high wtime [#6285](https://github.com/389ds/389-ds-base/pull/6285)
- Issue [6282](https://github.com/389ds/389-ds-base/issues/6282) - BUG - out of tree build fails [#6283](https://github.com/389ds/389-ds-base/pull/6283)
