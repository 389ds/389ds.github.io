---
title: "Releases/AdminServer-1.1.38"
---
389 Admin Server 1.1.38
-----------------------------

The 389 Directory Server team is proud to announce 389-admin version 1.1.38 and 389-adminutil version 1.1.21.

Fedora packages are available from the EPEL7, Fedora 20, Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-admin-1.1.38-1
-   389-adminutil-1.1.21-1

Source tarballs are available for download at [Download Admin Source]({{ site.baseurl }}/binaries/389-admin-1.1.38.tar.bz2) and 
[Download Adminutil Source]({{ site.baseurl }}/binaries/389-adminutil-1.1.21.tar.bz2).

### Highlights in 389-admin-1.1.38 and 389-adminutil-1.1.21

-   Several bugs are fixed including security bugs -- stop using DES and old SSL version.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users> and following pages:

-   <https://admin.fedoraproject.org/updates/389-admin-1.1.38-1.el7>
-   <https://admin.fedoraproject.org/updates/389-admin-1.1.38-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-admin-1.1.38-1.fc21>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.21-2.el7>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.21-1.fc20>
-   <https://admin.fedoraproject.org/updates/389-adminutil-1.1.21-1.fc21>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-admin-1.1.35

-   Ticket 48024 - repl-monitor invoked from adminserver cgi fails
-   Ticket 47995 - Admin Server: source code cleaning
-   Ticket 47891 - Admin Server reconfig breaks SSL config
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
-   Ticket 377   - Unchecked use of SELinux command Reviewed by: rmeggins
-   Ticket 47498 - Error Message for Failed to create the configuration directory server

### Detailed Changelog since 389-adminutil-1.1.19

-   Ticket 47929 - adminutil - future proof getSSLVersion
-   Ticket 47929 - Adminutil - do not use SSL3 by default
-   Ticket 47850 - "nsslapd-allow-anonymous-access: rootdse" makes login as "admin" fail at the first time
-   Ticket 47881 - crash during debug session in adminutil
-   Ticket 47680 - Upgraded 389-admin rpms and now I can't start dirsrv-admin

