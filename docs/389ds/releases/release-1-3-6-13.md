---
title: "Releases/1.3.6.13"
---

389 Directory Server 1.3.6.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.13

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1022740>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-7f7f7051e9>

The new packages and versions are:

-   389-ds-base-1.3.6.13-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.13.tar.bz2)

### Highlights in 1.3.6.13

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

- Bump version to 1.3.6.13
- CVE-2017-15134 - Remote DoS via search filters in slapi_filter_sprintf
- Ticket 49463 - After cleanALLruv, there is a flow of keep alive DEL
- Ticket 49509 - Indexing of internationalized matching rules is failing
- Ticket 49524 - Password policy: minimum token length fails  when the token length is equal to attribute length
- Ticket 49495 - Fix memory management is vattr.
- Ticket 48118 - Changelog can be erronously rebuilt at startup
- Ticket 49474 - sasl allow mechs does not operate correctly

