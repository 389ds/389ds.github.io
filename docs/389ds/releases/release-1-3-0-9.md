---
title: "Releases/1.3.0.9"
---
389 Directory Server 1.3.0.9
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.0.9.

Fedora packages are available from the Fedora 18 Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.0.9-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.9.tar.bz2)

### Highlights in 1.3.0.9

A security fix, several other fixes and enhancements

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

### Detailed Changelog since 1.3.0.8

-   Ticket \#47605 CVE-2013-4485: DoS due to improper handling of ger attr searches
-   Ticket \#47596 attrcrypt fails to find unlocked key
-   Ticket \#47585 Replication Failures related to skipped entries due to cleaned rids
-   Ticket 47577 - crash when removing entries from cache
-   ad64367 Coverity Fixes
-   Ticket 47329 - Improve slapi\_back\_transaction\_begin() return code when transactions are not available
-   Ticket \#47550 logconv: failed logins: Use of uninitialized value in numeric comparison at logconv.pl line 949
-   Ticket \#47551 logconv: -V does not produce unindexed search report
-   Ticket 47517 - fix memory leaks in ldaputil.c nad ldbm\_delete.c
-   Ticket \#422 - 389-ds-base - Can't call method "getText"
-   aa19f9a Coverity fixes - 12023, 12024, and 12025
-   Ticket 47533 logconv: some stats do not work across server restarts
-   Ticket \#47501 logconv.pl uses /var/tmp for BDB temp files
-   Ticket 47520 - Fix various issues with logconv.pl
-   Ticket \#47387 - improve logconv.pl performance with large access logs
-   Ticket 47354 - Indexed search are logged with 'notes=U' in the access logs
-   Ticket 47461 - logconv.pl - Use of comma-less variable list is deprecated
-   Ticket 47447 - logconv.pl man page missing -m,-M,-B,-D
-   Ticket \#47348 - add etimes to per second/minute stats
-   Ticket \#47341 - logconv.pl -m time calculation is wrong
-   Ticket \#47336 - logconv.pl -m not working for all stats
-   Ticket 611 - logconv.pl missing stats for StartTLS, LDAPI, and AUTOBIND
-   TIcket 419 - logconv.pl - improve memory management
-   Ticket 471 - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   Ticket 539 - logconv.pl should handle microsecond timing
-   Ticket \#47504 idlistscanlimit per index/type/value
-   Ticket \#47516 replication stops with excessive clock skew

