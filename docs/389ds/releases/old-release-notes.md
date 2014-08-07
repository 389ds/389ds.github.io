---
title: "Old Release Notes"
---

# Old Release Notes
-----------------

-   [ 389 Directory Server 1.2.10.24](Releases/1.2.10.24 "wikilink") *(January 14, 2013)*
-   [ 389 Directory Server 1.2.10.7](Releases/1.2.10.7 "wikilink") *(April 30, 2012)*
-   [ 389 Directory Server 1.2.10.4](Releases/1.2.10.4 "wikilink") *(March 29, 2012)*
-   [ 389 Directory Server 1.2.10.3](Releases/1.2.10.3 "wikilink") *(March 8, 2012)*
-   [ 389 Directory Server 1.2.10.2](Releases/1.2.10.2 "wikilink") *(February 23, 2012)*
-   [ 389 Directory Server 1.2.10.0](Releases/1.2.10.0 "wikilink") *(February 14, 2012)*
-   [ 389 Directory Server 1.2.10.rc1](Releases/1.2.10.rc1 "wikilink") *(February 6, 2012)*
-   [ 389 Directory Server 1.2.10.a8](Releases/1.2.10.a8 "wikilink") *(January 25, 2012)*
-   [ 389 Directory Server 1.2.9.9](Releases/1.2.9.9 "wikilink") *(September 7, 2011)*
-   [ 389 Directory Server 1.2.9.8](Releases/1.2.9.8 "wikilink") *(September 1, 2011)*
-   [ 389 Directory Server 1.2.9.6](Releases/1.2.9.6 "wikilink") *(August 12, 2011)*
-   [ 389 Directory Server 1.2.9.0](Releases/1.2.9.0 "wikilink") *(July 25, 2011)*

389 Directory Server 1.2.8.3 - May 24, 2011
-------------------------------------------

389-ds-base version 1.2.8.3 is released to the Stable repositories. This release contains fixes for bugs found in 1.2.8.2 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages. Other 389 packages have been updated as well. See below for the new packages and versions.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.3
-   389-admin 1.1.16
-   idm-console-framework 1.1.7
-   389-ds-console 1.2.5
-   389-admin-console 1.1.7

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.3-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.3-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.3-1.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.3-1.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.2 in 389-ds-base:

-   Bug 700145 - userpasswd not replicating
-   Bug 700557 - Linked attrs callbacks access free'd pointers after close
-   Bug 694336 - Group sync hangs Windows initial Sync
-   Bug 700215 - ldclt core dumps
-   Bug 695779 - windows sync can lose old values when a new value is added
-   Bug 697027 - 12 - minor memory leaks found by Valgrind + TET

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8.2 - April 25, 2011
---------------------------------------------

389-ds-base version 1.2.8.2 is released to the Stable repositories. This release contains a fix for a bug found in 1.2.8.1 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages. Other 389 packages have been updated as well. See below for the new packages and versions.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.2
-   389-admin 1.1.16
-   idm-console-framework 1.1.7
-   389-ds-console 1.2.5
-   389-admin-console 1.1.7

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.1 in 389-ds-base:

-   Bug 696407 - If an entry with a mixed case RDN is turned to be a tombstone, it fails to assemble DN from entryrdn

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8.2 Testing - April 18, 2011
-----------------------------------------------------

389-ds-base version 1.2.8.2 has been released to the Testing repositories. This release contains a fix for a bug found in 1.2.8.1 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.2

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.2-1.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.1 in 389-ds-base:

-   Bug 696407 - If an entry with a mixed case RDN is turned to be a tombstone, it fails to assemble DN from entryrdn

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8.1 Testing - April 11, 2011
-----------------------------------------------------

389-ds-base version 1.2.8.1 has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.1

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.1-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.1-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.1-1.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8.1-1.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8 RC 5 in 389-ds-base:

-   Bug 693962 - Full replica push loses some entries with multi-valued RDNs
-   Bug 693473 - rhds82 rfe - windows\_tot\_run to log Sizelimit exceeded instead of LDAP error - -1
-   Bug 692991 - rhds82 - windows\_tot\_run: failed to obtain data to send to the consumer; LDAP error - -1
-   Bug 693466 - Unable to change schema online
-   Bug 693503 - matching rules do not inherit from superior attribute type
-   Bug 693455 - nsMatchingRule does not work with multiple values
-   Bug 693451 - cannot use localized matching rules
-   Bug 692331 - Segfault on index update during full replication push on 1.2.7.5

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Release Candidate 4 Testing - March 31, 2011
-----------------------------------------------------------------------

389-ds-base version 1.2.8 Release Candidate 4 (1.2.8.rc4) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.rc4
-   389-admin 1.1.16
-   idm-console-framework 1.1.7
-   389-ds-console 1.2.5
-   389-admin-console 1.1.7

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.8.rc4.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.8.rc4.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.8.rc4.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.9.rc4.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.rc2 in 389-ds-base:

-   Bug 668385 - DS pipe log script is executed as many times as the dirsrv service is restarted
-   Bug 690955 - Mrclone fails due to the replica generation id mismatch

Bugs fixed in admin server and console:

-   Bug 476925 - Admin Server: Do not allow 8-bit passwords for the admin user
-   Bug 614690 - Don't use exec to call genrb
-   Bug 158926 - Unable to install CA certificate when using hardware token ( LunaSA )
-   Bug 211296 - Clean up all HTML pages (Admin Express, Repl Monitor, etc)
-   Bug 622436 - Removal of Security:domestic from Console
-   Bug 229699 - objectclass without parent causes StringIndexOutOfBounds in console
-   Bug 583652 - Console caches magic numbers instead of DNA-generated values
-   Bug 616707 - Add attribute matching rule UI to Console
-   Bug 533505 - Warn about CA cert trust when enabling SSL in Console
-   Bug 158262 - Windows Sync UI is inconistent
-   Bug 504803 - Allow nsslapd-\*-logmaxdiskspace to be set to -1 in UI
-   Bug 474113 - Allow access log level to be configured from Console
-   Bug 229693 - Update naming attribute when objectclass is removed

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Release Candidate 2 Testing - March 25, 2011
-----------------------------------------------------------------------

389-ds-base version 1.2.8 Release Candidate 2 (1.2.8.rc2) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.rc2

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.7.rc2.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.7.rc2.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.7.rc2.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.8.rc2.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.rc1 in 389-ds-base:

