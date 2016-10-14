---
title: "Releases/AdminServer-1.1.45 and console packages"
---
389 Admin Server 1.1.45 and console packages
-----------------------------

The 389 Directory Server team is proud to announce 389-admin, 389-adminutil, 389-console, 389-ds-console, 389-admin-console, and idm-console-framework. 

Fedora packages are available from the Fedora 24, Fedora 25, and Rawhide repositories.

The new packages and versions are:

-   389-admin-1.1.45-1
-   389-adminutil-1.1.23-1
-   389-console-1.1.18-1
-   389-ds-console-1.2.15
-   389-admin-console-1.1.12-1
-   idm-console-framework-1.1.17-1

Source tarballs are available for download at 

[Download Admin Source]({{ site.baseurl }}/binaries/389-admin-1.1.45.tar.bz2)  
[Download Adminutil Source]({{ site.baseurl }}/binaries/389-adminutil-1.1.23.tar.bz2).
[Download 389-console Source]({{ site.baseurl }}/binaries/389-console-1.1.18.tar.bz2),
[Download 389-ds-console Source]({{ site.baseurl }}/binaries/389-ds-console-1.2.15.tar.bz2),
[Download 389-admin-console Source]({{ site.baseurl }}/binaries/389-admin-console-1.1.12.tar.bz2), and
[Download idm-console-framework Source]({{ site.baseurl }}/binaries/idm-console-framework-1.1.17.tar.bz2).


### Highlights

-   Several bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> and following pages:

-   [389-admin-1.1.45-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-9a07c81afa)
-   [389-admin-1.1.45-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-b1ec7bb18a)
-   [389-adminutil-1.1.23-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-7657a741a3)
-   [389-adminutil-1.1.23-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-e01c252a2a)
-   [idm-console-framework-1.1.17-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-58834f0b0e)
-   [idm-console-framework-1.1.17-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-f2af3ec61a)
-   [389-console-1.1.18-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-d95465347c)
-   [389-console-1.1.18-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-07d7111669)
-   [389-ds-console-1.2.15-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-ca30ede300)
-   [389-ds-console-1.2.15-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-e37b304df2)
-   [389-admin-console-1.1.12-1.f25](https://bodhi.fedoraproject.org/updates/FEDORA-2016-ab72039c92)
-   [389-admin-console-1.1.12-1.f24](https://bodhi.fedoraproject.org/updates/FEDORA-2016-0ea0ab2142)

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 389-admin-1.1.44

- Bug 1236635 - 389-admin TPS srpmtest failure
- Ticket 48932 - stopping admin server stops all httpd processes
- Ticket 47413 - 389-admin fails to build with latest httpd
- Ticket 48931 - start-ds-admin should use systemctl
- Ticket 48823 - Admin Server - Add IPv6 support
- Ticket 48907 - register-ds-admin fails to find local config DS
- Ticket 48306 - perl module conditional test is not conditional when checking SELinux policies
- Ticket 48213 - Admin server registration requires anonymous binds
- Ticket 48429 - running remove-ds-admin.pl multiple times will make it so you cannot install DS
- Ticket 48410 - 389-admin - Unable to remove / unregister a DS instance from admin server
- Ticket 48409 - RHDS upgrade change Ownership of certificate files upon upgrade.
- Ticket 47840 - Fix setup-ds-admin.pl to create adm.conf with sbin scripts

### Detailed Changelog since 389-adminutil-1.1.22

- Ticket 48345 - bad check for NUL char in psetc.c

### Detailed Changelog since 389-ds-console-1.1.12

- Ticket 49003 - Managed role error dialog empty
- Ticket 49003 - Add the host and port to the ldapurl in the role form
- Ticket 48926 - Fixed reset & save button behavior in the password/account lockout panels
- Bumped version to 1.2.14
- Ticket 48926 - fix "expiresin" entry definition
- Bumped version to 1.2.13
- Ticket #48933 - drop support for legacy replication - need to clean code
- Ticket 48926 - Inactive "save" button in "Password policy" dialog
- Ticket 47469 - Cannot enter time in Replication schedule in console
- Ticket 48823 - ds-console - add IPv6 support
- Ticket #48417 - ds-console: lower password history minimum to 1

### Detailed Changelog since 389-admin-console-1.1.10

- bump version to 1.1.12
- Ticket 48823 - admin-console - Add IPv6 support
- Ticket 48809 - Admin console displays the wrong log names
- bump version to 1.1.11
- Bug 1234441 - Security info from Help should be removed

### Detailed Changelog since idm-console-framework-1.1.14

- Bump version to 1.1.17
- Ticket 49003 - Allow LDAP Urls without host and port
- Ticket 49003 - Add host and port to LDAP URL construction
- Bump version to 1.1.16
- Ticket 48565 - Provide better error message in console when there is architecture mismatch
- Ticket 48743 - idm-console-framework - disable fortezza ciphers by default
- Ticket 48823 - idm-console-framework - Add IPv6 support
- Bump version to 1.1.15
- Ticket #48811 - Console window could be hidden after login via consoles on multiple hosts


