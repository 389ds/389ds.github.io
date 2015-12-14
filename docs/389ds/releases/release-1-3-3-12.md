---
title: "Releases/1.3.3.12"
---
389 Directory Server 1.3.3.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.12.

Fedora packages are available from the Fedora 21, 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.12-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.12.tar.bz2)

### Highlights in 1.3.3.12

-   Several critical bugs including a security bug were fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.12-1.fc21> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.12-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.10

-   Bug 1232896  - CVE-2015-3230 389-ds-base: nsSSL3Ciphers preference not enforced server side (Ticket 48194)
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48190 - idm/ipa 389-ds-base entry cache converges to 500 KB in dblayer_is_cachesize_sane
-   Ticket 48183 - bind on db chained to AD returns err=32
-   Ticket 47753 - Fix testecase
-   Ticket 47828 - fix testcase "import" issue
-   Ticket 48158 - cleanAllRUV task limit not being enforced correctly
-   Ticket 48158 - Remove cleanAllRUV task limit of 4
-   Ticket 48146 - async simple paged results issue; need to close a small window for a pr index competed among multiple threads.
-   Ticket 48146 - async simple paged results issue; log pr index
-   Ticket 48146 - async simple paged results issue
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
-   Ticket 48177 - dynamic plugins should not return an error when modifying a critical plugin
-   Ticket 48151 - fix coverity issues
-   Ticket 48151 - Improve CleanAllRUV logging
-   Ticket 48136 - v2v2 accept auxilliary objectclasse in replication agreements
-   Ticket 48132 - modrdn crashes server (invalid read/writes)
-   Ticket 48133 - Non tombstone entry which dn starting with "nsuniqueid=...," cannot be deleted
