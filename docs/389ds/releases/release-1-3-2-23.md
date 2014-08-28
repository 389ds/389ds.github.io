---
title: "Releases/1.3.2.23"
---
389 Directory Server 1.3.2.23
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.23.

Fedora packages are available from the Fedora 20 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.23-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.23.tar.bz2)

### Highlights in 1.3.2.23

-   Various bugs were fixed.

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

### Detailed Changelog since 1.3.2.22

-   Ticket 346   - Fixing memory leaks
-   Ticket 47446 - logconv.pl memory continually grows
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47753 - Add switch to disable pre-hashed password checking
-   Ticket 47781 - Server deadlock if online import started while  server is under load
-   Ticket 47797 - DB deadlock when two threads (on separated backend) try to record changes in retroCL
-   Ticket 47797 - fix the indentation
-   Ticket 47816 - v2- internal syncrepl searches are flagged as unindexed
-   Ticket 47824 - paged results control is not working in some cases when we have a subsuffix.
-   Ticket 47834 - Tombstone_to_glue: if parents are also converted to glue, the target entry's DN must be adjusted.
-   Ticket 47858 - Internal searches using OP_FLAG_REVERSE_CANDIDATE_ORDER can crash the server
-   Ticket 47861 - Certain schema files are not replaced during upgrade
-   Ticket 47862 - Repl-monitor.pl ignores the provided connection parameters
-   Ticket 47862 - repl-monitor fails to convert "*" to default values
-   Ticket 47866 - Errors after upgrading related to attribute "dnaremotebindmethod"
-   Ticket 47869 - unauthenticated information disclosure (Bug 1123477)
-   Ticket 47871 - 389-ds-base-1.3.2.21-1.fc20 crashed over the weekend
-   Ticket 47872 - Filter AND with only one clause should be optimized
-   Ticket 47874 - Performance degradation with scope ONE after some load
-   Ticket 47875 - dirsrv not running with old openldap
-   Ticket 47877 - check_and_add_entry fails for changetype: add and existing entry


