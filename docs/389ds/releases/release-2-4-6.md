---
title: "Releases/2.4.6"
---

389 Directory Server 2.4.6
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.6.

Fedora packages are available on Fedora 39:

<https://koji.fedoraproject.org/koji/buildinfo?buildID=2518751> - Koji
<br>
<https://bodhi.fedoraproject.org/updates/FEDORA-2024-c8290315df> - Bodhi

The new packages and versions are:

- 389-ds-base-2.4.6

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.4.6)
- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.4.6/389-ds-base-2.4.6.tar.bz2>

### Highlights in 2.4.6

- Enhancements
  - Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - Add log buffering to audit log
  - Issue [6112](https://github.com/389ds/389-ds-base/issues/6112) - RFE - add new operation note for MFA authentications
  - Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)

- Bug fixes
  - Issue [5487](https://github.com/389ds/389-ds-base/issues/5487) - Fix various isses with logconv.pl [#6085](https://github.com/389ds/389-ds-base/pull/6085)
  - Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
  - Issue [6010](https://github.com/389ds/389-ds-base/issues/6010) - 389 ds ignores nsslapd-maxdescriptors [#6027](https://github.com/389ds/389-ds-base/pull/6027)
  - Issue [6032](https://github.com/389ds/389-ds-base/issues/6032) - Replication broken after backup restore [#6035](https://github.com/389ds/389-ds-base/pull/6035)
  - Issue [6041](https://github.com/389ds/389-ds-base/issues/6041) - dscreate ds-root - accepts relative path [#6042](https://github.com/389ds/389-ds-base/pull/6042)
  - Issue [6061](https://github.com/389ds/389-ds-base/issues/6061) - Certificate lifetime displayed as NaN
  - Issue [6080](https://github.com/389ds/389-ds-base/issues/6080) - ns-slapd crash in referint\_get\_config [#6081](https://github.com/389ds/389-ds-base/pull/6081)
  - Issue [6092](https://github.com/389ds/389-ds-base/issues/6092) - passwordHistory is not updated with a pre-hashed password [#6093](https://github.com/389ds/389-ds-base/pull/6093)
  - Issue [6110](https://github.com/389ds/389-ds-base/issues/6110) - Typo in Account Policy plugin message
  - Issue [6117](https://github.com/389ds/389-ds-base/issues/6117) - Fix the UTC offset print [#6118](https://github.com/389ds/389-ds-base/pull/6118)
  - Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
  - Issue [6125](https://github.com/389ds/389-ds-base/issues/6125) - dscreate interactive fails when chosing mdb backend [#6126](https://github.com/389ds/389-ds-base/pull/6126)
  - Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
  - Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
  - Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
  - Issue [6227](https://github.com/389ds/389-ds-base/issues/6227) - dsconf schema does not show inChain matching rule [#6228](https://github.com/389ds/389-ds-base/pull/6228)
  - Issue [6254](https://github.com/389ds/389-ds-base/issues/6254) - Enabling replication for a sub suffix crashes browser [#6255](https://github.com/389ds/389-ds-base/pull/6255)
  - Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced

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

Changelog between 389-ds-base-2.4.5 and 389-ds-base-2.4.6:
- Bump version to 2.4.6
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced [#6257](https://github.com/389ds/389-ds-base/pull/6257)
- Issue [6256](https://github.com/389ds/389-ds-base/issues/6256) - nsslapd-numlisteners limit is not enforced
- Issue [5327](https://github.com/389ds/389-ds-base/issues/5327) - Fix test metadata
- Security fix for [CVE-2024-6237](https://access.redhat.com/security/cve/CVE-2024-6237)
- Security fix for [CVE-2024-5953](https://access.redhat.com/security/cve/CVE-2024-5953)
- Security fix for [CVE-2024-3657](https://access.redhat.com/security/cve/CVE-2024-3657)
- Security fix for [CVE-2024-2199](https://access.redhat.com/security/cve/CVE-2024-2199)
- Issue [5853](https://github.com/389ds/389-ds-base/issues/5853) - Update Cargo.lock
- Issue [5962](https://github.com/389ds/389-ds-base/issues/5962) - Rearrange includes for 32-bit support logic
- Bump ws from 7.5.9 to 7.5.10 in /src/cockpit/389-console
- Bump braces from 3.0.2 to 3.0.3 in /src/cockpit/389-console
- Issue [6254](https://github.com/389ds/389-ds-base/issues/6254) - Enabling replication for a sub suffix crashes browser [#6255](https://github.com/389ds/389-ds-base/pull/6255)
- Issue [6227](https://github.com/389ds/389-ds-base/issues/6227) - dsconf schema does not show inChain matching rule [#6228](https://github.com/389ds/389-ds-base/pull/6228)
- Issue [6224](https://github.com/389ds/389-ds-base/issues/6224) - d2entry - Could not open id2entry err 0 - at startup when having sub-suffixes [#6225](https://github.com/389ds/389-ds-base/pull/6225)
- Issue [5772](https://github.com/389ds/389-ds-base/issues/5772) - ONE LEVEL search fails to return sub-suffixes [#6219](https://github.com/389ds/389-ds-base/pull/6219)
- Issue [6183](https://github.com/389ds/389-ds-base/issues/6183) - Slow ldif2db import on a newly created BDB backend [#6208](https://github.com/389ds/389-ds-base/pull/6208)
- Issue [6188](https://github.com/389ds/389-ds-base/issues/6188) - Add nsslapd-haproxy-trusted-ip to cn=schema [#6201](https://github.com/389ds/389-ds-base/pull/6201)
- Issue [6170](https://github.com/389ds/389-ds-base/issues/6170) - audit log buffering doesn't handle large updates
- Issue [6193](https://github.com/389ds/389-ds-base/issues/6193) - Test failure: test\_tls\_command\_returns\_error\_text
- Issue [6189](https://github.com/389ds/389-ds-base/issues/6189) - CI tests fail with `[Errno 2] No such file or directory: '/var/cache/dnf/metadata\_lock.pid'`
- Issue [6123](https://github.com/389ds/389-ds-base/issues/6123) - Allow DNA plugin to reuse global config for bind method and connection protocol [#6124](https://github.com/389ds/389-ds-base/pull/6124)
- Issue [6172](https://github.com/389ds/389-ds-base/issues/6172) - RFE: improve the performance of evaluation of filter component when tested against a large valueset (like group members) [#6173](https://github.com/389ds/389-ds-base/pull/6173)
- Issue [6092](https://github.com/389ds/389-ds-base/issues/6092) - passwordHistory is not updated with a pre-hashed password [#6093](https://github.com/389ds/389-ds-base/pull/6093)
- Issue [6133](https://github.com/389ds/389-ds-base/issues/6133) - Move slapi\_pblock\_set\_flag\_operation\_notes() to slapi-plugin.h
- Issue [6125](https://github.com/389ds/389-ds-base/issues/6125) - dscreate interactive fails when chosing mdb backend [#6126](https://github.com/389ds/389-ds-base/pull/6126)
- Issue [6110](https://github.com/389ds/389-ds-base/issues/6110) - Typo in Account Policy plugin message
- Issue [6080](https://github.com/389ds/389-ds-base/issues/6080) - ns-slapd crash in referint\_get\_config [#6081](https://github.com/389ds/389-ds-base/pull/6081)
- Issue [6117](https://github.com/389ds/389-ds-base/issues/6117) - Fix the UTC offset print [#6118](https://github.com/389ds/389-ds-base/pull/6118)
- Issue [5305](https://github.com/389ds/389-ds-base/issues/5305) - OpenLDAP version autodetection doesn't work
- Issue [6112](https://github.com/389ds/389-ds-base/issues/6112) - RFE - add new operation note for MFA authentications
- Issue [5842](https://github.com/389ds/389-ds-base/issues/5842) - Add log buffering to audit log
- Issue [3527](https://github.com/389ds/389-ds-base/issues/3527) - Support HAProxy and Instance on the same machine configuration [#6107](https://github.com/389ds/389-ds-base/pull/6107)
- Issue [6103](https://github.com/389ds/389-ds-base/issues/6103) - New connection timeout error breaks errormap [#6104](https://github.com/389ds/389-ds-base/pull/6104)
- Issue [6067](https://github.com/389ds/389-ds-base/issues/6067) - Improve dsidm CLI No Such Entry handling [#6079](https://github.com/389ds/389-ds-base/pull/6079)
- Issue [6096](https://github.com/389ds/389-ds-base/issues/6096) - Improve connection timeout error logging [#6097](https://github.com/389ds/389-ds-base/pull/6097)
- Issue [6010](https://github.com/389ds/389-ds-base/issues/6010) - 389 ds ignores nsslapd-maxdescriptors [#6027](https://github.com/389ds/389-ds-base/pull/6027)
- Issue [6067](https://github.com/389ds/389-ds-base/issues/6067) - Add hidden -v and -j options to each CLI subcommand [#6088](https://github.com/389ds/389-ds-base/pull/6088)
- Issue [5487](https://github.com/389ds/389-ds-base/issues/5487) - Fix various isses with logconv.pl [#6085](https://github.com/389ds/389-ds-base/pull/6085)
- Issue [6052](https://github.com/389ds/389-ds-base/issues/6052) - Paged results test sets hostname to `localhost` on test collection
- Issue [6061](https://github.com/389ds/389-ds-base/issues/6061) - Certificate lifetime displayed as NaN
- Issue [6043](https://github.com/389ds/389-ds-base/issues/6043), 6044 - Enhance Rust and JS bundling and add SPDX licenses for both [#6045](https://github.com/389ds/389-ds-base/pull/6045)
- Issue [3555](https://github.com/389ds/389-ds-base/issues/3555) - Remove audit-ci from dependencies [#6056](https://github.com/389ds/389-ds-base/pull/6056)
- Issue [6047](https://github.com/389ds/389-ds-base/issues/6047) - Add a check for tagged commits
- Issue [6041](https://github.com/389ds/389-ds-base/issues/6041) - dscreate ds-root - accepts relative path [#6042](https://github.com/389ds/389-ds-base/pull/6042)
- Issue [6032](https://github.com/389ds/389-ds-base/issues/6032) - Replication broken after backup restore [#6035](https://github.com/389ds/389-ds-base/pull/6035)
- Issue [6034](https://github.com/389ds/389-ds-base/issues/6034) - Change replica\_id from str to int
- Bump version to 2.4.5
