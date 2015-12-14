---
title: "Releases/1.3.1.10"
---
389 Directory Server 1.3.1.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.10.

Fedora packages are available from the Fedora 19 and 20 Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.10-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.10.tar.bz2)

### Highlights in 1.3.1.10

-   server should restart cleanly after reboot - tmpfiles.d issues with /run have been resolved
-   new feature - [Fine\_Grained\_ID\_List\_Size](../design/fine-grained-id-list-size.html) - can set per-index, per-type, and per-value idlistscanlimit
-   several bug fixes

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

### Detailed Changelog since 1.3.1.9

-   Ticket \#47534 - RUV tombstone search with scope "one" doesn\`t work
-   Ticket 47510 - 389-ds-base does not compile against MozLDAP libraries
-   Ticket \#47523 - Set up replcation/agreement before initializing the sub suffix, the sub suffix is not found by ldapsearch
-   Ticket 47528 - 389-ds-base built with mozldap can crash from invalid free
-   Ticket \#47504 idlistscanlimit per index/type/value
-   Ticket 47513 - tmpfiles.d references /var/lock when they should reference /run/lock
-   Ticket \#47492 - PassSync removes User must change password flag on the Windows side
-   Ticket 47509 - CLEANALLRUV doesnt run across all replicas
-   Ticket \#47516 replication stops with excessive clock skew
-   6829200 Coverity fix - 11952 - for Ticket 47512
-   Ticket 47512 - backend txn plugin fixup tasks should be done in a txn

