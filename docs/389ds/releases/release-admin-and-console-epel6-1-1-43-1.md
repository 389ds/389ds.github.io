---
title: "Releases/AdminServer-1.1.43 and Consoles for EPEL6"
---
389 Admin Server 1.1.43 and Consoles for EPEL6
-----------------------------

The 389 Directory Server team is proud to announce 389-admin version 1.1.42, 389-adminutil version 1.1.22, 389-console version 1.1.16, 389-ds-console version 1.2.12, 389-admin-console version 1.1.11, and idm-console-framework version version 9.1.2.

Fedora packages are available from the EPEL6.

The new packages and versions are:

-   389-admin-1.1.43-1
-   389-adminutil-1.1.22-1.el6
-   389-console-1.1.17-1.el6
-   389-ds-console-1.2.12-2.el6
-   389-admin-console-1.1.11-1.el6
-   idm-console-framework-1.1.15-1.el6

Source tarballs are available for download at [Download Admin Source]({{ site.baseurl }}/binaries/389-admin-1.1.43.tar.bz2),
[Download Adminutil Source]({{ site.baseurl }}/binaries/389-adminutil-1.1.22.tar.bz2),
[Download 389-console Source]({{ site.baseurl }}/binaries/389-console-1.1.17.tar.bz2),
[Download 389-ds-console Source]({{ site.baseurl }}/binaries/389-ds-console-1.2.12.tar.bz2),
[Download 389-admin-console Source]({{ site.baseurl }}/binaries/389-admin-console-1.1.11.tar.bz2), and
[Download idm-console-framework Source]({{ site.baseurl }}/binaries/idm-console-framework-1.1.15.tar.bz2).

### Highlights in 389-admin-1.1.43, 389-adminutil-1.1.22, 389-console-1.1.17, 389-ds-console-1.2.12, 389-admin-console-1.1.11, and idm-console-framework-1.1.15

-   Releasing the latest versions for EPEL6

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   <https://admin.fedoraproject.org/updates/389-admin-1.1.43-1.el6 >
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.22-1.el6>
-   <https://admin.fedoraproject.org/updates/389-console-1.1.17-1.el6>
-   <https://admin.fedoraproject.org/updates/389-ds-console-1.2.12-2.el6>
-   <https://admin.fedoraproject.org/updates/389-admin-console-1.1.11-1.el6>
-   <https://admin.fedoraproject.org/updates/idm-console-framework-1.1.15-1.el6>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-admin-1.1.35

-   Ticket 48762 - 389-admin uses 389-admin-git.sh which uses HTTP to download content from git (should use HTTPS)
-   Ticket 48429 - running remove-ds-admin.pl multiple times will make it so you cannot inst all DS
-   Ticket 48409 - RHDS upgrade change Ownership of certificate files upon upgrade.
-   Ticket 47548 - register-ds-admin - silent file incorrectly processed
-   Ticket 47493 - Configuration Tab does not work with FIPS mode enabled
-   Ticket 48186 - register-ds-admin.pl script prints clear text password in the terminal
-   Ticket 47548 - register-ds-admin.pl fails to set local bind DN and password
-   Ticket 47467 - Improve Add CRL/CKL dialog and errors
-   Ticket 48171 - remove-ds-admin.pl removes files in the rpm
-   Ticket 48153 - "Manage certificates" crashes admin server
-   Ticket 48024 - repl-monitor invoked from adminserver cgi fails
-   Ticket 47995 - multiple /tmp/ file vulnerabilities [directory_server_10]
-   Ticket 47901 - Admin Server reconfig breaks SSL config
-   Ticket 47929 - Admin Server - disable SSLv3 by default
-   Ticket 201   - nCipher HSM cannot be configured via the console
-   Ticket 47493 - Configuration Tab does not work with FIPS mode enabled
-   Ticket 47697 - Resource leak in lib/libdsa/dsalib_updown.c
-   Ticket 47860 - register-ds-admin.pl problem when following steps to replicate o=netscaperoot
-   Ticket 47548 - register-ds-admin does not register into remote config ds
-   Ticket 47893 - Admin Server should use Sys::Hostname instead Net::Domain
-   Ticket 47891 - Admin Server reconfig breaks SSL config
-   Ticket 47300 - Update man page for remove-ds-admin.pl
-   Ticket 47850 - "nsslapd-allow-anonymous-access: rootdse" makes login as "admin" fail at the first time
-   Ticket 47497 - Admin Express - remove "Security Level"
-   Ticket 47495 - admin express: wrong instance creation time
-   Ticket 47665 - Create new instance results in setting wrong ACI for the "cn=config" entry
-   Ticket 47478 - No groups file? error restarting Admin server
-   Ticket 47300 - [RFE] remove-ds-admin.pl: redesign the behaviour
-   Ticket 434   - admin-serv logs filling with "admserv_host_ip_check: ap_get_remote_host could not resolve <ip address>"
-   Ticket 47563 - cannot restart directory server from console
-   Ticket 222   - Admin Express issues "Internal Server Error" when the Config DS is down.
-   Ticket 418   - Error with register-ds-admin.pl
-   Ticket 47498 - Error Message for Failed to create the configuration directory server

