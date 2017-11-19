---
title: "Releases/1.2.11.22"
---
389 Directory Server 1.2.11.22
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.22.

This release is only available in binary form for EL6 (Fedora 17 is now EOL) - see [Download\#RHEL6/EPEL6](Download#RHEL6/EPEL6 "wikilink") for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.22-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.2.11.22.tar.bz2)

### Highlights in 1.2.11.22

-   Many, many bug fixes - see below

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

### Detailed Changelog since 1.2.11.21

-   Full list [Milestone 1.2.11.22](https://fedorahosted.org/389/report/13)

Ludwig Krispenz (4):

-   Ticket [47395](https://fedorahosted.org/389/ticket/47395) [47397](https://fedorahosted.org/389/ticket/47397) v2 correct behaviour of account policy if only stateattr is configured or no alternate attr is configured
-   Ticket [47396](https://fedorahosted.org/389/ticket/47396) - crash on modrdn of tombstone
-   CVE-2013-2219 ACLs inoperative in some search scenarios - Ticket [\#47405](https://fedorahosted.org/389/ticket/47405): defect: access control not working for specific search filter
-   fix compiler warning

Mark Reynolds (19):

-   Ticket [580](https://fedorahosted.org/389/ticket/580) - Wrong error code return when using EXTERNAL SASL and no client certificate
-   Coverity Fixes (part 1)
-   Coverity Fixes (Part 2)
-   Coverity Fixes (Part 3)
-   Coverity Fixes (Part 4)
-   Coverity Fixes (Part 5)
-   Coverity Fixes (Part 6)
-   Coverity Fixes (Part 7)
-   Ticket [47385](https://fedorahosted.org/389/ticket/47385) - DS not shutting down when disk monitoring threshold is reached
-   Ticket [47383](https://fedorahosted.org/389/ticket/47383) - connections attribute in cn=snmp,cn=monitor is counted twice
-   Ticket [47376](https://fedorahosted.org/389/ticket/47376) - DESC should not be empty as per RFC 2252 (ldapv3)
-   Ticket [47385](https://fedorahosted.org/389/ticket/47385) - Disk Monitoring is not triggered as expected.
-   Ticket [47427](https://fedorahosted.org/389/ticket/47427) - Overflow in nsslapd-disk-monitoring-threshold
-   Ticket [47441](https://fedorahosted.org/389/ticket/47441) - Disk Monitoring not checking filesystem with logs
-   Ticket [47421](https://fedorahosted.org/389/ticket/47421) - memory leaks in set\_krb5\_creds
-   Ticket [47449](https://fedorahosted.org/389/ticket/47449) - deadlock after adding and deleting entries
-   Ticket [47427](https://fedorahosted.org/389/ticket/47427) - Overflow in nsslapd-disk-monitoring-threshold

Matthew Via (1):

-   Ticket [\#47428](https://fedorahosted.org/389/ticket/47428) - Memory leak in 389-ds-base 1.2.11.15

Noriko Hosoi (13):

-   Coverity fix 13139 - Dereference after NULL check in slapi\_attr\_value\_normalize\_ext()
-   Ticket [623](https://fedorahosted.org/389/ticket/623) - cleanAllRUV task fails to cleanup config upon completion
-   Ticket [\#47347](https://fedorahosted.org/389/ticket/47347) - Simple paged results should support async search
-   Trac Ticket[\#531](https://fedorahosted.org/389/ticket/531)- loading an entry from the database should use str2entry\_fast
-   Ticket [\#47327](https://fedorahosted.org/389/ticket/47327) - error syncing group if group member user is not synced
-   Ticket [\#47367](https://fedorahosted.org/389/ticket/47367) - (phase 1) ldapdelete returns non-leaf entry error while trying to remove a leaf entry
-   Ticket [\#47391](https://fedorahosted.org/389/ticket/47391) - deleting and adding userpassword fails to update the password
-   Ticket [\#47402](https://fedorahosted.org/389/ticket/47402) - Attribute names are incorrect in search results
-   Ticket [\#47412](https://fedorahosted.org/389/ticket/47412) - Modify RUV should be serialized in ldbm\_back\_modify/add
-   Ticket [\#47435](https://fedorahosted.org/389/ticket/47435) - Very large entryusn values after enabling the USN plugin and the lastusn value is negative.
-   Ticket [\#47378](https://fedorahosted.org/389/ticket/47378) - fix recent compiler warnings
-   Ticket [\#543](https://fedorahosted.org/389/ticket/543) - Sorting with attributes in ldapsearch gives incorrect result

Rich Megginson (20):

-   Ticket [\#47362](https://fedorahosted.org/389/ticket/47362) - ipa upgrade selinuxusermap data not replicating
-   Ticket [\#47359](https://fedorahosted.org/389/ticket/47359) - new ldap connections can block ldaps and ldapi connections
-   Ticket [\#47349](https://fedorahosted.org/389/ticket/47349) - DS instance crashes under a high load
-   Ticket [\#47378](https://fedorahosted.org/389/ticket/47378) - fix recent compiler warnings
-   Ticket [\#47377](https://fedorahosted.org/389/ticket/47377) - make listen backlog size configurable
-   Ticket [\#47375](https://fedorahosted.org/389/ticket/47375) - flush\_ber error sending back start\_tls response will deadlock
-   Ticket [\#47409](https://fedorahosted.org/389/ticket/47409) - allow setting db deadlock rejection policy
-   Ticket [\#47410](https://fedorahosted.org/389/ticket/47410) - changelog db deadlocks with DNA and replication
-   Ticket [\#47392](https://fedorahosted.org/389/ticket/47392) - ldbm errors when adding/modifying/deleting entries
-   Ticket [\#47424](https://fedorahosted.org/389/ticket/47424) - Replication problem with add-delete requests on single-valued attributes
-   Ticket [47427](https://fedorahosted.org/389/ticket/47427) - Overflow in nsslapd-disk-monitoring-threshold
-   Fix compiler warnings for Ticket [47395](https://fedorahosted.org/389/ticket/47395) and [47397](https://fedorahosted.org/389/ticket/47397)
-   fix compiler warning in posix winsync code for posix\_group\_del\_memberuid\_callback
-   fix coverity 11895 - null deref - caused by fix to ticket [47392](https://fedorahosted.org/389/ticket/47392)

Thierry bordaz (tbordaz) (2):

-   Ticket [47361](https://fedorahosted.org/389/ticket/47361) - Empty control list causes LDAP protocol error is thrown
-   Ticket [47393](https://fedorahosted.org/389/ticket/47393) - Attribute are not encrypted on a consumer after a full initialization

