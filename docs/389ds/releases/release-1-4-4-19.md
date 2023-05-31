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



