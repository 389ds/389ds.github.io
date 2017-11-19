---
title: "Releases/1.2.11.29"
---
389 Directory Server 1.2.11.29
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.29.

This release is only available in binary form for EL5 (EPEL5) and EL6 - see [Download\#RHEL6/EPEL6](../download.html) for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.29-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.29.tar.bz2)

### Highlights in 1.2.11.29

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

### Detailed Changelog since 1.2.11.28

-   Ticket 346 - version 4 Slow ldapmodify operation time for large quantities of multi-valued attribute values
-   Ticket 415 - winsync doesn't sync DN valued attributes if DS DN value doesn't exist
-   Ticket 417, 458, 47522 - Password Administrator Backport
-   Ticket 471 - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   Ticket 47369 - version2 - provide default syntax plugin
-   Ticket 47448 - Segfault in 389-ds-base-1.3.1.4-1.fc19 when setting up FreeIPA replication
-   Ticket 47455 - valgrind - value mem leaks, uninit mem usage
-   Ticket 47463 - IDL-style can become mismatched during partial restoration
-   Ticket 47492 - PassSync removes User must change password flag on the Windows side
-   Ticket 47516 - replication stops with excessive clock skew
-   Ticket 47538 - RFE: repl-monitor.pl plain text output, cmdline config options
-   Ticket 47587 - hard coded limit of 64 masters in agreement and changelog code
-   Ticket 47591 - entries with empty objectclass attribute value can be hidden
-   Ticket 47596 - attrcrypt fails to find unlocked key
-   Ticket 47623 - fix memleak caused by 47347
-   Ticket 47627 - changelog iteration should ignore cleaned rids when getting the minCSN
-   Ticket 47627 - Fix replication logging
-   Ticket 47637 - rsa\_null\_sha should not be enabled by default
-   Ticket 47638 - Overflow in nsslapd-disk-monitoring-threshold on 32bit platform
-   Ticket 47640 - Fix coverity issues - part 3
-   Ticket 47641 - 7-bit check plugin not checking MODRDN operation
-   Ticket 47642 - Windows Sync group issues
-   Ticket 47677 - Size returned by slapi\_entry\_size is not accurate
-   Ticket 47678 - modify-delete userpassword
-   Ticket 47692 - single valued attribute replicated ADD does not work
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 47693 - Environment variables are not passed when DS is started via service
-   Ticket 47704 - invalid sizelimits in aci group evaluation
-   Ticket 47722 - rsearch filter error on any search filter
-   Ticket 47722 - Fixed filter not correctly identified
-   Ticket 47729 - Directory Server crashes if shutdown during a replication initialization
-   Ticket 47731 - A tombstone entry is deleted by ldapdelete
-   Ticket 47734 - Change made in resolving ticket \#346 fails on Debian SPARC64
-   Ticket 47735 - e\_uniqueid fails to set if an entry is a conflict entry
-   Ticket 47737 - Under heavy stress, failure of turning a tombstone into glue makes the server hung
-   Ticket 47740 - Coverity Fixes (Mark - part 1)
-   Ticket 47740 - Coverity issue in 1.3.3
-   Ticket 47740 - Crash caused by changes to certmap.c
-   Ticket 47740 - Fix coverity erorrs - Part 4
-   Ticket 47740 - Fix coverity issues - Part 5
-   Ticket 47740 - Fix coverity issues: null deferences - Part 6
-   Ticket 47740 - Fix coverity issues(part 7)
-   Ticket 47743 - Memory leak with proxy auth control
-   Ticket 47748 - Simultaneous adding a user and binding as the user could fail in the password policy check
-   Ticket 47766 - Tombstone purging can crash the server if the backend is stopped/disabled
-   fix coverity 11915 - dead code - introduced with fix for ticket 346

