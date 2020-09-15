---
title: "Releases/1.3.6.10"
---

389 Directory Server 1.3.6.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.10

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22895230>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-15b4a0e925>


The new packages and versions are:

-   389-ds-base-1.3.6.10-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.10.tar.bz2)

### Highlights in 1.3.6.10

- Bug fix

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

- Bump version to 1.3.6.10
- Ticket 49439 - cleanallruv is not logging information
- Ticket 49431 - replicated MODRDN fails breaking replication
- Ticket 49402 - Adding a database entry with the same database name that was deleted hangs server at shutdown
- Ticket 48235 - remove memberof lock (cherry-pick error)
- Ticket 49401 - Fix compiler incompatible-pointer-types warnings
- Ticket 49401 - improve valueset sorted performance on delete
- Ticket 48894 - harden valueset_array_to_sorted_quick valueset access
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl line 2565, <$LOGFH> line 4
- Ticket 48235 - Remove memberOf global lock


