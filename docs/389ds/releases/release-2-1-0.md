---
title: "Releases/2.1.0"
---

389 Directory Server 2.1.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.1.0

Fedora packages are available on Fedora Rawhide (f36)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=81773299> - Koji


The new packages and versions are:

- 389-ds-base-2.1.0-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.0.tar.gz)

### Highlights in 2.1.0

- Bug and Security fixes
- Transition from BDB(libdb) to LMDB begun.  BDB is still the default backend, but it can be changed to LMDB for early testing.

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

- Bump version to 2.1.0
- Issue 5135 - UI - Disk monitoring threshold does update properly
- Issue 5129 - BUG - Incorrect fn signature in add_index (#5130)
- Issue 5132 - Update Rust crate lru to fix CVE
- Issue 3555 - UI - fix audit issue with npm nanoid
- Issue 4299 - UI - Add ACI editing features
- Issue 5127 - run restorecon on /dev/shm at server startup
- Issue 5124 - dscontainer fails to create an instance
- Issue 5098 - Multiple issues around replication and CI test test_online_reinit_may_hang (#5109)
- Issue 4939 - Redesign LMDB import (#5071)
- Issue 5113 - Increase timestamp precision for development builds
- Issue 5115 - AttributeError: type object 'build_manpages' has no attribute 'build_manpages'
- Issue 5117 - Revert skipif line from CI test (#5118)
- Issue 5102 - BUG - container may fail with bare uid/gid (#5110)
- Issue 5077 - UI - Add retrocl exclude attribute functionality (#5078)
- PR 4106 - ipa-replica-install with 389ds copr repo
- Issue 5105 - During a bind, if the target entry is not reachable the operation may complete without sending result (#5107)
- Issue 5074 - retro changelog cli updates (#5075)
- Issue 3584 - Add is_fips check to password tests (#5100)
- Issue 5095 - sync-repl with openldap may send truncated syncUUID (#5099)
- Issue 5032 - Fix OpenLDAP version check (#5091)
- Issue 5080 - BUG - multiple index types not handled in openldap migration (#5094)
- Issue 2929 - Fix github warnings
- Issue 5053 - Improve GitHub Actions debugging
- Issue 5088 - dsctl dblib broken because of a merge issue (#5089)
- Issue 5079 - BUG - multiple ways to specific primary (#5087)
- Issue 5085 - Race condition about snmp collator at startup (#5086)
- Issue 5082 - slugify: ModuleNotFoundError when running test cases
- Issue 4959 - Invalid /etc/hosts setup can cause isLocalHost to fail (#5003)
- Issue 5037 - in OpenQA changelog trimming can crashes (#5070)
- Issue 5049 - ns-slapd crash in replication/acceptance_test.py (#5063)
- Issue 4890 - Need cli to easely get simple performance statistics (#4891)
- Issue 5011 - test_replica_backup_and_restore random failure (#5066)
- Issue 4299 - UI LDAP editor - add "edit" and "rename" functionality
- Issue 5018 - RFE - openSUSE systemd hardening (#5019)
- Issue 4962 - Fix various UI bugs - Database and Backups (#5044)
- Issue 5055 - Improve core dump detection and collection in PR CI
- Issue 4994 - Revert retrocl dependency workaround (#4995)
- Issue 5046 - BUG - update concread (#5047)
- Issue 5043 - BUG - Result must be used compiler warning (#5045)
- Issue 4312 - performance search rate: contention on global monitoring counters (#4940)
- Issue 5034 - is_dbi contains an invalid debug message that trigger failure in import_tests (#5035)
- Issue 5029 - Unbind generates incorrent closed error message (#5030)
- Issue 4165 - Don't apply RootDN access control restrictions to UNIX connections
- Issue 4931 - RFE: dsidm - add creation of service accounts
- Issue 5024 - BUG - windows ro replica sigsegv (#5027)
- Issue 4758 - Add tests for WebUI
- Issue 5032 - OpenLDAP is not shipped with non-threaded version of libldap (#5033)
- Issue 5038 - BUG - dsconf tls may fail due to incorrect cert path (#5039)
- Issue 5020 - BUG - improve clarity of posix win sync logging (#5021)
- Issue 5011 - test_replica_backup_and_restore random failure (#5028)
- Issue 5025 - RFE - remove useless logging (#5026)
- Issue 5008 - If a non critical plugin can not be loaded/initialized, bootstrap should succeeds (#5009)
- Issue 4962 - Fix various UI bugs - Settings and Monitor (#5016)
- Issue 4976 - Failure in suites/import/import_test.py::test_fast_slow_import (#5017)
- Issue 5014 - UI - Add group creation to LDAP editor
- Issue 5006 - UI - LDAP editor tree not being properly updated
- Issue 4923 - issue about LMDB dbi versus txn handling (#4924)
- Issue 5001 - Update CI test for new availableSASLMechs attribute
- Issue 4959 - Invalid /etc/hosts setup can cause isLocalHost to fail.
- Issue 5001 - Fix next round of UI bugs:
- Issue 4962 - Fix various UI bugs - dsctl and ciphers (#5000)
- Issue 4734 - ldif2db - import of entry with no parent doesnt generate a warning
- Issue 4778 - [RFE] Schedule execution of "compactdb" at specific date/time
- Issue 4978 - use more portable python command for checking containers
- Issue 4990 - CI tests: improve robustness of fourwaymmr (#4991)
- Issue 4992 - BUG - slapd.socket container fix (#4993)
- Issue 4984 - BUG - pid file handling (#4986)
- Issue 4460 - python3-lib389 ignore the configuration parameters from … (#4906)
- Issue 4982 - BUG - missing inttypes.h (#4983)
- Issue 4758 - Add tests for WebUI
- Issue 4972 - gecos with IA5 introduces a compatibility issue with previous (#4981)
- Issue 4096 - Missing perl dependencies for logconv.pl
- Issue 4758 - Add tests for WebUI
- Issue 4978 - make installer robust
- Issue 4898 - Implement bdb to lmdb CLI migration tools (#4952)
- Issue 4976 - Failure in suites/import/import_test.py::test_fast_slow_import
- Issue 4973 - update snmp to use /run/dirsrv for PID file
- Issue 4973 - installer changes permissions on /run
- Issue 4959 - BUG - Invalid /etc/hosts setup can cause isLocalHost (#4960)
- Issue 4962 - Fix various UI bugs - Plugins (#4969)
- Issue 4092 - systemd-tmpfiles warnings
- Issue 4956 - Automember allows invalid regex, and does not log proper error
- Issue 4731 - Promoting/demoting a replica can crash the server
- Issue 4962 - Fix various UI bugs part 1
- Issue 3584 - Fix PBKDF2_SHA256 hashing in FIPS mode (#4949)
- Issue 4943 - Fix csn generator to limit time skew drift (#4946)
- Issue 4954 - pytest is killed by OOM killer when the whole test suite is executed
- Issue 2790 - Set db home directory by default
- Issue 4299 - Merge LDAP editor code into Cockpit UI
- Issue 4938 - max_failure_count can be reached in dscontainer on slow machine with missing debug exception trace
- Issue 4921 - logconv.pl -j: Use of uninitialized value (#4922)
- Issue 4896 - improve CI tests report in case of SERVER_DOWN exception (#4897)
- Issue 4678 - RFE automatique disable of virtual attribute checking (#4918)
- Issue 4847 - BUG - potential deadlock in replica (#4936)
- Issue 4513 - fix ACI CI tests involving ip/hostname rules
- Issue 4925 - Performance ACI: targetfilter evaluation result can be reused (#4926)
- Issue 4916 - Memory leak in ldap-agent
- Issue 4656 - DS Remove problematic language from CLI tools and UI (#4893)
- Issue 4908 - Updated several dsconf --help entries (typos, wrong descriptions, etc.)
- Issue 4912 - Account Policy plugin does not set the config entry DN
- Issue 4863 - typoes in logconv.pl
- Issue 4796 - Add support for nsslapd-state to CLI & UI
- Issue 4894 - IPA failure in ipa user-del --preserve (#4907)
- Issue 4914 - BUG - resolve duplicate stderr with clang (#4915)
- Issue 4912 - dsidm command crashing when account policy plugin is enabled
- Issue 4910 - db reindex corrupts RUV tombstone nsuiqueid index
- Issue 4577 - Add GitHub actions
- Issue 4901 - Add COPR integration
- Issue 4869 - Fix retro cl trimming misuse of monotonic/realtime clocks
- Issue 4889 - bdb lock deadlock while reindex/import vlv index (#4892)
- Issue 4773 - Extend CI tests for DNA interval assignment
- Issue 4887 - UI - fix minor regression from camelCase fixup
- Issue 4887 - UI - Update webpack.config.js and package.json
- Issue 4725 - [RFE] DS - Update the password policy to support Temporary Password Rules (#4853)
- Issue 4149 - UI - Migrate the remaining components to PF4
- Issue 4169 - Migrate Replication & Schema tabs to PF4
- Issue 4875 - CLI - Add some verbosity to installer
- Issue 4884 - server crashes when dnaInterval attribute is set to zero
- Issue 4699 - backend redesign phase 4 - db-mdb plugin implementation (#4716)
- Issue 4877 - RFE - EntryUUID to validate UUIDs on fixup (#4878)
- Issue 4872 - BUG - entryuuid enabled by default causes replication issues (#4876)
- Issue 4775 - Add entryuuid CLI and Fixup (#4776)
- Issue 4763 - Attribute Uniqueness Plugin uses wrong subtree on ModRDN (#4871)
- Issue 4851 - Typos in "dsconf pwpolicy set --help" (#4867)
- Issue 4096 - Missing perl dependencies for logconv.pl
- Issue 4736 - lib389 - fix regression in certutil error checking

