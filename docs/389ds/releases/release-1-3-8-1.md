---
title: "Releases/1.3.8.1"
---

389 Directory Server 1.3.8.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.1

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26850516>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-0113049e0c>

The new packages and versions are:

-   389-ds-base-1.3.8.1-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.1.tar.bz2)

### Highlights in 1.3.8.1

- Security and bug fixes

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

- Bump version to 1.3.8.1
- Ticket 49661 - CVE-2018-1089 - Crash from long search filter
- Ticket 49652 - DENY aci's are not handled properly
- Ticket 49649 - Use reentrant crypt_r()
- Ticket 49644 - crash in debug build
- Ticket 49631 - same csn generated twice
- Ticket 48184 - revert previous patch around unuc-stans shutdown crash
- Rebase to 1.3.8 from 1.3.7.10

