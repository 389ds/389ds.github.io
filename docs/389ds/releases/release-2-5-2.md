---
title: "Releases/2.5.2"
---

389 Directory Server 2.5.2
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.5.2.

The new packages and versions are:

- 389-ds-base-2.5.2

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.5.2)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.5.2/389-ds-base-2.5.2.tar.bz2>

### Highlights in 2.5.2

- Enhancements
  - Issue [6142](https://github.com/389ds/389-ds-base/issues/6142) - [RFE] Add LMDB configuration related checks into Healthcheck tool [#6143](https://github.com/389ds/389-ds-base/pull/6143)
  - Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)
- Bug fixes
  - Issue [5105](https://github.com/389ds/389-ds-base/issues/5105) - lmdb - Cannot create entries with long rdn - fix covscan [#6131](https://github.com/389ds/389-ds-base/pull/6131)
  - Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
  - Issue [6049](https://github.com/389ds/389-ds-base/issues/6049) - lmdb - changelog is wrongly recreated by reindex task [#6050](https://github.com/389ds/389-ds-base/pull/6050)
  - Issue [6057](https://github.com/389ds/389-ds-base/issues/6057) - vlv search may result wrong result with lmdb [#6091](https://github.com/389ds/389-ds-base/pull/6091)
  - Issue [6105](https://github.com/389ds/389-ds-base/issues/6105) - lmdb - Cannot create entries with long rdn [#6130](https://github.com/389ds/389-ds-base/pull/6130)
  - Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
  - Issue [6155](https://github.com/389ds/389-ds-base/issues/6155) - ldap-agent fails to start because of permission error [#6179](https://github.com/389ds/389-ds-base/pull/6179)
  - Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
  - Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
  - Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
  - Issue [6227](https://github.com/389ds/389-ds-base/issues/6227) - dsconf schema does not show inChain matching rule [#6228](https://github.com/389ds/389-ds-base/pull/6228)
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

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments here:
 - 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
 - 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

Changelog between 389-ds-base-2.5.1 and 389-ds-base-2.5.2:
- Bump version to 2.5.2
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced [#6257](https://github.com/389ds/389-ds-base/pull/6257)
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced
- Issue [5327](https://github.com/389ds/389-ds-base/issues/5327) - Fix test metadata
- Security fix for [CVE-2024-6237](https://access.redhat.com/security/cve/CVE-2024-6237)
- Security fix for [CVE-2024-5953](https://access.redhat.com/security/cve/CVE-2024-5953)
- Security fix for [CVE-2024-3657](https://access.redhat.com/security/cve/CVE-2024-3657)
- Security fix for [CVE-2024-2199](https://access.redhat.com/security/cve/CVE-2024-2199)
- Issue [6265](https://github.com/389ds/389-ds-base/issues/6265) - lmdb - missing entries in range searches [#6266](https://github.com/389ds/389-ds-base/pull/6266)
- Issue [5853](https://github.com/389ds/389-ds-base/issues/5853) - Update Cargo.lock
- Issue [5962](https://github.com/389ds/389-ds-base/issues/5962) - Rearrange includes for 32-bit support logic
- Bump ws from 7.5.9 to 7.5.10 in /src/cockpit/389-console
- Bump braces from 3.0.2 to 3.0.3 in /src/cockpit/389-console
- Issue [6254](https://github.com/389ds/389-ds-base/issues/6254) - Enabling replication for a sub suffix crashes browser [#6255](https://github.com/389ds/389-ds-base/pull/6255)
- Issue [6155](https://github.com/389ds/389-ds-base/issues/6155) - ldap-agent fails to start because of permission error [#6179](https://github.com/389ds/389-ds-base/pull/6179)
- Issue [6227](https://github.com/389ds/389-ds-base/issues/6227) - dsconf schema does not show inChain matching rule [#6228](https://github.com/389ds/389-ds-base/pull/6228)
- Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
- Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
- Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
- Issue [6188](https://github.com/389ds/389-ds-base/issues/6188) - Add nsslapd-haproxy-trusted-ip to cn=schema [#6201](https://github.com/389ds/389-ds-base/pull/6201)
- Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
- Issue [6193](https://github.com/389ds/389-ds-base/issues/6193) - Test failure: test\_tls\_command\_returns\_error\_text
- Issue [6189](https://github.com/389ds/389-ds-base/issues/6189) - CI tests fail with `[Errno 2] No such file or directory: '/var/cache/dnf/metadata\_lock.pid'`
- Issue [6142](https://github.com/389ds/389-ds-base/issues/6142) - [RFE] Add LMDB configuration related checks into Healthcheck tool [#6143](https://github.com/389ds/389-ds-base/pull/6143)
- Issue [6142](https://github.com/389ds/389-ds-base/issues/6142) - Fix CI tests [#6161](https://github.com/389ds/389-ds-base/pull/6161)
- Issue [6141](https://github.com/389ds/389-ds-base/issues/6141) - freeipa test\_topology\_TestCASpecificRUVs is failing [#6144](https://github.com/389ds/389-ds-base/pull/6144)
- Issue [6136](https://github.com/389ds/389-ds-base/issues/6136) - failure in freeipa tests [#6137](https://github.com/389ds/389-ds-base/pull/6137)
- Issue [5105](https://github.com/389ds/389-ds-base/issues/5105) - lmdb - Cannot create entries with long rdn - fix covscan [#6131](https://github.com/389ds/389-ds-base/pull/6131)
- Issue [6057](https://github.com/389ds/389-ds-base/issues/6057) - Fix3 - Fix covscan issues [#6127](https://github.com/389ds/389-ds-base/pull/6127)
- Issue [6105](https://github.com/389ds/389-ds-base/issues/6105) - lmdb - Cannot create entries with long rdn [#6130](https://github.com/389ds/389-ds-base/pull/6130)
- Issue [6057](https://github.com/389ds/389-ds-base/issues/6057) - vlv search may result wrong result with lmdb - Fix 2 [#6121](https://github.com/389ds/389-ds-base/pull/6121)
- Issue [6057](https://github.com/389ds/389-ds-base/issues/6057) - vlv search may result wrong result with lmdb [#6091](https://github.com/389ds/389-ds-base/pull/6091)
- Issue [6049](https://github.com/389ds/389-ds-base/issues/6049) - lmdb - changelog is wrongly recreated by reindex task [#6050](https://github.com/389ds/389-ds-base/pull/6050)
- Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
- Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)
