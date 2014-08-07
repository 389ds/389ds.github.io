---
title: "Releases/1.2.11.25"
---
389 Directory Server 1.2.11.25
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.25.

This release is only available in binary form for EL5 (EPEL5) and EL6 - see [Download\#RHEL6/EPEL6](../download.html) for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.25-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.2.11.25.tar.bz2)

### Highlights in 1.2.11.25

-   security fix
-   several bug fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds**

`yum install 389-ds`

After install completes, run **setup-ds-admin.pl** to set up your directory server.

`setup-ds-admin.pl`

To upgrade, use **yum upgrade**

`yum upgrade`

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

`setup-ds-admin.pl -u`

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.2.11.23

-   Ticket \#47605 CVE-2013-4485: DoS due to improper handling of ger attr searches
-   Ticket \#47596 attrcrypt fails to find unlocked key
-   Ticket \#47585 Replication Failures related to skipped entries due to cleaned rids
-   Ticket \#47581 - Winsync plugin segfault during incremental backoff (phase 2)
-   Ticket \#47581 - Winsync plugin segfault during incremental backoff
-   Ticket 47577 - crash when removing entries from cache
-   Ticket \#47559 hung server - related to sasl and initialize
-   Ticket \#47550 logconv: failed logins: Use of uninitialized value in numeric comparison at logconv.pl line 949
-   Ticket \#47551 logconv: -V does not produce unindexed search report
-   Ticket 47517 - fix memory leak in ldbm\_delete.c
-   Ticket \#47488 - Users from AD sub OU does not sync to IPA
-   minor fixes for bdb 4.2/4.3 and mozldap
-   Tickets: 47510 & 47543 - 389 fails to build when using Mozldap

