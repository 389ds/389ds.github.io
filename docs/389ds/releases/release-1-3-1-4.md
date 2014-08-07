---
title: "Releases/1.3.1.4"
---
389 Directory Server 1.3.1.4
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.4.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.4-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.4-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.4.tar.bz2)

### Highlights in 1.3.1.4

-   Default syntax plug-in was provided.
-   Performance was improved in ldapmodify.
-   Disk Monitoring was improved and stabilized.
-   Following issues in the replication were fixed.
    -   conflict resolution
    -   RUV inconsistency with the cached one
    -   Deadlock with DNA enabled
    -   Single-valued attribute handling
-   A bug that ACL Deny does not work with MODRDN was fixed.
-   An EntryUSN bug -- an unrealistic large entryusn value is returned -- was fixed.
-   Memory leaks in GSSAPI and connection were fixed

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

### Detailed Changelog since 1.3.1.3

-   Ticket 346 - version 4 Slow ldapmodify operation time for large quantities of multi-valued attribute values
-   Ticket 47339 - RHDS denies MODRDN access if ACI list contains any DENY rule
-   Ticket 47367 - ldapdelete returns non-leaf entry error while trying to remove a leaf entry
-   Ticket 47369 version2 - provide default syntax plugin
-   Ticket 47385 - Disk Monitoring is not triggered as expected.
-   Ticket 47392 - ldbm errors when adding/modifying/deleting entries
-   Ticket 47410 - changelog db deadlocks with DNA and replication
-   Ticket 47421 - memory leaks in set\_krb5\_creds
-   Ticket 47424 - Replication problem with add-delete requests on single-valued attributes
-   Ticket 47427 - Overflow in nsslapd-disk-monitoring-threshold
-   Ticket 47428 - Memory leak in 389-ds-base 1.2.11.15
-   Ticket 47435 - Very large entryusn values after enabling the USN plugin and the lastusn value is negative.

