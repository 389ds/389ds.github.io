---
title: "Releases/1.3.2.8"
---
389 Directory Server 1.3.2.8
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.8.

Fedora packages are available from the Fedora 20 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.8-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.8.tar.bz2)

### Highlights in 1.3.2.8

-   Suffixes used in the memberof and referential integrity plug-ins are now configurable.
-   The hard-coded limit of 64 masters was removed.
-   A couple of memory leak bugs were fixed.

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

### Detailed Changelog since 1.3.2.7

-   Ticket 342 - better error message when cache overflows (phase 2)
-   Ticket 47526 - Allow memberof suffixes to be configurable
-   Ticket 47527 - Allow referential integrity suffixes to be configurable
-   Ticket 47587 - hard coded limit of 64 masters in agreement and changelog code
-   Ticket 47591 - entries with empty objectclass attribute value can be hidden
-   Ticket 47592 - automember plugin task memory leaks
-   Ticket 47596 - attrcrypt fails to find unlocked key
-   Ticket 47611 - Add script to build patched RPMs
-   Ticket 47612 - ns-slapd eats all the memory
-   Ticket 47613 - Impossible to configure nsslapd-allowed-sasl-mechanisms
-   Ticket 47614 - Possible to specify invalid SASL mechanism in nsslapd-allowed-sasl-mechanisms

