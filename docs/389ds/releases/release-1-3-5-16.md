---
title: "Releases/1.3.5.16"
---
389 Directory Server 1.3.5.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.16.

Fedora packages are available from the Fedora 24, and 25.

The new packages and versions are:

-   389-ds-base-1.3.5.16-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.16.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.16

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump version to 1.3.5.16-1
- Issue 49188 - retrocl can crash server at shutdown
- Issue 49179 - Missing components in 1.3.5 defaults.inf
- Issue 48989 - Overflow in counters and monitor
- Issue 49095 - targetattr wildcard evaluation is incorrectly case sensitive
- Issue 49065 - dbmon.sh fails if you have nsslapd-require-secure-binds enabled
- Issue 49157 - ds-logpipe.py crashes for non-existing users
- Issue 49045 - Fix double-free in _cl5NewDBFile() error path
- Issue 49170 - sync plugin thread count not handled correctly
- Issue 49158 - fix latest coverity issues
- Issue 49122 - Filtered nsrole that uses nsrole crashes the  server
- Issue 49121 - ns-slapd crashes in ldif_sput due to the output buf size is less than the real size.
- Issue 49008 - check if ruv element exists
- Issue 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Issue 49104 - Add CI test
- Issue 49104 - dbscan-bin crashing due to a segmentation fault
- Issue 49079 - deadlock on cos cache rebuild
- Issue 49008 - backport 1.3.5 : aborted operation can leave RUV in incorrect state
- Issue 47973 - custom schema is registered in small caps after schema reload
- Issue 49088 - 389-ds-base rpm postinstall script bugs
- Issue 49082 - Adjusted the CI test case to the fix.
- Issue 49082 - Fix password expiration related shadow attributes
- Issue 49080 - shadowExpire should not be a calculated value
- Issue 49074 - incompatible nsEncryptionConfig object definition prevents RHEL 7->6 schema replication
- Issue 48964 - should not free repl name after purging changelog
- Issue 48964 - cleanallruv changelog purging removes wrong  rid
- Issue 49072 - fix log refactoring
- Issue 49072 - validate memberof fixup task args
- Issue 49071 - Import with duplicate DNs throws unexpected errors
- Issue 47966 - CI test: added test cases for ticket 47966
- Issue 48987 - Heap use after free in dblayer_close_indexes
- Issue 49068 - 1.3.5 use std c99
- Issue 49020 - do not treat missing csn as fatal
- Issue 48133 - v2 Non tombstone entry which dn starting with "nsuniqueid=...," cannot be delete
- Issue 47911 - Move dirsrv-snmp.service to 389-ds-base-snmp package

