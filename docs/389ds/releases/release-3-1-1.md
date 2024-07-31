---
title: "Releases/3.1.1"
---

389 Directory Server 3.1.1
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 3.1.1.

Fedora packages are available on Fedora 41:

<https://koji.fedoraproject.org/koji/buildinfo?buildID=2518706> - Koji
<br>
<https://bodhi.fedoraproject.org/updates/FEDORA-2024-48c0a7fa73> - Bodhi

The new packages and versions are:

- 389-ds-base-3.1.1

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-3.1.1)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-3.1.1/389-ds-base-3.1.1.tar.bz2>

### Highlights in 3.1.1

- Enhancements
  - Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)
  - Issue [6181](https://github.com/389ds/389-ds-base/issues/6181) - RFE - Allow system to manage uid/gid at startup
  - Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - RFE - add option to write audit log in JSON format
  - Issue [6241](https://github.com/389ds/389-ds-base/issues/6241) - Add support for CRYPT-YESCRYPT [#6242](https://github.com/389ds/389-ds-base/pull/6242)

- Bug fixes
  - Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
  - Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
  - Issue [6155](https://github.com/389ds/389-ds-base/issues/6155) - ldap-agent fails to start because of permission error [#6179](https://github.com/389ds/389-ds-base/pull/6179)
  - Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
  - Issue [6175](https://github.com/389ds/389-ds-base/issues/6175) - Referential integrity plugin - in referint_thread_func does not handle null from ldap_utf8strtok [#6168](https://github.com/389ds/389-ds-base/pull/6168)
  - Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
  - Issue [6199](https://github.com/389ds/389-ds-base/issues/6199) - unprotected search query during certificate based authentication [#6205](https://github.com/389ds/389-ds-base/pull/6205)
  - Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
  - Issue [6229](https://github.com/389ds/389-ds-base/issues/6229) - After an initial failure, subsequent online backups fail [#6230](https://github.com/389ds/389-ds-base/pull/6230)
  - Issue [6254](https://github.com/389ds/389-ds-base/issues/6254) - Enabling replication for a sub suffix crashes browser [#6255](https://github.com/389ds/389-ds-base/pull/6255)
  - Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced
  - Issue [6265](https://github.com/389ds/389-ds-base/issues/6265) - lmdb - missing entries in range searches [#6266](https://github.com/389ds/389-ds-base/pull/6266)

- Security fixes:
  - [CVE-2024-6237](https://access.redhat.com/security/cve/CVE-2024-6237)
  - [CVE-2024-5953](https://access.redhat.com/security/cve/CVE-2024-5953)
  - [CVE-2024-3657](https://access.redhat.com/security/cve/CVE-2024-3657)
  - [CVE-2024-2199](https://access.redhat.com/security/cve/CVE-2024-2199)

### Installation and Upgrade

See [Download](../download.html) for information about setting up your DNF repositories.

To install the server use `dnf install 389-ds-base`

To install the Cockpit UI plugin use `dnf install cockpit-389-ds`

After rpm install completes, run `dscreate interactive`

For upgrades, simply install the package. There are no further steps required.

There are no upgrade steps besides installing the new rpms.

See [Install Guide](../howto/howto-install-389.html) for more information about the initial installation and setup.

See [Source](../development/source.html) for information about source tarballs and git access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments here:
 - 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
 - 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

### Changelog between 389-ds-base-3.1.0 and 389-ds-base-3.1.1:
- Bump version to 3.1.1
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced [#6257](https://github.com/389ds/389-ds-base/pull/6257)
- Issue [5327](https://github.com/389ds/389-ds-base/issues/5327) - Fix test metadata
- Security fix for [CVE-2024-6237](https://access.redhat.com/security/cve/CVE-2024-6237)
- Security fix for [CVE-2024-5953](https://access.redhat.com/security/cve/CVE-2024-5953)
- Security fix for [CVE-2024-3657](https://access.redhat.com/security/cve/CVE-2024-3657)
- Security fix for [CVE-2024-2199](https://access.redhat.com/security/cve/CVE-2024-2199)
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced
- Issue [6265](https://github.com/389ds/389-ds-base/issues/6265) - lmdb - missing entries in range searches [#6266](https://github.com/389ds/389-ds-base/pull/6266)
- Issue [5853](https://github.com/389ds/389-ds-base/issues/5853) - Update Cargo.lock
- Bump openssl from 0.10.64 to 0.10.66 in /src
- Issue [6245](https://github.com/389ds/389-ds-base/issues/6245) - Revert \_\_COVERITY\_\_ ifndef [#6268](https://github.com/389ds/389-ds-base/pull/6268)
- Issue [6248](https://github.com/389ds/389-ds-base/issues/6248) - fix fanalyzer warnings [#6253](https://github.com/389ds/389-ds-base/pull/6253)
- Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - Fix test\_audit\_json\_logging CI test regression [#6264](https://github.com/389ds/389-ds-base/pull/6264)
- Issue [6254](https://github.com/389ds/389-ds-base/issues/6254) - Enabling replication for a sub suffix crashes browser [#6255](https://github.com/389ds/389-ds-base/pull/6255)
- Issue [6155](https://github.com/389ds/389-ds-base/issues/6155) - ldap-agent fails to start because of permission error [#6179](https://github.com/389ds/389-ds-base/pull/6179)
- Issue [6238](https://github.com/389ds/389-ds-base/issues/6238) - RFE - add option to write audit log in JSON format
- Issue [6216](https://github.com/389ds/389-ds-base/issues/6216) - CI test\_fast\_slow\_import sometime fail [#6247](https://github.com/389ds/389-ds-base/pull/6247)
- Issue [6245](https://github.com/389ds/389-ds-base/issues/6245) - covscan fixes [#6246](https://github.com/389ds/389-ds-base/pull/6246)
- Issue [6241](https://github.com/389ds/389-ds-base/issues/6241) - Add support for CRYPT-YESCRYPT [#6242](https://github.com/389ds/389-ds-base/pull/6242)
- Issue [6229](https://github.com/389ds/389-ds-base/issues/6229) - After an initial failure, subsequent online backups fail [#6230](https://github.com/389ds/389-ds-base/pull/6230)
- Issue [6236](https://github.com/389ds/389-ds-base/issues/6236) - rpm: fix compatibility with RPM 4.20
- Issue [6227](https://github.com/389ds/389-ds-base/issues/6227) - dsconf schema does not show inChain matching rule [#6228](https://github.com/389ds/389-ds-base/pull/6228)
- Issue [6233](https://github.com/389ds/389-ds-base/issues/6233) - CI test wait\_for\_async\_feature\_test sometime fails [#6234](https://github.com/389ds/389-ds-base/pull/6234)
- Bump ws from 7.5.9 to 7.5.10 in /src/cockpit/389-console
- Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
- Issue [6222](https://github.com/389ds/389-ds-base/issues/6222) - CI test acl/test\_timeofday\_keyword sometime fails [#6223](https://github.com/389ds/389-ds-base/pull/6223)
- Issue [6120](https://github.com/389ds/389-ds-base/issues/6120) - /usr/lib64/dirsrv/plugins/libback-bdb.so has an invalid-looking DT\_RPATH: /usr/lib/dirsrv
- Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
- Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
- Issue [6207](https://github.com/389ds/389-ds-base/issues/6207) - Random crash in test\_long\_rdn CI test [#6215](https://github.com/389ds/389-ds-base/pull/6215)
- Bump braces from 3.0.2 to 3.0.3 in /src/cockpit/389-console
- Issue [6191](https://github.com/389ds/389-ds-base/issues/6191) - Node.js 16 actions are deprecated
- Issue [6199](https://github.com/389ds/389-ds-base/issues/6199) - unprotected search query during certificate based authentication [#6205](https://github.com/389ds/389-ds-base/pull/6205)
- Issue [6200](https://github.com/389ds/389-ds-base/issues/6200) - Disable WebUI CI tests
- Issue [6192](https://github.com/389ds/389-ds-base/issues/6192) - Test failure: test\_match\_large\_valueset
- Issue [6181](https://github.com/389ds/389-ds-base/issues/6181) - RFE - Allow system to manage uid/gid at startup
- Issue [6188](https://github.com/389ds/389-ds-base/issues/6188) - Add nsslapd-haproxy-trusted-ip to cn=schema [#6201](https://github.com/389ds/389-ds-base/pull/6201)
- Issue [6181](https://github.com/389ds/389-ds-base/issues/6181) - RFE - Allow system to manage uid/gid at startup [#6182](https://github.com/389ds/389-ds-base/pull/6182)
- Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
- Issue [6193](https://github.com/389ds/389-ds-base/issues/6193) - Test failure: test\_tls\_command\_returns\_error\_text
- Issue [6177](https://github.com/389ds/389-ds-base/issues/6177) - Spec file cleanup
- Issue [6189](https://github.com/389ds/389-ds-base/issues/6189) - CI tests fail with `[Errno 2] No such file or directory: '/var/cache/dnf/metadata\_lock.pid'`
- Issue [6175](https://github.com/389ds/389-ds-base/issues/6175) - Referential integrity plugin - in referint\_thread\_func does not handle null from ldap\_utf8strtok [#6168](https://github.com/389ds/389-ds-base/pull/6168)
- Issue [6186](https://github.com/389ds/389-ds-base/issues/6186) - Change default salt sizes generated in crypt\_pwd [#6185](https://github.com/389ds/389-ds-base/pull/6185)
- Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
- Issue [6159](https://github.com/389ds/389-ds-base/issues/6159) - Add a test to check URP add and delete conflict [#6160](https://github.com/389ds/389-ds-base/pull/6160)
- Issue [6151](https://github.com/389ds/389-ds-base/issues/6151) - Use %bcond macro for conditional builds in the spec file
- Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)

