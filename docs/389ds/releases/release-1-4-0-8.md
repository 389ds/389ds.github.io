---
title: "Releases/1.4.0.8"
---

389 Directory Server 1.4.0.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.8

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26461258>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26461070>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-f36db5c2bf>

The new packages and versions are:

- 389-ds-base-1.4.0.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.8.tar.bz2)

### Highlights in 1.4.0.8

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

- Bump version to 1.4.0.8
- Ticket 49639 - Crash when failing to read from SASL conn
- Ticket 49109 - nsDS5ReplicaTransportInfo should accept StartTLS as an option
- Ticket 49586 - Add py3 support to plugins test suite
- Ticket 49511 - memory leak in pwdhash

