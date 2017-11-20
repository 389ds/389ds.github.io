---
title: "Releases/1.3.1.11"
---
389 Directory Server 1.3.1.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.11.

Fedora packages are available from the Fedora 19 and 20 Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.11-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.11.tar.bz2)

### Highlights in 1.3.1.11

-   server should restart cleanly after reboot - tmpfiles.d issues with /run have been resolved
    -   This time the issue has really been resolved
-   bug fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1.10

-   Ticket 47513 - Set localrundir outside of the "with-fhs" block
-   Ticket 47513 - Refine the check for @localrundir@
-   Ticket 47510 - remove unnecessary typedef
-   Ticket 47510 - Repl Sync does not compile against MozLDAP libraries

