---
title: "Releases/1.3.6.5"
---
389 Directory Server 1.3.6.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.5

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://koji.fedoraproject.org/koji/buildinfo?buildID=884231

The new packages and versions are:

-   389-ds-base-1.3.6.5-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.5.tar.bz2)

### Highlights in 1.3.6.5

-   Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.6.5-1
- Ticket 49231 - fix sasl mech handling
- Ticket 49233 - Fix crash in persistent search
- Ticket 49230 - slapi_register_plugin creates config entry where it should not
- Ticket 49135 - PBKDF2 should determine rounds at startup
- Ticket 49236 - Fix CI Tests
- Ticket 48310 - entry distribution should be case insensitive
- Ticket 49224 - without --prefix, $prefixdir would be NONE in defaults.


