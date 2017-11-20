---
title: "Releases/1.2.11.32"
---
389 Directory Server 1.2.11.32
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.32.

This release is only available in binary form for EL5 (EPEL5) and EL6 - see [Download\#RHEL6/EPEL6](../download.html) for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.32-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.32.tar.bz2)

### Highlights in 1.2.11.32

-   several bug fixes including a security bug

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds**

`yum install 389-ds`

After install completes, run **setup-ds-admin.pl** to set up your directory server.

`setup-ds-admin.pl`

To upgrade, use **yum upgrade**

`yum upgrade`

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

`setup-ds-admin.pl -u`

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.2.11.29

-   Bug 1129660  - Adding users to user group throws Internal server error.
-   Ticket 346   - Fixing memory leaks
-   Ticket 346   - Slow ldapmodify operation time for large quantities of multi-valued attribute values
-   Ticket 415   - winsync doesn't sync DN valued attributes if DS DN value doesn't exist
-   Ticket 443   - Deleting attribute present in nsslapd-allowed-to-delete-attrs returns Operations error
-   Ticket 616   - High contention on computed attribute lock
-   Ticket 47331 - Self entry access ACI not working properly
-   Ticket 47426 - Coverity issue with last commit(move compute_idletimeout out of handle_pr_read_ready)
-   Ticket 47426 - move compute_idletimeout out of handle_pr_read_ready
-   Ticket 47446 - logconv.pl memory continually grows
-   Ticket 47457 - default nsslapd-sasl-max-buffer-size should be 2MB
-   Ticket 47649 - Server hangs in cos_cache when adding a user entry
-   Ticket 47670 - Aci warnings in error log
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47707 - 389 DS Server crashes and dies while handles paged searches from clients
-   Ticket 47713 - Logconv.pl with an empty access log gives lots of errors
-   Ticket 47736 - Import incorrectly updates numsubordinates for tombstone entries
-   Ticket 47750 - Creating a glue fails if one above level is a conflict or missing
-   Ticket 47764 - Problem with deletion while replicated
-   Ticket 47767 - Nested tombstones become orphaned after purge
-   Ticket 47770 - #481 breaks possibility to reassemble memberuid list
-   Ticket 47771 - Cherry pick issue parentsdn freed twice
-   Ticket 47771 - Move parentsdn initialization to avoid crash
-   Ticket 47771 - Performing deletes during tombstone purging results in operation errors
-   Ticket 47772 - empty modify returns LDAP_INVALID_DN_SYNTAX
-   Ticket 47772 - fix coverity issue
-   Ticket 47773 - mem leak in do_bind when there is an error
-   Ticket 47774 - mem leak in do_search - rawbase not freed upon certain errors
-   Ticket 47780 - Some VLV search request causes memory leaks
-   Ticket 47781 - Server deadlock if online import started while  server is under load
-   Ticket 47782 - Parent numbordinate count can be incorrectly updated if an error occurs
-   Ticket 47787 - A replicated MOD fails (Unwilling to perform) if it targets a tombstone
-   Ticket 47793 - Server crashes if uniqueMember is invalid syntax and memberOf                plugin is enabled.
-   Ticket 47804 - db2bak.pl error with changelogdb
-   Ticket 47809 - find a way to remove replication plugin errors messages "changelog iteration code returned a dummy entry with csn %s, skipping ..."
-   Ticket 47813 - managed entry plugin fails to update member  pointer on modrdn operation
-   Ticket 47813 - remove "goto bail" from previous commit
-   Ticket 47817 - The error result text message should be obtained just prior to sending result
-   Ticket 47820 - 1.2.11 branch: coverity errors
-   Ticket 47821 - deref plugin cannot handle complex acis
-   Ticket 47824 - paged results control is not working in some cases when we have a subsuffix.
-   Ticket 47831 - server restart wipes out index config if there is a default index
-   Ticket 47858 - Internal searches using OP_FLAG_REVERSE_CANDIDATE_ORDER can crash the server
-   Ticket 47861 - Certain schema files are not replaced during upgrade
-   Ticket 47862 - Repl-monitor.pl ignores the provided connection parameters
-   Ticket 47862 - repl-monitor fails to convert "*" to default values
-   Ticket 47863 - New defects found in 389-ds-base-1.2.11
-   Ticket 47869 - unauthenticated information disclosure (Bug 1123477)
-   Ticket 47872 - Filter AND with only one clause should be optimized
-   Ticket 47874 - Performance degradation with scope ONE after some load
-   Ticket 47875 - dirsrv not running with old openldap
