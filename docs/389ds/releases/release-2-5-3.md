---
title: "Releases/2.5.3"
---

389 Directory Server 2.5.3
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.5.3.

The new packages and versions are:

- 389-ds-base-2.5.3

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.5.3)

- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.5.3/389-ds-base-2.5.3.tar.bz2>

### Highlights in 2.5.3

- Enhancements
  - Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - RFE - Add log buffering for error log
  - Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - RFE - add option to write audit log in JSON format
  - Issue [6304](https://github.com/389ds/389-ds-base/issues/6304) - RFE when memberof is enabled, defer updates of members from the update of the group [#6305](https://github.com/389ds/389-ds-base/pull/6305)
  - Issue [6340](https://github.com/389ds/389-ds-base/issues/6340) - RFE - Use previously extracted key path [#6363](https://github.com/389ds/389-ds-base/pull/6363)
  - Issue [6340](https://github.com/389ds/389-ds-base/issues/6340) - RFE - extract keys once [#6363](https://github.com/389ds/389-ds-base/pull/6363) [#6363](https://github.com/389ds/389-ds-base/pull/6363)

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

Changelog between 389-ds-base-2.5.2 and 389-ds-base-2.5.3:

- Bump version to 2.5.3
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix issues reported by npm audit
- Issue [6446](https://github.com/389ds/389-ds-base/issues/6446) - on replica consumer, account policy plugin fails to manage the last login history [#6448](https://github.com/389ds/389-ds-base/pull/6448)
- Issue [6432](https://github.com/389ds/389-ds-base/issues/6432) - Crash during bind when acct policy plugin does not have "alwaysrecordlogin" set
- Issue [5798](https://github.com/389ds/389-ds-base/issues/5798) - Fix dsconf config multi-valued attr operations [#6426](https://github.com/389ds/389-ds-base/pull/6426)
- Issue [6302](https://github.com/389ds/389-ds-base/issues/6302) - Allow to run replication status without a prompt [#6410](https://github.com/389ds/389-ds-base/pull/6410)
- Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - Fix test\_audit\_json\_logging CI test regression [#6264](https://github.com/389ds/389-ds-base/pull/6264)
- Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - RFE - add option to write audit log in JSON format
- Issue [6427](https://github.com/389ds/389-ds-base/issues/6427) - fix various memory leaks
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6418](https://github.com/389ds/389-ds-base/pull/6418)
- Issue [6340](https://github.com/389ds/389-ds-base/issues/6340) - RFE - extract keys once [#6413](https://github.com/389ds/389-ds-base/pull/6413)
- Issue [6415](https://github.com/389ds/389-ds-base/issues/6415) - BUG - Incorrect icu linking [#6416](https://github.com/389ds/389-ds-base/pull/6416)
- Issue [6258](https://github.com/389ds/389-ds-base/issues/6258) - Resolve race condition for two tests in health\_config.py
- Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - Add log buffering for error log
- Issue [6086](https://github.com/389ds/389-ds-base/issues/6086) - Ambiguous warning about SELinux in dscreate for non-root user
- Issue [6397](https://github.com/389ds/389-ds-base/issues/6397) - Remove deprecated setting for HR time stamps in logs
- Issue [6390](https://github.com/389ds/389-ds-base/issues/6390) - Adjust cleanAllRUV max per txn and interval limits
- Issue [6349](https://github.com/389ds/389-ds-base/issues/6349) - RFE - extract keys once [#6363](https://github.com/389ds/389-ds-base/pull/6363) [#6363](https://github.com/389ds/389-ds-base/pull/6363)
- Issue [6381](https://github.com/389ds/389-ds-base/issues/6381) - CleanAllRUV - move changelog purging to the very end of the task
- Issue [6199](https://github.com/389ds/389-ds-base/issues/6199) - unprotected search query during certificate based authentication [#6205](https://github.com/389ds/389-ds-base/pull/6205)
- Issue [5920](https://github.com/389ds/389-ds-base/issues/5920) - pamModuleIsThreadSafe is missing in the schema
- Issue [6328](https://github.com/389ds/389-ds-base/issues/6328) - vlv control may not be logged [#6354](https://github.com/389ds/389-ds-base/pull/6354)
- Issue [6349](https://github.com/389ds/389-ds-base/issues/6349) - RFE - Use previously extracted key path [#6363](https://github.com/389ds/389-ds-base/pull/6363)
- Issue [6067](https://github.com/389ds/389-ds-base/issues/6067) - Update dsidm to prioritize basedn from .dsrc over interactive input [#6362](https://github.com/389ds/389-ds-base/pull/6362)
- Issue [6347](https://github.com/389ds/389-ds-base/issues/6347) - better fix for desyncronized vlv cache [#6358](https://github.com/389ds/389-ds-base/pull/6358)
- Issue [6356](https://github.com/389ds/389-ds-base/issues/6356) - On LMDB, after an update the impact VLV index, the vlv recno cache is not systematically cleared [#6357](https://github.com/389ds/389-ds-base/pull/6357)
- Issue [6331](https://github.com/389ds/389-ds-base/issues/6331) - UI - Instance fails to load when DB backup directory doesn't exist [#6332](https://github.com/389ds/389-ds-base/pull/6332)
- Issue [6056](https://github.com/389ds/389-ds-base/issues/6056) - WebUI supports only instances with BDB [#6299](https://github.com/389ds/389-ds-base/pull/6299)
- Issue [6343](https://github.com/389ds/389-ds-base/issues/6343) - Improve online import robustness when the server is under load
- Issue [6345](https://github.com/389ds/389-ds-base/issues/6345) - Ensure all slapi\_log\_err calls end format strings with newline character \n [#6346](https://github.com/389ds/389-ds-base/pull/6346)
- Issue [6336](https://github.com/389ds/389-ds-base/issues/6336) - Fix failing CI tests (roles) due to slow import [#6337](https://github.com/389ds/389-ds-base/pull/6337)
- Issue [6304](https://github.com/389ds/389-ds-base/issues/6304) - RFE when memberof is enabled, defer updates of members from the update of the group [#6305](https://github.com/389ds/389-ds-base/pull/6305)
- Issue [6324](https://github.com/389ds/389-ds-base/issues/6324) - Provide more information in the error message during setup\_ol\_tls\_conn() [#6325](https://github.com/389ds/389-ds-base/pull/6325)
- Issue [5965](https://github.com/389ds/389-ds-base/issues/5965) - UI, CLI - Fix Account Policy Plugin functionality issues [#6323](https://github.com/389ds/389-ds-base/pull/6323)
- Issue [6316](https://github.com/389ds/389-ds-base/issues/6316) - lmdb reindex is broken if index type is specified [#6318](https://github.com/389ds/389-ds-base/pull/6318)
- Issue [6307](https://github.com/389ds/389-ds-base/issues/6307) - Wrong set of entries returned for some search filters [#6308](https://github.com/389ds/389-ds-base/pull/6308)
- Issue [2472](https://github.com/389ds/389-ds-base/issues/2472) - Add a CI test [#6314](https://github.com/389ds/389-ds-base/pull/6314)
- Issue [6276](https://github.com/389ds/389-ds-base/issues/6276) - Schema lib389 object is not keeping custom schema data upon editing [#6279](https://github.com/389ds/389-ds-base/pull/6279)
- Issue [6312](https://github.com/389ds/389-ds-base/issues/6312) - In branch 2.5, healthcheck report an invalid warning regarding BDB deprecation [#6313](https://github.com/389ds/389-ds-base/pull/6313)
- Issue [6296](https://github.com/389ds/389-ds-base/issues/6296) - basic\_test.py::test\_conn\_limits fails in main branch [#6300](https://github.com/389ds/389-ds-base/pull/6300)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - micromatch [#6310](https://github.com/389ds/389-ds-base/pull/6310)
- Issue [6301](https://github.com/389ds/389-ds-base/issues/6301) - Fix long delay when setting replication agreement with dsconf [#6303](https://github.com/389ds/389-ds-base/pull/6303)
- Issue [6280](https://github.com/389ds/389-ds-base/issues/6280) - Changelog trims updates from a given RID even if a consumer has not received any of them [#6281](https://github.com/389ds/389-ds-base/pull/6281)
- Issue [6295](https://github.com/389ds/389-ds-base/issues/6295) - test\_password\_modify\_non\_utf8 should set default password storage scheme
- Issue [6192](https://github.com/389ds/389-ds-base/issues/6192) - Test failure: test\_match\_large\_valueset
- Issue [2324](https://github.com/389ds/389-ds-base/issues/2324) - Add a CI test [#6289](https://github.com/389ds/389-ds-base/pull/6289)
- Issue [6284](https://github.com/389ds/389-ds-base/issues/6284) - BUG - freelist ordering causes high wtime [#6285](https://github.com/389ds/389-ds-base/pull/6285)
- Issue [6282](https://github.com/389ds/389-ds-base/issues/6282) - BUG - out of tree build fails [#6283](https://github.com/389ds/389-ds-base/pull/6283)
