---
title: "Releases/2.0.5"
---

389 Directory Server 2.0.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.5

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=69001795> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-234a7eff94> - Bohdi

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=69000250>


The new packages and versions are:

- 389-ds-base-2.0.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.5.tar.gz)

### Highlights in 2.0.5

- Bug & security fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 2.0.5
- Issue 4778 - RFE - Allow setting TOD for db compaction and add task
- Issue 4169 - UI - Port plugin tables to PF4
- Issue 4656 - Allow backward compatilbity for replication plugin name change
- Issue 4764 - replicated operation sometime checks ACI (#4783)
- Issue 2820 - Fix CI test suite issues
- Issue 4781 - There are some typos in man-pages
- Issue 4773 - Enable interval feature of DNA plugin
- Issue 4623 - RFE - Monitor the current DB locks (#4762)
- Issue 3555 - Fix UI audit issue
- Issue 4725 - Fix compiler warnings
- Issue 4770 - Lower FIPS logging severity
- Issue 4765 - database suffix unexpectdly changed from .db to .db4 (#4766)
- Issue 4725 - [RFE] DS - Update the password policy to support a Temporary Password Rules (#4727)
- Issue 4747 - Remove unstable/unstatus tests from PRCI (#4748)
- Issue 4759 - Fix coverity issue (#4760)
- Issue 4169 - UI - Migrate Buttons to PF4 (#4745)
- Issue 4714 - dscontainer fails with rootless podman
- Issue 4750 - Fix compiler warning in retrocl (#4751)
- Issue 4742 - UI - should always use LDAPI path when calling CLI
- Issue 4169 - UI - Migrate Server, Security, and Schema tables to PF4
- Issue 4667 - incorrect accounting of readers in vattr rwlock (#4732)
- Issue 4701 - RFE - Exclude attributes from retro changelog (#4723)
- Issue 4740 - Fix CI lib389 userPwdPolicy and subtreePwdPolicy (#4741)
- Issue 4711 - SECURITY FIX - SIGSEV with sync_repl (#4738)
- Issue 4734 - import of entry with no parent warning (#4735)
- Issue 4729 - GitHub Actions fails to run pytest tests
- Issue 4656 - Remove problematic language from source code
- Issue 4632 - dscontainer: SyntaxWarning: "is" with a literal.
- Issue 4169 - UI - migrate replication tables to PF4
- Issue 4637 - ndn cache leak (#4724)
- Issue 4577 - Fix ASAN flags in specfile
- Issue 4169 - UI - PF4 migration - database tables
- issue 4653 - refactor ldbm backend to allow replacement of BDB - phase 3e - dbscan (#4709)

