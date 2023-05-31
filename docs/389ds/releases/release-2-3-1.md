---
title: "Releases/2.3.1"
---

389 Directory Server 2.3.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.3.1

Fedora packages are available on Rawhide (f38)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=94296874>

The new packages and versions are:

- 389-ds-base-2.3.1-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.3.1.tar.gz)

### Highlights in 2.3.1

- Enhancements, and Bug fixes

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

- Bump version to 2.3.1
- Issue 5532 - Make db compaction TOD day more robust.
- Issue 3729 - RFE Extend log of operations statistics in access log (#5508)
- Issue 5529 - UI - Fix npm vulnerability in loader-utils
- Issue 5490 - tombstone in entryrdn index with lmdb but not with bdb (#5498)
- Issue 5162 - Fix dsctl tls ca-certfiicate add-cert arg requirement
- Issue 5510 - remove twalk_r dependency to build on RHEL8 (#5516)
- Issue 5162 - RFE - CLI allow adding CA certificate bundles
- Issue 5440 - memberof is slow on update/fixup if there are several 'groupattr' (#5455)
- Issue 5512 - BUG - skip pwdPolicyChecker OC in migration (#5513)
- Issue 3555 - UI - fix audit issue with npm loader-utils (#5514)
- Issue 5505 - Fix compiler warning (#5506)
- Issue 5469 - Increase the default value of nsslapd-conntablesize (#5472)
- Issue 5408 - lmdb import is slow (#5481)
- Issue 5429 - healthcheck - add checks for MemberOf group attrs being indexed
- Issue 5502 - RFE - Add option to display entry attributes in audit log
- Issue 5495 - BUG - Minor fix to dds skip, inconsistent attrs caused errors (#5501)
- Issue 5367 - RFE - store full DN in database record
- Issue 5495 - RFE - skip dds during migration. (#5496)
- Issue 5491 - UI - Add rework and finish jpegPhoto functionality (#5492)
- Issue 5368 - Retro Changelog trimming does not work (#5486)
- Issue 5487 - Fix various issues with logconv.pl
- Issue 5476 - RFE - add memberUid read aci by default (#5477)
- Issue 5482 - lib389 - Can not enable replication with a mixed case suffix
- Issue 5478 - Random crash in connection code during server shutdown (#5479)
- Issue 3061 - RFE - Add password policy debug log level
- Issue 5302 - Release tarballs don't contain cockpit webapp
- Issue 5262 - high contention in find_entry_internal_dn on mixed load (#5264)
- Issue 4324 - Revert recursive pthread mutex change (#5463)
- Issue 5462 - RFE - add missing default indexes (#5464)
- Issue 5465 - Fix dbscan linking (#5466)
- Issue 5271 - Serialization of pam_passthrough causing high etimes (#5272)
- Issue 5453 - UI/CLI - Changing Root DN breaks UI
- Issue 5446 - Fix some covscan issues (#5451)
- Issue 4308 - checking if an entry is a referral is expensive
- Issue 5447 - UI - add NDN max cache size to UI
- Issue 5443 - UI - disable save button while saving
- Issue 5413 - Allow only one MemberOf fixup task at a time
- Issue 4592 - dscreate error with custom dir_path (#5434)
- Issue 5158 - entryuuid fixup tasks fails in replicated topology (#5439)

