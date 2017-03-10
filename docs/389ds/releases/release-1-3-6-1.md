---
title: "Releases/1.3.6.1"
---
389 Directory Server 1.3.6.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.1.

Fedora packages are available from the Fedora 26 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.6.1-2

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.6.1.tar.bz2)

### Highlights in 1.3.6.1

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.6.1
- Issue 49162 - Only check event.m4 if nunc-stans is enabled
- Issue 49156 - Add more IDs and fix docstrings
- Issue 49156 - Fix typo in the import
- Ticket 49160 - Fix sds benchmark and copyright
- Issue 47536 - Fix CI testcase
- Issue 49159 - test_schema_comparewithfiles fails with python-ldap>=2.4.26
- Issue 49156 - Clean up test suites dir structure and docstrings
- Issue 49158 - fix latest coverity issues
- Ticket 49155 - Fix db2ldif path in test
- Issue 49122 - Fix rpm build
- Issue 49044 - Fix script usage and man pages
- Ticket 48707 - Update rfc to accomodate that authid is mandatory
- Ticket 49141 - Enable tcmalloc
- Ticket 49142 - bytes vs unicode in plugin tests
- Ticket 49139 - Update makefile and rpm for import
- Ticket 49139 - Import libsds and nunc-stans for bundling
- Issue 49122 - Filtered nsrole that uses nsrole crashes the  server
- Issue 49147 - Fix tests compatibility with older versions
- Issue 49141 - Fix spec file for tcmalloc
- Issue 49141 - Use tcmalloc by default
- Ticket 49086 - SDN premangaling broken after SASL change
- Ticket 49137 - Add sasl plain test - ds
- Ticket 49138 - Increase systemd timout
- Issue 48226 - Fix CI test
- Ticket 49140 - Remove legacy inst reference in test
- Ticket 49134  Remove hardcoded elements from db lock test
- Fix compiler warning
- Ticket 47925 - Move add and delete operation aci checks to be before plugins.
- Ticket 49086 - public api compatability test for SDN changes.
- Ticket 49116 - Pblock usage analytics
- Ticket 49020 - Add CI test
- Revise README for pagure
- Ticket #49121 - ns-slapd crashes in ldif_sput due to the output buf size is less than the real size.
- Ticket 48085 - Add replica acceptance test suite
- Ticket 49008 - Fix regression in check if ruv element exists
- Ticket 49108 - ds_selinux_port_query doesn't detect ports labeled with range
- Ticket 49057 - Fix tests failures on older versions of DS
- Ticket 49111 - Integrate cmocka skeleton to Directory Server
- Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Ticket 48085 - Add single master replication test suite
- Ticket #49104 - Add CI test
- Ticket #49104 - dbscan-bin crashing due to a segmentation fault
- Ticket 49105 - Sig FPE when ns-slapd has 0 backends.
- Ticket 49075 - Adjust log severity levels
- Ticket 49008 - Add CI test
- Ticket 49008 v2: aborted operation can leave RUV in incorrect state
- Ticket 47973 - CI Test case (test_ticket47973_case)
- Ticket 47973 - CI Test case (test_ticket47973_case)
- Ticket 47973 - custom schema is registered in small caps after schema reload
- Ticket 49089 - List library build deps
- Ticket 49085 - Make a short topology fixture alias
- Ticket #49088 - 389-ds-base rpm postinstall script bugs
- Ticket 49028 - Autosize database cache by default.
- Ticket 49089 - Fix invalid cxxlink statement from hpux
- Ticket 49087 - ds resolve jenkins issues.
- Ticket #49082 - Adjusted the CI test case to the fix.
- Ticket #49082 - Fix password expiration related shadow attributes
- Ticket #49080 - shadowExpire should not be a calculated value
- Ticket 49027 - on secfailure do not store cleartext password content
- Ticket 49031 - Improve memberof with a cache of ancestors for groups
- Ticket 49079: deadlock on cos cache rebuild
- Ticket 48665 - Fix RHEL6 test compatibility issues
- Ticket 49055 - Fix create_test.py issues
- Ticket 48797 - Add freebsd support to ns-slapd: main
- Ticket 49055 - Refactor create_test.py
- Ticket 49060 - Increase number of masters, hubs and consumers in topology
- Ticket 49055 - Clean up test tickets and suites
- Ticket 48964 - should not free repl name after purging changelog
- Ticket 48050 - Refactor acctpolicy_plugin suite
- Ticket 48964 - cleanallruv changelog purging removes wrong  rid
- Ticket 49073: nsDS5ReplicatedAttributeListTotal fails when excluding no attribute
- Ticket 49074 - incompatible nsEncryptionConfig object definition prevents RHEL 7->6 schema replication
- Ticket 48835 - package tests into python site packages - fix rpm
- Ticket 49066 - Memory leaks in server - part 2
- Ticket 49072 - validate memberof fixup task args
- Ticket 49071 - Import with duplicate DNs throws unexpected errors
- Ticket 47858 - Add test case for nsTombstone
- Ticket 48835 - Tests with setup.py.in
- Ticket 49066 - Memory leaks in server
- Ticket 47982 - Add CI test suite ds_logs
- Ticket 49052 - Environment quoting on fedora causes ds to fail to start.
- Ticket 47662 - Better input argument validation and error messages for cli tools
- Ticket 48681 - logconv.pl lists sasl binds with no dn as anonymous
- Ticket 48861: memberof plugin tests suite
- Ticket 48861: Memberof plugins can update several times the same entry to set the same values
- Ticket 48163 - Re-space schema.c
- Ticket 48163 - Read schema from multiple locations
- Ticket 48894 - improve entrywsi delete
- Ticket 49051 - Enable SASL LOGIN/PLAIN support as a precursor to LDAPSSOTOKEN
- Ticket 49020 - do not treat missing csn as fatal
- Ticket 48133 v2 Non tombstone entry which dn starting with "nsuniqueid=...," cannot be delete
- Ticket 49055 - Clean up test suites
- Ticket 48797 - Add freebsd support to ns-slapd: Configure and makefile.
- Ticket 48797 - Add freebsd support to ns-slapd: Add freebsd support for ldaputil
- Ticket 48797 - Add freebsd support to ns-slapd: Add support for dsktune
- Ticket 48797 - Add freebsd support to ns-slapd: Add support for cpp in Fbsd
- Ticket 48797 - Add freebsd support to ns-slapd: Header files
- Ticket 48978 - Fix implicit function declaration
- Ticket 49002 - Remove memset on allocation
- Ticket 49021 - Automatic thread tuning
- Ticket 48894 - Issues with delete of entrywsi with large entries.
- Ticket 49054 - Fix sasl_map unused paramater compiler warnings.
- Ticket 48050 - Add test suite to acctpolicy_plugin
- Ticket 49048 - Fix rpm build failure
- Ticket 49042 - Test failure that expects old default
- Ticket 49042 - Increase cache defaults slightly
- Ticket 48894 - Issue with high number of entry state objects.
- Ticket 48978 - Fix more log refactoring issues
- Ticket 48707 - Draft Ldap SSO Token proposal
- Ticket 49024 - Fix the rest of the CI failures
- Ticket #48987 - Heap use after free in dblayer_close_indexes
- Ticket 48945 - Improve db2ldif error message.
- Ticket 49024 - Fix inst_dir parameter in defaults.inf
- Ticket 49024 - Fix dbdir paths and adjust test cases
- Ticket 48961 - Allow reset of configuration values to defaults.
- Ticket #47911 - Move dirsrv-snmp.service to 389-ds-base-snmp package
- Ticket bz1358565 - Fix compiler warning about unused variable
- Ticket bz1358565 -  clear and unsalted password types are vulnerable to timing attack
- Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Ticket 397 - Add PBKDF2 to Directory Server password storage.
- Ticket 49024 - Fix CI test failures and defaults.inf
- Ticket 49026 - Support nunc-stans pkgconfig
- Ticket 49025 - Upgrade nunc-stans to 0.2.1
- Ticket 48978 - error log refactoring error
- Ticket 49013 - Correct signal handling with NS in DS
- Ticket 49017 - Various minor test failures
- Ticket 48947 - Update default password hash to SSHA512
- Ticket 48328 - Add missing dependency
- Ticket 49009 - args debug logging must be more restrictive
- Ticket 49011 - Remove configure artifacts
- Ticket 48272 - Fix compiler warnings for addn
- Ticket 49014 - ns-accountstatus.pl shows wrong status for accounts inactivated by Account policy plugin
- Ticket 48978 - Fine tune error logging
- Ticket 48982 - Comment about resolving failure to open plugin.
- Ticket 48272 - ADDN Sytle prebind plugin
- Ticket 49012 - Removed un-used counters
- Ticket 47703 - remove search limit for aci group evaluation
- Ticket 48978 - Fix logging format errors and replace LDAP_DEBUG
- Ticket 49006 - Nunc stans use DS stack size
- Ticket 49007 - Update configure scripts
- Ticket 48538 - Failed to delete old semaphore
- Ticket 48978 - Build fails on i686
- Ticket 48909 - Replication stops working in FIPS mode
- Ticket 49007 - Update DS basic test to better work with systemd.
- Ticket 49006 - Enable nunc-stans by default.
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 49005 - Update lib389 to work in containers correctly.
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 48982 - When plugin doesn't enable, actually log the path it used
- Ticket 48996 - Fix rpm to work with ns 0.2.0
- Ticket 48996 - remove unused variable.
- Ticket 48996 - update DS for ns 0.2.0
- Ticket 48982 - One line fix, remove unused variable.
- Ticket 48982 - Enabling a plugin that has a versioned so causes overflow
- Ticket 48986 - 47808 triggers overflow in uiduniq.c
- Ticket 48978 - Convert slapi_log_error() to a variadic macro
- Ticket 48992: Total init may fail if the pushed schema is rejected
- Ticket 48978 - Fix CI test to account for new logging format
- Ticket 48978 - Update error logging with new codes
- Ticket 48832 - Fix CI test suite for password min age
- Ticket 48984 - Add lib389 paths module
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48944 - on a read only replica invalid state info can accumulate
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48983 -  generate install path info from autotools scripts
- use a consumer maxcsn only as anchor if supplier is more advanced
- Ticket 48921 - CI Replication stress tests have limits set too low
- Ticket 48906 Allow nsslapd-db-locks to be configurable online
- Ticket 47978 - Refactor slapi_log_error
- Ticket48978 - refactor LDAPDebug()
- Ticket 48978 - Update the logging function to accept sev level
- Ticket 48414 - cleanAllRUV should clean the agreement RUV
- Ticket 48979 - Strict Prototypes
- Ticket 48979 - Allow to compile 389ds with warning Wstrict-prototypes
- Ticket 142 - Refactor and move CI test
- Ticket 48278 - cleanAllRUV should remove keep-alive entry
- Ticket #48969 - nsslapd-auditfaillog always has an explicit path
- Ticket 48957 - Update repl-monitor to handle new status messages
- Ticket 48805 - Sign comparison checks.
- Ticket #48896 - CI test: test case for ticket 48896
- Ticket #48896 - Default Setting for passwordMinTokenLength does not work
- Ticket 48805 - Sign comparison checks.
- Ticket 48805 - Misleading indent and Uninitialised struct member
- Bump version to 1.3.6.0

