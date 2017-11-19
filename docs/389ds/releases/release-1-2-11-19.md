---
title: "Releases/1.2.11.19"
---
389 Directory Server 1.2.11.19
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.19.

Fedora packages are available from the Fedora 18 Testing repositories. It will move to the Fedora 18 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/FEDORA-2013-2485/389-ds-base-1.2.11.19-1.fc17) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.2.11.19-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.19.tar.bz2)

### Highlights in 1.2.11.19

Fixed security issue with invalid controls.

Fixed crash casued by trying to delete a tombstone entry.

Fixed issue where the dse.ldif can get corrupted.

Fixed erroneous error message from WinSync.

Improved DNA plugin startup process.

Fixed issue where an invalid chaining plugin configuration would accidentally casue the server to shutdown.

Fixed issue with replication interfering with certain modify operations.

Fixed some ememory leaks.

Fixed issue with the PAM plugin schema not being upgraded correctly.

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

### Detailed Changelog since 1.2.11.18

Noriko Hosoi (5):

-   [Bug 912964 - CVE-2013-0312 389-ds: unauthenticated denial of service vulnerability in handling of LDAPv3 control data](https://bugzilla.redhat.com/show_bug.cgi?id=912964)
-   [Ticket 579 - Error messages encountered when using POSIX winsync](https://fedorahosted.org/389/ticket/579)
-   [Ticket 576 - DNA: use event queue for config update only at the start up](https://fedorahosted.org/389/ticket/576)
-   [Ticket 572 - PamConfig schema not updated during upgrade](https://fedorahosted.org/389/ticket/572)
-   [Bug 906005 - Valgrind reports memleak in modify\_update\_last\_modified\_attr](https://bugzilla.redhat.com/show_bug.cgi?id=906005)

Mark Reynolds (4):

-   bump version to 1.2.11.19
-   [Ticket 570 - DS returns error 20 when replacing values of a multi-valued attribute (only when replication is enabled)](https://fedorahosted.org/389/ticket/570)
-   [Ticket 590 - ns-slapd segfaults while trying to delete a tombstone entry](https://fedorahosted.org/389/ticket/590)
-   [Ticket 367 - Invalid chaining config triggers a disk full error and shutdown](https://fedorahosted.org/389/ticket/367)

Ludwig Krispenz (1):

-   [Ticket \#518 - dse.ldif is 0 length after server kill or machine kill](https://fedorahosted.org/389/ticket/518)

