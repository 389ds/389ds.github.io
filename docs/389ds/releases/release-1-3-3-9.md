---
title: "Releases/1.3.3.9"
---
389 Directory Server 1.3.3.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.9.

Fedora packages are available from the Fedora 21, 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.9-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.9.tar.bz2)

### Highlights in 1.3.3.9

-   Several bugs are fixed including 2 security bugs

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.9-1.fc21> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.9-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.8

-   Bug 1199675 - CVE-2014-8112 CVE-2014-8105 389-ds-base: various flaws [fedora-all]
-   Ticket 47431 - Duplicate values for the attribute nsslapd-pluginarg are not handled correctly
-   Ticket 47451 - dynamic plugins - fix crash caused by invalid plugin config
-   Ticket 47728 - compilation failed with ' incomplete struct/union/enum' if not set USE_POSIX_RWLOCKS
-   Ticket 47742 - 64bit problem on big endian: auth method not supported
-   Ticket 47801 - RHDS keeps on logging write_changelog_and_ruv: failed to update RUV for unknown
-   Ticket 47828 - DNA scope: allow to exlude some subtrees
-   Ticket 47836 - Do not return '0' as empty fallback value of nsds5replicalastupdatestart and nsds5replicalastupdatestart
-   Ticket 47901 - After total init, nsds5replicaLastInitStatus can report an erroneous error status (like 'Referral')
-   Ticket 47936 - Create a global lock to serialize write operations over several backends
-   Ticket 47957 - Make ReplicaWaitForAsyncResults configurable
-   Ticket 48001 - ns-activate.pl fails to activate account if it was disabled on AD
-   Ticket 48003 - add template scripts
-   Ticket 48003 - build "suite" framework
-   Ticket 48005 - ns-slapd crash in shutdown phase
-   Ticket 48021 - nsDS5ReplicaBindDNGroup checkinterval not working properly
-   Ticket 48027 - revise the rootdn plugin configuration validation
-   Ticket 48030 - spec file should run "systemctl stop" against each running instance instead of dirsrv.target
-   Ticket 48048 - Fix coverity issues - 2015/2/24
-   Ticket 48048 - Fix coverity issues - 2015/3/1
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
