---
title: "Releases/1.2.11.17"
---
389 Directory Server 1.2.11.17 Testing - Decemeber 10, 2012
-----------------------------------------------------------

389-ds-base version 1.2.11.17 is released to Testing. This release fixes more bugs with CLEANALLRUV and winsync, schema reload and userpassword, and some other bugs.

The new packages and versions are:

-   389-ds-base 1.2.11.17

NOTE: **1.2.11 will not be available for Fedora 16 or earlier, nor for EL6 or earlier** 1.2.11 will only be available for Fedora 17 and later. We are trying to stabilize current, stable releases - upgrades to 1.2.11 will disrupt stability.

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

See [Download](../download.html) for more information about setting up yum access.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade.

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

**EL6** - see [Download](../download.html) for EL6 instructions

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system.

-   Go to <https://admin.fedoraproject.org/updates>
-   In the Search box in the upper right hand corner, type in the name of the package
-   In the list, find the version and release you are using (if you're not sure, use rpm -qi <package name> on your system) and click on the release
-   On the page for the update, scroll down to "Add a comment" and provide your input

Or just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, use the 389 Trac - [<https://fedorahosted.org/389>](https://fedorahosted.org/389)

### Notes

NOTE: **1.2.11 will not be available for Fedora 16 or earlier, nor for EL6 or earlier** 1.2.11 will only be available for Fedora 17 and later. We are trying to stabilize current, stable releases - upgrades to 1.2.11 will disrupt stability.

### New features in 1.2.11

`ns-slapd segfaults if it cannot rename the logs`
`disable replication agreements`
`Allow automember to work on entries that have already been added`
`improve CLEANRUV functionality`
`internalModifiersname not updated by DNA plugin`
`crash in DNA if no dnaMagicRegen is specified`
`RedHat Directory Server crashes (segfaults) when moving ldap entry`
`Search with a complex filter including range search is slow`
`Newly created users with organizationalPerson objectClass fails to sync from AD to DS with missing attribute error`
`Improve AD version in winsync log message`
`Cannot abaondon simple paged result search`
`slapd entered to infinite loop during new index addition`
`if pam_passthru is enabled, need to AC_CHECK_HEADERS([security/pam_appl.h])`
`nsslapd-enablePlugin should not be multivalued`
`Doc: DS error log messages with typo`
`multimaster_extop_cleanruv returns wrong error codes`

### Tickets for 1.2.11

These are all of the tickets targeted for 1.2.11. Tickets with Status **closed** and Resolution **fixed** have been fixed in this release.

-   [389 1.2.11 Tickets](https://fedorahosted.org/389/report/13)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.