### Detailed Changelog since 389-adminutil-1.1.19

-   Ticket 48152 - "Manage certificates" crashes admin server
-   Ticket 47929 - adminutil - future proof getSSLVersion
-   Ticket 47929 - Adminutil - do not use SSL3 by default
-   Ticket 47850 - "nsslapd-allow-anonymous-access: rootdse" makes login as "admin" fail at the first time
-   Ticket 47881 - crash during debug session in adminutil
-   Ticket 47680 - Upgraded 389-admin rpms and now I can't start dirsrv-admin
-   Ticket 47415 - "Manage certificates" crashes admin server
-   Ticket 47486 - compiler warnings in adminutil, admin, dsgw
-   Ticket 47343 - 389-adminutil: Does not support aarch64 in f19 and rawhide

### Detailed Changelog since 389-console-1.1.7

-   Bug 1304595 - Console -- Update Java dependency to 1.8
-   Bug 1022104 - Remove versioned jar files

### Detailed Changelog since 389-ds-console-1.2.6

-   Bug 1234441 - Security info from Help should be removed
-   Console -- Update Java dependency to 1.8
-   Ticket 48417 - Security info from Help should be removed (partial)
-   Ticket 48139 - drop support for legacy replication
-   Ticket 48130 - Add "+all" and "-TLS_RSA_WITH_AES_128_GCM_SHA256" to Console Cipher Preference for TLS
-   Ticket 47994 - DS Console always sets nsSSL3 to "on" when a securty setting is adjusted
-   Ticket 47380 - RFE: Winsync loses connection with AD objects when they move from the console.
-   Ticket 135   - DS console - right clicking an object does not select that object
-   Ticket 47887 - DS Console does not correctly disable SSL
-   Ticket 47485 - DS instance cannot be restored from remote console
-   Ticket 47886 - DS Console - mouse wheel speed very slow
-   Ticket 176   - DS Console should timeout when mismatched port and protocol combination is chosen
-   Ticket 47883 - DS Console - java exception when refreshing  schema
-   Ticket 96    - Window too large for Manage password policy
-   Ticket 370   - Opening merge qualifier CoS entry using RHDS console changes the entry

### Detailed Changelog since 389-admin-console-1.1.8

-   Bug 723126   - Configure Admin Server -> Connection Restriction --> Add Screen is flicking consistently.
-   Bug 1022104  - Remove versioned jarfiles from _javadir
-   Ticket 48417 - Security info from Help should be removed
-   Ticket 362   - Directory Console generates insufficient key strength
-   Ticket 47467 - Improve online help for Add CRL dialog
-   Ticket 47477 - Cannot restart SSL-admin server from console

### Detailed Changelog since idm-console-framework-1.1.7

-   Ticket 48811 - Console window could be hidden after login via consoles on multiple hosts
-   Console -- Update Java dependency to 1.8
-   Ticket 48187 - Adding an OU from console is throwing missing attribute aliasedObjectName error
-   Ticket 48134 - Directory Server Admin Console: plaintext password logged in debug mode
-   Ticket 47946 - Adding an ACI from the GUI removes broken ACIs
-   Ticket 47946 - Need to revise console aci syntax checking
-   Ticket 97    - 389-console should provide usage options, help, and man pages
-   Ticket 48130 - Add "+all" and "-TLS_RSA_WITH_AES_128_GCM_SHA256" to Console Cipher Preference for TLS
-   Ticket 48134 - Directory Server Admin Console: plaintext password logged in debug mode
-   Ticket 47929 - idm-console-framework - set default min to tls1.0
-   Ticket 47946 - ACI's are replaced by "ACI_ALL" after editing group of ACI's including invalid one
-   Ticket 47929 - Console - add tls1.1 support
-   Ticket 47472 - Entries cannot be highlighted in the "Edit Aci" Rights panel
-   Ticket 47364 - Console does not support passwords containing  8-bit characters
-   Ticket 47604 - idm-console-framework: remove versioned jars from %{_javadir}
-   Ticket 47480 - Admin Console "server restart dialog" disppears after clicking OK
-   Ticket 47467 - Improve CRL import dialog text
-   Ticket 362   - Directory Console generates insufficient key strength
-   Bug 1022104 - Do not use versioned jars
-   using new upstream git repo at fedorahosted.org


