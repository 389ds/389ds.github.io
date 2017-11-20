---
title: "Releases/1.3.0.5"
---
389 Directory Server 1.3.0.5
----------------------------

389-ds-base version 389-ds-base-1.3.0.5-1 is released to Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.0.5-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.0.5.tar.bz2)

### Highlights in 1.3.0.5

-   Fix crash caused by getting a get effective rights of non-existing entry.
-   Fix crash caused by a schema-reload utility under the stress.
-   Fix crash caused in acl evaluation in modrdn.
-   Fix deadlock caused by a configuration update on DNA plug-in.
-   Fix cleanAllRUV task failure when cleaning up config upon completion.
-   Fix unintended anonymous access on rootdse when anonymous access is not allowed.

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

### Detailed Changelog since 1.3.0.4

Mark Reynolds (3):

-   [Ticket 619 - Crash in MODRDN](https://fedorahosted.org/389/ticket/619)
-   [Ticket 623 - cleanAllRUV task fails to cleanup config upon completion](https://fedorahosted.org/389/ticket/623)
-   [Ticket 628 - crash in aci evaluation](https://fedorahosted.org/389/ticket/628)

Noriko Hosoi (3):

-   [Ticket 627 - ns-slapd crashes sporadically with segmentation fault in libslapd.so](https://fedorahosted.org/389/ticket/627)
-   [Ticket 634 - Deadlock in DNA plug-in](https://fedorahosted.org/389/ticket/634)
-   [Ticket 47308 - CVE-2013-1897: unintended information exposure when anonymous access is set to rootdse](https://fedorahosted.org/389/ticket/47308)

