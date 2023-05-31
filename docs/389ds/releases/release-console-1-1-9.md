---
title: "Releases/console-1.1.9"
---
389 Console 1.1.9
-----------------------------

The 389 Directory Server team is proud to announce 389-console version 1.1.9, 389-ds-console version 1.2.10, 389-admin-console version 1.1.10, and idm-console-framework version 1.1.9.

Fedora packages are available from the EPEL7, Fedora 20, Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-console-1.1.9-1
-   389-ds-console-1.2.10-1
-   389-admin-console-1.1.10-1
-   idm-console-framework-1.1.9-1

Source tarballs are available for download at [Download 389 Console Source]({{ site.binaries_url }}/binaries/389-console-1.1.9.tar.bz2), 
[Download 389 Ds Console Source]({{ site.binaries_url }}/binaries/389-ds-console-1.2.10.tar.bz2), 
[Download 389 Admin Console Source]({{ site.binaries_url }}/binaries/389-admin-console-1.1.10.tar.bz2) and 
[Download Idm Console Framework Source]({{ site.binaries_url }}/binaries/idm-console-framework-1.1.9.tar.bz2).

### Highlights in 389-console-1.1.9, 389-ds-console-1.2.10, 389-admin-console-1.1.10 and idm-console-framework-1.1.9-1

-   Several bugs are fixed including security bugs -- enable TLS version 1.1 and newer; stop using old SSL version.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   <https://admin.fedoraproject.org/updates/389-console-1.1.9-1.el7>
-   <https://admin.fedoraproject.org/updates/389-console-1.1.9-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-console-1.1.9-1.fc21>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.10-1.el7>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.10-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.10-1.fc21>
-   <https://admin.fedoraproject.org/updates/389-admin-console-1.1.10-1.el7>
-   <https://admin.fedoraproject.org/updates/389-admin-console-1.1.10-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-admin-console-1.1.10-1.fc21>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.9-2.el7>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.9-2.fc20>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.9-1.fc21>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-console-1.1.7

-   Ticket 47604 - 389-console: remove versioned jars from %{_javadir}
-   Ticket 97    - 389-console should provide man page

### Detailed Changelog since 389-ds-console-1.2.7

-   Bug 1022104  - Remove versioned jarfiles from _javadir (idm-console-framework)
-   Ticket 47994 - DS Console always sets nsSSL3 to "on" when a securty setting is adjusted
-   Ticket 47380 - RFE: Winsync loses connection with AD objects when they move from the console.
-   Ticket 135   - DS console - right clicking an object does not select that object
-   Ticket 47887 - DS Console does not correctly disable SSL
-   Ticket 47485 - DS instance cannot be restored from remote console
-   Ticket 47886 - DS Console - mouse wheel speed very slow
-   Ticket 176   - DS Console should timeout when mismatched port and protocol combination is chosen
-   Ticket 47883 - DS Console - java exception when refreshing  schema
-   Ticket 96    - Window too large for Manage password policy

### Detailed Changelog since 389-admin-console-1.1.8

-   Bug 1022104  - Remove versioned jarfiles from _javadir (idm-console-framework)
-   Ticket 47477 - Cannot restart SSL-admin server from console
-   Ticket 47467 - Improve online help for Add CRL dialog
-   Ticket 362   - Directory Console generates insufficient key strength

### Detailed Changelog since idm-console-framework-1.1.7

-   Ticket 47929 - idm-console-framework - set default min to tls1.0
-   Ticket 47946 - ACI's are replaced by "ACI_ALL" after editing group of ACI's including invalid one
-   Ticket 47929 - Console - add tls1.1 support
-   Ticket 47472 - Entries cannot be highlighted in the "Edit Aci" Rights panel
-   Ticket 47364 - Console does not support passwords containing  8-bit characters
-   Ticket 47604 - idm-console-framework: remove versioned jars from %{_javadir}
-   Ticket 47480 - Admin Console "server restart dialog" disppears after clicking OK
-   Ticket 47467 - Improve CRL import dialog text
-   Ticket 362   - Directory Console generates insufficient key strength
