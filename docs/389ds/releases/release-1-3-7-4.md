---
title: "Releases/1.3.7.4"
---

389 Directory Server 1.3.7.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.4

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21684703>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21684678>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.4-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.7.4.tar.bz2)

### Highlights in 1.3.7.4

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

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.7.4
- Ticket 49371 - Cleanup update script
- Ticket 48831 - Autotune dncache with entry cache.
- Ticket 49312 - pwdhash -D used default hash algo
- Ticket 49043 - make replication conflicts transparent to clients
- Ticket 49371 - Fix rpm build
- Ticket 49371 - Template dse.ldif did not contain all needed plugins
- Ticket 49295 - Fix CI Tests
- Ticket 49050 - make objectclass ldapsubentry effective immediately

