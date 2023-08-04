---
title: "Releases/1.4.4.x Archive"
---

389 Directory Server 1.4.4.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.0

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=43472534>

The new packages and versions are:

- 389-ds-base-1.4.4.0-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.0.tar.bz2)

### Highlights in 1.4.4.0

- Bug fixes

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

- Bump version to 1.4.4.0
- Issue 50933 - 10rfc2307compat.ldif is not ready to set used by default
- Issue 50931 - RFE AD filter rewriter for ObjectCategory
- Issue 51016 - Fix memory leaks in changelog5_init and perfctrs_init
- Issue 50980 - RFE extend usability for slapi_compute_add_search_rewriter and slapi_compute_add_evaluator
- Issue 51008 - dbhome in containers
- Issue 50875 - Refactor passwordUserAttributes's and passwordBadWords's code
- Issue 51014 - slapi_pal.c possible static buffer overflow
- Issue 50545 - remove dbmon "incr" option from arg parser
- Issue 50545 - Port dbmon.sh to dsconf
- Issue 51005 - AttributeUniqueness plugin's DN parameter should not have a default value
- Issue 49731 - Fix additional issues with setting db home directory by default
- Issue 50337 - Replace exec() with setattr()
- Issue 50905 - intermittent SSL hang with rhds
- Issue 50952 - SSCA lacks basicConstraint:CA
- Issue 50640 - Database links: get_monitor() takes 1 positional argument but 2 were given
- Issue 50869 - Setting nsslapd-allowed-sasl-mechanisms truncates the value


---
title: "Releases/1.4.4.10"
---

389 Directory Server 1.4.4.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.10

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=59728248> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-e81d94692a> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.10-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.10.tar.gz)

### Highlights in 1.4.4.10

- Bug & Security fixes

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

