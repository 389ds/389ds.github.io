---
title: "Releases/1.3.1.15"
---
389 Directory Server 1.3.1.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.15.

Fedora packages are available from the Fedora 19 Testing repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.15-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.15.tar.bz2)

### Highlights in 1.3.1.15

-   Ticket \#47605 CVE-2013-4485: DoS due to improper handling of ger attr searches
-   Retro Changelog fixes
-   Replication fix

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1.14

-   Ticket \#47605 CVE-2013-4485: DoS due to improper handling of ger attr searches
-   Ticket 47599 - Reduce lock scope in retro changelog plug-in
-   Ticket \#47596 attrcrypt fails to find unlocked key
-   Ticket 47598 - Convert ldbm\_back\_seq code to be transaction aware
-   Ticket 47597 - Convert retro changelog plug-in to betxn
-   Ticket \#47585 Replication Failures related to skipped entries due to cleaned rids

