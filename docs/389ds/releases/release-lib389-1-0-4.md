---
title: "python-lib389 1.0.4"
---

python-lib389-1.0.4
-------------

The 389 Directory Server team is proud to announce python-lib389 version 1.0.4.

Source tarballs are available for download at [Download python-lib389 source code]({{ site.binaries_url }}/binaries/python-lib389-1.0.4.tar.bz2).

Fedora packages are in testing for Fedora 25, 26, and Rawhide repositories.

F25:
https://bodhi.fedoraproject.org/updates/FEDORA-2017-1e52ff27ab

F26:
https://bodhi.fedoraproject.org/updates/FEDORA-2017-ed66370476

Rawhide:
https://koji.fedoraproject.org/koji/taskinfo?taskID=20121272

### Highlights in 1.0.4

- Several functional areas have finally been completed
- Various features have been made more protable
- Many bug fixes

### Installation

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>.

If you find a bug, or would like to see a new feature, file it using trac: <https://pagure.io/lib389/new_issue>

### Detailed Changelog since 1.0.3

- Bump verson to 1.0.4-1
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

- Bump version to 1.0.3-3
- Adjust spec file for Require dependencies

- Bump version to 1.0.3-2
- Fix specfile issues with python3

- Bump verson to 1.0.3-1
- Ticket 5 - Fix container build on fedora
- Ticket 4 - Cert detection breaks some tests
- Ticket 49137 - Add sasl plain tests, lib389 support
- Ticket 2 -  pytest mark with version relies on root
- Ticket 49126 - DIT management tool
- dbscan - Support additional options (-t truncate -R)
- Ticket 49101 - Python 2 generate example entries
- Ticket 49103 - python 2 support for installer
- Fixed regression with offline db2ldif
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
- Fix runUpgrade tool issues
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

- Bump version to 1.0.2
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
- Ticket 48878 - better style for backend in backend test.py
- Ticket 48878 - pep8 fixes part 2
- Ticket 48878 - pep8 fixes and fix rpm to build
- Ticket 48853 - Prerelease installer
- Ticket 48820 - Begin to test compatability with py.test3, and the new orm
- Ticket 48434 - Fix for negative tz offsets
- Ticket 48857 - Remove python-krbV from lib389
- Ticket 48820 - Move Encryption and RSA to the new object types
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
- Ticket 48661 - Agreement test suite fails at the test changes case
- Ticket 48407 - Add test coverage module for lib389 repo
- Ticket 48357 - clitools should standarise their args
- Ticket 48560 - Make verbose handling consistent
- Ticket 48419 - getadminport() should not a be a static method
- Ticket 48415 - Add default domain parameter
- Ticket 48408 - RFE escaped default suffix for tests
- Ticket 48405 - python-lib389 in rawhide is missing dependencies
- Ticket 48401 - Revert typecheck
- Ticket 48401 - lib389 Entry hasAttr returs dict instead of false
- Ticket 48390 - RFE Improvements to lib389 monitor features for rest389
- Ticket 48358 - Add new spec file
- Ticket 48371 - weaker host check on localhost.localdomain