- Bump version to 1.4.4.10
- Issue 4418 - Fix copy and paste error
- Issue 4381 - RFE - LDAPI authentication DN rewritter
- Issue 4539 - BUG - no such file if no overlays in openldap during migration (#4540)
- Issue 4513 - CI Tests - fix test failures
- Issue 4528 - Fix cn=monitor SCOPE_ONE search (#4529)
- Issue 4535 - lib389 - healthcheck throws exception if backend is not replicated
- Issue 4504 - insure that repl_monitor_test use ldapi (for RHEL) - fix merge issue (#4533)
- Issue 4504 - Insure ldapi is enabled in repl_monitor_test.py (Needed on RHEL) (#4527)
- Issue 4506 - BUG - Fix bounds on fd table population (#4520)
- Issue 4521 - DS crash in deref plugin if dereferenced entry exists but is not returned by internal search (#4525)
- Issue 4384 - Separate eventq into REALTIME and MONOTONIC
- Issue 4418 - ldif2db - offline. Warn the user of skipped entries
- Issue 4419 - Warn users of skipped entries during ldif2db online import (#4476)
- Issue 4414 - disk monitoring - prevent division by zero crash
- Issue 4507 - Improve csngen testing task (#4508)
- Issue 4498 - BUG - entryuuid replication may not work (#4503)
- Issue 4504 - Fix pytest test_dsconf_replication_monitor (#4505)
- Issue 4480 - Unexpected info returned to ldap request (Security Fix)
- Issue 4373 - BUG - one line cleanup, free results in mt if ent 0 (#4502)
- Issue 4500 - Add cockpit enabling to dsctl
- Issue 4272 - RFE - add support for gost-yescrypt for hashing passwords (#4497)
- Issue 1795 - RFE - Enable logging for libldap and libber in error log (#4481)
- Issue 4492 - Changelog cache can upload updates from a wrong starting point (CSN) (#4493)
- Issue 4373 - BUG - calloc of size 0 in MT build (#4496)
- Issue 4483 - heap-use-after-free in slapi_be_getsuffix
- Issue 4224 - cleanup specfile after libsds removal
- Issue 4421 - Unable to build with Rust enabled in closed environment
- Issue 4229 - RFE - Improve rust linking and build performance (#4474)
- Issue 4464 - RFE - clang with ds+asan+rust
- Issue 4224 - openldap can become confused with entryuuid
- Issue 4313 - improve tests and improve readme re refdel
- Issue 4313 - fix potential syncrepl data corruption
- Issue 4315 - performance search rate: nagle triggers high rate of setsocketopt (#4437)
- Issue 4243 - Fix test (4th): SyncRepl plugin provides a wrong (#4475)
- Issue 4446 - RFE - openldap password hashers
- Issue 4403 - RFE - OpenLDAP pw hash migration tests (#4408)
- Issue 4410  -RFE - ndn cache with arc in rust
- Issue 4460 - BUG - add machine name to subject alt names in SSCA (#4472)
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4466) (#4466)


---
title: "Releases/1.4.4.11"
---

389 Directory Server 1.4.4.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.11

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=60484248> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-5258e9cb11> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.11.tar.gz)

### Highlights in 1.4.4.11

- Bug fixes

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

- Bump version to 1.4.4.11
- Issue 4548 - CLI - dsconf needs better root DN access control plugin validation
- Issue 4513 - Fix schema test and lib389 task module (#4514)
- Issue 4535 - lib389 - Fix log function in backends.py
- Issue 4534 - libasan read buffer overflow in filtercmp (#4541)



---
title: "Releases/1.4.4.12"
---

389 Directory Server 1.4.4.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.12

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=61137714> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-8e3d89c9dc> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.12-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.12.tar.gz)

### Highlights in 1.4.4.12

- Bug fixes

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

- Bump version to 1.4.4.12
- Issue 4579 - libasan detects heap-use-after-free in URP test (#4584)
- Issue 4563 - Failure on s390x: 'Fails to split RDN "o=pki-tomcat-CA" into components' (#4573)
- Issue 4526 - sync_repl: when completing an operation in the pending list, it can select the wrong operation (#4553)
- Issue 4396 - Minor memory leak in backend (#4558) (#4572)
- Issue 4324 - Performance search rate: change entry cache monitor to recursive pthread mutex (#4569)
- Issue 5442 - Search results are different between RHDS10 and RHDS11



---
title: "Releases/1.4.4.13"
---

389 Directory Server 1.4.4.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.13

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=61840324> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-23690b2925> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.13.tar.gz)

### Highlights in 1.4.4.13

- Bug and Security fixes

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

- Bump version to 1.4.4.13
- Update dscontainer (#4564)
- Issue 4591 - RFE - improve openldap_to_ds help and features (#4607)
- Issue 4324 - Some architectures the cache line size file does not exist
- Issue 4593 - RFE - Print help when nsSSLPersonalitySSL is not found (#4614)
- Issue 4609 - CVE - info disclosure when authenticating



---
title: "Releases/1.4.4.14"
---

389 Directory Server 1.4.4.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.14

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=64115273> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-3eed313617> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.14.tar.gz)

### Highlights in 1.4.4.14

- Bug and Security fixes

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

- Bump version to 1.4.4.14
- Issue 4671 - UI - Fix browser crashes
- Issue 4229 - Fix Rust linking
- Issue 4658 - monitor - connection start date is incorrect
- Issue 4656 - Make replication CLI backwards compatible with role name change
- Issue 4656 - Remove problematic language from UI/CLI/lib389
- Issue 4459 - lib389 - Default paths should use dse.ldif if the server is down
- Issue 4661 - RFE - allow importing openldap schemas (#4662)
- Issue 4659 - restart after openldap migration to enable plugins (#4660)
- Issue 4663 - CLI - unable to add objectclass/attribute without x-origin
- Issue 4169 - UI - updates on the tuning page are not reflected in the UI
- Issue 4588 - BUG - unable to compile without xcrypt (#4589)
- Issue 4513 - Fix replication CI test failures (#4557)
- Issue 4646 - CLI/UI - revise DNA plugin management
- Issue 4644 - Large updates can reset the CLcache to the beginning of the changelog (#4647)
- Issue 4649 - crash in sync_repl when a MODRDN create a cenotaph (#4652)
- Issue 4513 - CI - make acl ip address tests more robust
- Issue 4619 - remove pytest requirement from lib389
- Issue 4615 - log message when psearch first exceeds max threads per conn

---
title: "Releases/1.4.4.15"
---

389 Directory Server 1.4.4.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.15

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=65298461> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-57ef97888c> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.15-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.15.tar.gz)

### Highlights in 1.4.4.15

- Bug and Security fixes

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

- Bump version to 1.4.4.15
- Issue 4700 - Regression in winsync replication agreement (#4712)
- Issue 2736 - https://github.com/389ds/389-ds-base/issues/2736
- Issue 4706 - negative wtime in access log for CMP operations

---
title: "Releases/1.4.4.16"
---

389 Directory Server 1.4.4.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.16

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=69004283> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-67a3b7ca78> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.16.tar.gz)

### Highlights in 1.4.4.16

- Bug and Security fixes

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

- Bump version to 1.4.4.16
- Issue 4711 - SECURITY FIX - SIGSEV with sync_repl (#4738)
- Issue 4778 - RFE - Allow setting TOD for db compaction and add task
- Issue 4623 - RFE - Monitor the current DB locks (#4762)
- Issue 4725 - RFE - Update the password policy to support a Temporary Password Rules (#4727)
- Issue 4701 - RFE - Exclude attributes from retro changelog (#4723)
- Issue 4773 - RFE - Enable interval feature of DNA plugin
- Issue 4719 - lib389 - fix dsconf passthrough auth bugs
- Issue 4764 - replicated operation sometime checks ACI (#4783)
- Issue 4781 - There are some typos in man-pages
- Issue 3555 - Fix UI audit issue
- Issue 4747 - Remove unstable/unstatus tests from PRCI (#4748)
- Issue 4725 - Fix compiler warnings
- Issue 4770 - Lower FIPS logging severity
- Issue 4759 - Fix coverity issue (#4760)
- Issue 4742 - UI - should always use LDAPI path when calling CLI
- Issue 4667 - incorrect accounting of readers in vattr rwlock (#4732)
- Issue 4637 - ndn cache leak (#4724)
- Issue 4577 - Fix ASAN flags in specfile

---
title: "Releases/1.4.4.17"
---

389 Directory Server 1.4.4.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.17

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=76027095> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-1c2247a1ec> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.17-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.17.tar.gz)

### Highlights in 1.4.4.17

- Bug fixes
- Cockpit UI migrated to Patternfly 4 (fixed all security vulnerabilities)

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

- Bump version to 1.4.4.17
- Issue 4927 - rebase lib389 and cockpit in 1.4.4
- Issue 4908 - Updated several dsconf --help entries (typos, wrong descriptions, etc.)
- Issue 4912 - Account Policy plugin does not set the config entry DN
- Issue 4796 - Add support for nsslapd-state to CLI & UI
- Issue 4894 - IPA failure in ipa user-del --preserve (#4907)
- Issue 4169 - backport lib389 cert list fix
- Issue 4912 - dsidm command crashing when account policy plugin is enabled
- Issue 4910 - db reindex corrupts RUV tombstone nsuiqueid index
- Issue 4869 - Fix retro cl trimming misuse of monotonic/realtime clocks
- Issue 4696 - Password hash upgrade on bind (#4840)
- Issue 4875 - CLI - Add some verbosity to installer
- Issue 4884 - server crashes when dnaInterval attribute is set to zero
- Issue 4877 - RFE - EntryUUID to validate UUIDs on fixup (#4878)
- Issue 4734 - import of entry with no parent warning (#4735)
- Issue 4872 - BUG - entryuuid enabled by default causes replication issues (#4876)
- Issue 4763 - Attribute Uniqueness Plugin uses wrong subtree on ModRDN (#4871)
- Issue 4851 - Typos in "dsconf pwpolicy set --help" (#4867)
- Issue 4736 - lib389 - fix regression in certutil error checking
- Issue 4736 - CLI - Errors from certutil are not propagated
- Issue 4460 - Fix isLocal and TLS paths discovery (#4850)
- Issue 4443 - Internal unindexed searches in syncrepl/retro changelog
- Issue 4817 - BUG - locked crypt accounts on import may allow all passwords (#4819)
- Issue 4656 - (2nd) Remove problematic language from UI/CLI/lib389
- Issue 4262 - Fix Index out of bound in fractional test (#4828)
- Issue 4822 - Fix CI temporary password: fixture leftover breaks them (#4823)
- Issue 4656 - remove problematic language from ds-replcheck
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions (#4810)
- Issue 4788 - CLI should support Temporary Password Rules attributes (#4793)
- Issue 4506 - Improve SASL logging
- Issue 4093 - Fix MEP test case
- Issue 4747 - Remove unstable/unstatus tests (followup) (#4809)
- Issue 4789 - Temporary password rules are not enforce with local password policy (#4790)
- Issue 4797 - ACL IP ADDRESS evaluation may corrupt c_isreplication_session connection flags (#4799)
- Issue 4447 - Crash when the Referential Integrity log is manually edited
- Issue 4773 - Add CI test for DNA interval assignment
- Issue 4750 - Fix compiler warning in retrocl (#4751)

---
title: "Releases/1.4.4.19"
---

389 Directory Server 1.4.4.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.19

Fedora packages are EOL (updated for other platforms)

The new packages and versions are:

- 389-ds-base-1.4.4.19-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.19.tar.gz)

### Highlights in 1.4.4.19

- Bug fixes
- Cockpit UI - LDAP editor functional (Add, edit, delete, rename, and ACI editor)

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

- Bump version to 1.4.4.19
- Issue 5132 - Update Rust crate lru to fix CVE
- Issue 5046 - BUG - update concread (#5047)
- Issue 3555 - UI - fix audit issue with npm nanoid
- Issue 4299 - UI - Add ACI editing features
- Issue 4299 - UI LDAP editor - add "edit" and "rename" functionality
- Issue 5127 - run restorecon on /dev/shm at server startup
- Issue 4595 - Paged search lookthroughlimit bug (#4602)
- Issue 5115 -  AttributeError: type object 'build_manpages' has no attribute 'build_manpages'
- Issue 4312 - fix compiler warning
- Issue 4312 - performance search rate: contention on global monitoring counters (#4940)
- Issue 5105 - During a bind, if the target entry is not reachable the operation may complete without sending result (#5107)
- Issue 5095 - sync-repl with openldap may send truncated syncUUID (#5099)
- Issue 3584 - Add is_fips check to password tests (#5100)
- Issue 5074 - retro changelog cli updates (#5075)
- Issue 4994 - Revert retrocl dependency workaround (#4995)
- Issue 5092 - BUG - pin concread for el8.5
- Issue 5080 - BUG - multiple index types not handled in openldap migration (#5094)
- Issue 5079 - BUG - multiple ways to specific primary (#5087)
- Issue 4992 - BUG - slapd.socket container fix (#4993)
- Issue 5037 - in OpenQA changelog trimming can crashes (#5070)

- Bump version to 1.4.4.18
- Issue 4962 - Fix various UI bugs - Database and Backups (#5044)
- Issue 5046 - BUG - update concread (#5047)
- Issue 5043 - BUG - Result must be used compiler warning (#5045)
- Issue 4165 - Don't apply RootDN access control restrictions to UNIX connections
- Issue 4931 - RFE: dsidm - add creation of service accounts
- Issue 5024 - BUG - windows ro replica sigsegv (#5027)
- Issue 5020 - BUG - improve clarity of posix win sync logging (#5021)
- Issue 5008 - If a non critical plugin can not be loaded/initialized, bootstrap should succeeds (#5009)
- Issue 4962 - Fix various UI bugs - Settings and Monitor (#5016)
- Issue 5014 - UI - Add group creation to LDAP editor
- Issue 5006 - UI - LDAP editor tree not being properly updated
- Issue 5001 - Update CI test for new availableSASLMechs attribute
- Issue 4959 - Invalid /etc/hosts setup can cause isLocalHost to fail.
- Issue 5001 - Fix next round of UI bugs:
- Issue 4962 - Fix various UI bugs - dsctl and ciphers (#5000)
- Issue 4978 - use more portable python command for checking containers
- Issue 4972 - gecos with IA5 introduces a compatibility issue with previous (#4981)
- Issue 4978 - make installer robust
- Issue 4973 - update snmp to use /run/dirsrv for PID file
- Issue 4962 - Fix various UI bugs - Plugins (#4969)
- Issue 4973 - installer changes permissions on /run
- Issue 4092 - systemd-tmpfiles warnings
- Issue 4956 - Automember allows invalid regex, and does not log proper error
- Issue 4731 - Promoting/demoting a replica can crash the server
- Issue 4962 - Fix various UI bugs part 1
- Issue 3584 - Fix PBKDF2_SHA256 hashing in FIPS mode (#4949)
- Issue 4943 - Fix csn generator to limit time skew drift (#4946)
- Issue 4678 - RFE automatique disable of virtual attribute checking (#4918)
- Issue 4603 - Reindexing a single backend (#4831)
- Issue 2790 - Set db home directory by default
- Bump github contianer shm size to 4 gigs
- Issue 4299 - Merge LDAP editor code into Cockpit UI
- Issue 4938 - max_failure_count can be reached in dscontainer on slow machine with missing debug exception trace
- Issue 4921 - logconv.pl -j: Use of uninitialized value (#4922)
- Issue 4847 - BUG - potential deadlock in replica (#4936)
- Issue 4513 - fix ACI CI tests involving ip/hostname rules
- Issue 4925 - Performance ACI: targetfilter evaluation result can be reused (#4926)
- Issue 4916 - Memory leak in ldap-agent



---
title: "Releases/1.4.4.1"
---

389 Directory Server 1.4.4.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.1

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=43651906>

The new packages and versions are:

- 389-ds-base-1.4.4.1-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.1.tar.bz2)

### Highlights in 1.4.4.1

- Bug fixes

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

- Bump version to 1.4.4.1
- Issue 51024 - syncrepl_entry callback does not contain attributes added by postoperation plugins
- Issue 50877 - task to run tests of csn generator
- Issue 49731 - undo db_home_dir under /dev/shm/dirsrv for now
- Issue 48055 - CI test - automember_plugin(part3)
- Issue 51035 - Heavy StartTLS connection load can randomly fail with err=1
- Issue 51031 - UI - transition between two instances needs improvement


---
title: "Releases/1.4.4.2"
---

389 Directory Server 1.4.4.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.2

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=44234677>

The new packages and versions are:

- 389-ds-base-1.4.4.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.2.tar.bz2)

### Highlights in 1.4.4.2

- Bug fixes

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

- Bump version to 1.4.4.2
- Issue 51078 - Add nsslapd-enable-upgrade-hash to the schema
- Issue 51054 - Revise ACI target syntax checking
- Issue 51068 - deadlock when updating the schema
- Issue 51042 - try to use both c_rehash and openssl rehash
- Issue 51042 - switch from c_rehash to openssl rehash
- Issue 50992 - Bump jemalloc version and enable profiling
- Issue 51060 - unable to set sslVersionMin to TLS1.0
- Issue 51064 - Unable to install server where IPv6 is disabled
- Issue 51051 - CLI fix consistency issues with confirmations
- Issue 50655 - etime displayed has an order of magnitude 10 times smaller than it should be
- Issue 49731 - undo db_home_dir under /dev/shm/dirsrv for now
- Issue 51054 - AddressSanitizer: heap-buffer-overflow in ldap_utf8prev
- Issue 49761 - Fix CI tests
- Issue 51047 - React deprecating ComponentWillMount
- Issue 50499 - fix npm audit issues
- Issue 50545 - Port dbgen.pl to dsctl
- Issue 51027 - Test passwordHistory is not rewritten on a fail attempt
---
title: "Releases/1.4.4.3"
---

389 Directory Server 1.4.4.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.3

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=45152302>

The new packages and versions are:

- 389-ds-base-1.4.4.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.3.tar.bz2)

### Highlights in 1.4.4.3

- Bug fixes

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

- Bump version to 1.4.4.3
- Issue 50931 - RFE AD filter rewriter for ObjectCategory
- Issue 50860 - Port Password Policy test cases from TET to python3 part1
- Issue 51113 - Allow using uid for replication manager entry
- Issue 51095 - abort operation if CSN can not be generated
- Issue 51110 - Fix ASAN ODR warnings
- Issue 49850 - ldbm_get_nonleaf_ids() painfully slow for databases with many non-leaf entries
- Issue 51102 - RFE - ds-replcheck - make online timeout configurable
- Issue 51076 - remove unnecessary slapi entry dups
- Issue 51086 - Improve dscreate instance name validation
- Issue:51070 - Port Import TET module to python3 part1
- Issue 51037 - compiler warning
- Issue 50989 - ignore pid when it is ourself in protect_db
- Issue 51037 - RFE AD filter rewriter for ObjectSID
- Issue 50499 - Fix some npm audit issues
- Issue 51091 - healthcheck json report fails when mapping tree is deleted
- Issue 51079 - container pid start and stop issues
- Issue 49761 - Fix CI tests
- Issue 50610 - Fix return code when it's nothing to free
- Issue 50610 - memory leaks in dbscan and changelog encryption
- Issue 51076 - prevent unnecessarily duplication of the target entry
- Issue 50940 - Permissions of some shipped directories may change over time
- Issue 50873 - Fix issues with healthcheck tool
- Issue 51082 - abort when a empty valueset is freed
- Issue 50201 - nsIndexIDListScanLimit accepts any value


---
title: "Releases/1.4.4.4"
---

389 Directory Server 1.4.4.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.4

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46829414>

The new packages and versions are:

- 389-ds-base-1.4.4.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.4.tar.bz2)

### Highlights in 1.4.4.4

- Bug fixes

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

- Bump version to 1.4.4.4
- Issue 51175 - resolve plugin name leaking
- Issue 51187 - UI - stop importing Cockpit's PF css
- Issue 51192 - Add option to reject internal unindexed searches
- Issue 50840 - Fix test docstrings metadata-1
- Issue 50840 - Fix test docstrings metadata
- Issue 50980 - fix foo_filter_rewrite
- Issue 51165 - add more logconv stats for the new access log keywords
- Issue 50928 - Unable to create a suffix with countryName either via dscreate or the admin console
- Issue 51188 - db2ldif crashes when LDIF file can't be accessed
- Issue 50545 - Port remaining legacy tools to new python CLI
- Issue 51165 - add new access log keywords for wtime and optime
- Issue 49761 - Fix CI test suite issues ( Port remaning acceptance test suit part 1)
- Issue 51070 - Port Import TET module to python3 part2
- Issue 51142 - Port manage Entry TET suit to python 3 part 1
- Issue 50860 - Port Password Policy test cases from TET to python3 final
- Issue 50696 - Fix Allowed and Denied Ciphers lists - WebUI
- Issue 51169 - UI - attr uniqueness - selecting empty subtree crashes cockpit
- Issue 49256 - log warning when thread number is very different from autotuned value
- Issue 51157 - Reindex task may create abandoned index file
- Issue 50873 - Fix issues with healthcheck tool
- Issue 50860 - Port Password Policy test cases from TET to python3 part2
- Issue 51166 - Log an error when a search is fully unindexed
- Issue 50544 - OpenLDAP syncrepl compatability
- Issue 51161 - fix SLE15.2 install issps
- Issue 49999 - rpm.mk build-cockpit should clean cockpit_dist first
- Issue 51144 - dsctl fails with instance names that contain slapd-
- Issue 51155 - Fix OID for sambaConfig objectclass
- Issue 51159 - dsidm ou delete fails
- Issue 50984 - Memory leaks in disk monitoring
- Issue 51131 - improve mutex alloc in conntable
- Issue 49761 - Fix CI tests
- Issue 49859 - A distinguished value can be missing in an entry
- Issue 50791 - Healthcheck should look for notes=A/F in access log
- Issue 51072 - Set the default minimum worker threads
- Issue 51140 - missing ifdef
- Issue 50912 - pwdReset can be modified by a user
- Issue 50781 - Make building cockpit plugin optional
- Issue 51100 - Correct numSubordinates value for cn=monitor
- Issue 51136 - dsctl and dsidm do not errors correctly when using JSON
- Issue 137 - fix compiler warning
- Issue 50781 - Make building cockpit plugin optional
- Issue 51132 - Winsync setting winSyncWindowsFilter not working as expected
- Issue 51034 - labeledURIObject
- Issue 50545 - Port remaining legacy tools to new python CLI
- Issue 50889 - Extract pem files into a private namespace
- Issue 137 - Implement EntryUUID plugin
- Issue 51072 - improve autotune defaults
- Issue 51115 - enable samba3.ldif by default
- Issue 51118 - UI - improve modal validation when creating an instance
- Issue 50746 - Add option to healthcheck to list all the lint reports


---
title: "Releases/1.4.4.5"
---

389 Directory Server 1.4.4.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.5

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1620743>

The new packages and versions are:

- 389-ds-base-1.4.4.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.5.tar.bz2)

### Highlights in 1.4.4.5

- Bug fixes

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

- Bump version to 1.4.4.5
- Issue 4347 - log when server requires a restart for a plugin to become active (#4352)
- Issue 4297 - On ADD replication URP issue internal searches with filter containing unescaped chars (#4355)
- Issue 4350 - dsrc should warn when tls_cacertdir is invalid (#4353)
- Issue 4351 - improve generated sssd.conf output (#4354)
- Issue 4345 - import self sign cert doc comment (#4346)
- Issue 4342 - UI - additional fixes for creation instance modal
- Issue 3996 - Add dsidm rename option (#4338)
- Issue 4258 - Add server version information to UI
- Issue 4326 - entryuuid fixup did not work correctly (#4328)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (upgrade update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (UI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4322 - Fix a source link (#4332)
- Issue 4319 - Performance search rate: listener may be erroneously waken up (#4323)
- Issue 4322 - Updates old reference to pagure issue (#4321)
- Issue 4327 - Update issue templates and README.md
- Ticket 51190 - SyncRepl plugin provides a wrong cookie
- Ticket 51121 - Remove hardcoded changelog file name
- Ticket 51253 - dscreate should LDAPI to bootstrap the config
- Ticket 51177 - fix warnings
- Ticket 51228 - Fix lock/unlock wording and lib389 use of methods
- Ticket 51247 - Container Healthcheck failure
- Ticket 51177 - on upgrade configuration handlers
- Ticket 51229 - Server Settings page gets into an unresponsive state
- Ticket 51189 - integrate changelog in main database - update CLI
- Ticket 49562 - integrate changelog database to main database
- Ticket 51165 - Set the operation start time for extended ops
- Ticket 50933 - Fix OID change between 10rfc2307 and 10rfc2307compat
- Ticket 51228 - Clean up dsidm user status command
- Ticket 51233 - ds-replcheck crashes in offline mode
- Ticket 50260 - Fix test according to #51222 fix
- Ticket 50952 - SSCA lacks basicConstraint:CA
- Ticket 50933 - enable 2307compat.ldif by default
- Ticket 50933 - Update 2307compat.ldif
- Ticket 51102 - RFE - ds-replcheck - make online timeout configurable
- Ticket 51222 - It should not be allowed to delete Managed Entry manually
- Ticket 51129 - SSL alert: The value of sslVersionMax "TLS1.3" is higher than the supported version
- Ticket 49487 - Restore function that incorrectly removed by last patch
- Ticket 49481 - remove unused or unnecessary database plugin functions
- Ticket 50746 - Add option to healthcheck to list all the lint reports
- Ticket 49487 - Cleanup unused code
- Ticket 51086 - Fix instance name length for interactive install
- Ticket 51136 - JSON Error output has redundant messages
- Ticket 51059 - If dbhome directory is set online backup fails
- Ticket 51000 - Separate the BDB backend monitors
- Ticket 49300 - entryUSN is duplicated after memberOf operation
- Ticket 50984 - Fix disk_mon_check_diskspace types
- Ticket 50791 - Healthcheck to find notes=F- Bump version to 1.4.4.5
- Issue 4347 - log when server requires a restart for a plugin to become active (#4352)
- Issue 4297 - On ADD replication URP issue internal searches with filter containing unescaped chars (#4355)
- Issue 4350 - dsrc should warn when tls_cacertdir is invalid (#4353)
- Issue 4351 - improve generated sssd.conf output (#4354)
- Issue 4345 - import self sign cert doc comment (#4346)
- Issue 4342 - UI - additional fixes for creation instance modal
- Issue 3996 - Add dsidm rename option (#4338)
- Issue 4258 - Add server version information to UI
- Issue 4326 - entryuuid fixup did not work correctly (#4328)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (upgrade update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (UI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4322 - Fix a source link (#4332)
- Issue 4319 - Performance search rate: listener may be erroneously waken up (#4323)
- Issue 4322 - Updates old reference to pagure issue (#4321)
- Issue 4327 - Update issue templates and README.md
- Ticket 51190 - SyncRepl plugin provides a wrong cookie
- Ticket 51121 - Remove hardcoded changelog file name
- Ticket 51253 - dscreate should LDAPI to bootstrap the config
- Ticket 51177 - fix warnings
- Ticket 51228 - Fix lock/unlock wording and lib389 use of methods
- Ticket 51247 - Container Healthcheck failure
- Ticket 51177 - on upgrade configuration handlers
- Ticket 51229 - Server Settings page gets into an unresponsive state
- Ticket 51189 - integrate changelog in main database - update CLI
- Ticket 49562 - integrate changelog database to main database
- Ticket 51165 - Set the operation start time for extended ops
- Ticket 50933 - Fix OID change between 10rfc2307 and 10rfc2307compat
- Ticket 51228 - Clean up dsidm user status command
- Ticket 51233 - ds-replcheck crashes in offline mode
- Ticket 50260 - Fix test according to #51222 fix
- Ticket 50952 - SSCA lacks basicConstraint:CA
- Ticket 50933 - enable 2307compat.ldif by default
- Ticket 50933 - Update 2307compat.ldif
- Ticket 51102 - RFE - ds-replcheck - make online timeout configurable
- Ticket 51222 - It should not be allowed to delete Managed Entry manually
- Ticket 51129 - SSL alert: The value of sslVersionMax "TLS1.3" is higher than the supported version
- Ticket 49487 - Restore function that incorrectly removed by last patch
- Ticket 49481 - remove unused or unnecessary database plugin functions
- Ticket 50746 - Add option to healthcheck to list all the lint reports
- Ticket 49487 - Cleanup unused code
- Ticket 51086 - Fix instance name length for interactive install
- Ticket 51136 - JSON Error output has redundant messages
- Ticket 51059 - If dbhome directory is set online backup fails
- Ticket 51000 - Separate the BDB backend monitors
- Ticket 49300 - entryUSN is duplicated after memberOf operation
- Ticket 50984 - Fix disk_mon_check_diskspace types
- Ticket 50791 - Healthcheck to find notes=F
---
title: "Releases/1.4.4.6"
---

389 Directory Server 1.4.4.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.6

Fedora packages are available on Fedora 33 and Rawhide (Fedora 34).

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=54270607> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-a998e68006> - Bohdi

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=46829414>



The new packages and versions are:

- 389-ds-base-1.4.4.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.6.tar.bz2)

### Highlights in 1.4.4.6

- Bug fixes

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

- Bump version to 1.4.4.6
- Issue 4262 - Remove legacy tools subpackage (final cleanup)
- Issue 4262 - Remove legacy tools subpackage (restart instances after rpm install)
- Issue 4262 - Remove legacy tools subpackage
- Issue 2526 - revert API change in slapi_be_getsuffix()
- Issue 4363 - Sync repl: per thread structure was incorrectly initialized (#4395)
- Issue 4392 - Update create_test.py
- Issue 2820 - Fix CI tests (#4365)
- Issue 2526 - suffix management in backends incorrect
- Issue 4389 - errors log with incorrectly formatted message parent_update_on_childchange
- Issue 4295 - Fix a closing quote issue (#4386)
- Issue 1199 - Misleading message in access log for idle timeout (#4385)
- Issue 3600 - RFE - openldap migration tooling (#4318)
- Issue 4176 - import ldif2cl task should not close all changelogs
- Issue 4159 - Healthcheck code DSBLE0002 not returned on disabled suffix
- Issue 4379 - allow more than 1 empty AttributeDescription for ldapsearch, without the risk of denial of service (#4380)
- Issue 4329 - Sync repl - if a serie of updates target the same entry then the cookie get wrong changenumber (#4356)
- Issue 3555 - Fix npm audit issues (#4370)
- Issue 4372 - BUG - Chaining DB did not validate bind mech parameters (#4374)
- Issue 4334 - RFE - Task timeout may cause larger dataset imports to fail (#4359)
- Issue 4361 - RFE - add - dscreate --advanced flag to avoid user confusion
- Issue 4368 - ds-replcheck crashes when processing glue entries
- Issue 4366 - lib389 - Fix account status inactivity checks
- Issue 4265 - UI - Make the secondary plugins read-only (#4364)
- Issue 4360 - password policy max sequence sets is not working as expected
- Issue 4348 - Add tests for dsidm
- Issue 4350 - One line, fix invalid type error in tls_cacertdir check (#4358)


---
title: "Releases/1.4.4.7"
---

389 Directory Server 1.4.4.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.7

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=54409692> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-8620070857> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.7-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.7.tar.gz)

### Highlights in 1.4.4.7

- Bug fixes

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

- Bump version to 1.4.4.7
- Issue 2526 - revert backend validation check
- Issue 4262 - more perl removal cleanup
- Issue 2526 - retrocl backend created out of order

---
title: "Releases/1.4.4.8"
---

389 Directory Server 1.4.4.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.8

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=55146435> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-54dfdbe3f6> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.8.tar.gz)

### Highlights in 1.4.4.8

- Bug fixes

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

- Bump version to 1.4.4.8
- Issue 4415 - unable to query schema if there are extra parenthesis
- Issue 4176 - replication change log trimming causes high CPU

---
title: "Releases/1.4.4.9"
---

389 Directory Server 1.4.4.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.9

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=56470736> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-5f9a6218fa> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.9.tar.gz)

### Highlights in 1.4.4.9

- Bug fixes

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

- Bump version to 1.4.4.9
- Issue 4105 - Remove python.six (fix regression)
- Issue 4384 - Use MONOTONIC clock for all timing events and conditions
- Issue 4243 - Fix test: SyncRepl plugin provides a wrong cookie (#4467)
- Issue 4460 - BUG  - lib389 should use system tls policy
- Issue 3657 - Add options to dsctl for dsrc file
- Issue 3986 - UI - Handle objectclasses that do not have X-ORIGIN set
- Issue 4297 - 2nd fix for on ADD replication URP issue internal searches with filter containing unescaped chars (#4439)
- Issue 4449 - dsconf replication monitor fails to retrieve database RUV - consumer (Unavailable) (#4451)
- Issue 4105 - Remove python.six from lib389 (#4456)
- Issue 4440 - BUG - ldifgen with --start-idx option fails with unsupported operand (#4444)
- Issue 2054 - do not add referrals for masters with different data generation #2054 (#4427)
- Issue 2058 - Add keep alive entry after on-line initialization - second version (#4399)
- Issue 4373 - BUG - Mapping Tree nodes can be created that are invalid
- Issue 4428 - BUG Paged Results with critical false causes sigsegv in chaining
- Issue 4428 - Paged Results with Chaining Test Case
- Issue 4383 - Do not normalize escaped spaces in a DN
- Issue 4432 - After a failed online import the next imports are very slow
- Issue 4404 - build problems at alpine linux
- Issue 4316 - performance search rate: useless poll on network send callback (#4424)
- Issue 4429 - NULL dereference in revert_cache()
- Issue 4391 - DSE config modify does not call be_postop (#4394)
- Issue 4412 - Fix CLI repl-agmt requirement for parameters (#4422)


