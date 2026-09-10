---
title: "Releases/2.8.2"
---

389 Directory Server 2.8.2
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.8.2.

The new package and version is:

- 389-ds-base-2.8.2

Source tarball: [GitHub Releases](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.8.2)

### Highlights in 2.8.2

- Security fixes for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770), [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355), [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453), [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922), [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843), [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560).
- Prevent silent entry loss during LMDB bulk import and improve replication total-init performance on high-latency storage.
- Fix deferred MemberOf updates, range searches, online reindex safety, and local password policy handling.
- Improve WebUI group management coverage and healthcheck index diagnostics.

See [Download](https://www.port389.org/docs/389ds/download.html) for package installation and [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for setup.

Changelog between 389-ds-base-2.8.1 and 389-ds-base-2.8.2:

- Bump version to 2.8.2
- Security fix for [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560)
- Security fix for [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843)
- Issue [7041](https://github.com/389ds/389-ds-base/issues/7041) - Add WebUI test for group member management [#7111](https://github.com/389ds/389-ds-base/pull/7111)
- Security fix for [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922)
- Security fix for [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453)
- Security fix for [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355)
- Issue [7808](https://github.com/389ds/389-ds-base/issues/7808) - CI - harden online\_import\_nosync\_test [#7809](https://github.com/389ds/389-ds-base/pull/7809)
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Remove the nightly dedup gate and fix dispatched test runs
- Fix expiration time check [#7718](https://github.com/389ds/389-ds-base/pull/7718)
- Issue [7774](https://github.com/389ds/389-ds-base/issues/7774) - Add backport action [#7775](https://github.com/389ds/389-ds-base/pull/7775)
- Issue [7770](https://github.com/389ds/389-ds-base/issues/7770) - Testimony failure in test\_cleanruv\_extop\_security.py [#7771](https://github.com/389ds/389-ds-base/pull/7771)
- [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770) - Fix StartReplicationRequest auth gate response format
- Security fix for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770)
- Issue [3082](https://github.com/389ds/389-ds-base/issues/3082) - Add test389.topologies compatibility shim for backports [#7725](https://github.com/389ds/389-ds-base/pull/7725)
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Skip redundant CI runs to relieve the Actions queue [#7751](https://github.com/389ds/389-ds-base/pull/7751)
- Issue [7760](https://github.com/389ds/389-ds-base/issues/7760) - CI - harden dsconf\_task\_test.py
- Issue [4701](https://github.com/389ds/389-ds-base/issues/4701) - Fix UAF when excluding attrs from retro changelog [#7730](https://github.com/389ds/389-ds-base/pull/7730)
- Issue [7723](https://github.com/389ds/389-ds-base/issues/7723) - Range search returns an empty result when its start key is removed [#7724](https://github.com/389ds/389-ds-base/pull/7724)
- Issue [7735](https://github.com/389ds/389-ds-base/issues/7735) - Heap overflow when parsing objectclass superior [#7736](https://github.com/389ds/389-ds-base/pull/7736)
- Issue [7733](https://github.com/389ds/389-ds-base/issues/7733) - Typo about nsuniqueid in tombstone\_to\_conflict [#7734](https://github.com/389ds/389-ds-base/pull/7734)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Creating local password policy succeeds with incorrect passwordInHistory value [#7662](https://github.com/389ds/389-ds-base/pull/7662)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Automated test for creating local password policy with incorrect passwordInHistory value [#7608](https://github.com/389ds/389-ds-base/pull/7608)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - CI - Fix test\_grace\_limit\_section after pwpolicy validation fix [#7357](https://github.com/389ds/389-ds-base/pull/7357)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Creating local password policy succeeds with incorrect passwordInHistory value [#7285](https://github.com/389ds/389-ds-base/pull/7285)
- Issue [7707](https://github.com/389ds/389-ds-base/issues/7707) - lib389: set nsDS5ReplicaBindDNGroup before ensure\_agreement() in join\_supplier/hub/consumer [#7708](https://github.com/389ds/389-ds-base/pull/7708)
- Issue [7711](https://github.com/389ds/389-ds-base/issues/7711) - Fix typo in accountpolicy --login-history-size help text [#7713](https://github.com/389ds/389-ds-base/pull/7713)
- Issue [7688](https://github.com/389ds/389-ds-base/issues/7688) - BUG - partial address leak in sso token [#7689](https://github.com/389ds/389-ds-base/pull/7689)
- Issue [7705](https://github.com/389ds/389-ds-base/issues/7705) - With memberOfEntryScope set, deferred memberOf skips MODIFY operations [#7706](https://github.com/389ds/389-ds-base/pull/7706)
- Issue [7698](https://github.com/389ds/389-ds-base/issues/7698) - Fix silent entry loss in LMDB bulk import waiter handling [#7699](https://github.com/389ds/389-ds-base/pull/7699)
- Issue [7666](https://github.com/389ds/389-ds-base/issues/7666) - Replication performance degradation during total init on high-latency storage [#7667](https://github.com/389ds/389-ds-base/pull/7667)
- Issue [7201](https://github.com/389ds/389-ds-base/issues/7201) - Syscall overhead in LMDB import writer thread [#7204](https://github.com/389ds/389-ds-base/pull/7204)
- Issue [7645](https://github.com/389ds/389-ds-base/issues/7645) - Add runtime LeakSanitizer leak check [#7646](https://github.com/389ds/389-ds-base/pull/7646)
- Issue [7714](https://github.com/389ds/389-ds-base/issues/7714) - UI - sass import rules are deprecated
- Issue [7658](https://github.com/389ds/389-ds-base/issues/7658) - Heap Buffer Overflow in sasl\_io\_recv() via Padded SASL UNBIND
- Issue [7710](https://github.com/389ds/389-ds-base/issues/7710) - MemberOf deferred update - Use condvar instead of sleep loop
- Issue [7637](https://github.com/389ds/389-ds-base/issues/7637) - fix cherry-pick error
- Issue [7637](https://github.com/389ds/389-ds-base/issues/7637) - UI - Using Arrow Keys in New Object Wizard Resulted in DOM Reload
- Issue [7578](https://github.com/389ds/389-ds-base/issues/7578) - schema - attribute refcount is not maintained properly
- Issue [7605](https://github.com/389ds/389-ds-base/issues/7605) - Harden CI test ports against ephemeral allocation [#7692](https://github.com/389ds/389-ds-base/pull/7692)
- Issue [7528](https://github.com/389ds/389-ds-base/issues/7528) - Retry the CI image pull instead of failing the job [#7691](https://github.com/389ds/389-ds-base/pull/7691)
- Issue [7460](https://github.com/389ds/389-ds-base/issues/7460) - MOD\_REPLACE on groups/link attributes modifies overlap targets [#7461](https://github.com/389ds/389-ds-base/pull/7461)
- Issue [7670](https://github.com/389ds/389-ds-base/issues/7670) - BDB range searches intermittently fail with err=1 under write load [#7671](https://github.com/389ds/389-ds-base/pull/7671)
- Issue [7108](https://github.com/389ds/389-ds-base/issues/7108) - Fix shutdown crash in entry cache destruction [#7163](https://github.com/389ds/389-ds-base/pull/7163)
- Issue [7200](https://github.com/389ds/389-ds-base/issues/7200) - repl-agmt create doesn't set some parameters [#7663](https://github.com/389ds/389-ds-base/pull/7663)
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - Preserve legacy PBKDF2 hash compatibility [#7649](https://github.com/389ds/389-ds-base/pull/7649)
- Issue [7547](https://github.com/389ds/389-ds-base/issues/7547) - Heap buffer overflow in ldap\_utf8prev()
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - PBKDF2 password verification should reject invalid iteration count [#7613](https://github.com/389ds/389-ds-base/pull/7613)
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - Total init sends the suffix entry twice [#7640](https://github.com/389ds/389-ds-base/pull/7640)
- Issue [7635](https://github.com/389ds/389-ds-base/issues/7635) - Integer Underflow in {SMD5} Password Comparison [#7636](https://github.com/389ds/389-ds-base/pull/7636)
- Issue [7406](https://github.com/389ds/389-ds-base/issues/7406) - Fix ldap-agent SNMP stats file loading [#7630](https://github.com/389ds/389-ds-base/pull/7630)
- Issue [7621](https://github.com/389ds/389-ds-base/issues/7621) - Stack Buffer Overflow in Password checkPrefix
- Issue [7623](https://github.com/389ds/389-ds-base/issues/7623)  - Heap Buffer Overflow in 389-ds-base Audit Log Password Masking
- Issue [7602](https://github.com/389ds/389-ds-base/issues/7602) - CI - lib389 user compare fails due to parentid mismatch [#7603](https://github.com/389ds/389-ds-base/pull/7603)
- Issue [7537](https://github.com/389ds/389-ds-base/issues/7537) - CI - Fix replication log monitoring parser/timing failures [#7592](https://github.com/389ds/389-ds-base/pull/7592)
- Issue [7593](https://github.com/389ds/389-ds-base/issues/7593) - Fix testimony docstring for SASL overflow test [#7606](https://github.com/389ds/389-ds-base/pull/7606)
- Issue [7530](https://github.com/389ds/389-ds-base/issues/7530) - CI - Stabilize DNA plugin replication tests timing out in CI [#7572](https://github.com/389ds/389-ds-base/pull/7572)
- Issue [7593](https://github.com/389ds/389-ds-base/issues/7593) - Reject invalid SASL packet length values in sasl\_io\_start\_packet [#7594](https://github.com/389ds/389-ds-base/pull/7594)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - ws, js-yaml, js-yaml, postcss, uuid
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - Add invalid ACL text header regression test [#7591](https://github.com/389ds/389-ds-base/pull/7591)
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - heap-buffer-overflows in \_\_aclp\_\_normalize\_acltxt() [#7542](https://github.com/389ds/389-ds-base/pull/7542)
- Issue [7576](https://github.com/389ds/389-ds-base/issues/7576) - Fix leak of temporary attribute syntax hash tables after schema reload
- Issue [7198](https://github.com/389ds/389-ds-base/issues/7198) - Web console doesn't show sub-suffix when parent-suffix points to an entry [#7202](https://github.com/389ds/389-ds-base/pull/7202)
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - During online import, the IDL should be created with in-depth first approach [#7559](https://github.com/389ds/389-ds-base/pull/7559)
- Issue [7500](https://github.com/389ds/389-ds-base/issues/7500) - Prevent unsigned integer underflow during stalled import
- Issue [7560](https://github.com/389ds/389-ds-base/issues/7560) - lib389 - Add helper function for checking ASAN files
- Issue [7539](https://github.com/389ds/389-ds-base/issues/7539) - Server shutdown during online reindex may lead to data loss [#7540](https://github.com/389ds/389-ds-base/pull/7540)
- Issue [7549](https://github.com/389ds/389-ds-base/issues/7549) - Substring index should validate minimum nsSubStrBegin/nsSubStrEnd values [#7550](https://github.com/389ds/389-ds-base/pull/7550)
- Issue [7440](https://github.com/389ds/389-ds-base/issues/7440) - Substring index produces empty results and can crash when non-default nsSubStrBegin/nsSubStrEnd lengths are configured [#7441](https://github.com/389ds/389-ds-base/pull/7441)
- Fix test389 imports on older branches
- Issue [7267](https://github.com/389ds/389-ds-base/issues/7267) - MDB\_BAD\_VALSIZE error when updating index [#7268](https://github.com/389ds/389-ds-base/pull/7268)
- Issue [7327](https://github.com/389ds/389-ds-base/issues/7327) - dsctl healthcheck DSMOLE0001 inaccurate recommendations with multiple backends [#7328](https://github.com/389ds/389-ds-base/pull/7328)
- Issue [7372](https://github.com/389ds/389-ds-base/issues/7372) - Reindex adds tombstones to ancestorid causing export failures [#7373](https://github.com/389ds/389-ds-base/pull/7373)
- Issue [7437](https://github.com/389ds/389-ds-base/issues/7437) - LeakSanitizer: memory leaks in CoS cache error paths [#7438](https://github.com/389ds/389-ds-base/pull/7438)
- Issue [6922](https://github.com/389ds/389-ds-base/issues/6922) - AddressSanitizer: leaks found by acl test suite
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - brace-expansion [#7556](https://github.com/389ds/389-ds-base/pull/7556)
- Issue [7554](https://github.com/389ds/389-ds-base/issues/7554) - deref plugin null pointer dereference if ber\_init fails
