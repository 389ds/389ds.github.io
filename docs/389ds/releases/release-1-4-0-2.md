---
title: "Releases/1.4.0.2"
---

389 Directory Server 1.4.0.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.2

Fedora packages are available on Fedora 28(rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22894633>

The new packages and versions are:

-   389-ds-base-1.4.0.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.2.tar.bz2)

### Highlights in 1.4.0.2

- Version change

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.2
- Ticket 48393 - fix copy and paste error
- Ticket 49439 - cleanallruv is not logging information
- Ticket 48393 - Improve replication config validation
- Ticket lib389 3 - Python 3 support for ACL test suite
- Ticket 103 - sysconfig not found
- Ticket 49436 - double free in COS in some conditions
- Ticket 48007 - CI test to test changelog trimming interval
- Ticket 49424 - Resolve csiphash alignment issues
- Ticket lib389 3 - Python 3 support for pwdPolicy_controls_test.py
- Ticket 3 - python 3 support - filter test
- Ticket 49434 - RPM build errors
- Ticket 49432 - filter optimise crash
- Ticket 49432 - Add complex fliter CI test
- Ticket 48894 - harden valueset_array_to_sorted_quick valueset  access
- Ticket 49401 - Fix compiler incompatible-pointer-types warnings
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 49409 - Update lib389 requirements
- Ticket 49401 - improve valueset sorted performance on delete
- Ticket 49374 -  server fails to start because maxdisksize is recognized incorrectly
- Ticket 49408 - Server allows to set any nsds5replicaid in the existing replica entry
- Ticket 49407 - status-dirsrv shows ellipsed lines
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 49386 - Memberof should be ignore MODRDN when the pre/post entry are identical
- Ticket 48006 - Missing warning for invalid replica backoff  configuration
- Ticket 49064 - testcase hardening
- Ticket 49064 - RFE allow to enable MemberOf plugin in dedicated consumer
- Ticket lib389 3 - python 3 support
- Ticket 49402 - Adding a database entry with the same database name that was deleted hangs server at shutdown
- Ticket 48235 - remove memberof lock (cherry-pick error)
- Ticket 49394 - build warning
- Ticket 49381 - Refactor numerous suite docstrings - Part 2
- Ticket 49394 - slapi_pblock_get may leave unchanged the provided variable
- Ticket 49403 - tidy ns logging
- Ticket 49381 - Refactor filter test suite docstrings
- Ticket 48235 - Remove memberOf global lock
- Ticket 103 - Make sysconfig where it is expected to exist
- Ticket 49400 - Add clang support to rpm builds
- Ticket 49381 - Refactor ACL test suite docstrings
- Ticket 49363 - Merge lib389
- Ticket 101 - BaseException.message has been deprecated in Python3
- Ticket 102 - referral support
- Ticket 99 - Fix typo in create_topology
- Ticket #98 - Fix dbscan output
- Ticket #77 - Fix changelogdb param issue
- Ticket #77 - Refactor docstrings in rST format - part 1
- Ticket 96 - Change binaries' names
- Ticket 77 - Add sphinx documentation
- Ticket 43 - Add support for Referential Integrity plugin
- Ticket 45 - Add support for Rootdn Access Control plugin
- Ticket 46 - dsconf support for dynamic schema reload
- Ticket 74 - Advice users to set referint-update-delay to 0
- Ticket 92 - display_attr() should return str not bytes in py3
- Ticket 93 - Fix test cases in ctl_dbtasks_test.py
- Ticket 88 - python install and remove for tests
- Ticket 85 - Remove legacy replication attribute
- Ticket 91 - Fix replication topology
- Ticket 89 - Fix inconsistency with serverid
- Ticket 79 - Fix replica.py and add tests
- Ticket 86 - add build dir to gitignore
- Ticket 83 - Add an util for generating instance parameters
- Ticket 87 - Update accesslog regec for HR etimes
- Ticket 49 - Add support for whoami plugin
- Ticket 48 - Add support for USN plugin
- Ticket 78 - Add exists() method to DSLdapObject
- Ticket 31 - Allow complete removal of some memberOf attrs
- Ticket31 - Add memberOf fix-up task
- Ticket 67 - Add ensure_int function
- Ticket 59 - lib389 support for index management.
- Ticket 67 - get attr by type
- Ticket 70 - Improve repl tools
- Ticket 50 - typo in db2* in dsctl
- Ticket 31 - Add status command and SkipNested support for MemberOf
- Ticket 31 - Add functional tests for MemberOf plugin
- Ticket 66 - expand healthcheck for Directory Server
- Ticket 69 - add specfile requires
- Ticket 31 - Initial MemberOf plugin support
- Ticket 50 - Add db2* tasks to dsctl
- Ticket 65 - Add m2c2 topology
- Ticket 63 - part 2, agreement test
- Ticket 63 - lib389 python 3 fix
- Ticket 62 - dirsrv offline log
- Ticket 60 - add dsrc to dsconf and dsidm
- Ticket 32 - Add TLS external bind support for testing
- Ticket 27 - Fix get function in tests
- Ticket 28 - userAccount for older versions without nsmemberof
- Ticket 27 - Improve dseldif API
- Ticket 30 - Add initial support for account lock and unlock.
- Ticket 29 - fix incorrect format in tools
- Ticket 28 - Change default objectClasses for users and groups
- Ticket 1 - Fix missing dn / rdn on config.
- Ticket 27 - Add a module for working with dse.ldif file
- Ticket 1 - cn=config comparison
- Ticket 21 - Missing serverid in dirsrv_test due to incorrect allocation
- Ticket 26 - improve lib389 sasl support
- Ticket 24 - Join paths using os.path.join instead of string concatenation
- Ticket 25 - Fix RUV __repr__ function
- Ticket 23 - Use DirSrv.exists() instead of manually checking for instance's existence
- Ticket 1 - cn=config comparison
- Ticket 22 - Specify a basedn parameter for IDM modules
- Ticket 19 - missing readme.md in python3
- Ticket 20 - Use the DN_DM constant instead of hard coding its value
- Ticket 19 - Missing file and improve make
- Ticket 14 - Remane dsadm to dsctl
- Ticket 16 - Reset InstScriptsEnabled argument during the init
- Ticket 14 - Remane dsadm to dsctl
- Ticket 13 - Add init function to create new domain entries
- Ticket 15 - Improve instance configuration ability
- Ticket 10 - Improve command line tool arguments
- Ticket 9 - Convert readme to MD
- Ticket 7 - Add pause and resume methods to topology fixtures
- Ticket 49172 - Allow lib389 to read system schema and instance
- Ticket 49172 - Allow lib389 to read system schema and instance
- Ticket 6 - Bump lib389 version 1.0.4
- Ticket 5 - Fix container build on fedora
- Ticket 4 - Cert detection breaks some tests
- Ticket 49137 - Add sasl plain tests, lib389 support
- Ticket 2 - pytest mark with version relies on root
- Ticket 49126 - DIT management tool
- Ticket 49101 - Python 2 generate example entries
- Ticket 49103 - python 2 support for installer
- Ticket 47747 - Add topology_i2 and topology_i3
- Ticket 49087 - lib389 resolve jenkins issues
- Ticket 48413 - Improvements to lib389 for rest
- Ticket 49083 - Support prefix for discovery of the defaults.inf file.
- Ticket 49055 - Fix debugging mode issue
- Ticket 49060 - Increase number of masters, hubs and consumers in topology
- Ticket 47747 - Add more topology fixtures
- Ticket 47840 - Add InstScriptsEnabled argument
- Ticket 47747 - Add topology fixtures module
- Ticket 48707 - Implement draft-wibrown-ldapssotoken-01
- Ticket 49022 - Lib389, py3 installer cannot create entries in backend
- Ticket 49024 - Fix paths to the dbdir parent
- Ticket 49024 - Fix db_dir paths
- Ticket 49024 - Fix paths in tools module
- Ticket 48961 - Fix lib389 minor issues shown by 48961 test
- Ticket 49010 - Lib389 fails to start with systemctl changes
- Ticket 49007 - lib389 fixes for paths to use online values
- Ticket 49005 - Update lib389 to work in containers correctly.
- Ticket 48991 - Fix lib389 spec for python2 and python3
- Ticket 48984 - Add lib389 paths module
- Ticket 48951 - dsadm dsconfig status and plugin
- Ticket 47957 - Update the replication "idle" status string
- Ticket 48951 - dsadm and dsconf base files
- Ticket 48952 - Restart command needs a sleep
- Ticket 48949 - Fix ups for style and correctness
- Ticket 48949 - added copying slapd-collations.conf
- Ticket 48949 - change default file path generation - use os.path.join
- Ticket 48949 - os.makedirs() exist_ok not python2 compatible, added try/except
- Ticket 48949 - configparser fallback not python2 compatible
- Ticket 48946 - openConnection should not fully popluate DirSrv object
- Ticket 48832 - Add DirSrvTools.getLocalhost() function
- Ticket 48382 - Fix serverCmd to get sbin dir properly
- Bug 1347760 - Information disclosure via repeated use of LDAP ADD operation, etc.
- Ticket 48937 - Cleanup valgrind wrapper script
- Ticket 48923 - Fix additional issue with serverCmd
- Ticket 48923 - serverCmd timeout not working as expected
- Ticket 48917 - Attribute presence
- Ticket 48911 - Plugin improvements for lib389
- Ticket 48911 - Improve plugin support based on new mapped objects
- Ticket 48910 - Fixes for backend tests and lib389 reliability.
- Ticket 48860 - Add replication tools
- Ticket 48888 - Correction to create of dsldapobject
- Ticket 48886 - Fix NSS SSL library in lib389
- Ticket 48885 - Fix spec file requires
- Ticket 48884 - Bugfixes for mapped object and new connections
- Ticket 48878 - better style for backend in backend_test.py
- Ticket 48878 - pep8 fixes part 2
- Ticket 48878 - pep8 fixes and fix rpm to build
- Ticket 48853 - Prerelease installer
- Ticket 48820 - Begin to test compatability with py.test3, and the new orm
- Ticket 48434 - Fix for negative tz offsets
- Ticket 48857 - Remove python-krbV from lib389
- Ticket 48820 - Fix tests to ensure they work with the new object types
- Ticket 48820 - Move Encryption and RSA to the new object types
- Ticket 48820 - Proof of concept of orm style mapping of configs and objects
- Ticket 48820 - Clitool rename
- Ticket 48431 - lib389 integrate ldclt
- Ticket 48434 - lib389 logging tools
- Ticket 48796 - add function to remove logs
- Ticket 48771 - lib389 - get ns-slapd version
- Ticket 48830 - Convert lib389 to ip route tools
- Ticket 48763 - backup should run regardless of existing backups.
- Ticket 48434 - lib389 logging tools
- Ticket 48798 - EL6 compat for lib389 tests for DH params
- Ticket 48798 - lib389 add ability to create nss ca and certificate
- Ticket 48433 - Aci linting tools
- Ticket 48791 - format args in server tools
- Ticket 48399 - Helper makefile is missing mkdir dist
- Ticket 48399 - Helper makefile is missing mkdir dist
- Ticket 48794 - lib389 build requires are on a single line
- Ticket 48660 - Add function to convert binary values in an entry to base64
- Ticket 48764 - Fix mit krb password to be random.
- Ticket 48765 - Change default ports for standalone topology
- Ticket 48750 - Clean up logging to improve command experience
- Ticket 48751 - Improve lib389 ldapi support
- Ticket 48399 - Add helper makefile to lib389 to build and install
- Ticket 48661 - Agreement test suite fails at the test_changes case
- Ticket 48407 - Add test coverage module for lib389 repo
- Ticket 48357 - clitools should standarise their args
- Ticket 48560 - Make verbose handling consistent
- Ticket 48419 - getadminport() should not a be a static method
- Ticket 48408 - RFE escaped default suffix for tests
- Ticket 48401 - Revert typecheck
- Ticket 48401 - lib389 Entry hasAttr returs dict instead of false
- Ticket 48390 - RFE Improvements to lib389 monitor features for rest389
- Ticket 48358 - Add new spec file
- Ticket 48371 - weaker host check on localhost.localdomain
- Ticket 58358 - Update spec file with pre-release versioning
- Ticket 48358 - Make Fedora packaging changes to the spec file
- Ticket 48358 - Prepare lib389 for Fedora Packaging
- Ticket 48364 - Fix test failures
- Ticket 48360 - Refactor the delete agreement function
- Ticket 48361 - Expand 389ds monitoring capabilities
- Ticket 48246 - Adding license/copyright to lib389 files
- Ticket 48340 - Add basic monitor support to lib389 https://fedorahosted.org/389/ticket/48340
- Ticket 48353 - Add Replication REST support to lib389
- Ticket 47840 - Fix regression
- Ticket 48343 - lib389 krb5 realm management https://fedorahosted.org/389/ticket/48343
- Ticket 47840 - fix lib389 to use sbin scripts  https://fedorahosted.org/389/ticket/47840
- Ticket 48335 - Add SASL support to lib389
- Ticket 48329 - Fix case-senstive scyheam comparisions
- Ticket 48303 - Fix lib389 broken tests
- Ticket 48329 - add matching rule functions to schema module
- Ticket 48324 - fix boolean capitalisation (one line) https://fedorahosted.org/389/ticket/48324
- Ticket 48321 - Improve is_a_dn check to prevent mistakes with lib389 auth https://fedorahosted.org/389/ticket/48321
- Ticket 48322 - Allow reindex function to reindex all attributes
- Ticket 48319 - Fix ldap.LDAPError exception processing
- Ticket 48318 - Do not delete a changelog while disabling a replication by suffix
- Ticket 48308 - Add __eq__ and __ne__ to Entry to allow fast comparison https://fedorahosted.org/389/ticket/48308
- Ticket 48303 - Fix lib389 broken tests - backend_test
- Ticket 48309 - Fix lib389 lib imports
- Ticket 48303 - Fix lib389 broken tests - agreement_test
- Ticket 48303 - Fix lib389 broken tests - aci_parse_test
- Ticket 48301 - add tox support
- Ticket 48204 - update lib389 for python3
- Ticket 48273 - Improve valgrind functions
- Ticket 48271 - Fix for self.prefix being none when SER_DEPLOYED_DIR is none https://fedorahosted.org/389/ticket/48271
- Ticket 48259 - Add aci parsing utilities to lib389
- Ticket 48252 - (lib389) adding get_bin_dir and dbscan
- Ticket 48247 - Change the default user to 'dirsrv'
- Ticket 47848 - Add new function to create ldif files
- Ticket 48239 - Fix for prefix allocation of un-initialised dirsrv objects
- Ticket 48237 - Add lib389 helper to enable and disable logging services.
- Ticket 48236 - Add get effective rights helper to lib389
- Ticket 48238 - Add objectclass and attribute type query mechanisms
- Ticket 48029 - Add missing replication related functions
- Ticket 48028 - add valgrind wrapper for ns-slapd
- Ticket 48028 - lib389 - add valgrind functions
- Ticket 48022 - lib389 - Add all the server tasks
- Ticket 48023 - create function to test replication between servers
- Ticket 48020 - lib389 - need to reset args_instance with  every DirSrv init
- Ticket 48000 - Repl agmts need more time to stop
- Ticket 48004 - Fix various issues
- Ticket 48000 - replica agreement pause/resume should have a short sleep
- Ticket 47990 - Add check for ".removed" instances when doing an upgrade
- Ticket 47990 - Add "upgrade" function to lib389
- Ticket 47691 - using lib389 with RPMs
- Ticket 47848 - Add support for setuptools.
- Ticket 47855 - Add function to clear tmp directory
- Ticket 47851 - Need to retrieve tmp directory path
- Ticket 47845 - add stripcsn option to tombstone fixup task
- Ticket 47851 - Add function to retrieve dirsrvtests data directory
- Ticket 47845 - Add backup/restore/fixup tombstone tasks to lib389
- Ticket 47819 - Add the new precise tombstone purging config attribute
- Ticket 47695 - Add plugins/tasks/Index
- Ticket 47648 - lib389 - add schema classes, methods
- Ticket 47671 - CI lib389: allow to open a DirSrv without having to create the instance
- Ticket 47600 - Replica/Agreement/Changelog not conform to the design
- Ticket 47652 - replica add fails: MT.list return a list not an entry
- Ticket 47635 - MT/Backend/Suffix to be conform with the design
- Ticket 47625 - CI lib389: DirSrv not conform to the design
- Ticket 47595 - fail to detect/reinit already existing instance/backup
- Ticket 47590 - CI tests: add/split functions around replication
- Ticket 47584 - CI tests: add backup/restore of an instance
- Ticket 47578 - CI tests: removal of 'sudo' and absolute path in lib389
- Ticket 47568 - Rename DSAdmin class
- Ticket 47566 - Initial import of DSadmin into 389-test repos




