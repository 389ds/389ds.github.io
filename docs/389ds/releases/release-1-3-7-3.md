---
title: "Releases/1.3.7.3"
---

389 Directory Server 1.3.7.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.3

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21607186>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21607237>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.3-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.3.tar.bz2)

### Highlights in 1.3.7.3

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

- Bump version to 1.3.7.3
- Ticket 49354 - fix regression in total init due to mistake in range fetch
- Ticket 49370 - local password policies should use the same defaults as the global policy
- Ticket 48989 - Delete slow lib389 test
- Ticket 49367 - missing braces in idsktune
- Ticket 49364 - incorrect function declaration.
- Ticket 49275 - fix tls auth regression
- Ticket 49038 - Revise creation of cn=replication,cn=config
- Ticket 49368 - Fix typo in log message
- Ticket 48059 - Add docstrings to CLU tests
- Ticket 47840 - Add docstrings to setup tests
- Ticket 49348 - support perlless and wrapperless install


