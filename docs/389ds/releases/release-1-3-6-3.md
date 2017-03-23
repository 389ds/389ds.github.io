---
title: "Releases/1.3.6.3"
---
389 Directory Server 1.3.6.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.3.

Fedora packages are available from the Fedora 26 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.6.3-4

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.6.3.tar.bz2)

### Highlights in 1.3.6.3

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

- Bump verson to 1.3.6.3-4
- Issue 49177 - rpm would not create valid pkgconfig files(pt2)
- Bump version to 1.3.6.3-3
- Issue 49186 - Fix NS to improve shutdown relability
- Issue 49174 - nunc-stans can not use negative timeout
- Issue 49076 - To debug DB_DEADLOCK condition, allow to reset DB_TXN_NOWAIT flag on txn_begin
- Issue 49188 - retrocl can crash server at shutdown
- Issue 47840 - Add setup_ds test suite
- Bump version to 1.3.6.3-2
- Fix srvcore version dependancy
- Bump verson to 1.3.6.3-1
- Issue 48989 - Overflow in counters and monitor
- Issue 49095 - targetattr wildcard evaluation is incorrectly case sensitive
- Issue 49177 - rpm would not create valid pkgconfig files
- Issue 49176 - Remove tcmalloc restriction from s390x
- Issue 49157 - ds-logpipe.py crashes for non-existing users
- Issue 49065 - dbmon.sh fails if you have nsslapd-require-secure-binds enabled
- Issue 49095 - Fix double-free in _cl5NewDBFile() error path
- Bump verson to 1.3.6.2-2
- Issue 49169 - Fix covscan errors(regression)
- Issue 49172 - Fix test schema files
- Issue 49171 - Nunc Stans incorrectly reports a timeout
- Issue 49169 - Fix covscan errors
- Bump version to 1.3.6.2-1
- Issue 49164 - Change NS to acq-rel semantics for atomics
- Issue 49154 - Nunc Stans stress should assert it has 95% success rate
- Issue 49165 - pw_verify did not handle external auth
- Issue 49062 - Reset agmt update staus and total init
- Issue 49151 - Remove defunct selinux policy

