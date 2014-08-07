---
title: "Releases/1.2.11.15"
---
389 Directory Server 1.2.11.15 Testing - September 25, 2012
-----------------------------------------------------------

389-ds-base version 1.2.11.15 is released to Testing. This release fixes more bugs with CLEANALLRUV and winsync, schema reload and userpassword, and some other bugs.

The new packages and versions are:

-   389-ds-base 1.2.11.15

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

-   Transaction improvements
    -   DNA and USN use backend transaction plugins
    -   Allow most plugins to be backend transaction plugins (for testing)
-   Track when password was last modified [Track\_Password\_Update](../design/track-password-update.html)
    -   **passwordTrackUpdateTime** - if this is set to "on", the server will keep track of the last password update time
    -   **pwdUpdateTime** - new operational attribute in entries holds the last password update time if passwordTrackUpdateTime is enabled
-   Ability to disable replication agreements
    -   **nsds5ReplicaEnabled** - if this is set to "off" in the replication agreement entry, the agreement will be disabled
-   [CLEANRUV improvements](../howto/howto-cleanruv.html)
    -   New CLEANALLRUV task
-   Disk monitoring [Disk\_Monitoring](../design/disk-monitoring.html)
    -   Can enable monitoring of disk usage, particularly for databases and log files, with warnings upon reaching certain thresholds of disk usage
-   Allow setup to work with IPv6
-   Additional winsync callback hooks [Windows\_Sync\_Plugin\_API](../design/windows-sync-plugin-api.html) - add post add/mod and AD add callback hooks
-   creatorsName and modifersName keep track of original bind DN for triggered plugin operations
    -   **nsslapd-plugin-binddn-tracking** - if this is set to "on" in cn=config, the server will keep track of the original bind DN
    -   **internalModifiersname** and **internalCreatorsname** - this will be the DN of the plugin that triggered the add/update operation
-   support for Berkeley DB version 5
-   support for multiple Simple Paged Searches per connection [Simple\_Paged\_Results\_Design](../design/simple-paged-results-design.html)
-   support for SASL/PLAIN binds
-   Root DN Access Control Plugin [RootDN\_Access\_Control](../design/rootdn-access-control.html)
-   Added ability to disable the legacy password policy behavior. PasswordMaxFailure doesn't behave as some newer LDAP clients might expect [Legacy\_Password\_Policy](../design/legacy-password-policy.html)
-   Windows Sync - support for [WinSync\_Posix](../design/winsync-posix.html) - Sync POSIX attributes from Active Directory to 389 and vice versa
    -   NOTE: This version does not support ADD operations from DS to AD - POSIX attributes will not be synced - AD to DS works fine
-   Windows Sync - support for [WinSync\_Move\_Action](../design/winsync-move-admin.html) - control how winsync processes out of scope AD entries
-   Windows Sync API version 3 [Windows\_Sync\_Plugin\_API](../design/windows-sync-plugin-api.html)
    -   support for multiple winsync plugins
    -   support for plugin precedence
    -   support for pre DS to AD user and group ADD operation callbacks
    -   support for post operation callbacks

### Tickets for 1.2.11

These are all of the tickets targeted for 1.2.11. Tickets with Status **closed** and Resolution **fixed** have been fixed in this release.

-   [389 1.2.11 Tickets](https://fedorahosted.org/389/report/13)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.
