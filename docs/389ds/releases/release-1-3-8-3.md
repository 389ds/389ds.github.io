---
title: "Releases/1.3.8.3"
---

389 Directory Server 1.3.8.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.3

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27563282>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-34937d412d>

The new packages and versions are:

-   389-ds-base-1.3.8.3-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.3.tar.bz2)

### Highlights in 1.3.8.3

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

- Bump version to 1.3.8.3-2
- Ticket 49576 - ds-replcheck: fix certificate directory verification
- Ticket 49746 - Additional compiler errors on ARM
- Ticket 49746 - Segfault during replication startup on Arm device
- Ticket 49742 - Fine grained password policy can impact search performance
- Ticket 49768 - Under network intensive load persistent search can erronously decrease connection refcnt
- Ticket 49765 - compiler warning
- Ticket 49765 - Async operations can hang when the server is running nunc-stans
- Ticket 49748 - Passthru plugin startTLS option not working
- Ticket 49736 - Hardening of active connection list
- Ticket 48184 - clean up and delete connections at shutdown (3rd)
- Ticket 49726 - DS only accepts RSA and Fortezza cipher families
- Ticket 49722 - Errors log full of " WARN - keys2idl - recieved NULL idl from index_read_ext_allids, treating as empty set" messages
- Ticket 49576 - Add support of ";deletedattribute" in ds-replcheck
- Ticket 49576 - Update ds-replcheck for new conflict entries


