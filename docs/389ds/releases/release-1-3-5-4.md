---
title: "Releases/1.3.5.4"
---
389 Directory Server 1.3.5.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.4.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.4.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.4

-   Bug fixes and enhancements.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-2.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.5.3

-   Ticket 48836 - replication session fails because of permission denied
-   Ticket 48837 - Replication: total init aborted
-   Ticket 48617 - Server ram checks work in isolation
-   Ticket 48220 - The "repl-monitor" web page does not display "year" in date.
-   Ticket 48829 - Add gssapi sasl replication bind test
-   Ticket 48497 - uncomment pytest from CI test
-   Ticket 48828 - db2ldif is not taking into account multiple suffixes or backends
-   Ticket 48818 - Fix case where return code is always -1
-   Ticket 48826 - 52updateAESplugin.pl may fail on older versions of perl
-   Ticket 48825 - Configure make generate invalid makefile

