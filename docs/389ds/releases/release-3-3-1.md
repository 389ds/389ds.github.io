---
title: "Releases/3.3.1"
---

389 Directory Server 3.3.1
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.3.1.

The new package and version is:

- 389-ds-base-3.3.1

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.3.1)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.3.1/389-ds-base-3.3.1.tar.bz2>

### Highlights in 3.3.1

- Security fixes for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770), [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355), [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453), [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922), [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843), [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560), and [CVE-2026-9064](https://access.redhat.com/security/cve/CVE-2026-9064).
- Add Have I Been Pwned password breach validation, sysusers.d support, and offline thread-pool saturation diagnostics.
- Preserve `dsEntryDN` case on modify and prevent silent entry loss during LMDB bulk import.
- Improve replication total initialization, deferred MemberOf updates, range searches, online reindex safety, and log-compression contention.
- Strengthen PBKDF2 validation and fix memory-safety issues in LDAP parsing, ACL processing, password handling, and retro changelog operations.

### Installation and Upgrade

See [Download](https://www.port389.org/docs/389ds/download.html) for information about setting up your DNF repositories.

To install the server use `dnf install 389-ds-base`

To install the Cockpit UI plugin use `dnf install cockpit-389-ds`

After rpm install completes, run `dscreate interactive`

For upgrades, simply install the package. There are no further steps required.

See [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for more information about the initial installation and setup.

See [Source](https://www.port389.org/docs/389ds/development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

Please provide feedback and comments here:
 - 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
 - 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

Changelog between 389-ds-base-3.3.0 and 389-ds-base-3.3.1:

- Bump version to 3.3.1
- Security fix for [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560)
- Security fix for [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843)
- Security fix for [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922)
- Security fix for [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453)
- Security fix for [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355)
- Issue [7806](https://github.com/389ds/389-ds-base/issues/7806) - Preserve dsEntryDN case on modify [#7807](https://github.com/389ds/389-ds-base/pull/7807)
- Issue [7808](https://github.com/389ds/389-ds-base/issues/7808) - CI - harden online\_import\_nosync\_test [#7809](https://github.com/389ds/389-ds-base/pull/7809)
- Bump fast-uri from 3.1.5 to 3.1.7 in /src/cockpit/389-console
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Remove the nightly dedup gate and fix dispatched test runs [#7792](https://github.com/389ds/389-ds-base/pull/7792)
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - PBKDF2 password verification should reject invalid iteration counts [#7632](https://github.com/389ds/389-ds-base/pull/7632)
- Issue [7785](https://github.com/389ds/389-ds-base/issues/7785) - Downstream release automation using Packit [#7786](https://github.com/389ds/389-ds-base/pull/7786)
- Issue [2779](https://github.com/389ds/389-ds-base/issues/2779) - Streamline SPEC file for potential inclusion in Fedora [#7784](https://github.com/389ds/389-ds-base/pull/7784)
- Issue [7769](https://github.com/389ds/389-ds-base/issues/7769) - Password may wrongly be reported as expired [#7777](https://github.com/389ds/389-ds-base/pull/7777)
- Update Rust crate uuid to v1.26.0
- Update dependency eslint to v10.9.1
- Update github-actions
- Reject mismatched cn in dynamic certificate add requests [#7680](https://github.com/389ds/389-ds-base/pull/7680)
- Fix expiration time check [#7718](https://github.com/389ds/389-ds-base/pull/7718)
- Issue [7722](https://github.com/389ds/389-ds-base/issues/7722) - Switch to `logconv.py` as default [#7778](https://github.com/389ds/389-ds-base/pull/7778)
- Issue [6176](https://github.com/389ds/389-ds-base/issues/6176) - Add sysusers.d support and modernize systemd path detection [#7776](https://github.com/389ds/389-ds-base/pull/7776)
- Issue [7774](https://github.com/389ds/389-ds-base/issues/7774) - Add backport action [#7775](https://github.com/389ds/389-ds-base/pull/7775)
- Issue [7770](https://github.com/389ds/389-ds-base/issues/7770) - Testimony failure in test\_cleanruv\_extop\_security.py [#7771](https://github.com/389ds/389-ds-base/pull/7771)
- [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770) - Fix StartReplicationRequest auth gate response format
- Security fix for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770)
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Run PR tests when the nightly gate is skipped [#7766](https://github.com/389ds/389-ds-base/pull/7766)
- Issue [7760](https://github.com/389ds/389-ds-base/issues/7760) - CI - harden dsconf\_task\_test.py
- Update rust-dependencies to v1.4.4
- Issue [7764](https://github.com/389ds/389-ds-base/issues/7764) - Remove stale Cargo.lock [#7765](https://github.com/389ds/389-ds-base/pull/7765)
- Issue [4701](https://github.com/389ds/389-ds-base/issues/4701) - Fix UAF when excluding attrs from retro changelog [#7730](https://github.com/389ds/389-ds-base/pull/7730)
- Update github/codeql-action digest to db488dd
- Update cockpit-389-ds-npm
- Issue [7723](https://github.com/389ds/389-ds-base/issues/7723) - Range search returns an empty result when its start key is removed [#7724](https://github.com/389ds/389-ds-base/pull/7724)
- Issue [7728](https://github.com/389ds/389-ds-base/issues/7728) - bdb: Fix nsslapd-db-compactdb-interval: 0 not disabling auto compaction
- Issue [7639](https://github.com/389ds/389-ds-base/issues/7639) - Move log compression outside of global write lock
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Skip redundant CI runs to relieve the Actions queue [#7717](https://github.com/389ds/389-ds-base/pull/7717)
- Issue [7631](https://github.com/389ds/389-ds-base/issues/7631) - Don't install bpftrace by default [#7726](https://github.com/389ds/389-ds-base/pull/7726)
- Issue [7735](https://github.com/389ds/389-ds-base/issues/7735) - Heap overflow when parsing objectclass superior [#7736](https://github.com/389ds/389-ds-base/pull/7736)
- Issue [7733](https://github.com/389ds/389-ds-base/issues/7733) - Typo about nsuniqueid in tombstone\_to\_conflict [#7734](https://github.com/389ds/389-ds-base/pull/7734)
- Update rust-dependencies
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - fast-uri, js-yaml, nanoid [#7700](https://github.com/389ds/389-ds-base/pull/7700)
- Issue [7707](https://github.com/389ds/389-ds-base/issues/7707) - lib389: set nsDS5ReplicaBindDNGroup before ensure\_agreement() in join\_supplier/hub/consumer [#7708](https://github.com/389ds/389-ds-base/pull/7708)
- Issue [7679](https://github.com/389ds/389-ds-base/issues/7679) - Add layered agent docs, task skills, and guides [#7686](https://github.com/389ds/389-ds-base/pull/7686)
- Issue [7688](https://github.com/389ds/389-ds-base/issues/7688) - BUG - partial address leak in sso token [#7689](https://github.com/389ds/389-ds-base/pull/7689)
- Issue [7705](https://github.com/389ds/389-ds-base/issues/7705) - With memberOfEntryScope set, deferred memberOf skips MODIFY operations [#7706](https://github.com/389ds/389-ds-base/pull/7706)
- Issue [7698](https://github.com/389ds/389-ds-base/issues/7698) - Fix silent entry loss in LMDB bulk import waiter handling [#7699](https://github.com/389ds/389-ds-base/pull/7699)
- Issue [7711](https://github.com/389ds/389-ds-base/issues/7711) - Fix typo in accountpolicy --login-history-size help text [#7713](https://github.com/389ds/389-ds-base/pull/7713)
- Issue [6419](https://github.com/389ds/389-ds-base/issues/6419) - Error: name 'cockpit\_present' is not defined [#7719](https://github.com/389ds/389-ds-base/pull/7719)
- Update github-actions
- Issue [7709](https://github.com/389ds/389-ds-base/issues/7709) - Add EPEL 10 target to Packit COPR builds [#7721](https://github.com/389ds/389-ds-base/pull/7721)
- Issue [7666](https://github.com/389ds/389-ds-base/issues/7666) - Replication performance degradation during total init on high-latency storage [#7667](https://github.com/389ds/389-ds-base/pull/7667)
- Issue [7645](https://github.com/389ds/389-ds-base/issues/7645) - Add runtime LeakSanitizer leak check [#7646](https://github.com/389ds/389-ds-base/pull/7646)
- Issue [7273](https://github.com/389ds/389-ds-base/issues/7273) - In a chaining environment binding as remote user causes an invalid error in the logs
- Issue [7709](https://github.com/389ds/389-ds-base/issues/7709) - Add EPEL 10 target to Packit COPR builds
- Issue [7714](https://github.com/389ds/389-ds-base/issues/7714) - UI - sass import rules are deprecated
- Issue [7658](https://github.com/389ds/389-ds-base/issues/7658) - Heap Buffer Overflow in sasl\_io\_recv() via Padded SASL UNBIND
- Issue [7710](https://github.com/389ds/389-ds-base/issues/7710) - MemberOf deferred update - Use condvar instead of sleep loop
- Issue [7637](https://github.com/389ds/389-ds-base/issues/7637) - UI - Using Arrow Keys in New Object Wizard Resulted in DOM Reload
- Issue [7685](https://github.com/389ds/389-ds-base/issues/7685) - BUG - Avoid ioblocktimeout [#7687](https://github.com/389ds/389-ds-base/pull/7687)
- Issue [7578](https://github.com/389ds/389-ds-base/issues/7578) - schema - attribute refcount is not maintained properly
- Issue [7468](https://github.com/389ds/389-ds-base/issues/7468) - RFE - HIBP password breach validation [#7492](https://github.com/389ds/389-ds-base/pull/7492)
- Issue [7605](https://github.com/389ds/389-ds-base/issues/7605) - Harden CI test ports against ephemeral allocation [#7692](https://github.com/389ds/389-ds-base/pull/7692)
- Issue [7528](https://github.com/389ds/389-ds-base/issues/7528) - Retry the CI image pull instead of failing the job [#7691](https://github.com/389ds/389-ds-base/pull/7691)
- Backport Issue [7519](https://github.com/389ds/389-ds-base/issues/7519) — ignore obsolete entrydn when entryrdn is in use [#7657](https://github.com/389ds/389-ds-base/pull/7657)
- Update cockpit-389-ds-npm [#7565](https://github.com/389ds/389-ds-base/pull/7565)
- Issue [7466](https://github.com/389ds/389-ds-base/issues/7466) - UI - Refactor all TextInput number types to NumberInput
- Migrate pwdchan to base64 0.23 Engine API
- Update rust-dependencies
- Update rust-dependencies [#7669](https://github.com/389ds/389-ds-base/pull/7669)
- Issue [7505](https://github.com/389ds/389-ds-base/issues/7505) - RFE - CLI - add feature to determine which password policy applies to a user
- Issue [7652](https://github.com/389ds/389-ds-base/issues/7652) - Fix acl\_test after fixing anonymous bind with password [#7678](https://github.com/389ds/389-ds-base/pull/7678)
- Update github/codeql-action digest to f205ea1
- Issue [7675](https://github.com/389ds/389-ds-base/issues/7675) - memory leak in test\_libslapd\_csngen\_clock\_failure- #7676 #7676
- Issue [7670](https://github.com/389ds/389-ds-base/issues/7670) - BDB range searches intermittently fail with err=1 under write load [#7671](https://github.com/389ds/389-ds-base/pull/7671)
- Issue [7652](https://github.com/389ds/389-ds-base/issues/7652) - change bind result with password but no dn [#7653](https://github.com/389ds/389-ds-base/pull/7653)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Creating local password policy succeeds with incorrect passwordInHistory value [#7662](https://github.com/389ds/389-ds-base/pull/7662)
- Issue [7200](https://github.com/389ds/389-ds-base/issues/7200) - repl-agmt create doesn't set some parameters [#7663](https://github.com/389ds/389-ds-base/pull/7663)
- Update rust-dependencies [#7472](https://github.com/389ds/389-ds-base/pull/7472)
- Pin dependencies
- Update actions/checkout action to v7
- Update Rust crate openssl to v0.10.80 [SECURITY]
- Issue [7327](https://github.com/389ds/389-ds-base/issues/7327) - Unify topology naming in tests [#7650](https://github.com/389ds/389-ds-base/pull/7650)
- Issue [7633](https://github.com/389ds/389-ds-base/issues/7633) - RFE - Add offline diagnostics for thread pool saturation [#7634](https://github.com/389ds/389-ds-base/pull/7634)
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - Preserve legacy PBKDF2 hash compatibility [#7649](https://github.com/389ds/389-ds-base/pull/7649)
- Issue [7547](https://github.com/389ds/389-ds-base/issues/7547) - Heap buffer overflow in ldap\_utf8prev()
- Issue [7543](https://github.com/389ds/389-ds-base/issues/7543) - buffer overflow in slapi\_dn\_find\_parent\_ext() [#7544](https://github.com/389ds/389-ds-base/pull/7544)
- Issue [7545](https://github.com/389ds/389-ds-base/issues/7545) - Heap buffer overflow in str2entry\_state\_information\_from\_type() [#7546](https://github.com/389ds/389-ds-base/pull/7546)
- Issue [7569](https://github.com/389ds/389-ds-base/issues/7569) - Reduce noisy CodeQL false-positive alerts [#7629](https://github.com/389ds/389-ds-base/pull/7629)
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - PBKDF2 password verification should reject invalid iteration count [#7613](https://github.com/389ds/389-ds-base/pull/7613)
- Issue [7535](https://github.com/389ds/389-ds-base/issues/7535) - Fix race in test\_schema\_update\_policy\_reject
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Reduce Actions queue saturation [#7596](https://github.com/389ds/389-ds-base/pull/7596)
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - Total init sends the suffix entry twice [#7640](https://github.com/389ds/389-ds-base/pull/7640)
- Issue [7147](https://github.com/389ds/389-ds-base/issues/7147) - Fix DN cache ownership during online reindex [#7641](https://github.com/389ds/389-ds-base/pull/7641)
- Issue [7635](https://github.com/389ds/389-ds-base/issues/7635) - Integer Underflow in {SMD5} Password Comparison [#7636](https://github.com/389ds/389-ds-base/pull/7636)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Automated test for creating local password policy with incorrect passwordInHistory value [#7608](https://github.com/389ds/389-ds-base/pull/7608)
- Issue [7406](https://github.com/389ds/389-ds-base/issues/7406) - Fix ldap-agent SNMP stats file loading [#7630](https://github.com/389ds/389-ds-base/pull/7630)
- Issue [7621](https://github.com/389ds/389-ds-base/issues/7621) - Stack Buffer Overflow in Password checkPrefix
- Issue [7623](https://github.com/389ds/389-ds-base/issues/7623)  - Heap Buffer Overflow in 389-ds-base Audit Log Password Masking
- Issue [7569](https://github.com/389ds/389-ds-base/issues/7569) - Add CodeQL advanced setup workflow [#7570](https://github.com/389ds/389-ds-base/pull/7570)
- Issue [7536](https://github.com/389ds/389-ds-base/issues/7536) - CI - Fix backup\_task\_after\_failure race [#7588](https://github.com/389ds/389-ds-base/pull/7588)
- Issue [7610](https://github.com/389ds/389-ds-base/issues/7610) - Still some lib389.topologies in CI tests [#7612](https://github.com/389ds/389-ds-base/pull/7612)
- Issue [7529](https://github.com/389ds/389-ds-base/issues/7529) - Fix WebUI local policy availability test [#7609](https://github.com/389ds/389-ds-base/pull/7609)
- Issue [7617](https://github.com/389ds/389-ds-base/issues/7617) - Fix wrong PR\_ASSERT about entry cache [#7618](https://github.com/389ds/389-ds-base/pull/7618)
- Issue [7602](https://github.com/389ds/389-ds-base/issues/7602) - CI - lib389 user compare fails due to parentid mismatch [#7603](https://github.com/389ds/389-ds-base/pull/7603)
- Issue [7380](https://github.com/389ds/389-ds-base/issues/7380) - Automated test for negative wtime [#7616](https://github.com/389ds/389-ds-base/pull/7616)
- Issue [7147](https://github.com/389ds/389-ds-base/issues/7147) - entrycache\_eviction\_test CI test is failing [#7607](https://github.com/389ds/389-ds-base/pull/7607)
- Issue [7537](https://github.com/389ds/389-ds-base/issues/7537) - CI - Fix replication log monitoring parser/timing failures [#7592](https://github.com/389ds/389-ds-base/pull/7592)
- Issue [7593](https://github.com/389ds/389-ds-base/issues/7593) - Fix testimony docstring for SASL overflow test [#7606](https://github.com/389ds/389-ds-base/pull/7606)
- Issue [7583](https://github.com/389ds/389-ds-base/issues/7583) - Compressed logs are prematurely deleted [#7584](https://github.com/389ds/389-ds-base/pull/7584)
- Issue [7530](https://github.com/389ds/389-ds-base/issues/7530) - CI - Stabilize DNA plugin replication tests timing out in CI [#7572](https://github.com/389ds/389-ds-base/pull/7572)
- Issue [7567](https://github.com/389ds/389-ds-base/issues/7567) - Content Sync plugin unbounded queue growth and race conditions [#7568](https://github.com/389ds/389-ds-base/pull/7568)
- Issue [7593](https://github.com/389ds/389-ds-base/issues/7593) - Reject invalid SASL packet length values in sasl\_io\_start\_packet [#7594](https://github.com/389ds/389-ds-base/pull/7594)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - ws, js-yaml, babel/core [#7599](https://github.com/389ds/389-ds-base/pull/7599)
- Issue [7263](https://github.com/389ds/389-ds-base/issues/7263) - UI - Use cockpit.file API for temporary file writes [#7590](https://github.com/389ds/389-ds-base/pull/7590)
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - Add invalid ACL text header regression test [#7591](https://github.com/389ds/389-ds-base/pull/7591)
- Issue [7554](https://github.com/389ds/389-ds-base/issues/7554) - UI - Revise local password policy layout
- Issue [7521](https://github.com/389ds/389-ds-base/issues/7521) - UI - make changes for cockpit API updates
- Issue [7529](https://github.com/389ds/389-ds-base/issues/7529) - Fix WebUI CI failure cascade and missing screenshots [#7566](https://github.com/389ds/389-ds-base/pull/7566)
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - heap-buffer-overflows in \_\_aclp\_\_normalize\_acltxt() [#7542](https://github.com/389ds/389-ds-base/pull/7542)
- Issue [7534](https://github.com/389ds/389-ds-base/issues/7534) - CI - Fix resource\_limits fdlimits failures in BDB and LMDB [#7585](https://github.com/389ds/389-ds-base/pull/7585)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48392 test [#7523](https://github.com/389ds/389-ds-base/pull/7523)
- Issue [7531](https://github.com/389ds/389-ds-base/issues/7531) - Fix LMDB replication regression\_m2 failures and core dumps [#7575](https://github.com/389ds/389-ds-base/pull/7575)
- Issue [7490](https://github.com/389ds/389-ds-base/issues/7490) - Enable USDT probes by default in RPM [#7491](https://github.com/389ds/389-ds-base/pull/7491)
- Issue [7576](https://github.com/389ds/389-ds-base/issues/7576) - Fix leak of temporary attribute syntax hash tables after schema reload
- Issue [7573](https://github.com/389ds/389-ds-base/issues/7573) - Post-import cache autotuning does not recompute entry cache size [#7574](https://github.com/389ds/389-ds-base/pull/7574)
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - During online import, the IDL should be created with in-depth first approach [#7559](https://github.com/389ds/389-ds-base/pull/7559)
- Issue [7500](https://github.com/389ds/389-ds-base/issues/7500) - Prevent unsigned integer underflow during stalled import
- Issue [7562](https://github.com/389ds/389-ds-base/issues/7562) - Error: NssSsl.add\_cert() got an unexpected keyword argument 'input\_file' [#7563](https://github.com/389ds/389-ds-base/pull/7563)
- Issue [7560](https://github.com/389ds/389-ds-base/issues/7560) - lib389 - Add helper function for checking ASAN files
- Issue [7539](https://github.com/389ds/389-ds-base/issues/7539) - Server shutdown during online reindex may lead to data loss [#7540](https://github.com/389ds/389-ds-base/pull/7540)
- Issue [7549](https://github.com/389ds/389-ds-base/issues/7549) - Substring index should validate minimum nsSubStrBegin/nsSubStrEnd values [#7550](https://github.com/389ds/389-ds-base/pull/7550)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - brace-expansion [#7556](https://github.com/389ds/389-ds-base/pull/7556)
- Issue [7554](https://github.com/389ds/389-ds-base/issues/7554) - deref plugin null pointer dereference if ber\_init fails
- Issue [7532](https://github.com/389ds/389-ds-base/issues/7532) - CI - Fix BDB CLU dbmon tests leaving instance offline [#7553](https://github.com/389ds/389-ds-base/pull/7553)
- Issue [7391](https://github.com/389ds/389-ds-base/issues/7391) - Harden systemd service unit [#7392](https://github.com/389ds/389-ds-base/pull/7392)
- Bump version to 3.3.0
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 49658 test
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Removing ticket48252\_test and porting to DSLdapObject [#7520](https://github.com/389ds/389-ds-base/pull/7520)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48354 test
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48745 and 48746 tests [#7513](https://github.com/389ds/389-ds-base/pull/7513)
- Issue [7493](https://github.com/389ds/389-ds-base/issues/7493) - RFE - Add ShadowAccount fixup task
- Issue [7507](https://github.com/389ds/389-ds-base/issues/7507) - UI - cleanup style and alignments
- Issue [7514](https://github.com/389ds/389-ds-base/issues/7514) - Crash when doing moddn on very large subtree
- Issue [7516](https://github.com/389ds/389-ds-base/issues/7516) - dblayer\_bulk\_nextdata should not return an error when maxrecords is hit
- Issue [7475](https://github.com/389ds/389-ds-base/issues/7475) - Fix CI test failures in test\_fd\_limits [#7488](https://github.com/389ds/389-ds-base/pull/7488)
- Issue [7496](https://github.com/389ds/389-ds-base/issues/7496) - Fix latest GCC compiler warnings
- Issue [7503](https://github.com/389ds/389-ds-base/issues/7503) - [CVE-2026-9064](https://access.redhat.com/security/cve/CVE-2026-9064) - Add a limit to the number controls per operation
- Issue [7468](https://github.com/389ds/389-ds-base/issues/7468) - RFE - Add HIBP HTTP client [#7469](https://github.com/389ds/389-ds-base/pull/7469)
- Issue [7402](https://github.com/389ds/389-ds-base/issues/7402) - remove debug print state
- address Simon's comments
- Minor fixes
- fix CI tests
- Add disk space checking functionality for offline server
- Issue [7402](https://github.com/389ds/389-ds-base/issues/7402) - CLI - allow healthcheck to work when server is stopped
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Removing ticket49412\_test and porting to DSLdapObject [#7428](https://github.com/389ds/389-ds-base/pull/7428)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Removing ticket49303\_test and porting to DSLdapObject [#7429](https://github.com/389ds/389-ds-base/pull/7429)
- Issue [7460](https://github.com/389ds/389-ds-base/issues/7460) - MOD\_REPLACE on groups/link attributes modifies overlap targets [#7461](https://github.com/389ds/389-ds-base/pull/7461)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Removing ticket49287 test and porting to DSLdapObject [#7480](https://github.com/389ds/389-ds-base/pull/7480)
- Issue [7464](https://github.com/389ds/389-ds-base/issues/7464) - CLI - allow dsidm to work with other user types
- Issue [7435](https://github.com/389ds/389-ds-base/issues/7435) - Add AGENTS.md to support AI coding assistants
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48266 test
- Bump fast-uri from 3.1.0 to 3.1.2 in /src/cockpit/389-console [#7487](https://github.com/389ds/389-ds-base/pull/7487)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48383 test [#7486](https://github.com/389ds/389-ds-base/pull/7486)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48366 test [#7481](https://github.com/389ds/389-ds-base/pull/7481)
- Update Rust crate openssl to v0.10.79 [SECURITY] [#7484](https://github.com/389ds/389-ds-base/pull/7484)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48194 test
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Remove ticket 48497 test [#7482](https://github.com/389ds/389-ds-base/pull/7482)
- Issue [7475](https://github.com/389ds/389-ds-base/issues/7475) - Fix CI test failures [#7476](https://github.com/389ds/389-ds-base/pull/7476)
- Issue [6641](https://github.com/389ds/389-ds-base/issues/6641) - MODRDN fails when referint-tracked attr is MUST and SINGLE-VALUE [#7409](https://github.com/389ds/389-ds-base/pull/7409)
- Issue [7470](https://github.com/389ds/389-ds-base/issues/7470) - dsctl localhost tls import-server-key-cert fails with 'expected str, bytes or os.PathLike object, not NoneType' [#7477](https://github.com/389ds/389-ds-base/pull/7477)
- Issue [7478](https://github.com/389ds/389-ds-base/issues/7478) - Regression in FreeIPA backup-restore test [#7479](https://github.com/389ds/389-ds-base/pull/7479)
- Issue [3082](https://github.com/389ds/389-ds-base/issues/3082) - Separate test code from lib389 [#7430](https://github.com/389ds/389-ds-base/pull/7430)
- Issue [7289](https://github.com/389ds/389-ds-base/issues/7289) - RFE - Container First Run Improvements [#7290](https://github.com/389ds/389-ds-base/pull/7290)
- Issue [7372](https://github.com/389ds/389-ds-base/issues/7372) - Reindex adds tombstones to ancestorid causing export failures [#7373](https://github.com/389ds/389-ds-base/pull/7373)
- Issue [7457](https://github.com/389ds/389-ds-base/issues/7457) - Refactor memberOf perf test [#7458](https://github.com/389ds/389-ds-base/pull/7458)
- Update github-actions [#7474](https://github.com/389ds/389-ds-base/pull/7474)
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48214 test
- Issue [6753](https://github.com/389ds/389-ds-base/issues/6753) - Port ticket 48272 test [#7442](https://github.com/389ds/389-ds-base/pull/7442)
- issue 6867 - check file access in dsctl ldif2db [#7459](https://github.com/389ds/389-ds-base/pull/7459)
- Issue [7452](https://github.com/389ds/389-ds-base/issues/7452) - UI - password polices - reorganize settings
- Bump version to 3.2.1
