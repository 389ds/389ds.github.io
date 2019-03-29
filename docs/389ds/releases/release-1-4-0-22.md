---
title: "Releases/1.4.0.22"
---

389 Directory Server 1.4.0.22
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.22

Fedora packages are available on Fedora 28, and 29


Fedora 29

<http://koji.fedoraproject.org/koji/buildinfo?buildID=1240342>

Fedora 28

<http://koji.fedoraproject.org/koji/buildinfo?buildID=1240341>

Bodhi

F29 <>

F28 <>


The new packages and versions are:

- 389-ds-base-1.4.0.22-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.22.tar.bz2)

### Highlights in 1.4.0.22

Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  To install the Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab| Finished | Demo Mode | Written in ReachJS |
|-----------------|----------|-----------|---------|
|Server Tab|Yes||No|
|Security Tab||X||
|Database Tab|Yes||Yes|
|Replication Tab|Yes||No|
|Schema Tab|Yes||No|
|Plugin Tab|Yes||Yes|
|Monitor Tab||X||

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.21
- Ticket 50041 - CLI and WebUI - Add memberOf plugin functionality
- Ticket 50079 - Fix for ticket 50059: If an object is nsds5replica, it must be cn=replica
- Ticket 50125 - perl fix ups for tmpfiles
- Ticket 50164 - Add test for dscreate
- Ticket 50059 - If an object is nsds5replica, it must be cn=replica
- Ticket 50169 - lib389 changed hardcoded systemctl path
- Ticket 50165 - Fix dscreate issues
- Ticket 50152 - Replace os.getenv('HOME') with os.path.expanduser
- Fix compiler warning in snmp main()
- Fix compiler warning in init.c
- Ticket 49540 - FIx compiler warning in ldif2ldbm
- Ticket 50077 - Fix compiler warnings in automember rebuild task
- Ticket 49972 - use-after-free in case of several parallel krb authentication
- Ticket 50161 - Fixed some descriptions in "dsconf backend --help"
- Ticket 50153 - Increase default max logs
- Ticket 50123 - with_tmpfiles_d is associated to systemd
- Ticket 49984 - python installer add option to create suffix entry
- Ticket 50077 - RFE - improve automember plugin to work with modify ops
- Ticket 50136 - Allow resetting passwords on the CLI
- Ticket 49994 - Adjust dsconf backend usage
- Ticket 50138 - db2bak.pl -P LDAPS does not work when nsslapd-securePort is missing
- Ticket 50122 - Fix incorrect path spec
- Ticket 50145 - Add a verbose option to the backup tools
- Ticket 50056 - dsctl db2ldif throws an exception
- Ticket 50078 - cannot add cenotaph in read only consumer
- Ticket 50126 - Incorrect usage of sudo in test
- Ticket 50130 - Building RPMs on RHEL8 fails
- Ticket 50134 - fixup-memberof.pl does not respect protocol requested
- Ticket 50122 - Selinux test for presence
- Ticket 50101 - Port fourwaymmr Test TET suit to python3
- Ticket 50091 - shadowWarning is not generated if passwordWarning is lower than 86400 seconds (1 day).
- Ticket 50128 - NS Stress fails without ipv6
- Ticket 49618 - Set nsslapd-cachememsize to custom value
- Ticket 50117 - after certain failed import operation, impossible to replay an import operation
- Ticket 49999 - rpm.mk dist-bz2 should clean cockpit_dist first
- Ticket 48064 - Fix various issues in disk monitoring test suite
- Ticket 49938 - lib389 - Clean up CLI logging
- Ticket 49761 - Fix CI test suite issues
- Ticket 50056 - Fix UI bugs (part 2)
- Ticket 48064 - CI test - disk_monitoring
- Ticket 50099 - extend error messages
- Ticket 50099 - In FIPS mode, the server can select an unsupported password storage scheme
- Ticket 50041 - Add basic plugin UI/CLI wrappers
- Ticket 50082 - Port state test suite
- Ticket 49574 - remove index subsystem
- Ticket 49588 - Add py3 support for tickets : part-5
- Ticket 50095 - cleanup deprecated key.h includes



