---
title: "Releases/1.3.3.8"
---
389 Directory Server 1.3.3.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.8.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.8-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.8.tar.bz2)

### Highlights in 1.3.3.8

-   Several bugs are fixed including security bugs -- stop using DES and old SSL version.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.8-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.5

-   Ticket 47451 - Dynamic plugins
-   Ticket 47462 - Stop using DES in the reversible password encryption plug-in
-   Ticket 47525 - Crash if setting invalid plugin config area for MemberOf Plugin
-   Ticket 47553 - Enhance ACIs to have more control over MODRDN operations
-   Ticket 47617 - replication changelog trimming setting validation
-   Ticket 47636 - Error log levels not displayed correctly
-   Ticket 47722 - Using the filter file does not work
-   Ticket 47738 - use PL_strcasestr instead of strcasestr
-   Ticket 47750 - During delete operation do not refresh cache entry if it is a tombstone
-   Ticket 47750 - Need to refresh cache entry after called betxn postop plugins
-   Ticket 47807 - SLAPI_REQUESTOR_ISROOT not set for extended operation plugins
-   Ticket 47810 - RI plugin does not return result code if update fails
-   Ticket 47905 - Bad manipulation of passwordhistory
-   Ticket 47928 - Disable SSL v3, by default.
-   Ticket 47934 - nsslapd-db-locks modify not taking into account.
-   Ticket 47935 - Error: failed to open an LDAP connection to host 'example.org' port '389' as user 'cn=Directory Manager'. Error: unknown.
-   Ticket 47937 - Crash in entry_add_present_values_wsi_multi_valued
-   Ticket 47939 - Malformed cookie for LDAP Sync makes DS crash
-   Ticket 47942 - DS hangs during online total update
-   Ticket 47945 - Add SSL/TLS version info to the access log
-   Ticket 47947 - start dirsrv after chrony on RHEL7 and Fedora
-   Ticket 47948 - ldap_sasl_bind fails assertion (ld != NULL) if it is called from chainingdb_bind over SSL/startTLS
-   Ticket 47949 - logconv.pl -- support parsing/showing/reporting different protocol versions
-   Ticket 47950 - Bind DN tracking unable to write to internalModifiersName without special permissions
-   Ticket 47952 - PasswordAdminDN attribute is not properly returned to client
-   Ticket 47953 - Should not check aci syntax when deleting an aci
-   Ticket 47958 - Memory leak in password admin if the admin entry does not exist
-   Ticket 47960 - cookie_change_info returns random negative number if there was no change in a tree
-   Ticket 47963 - RFE - memberOf - add option to skip nested  group lookups during delete operations
-   Ticket 47964 - Incorrect search result after replacing an empty attribute
-   Ticket 47965 - Fix coverity issues 
-   Ticket 47967 - cos_cache_build_definition_list does not stop during server shutdown
-   Ticket 47969 - COS memory leak when rebuilding the cache
-   Ticket 47970 - Account lockout attributes incorrectly updated after failed SASL Bind
-   Ticket 47973 - During schema reload sometimes the search returns no results
-   Ticket 47980 - Nested COS definitions can be incorrectly  processed
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as  invalid when there are multiple suffixes
-   Ticket 47988 - Schema learning mechanism, in replication, unable to extend an existing definition
-   Ticket 47989 - Windows Sync accidentally cleared raw_entry
-   Ticket 47991 - upgrade script fails if /etc and /var are on different file systems
-   Ticket 47996 - ldclt needs to support SSL Version range
-   Ticket 48001 - ns-activate.pl fails to activate account if it was disabled on AD
