---
title: "Releases/2.1.6"
---

389 Directory Server 2.1.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.1.6

Fedora packages are available on Fedora 36

<https://koji.fedoraproject.org/koji/taskinfo?taskID=94299041>

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-103c244fb8> - Bodhi


The new packages and versions are:

- 389-ds-base-2.1.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.6.tar.gz)

### Highlights in 2.1.6

- Bug fixes & enhancements

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

- Bump version to 2.1.6
- Issue 5534 - Add copyright text to the repository files
- Issue 5532 - Make db compaction TOD day more robust.
- Issue 5529 - UI - Fix npm vulnerability in loader-utils
- Issue 3555 - UI - fix audit issue with npm loader-utils (#5514)
- Issue 5162 - Fix dsctl tls ca-certfiicate add-cert arg requirement
- Issue 5510 - remove twalk_r dependency to build on RHEL8 (#5516)
- Issue 5162 - RFE - CLI allow adding CA certificate bundles
- Issue 5440 - memberof is slow on update/fixup if there are several 'groupattr' (#5455)
- Issue 5512 - BUG - skip pwdPolicyChecker OC in migration (#5513)
- Issue 5429 - healthcheck - add checks for MemberOf group attrs being indexed
- Issue 5502 - RFE - Add option to display entry attributes in audit log
- Issue 5495 - BUG - Minor fix to dds skip, inconsistent attrs caused errors (#5501)
- Issue 5495 - RFE - skip dds during migration. (#5496)
- Issue 5491 - UI - Add rework and finish jpegPhoto functionality (#5492)
- Issue 5368 - Retro Changelog trimming does not work (#5486)
- Issue 5487 - Fix various issues with logconv.pl
- Issue 5482 - lib389 - Can not enable replication with a mixed case suffix
- Issue 5356 - Update Cargo.lock and bootstrap PBKDF2-SHA512 (#5480)
- Issue 3061 - RFE - Add password policy debug log level
- Issue 5462 - RFE - add missing default indexes (#5464)
- Issue 5305 - OpenLDAP version autodetection doesn't work
- Issue 4324 - Revert recursive pthread mutex usage in factory.c
- Issue 5262 - high contention in find_entry_internal_dn on mixed load (#5264)
- Issue 4324 - Revert recursive pthread mutex change (#5463)
- Issue 5465 - Fix dbscan linking (#5466)
- Issue 5254 - dscreate create-template regression due to 5a3bdc336 (#5255)
- Issue 5271 - Serialization of pam_passthrough causing high etimes (#5272)
- Issue 5453 - UI/CLI - Changing Root DN breaks UI
- Issue 5446 - Fix some covscan issues (#5451)
- Issue 5294 - Report Portal 5 is not processing an XML file with (#5358)
- Issue 4588 - Gost yescrypt may fail to build on some older versions of glibc
- Issue 4308 - checking if an entry is a referral is expensive
- Issue 5447 - UI - add NDN max cache size to UI
- Issue 5443 - UI - disable save button while saving
- Issue 5413 - Allow only one MemberOf fixup task at a time
- Issue 5158 - entryuuid fixup tasks fails in replicated topology (#5439)
- Issue 4592 - dscreate error with custom dir_path (#5434)
- Issue 5397 - Fix memory leak with the intent filter
- Issue 5356 - For RUST build update the default password storage scheme


