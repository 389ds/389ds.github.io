---
title: "Releases/1.3.1.0"
---
389 Directory Server 1.3.1.0
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.0.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.0-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.0-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.1.0.tar.bz2)

### Highlights in 1.3.1.0

-   Plug-in Transaction Support
-   Normalized DN Cache
-   Configurable Allowed SASL Mechanisms
-   SASL Mapping Improvements
-   Configurable SASL Buffer
-   Replication Retry Settings
-   Instance Script Improvements
-   Access Log Analyzer Improvements
-   Performance improvements

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

### Detailed Changelog since 1.3.0.6

-   Ticket 332 - Command line perl scripts should attempt most secure connection type first
-   Ticket 342 - better error message when cache overflows
-   Ticket 417 - RFE - forcing passwordmustchange attribute by non-cn=directory manager
-   Ticket 419 - logconv.pl - improve memory management
-   Ticket 422 - 389-ds-base - Can't call method "getText"
-   Ticket 433 - multiple bugs in start-dirsrv, stop-dirsrv, restart-dirsrv scripts
-   Ticket 458 - RFE - Make it possible for privileges to be provided to an admin user to import an LDIF file containing hashed passwords
-   Ticket 471 - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   Ticket 487 - Possible to add invalid attribute values to PAM PTA plugin configuration
-   Ticket 502 - setup-ds.pl script should wait if "semanage.trans.LOCK" presen
-   Ticket 505 - use lock-free access name2asi and oid2asi tables (additional)
-   Ticket 508 - lock-free access to FrontendConfig structure
-   Ticket 511 - allow turning off vattr lookup in search entry return
-   Ticket 525 - Introducing a user visible configuration variable for controlling replication retry time
-   Ticket 528 - RFE - get rid of instance specific scripts
-   Ticket 529 - dn normalization must handle multiple space characters in attributes
-   Ticket 532 - RUV is not getting updated for both Master and consumer
-   Ticket 533 - only scan for attributes to decrypt if there are encrypted attrs configured
-   Ticket 534 - RFE: Add SASL mappings fallback
-   Ticket 537 - Improvement of range search
-   Ticket 539 - logconv.pl should handle microsecond timing
-   Ticket 543 - Sorting with attributes in ldapsearch gives incorrect result
-   Ticket 545 - Segfault during initial LDIF import: str2entry\_dupcheck()
-   Ticket 547 - Incorrect assumption in ndn cache
-   Ticket 550 - posix winsync will not create memberuid values if group entry become posix group in the same sync interval
-   Ticket 551 - Multivalued rootdn-days-allowed in RootDN Access Control plugin always results in access control violation
-   Ticket 552 - Adding rootdn-open-time without rootdn-close-time to RootDN Acess Control results in inconsistent configuration
-   Ticket 558 - Replication - make timeout for protocol shutdown configurable
-   Ticket 561 - disable writing unhashed\#user\#password to changelog
-   Ticket 563 - DSCreate.pm: Error messages cannot be used in the if expression since they could be localized.
-   Ticket 565 - turbo mode and replication - allow disable of turbo mode
-   Ticket 571 - server does not accept 0 length LDAP Control sequence
-   Ticket 574 - problems with dbcachesize disk space calculation
-   Ticket 583 - dirsrv fails to start on reboot due to /var/run/dirsrv permissions
-   Ticket 585 - Behaviours of "db2ldif -a <filename>" and "db2ldif.pl -a <filename>" are inconsistent
-   Ticket 587 - Replication error messages in the DS error logs
-   Ticket 588 - Create MAN pages for command line scripts
-   Ticket 600 - Server should return unavailableCriticalExtension when processing a badly formed critical control
-   Ticket 603 - A logic error in str2simple
-   Ticket 604 - Required attribute not checked during search operation
-   Ticket 608 - Posix Winsync plugin throws "posix\_winsync\_end\_update\_cb: failed to add task entry" error message
-   Ticket 611 - logconv.pl missing stats for StartTLS, LDAPI, and AUTOBIND
-   Ticket 612 - improve dbgen rdn generation, output
-   Ticket 613 - ldclt: add timestamp, interval, nozeropad, other improvements
-   Ticket 616 - High contention on computed attribute lock
-   Ticket 618 - Crash at shutdown while stopping replica agreements
-   Ticket 620 - Better logging of error messages for 389-ds-base
-   Ticket 621 - modify operations without values need to be written to the changelog
-   Ticket 622 - DS logging errors "libdb: BDB0171 seek: 2147483648: (262144 \* 8192) + 0: No such file or directory
-   Ticket 631 - Replication: "Incremental update started" status message without consumer initialized
-   Ticket 633 - allow nsslapd-nagle to be disabled, and also tcp cork
-   Ticket 47299 - allow cmdline scripts to work with non-root user
-   Ticket 47302 - get rid of sbindir start/stop/restart slapd scripts
-   Ticket 47303 - start/stop/restart dirsrv scripts should report and error if no instances
-   Ticket 47304 - reinitialization of a master with a disabled agreement hangs
-   Ticket 47311 - segfault in db2ldif(trigger by a cleanallruv task)
-   Ticket 47312 - replace PR\_GetFileInfo with PR\_GetFileInfo64
-   Ticket 47315 - filter option in fixup-memberof requires more clarification
-   Ticket 47325 - Crash at shutdown on a replica aggrement
-   Ticket 47330 - changelog db extension / upgrade is obsolete
-   Ticket 47336 - logconv.pl -m not working for all stats
-   Ticket 47341 - logconv.pl -m time calculation is wrong
-   Ticket 47343 - 389-ds-base: Does not support aarch64 in f19 and rawhide
-   Ticket 47347 - Simple paged results should support async search
-   Ticket 47348 - add etimes to per second/minute stats
-   Ticket 47349 - DS instance crashes under a high load

