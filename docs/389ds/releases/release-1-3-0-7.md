---
title: "Releases/1.3.0.7"
---
389 Directory Server 1.3.0.7
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.0.7.

Fedora packages are available from the Fedora 18 Testing repositories. It will move to the Fedora 18 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.0.7-1.fc18) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.0.7-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.7.tar.bz2)

### Highlights in 1.3.0.7

In this version, a security bug in ACL, a crash bug in replication, a deadlock issue as well as several important bugs were fixed. Functionality such as Disk Monitoring and logconv were improved. Also, memory management issues reported by valgrind, defects reported by coverity and compiler warnings were fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.0.6

-   Ticket 511 - Revision - allow turning off vattr lookup in search entry return
-   Ticket 543 - Sorting with attributes in ldapsearch gives incorrect result
-   Ticket 580 - Wrong error code return when using EXTERNAL SASL and no client certificate
-   Ticket 47327 - error syncing group if group member user is not synced
-   Ticket 47347 - Simple paged results should support async search
-   Ticket 47349 - DS instance crashes under a high load
-   Ticket 47355 - dse.ldif doesn't replicate update to nsslapd-sasl-mapping-fallback
-   Ticket 47359 - new ldap connections can block ldaps and ldapi connections
-   Ticket 47362 - ipa upgrade selinuxusermap data not replicating
-   Ticket 47367 - (phase 1) ldapdelete returns non-leaf entry error while trying to remove a leaf entry
-   Ticket 47367 - (phase 2) ldapdelete returns non-leaf entry error while trying to remove a leaf entry
-   Ticket 47375 - flush\_ber error sending back start\_tls response will deadlock
-   Ticket 47376 - DESC should not be empty as per RFC 2252 (ldapv3)
-   Ticket 47377 - make listen backlog size configurable
-   Ticket 47378 - fix recent compiler warnings
-   Ticket 47383 - connections attribute in cn=snmp,cn=monitor is counted twice
-   Ticket 47385 - DS not shutting down when disk monitoring threshold is reached
-   Ticket 47385 - Disk Monitoring is not triggered as expected.
-   Ticket 47391 - deleting and adding userpassword fails to update the password
-   Ticket 47391 - deleting and adding userpassword fails to update the password (additional fix)
-   Ticket 47392 - ldbm errors when adding/modifying/deleting entries
-   Ticket 47393 - Attribute are not encrypted on a consumer after a full initialization
-   Ticket 47395 47397 v2 correct behaviour of account policy if only stateattr is configured or no alternate attr is configured
-   Ticket 47396 - crash on modrdn of tombstone
-   Ticket 47399 - RHDS denies MODRDN access if ACI list contains any DENY rule
-   Ticket 47400 - MMR stress test with dna enabled causes a deadlock
-   Ticket 47402 - Attribute names are incorrect in search results
-   Ticket 47405 - CVE-2013-2219 ACLs inoperative in some search scenarios
-   Ticket 47409 - allow setting db deadlock rejection policy
-   Ticket 47410 - changelog db deadlocks with DNA and replication
-   Ticket 47419 - Unhashed userpassword can accidentally get removed from mods
-   Ticket 47421 - memory leaks in set\_krb5\_creds
-   Ticket 47424 - Replication problem with add-delete requests on single-valued attributes
-   Ticket 47427 - Overflow in nsslapd-disk-monitoring-threshold
-   Ticket 47428 - Memory leak in 389-ds-base 1.2.11.15
-   Ticket 47435 - Very large entryusn values after enabling the USN plugin and the lastusn value is negative.
-   Ticket 47441 - Disk Monitoring not checking filesystem with logs
-   Ticket 47449 - deadlock after adding and deleting entries
-   fix compiler warning (cherry picked from commit 904416f4631d842a105851b4a9931ae17822a107) (cherry picked from commit 3a5f8de21fba3656670b8ee35e020f159d4110db)
-   fix compiler warning in posix winsync code for posix\_group\_del\_memberuid\_callback (cherry picked from commit f440e039a5f2a7b2ea0dd087d8e91c554abc1be0)
-   Fix compiler warnings for Ticket 47395 and 47397
-   fix coverity 11895 - null deref - caused by fix to ticket 47392
-   Coverity Fixes (Part 1)
-   Coverity Fixes (Part 2)
-   Coverity Fixes (Part 3)
-   Coverity Fixes (Part 4)
-   Coverity Fixes (Part 5)
-   Coverity Fixes (Part 7)

