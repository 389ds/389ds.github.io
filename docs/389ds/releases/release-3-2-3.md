---
title: "Releases/3.2.3"
---

389 Directory Server 3.2.3
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.2.3.

The new package and version is:

- 389-ds-base-3.2.3

Source tarball: [GitHub Releases](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.2.3)

### Highlights in 3.2.3

- Security fixes for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770), [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355), [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453), [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922), [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843), [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560).
- Add sysusers.d support, modern systemd path detection, and dynamic-certificate request validation.
- Add Have I Been Pwned password breach validation and offline thread-pool saturation diagnostics.
- Prevent silent entry loss during LMDB bulk import and improve replication total initialization on high-latency storage.
- Strengthen PBKDF2 validation, deferred MemberOf updates, range searches, and online reindex safety.

See [Download](https://www.port389.org/docs/389ds/download.html) for package installation and [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for setup.

Changelog between 389-ds-base-3.2.2 and 389-ds-base-3.2.3:

- Bump version to 3.2.3
- Security fix for [CVE-2026-76560](https://access.redhat.com/security/cve/CVE-2026-76560)
- Security fix for [CVE-2026-19843](https://access.redhat.com/security/cve/CVE-2026-19843)
- Security fix for [CVE-2026-18922](https://access.redhat.com/security/cve/CVE-2026-18922)
- Security fix for [CVE-2026-18453](https://access.redhat.com/security/cve/CVE-2026-18453)
- Security fix for [CVE-2026-18355](https://access.redhat.com/security/cve/CVE-2026-18355)
- Issue [7808](https://github.com/389ds/389-ds-base/issues/7808) - CI - harden online\_import\_nosync\_test [#7809](https://github.com/389ds/389-ds-base/pull/7809)
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Remove the nightly dedup gate and fix dispatched test runs
- Migrate pwdchan to base64 0.23 Engine API
- Update rust-dependencies
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - PBKDF2 password verification should reject invalid iteration counts [#7632](https://github.com/389ds/389-ds-base/pull/7632)
- Issue [6176](https://github.com/389ds/389-ds-base/issues/6176) - Add sysusers.d support and modernize systemd path detection [#7776](https://github.com/389ds/389-ds-base/pull/7776)
- Reject mismatched cn in dynamic certificate add requests [#7680](https://github.com/389ds/389-ds-base/pull/7680)
- Fix expiration time check [#7718](https://github.com/389ds/389-ds-base/pull/7718)
- Issue [7774](https://github.com/389ds/389-ds-base/issues/7774) - Add backport action [#7775](https://github.com/389ds/389-ds-base/pull/7775)
- Issue [7770](https://github.com/389ds/389-ds-base/issues/7770) - Testimony failure in test\_cleanruv\_extop\_security.py [#7771](https://github.com/389ds/389-ds-base/pull/7771)
- [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770) - Fix StartReplicationRequest auth gate response format
- Security fix for [CVE-2026-11770](https://access.redhat.com/security/cve/CVE-2026-11770)
- Issue [7595](https://github.com/389ds/389-ds-base/issues/7595) - Skip redundant CI runs to relieve the Actions queue [#7747](https://github.com/389ds/389-ds-base/pull/7747)
- Issue [7760](https://github.com/389ds/389-ds-base/issues/7760) - CI - harden dsconf\_task\_test.py
- Issue [4701](https://github.com/389ds/389-ds-base/issues/4701) - Fix UAF when excluding attrs from retro changelog [#7730](https://github.com/389ds/389-ds-base/pull/7730)
- Issue [7723](https://github.com/389ds/389-ds-base/issues/7723) - Range search returns an empty result when its start key is removed [#7724](https://github.com/389ds/389-ds-base/pull/7724)
- Issue [7639](https://github.com/389ds/389-ds-base/issues/7639) - Move log compression outside of global write lock
- Issue [7631](https://github.com/389ds/389-ds-base/issues/7631) - Don't install bpftrace by default [#7726](https://github.com/389ds/389-ds-base/pull/7726)
- Issue [7735](https://github.com/389ds/389-ds-base/issues/7735) - Heap overflow when parsing objectclass superior [#7736](https://github.com/389ds/389-ds-base/pull/7736)
- Issue [7733](https://github.com/389ds/389-ds-base/issues/7733) - Typo about nsuniqueid in tombstone\_to\_conflict [#7734](https://github.com/389ds/389-ds-base/pull/7734)
- Issue [7707](https://github.com/389ds/389-ds-base/issues/7707) - lib389: set nsDS5ReplicaBindDNGroup before ensure\_agreement() in join\_supplier/hub/consumer [#7708](https://github.com/389ds/389-ds-base/pull/7708)
- Issue [7688](https://github.com/389ds/389-ds-base/issues/7688) - BUG - partial address leak in sso token [#7689](https://github.com/389ds/389-ds-base/pull/7689)
- Issue [7705](https://github.com/389ds/389-ds-base/issues/7705) - With memberOfEntryScope set, deferred memberOf skips MODIFY operations [#7706](https://github.com/389ds/389-ds-base/pull/7706)
- Issue [7698](https://github.com/389ds/389-ds-base/issues/7698) - Fix silent entry loss in LMDB bulk import waiter handling [#7699](https://github.com/389ds/389-ds-base/pull/7699)
- Issue [7711](https://github.com/389ds/389-ds-base/issues/7711) - Fix typo in accountpolicy --login-history-size help text [#7713](https://github.com/389ds/389-ds-base/pull/7713)
- Issue [6419](https://github.com/389ds/389-ds-base/issues/6419) - Error: name 'cockpit\_present' is not defined [#7719](https://github.com/389ds/389-ds-base/pull/7719)
- Issue [7666](https://github.com/389ds/389-ds-base/issues/7666) - Replication performance degradation during total init on high-latency storage [#7667](https://github.com/389ds/389-ds-base/pull/7667)
- Issue [7645](https://github.com/389ds/389-ds-base/issues/7645) - Add runtime LeakSanitizer leak check [#7646](https://github.com/389ds/389-ds-base/pull/7646)
- Issue [7709](https://github.com/389ds/389-ds-base/issues/7709) - Add EPEL 10 target to Packit COPR builds
- Issue [7714](https://github.com/389ds/389-ds-base/issues/7714) - UI - sass import rules are deprecated
- Issue [7658](https://github.com/389ds/389-ds-base/issues/7658) - Heap Buffer Overflow in sasl\_io\_recv() via Padded SASL UNBIND
- Issue [7710](https://github.com/389ds/389-ds-base/issues/7710) - MemberOf deferred update - Use condvar instead of sleep loop
- Issue [7637](https://github.com/389ds/389-ds-base/issues/7637) - UI - Using Arrow Keys in New Object Wizard Resulted in DOM Reload
- Issue [7578](https://github.com/389ds/389-ds-base/issues/7578) - schema - attribute refcount is not maintained properly
- Issue [7468](https://github.com/389ds/389-ds-base/issues/7468) - RFE - HIBP password breach validation [#7492](https://github.com/389ds/389-ds-base/pull/7492)
- Issue [7605](https://github.com/389ds/389-ds-base/issues/7605) - Harden CI test ports against ephemeral allocation [#7692](https://github.com/389ds/389-ds-base/pull/7692)
- Issue [7528](https://github.com/389ds/389-ds-base/issues/7528) - Retry the CI image pull instead of failing the job [#7691](https://github.com/389ds/389-ds-base/pull/7691)
- Backport Issue [7519](https://github.com/389ds/389-ds-base/issues/7519) — ignore obsolete entrydn when entryrdn is in use [#7657](https://github.com/389ds/389-ds-base/pull/7657)
- Issue [7466](https://github.com/389ds/389-ds-base/issues/7466) - UI - Refactor all TextInput number types to NumberInput
- Issue [7505](https://github.com/389ds/389-ds-base/issues/7505) - RFE - CLI - add feature to determine which password policy applies to a user
- Issue [7670](https://github.com/389ds/389-ds-base/issues/7670) - BDB range searches intermittently fail with err=1 under write load [#7671](https://github.com/389ds/389-ds-base/pull/7671)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Creating local password policy succeeds with incorrect passwordInHistory value [#7662](https://github.com/389ds/389-ds-base/pull/7662)
- Issue [7284](https://github.com/389ds/389-ds-base/issues/7284) - Automated test for creating local password policy with incorrect passwordInHistory value [#7608](https://github.com/389ds/389-ds-base/pull/7608)
- Issue [7200](https://github.com/389ds/389-ds-base/issues/7200) - repl-agmt create doesn't set some parameters [#7663](https://github.com/389ds/389-ds-base/pull/7663)
- Issue [7573](https://github.com/389ds/389-ds-base/issues/7573) - Post-import cache autotuning does not recompute entry cache size [#7574](https://github.com/389ds/389-ds-base/pull/7574)
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - Preserve legacy PBKDF2 hash compatibility [#7649](https://github.com/389ds/389-ds-base/pull/7649)
- Issue [7547](https://github.com/389ds/389-ds-base/issues/7547) - Heap buffer overflow in ldap\_utf8prev()
- Issue [7611](https://github.com/389ds/389-ds-base/issues/7611) - PBKDF2 password verification should reject invalid iteration count [#7613](https://github.com/389ds/389-ds-base/pull/7613)
- Issue [7535](https://github.com/389ds/389-ds-base/issues/7535) - Fix race in test\_schema\_update\_policy\_reject
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - Total init sends the suffix entry twice [#7640](https://github.com/389ds/389-ds-base/pull/7640)
- Issue [7635](https://github.com/389ds/389-ds-base/issues/7635) - Integer Underflow in {SMD5} Password Comparison [#7636](https://github.com/389ds/389-ds-base/pull/7636)
- Issue [7406](https://github.com/389ds/389-ds-base/issues/7406) - Fix ldap-agent SNMP stats file loading [#7630](https://github.com/389ds/389-ds-base/pull/7630)
- Issue [7621](https://github.com/389ds/389-ds-base/issues/7621) - Stack Buffer Overflow in Password checkPrefix
- Issue [7623](https://github.com/389ds/389-ds-base/issues/7623)  - Heap Buffer Overflow in 389-ds-base Audit Log Password Masking
- Issue [7602](https://github.com/389ds/389-ds-base/issues/7602) - CI - lib389 user compare fails due to parentid mismatch [#7603](https://github.com/389ds/389-ds-base/pull/7603)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - ws, js-yaml, babel/core [#7599](https://github.com/389ds/389-ds-base/pull/7599)
- Issue [7263](https://github.com/389ds/389-ds-base/issues/7263) - UI - Use cockpit.file API for temporary file writes [#7590](https://github.com/389ds/389-ds-base/pull/7590)
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - Add invalid ACL text header regression test [#7591](https://github.com/389ds/389-ds-base/pull/7591)
- Issue [7554](https://github.com/389ds/389-ds-base/issues/7554) - UI - Revise local password policy layout
- Issue [7521](https://github.com/389ds/389-ds-base/issues/7521) - UI - make changes for cockpit API updates
- Issue [7541](https://github.com/389ds/389-ds-base/issues/7541) - heap-buffer-overflows in \_\_aclp\_\_normalize\_acltxt() [#7542](https://github.com/389ds/389-ds-base/pull/7542)
- Issue [7490](https://github.com/389ds/389-ds-base/issues/7490) - Enable USDT probes by default in RPM [#7491](https://github.com/389ds/389-ds-base/pull/7491)
- Issue [7576](https://github.com/389ds/389-ds-base/issues/7576) - Fix leak of temporary attribute syntax hash tables after schema reload
- Issue [7549](https://github.com/389ds/389-ds-base/issues/7549) - Substring index should validate minimum nsSubStrBegin/nsSubStrEnd values [#7550](https://github.com/389ds/389-ds-base/pull/7550)
- Issue [7539](https://github.com/389ds/389-ds-base/issues/7539) - Server shutdown during online reindex may lead to data loss [#7540](https://github.com/389ds/389-ds-base/pull/7540)
- Issue [7558](https://github.com/389ds/389-ds-base/issues/7558) - During online import, the IDL should be created with in-depth first approach [#7559](https://github.com/389ds/389-ds-base/pull/7559)
- Issue [7500](https://github.com/389ds/389-ds-base/issues/7500) - Prevent unsigned integer underflow during stalled import
- Issue [7562](https://github.com/389ds/389-ds-base/issues/7562) - Error: NssSsl.add\_cert() got an unexpected keyword argument 'input\_file' [#7563](https://github.com/389ds/389-ds-base/pull/7563)
- Issue [7560](https://github.com/389ds/389-ds-base/issues/7560) - lib389 - Add helper function for checking ASAN files
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - UI - Fix audit issue with npm - brace-expansion [#7556](https://github.com/389ds/389-ds-base/pull/7556)
- Issue [7554](https://github.com/389ds/389-ds-base/issues/7554) - deref plugin null pointer dereference if ber\_init fails