-   Bug 689537 - (cov\#10610) Fix Coverity NULL pointer dereferences
-   Bug 689866 - ns-newpwpolicy.pl needs to use the new DN format
-   Bug 681015 - RFE: allow fine grained password policy duration attributes in days, hours, minutes, as well
-   Bug 684996 - Exported tombstone cannot be imported correctly
-   Bug 683250 - slapd crashing when traffic replayed
-   Bug 668909 - Can't modify replication agreement in some cases
-   Bug 504803 - Allow maxlogsize to be set if logmaxdiskspace is -1
-   Bug 644784 - Memory leak in "testbind.c" plugin
-   Bug 680558 - Winsync plugin fails to restrain itself to the configured subtree

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Release Candidate 1 Testing - March 3, 2011
----------------------------------------------------------------------

389-ds-base version 1.2.8 Release Candidate 1 (1.2.8.rc1) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8 alpha testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.rc1

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.6.rc1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.6.rc1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.6.rc1.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.6.rc1.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: There is a new sub package **389-ds-base-libs**. This package contains libraries used by 389-ds-base and 389-ds-base-devel. If you use yum to install 389-ds-base, this dependency will automatically be taken care of. To remove the 389-ds-base package from the system, you must also remove the -libs package. If you use **yum erase 389-ds-base-libs** it will also remove 389-ds-base and any other dependent package.

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.a3 in 389-ds-base:

-   Bug 518890 - setup-ds-admin.pl - improve hostname validation
-   Bug 681015 - RFE: allow fine grained password policy duration attributes in days, hours, minutes, as well
-   Bug 514190 - setup-ds-admin.pl --debug does not log to file
-   Bug 680555 - ns-slapd segfaults if I have more than 100 DBs
-   Bug 681345 - setup-ds.pl should set SuiteSpotGroup automatically
-   Bug 674852 - crash in ldap-agent when using OpenLDAP
-   Bug 679978 - modifying attr value crashes the server, which is supposed to be indexed as substring type, but has octetstring syntax
-   Bug 676655 - winsync stops working after server restart
-   Bug 677705 - ds-logpipe.py script is failing to validate "-s" and "--serverpid" options with "-t".
-   Bug 625424 - repl-monitor.pl doesn't work in hub node

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Alpha 3 Testing - February 25, 2011
--------------------------------------------------------------

389-ds-base version 1.2.8 Alpha 3 (1.2.8.a3) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8 alpha testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.a3
-   idm-console-framework 1.1.6
-   389-admin 1.1.15
-   389-ds-console 1.2.4
-   389-admin-console 1.1.6

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base \    
     389-admin idm-console-framework 389-ds-console 389-admin-console    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.3.a3.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.3.a3.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.3.a3.fc14>
-   Fedora 15 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.3.a3.fc15>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is a bug fix release, no new features

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.a2 in 389-ds-base:

-   Bug 675320 - empty modify operation with repl on or lastmod off will crash server
-   Bug 666076 - dirsrv crash (1.2.7.5) with multiple simple paged result searches
-   Bug 672468 - Don't use empty path elements in LD\_LIBRARY\_PATH
-   Bug 671199 - Don't allow other to write to rundir
-   Bug 678646 - Ignore tombstone operations in managed entry plug-in
-   Bug 677774 - DS fails to start after reboot
-   Bug 676053 - export task followed by import task causes cache assertion
-   Bug 677440 - clean up compiler warnings in 389-ds-base 1.2.8
-   Bug 675113 - ns-slapd core dump in windows\_tot\_run if oneway sync is used
-   Bug 676689 - crash while adding a new user to be synced to windows
-   Bug 604881 - admin server log files have incorrect permissions/ownerships
-   Bug 668385 - DS pipe log script is executed as many times as the dirsrv service is restarted
-   Bug 675853 - dirsrv crash segfault in need\_new\_pw()
-   Bug 675265 - preventryusn gets added to entries on a failed delete

Bugs fixed in other packages:

-   Bug 594939 - ACI editing dialog initial size is not big enough to display
-   Bug 151705 - Need to update Console Cipher Preferences with new ciphers
-   fix fourth step of cert wizard for installing cert
-   Bug 668950 - Add posixGroup support to Console
-   Bug 583652 - Console caches magic numbers instead of DNA-generated values
-   Bug 493424 - remove unneeded modules for admin server apache config
-   Bug 618897 - Wrong permissions when creating instance from Console
-   Bug 672468 - Don't use empty path elements in LD\_LIBRARY\_PATH
-   Bug 245278 - Changing to a password with a single quote does not work
-   Bug 604881 - admin server log files have incorrect permissions/ownerships
-   Bug 387981 - plain files can be chosen on the Restore Directory dialog
-   Bug 618858 - move start-ds-admin env file into main admin server config path
-   Bug 616260 - libds-admin-serv linking fails due to unresolved link-time dependencies
-   start-ds-admin.in -- replaced "return 1" with "exit 1"
-   Bug 470576 - Migration could do addition checks before commiting actions
-   Bug 450016 - RFE- Console display values in KB/MB/GB
-   Bug 661116 - 389-console Configuration tab admin permissions (nsslapd-referral ?) and folder not expending immediatly
-   Bug 553066 - Directory Console: do not display "subtree" index type
-   Bug 599732 - Root node in directory browser shows DN syntax error

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Alpha 2 Testing - February 8, 2011
-------------------------------------------------------------

389-ds-base version 1.2.8 Alpha 2 (1.2.8.a2) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7 and 1.2.8.a1 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.a2

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.2.a2.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.2.a2.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.2.a2.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is primarily a bug fix release, but there are some minor new features of interest to plugin authors

-   389-ds-base-devel subpackage enhanced for use by plugin writers
-   BIND operation plugins now work for SASL binds

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

Bugs fixed since 1.2.8.a1

-   Bug 675265 - preventryusn gets added to entries on a failed delete
-   Bug 674430 - Improve error messages for attribute uniqueness
-   Bug 616213 - insufficient stack size for HP-UX on PA-RISC
-   Bug 615052 - intrinsics and 64-bit atomics code fails to compile on PA-RISC
-   Bug 151705 - Need to update Console Cipher Preferences with new ciphers
-   Bug 668862 - init scripts return wrong error code
-   Bug 670616 - Allow SSF to be set for local (ldapi) connections
-   Bug 667935 - DS pipe log script's logregex.py plugin is not redirecting the log output to the text file
-   Bug 668619 - slapd stops responding
-   Bug 624547 - attrcrypt should query the given slot/token for supported ciphers
-   Bug 646381 - Faulty password for nsmultiplexorcredentials does not give any error message in logs

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.8 Alpha 1 Testing - January 25, 2011
-------------------------------------------------------------

389-ds-base version 1.2.8 Alpha 1 (1.2.8.a1) has been released to the Testing repositories. This release contains many fixes for bugs found in 1.2.7. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6 or 1.2.7, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.8.a1

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.1.a1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.1.a1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.8-0.1.a1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 13 are no longer supported. If you are running Fedora 12 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

This is primarily a bug fix release, but there are some minor new features of interest to plugin authors

-   389-ds-base-devel subpackage enhanced for use by plugin writers
-   BIND operation plugins now work for SASL binds

### Bugs Fixed

**NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.8](https://bugzilla.redhat.com/showdependencytree.cgi?id=656390&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.7.5 - December 17, 2010
------------------------------------------------

389-ds-base version 1.2.7.5 fixes some key bugs found in 1.2.7.2, .3, and .4 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.7.5

### Installation

    yum install 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade 389-ds-base    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.5-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.5-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.5-1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features (in 1.2.7, not 1.2.7.5)

-   [Use OpenLDAP instead of Mozilla LDAP](../howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
-   [Account\_Policy\_Design](../design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move\_changelog](../howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf\_Multiple\_Grouping\_Enhancements](../design/memberof-multiple-grouping-enhancements.htmlhtml) - Member Of supports multiple membership attributes
-   SELinux policy has been removed from 389-ds-base and 389-admin on Fedora - policy now supplied by base OS - does not apply to EL where we still have separate policy modules

### Bugs Fixed

The following bugs were fixed since 1.2.7.2:

-   Bug 663597 - Memory leaks in normalization code
-   Bug 661792 - Valid managed entry config rejected
-   Bug 658312 - Invalid free in Managed Entry plug-in
-   Bug 641944 - Don't normalize non-DN RDN values

For 1.2.7, we ran Coverity against the 389-ds-base code, found hundreds of issues (most of which were not serious and not security issues) and fixed them. The code is now Coverity clean. This release also contains fixes for some of the upgrade problems reported by the community, as well as many other bug fixes. **NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.7 - 1.2.7.5](https://bugzilla.redhat.com/showdependencytree.cgi?id=576869&hide_resolved=1)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.7.2 Testing - December 6, 2010
-------------------------------------------------------

389-ds-base version 1.2.7.2 has been released to the Testing repositories. This release fixes some key bugs found in 1.2.7 and 1.2.7.1 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.7.2
-   389-admin 1.1.13

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base 389-admin 389-adminutil 389-dsgw perl-Mozilla-LDAP    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 13, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 13 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.2-1.el5>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.2-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.2-1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features (in 1.2.7, not 1.2.7.2)

-   [Use OpenLDAP instead of Mozilla LDAP](../howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
-   [Account\_Policy\_Design](../design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move\_changelog](../howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf\_Multiple\_Grouping\_Enhancements](../design/memberof-multiple-grouping-enhancements.htmlhtml) - Member Of supports multiple membership attributes
-   SELinux policy has been removed from 389-ds-base and 389-admin on Fedora - policy now supplied by base OS - does not apply to EL where we still have separate policy modules

### Bugs Fixed

The following bugs from 1.2.7, 1.2.7.1 and 1.1.12 were fixed in 1.2.7.2:

-   Bug 659456 - Incorrect usage of ber\_printf() in winsync code
-   Bug 658309 - Process escaped characters in managed entry mappings
-   Bug 197886 - Initialize return value for UUID generation code
-   Bug 658312 - Allow mapped attribute types to be quoted
-   Bug 197886 - Avoid overflow of UUID generator

For 1.2.7, we ran Coverity against the 389-ds-base code, found hundreds of issues (most of which were not serious and not security issues) and fixed them. The code is now Coverity clean. This release also contains fixes for some of the upgrade problems reported by the community, as well as many other bug fixes. **NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.7, 1.2.7.1, 1.2.7.2](https://bugzilla.redhat.com/showdependencytree.cgi?id=576869&hide_resolved=1)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.7.1 Testing - November 29, 2010
--------------------------------------------------------

389-ds-base version 1.2.7.1 has been released to the Testing repositories. This release fixes some key bugs found in 1.2.7 testing. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.7.1
-   389-admin 1.1.13

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base 389-admin 389-adminutil 389-dsgw perl-Mozilla-LDAP    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.1-1.el5>
-   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.1-1.fc12>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.1-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7.1-1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features (in 1.2.7, not 1.2.7.1)

-   [Use OpenLDAP instead of Mozilla LDAP](../howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
-   [Account\_Policy\_Design](../design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move\_changelog](../howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf\_Multiple\_Grouping\_Enhancements](../design/memberof-multiple-grouping-enhancements.htmlhtml) - Member Of supports multiple membership attributes
-   SELinux policy has been removed from 389-ds-base and 389-admin on Fedora - policy now supplied by base OS - does not apply to EL where we still have separate policy modules

### Bugs Fixed

The following bugs from 1.2.7 and 1.1.12 were fixed in 1.2.7.1 and 1.1.13:

-   Bug 656515 - Allow Name and Optional UID syntax for grouping attributes
-   Bug 656392 - Remove calls to ber\_err\_print()
-   Bug 625950 - hash nsslapd-rootpw changes in audit log
-   Bug 656441 - Missing library path entry causes LD\_PRELOAD error
-   setup-ds-admin.pl -u exits with ServerAdminID and as\_uid related error

For 1.2.7, we ran Coverity against the 389-ds-base code, found hundreds of issues (most of which were not serious and not security issues) and fixed them. The code is now Coverity clean. This release also contains fixes for some of the upgrade problems reported by the community, as well as many other bug fixes. **NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.7 and 1.2.7.1](https://bugzilla.redhat.com/showdependencytree.cgi?id=576869&hide_resolved=1)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.7 Testing - November 22, 2010
------------------------------------------------------

389-ds-base version 1.2.7 has been released to the Testing repositories. This release has some new features and many bug fixes. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK. We have removed the SELinux policy from the 389-ds-base and 389-admin packages on Fedora. The policy will be provided by the SELinux policy in the base OS. On EL, the policy will continue to be provided by the 389 packages.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.7
-   389-admin 1.1.12
-   389-adminutil 1.1.13
-   389-dsgw 1.1.6
-   perl-Mozilla-LDAP 1.5.3 (Fedora 14 and later)

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base 389-admin 389-adminutil 389-dsgw perl-Mozilla-LDAP    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-1.el5>
-   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-1.fc12>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-1.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

-   [Use OpenLDAP instead of Mozilla LDAP](../howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
-   [Account\_Policy\_Design](../design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move\_changelog](../howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf\_Multiple\_Grouping\_Enhancements](../design/memberof-multiple-grouping-enhancements.htmlhtml) - Member Of supports multiple membership attributes
-   SELinux policy has been removed from 389-ds-base and 389-admin on Fedora - policy now supplied by base OS - does not apply to EL where we still have separate policy modules

### Bugs Fixed

We ran Coverity against the 389-ds-base code, found hundreds of issues (most of which were not serious and not security issues) and fixed them. The code is now Coverity clean. This release also contains fixes for some of the upgrade problems reported by the community, as well as many other bug fixes. **NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.7](https://bugzilla.redhat.com/showdependencytree.cgi?id=576869&hide_resolved=1)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.7.a3 (Alpha 3) Testing - October 29, 2010
------------------------------------------------------------------

389-ds-base version 1.2.7 Alpha 3 has been released to the Testing repositories. This release has some new features and many bug fixes. On those platforms which have OpenLDAP built with Mozilla NSS crypto support (Fedora 14 and later), the packages are built with OpenLDAP instead of the Mozilla LDAP C SDK.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, or a stable 1.2.6, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.7.a3
-   389-admin 1.1.12.a2
-   389-adminutil 1.1.13
-   389-dsgw 1.1.6
-   perl-Mozilla-LDAP 1.5.3 (Fedora 14 and later)

### Installation

    yum install --enablerepo=[updates-testing|epel-testing] 389-ds    
    setup-ds-admin.pl    

### Upgrade

    yum upgrade --enablerepo=[updates-testing|epel-testing] 389-ds-base 389-admin 389-adminutil 389-dsgw perl-Mozilla-LDAP    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-0.4.a3.el5>
-   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-0.6.a3.fc12>
-   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-0.6.a3.fc13>
-   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.7-0.4.a3.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

-   [Use OpenLDAP instead of Mozilla LDAP](../howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
-   [Account\_Policy\_Design](../design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move\_changelog](../howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf\_Multiple\_Grouping\_Enhancements](../design/memberof-multiple-grouping-enhancements.htmlhtml) - Member Of supports multiple membership attributes

### Bugs Fixed

We ran Coverity against the 389-ds-base code, found hundreds of issues (most of which were not serious and not security issues) and fixed them. The code is now Coverity clean. This release also contains fixes for some of the upgrade problems reported by the community, as well as many other bug fixes. **NOTE**: bugs marked **MODIFIED** have been fixed but not fully tested and verified.

-   [Bug List for 389 1.2.7](https://bugzilla.redhat.com/showdependencytree.cgi?id=576869&hide_resolved=1)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.1 - October 15, 2010
-----------------------------------------------

The 389-ds-base 1.2.6.1 release is a bug fix release to fix a couple of crash problems and a couple of other problems.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.6.1 (1.2.6.1-3 for rawhide, 1.2.6.1-2 for other platforms - do not use 1.2.6.1-1)

Installation

    yum install 389-ds    
    setup-ds-admin.pl    

Upgrade

    yum upgrade 389-ds-base    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   389-ds-base-1.2.6.1
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6.1-2.el5>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6.1-2.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6.1-2.fc13>
    -   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6.1-2.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](../design/subtree-rename.html#warning).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

There are no new features in this release. This is a bug fix release only.

### Bugs Fixed

This release contains some important bug fixes. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Bug 635987 - Incorrect sub scope search result with ACL containing <ldap:///self>
-   Bug 612264 - ACI issue with (targetattr='userPassword')
-   Bug 606920 - anonymous resource limit- nstimelimit - also applied to "cn=directory manager"
-   Bug 631862 - crash - delete entries not in cache + referint
-   Bug 634561 - Server crushes when using Windows Sync Agreement

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6 - September 13, 2010
-----------------------------------------------

The 389-ds-base 1.2.6 release is essentially the same as the 1.2.6.rc7 release. The 389-admin-1.1.11 release is essentially the same as the 1.1.11.rc2 release. 1.2.6 contains several new features and many bug fixes.

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

If you are upgrading from 1.2.5 or earlier, there is no problem.

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, there is no problem.

The new packages and versions are:

-   389-ds-base 1.2.6
-   389-admin 1.1.11
-   389-adminutil 1.1.10
-   idm-console-framework 1.1.5
-   389-console 1.1.4
-   389-ds-console 1.2.3
-   389-dsgw 1.1.5
-   389-ds 1.2.1

Installation

    yum install 389-ds    
    setup-ds-admin.pl    

Upgrade

    yum upgrade    
    setup-ds-admin.pl -u    

See [Download](../download.html) for more information about setting up yum access. See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   389-ds-base-1.2.6
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-1.el5>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-1.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-1.fc13>
    -   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-1.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

**WARNING**: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

### New features

-   [Upgrade\_to\_New\_DN\_Format](    ../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains many, many bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.rc7 (Release Candidate 7) - August 10, 2010
----------------------------------------------------------------------

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, there is no problem.

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 7 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.rc7 - 389-ds-base

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds-base    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds-base    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   389-ds-base-1.2.6.rc7
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.11.rc7.el5>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.11.rc7.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.11.rc7.fc13>
    -   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.11.rc7.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

NOTE: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

### New features

-   [Upgrade\_to\_New\_DN\_Format](    ../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains one bug fix. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
    -   Bug 621928 - Unable to enable replica (rdn problem?) on 1.2.6 rc6

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.rc6 (Release Candidate 6) - August 5, 2010
---------------------------------------------------------------------

**WARNING**: If you are upgrading from a previous 1.2.6 release candidate, you will need to run fixfiles to fix some SELinux AVCs, or directory server will not start. See bug <https://bugzilla.redhat.com/show_bug.cgi?id=622882>

To fix, run this:

    fixfiles -R 389-ds-base restore    

**WARNING**: If you are upgrading from a 1.2.6 alpha or release candidate, you will need to manually fix your entryrdn index files. See [Subtree Rename Warning](../design/subtree-rename.html#warning) for more information. If you are upgrading from 1.2.5 or earlier, there is no problem.

Note: RC4 and RC5 were never released.

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 6 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.rc6 - 389-ds-base
-   389-admin-1.1.11.rc2 - 389-admin

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds-base 389-admin    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 and provide feedback.

-   389-ds-base-1.2.6.rc6
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.9.rc6.el5>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.9.rc6.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.9.rc6.fc13>
    -   Fedora 14 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.10.rc6.fc14>
-   389-admin-1.1.11.rc2
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.6.rc2.el5>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.6.rc2.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.6.rc2.fc13>
    -   Fedora 14 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.7.rc2.fc14>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 12 are no longer supported. If you are running Fedora 11 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

NOTE: If you are upgrading from **389 1.2.6 rcN (N \< 6)**, simple upgrade won't work due to the entryrdn format change (See also [Bug 616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments ). Please follow the steps described in [this section](http://directory.fedoraproject.org/wiki/Subtree_Rename#warning:_upgrade_from_389_v1.2.6_.28a.3F.2C_rc1_.7E_rc6.29_to_v1.2.6_rc6_or_newer).

### New features

-   [Upgrade\_to\_New\_DN\_Format](    ../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains several bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
    -   Bug 617013 - repl-monitor.pl use cpu upto 90%
    -   Bug 616618 - 389 v1.2.5 accepts 2 identical entries with different DN format
    -   Bug 547503 - replication broken again, with 389 MMR replication and TCP errors
    -   Bug 613833 - Allow dirsrv\_t to bind to rpc ports
    -   Bug 612242 - membership change on DS does not show on AD
    -   Bug 617629 - Missing aliases in new schema files
    -   Bug 619595 - Upgrading sub suffix under non-normalized suffix disappears
    -   Bug 616608 - SIGBUS in RDN index reads on platforms with strict alignments
    -   Bug 617862 - Replication: Unable to delete tombstone errors
    -   Bug 594745 - Get rid of dirsrv\_lib\_t label

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.rc3 (Release Candidate 3) - July 6, 2010
-------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 3 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.rc3 - 389-ds-base

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds-base    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds-base    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.8.rc3.fc12, 389-admin-1.1.11-0.4.rc1.fc12 and provide feedback.

-   389-ds-base-1.2.6.rc3
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.8.rc3.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.8.rc3.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.8.rc3.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.8.rc3.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   [Upgrade\_to\_New\_DN\_Format](    ../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains a few bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
    -   Bug 606920 - anonymous resource limit - nstimelimit - also applied to "cn=directory manager"
    -   Bug 604453 - SASL Stress and Server crash: Program quits with the assertion failure in PR\_Poll
    -   Bug 605827 - In-place upgrade: upgrade dn format should not run in setup-ds-admin.pl
    -   Bug 578296 - Attribute type entrydn needs to be added when subtree rename switch is on
    -   Bug 609256 - Selinux: pwdhash fails if called via Admin Server CGI
    -   Bug 603942 - null deref in \_ger\_parse\_control() for subjectdn

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.rc2 (Release Candidate 2) - June 23, 2010
--------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 2 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.rc2 - 389-ds-base

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds-base    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds-base    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.7.rc2.fc12, 389-admin-1.1.11-0.4.rc1.fc12 and provide feedback.

-   389-ds-base-1.2.6.rc2
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.7.rc2.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.7.rc2.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.7.rc2.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.7.rc2.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   [Upgrade\_to\_New\_DN\_Format](../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
-   Bug 604263 - Fix memory leak when password change is rejected

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.rc1 (Release Candidate 1) - June 16, 2010
--------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 1 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.rc1 - 389-ds-base
-   389-admin-1.1.11.rc1 - 389-admin

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds-base 389-admin    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.4.rc1.fc12, 389-admin-1.1.11-0.4.rc1.fc12 and provide feedback.

-   389-ds-base-1.2.6.rc1
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.6.rc1.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.6.rc1.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.6.rc1.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.6.rc1.fc13>
-   389-admin-1.1.11.rc1
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.5.rc1.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.5.rc1.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.5.rc1.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.5.rc1.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   [Upgrade\_to\_New\_DN\_Format](../howto/howto-use-named-pipe-log-script.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
    -   Bug 597375 - Deleting LDBM database causes backup/restore problem
    -   Bug 601433 - Add man pages for start-dirsrv and related commands
    -   Bug 574101 - MODRDN request never returns - possible deadlock

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.a4 (Alpha 4) - June 2, 2010
------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Alpha 3 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.a4 - 389-ds-base
-   389-admin-1.1.11.a4 - 389-admin

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo - on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds 389-ds-base 389-admin    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds 389-ds-base 389-admin    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.4.a4.fc12, 389-admin-1.1.11-0.4.a4.fc12 and provide feedback.

-   389-ds-base-1.2.6.a4
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.4.a4.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.4.a4.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.4.a4.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.4.a4.fc13>
-   389-admin-1.1.11.a4
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.4.a4.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.4.a4.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.4.a4.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.4.a4.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   [Upgrade\_to\_New\_DN\_Format](../howto/howto-upgrade-to-new-dn-format.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication\_Session\_Hooks](../design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains many bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.a3 (Alpha 3) - April 19, 2010
--------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Alpha 3 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.a3 - 389-ds-base
-   389-admin-1.1.11.a3 - 389-admin
-   389-ds-1.2.1 - 389-ds
-   idm-console-framework-1.1.4 - idm-console-framework
-   389-console-1.1.4 - 389-console
-   389-ds-console-1.1.4 - 389-ds-console

Previous versions had a separate -selinux package for 389-ds-base and 389-admin - these are now gone - the selinux policy for the package is now provided by the package itself. Upgrading from a previous version should obsolete these packages.

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds 389-ds-base 389-admin idm-console-framework 389-console 389-ds-console    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds 389-ds-base 389-admin idm-console-framework 389-console 389-ds-console    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.3.a3.fc12, 389-admin-1.1.11-0.3.a3.fc12 and provide feedback.

-   389-ds-base-1.2.6.a3
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.3.a3.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.3.a3.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.3.a3.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.3.a3.fc13>
-   389-admin-1.1.11.a3
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.3.a3.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.3.a3.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.3.a3.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.3.a3.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   [Managed Entries](../design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains many bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.6.a2 (Alpha 2) - March 4, 2010
-------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Alpha 2 for the 1.2.6 release. The new packages available for testing are:

-   389-ds-base-1.2.6.a2 - 389-ds-base and 389-ds-base-selinux
-   389-admin-1.1.11.a2 - 389-admin and 389-admin-selinux
-   389-adminutil-1.1.10 - 389-adminutil
-   389-ds-1.2.0 - 389-ds

Instructions for installing these from the testing repositories - different for Fedora and EPEL - difference is name of testing repo on Fedora is **updates-testing** and for EPEL is **epel-testing**

-   Fedora new install

    yum install --enablerepo=updates-testing 389-ds    

-   Fedora upgrade

    yum upgrade --enablerepo=updates-testing 389-ds 389-ds-base 389-ds-base-selinux 389-admin 389-admin-selinux 389-adminutil    

-   EPEL new install

    yum install --enablerepo=epel-testing 389-ds    

-   EPEL upgrade

    yum upgrade --enablerepo=epel-testing 389-ds 389-ds-base 389-ds-base-selinux 389-admin 389-admin-selinux 389-adminutil    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. Each update is broken down by package and platform. For example, if you are using Fedora 12, and you have successfully installed or upgraded all of the packages, and the console and etc. works, then go to the links below for Fedora 12 for 389-ds-base-1.2.6-0.2.a2.fc12, 389-admin-1.1.11-0.2.a2.fc12, and 389-adminutil-1.1.10.fc12 and provide feedback.

-   389-ds-base-1.2.6.a2
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.2.a2.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.2.a2.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.2.a2.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-ds-base-1.2.6-0.2.a2.fc13>
-   389-admin-1.1.11.a2
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.2.a2.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.2.a2.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.2.a2.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-admin-1.1.11-0.2.a2.fc13>
-   389-adminutil-1.1.10
    -   EL-5 - <https://admin.fedoraproject.org/updates/389-adminutil-1.1.10.el5>
    -   Fedora 11 - <https://admin.fedoraproject.org/updates/389-adminutil-1.1.10.fc11>
    -   Fedora 12 - <https://admin.fedoraproject.org/updates/389-adminutil-1.1.10.fc12>
    -   Fedora 13 - <https://admin.fedoraproject.org/updates/389-adminutil-1.1.10.fc13>

scroll down to the bottom of the page, and click on the Add a comment \>\> link

-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@lists.fedoraproject.org

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: Now using EPEL for Enterprise Linux packages. See [Download](../download.html) for more information.

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 11 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](../FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Bugs Fixed

This release contains many bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.6 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=543590&hide_resolved=0)
    -   [171338](https://bugzilla.redhat.com/show_bug.cgi?id=171338) Enhancement: winsync modrdn not synced
    -   [434735](https://bugzilla.redhat.com/show_bug.cgi?id=434735) SASL ANONYMOUS is broken in x86\_64
    -   [460162](https://bugzilla.redhat.com/show_bug.cgi?id=460162) FedoraDS "with-FHS" installs init.d StartupScript in wrong location on non-RHEL/Fedora OS
    -   [460168](https://bugzilla.redhat.com/show_bug.cgi?id=460168) FedoraDS' adminutil requires non-existent "icu.pc" on non-RH/Fedora OS
    -   [460209](https://bugzilla.redhat.com/show_bug.cgi?id=460209) adminserver "./configure --help" error @ --with-apr-config
    -   [498103](https://bugzilla.redhat.com/show_bug.cgi?id=498103) [RFE] SELinux policy for the Directory Server
    -   [506206](https://bugzilla.redhat.com/show_bug.cgi?id=506206) problems linking with -z defs
    -   [509201](https://bugzilla.redhat.com/show_bug.cgi?id=509201) rhds81 hub with 71 master - err=32 on replica base search during replication
    -   [516611](https://bugzilla.redhat.com/show_bug.cgi?id=516611) 389 DS segfaults on libsyntax-plugin.so
    -   [518084](https://bugzilla.redhat.com/show_bug.cgi?id=518084) Out of order retro change log records
    -   [519459](https://bugzilla.redhat.com/show_bug.cgi?id=519459) Semi-hardcoded include and lib directories in db.m4
    -   [531929](https://bugzilla.redhat.com/show_bug.cgi?id=531929) rhds8.1 seg fault on null bvals in syntax plug-in
    -   [536703](https://bugzilla.redhat.com/show_bug.cgi?id=536703) Red Hat Direct Directory Migration 7.1 -\> 8.1 problems
    -   [537466](https://bugzilla.redhat.com/show_bug.cgi?id=537466) nsslapd-distribution-plugin should not require plugin name to begin with "lib"
    -   [543080](https://bugzilla.redhat.com/show_bug.cgi?id=543080) Bitwise plugin fails to return the exact matched entries for Bitwise search filter
    -   [544089](https://bugzilla.redhat.com/show_bug.cgi?id=544089) Referential Integrity Plugin does not take into account the attribute subtypes
    -   [548115](https://bugzilla.redhat.com/show_bug.cgi?id=548115) memory leak in schema reload
    -   [548535](https://bugzilla.redhat.com/show_bug.cgi?id=548535) memory leak in attrcrypt
    -   [552419](https://bugzilla.redhat.com/show_bug.cgi?id=552419) 389-admin-1.1.10-0.2.a2.el5 fails to start
    -   [552421](https://bugzilla.redhat.com/show_bug.cgi?id=552421) Cannot log into admin server after upgrade (fedora-ds-admin-1.1.6 -\> 389-admin-1.1.9
    -   [553027](https://bugzilla.redhat.com/show_bug.cgi?id=553027) Support for nsUniqueId and alias for additional retro changelog attributes
    -   [554841](https://bugzilla.redhat.com/show_bug.cgi?id=554841) Unitialized mutex in Retro Changelog Plugin.
    -   [554887](https://bugzilla.redhat.com/show_bug.cgi?id=554887) Net::LDAP password modify extop breaks; msgid in response is 0xFF
    -   [555970](https://bugzilla.redhat.com/show_bug.cgi?id=555970) seg fault maybe on cos or nsview changes and replication?
    -   [558518](https://bugzilla.redhat.com/show_bug.cgi?id=558518) several spelling errors
    -   [559315](https://bugzilla.redhat.com/show_bug.cgi?id=559315) Searching some attributes are now case sensitive when they were previously case-insensitive
    -   [560827](https://bugzilla.redhat.com/show_bug.cgi?id=560827) Admin Server: DistinguishName validation fails
    -   [564876](https://bugzilla.redhat.com/show_bug.cgi?id=564876) FTBFS 389-ds-base-1.2.6-0.1.a1.fc13: ImplicitDSOLinking
    -   [568196](https://bugzilla.redhat.com/show_bug.cgi?id=568196) Install DS8.2 on Solaris fails

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.5 - January 13, 2010
---------------------------------------------

Version 1.2.5 contains one new feature as well as several bug fixes. This release is essentially the same as 1.2.5 RC4.

### Notes

NOTE: Packages for Enterprise Linux are available from Fedora EPEL. We will no longer have a separate yum repo hosted on this site.

-   How to use - <https://fedoraproject.org/wiki/EPEL/FAQ#howtouse>
-   More information about Fedora EPEL - <https://fedoraproject.org/wiki/EPEL>

NOTE: Fedora versions below 11 are no longer supported. If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. Fedora has Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   Named Pipe Log Script - this script allows you to replace the access/errors/audit log file with a named pipe attached to a script - this allows you to do things like
    -   enable full debug error log level in production environments without suffering too much performance degradation
    -   log only certain events e.g. failed bind attempts only, or only messages that contain a specified pattern
    -   send data to a remote server, send email, anything that can be scripted
    -   [Named\_Pipe\_Log\_Script](../howto/howto-use-named-pipe-log-script.html)

### Bugs Fixed

-   Tracking bug for 1.2.5 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0)
-   [537956](https://bugzilla.redhat.com/show_bug.cgi?id=537956) Password replication from 389DS to AD2008(64bit) fails, all other replication continues
-   [548537](https://bugzilla.redhat.com/show_bug.cgi?id=548537) Fix memory leaks in DNA plugin
-   [518084](https://bugzilla.redhat.com/show_bug.cgi?id=518084) Fix out of order retro changelog entries
-   [497556](https://bugzilla.redhat.com/show_bug.cgi?id=497556) LDAPI connections cause TCP performance degradation
-   [195302](https://bugzilla.redhat.com/show_bug.cgi?id=195302) local pwp can't set storage scheme
-   [387681](https://bugzilla.redhat.com/show_bug.cgi?id=387681) "windows\_process\_dirsync\_entry: failed to map tombstone dn." with , in DisplayName
-   [486171](https://bugzilla.redhat.com/show_bug.cgi?id=486171) [RFE] Access log - Failed binds
-   [497199](https://bugzilla.redhat.com/show_bug.cgi?id=497199) 'failed to send dirsync search request 2' error
-   [504817](https://bugzilla.redhat.com/show_bug.cgi?id=504817) Double quoted distinguished names not working in fedora-ds 1.2.0
-   [515329](https://bugzilla.redhat.com/show_bug.cgi?id=515329) Multiple mods in one operation can result in an inconsistent replica
-   [540559](https://bugzilla.redhat.com/show_bug.cgi?id=540559) selinux policy needs to allow log pipe

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.5.rc4 (Release Candidate) - January 6, 2010
--------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 4 for the 1.2.5 release. The new packages available for testing are:

-   389-ds-base-1.2.5.rc4

NOTE: Packages for Enterprise Linux are available from EPEL. We will no longer have a separate yum repo hosted on this site.

-   How to use - <https://fedoraproject.org/wiki/EPEL/FAQ#howtouse>
-   More information about EPEL - <https://fedoraproject.org/wiki/EPEL>

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base # Fedora upgrade    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. If you have an account, go here:

-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.5.rc4.el5>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.5.rc4.fc11>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.5.rc4.fc12>
-   scroll down to the bottom of the page, and click on the Add a comment \>\> link
-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@redhat.com.

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: FC6 (EL5) package updates **are no longer available**. Get them from EPEL instead.

NOTE: Fedora versions below 11 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

None - this is primarily to fix bugs found in 1.2.5.rc3

### Bugs Fixed

This release contains one bug fix. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.5 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0)
-   [537956](https://bugzilla.redhat.com/show_bug.cgi?id=537956) Password replication from 389DS to AD2008(64bit) fails, all other replication continues

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.5.rc3 (Release Candidate) - December 18, 2009
----------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 3 for the 1.2.5 release. The new packages available for testing are:

-   389-ds-base-1.2.5.rc3
-   389-admin-1.1.10.a2

NOTE: Packages for Enterprise Linux are available from EPEL. We will no longer have a separate yum repo hosted on this site.

-   How to use - <https://fedoraproject.org/wiki/EPEL/FAQ#howtouse>
-   More information about EPEL - <https://fedoraproject.org/wiki/EPEL>

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin 389-console # Fedora upgrade    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. If you have an account, go here:

-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.4.rc3.el5>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.4.rc3.fc11>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.4.rc3.fc12>
-   scroll down to the bottom of the page, and click on the Add a comment \>\> link
-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@redhat.com.

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: FC6 (EL5) package updates **are no longer available**. Get them from EPEL instead.

NOTE: Fedora versions below 11 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 10 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

None - this is primarily to fix bugs found in 1.2.5.rc2

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.5 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0)
-   [548537](https://bugzilla.redhat.com/show_bug.cgi?id=548537) Fix memory leaks in DNA plugin
-   [518084](https://bugzilla.redhat.com/show_bug.cgi?id=518084) Fix out of order retro changelog entries
-   [497556](https://bugzilla.redhat.com/show_bug.cgi?id=497556) LDAPI connections cause TCP performance degradation

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.5.rc2 (Release Candidate) - December 8, 2009
---------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 2 for the 1.2.5 release. The new package available for testing is:

-   389-ds-base-1.2.5.rc2

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin 389-console # Fedora upgrade    

or EL5

    yum install --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds # new install    
    yum upgrade --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds-base # upgrade    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. If you have an account, go here:

-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.3.rc2.fc10>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.3.rc2.fc11>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.3.rc2.fc12>
-   scroll down to the bottom of the page, and click on the Add a comment \>\> link
-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@redhat.com.

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: If using the FC6 (EL5) packages, **you must update your yum repo files** - the URLs have changed. See [Download](../download.html) for more information.

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

None - this is primarily to fix bugs found in 1.2.5.rc1

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.5 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0)
-   [195302](https://bugzilla.redhat.com/show_bug.cgi?id=195302) local pwp can't set storage scheme
-   [387681](https://bugzilla.redhat.com/show_bug.cgi?id=387681) "windows\_process\_dirsync\_entry: failed to map tombstone dn." with , in DisplayName
-   [486171](https://bugzilla.redhat.com/show_bug.cgi?id=486171) [RFE] Access log - Failed binds
-   [497199](https://bugzilla.redhat.com/show_bug.cgi?id=497199) 'failed to send dirsync search request 2' error
-   [504817](https://bugzilla.redhat.com/show_bug.cgi?id=504817) [Double quoted distinguished names not working in fedora-ds 1.2.0
-   [515329](https://bugzilla.redhat.com/show_bug.cgi?id=515329) Multiple mods in one operation can result in an inconsistent replica
-   [540559](https://bugzilla.redhat.com/show_bug.cgi?id=540559) selinux policy needs to allow log pipe [See dependency tree for bug 540559]

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.5.rc1 (Release Candidate) - December 2, 2009
---------------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories. This is Release Candidate 1 for the 1.2.5 release. The new package available for testing is:

-   389-ds-base-1.2.5.rc1

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin 389-console # Fedora upgrade    

or EL5

    yum install --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds # new install    
    yum upgrade --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds-base # upgrade    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. If you have an account, go here:

-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.2.rc1.fc10>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.2.rc1.fc11>
-   <https://admin.fedoraproject.org/updates/389-ds-base-1.2.5-0.2.rc1.fc12>
-   scroll down to the bottom of the page, and click on the Add a comment \>\> link
-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@redhat.com.

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: If using the FC6 (EL5) packages, **you must update your yum repo files** - the URLs have changed. See [Download](../download.html) for more information.

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   Named Pipe Log Script - this script allows you to replace the access/errors/audit log file with a named pipe attached to a script - this allows you to do things like
    -   enable full debug error log level in production environments without suffering too much performance degradation
    -   log only certain events e.g. failed bind attempts only, or only messages that contain a specified pattern
    -   send data to a remote server, send email, anything that can be scripted
    -   [Named\_Pipe\_Log\_Script](../howto/howto-use-named-pipe-log-script.html)

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.5 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=533025&hide_resolved=0)
-   [195302](https://bugzilla.redhat.com/show_bug.cgi?id=195302) local pwp can't set storage scheme
-   [387681](https://bugzilla.redhat.com/show_bug.cgi?id=387681) "windows\_process\_dirsync\_entry: failed to map tombstone dn." with , in DisplayName
-   [486171](https://bugzilla.redhat.com/show_bug.cgi?id=486171) [RFE] Access log - Failed binds
-   [497199](https://bugzilla.redhat.com/show_bug.cgi?id=497199) 'failed to send dirsync search request 2' error
-   [504817](https://bugzilla.redhat.com/show_bug.cgi?id=504817) [Double quoted distinguished names not working in fedora-ds 1.2.0
-   [515329](https://bugzilla.redhat.com/show_bug.cgi?id=515329) Multiple mods in one operation can result in an inconsistent replica
-   [540559](https://bugzilla.redhat.com/show_bug.cgi?id=540559) selinux policy needs to allow log pipe [See dependency tree for bug 540559]

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Windows Console 1.1.4.a1 - November 16, 2009
------------------------------------------------

This is the alpha 1 (.a1) release. See [Release\_Procedure](../development/release-procedure.html) for information about release numbering. This release supports Windows Server 2008 in addition to 2003. 2000 is no longer supported (although it may work, we don't test it). We also have 64-bit packages in addition to the 32-bit packages.

This release uses the **389** branding. The program files folder will be named 389 Management Console.

-   Download - [Download](../download.html)
-   [Howto:WindowsConsole](../howto/howto-windowsconsole.html)

389 Windows Password Synchronization 1.1.3 - November 16, 2009
--------------------------------------------------------------

This release supports Windows Server 2008 in addition to 2003. 2000 is no longer supported (although it may work, we don't test it). We also have 64-bit packages in addition to the 32-bit packages.

This release uses the **389** branding. The program files folder will be named 389 Password Sync. If you are upgrading from Fedora PassSync, the upgrade will attempt to copy your db and log files from the Fedora folder to the new 389 folder. It will not remove the old Fedora folder. You can remove that manually after you have verified that the 389 PassSync is working correctly.

-   Download - [Download](../download.html)
-   [Howto:WindowsSync](../howto/howto-windowssync.html)

389 Directory Server 1.2.4 (testing release) - November 4, 2009
---------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories, not the official release repositories yet. We are seeking feedback. The new package available for testing is:

-   389-ds-base-1.2.4

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin 389-console # Fedora upgrade    

or EL5

    yum install --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds # new install    
    yum upgrade --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds-base # upgrade    

See [Download](../download.html) for more information about setting up yum access.

### Your Feedback is Important!

The best way to provide feedback is via the Fedora Update system. If you have an account, go here:

-   <https://admin.fedoraproject.org/updates/F10/FEDORA-2009-11023>
-   OR
-   <https://admin.fedoraproject.org/updates/F11/FEDORA-2009-10901>
-   scroll down to the bottom of the page, and click on the Add a comment \>\> link
-   select one of the Works for me or Does not work radio buttons, add text, and click on the Add Comment button

If you are using a build on another platform, just send us an email to 389-users@redhat.com.

If you find a bug, or would like to see a new feature, you can enter it here - <https://bugzilla.redhat.com/enter_bug.cgi?product=389>

### Notes

NOTE: If using the FC6 (EL5) packages, **you must update your yum repo files** - the URLs have changed. See [Download](../download.html) for more information.

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixed some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. For more information, see the 1.2.3 release notes below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   Support for Salted MD5 (SMD5) hashes. These are supported for migration purposes only. You should not use SMD5 for new passwords - use SSHA256

### Bugs Fixed

This release contains a couple of bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.4 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=531879&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=531879&hide_resolved=0)
    -   [221905](https://bugzilla.redhat.com/show_bug.cgi?id=221905) Add SMD5 password support
    -   [529258](https://bugzilla.redhat.com/show_bug.cgi?id=529258) upgrade should remove duplicate and obsolete schema from 99user.ldif

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Windows Password Synchronization 1.1.2 - November 3, 2009
-------------------------------------------------------------

This release supports Windows Server 2008 in addition to 2003. 2000 is no longer supported (although it may work, we don't test it). We also have 64-bit packages in addition to the 32-bit packages.

This release uses the **389** branding. The program files folder will be named 389 Password Sync. If you are upgrading from Fedora PassSync, the upgrade will attempt to copy your db and log files from the Fedora folder to the new 389 folder. It will not remove the old Fedora folder. You can remove that manually after you have verified that the 389 PassSync is working correctly.

-   Download - [Download](../download.html)
-   [Howto:WindowsSync](../howto/howto-windowssync.html)

389 Directory Server 1.2.3 (testing release) - October 7, 2009
--------------------------------------------------------------

This has been released for testing. The packages are available from the testing repositories, not the official release repositories yet. We are seeking feedback. The two new packages available for testing are:

-   389-ds-base-1.2.3
-   389-admin-1.1.9

Instructions for installing these from the testing repositories:

    yum install --enablerepo=updates-testing 389-ds # Fedora new install    
    yum upgrade --enablerepo=updates-testing 389-ds-base 389-admin 389-console # Fedora upgrade    

or EL5

    yum install --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds # new install    
    yum upgrade --enablerepo=dirsrv-testing --enablerepo=idmcommon-testing 389-ds-base 389-admin 389-console # new install    

See [Download](../download.html) for more information about setting up yum access.

### Notes

NOTE: If using the FC6 (EL5) packages, **you must update your yum repo files** - the URLs have changed. See [Download](../download.html) for more information.

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: If you are using the console, after installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. 1.2.3 fixes some bugs related to update - it will remove old Fedora servers from the console, and will preserve TLS/SSL configuration. See the buglist below.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

-   Ability to set resource limits (sizelimit, timelimit, look through limit) specifically for anonymous connections
    -   This is useful when you want to have different limits for regular users and anonymous users
    -   Set the attribute **nsslapd-anonlimitsdn** in cn=config to the DN of the entry that you want to use as the "template" entry. This is a dummy entry that you have to create. Then you set whatever resource limits you want to apply to anonymous to that dummy entry, and those limits will apply to anonymous users.
-   Access based on the security strength of the connection
    -   There is a new ACI keyword - **minssf** - this allows you to set access control based on how secure the connection is
    -   There is a global server setting in cn=config - **nsslapd-minssf** - that allows you to reject operations based on how secure the connection is
-   Ability to shut off anonymous access
    -   This adds a new config switch in cn=config - **nsslapd-allow-anonymous-access** - that allows one to restrict all anonymous access. When this is enabled, the connection dispatch code will only allow BIND operations through for an unauthenticated user. The BIND code will only allow the operation through if it's not an anonymous or unauthenticated BIND.

### Bugs Fixed

This release contains several bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   Tracking bug for 1.2.3 release - [<https://bugzilla.redhat.com/showdependencytree.cgi?id=519216&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=519216&hide_resolved=0)
    -   [495073](https://bugzilla.redhat.com/show_bug.cgi?id=495073) RFE: In Place upgrade should handle configuration and schema changes
    -   [495522](https://bugzilla.redhat.com/show_bug.cgi?id=495522) Start script hardcodes file permissions mask to 077 (600), so the nsslapd-\*log-mode configuration attributes don't work
    -   [501616](https://bugzilla.redhat.com/show_bug.cgi?id=501616) [RFE] Restrict access to secure sessions only (TLS and SSL)
    -   [501846](https://bugzilla.redhat.com/show_bug.cgi?id=501846) Running setup-ds-admin.pl -u on replica with ldaps chokes on CA cert
    -   [513308](https://bugzilla.redhat.com/show_bug.cgi?id=513308) empty principal name used when using server to server sasl for db chaining
    -   [516305](https://bugzilla.redhat.com/show_bug.cgi?id=516305) MODIFY/replace with empty values does not ignore missing or unknown attributes
    -   [518112](https://bugzilla.redhat.com/show_bug.cgi?id=518112) rhds 81 el53 64b ns-slapd seg fault error 4 - nspr -5956 (The device for storing the file is full.)
    -   [518279](https://bugzilla.redhat.com/show_bug.cgi?id=518279) logs created at startup can get wrong file mode
    -   [518514](https://bugzilla.redhat.com/show_bug.cgi?id=518514) Bitwise Plugin: Bitwise filter doesn't return except the first entry if its multi-valued
    -   [518673](https://bugzilla.redhat.com/show_bug.cgi?id=518673) entryusn: wrong lastusn value
    -   [519455](https://bugzilla.redhat.com/show_bug.cgi?id=519455) Should not attempt to pop SASL IO layer if not using SASL IO
    -   [520483](https://bugzilla.redhat.com/show_bug.cgi?id=520483) setup-ds-admin.pl: Can't call method "getErrorString" on an undefined value at /usr/lib64/dirsrv/perl/AdminUtil.pm line 405.
    -   [520493](https://bugzilla.redhat.com/show_bug.cgi?id=520493) Upgrade from fedora-ds-1.2.0 to 389-ds-1.2.2 breaks 389-console and the admin server
    -   [520921](https://bugzilla.redhat.com/show_bug.cgi?id=520921) Config schema not included in core schema
    -   [521523](https://bugzilla.redhat.com/show_bug.cgi?id=521523) RPM Dependencies for 389 console are incomplete
    -   [523476](https://bugzilla.redhat.com/show_bug.cgi?id=523476) 389-ds-base/glibmm24: conflicting perl provides
    -   [525007](https://bugzilla.redhat.com/show_bug.cgi?id=525007) ldif2db replaces existing modify/create name and timestamps
    -   [525785](https://bugzilla.redhat.com/show_bug.cgi?id=525785) setup-ds-admin.pl should use correct default hostname + port
    -   [526141](https://bugzilla.redhat.com/show_bug.cgi?id=526141) allow empty groups
    -   [526319](https://bugzilla.redhat.com/show_bug.cgi?id=526319) SASL IO sometimes loops with "error: would block"

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.2 - August 26, 2009
--------------------------------------------

### Notes

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This release is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: After installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. There is a bug in setup - it will leave the old versions of the server in console - you can ignore the old versions.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

There are no new features in this release. This release fixes some critical bugs.

### Bugs Fixed

This release contains several bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   [<https://bugzilla.redhat.com/showdependencytree.cgi?id=389_1.2.2&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=389_1.2.2&hide_resolved=0)
-   [487425 slapd crashes after changelog is moved](https://bugzilla.redhat.com/show_bug.cgi?id=487425)
-   [504651 Need to store additional attributes in Retro Changelog](https://bugzilla.redhat.com/show_bug.cgi?id=504651)
-   [509472 db2index (all) does not reindex all the db backends correctly](https://bugzilla.redhat.com/show_bug.cgi?id=509472)
-   [518418 Package rename shuts down server, results in unconfigured package](https://bugzilla.redhat.com/show_bug.cgi?id=518418)
-   [518520 pre hashed salted passwords do not work](https://bugzilla.redhat.com/show_bug.cgi?id=518520)
-   [518544 large entries cause server SASL responses to fail](https://bugzilla.redhat.com/show_bug.cgi?id=518544)
-   [519065 Fails to start if attrcrypt can't unwrap keys](https://bugzilla.redhat.com/show_bug.cgi?id=519065)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

389 Directory Server 1.2.1 - August 17, 2009
--------------------------------------------

### Notes

NOTE: Fedora versions below 10 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 9 or earlier, you should upgrade.

NOTE: This is the first release that is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

NOTE: After installing the updates, you must run **setup-ds-admin.pl -u** to refresh your console and admin server configuration with the new version information. There is a bug in setup - it will leave the old versions of the server in console - you can ignore the old versions.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

### New features

There are several new features in this release. For more information, see [New Features for 1.2.1](../FAQ/roadmap.html)

### Bugs Fixed

This release contains several bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   [<https://bugzilla.redhat.com/showdependencytree.cgi?id=517385&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=517385&hide_resolved=0)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

Fedora Directory Server 1.2.0 - April 3, 2009
---------------------------------------------

### Notes

NOTE: Fedora versions below 9 are no longer supported (except for Fedora Core 6 - see below). If you are running Fedora 8 or earlier, you should upgrade.

NOTE: The console now requires Java 1.6. This is available on most platforms via OpenJDK (IcedTea). If you are using some derivative of Enterprise Linux 5, and cannot find Java 1.6, Java 1.6 is available from Fedora EPEL. See the [Download](../download.html) page for information about Enterprise Linux 5. Fedora 9 and later have Java 1.6 OpenJDK.

### Bugs Fixed

This release contains over 200 bug fixes. The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED have been fixed but are still in testing.

-   [<https://bugzilla.redhat.com/showdependencytree.cgi?id=493682&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=493682&hide_resolved=0)

### New features

-   [Server to Server connection improvements (startTLS, SASL, Kerberos)](../design/server-to-server-conn.html)
-   [64-bit counters](../design/64-bit-counters-design.html)
-   Ability to turn off anonymous BIND operations
-   Access Control: dynamic group lookup
    -   The ACI groupdn/roledn keyword allows you to specify access based on membership
    -   With earlier releases, you had to specify the full DN of the group/role e.g.

    groupdn="ldap:///cn=Administrators,dc=example,dc=com)"

-   -   You can now use a search specification

     groupdn="ldap:///suffix)??scope?(filter)"    

-   -   Example

    (groupdn = "ldap:///ou=Groups, dc=example,dc=com??sub?(cn=*s_0)" or    
     groupdn = "ldap:///ou=Groups,dc=example,dc=com)??sub?(cn=*s_1)") and    
    groupdn = "ldap:///ou=Groups), dc=example,dc=com??sub?(cn=*s_2)"    

means the user must belong to the group ending with s\_0 or s\_1, and the group ending with s\_2

-   remove-ds.pl - remove a directory server instance
-   remove-ds-admin.pl - wipe out everything (for use when you run setup-ds-admin.pl and get an error, and just want to start over from scratch)
-   New Schema - now includes schema for autofs, samba, and many other apps

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

Fedora Directory Server 1.1.3 - September 25, 2008
--------------------------------------------------

This release fixes a bug in the Windows Sync code that was introduced with 1.1.2. If you are using Windows Sync or plan to use freeIPA, you should upgrade to 1.1.3.

See *Fedora Directory Server 1.1.2* for additional information.

### Bugs Fixed

-   [457846 The Windows Sync API should have plug-in points](https://bugzilla.redhat.com/show_bug.cgi?id=457846)
    -   A previous fix to this bug caused Windows Sync to fail under certain conditions. This bug was fixed in 1.1.3

Fedora Directory Server 1.1.2 - September 16, 2008
--------------------------------------------------

### Notes

NOTE: If you had servers that did not show up console, or you want to update the information displayed for those servers in the console, run setup-ds-admin.pl with the new *update* option (-u or --update) - this will re-register all of your servers with the console. It is ok to run this even if your servers are already registered correctly and show up in the console - it will update the date and version information.

    setup-ds-admin.pl -u    

This will prompt for the Configuration Directory Server Admin password (i.e. the password for the admin user).

### Bugs Fixed

This release contains many, many bug fixes, including some security problems and memory leaks The complete list of bugs fixed is found at the link below. Note that bugs marked as MODIFIED are considered fixed. Only bugs in the NEW or ASSIGNED state have not been fixed or resolved.

-   [<https://bugzilla.redhat.com/showdependencytree.cgi?id=452721&hide_resolved=0>](https://bugzilla.redhat.com/showdependencytree.cgi?id=452721&hide_resolved=0)

### New features

-   Dynamic schema file reload - you can change the schema in a running server now in two ways
    -   old method - add schema over LDAP
    -   new method - add schema files to the slapd-instance/schema directory and tell the server to reload them - see <https://bugzilla.redhat.com/show_bug.cgi?id=436837> and <https://bugzilla.redhat.com/show_bug.cgi?id=450753> for more details
-   Get Effective Rights
    -   You can use the Get Effective Rights query to see what attributes a user would be allowed to edit or add to a new entry - see <https://bugzilla.redhat.com/show_bug.cgi?id=437525> for more details
    -   other enhancements - <https://bugzilla.redhat.com/show_bug.cgi?id=456296> and <https://bugzilla.redhat.com/show_bug.cgi?id=456752>
-   Man pages for many of the command line utilities
-   Windows Sync plug-in API - see the new include file winsync-plugin.h for details
-   Indexing improvements - you can now index attributes to do fast searches for one character initial substring searches e.g. (uid=a\*)
-   MemberOf plugin improvements - [MemberOf\_Plugin](../design/memberof-plugin.html)
-   DNA plugin improvements - [DNA\_Plugin](../design/dna-plugin.html)

### Download, Install, Setup

The [Download](../download.html) page has information about how to get the binaries. The [Install\_Guide](../legacy/install-guide.html) has information about installation and setup.

Fedora Directory Server 1.1.1 - June 6, 2008
--------------------------------------------

This is primarily a bug fix update. New features:

-   Improved slapi task interface - [Slapi\_Task\_API](../design/slapi-task-api.html)
-   Improved ldapi support, with support for SASL/EXTERNAL bind - [LDAPI\_and\_AutoBind](../FAQ/ldapi-and-autobind.html)
-   MemberOf plugin - [MemberOf\_Plugin](../design/memberof-plugin.html)
-   Bugs Fixed
    -   [429793](https://bugzilla.redhat.com/show_bug.cgi?id=429793) - Fixed crash in replication during bulk import
    -   [182621](https://bugzilla.redhat.com/show_bug.cgi?id=182621) - Allow larger regex buffer to enable long substring filters
    -   [439829](https://bugzilla.redhat.com/show_bug.cgi?id=439829) - simple password auth fails using NSS 3.11.99 or later
    -   [428764](https://bugzilla.redhat.com/show_bug.cgi?id=428764) - memory leaks in extensible filter code
    -   [440333](https://bugzilla.redhat.com/show_bug.cgi?id=440333) - Fixed valrgind errors about use of unitialized values
    -   [428163](https://bugzilla.redhat.com/show_bug.cgi?id=428163) - SASL IO functions set/get: argument mismatch
    -   [429799](https://bugzilla.redhat.com/show_bug.cgi?id=429799) - Allow import fifo to clear out all finished entries

Fedora Directory Server 1.1.0 - January 4, 2008
-----------------------------------------------

**WARNING: Following the instructions below will upgrade your 1.0 installation to 1.1.** If you want to do this, run /usr/sbin/migrate-ds-admin.pl after installation. If you do not want to do this, use a clean machine or a VM to install Fedora DS 1.1.

### Known Issues

-   **Migration to Fedora 8 and later requires LDIF files** - binary database migration from an earlier release to Fedora 8 or later does not work. This is because Fedora 8 and later use Berkeley DB 4.6 and the binary database format used in earlier releases is not compatible. If you are upgrading or migrating to Fedora DS 1.1 on Fedora 8 or later, you must first export (db2ldif) your databases to LDIF format. 

### What's new

-   Auto UID and GID number generation with the libdna plugin - Distributed Numeric Assignment - that works even with multi-master replication environments - see <http://cvs.fedora.redhat.com/viewcvs/ldapserver/ldap/servers/plugins/dna/?root=dirsec> for more information
-   Separate packages - each main component is in its own package - see [Discrete\_Packaging](../legacy/discrete-packaging.html)
-   Filesystem Hierarchy Standard file/path layout (e.g. log files are under /var/log/dirsrv) - see [FHS\_Packaging](../development/fds-packaging.html)
-   The setup command is now /usr/sbin/setup-ds-admin.pl - see [FDS\_Setup](../legacy/fds-setup.html) for more information
-   startconsole is gone - use /usr/bin/fedora-idm-console instead
-   Migration from version 1.0 and earlier is fully supported by the /usr/sbin/migrate-ds-admin.pl script provided with the package - see [FDS\_Setup](../legacy/fds-setup.html) and [Migration\_From\_10](../legacy/migration-from-10.html) for more information - see note above about migration to Fedora DS 1.1 on Fedora 8 and later.
-   Binary packages are provided only for Fedora 6, 7, 8 and 9 - The Fedora 6 packages should run on Red Hat EL5.1 (not 5.0)
    -   See [Enterprise Linux 5 Instructions](../download.html)
-   Version 1.1 does not include the phonebook, gateway, or org chart web apps - those will be provided in a following release
-   Init scripts!

    service dirsrv {start|stop|restart} [instance name]    
    service dirsrv-admin {start|stop|restart}    
    edit /etc/sysconfig/dirsrv or /etc/sysconfig/dirsrv-admin to set environment    

-   Bug Fixes - [This link](https://bugzilla.redhat.com/showdependencytree.cgi?id=427409) lists all of the Fedora Directory Server bugs fixed since 1.0.4
-   See the Red Hat Directory Server 8.0 documents for more information:
    -   Install Guide - <http://www.redhat.com/docs/manuals/dir-server/install/8.0/index.html>
    -   Admin Guide - <http://www.redhat.com/docs/manuals/dir-server/ag/8.0/index.html>
    -   Config, Command, and File Reference - <http://www.redhat.com/docs/manuals/dir-server/cli/8.0/index.html>
    -   Release Notes - <http://www.redhat.com/docs/manuals/dir-server/release-notes/8.0/index.html>

### Installation

-   Installation uses yum
-   If you are already using fedora-ds-base from Fedora, you must first upgrade it

    rpm -qi fedora-ds-base    

If that returns an error, skip to the next bullet, otherwise

    yum upgrade fedora-ds-base    

-   Set up your Fedora DS yum repo - as root

    cd /etc/yum.repos.d    
    wget http://{{ site.baseurl }}/binaries/idmcommon.repo)
    wget http://{{ site.baseurl }}/binaries/dirsrv.repo)

-   Full install

    yum install fedora-ds    

This will install many dependencies too. NOTE: On Fedora 8, the IcedTea Java can run the console. On Fedora 7 and earlier, you will still need to install a proprietary JRE in order to run - see [Install\_Guide](../legacy/install-guide.html) for information about how to install Java.

-   First time users can use /usr/sbin/setup-ds-admin.pl to set up the new directory server and admin server
-   Fedora DS 1.0.x users can use /usr/sbin/migrate-ds-admin.pl to migrate existing directory and admin server data

NOTE: If you are upgrading from 1.0, DO NOT USE setup-ds-admin.pl - use migrate-ds-admin.pl instead

-   Console - the console command is /usr/bin/fedora-idm-console - startconsole has been removed

#### Console only Installation

Follow the above steps to set up the yum repositories, then just install the fedora-idm-console package:

    yum install fedora-idm-console    

Then use /usr/bin/fedora-idm-console

#### Base DS only Installation

Follow the above steps to set up the yum repositories, then just install the fedora-ds-base package:

    yum install fedora-ds-base    

-   First time users can use /usr/sbin/setup-ds.pl to set up the new directory server
-   If you already have a directory server installation, use /usr/sbin/migrate-ds.pl instead of setup-ds.pl

Windows Console for Fedora DS 1.1 - December 14, 2007
-----------------------------------------------------

FedoraConsole.msi is a Windows Installer file for the Console for Fedora Directory Server 1.1. Go to [Download](../download.html) to download the file.

-   Tested with Sun Java 1.4 and 1.5 on Windows 2003 Server
-   You will need to install Java 1.4 or 1.5. Java must be available in your PATH, or you can edit the batch file provided to set JAVA to the correct path to java.exe
-   This might work with Fedora DS 1.0.4 but it has not been tested.

Fedora Directory Server 1.1 Beta - November 26, 2007
----------------------------------------------------

**WARNING: Following the instructions below will upgrade your 1.0 installation to 1.1.** If you want to do this, run /usr/sbin/migrate-ds-admin.pl after installation. If you do not want to do this, use a clean machine or a VM to install Fedora DS 1.1.

What's new?

-   Auto UID and GID number generation with the libdna plugin - Distributed Numeric Assignment - that works even with multi-master replication environments - see <http://cvs.fedora.redhat.com/viewcvs/ldapserver/ldap/servers/plugins/dna/?root=dirsec> for more information
-   Separate packages - each main component is in its own package - see [Discrete\_Packaging](../legacy/discrete-packaging.html)
-   Filesystem Hierarchy Standard file/path layout (e.g. log files are under /var/log/dirsrv) - see [FHS\_Packaging](../development/fhs-packaging.html)
-   The setup command is now /usr/sbin/setup-ds-admin.pl - see [FDS\_Setup](../legacy/fds_setup.html) for more information
-   startconsole is gone - use /usr/bin/fedora-idm-console instead
-   Migration from version 1.0 and earlier is fully supported by the /usr/sbin/migrate-ds-admin.pl script provided with the package - see [FDS\_Setup](../legacy/fds_setup.html) and [Migration\_From\_10](../legacy/migration-from-10.html) for more information
-   The beta only provides binary packages for Fedora 6, 7, 8 - The Fedora 6 packages should run on Red Hat EL5.1 (not 5.0)
    -   RHEL5 or CentOS 5 (or derivatives)
        -   Upgrade to 5.1 and install the packages svrcore, mozldap, and perl-Mozilla-LDAP
        -   You will also have to install the following packages from FC6 - jss, fedora-ds-base, and adminutil - for example, for 32-bit:
        -   GPG key for yum - <http://mirrors.kernel.org/fedora/core/6/i386/os/RPM-GPG-KEY-fedora>
            -   rpm --import <http://mirrors.kernel.org/fedora/core/6/i386/os/RPM-GPG-KEY-fedora>
        -   <http://mirrors.kernel.org/fedora/extras/6/i386/adminutil-1.1.5-1.fc6.i386.rpm>
        -   <http://mirrors.kernel.org/fedora/extras/6/i386/jss-4.2.5-1.fc6.i386.rpm>
        -   <http://mirrors.kernel.org/fedora/extras/6/i386/fedora-ds-base-1.1.0-2.0.fc6.i386.rpm>
        -   For 64-bit, just replace i386 above with x86\_64
-   Version 1.1 does not include the phonebook, gateway, or org chart web apps - those will be provided in a following release
-   Init scripts!

    service dirsrv {start|stop|restart} [instance name]    
    service dirsrv-admin {start|stop|restart}    
    edit /etc/sysconfig/dirsrv or /etc/sysconfig/dirsrv-admin to set environment    

-   Many, many bug fixes
-   See the Red Hat Directory Server 8.0 Beta documents for more information:
    -   Install Guide - <http://www.redhat.com/docs/manuals/dir-server/install/8.0/index.html>
    -   Admin Guide - <http://www.redhat.com/docs/manuals/dir-server/ag/8.0/index.html>
    -   Release Notes - <http://www.redhat.com/docs/manuals/dir-server/release-notes/8.0/index.html>

### Installation

-   Installation uses yum
-   If you are already using fedora-ds-base from Fedora, you must first upgrade it

    rpm -qi fedora-ds-base    

If that returns an error, skip to the next bullet, otherwise

    yum upgrade fedora-ds-base    

-   Set up your Fedora DS yum repo - as root

    cd /etc/yum.repos.d    
    wget http://{{ site.baseurl }}/binaries/idmcommon.repo
    wget http://{{ site.baseurl }}/binaries/dirsrv.repo

-   Install

    yum install fedora-ds    

This will install many dependencies too. NOTE: On Fedora 8, the IcedTea Java can run the console. On Fedora 7 and earlier, you will still need to install a proprietary JRE in order to run - see [Install\_Guide](../legacy/install-guide.html) for information about how to install Java.

-   First time users can use /usr/sbin/setup-ds-admin.pl to set up the new directory server and admin server
-   Fedora DS 1.0.x users can use /usr/sbin/migrate-ds-admin.pl to migrate existing directory and admin server data

NOTE: If you are upgrading from 1.0, DO NOT USE setup-ds-admin.pl - use migrate-ds-admin.pl instead

-   Console - the console command is /usr/bin/fedora-idm-console - startconsole has been removed

Fedora Directory Server 1.0.4 - November 9, 2006
------------------------------------------------

What's new?

-   Bug fixes - follow [this link](https://bugzilla.redhat.com/bugzilla/showdependencytree.cgi?id=213957) to see the bugzilla report
    -   The main bug fixed is in setup - it would change file ownership and break the server
-   Known issues
    -   You may get a Constraint Violation error during setup after doing an upgrade - disable password syntax checking before running setup, and re-enable it afterwards if you are using password syntax checking
    -   After doing an upgrade install (rpm -U), make sure the directory server and admin server are running:
        -   /opt/fedora-ds/slapd-instance/start-slapd
        -   /opt/fedora-ds/start-admin
    -   See also What's New with FDS 1.0.3 below

### Installation

First, [Download](../download.html) the binaries. Next, if you are upgrading from an earlier release, use rpm -Uvh to install, otherwise, use rpm -ivh. If upgrading, make sure your slapd and admin server are running:

    cd /opt/fedora-ds    
    ./slapd-yourhost/start-slapd    
    ./start-admin    

Next, if you are using password syntax checking, disable it before running setup:

    ldapmodify -x -D "cn=directory manager" -w password
    dn: cn=config
    changetype: modify
    replace: passwordCheckSyntax
    passwordCheckSyntax: off

Finally, run setup as follows:

    cd /opt/fedora-ds ; ./setup/setup    

Then, if you are using password syntax checking, enable it again:

    ldapmodify -x -D "cn=directory manager" -w password
    dn: cn=config
    changetype: modify
    replace: passwordCheckSyntax
    passwordCheckSyntax: on

Please refer to the [Install\_Guide](../legacy/install-guide.html) for more information.

Fedora Directory Server 1.0.3 - 10/31/2006
------------------------------------------

What's new?

-   Password modify extended operation can generate new passwords
-   New versions of NSPR (4.6.3) NSS (3.11.3) Mozldap (6.0.0)
    -   These new components address bugs and memory leaks in earlier versions, and adds client support for SASL to the bundled ldap command line tools
-   Uses system sasl and snmp instead of bundled versions
-   The PAM passthru auth plug-in is included (disabled by default)
-   Bug fixes - follow [this link](https://bugzilla.redhat.com/bugzilla/showdependencytree.cgi?id=208654) to see the bugzilla report
-   Known issues
    -   After doing an upgrade install (rpm -U), make sure the directory server and admin server are running:
        -   /opt/fedora-ds/slapd-instance/start-slapd
        -   /opt/fedora-ds/start-admin
    -   Using password syntax checking to restrict passwords less than 9 characters in length doesn't work with new password generation

### Installation

First, [Download](../download.html) the binaries. Next, if you are upgrading from an earlier release, use rpm -Uvh to install, otherwise, use rpm -ivh. If upgrading, make sure your slapd and admin server are running:

    cd /opt/fedora-ds    
    ./slapd-yourhost/start-slapd    
    ./start-admin    

Finally, run setup as follows:

    cd /opt/fedora-ds ; ./setup/setup    

Please refer to the [Install\_Guide](../legacy/install-guide.html) for more information.

Fedora Directory Server 1.0.2 - 03/02/2006
------------------------------------------

What's new?

-   Extended Password Syntax checking - passwords can be checked to see if they conform to the following:
    -   minimum password character length (old feature, but now the default is 8 characters)
    -   minimum number of digit characters (0-9)
    -   minimum number of ASCII alpha characters (a-z, A-Z)
    -   minimum number of uppercase ASCII alpha characters (A-Z)
    -   minimum number of lowercase ASCII alpha characters (a-z)
    -   minimum number of special ASCII characters (!@\#\$, etc.)
    -   minimum number of 8-bit characters
    -   maximum number of times the same char can be immediately repeated (aaabbb)
    -   minimum number of character categories that are represented (categories are lower, upper, digit, special, and 8-bit)
    -   More information, including screen shots, can be found [here](../design/password-syntax.html).
-   Support for Linux x86\_64 - RPMs for Fedora Core 4 and 5 and RHEL4 x86\_64 are on the [Download](../download.html) page.
-   Bug fixes - follow [this link](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=183369) to see the bugzilla report

### Installation

First, [Download](../download.html) the binaries. Next, if you are upgrading from an earlier release, use rpm -Uvh to install, otherwise, use rpm -ivh. Finally, run setup as follows:

    cd /opt/fedora-ds ; ./setup/setup    

If upgrading, you may need to restart your slapd and/or admin server after running setup:

    cd /opt/fedora-ds    
    ./slapd-yourhost/start-slapd    
    ./start-admin    

Please refer to the [Install\_Guide](../legacy/install-guide.html) for more information.

Fedora Directory Server 1.0.1 - 12/08/2005
------------------------------------------

This is a patch release to address the following problems:

-   Fedora DS 1.0 was built with the build bomb ON - this means the binary will quit working after 120 days - [175053](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=175053)
-   The Admin Server in Fedora DS 1.0 can allow unauthorized access to sensitive information - [174837](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=174837)
-   The console required the mozilla-nspr and mozilla-nss packages. This dependency has been removed - [174981](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=174981)
-   Other bugs: [174843](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=174843) [175187](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=175187) [175098](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=175098)

### Installation

First, [Download](../download.html) the binaries.

#### Upgrade from Fedora DS 1.0

If you are upgrading from Fedora DS 1.0, DO NOT RUN SETUP after doing the rpm -Uvh. Instead, just restart your directory servers, followed by restarting your admin server. e.g.

    cd /opt/fedora-ds    
    ./slapd-name/start-slapd    
    ./slapd-name2/start-slapd    
    ...    
    ./slapd-nameN/start-slapd    
    ./start-admin    

#### First time Fedora DS Install

If you are installing the software for the first time, please refer to [Install\_Guide](../legacy/install-guide.html) for more information.



