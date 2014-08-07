---
title: "Releases/1.3.2.2"
---
389 Directory Server 1.3.2.2
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.2.2.

Fedora packages are available from the Fedora 20 Testing repositories.

The new packages and versions are:

-   389-ds-base-1.3.2.2-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.2.tar.bz2)

### Highlights in 1.3.2.2

-   Support 'Content Synchronization Operation' (SyncRepl) - RFC 4533
-   Support "whoami" extended operation
-   Add ACI support for ldapi
-   WinSync enhancement
    -   support range retrieval
    -   support multiple subtrees and filters
-   Performance improvements
-   bug fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.1

-   Ticket 48 - Active Directory has certain uids which are reserved and will cause a Directory Server replica initialization of an AD server to abort.
-   Ticket 53 - Need to update supported locales
-   Ticket 54 - locale "nl" not supported by collation plugin
-   Ticket 77 - [RFE] Add ACI support for ldapi
-   Ticket 123 - Enhancement request: "whoami" extended operation
-   Ticket 153 - Schema file parsing overly picky?
-   Ticket 182 - Pwd retry counters replication not enabled by default, and enabling it could lead to undesired results
-   Ticket 197 - rhds82 rfe - BDB backend - clear free page files to reduce changelog size
-   Ticket 205 - rhds81 rfe - snmp counters index strings for multiple network interfaces with ip addr and tcp port pairs
-   Ticket 208 - [RFE] Roles with explicit scoping in RHDS
-   Ticket 283 - Expose slapi\_eq\_\* API
-   Ticket 314 - ChainOnUpdate: "cn=directory manager" can modify userRoot on consumer without changes being chained or replicated. Directory integrity compromised.
-   Ticket 411 - [RFE] mods optimizer
-   Ticket 415 - winsync doesn't sync DN valued attributes if DS DN value doesn't exist
-   Ticket 428 - posix winsync should support ADD user/group entries from DS to AD
-   Ticket 460 - support multiple subtrees and filters
-   Ticket 512 - improve performance of vattr code
-   Ticket 513 - recycle operation pblocks
-   Ticket 514 - investigate connection locking
-   Ticket 521 - modrdn + NSMMReplicationPlugin - Consumer failed to replay change
-   Ticket 564 - Is ldbm\_txn\_ruv\_modify\_context still required ?
-   Ticket 568 - using transaction batchval violates durability
-   Ticket 569 - examine replication code to reduce amount of stored state information
-   Ticket 586 - selinux errors with /usr/sbin/setup-ds-admin.pl
-   Ticket 589 - [RFE] Support RFC 4527 Read Entry Controls
-   Ticket 601 - multi master replication allows schema violation
-   Ticket 602 - replication inconsistency if attribute is modified several times in one operaion
-   Ticket 607 - Replication issue: Entry can diverge betwen servers
-   Ticket 609 - nsDS5BeginReplicaRefresh attribute accepts any value and it doesn't throw any error when server restarts.
-   Ticket 615 - High contention on cos cache lock
-   Ticket 617 - Possible to add invalid ACI value
-   Ticket 626 - Possible to add nonexistent target to ACI
-   Ticket 630 - The backend name provided to bak2db is not validated
-   Ticket 47306 - execute index\_add\_mods only for indexed attributes
-   Ticket 47310 - Attribute "dsOnlyMemberUid" not allowed when syncing nested posix groups from AD with posixWinsync
-   Ticket 47313 - Indexed search with filter containing '&' and "!" with attribute subtypes gives wrong result
-   Ticket 47314 - Winsync should support range retrieval
-   Ticket 47316 - Search against 'view' is always reported as unindexed
-   Ticket 47317 - should set LDAP\_OPT\_X\_SASL\_NOCANON to LDAP\_OPT\_ON by default
-   Ticket 47319 - make connection buffer size adjustable
-   Ticket 47320 - put conn on work\_q not poll list if conn has buffered more\_data
-   Ticket 47323 - resurrected entry is not correctly indexed
-   Ticket 47326 - idl switch does not work
-   Ticket 47329 - Improve slapi\_back\_transaction\_begin() return code when transactions are not available
-   Ticket 47331 - Self entry access ACI not working properly
-   Ticket 47337 - mep\_pre\_op: Unable to fetch origin entry
-   Ticket 47340 - Deleting a separator ',' in 7-bit check plugin arguments makes the server fail to start with segfault
-   Ticket 47350 - Allow search to look up 'in memory RUV'
-   Ticket 47354 - Indexed search are logged with 'notes=U' in the access logs
-   Ticket 47358 - backend performance - introduce optimization levels
-   Ticket 47360 - Delete attribute could crash the server
-   Ticket 47363 - 7-bit checking is not necessary for userPassword
-   Ticket 47370 - DS crashes with some 7-bit check plugin configurations
-   Ticket 47371 - Some updates of "passwordgraceusertime" are useless when updating "userpassword"
-   Ticket 47372 - make old-idl tunable
-   Ticket 47381 - nsslapd-db-transaction-batch-val turns to -1
-   Ticket 47382 - Add a warning message when a connection hits the max number of threads
-   Ticket 47384 - Plugin library path validation
-   Ticket 47387 - improve logconv.pl performance with large access logs
-   Ticket 47388 - [RFE] Support 'Content Synchronization Operation' (SyncRepl) - RFC 4533
-   Ticket 47389 - Non-directory manager can change the individual userPassword's storage scheme
-   Ticket 47394 - remove-ds.pl should remove /var/lock/dirsrv
-   Ticket 47400 - MMR stress test with dna enabled causes a deadlock
-   Ticket 47411 - Replace substring search with plain search in referint plugin
-   Ticket 47416 - IPA replica's - "SASL encrypted packet length exceeds maximum allowed limit"
-   Ticket 47423 - 7-bit check plugin does not work for userpassword attribute
-   Ticket 47425 - should only call windows\_update\_done if repl agmt type is windows
-   Ticket 47426 - move compute\_idletimeout out of handle\_pr\_read\_ready
-   Ticket 47433 - With SeLinux, ports can be labelled per range. setup-ds.pl or setup-ds-admin.pl fail to detect already ranged labelled ports
-   Ticket 47463 - IDL-style can become mismatched during partial restoration
-   Ticket 47487 - enhance retro changelog
-   Ticket 47490 - Schema replication between DS versions may overwrite newer base schema
-   Ticket 47502 - updates to ruv entry are written to retro changelog
-   Ticket 47504 - idlistscanlimit per index/type/value
-   Ticket 47505 - get rid of valueset\_add\_valuearray\_ext
-   Ticket 47513 - tmpfiles.d references /var/lock when they should reference /run/lock
-   Ticket 47517 - memory leak in range searches and other various leaks
-   Ticket 47520 - Fix various issues with logconv.pl
-   Ticket 47522 - Password administrators should be able to violate password policy
-   Ticket 47531 - 1.3.2 with mozldap - need to redo sasl\_io\_recv
-   Ticket 47532 - 1.3.2 with mozldap - crashes in new operation work\_q
-   Ticket 47539 - Disabling DNA plug-in throws error 53
-   Ticket 47543 - mozldap - fix compiler warnings
-   Ticket 47551 - logconv: -V does not produce unindexed search report
-   Ticket 47550 - logconv: failed logins: Use of uninitialized value in numeric comparison at logconv.pl line 949
-   ticket 47550 - wip (cherry picked from commit 82377636267787be5182457d619d5a0b662d2658)

