---
title: "389-ds-base 1.2.10.0"
---

# 389 Directory Server 1.2.10.0 - February 14, 2012
-------------------------------------------------

389-ds-base version 1.2.10.0 is released. This release contains many fixes for bugs found in a8 and rc1 testing, and in earlier releases. No new features were introduced after alpha 8.

We have moved our ticket tracking system from the Red Hat Bugzilla [<https://bugzilla.redhat.com/enter_bug.cgi?product=389>](https://bugzilla.redhat.com/enter_bug.cgi?product=389) to our Fedora Hosted Trac [<https://fedorahosted.org/389>](https://fedorahosted.org/389). All of the old 389 bugs have been copied to Trac. All new bugs, feature requests, and tasks should be entered in Trac.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or later, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or later, there is no problem.

**WARNING Plugin Writers**: Plugins should be made transaction aware so that they can be called from within a backend pre/post transaction plugin. Otherwise, attempting to perform an internal operation will cause a deadlock. See [Plugins](../design/plugins.html)

The new packages and versions are:

-   389-ds-base 1.2.10.0
-   389-admin 1.1.27
-   389-dsgw 1.1.9
-   389-adminutil 1.1.15

### Installation

See [Download](../download.html) for information about setting up your yum repositories. Then use **yum install 389-ds**

    yum install 389-ds    

After install completes, run **setup-ds-admin.pl** to set up your directory server.

    setup-ds-admin.pl    

### Upgrade

See [Download](../download.html) for information about setting up your yum repositories. Then use **yum upgrade**

    yum upgrade    

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

    setup-ds-admin.pl -u    

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

NOTE: Fedora versions below 15 are no longer supported. If you are running Fedora 14 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features (up to and including 1.2.10.a8 - none after a8)

-   Account Usability Control support
-   database transaction pre/post plugins
    -   Changelog writes use main database transaction
    -   All plugins are transaction aware
-   native systemd support (Fedora 16 and later)
-   slapi\_rwlock support replaces direct NSPR PR\_RWLock support - solves some deadlock issues in certain cases
-   improved entryrdn index
-   Performance improvements
    -   Reduce DN normalization
    -   speed up searches that use large filters with large result sets
-   Automember and Managed Entry improvements

### Tickets for 1.2.10

These are all of the tickets targeted for 1.2.10. Tickets with Status **closed** and Resolution **fixed** have been fixed in this release.

-   [389 1.2.10 Tickets](https://fedorahosted.org/389/report/12)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](Install_Guide "wikilink") has information about installation and setup.
