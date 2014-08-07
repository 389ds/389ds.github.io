---
title: "Releases/1.3.0.2"
---
389 Directory Server 1.3.0.2 - January 21, 2013
-----------------------------------------------

389-ds-base version 389-ds-base-1.3.0.2-1 is released to Stable repositories. This release supports slapi transactions, improved performance, as well as fixed bugs.

The new packages and versions are:

-   389-ds-base-1.3.0.2-1

### Installation

See [Download](../download.html) for information about setting up your yum repositories. Then use **yum install 389-ds**

`yum install 389-ds`

After install completes, run **setup-ds-admin.pl** to set up your directory server.

`setup-ds-admin.pl`

If running 389-ds on Fedora, use **'systemctl start|stop dirsrv.target**' for stopping and starting 389-ds, instead of using **'service dirsrv start|stop**'

### Upgrade

See [Download](../download.html) for information about setting up your yum repositories. Then use **yum upgrade**

`yum upgrade`

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

`setup-ds-admin.pl -u`

See [Download](../download.html) for more information about setting up yum accb12e69e Ticket 541 -ess.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade.d

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system.

-   Go to <https://admin.fedoraproject.org/updates>
-   In the Search box in the upper right hand corner, type in the name of the package
-   In the list, find the version and release you are using (if you're not sure, use rpm -qi <package name> on your system) and click on the release
-   On the page for the update, scroll down to "Add a comment" and provide your input

Or just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, use the 389 Trac - [<https://fedorahosted.org/389>](https://fedorahosted.org/389)

### Notes

NOTE: **1.3.0 will not be available for Fedora 17 or earlier, nor for EL6 or earlier** 1.3.0 will only be available for Fedora 18 and later. We are trying to stabilize current, stable releases - upgrades to 1.3.0 will disrupt stability.

### New features / Fixed bugs in 1.3.0

`Don't overwrite certmap.conf during upgrade`
`Cannot dynamically set nsslapd-maxbersize`
`DNA plugin no longer reports additional info when range is depleted`
`need to set plugin as off in ldif template`
`RootDN Access Control plugin is missing after upgrade`
`Escaped character cannot be used in the substring search filter`
`betxn: upgrade is not implemented yet`
`Create DOAP description for the 389 Directory Server project`
`Handling URP results is not correct`
`lock-free access to be->be_suffixlock`
`improve entry cache sizing`
`Clean up compiler warnings for 1.3`
`loading an entry from the database should use str2entry_fast`
`lock-free access to be->be_suffixlock`
`ns-slapd segfaults if it cannot rename the logs`
`RFE: 389-ds shouldn't advertise in the rootDSE that we can handle a sasl mech if we really can't`
`disable replication agreements`
`dse.ldif is 0 length after server kill or machine kill`
`Change in winSyncInterval does not take immediate effect`
`Allow automember to work on entries that have already been added`
`nsViewFilter syntax issue in 389DS 1.2.5`
`improve CLEANRUV functionality`
`modify-delete userpassword`
`minor fixes for bdb 4.2/4.3 and mozldap`
`Multiple threads simultaneously working on connection's private buffer causes ns-slapd to abort`
`cn=monitor showing stats for other db instances`
`use mutex for FrontendConfig lock instead of rwlock`
`Avoid creating an attribute just to determine the syntax for a type, look up the syntax directly by type`
`crash in DNA if no dnaMagicRegen is specified`
`RedHat Directory Server crashes (segfaults) when moving ldap entry`
`Search with a complex filter including range search is slow`
`Newly created users with organizationalPerson objectClass fails to sync from AD to DS with missing attribute error`
`IP lookup failing with multiple DNS entries`
`Possible to add invalid attribute to nsslapd-allowed-to-delete-attrs`
`Deleting attribute present in nsslapd-allowed-to-delete-attrs returns Operations error`
`Improve AD version in winsync log message`
`Un-resolvable server in replication agreement produces unclear error message`
`Slapd crashes when deleting backends while operations are still in progress`
`Possible to set invalid macros in Macro ACIs`
`Cannot abaondon simple paged result search`
`slapd entered to infinite loop during new index addition`
`Internal Password Policy usage very inefficient`
`internalModifiersname not updated by DNA plugin`
`if pam_passthru is enabled, need to AC_CHECK_HEADERS([security/pam_appl.h])`
`nsslapd-enablePlugin should not be multivalued`
`Doc: DS error log messages with typo`
`Allow db2ldif to be quiet`
`multimaster_extop_cleanruv returns wrong error codes`
`expand nested posix groups`
`Insufficient rights to unhashed#user#password when user deletes his password`
`anonymous limits are being applied to directory manager`
`MOD operations with chained delete/add get back error 53 on backend config`
`ds-logpipe.py script's man page and script help should be updated for -t option.`
`RFE: Interpret IPV6 addresses for ACIs, replication, and chaining `
`RFE - Make RIP working with Replicated Entries `
`make sure all internal search filters are properly escaped `
`389-admin build fails on F-18 with new apache  `
`deadlock in replica_write_ruv`
`use betxn plugins by default`
`make cos, roles, views betxn aware `
`logconv.pl track bind info`
`Audit log - clear text password in user changes `
`Opening merge qualifier CoS entry using RHDS console changes the entry. `
`Setting nsslapd-listenhost or nsslapd-securelistenhost breaks ACI processing   `
`Overconsumption of memory with large cachememsize and heavy use of ldapmodify  `
`unhashedTicket #userTicket #password in entry extension    `
`Create a normalized dn cache   `
`db2index with -tattrname:type,type fails   `
`fix build problem with mozldap c sdk   `
`add test for include file mntent.h     `
`different parameters of getmntent in Solaris`

### Tickets for 1.3.0

These are all of the tickets targeted for 1.3.0. Tickets with Status **closed** and Resolution **fixed** have been fixed in this release.

-   [389 1.3.0 Tickets](https://fedorahosted.org/389/report/14)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.
