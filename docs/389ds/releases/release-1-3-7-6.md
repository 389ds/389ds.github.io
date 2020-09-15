---
title: "Releases/1.3.7.6"
---

389 Directory Server 1.3.7.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.6

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22353280`>   - Fedora 27
<https://bodhi.fedoraproject.org/updates/FEDORA-2017-f8b8ef6e03>

The new packages and versions are:

-   389-ds-base-1.3.7.6-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.6.tar.bz2)

### Highlights in 1.3.7.6

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

- Bump verson to 1.3.7.6
- Ticket 49038 - remove legacy replication - change cleanup script precedence
- Ticket 49392 - memavailable not available
- Ticket 49320 - Activating already active role returns error 16
- Ticket 49389 - unable to retrieve specific cosAttribute when subtree password policy is configured
- Ticket 49092 - Add CI test for schema-reload
- Ticket 49388 - repl-monitor - matches null string many times in regex
- Ticket 49385 - Fix coverity warnings
- Ticket 49305 - Need to wrap atomic calls
- Ticket 49180 - errors log filled with attrlist\_replace - attr\_replace

