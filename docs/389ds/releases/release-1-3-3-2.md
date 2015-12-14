---
title: "Releases/1.3.3.2"
---
389 Directory Server 1.3.3.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.2.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.2-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.2.tar.bz2)

### Highlights in 1.3.3.2

-   Several bugs are fixed.

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

### Detailed Changelog since 1.3.3.0

-   Ticket 47889 - DS crashed during ipa-server-install on test_ava_filter
-   Ticket 47895 - If no effective ciphers are available, disable security setting.
-   Ticket 47838 - harden the list of ciphers available by default
-   Ticket 47885 - did not always return a response control
-   Ticket 47890 - minor memory leaks in utilities
-   Ticket 47834 - Tombstone_to_glue: if parents are also converted to glue, the target entry's DN must be adjusted.
-   Ticket 47748 - Simultaneous adding a user and binding as the user could fail in the password policy check
-   Ticket 47875 - dirsrv not running with old openldap
-   Ticket 47885 - deref plugin should not return references with noc access rights
