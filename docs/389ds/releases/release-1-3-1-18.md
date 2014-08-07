---
title: "Releases/1.3.1.18"
---
389 Directory Server 1.3.1.18
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.18.

Fedora packages are available from the Fedora 19 Testing repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.18-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.18.tar.bz2)

### Highlights in 1.3.1.18

-   A dozen of bugs are fixed including a crash bug and a deadlock.

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

### Detailed Changelog since 1.3.1.17

-   Ticket 342 - better error message when cache overflows
-   Ticket 408 - Fix crash when disabling/enabling the setting
-   Ticket 443 - Deleting attribute present in nsslapd-allowed-to-delete-attrs returns Operations error
-   Ticket 471 - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   Ticket 47374 - flush.pl is not included in perl5
-   Ticket 47463 - IDL-style can become mismatched during partial restoration
-   Ticket 47516 - replication stops with excessive clock skew
-   Ticket 47620 - Unable to delete protocol timeout attribute
-   Ticket 47638 - Overflow in nsslapd-disk-monitoring-threshold on 32bit platform
-   Ticket 47641 - 7-bit check plugin not checking MODRDN operation
-   Ticket 47649 - Server hangs in cos\_cache when adding a user entry
-   Ticket 47660 - config\_set\_allowed\_to\_delete\_attrs: Valgrind reports Invalid read

