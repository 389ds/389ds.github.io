---
title: "Releases/1.4.1.3"
---

389 Directory Server 1.4.1.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.3

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35035898> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35035974> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-ac3a8134ef>


The new packages and versions are:

-   389-ds-base-1.4.1.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.3.tar.bz2)

### Highlights in 1.4.1.3

- Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab|Finished|Written in ReachJS |
|-----------------|--------|-------------------|
|Server Tab|Yes|No|
|Security Tab|No||
|Database Tab|Yes|Yes|
|Replication Tab|Yes||No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

* Fri May 24 2019 Mark Reynolds <mreynolds@redhat.com> - 1.4.1.3-1
- Bump version to 1.4.1.3
- Issue 49761 - Fix CI test suite issues
- Issue 50041 - Add the rest UI Plugin tabs - Part 2
- Issue 50340 - 2nd try - structs for diabled plugins will not be freed
- Issue 50403 - Instance creation fails on 1.3.9 using perl utils and latest lib389
- Issue 50389 - ns-slapd craches while two threads are polling the same connection
- Issue 48851 - investigate and port TET matching rules filter tests(scanlimit)
- Issue 50037 - lib389 fails to install in venv under non-root user
- Issue 50112 - Port ACI test suit from TET to python3(userattr)
- Issue 50393 - maxlogsperdir accepting negative values
- Issue 50112 - Port ACI test suit from TET to python3(roledn)
- Issue 49960 - Core schema contains strings instead of numer oids
- Issue 50396 - Crash in PAM plugin when user does not exist
- Issue 50387 - enable_tls() should label ports with ldap_port_t
- Issue 50390 - Add Managed Entries Plug-in Config Entry schema
- Issue 50306 - Fix regression with maxbersize
- Issue 50384 - Missing dependency: cracklib-dicts
- Issue 49029 - [RFE] improve internal operations logging
- Issue 49761 - Fix CI test suite issues
- Issue 50374 - dsdim posixgroup create fails with ERROR
- Issue 50251 - clear text passwords visable in CLI verbose mode logging
- Issue 50378 - ACI's with IPv4 and IPv6 bind rules do not work for IPv6 clients
- Issue 48851 - investigate and port TET matching rules filter tests
- Issue 50220 - attr_encryption test suite failing
- Issue 50370 -  CleanAllRUV task crashing during server shutdown
- Issue 50340 - structs for disabled plugins will not be freed
- Issue 50164 - Add test for dscreate to basic test suite
- Issue 50363 - ds-replcheck incorrectly reports error out of order multi-valued attributes
- Issue 49730 - MozLDAP bindings have been unsupported for a while
- Issue 50353 - Categorize tests by tiers
- Issue 50303 - Add creation date to task data
- Issue 50358 -  Create a Bitwise Plugin class in plugins.py
- Remove the nss3 path prefix from the cert.h C preprocessor source file inclusion
- Issue 50329 - revert fix
- Issue 50112 - Port ACI test suit from TET to python3(keyaci)
- Issue 50344 - tidy rpm vs build systemd flag handling
- Issue 50067 - Fix krb5 dependency in a specfile
- Issue 50340 - structs for diabled plugins will not be freed
- Issue 50327 - Add replication conflict support to UI
- Issue 50327 - Add replication conflict entry support to lib389/CLI
- Issue 50329 - improve connection default parameters
- Issue 50313 - Add a NestedRole type to lib389
- Issue 50112 - Port ACI test suit from TET to python3(Delete and  Add)
- Issue 49390, 50019 - support cn=config compare operations
- Issue 50041 - Add the rest UI Plugin tabs - Part 1
- Issue 50329 - Possible Security Issue: DOS due to ioblocktimeout not applying to TLS
- Issue 49990 - Increase the default FD limits
- Issue 50306 - (cont typo) Move connection config inside struct
- Issue 50291 - Add monitor tab functionality to Cockpit UI
- Issue 50317 - fix ds-backtrace issue on latest gdb
- Issue 50305 - Revise CleanAllRUV task restart process
- Issue 49915 - Fix typo
- Issue 50026 - Audit log does not capture the operation where nsslapd-lookthroughlimit is modified
- Issue 49899 - fix pin.txt and pwdfile permissions
- Issue 49915 - Add regression test
- Issue 50303 - Add task creation date to task data
- Issue 50306 - Move connection config inside struct
- Issue 50240 - Improve task logging
- Issue 50032 - Fix deprecation warnings in tests
- Issue 50310 - fix sasl header include
- Issue 49390 - improve compare and cn=config compare tests





