---
title: "Releases/2.0.8"
---

389 Directory Server 2.0.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.8

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=74413473> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-da6419cbea> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.8.tar.gz)

### Highlights in 2.0.8

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

- Bump version to 2.0.8
- Issue 4877 - RFE - EntryUUID to validate UUIDs on fixup (#4878)
- Issue 4872 - BUG - entryuuid enabled by default causes replication issues (#4876)
- Issue 4851 - Typos in "dsconf pwpolicy set --help" (#4867)
- Issue 4763 - Attribute Uniqueness Plugin uses wrong subtree on ModRDN (#4871)
- Issue 4736 - lib389 - fix regression in certutil error checking
- Issue 4861 - Improve instructions in custom.conf for memory leak detection
- Issue 4859 - Don't version libns-dshttpd
- Issue 4169 - Migrate Replication & Schema tabs to PF4
- Issue 4623 - RFE - Monitor the current DB locks ( nsslapd-db-current-locks )
- Issue 4736 - CLI - Errors from certutil are not propagated
- Issue 4460 - Fix isLocal and TLS paths discovery (#4850)
- Issue 4848 - Force to require nss version greater or equal as the version available at the build time
- Issue 4696 - Password hash upgrade on bind (#4840)

