---
title: "Releases/1.3.7.7"
---

389 Directory Server 1.3.7.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.7

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22895176>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-e79ba6b7d5>

The new packages and versions are:

-   389-ds-base-1.3.7.7-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.7.tar.bz2)

### Highlights in 1.3.7.7

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.3.7.7
- Ticket 48393 - fix copy and paste error
- Ticket 49439 - cleanallruv is not logging information
- Ticket 48393 - Improve replication config validation
- Ticket 49436 - double free in COS in some conditions
- Ticket 48007 - CI test to test changelog trimming interval
- Ticket 49424 - Resolve csiphash alignment issues
- Ticket 49401 - Fix compiler incompatible-pointer-types warnings
- Ticket 49401 - improve valueset sorted performance on delete
- Ticket 48894 - harden valueset_array_to_sorted_quick valueset  access
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 49374 - server fails to start because maxdisksize is recognized incorrectly
- Ticket 49408 - Server allows to set any nsds5replicaid in the existing replica entry
- Ticket 49407 - status-dirsrv shows ellipsed lines
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl line 2565, <$LOGFH> line 4
- Ticket 49386 - Memberof should be ignore MODRDN when the pre/post entry are identical
- Ticket 48006 - Missing warning for invalid replica backoff  configuration
- Ticket 49378 - server init fails
- Ticket 49064 - testcase hardening
- Ticket 49064 - RFE allow to enable MemberOf plugin in dedicated consumer
- Ticket 49402 - Adding a database entry with the same database name that was deleted hangs server at shutdown
- Ticket 49394 - slapi_pblock_get may leave unchanged the provided variable
- Ticket 48235 - remove memberof lock (cherry-pick error)
- Ticket 48235 - Remove memberOf global lock
- Ticket 49363 - Merge lib389, all lib389 history in single patch




