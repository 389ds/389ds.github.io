---
title: "Releases/1.4.0.10"
---

389 Directory Server 1.4.0.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.10

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1090967>

F28

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1090968>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-4e2349faa5>

The new packages and versions are:

- 389-ds-base-1.4.0.10-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.10.tar.bz2)

### Highlights in 1.4.0.10

- Security and Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.4.0.10
- Ticket 49640 - Errors about PBKDF2 password storage plugin at server startup
- Ticket 49571 - perl subpackage and python installer by default
- Ticket 49740 - UI - Replication monitor color coding is not colorblind friendly
- Ticket 49741 - UI - View/Edit replication agreement hangs WebUI
- Ticket 49703 - UI - Set default values in create instance form
- Ticket 49742 - Fine grained password policy can impact search performance
- Ticket 49768 - Under network intensive load persistent search can erronously decrease connection refcnt(Security Fix)
- Ticket 49765 - compiler warning
- Ticket 49689 - Cockpit subpackage does not build in PREFIX installations
- Ticket 49765 - Async operations can hang when the server is running nunc-stans
- Ticket 49745 - UI add filter options for error log severity levels
- Ticket 49761 - Fix test suite issues
- Ticket 49754 - instances created with dscreate can not be upgraded with setup-ds.pl
- Ticket 47902 - UI - add continuous refresh log feature
- Ticket 49381 - Add docstrings to plugin test suites - Part 1
- Ticket 49646 - Improve TLS cert processing in lib389 CLI
- Ticket 49748 - Passthru plugin startTLS option not working
- Ticket 49732 - Optimize resource limit checking for rootdn issued searches
- Ticket 48377 - Bundle jemalloc
- Ticket 49736 - Hardening of active connection list
- Ticket 48184 - clean up and delete connections at shutdown (3rd)
- Ticket 49675 - Revise coverity fix
- Ticket 49333 - Do not remove versioned man pages
- Ticket 49683 - Add support for JSON option in lib389 CLI tools
- Ticket 49704 - Error log from the installer is concatenating all lines into one
- Ticket 49726 - DS only accepts RSA and Fortezza cipher families
- Ticket 49722 - Errors log full of " WARN - keys2idl - recieved NULL idl from index_read_ext_allids, treating as empty set" messages
- Ticket 49582 - Add py3 support to memberof_plugin test suite
- Ticket 49675 - Fix coverity issues
- Ticket 49576 - Add support of ";deletedattribute" in ds-replcheck
- Ticket 49706 - Finish UI patternfly convertions
- Ticket 49684 - AC_PROG_CC clobbers CFLAGS set by --enable-debug
- Ticket 49678 - organiSational vs organiZational spelling in lib389
- Ticket 49689 - Fix local "make install" after adding cockpit subpackage
- Ticket 49689 - Move Cockpit UI plugin to a subpackage
- Ticket 49679 - Missing nunc-stans documentation and doxygen warnings
- Ticket 49588 - Add py3 support for tickets : part-1
- Ticket 49576 - Update ds-replcheck for new conflict entries
- Ticket 48184 - clean up and delete connections at shutdown (2nd try)
- Ticket 49698 - Remove unneeded patternfly files from Cockpit package
- Ticket 49581 - Fix dynamic plugins test suite
- Ticket 49665 - remove obsoleted upgrade scripts
- Ticket 49693 - A DB_DEADLOCK while adding a tombstone (RUV) leads to access of an already freed entry
- Ticket 49696 - replicated operations should be serialized
- Ticket 49669 - Invalid cachemem size can crash the server during a restore
- Ticket 49684 - AC_PROG_CC clobbers CFLAGS set by --enable-debug
- Ticket 49685 - make clean fails if cargo is not installed
- Ticket 49106 - Move ds_* scripts to libexec
- Ticket 49657 - Fix cascading replication scenario in lib389 API
- Ticket 49671 - Readonly replicas should not write internal ops to changelog
- Ticket 49673 -  nsslapd-cachememsize can't be set to a value bigger than MAX_INT
- Ticket 49519 - Convert Cockpit UI to use strictly patternfly stylesheets
- Ticket 49665 - Upgrade script doesn't enable CRYPT password storage plug-in
- Ticket 49665 - Upgrade script doesn't enable PBKDF2 password storage plug-in

