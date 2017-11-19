---
title: "Releases/1.3.4.8"
---
389 Directory Server 1.3.4.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.8.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.8-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.8.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.8

-   Various bugs including a security bug 1299417 are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.8-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.8-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.5

-   Ticket 47788 - Supplier can skip a failing update, although  it should retry
-   Ticket 48289 - 389-ds-base: ldclt-bin killed by SIGSEGV
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48312 - Crash when doing modrdn on managed entry
-   Ticket 48332 - allow users to specify to relax the FQDN constraint
-   Ticket 48341 - deadlock on connection mutex
-   Ticket 48362 - With exhausted range, part of DNA shared configuration is deleted after server restart
-   Ticket 48369 - RFE - Add config setting to always send the  password expiring time
-   Ticket 48370 - The 'eq' index does not get updated properly when deleting and re-adding attributes in the same modify operation
-   Ticket 48375 - SimplePagedResults -- in the search error case, simple paged results slot was not released.
-   Ticket 48388 - db2ldif -r segfaults from time to time
-   Ticket 48406 - Avoid self deadlock by PR_Lock(conn->c_mutex)
-   Ticket 48412 - worker threads do not detect abnormally closed  connections
-   Ticket 48445 - keep alive entries can break replication
-   Ticket 48448 - dirsrv start-stop fail in certain shell environments.
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48536 - Crash in slapi_get_object_extension


