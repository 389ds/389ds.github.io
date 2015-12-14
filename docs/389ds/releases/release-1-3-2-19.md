---
title: "Releases/1.3.2.19"
---
389 Directory Server 1.3.2.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.19.

Fedora packages are available from the Fedora 20 Testing and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.19-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.19.tar.bz2)

### Highlights in 1.3.2.19

-   Various bugs were fixed.

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

### Detailed Changelog since 1.3.2.16

-   Ticket 346 - Slow ldapmodify operation time for large quantities of multi-valued attribute values
-   Ticket 47446 - logconv.pl memory continually grows
-   Ticket 47538 - RFE: repl-monitor.pl plain text output, cmdline config options
-   Ticket 47541 - Replication of the schema may overwrite consumer 'attributetypes' even if consumer definition is a superset
-   Ticket 47640 - Fix coverity issues - part 3
-   Ticket 47670 - Aci warnings in error log
-   Ticket 47676 - Replication of the schema fails 'master branch' -\> 1.2.11 or 1.3.1
-   Ticket 47704 - invalid sizelimits in aci group evaluation
-   Ticket 47707 - 389 DS Server crashes and dies while handles paged searches from clients
-   Ticket 47713 - Logconv.pl with an empty access log gives lots of errors
-   Ticket 47720 - Normalization from old DN format to New DN format doesnt handel condition properly when there is space in a suffix after the seperator operator.
-   Ticket 47721 - Schema Replication Issue
-   Ticket 47722 - Fixed filter not correctly identified
-   Ticket 47722 - rsearch filter error on any search filter
-   Ticket 47732 - ds logs many "SLAPI\_PLUGIN\_BE\_TXN\_POST\_DELETE\_FN plugin returned error" messages
-   Ticket 47733 - ds logs many "Operation error fetching Null DN" messages
-   Ticket 47734 - Change made in resolving ticket \#346 fails on Debian SPARC64
-   Ticket 47735 - e\_uniqueid fails to set if an entry is a conflict entry
-   Ticket 47740 - Coverity Fixes (Mark - part 1)
-   Ticket 47740 - Coverity issue in 1.3.3
-   Ticket 47740 - Crash caused by changes to certmap.c
-   Ticket 47740 - Fix coverity erorrs - Part 4
-   Ticket 47740 - Fix coverity issues - Part 5
-   Ticket 47740 - Fix coverity issues(part 7)
-   Ticket 47740 - Fix coverity issues: null deferences - Part 6
-   Ticket 47740 - Fix sync plugin resource leaks
-   Ticket 47743 - Memory leak with proxy auth control
-   Ticket 47748 - Simultaneous adding a user and binding as the user could fail in the password policy check
-   Ticket 47750 - Creating a glue fails if one above level is a conflict or missing
-   Ticket 47759 - Crash in replication when server is under write load
-   Ticket 47763 - winsync plugin modify is broken
-   Ticket 47764 - Problem with deletion while replicated
-   Ticket 47766 - Tombstone purging can crash the server if the backend is stopped/disabled
-   Ticket 47767 - Nested tombstones become orphaned after purge
-   Ticket 47770 - \#481 breaks possibility to reassemble memberuid list
-   Ticket 47771 - Move parentsdn initialization to avoid crash
-   Ticket 47772 - empty modify returns LDAP\_INVALID\_DN\_SYNTAX
-   Ticket 47773 - mem leak in do\_bind when there is an error
-   Ticket 47774 - mem leak in do\_search - rawbase not freed upon certain errors
-   Ticket 47779 - Need to lock server list when removing list
-   Ticket 47779 - Part of DNA shared configuration is deleted after server restart
-   Ticket 47779 - Potential deadlock after startup if a dna configuration change is made
-   Ticket 47780 - Some VLV search request causes memory leaks
-   Ticket 47782 - Parent numbordinate count can be incorrectly updated if an error occurs
-   Ticket 47787 - A replicated MOD fails (Unwilling to perform) if it targets a tombstone
-   Ticket 47792 - database plugins need a way to call betxn plugins
-   Ticket 47793 - Server crashes if uniqueMember is invalid syntax and memberOf plugin is enabled.
-   Ticket 47804 - db2bak.pl error with changelogdb
-   Ticket 47806 - Failed deletion of aci: no such attribute
-   Ticket 47808 - If be\_txn plugin fails in ldbm\_back\_add, adding entry is double freed.
-   Ticket 47809 - find a way to remove replication plugin errors messages "changelog iteration code returned a dummy entry with csn %s, skipping ..."
-   Ticket 47813 - managed entry plugin fails to update member pointer on modrdn operation
-   Ticket 47815 - Add operations rejected by betxn plugins remain in cache
-   Ticket 47817 - The error result text message should be obtained just prior to sending result
-   Ticket 47821 - deref plugin cannot handle complex acis
-   Ticket 47831 - server restart wipes out index config if there is a default index
-   Ticket 47839 - 389-ds production segfault: \_\_memcpy\_sse2\_unaligned...

