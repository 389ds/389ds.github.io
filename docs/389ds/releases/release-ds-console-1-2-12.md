---
title: "Releases/ds-console-1.2.12"
---
389 Ds Console 1.2.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-console version 1.2.12 and idm-console-framework version 1.1.14.

Fedora packages are available from the EPEL7, Fedora 21, Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-console-1.2.12-1
-   idm-console-framework-1.1.14-1

Source tarballs are available for download at 
[Download 389 Ds Console Source]({{ site.baseurl }}/binaries/389-ds-console-1.2.12.tar.bz2), 
[Download Idm Console Framework Source]({{ site.baseurl }}/binaries/idm-console-framework-1.1.14.tar.bz2).

### Highlights in 389-ds-console-1.2.12 and idm-console-framework-1.1.14-1

-   Several bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.12-1.el7>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.12-1.fc21>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.12-1.fc22>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.14-1.el7>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.14-1.fc21>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.14-2.fc22>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-ds-console-1.2.10

-   Ticket 48139 - drop support for legacy replication
-   Ticket 48130 - Add "+all" and "-TLS_RSA_WITH_AES_128_GCM_SHA256" to Console Cipher Preference for TLS

### Detailed Changelog since idm-console-framework-1.1.9

-   Ticket 48187 - Adding an OU from console is throwing missing attribute aliasedObjectName error
-   Ticket 47946 - Fix regression with original patch
-   Ticket 47946 - Need to revise console aci syntax checking
-   Ticket 97    - 389-console should provide usage options, help, and man pages
-   Ticket 48134 - Directory Server Admin Console: plaintext password logged in debug mode
-   Ticket 48130 - Add "+all" and "-TLS_RSA_WITH_AES_128_GCM_SHA256" to Console Cipher Preference for TLS

