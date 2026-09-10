---
title: "Releases/3.3.0"
---

389 Directory Server 3.3.0
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.3.0.

The new package and version is:

- 389-ds-base-3.3.0

Source tarball: [GitHub Releases](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.3.0)

### Highlights in 3.3.0

- Security fix for [CVE-2026-9064](https://access.redhat.com/security/cve/CVE-2026-9064) limits controls per operation.
- Add ShadowAccount fixup task and Have I Been Pwned password breach validation.
- Let healthcheck run while server is stopped, with offline disk-space checks.
- Improve container first-run setup and `dsidm` support for additional user types.
- Fix large subtree MODRDN crashes, referential-integrity updates, database bulk reads, and backup restore tests.

### Installation and Upgrade

See [Download](https://www.port389.org/docs/389ds/download.html) for package installation.

To install the server use `dnf install 389-ds-base`.

For upgrades, install the package. No further steps are required.

See [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for setup.

Changelog between 389-ds-base-3.2.1 and 389-ds-base-3.3.0:

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
