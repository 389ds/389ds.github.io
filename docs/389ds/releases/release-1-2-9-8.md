---
title: "Releases/1.2.9.8"
---
389 Directory Server 1.2.9.8 Testing - September 1, 2011
--------------------------------------------------------

389-ds-base version 1.2.9.8 is released to the Testing repositories. This release contains fixes for bugs found in 1.2.8.x and 1.2.9.x. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. Other 389 packages have been updated as well. See below for the new packages and versions.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

`fixfiles -R 389-ds-base restore`

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7 or 1.2.8, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer "wikilink") for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or later, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.9.8
-   389-admin 1.1.23

### Installation

`yum install --enablerepo=updates-testing 389-ds`
`OR`
`yum install --enablerepo=epel-testing 389-ds`
`setup-ds-admin.pl`

### Upgrade

`yum upgrade --enablerepo=updates-testing 389-ds-base \`
` 389-admin idm-console-framework 389-ds-console 389-admin-console \`
` 389-adminutil 389-dsgw 389-console`
`OR`
`yum upgrade --enablerepo=epel-testing 389-ds-base \`
` 389-admin idm-console-framework 389-ds-console 389-admin-console \`
` 389-adminutil 389-dsgw 389-console`
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

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 14 are no longer supported. If you are running Fedora 13 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

`fixfiles -R 389-ds-base restore`

### New features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.9](https://bugzilla.redhat.com/showdependencytree.cgi?id=708096&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.
