---
title: "Releases/1.4.1.4"
---

389 Directory Server 1.4.1.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.4

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35621238> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=35620824> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-ed262351ae>


The new packages and versions are:

- 389-ds-base-1.4.1.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.4.tar.bz2)

### Highlights in 1.4.1.4

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

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab|Finished|Written in ReachJS |
|-----------------|--------|-------------------|
|Server Tab|Yes|No|
|Security Tab|No|No|
|Database Tab|Yes|Yes|
|Replication Tab|Yes|No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.1.4
- Issue 49361 - Use IPv6 friendly network functions
- Issue 48851 - Investigate and port TET matching rules filter tests(bug772777)
- Issue 50446 - NameError: name 'ds_is_older' is not defined
- Issue 49602 - Revise replication status messages
- Issue 50439 - Update docker integration to work out of source directory
- Issue 50037 - revert path changes as it breaks prefix/rpm builds
- Issue 50431 - Fix regression from coverity fix
- Issue 50370 - CleanAllRUV task crashing during server shutdown
- Issue 48851 - investigate and port TET matching rules filter tests(match)
- Issue 50417 - Fix missing quote in some legacy tools
- Issue 50431 - Fix covscan warnings
- Revert "Issue 49960 - Core schema contains strings instead of numer oids"
- Issue 50426 - nsSSL3Ciphers is limited to 1024 characters
- Issue 50052 - Fix rpm.mk according to audit-ci change
- Issue 50365 - PIDFile= references path below legacy directory /var/run/
- Issue 50428 - Log the actual base DN when the search fails with "invalid attribute request"
- Issue 50329 - (2nd) Possible Security Issue: DOS due to ioblocktimeout not applying to TLS
- Issue 50417 - Revise legacy tool scripts to work with new systemd changes
- Issue 48851 - Add more search filters to vfilter_simple test suite
- Issue 49761 - Fix CI test suite issues
- Issue 49875 - Move SystemD service config to a drop-in file
- Issue 50413 - ds-replcheck - Always display the Result Summary
- Issue 50052 - Add package-lock.json and use "npm ci"
- Issue 48851 - investigate and port TET matching rules filter tests(vfilter simple)
- Issue 50355 - NSS can change the requested SSL min and max versions
- Issue 48851 - investigate and port TET matching rules filter tests(vfilter_ld)
- Issue 50390 - Add Managed Entries Plug-in Config Entry schema
- Issue 49730 - Remove unused Mozilla ldapsdk variables




