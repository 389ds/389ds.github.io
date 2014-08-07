---
title: "Releases/1.3.1.1"
---
389 Directory Server 1.3.1.1
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.1.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.1-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.1-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.1.tar.bz2)

### Highlights in 1.3.1.1

-   Performance improvements - a configuration parameter nsslapd-ignore-virtual-attrs is added to skip virtual attribute lookup.
-   Enhancement - listen backlog size is now configurable.
-   Bug fixes in password handling, SASL, WinSync, Start\_TLS, schema, LDAP connection, and SNMP.
-   Compiler warnings and defects reported by Coverity Code Analysis Tool were fixed.

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

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1.0

-   Ticket 402 - nhashed\#user\#password in entry extension
-   Ticket 511 - Revision - allow turning off vattr lookup in search entry return
-   Ticket 580 - Wrong error code return when using EXTERNAL SASL and no client certificate
-   Ticket 47327 - error syncing group if group member user is not synced
-   Ticket 47355 - dse.ldif doesn't replicate update to nsslapd-sasl-mapping-fallback
-   Ticket 47359 - new ldap connections can block ldaps and ldapi connections
-   Ticket 47362 - ipa upgrade selinuxusermap data not replicating
-   Ticket 47375 - flush\_ber error sending back start\_tls response will deadlock
-   Ticket 47376 - DESC should not be empty as per RFC 2252 (ldapv3)
-   Ticket 47377 - make listen backlog size configurable
-   Ticket 47378 - fix recent compiler warnings
-   Ticket 47383 - connections attribute in cn=snmp,cn=monitor is counted twice
-   Ticket 47385 - DS not shutting down when disk monitoring threshold is reached
-   Coverity Fixes (part 1)
-   Coverity Fixes (Part 2)
-   Coverity Fixes (Part 3)
-   Coverity Fixes (Part 4)
-   Coverity Fixes (Part 5)

