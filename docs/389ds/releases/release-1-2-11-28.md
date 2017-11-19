---
title: "Releases/1.2.11.28"
---
389 Directory Server 1.2.11.28
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.28.

This release is only available in binary form for EL5 (EPEL5) and EL6 - see [Download\#RHEL6/EPEL6](../download.html) for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.28-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.28.tar.bz2)

### Highlights in 1.2.11.28

-   security fix
-   several bug fixes

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

### Detailed Changelog since 1.2.11.25

-   Ticket 47739 - directory server is insecurely misinterpreting authzid on a SASL/GSSAPI bind
-   Ticket 47731 - A tombstone entry is deleted by ldapdelete
-   Ticket 47729 - Directory Server crashes if shutdown during a replication initialization
-   Ticket 47637 - rsa\_null\_sha should not be enabled by default
-   Ticket 417, 458, 47522 - Password Administrator Backport
-   Ticket 47455 - valgrind - value mem leaks, uninit mem usage
-   fix coverity 11915 - dead code - introduced with fix for ticket 346
-   Ticket 47369 version2 - provide default syntax plugin
-   Ticket 346 - version 4 Slow ldapmodify operation time for large quantities of multi-valued attribute values
-   Ticket 415 - winsync doesn't sync DN valued attributes if DS DN value doesn't exist
-   Ticket 47642 - Windows Sync group issues
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47677 - Size returned by slapi\_entry\_size is not accurate
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 471 - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   Ticket 47463 - IDL-style can become mismatched during partial restoration
-   Ticket 47638 - Overflow in nsslapd-disk-monitoring-threshold on 32bit platform
-   Ticket 47641 - 7-bit check plugin not checking MODRDN operation
-   Ticket 47678 - modify-delete userpassword
-   Ticket 47516 - replication stops with excessive clock skew
-   Ticket 47627 - Fix replication logging
-   Ticket 47627 - changelog iteration should ignore cleaned rids when getting the minCSN
-   Ticket 47623 - fix memleak caused by 47347
-   Ticket 47587 - hard coded limit of 64 masters in agreement and changelog code
-   Ticket 47591 - entries with empty objectclass attribute value can be hidden
-   Ticket 47596 - attrcrypt fails to find unlocked key

