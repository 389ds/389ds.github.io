---
title: "Wishlist"
---

# Wishlist
----------

This page contains features we'd like to see in the project. Can you help?

Core Server Features
--------------------

### Replication

-   Simplified replication setup
-   Option to monitor stats about busy time, time (min/max/avg) of supplier push connection and number of updates for each replicas of replication process
-   Option for Windows Sync service to bind a secondary (and rotate to more DS) Directory Server if the first is out of service (in multi-master replication architecture)

### IPA Needs

-   Allow namespace uniqueness across user's uid attribute and group's cn attributes. And similar functionality across uidNumber and gidNumber. There should be a way to switch the enforcement of and on with some kind of a configuration attribute or command.
-   Find a solution for the problem of name collisions when entries with same name are created on different servers.

### AD Integration Alignment

-   Support of atomic operations and transactions preventing creation of the inconsistent entries.

### Windows Sync

-   WinSync - support password and account policy sync
    -   NOTE: account enable/disable sync supported in IPA 1.1
    -   Password expiration time
    -   Failed login attempts
    -   Account lockout
    -   Account unlock time
    -   Password min/max length
    -   Explore others, e.g. password syntax, password strength, last login time, last logout time, etc.

### Standards

-   LDAP Transactions

### Security

-   Allow server to listen \_only\_ to LDAPI (e.g. shut off LDAP and LDAPS access)
-   Password Policy
    -   Quality - specify a list of regexp that the password must match in order to be valid
        We could have a multi-valued attribute called passwordRegexp whose values are regular expressions to match against the password
    -   Dictionary - specify a list of text files to use for dictionary lookups
        We could have a multi-valued attribute called passwordDictionary whose values are the pathnames of files to use as dictionaries (e.g. /usr/share/dict/words)
    -   Extra credit - use the server itself as the dictionary (need schema for dictionary)

### Community/Project Enhancements

-   Open source test suites
-   Add DS to Debian - other distros?

### Other

-   Account Policy [Account Policy Design](design/account-policy-design.html)
    -   Keep track of last login time
    -   Automatically disable account after some period of unuse
-   Improve referential integrity plug-in with MMR
-   Dynamic Group Expansion - define dynamic group and have members appear when searched
    -   This is sort of like memberOf in reverse
    -   Should allow creation of a dynamic posix group - but when the posix client searches the group for member/uniqueMember, the members magically appear
    -   Users like the ease of use of dynamic group definition, but many/most posix clients cannot follow the dynamic group definition URL/search params to dynamically populate the group
-   Support special attribute '+' in search attribute list
    -   '+' means all operational attributes (like '\*' means all regular attributes)
-   Support using objectclass name in search attribute list
    -   e.g. <em>ldapsearch ... :inetOrgPerson</em> will return all allowed attributes of the inetOrgPerson objectclass
-   Samba NT/LM password sync (IPA pwd extop plug-in "lite")
-   OpenLDAP SyncRepl support
-   Quality of Service - ability to provide different levels of service for different clients
    -   different connection pools for search, update, replication clients
    -   have connections available for priority clients e.g. directory manager can always open a connection
-   epoll support
    -   or see if async network I/O or other new technologies are available
-   Move global configuration information that affects all nodes equally from file to the database. Replicate changes to this information.
-   Null Suffix Support - ability to do one level and subtree searches with base ""
    -   Need configuration to specify which suffixes to include/exclude from this type of search e.g. defaultSearchBase
-   Class of Service based on client hostname/IP address
    -   We've had several requests for something like this:
    -   when user logs into machineA, want to have attribute N set to value Y - but when user logs into machineB, want to have attribute N set to value Z
-   Access control for extended operations
    -   It would be nice to be able to apply ACIs to extended operations. You would then be able to restrict who can perform a particular extended operation (or restrict to particular IPs, etc.).

Database
--------

-   Database integrity checking (and repair) tool
-   Fine grained database access/locking - lock per entry or per attribute rather than entire database
    -   Reason - increase write performance by reducing lock contention
    -   Also investigate berkeley db Level 2 Isolation, other features
-   Do not store DN or DN values with entry data - have lookup table to map from entry GUID to DN
    -   Will help with entry move/subtree rename (MOD DN operations)
    -   Will help with referential integrity

Samba Support
-------------

The full up-to-date list is here - [<http://wiki.samba.org/index.php/Samba4/LDAP_Backend>](http://wiki.samba.org/index.php/Samba4/LDAP_Backend)

### Passwords

Support several different kinds of password encryption/hashing:

-   all of the Kerberos KDC types
    -   heimdal is slightly different than MIT
-   NT (utf8-uc2-md4)
-   LM (des)

### Extensions

-   Schema - MS supports aggregate (RFC 2252) and exploded schema entries - the exploded entries have more attributes than the standard - use X-XXXX to support non-standard schema elements in aggregate schema - perhaps virtual exploded schema?
-   Operational attribute that lists which attributes are writable - sort of like our GetEffectiveRights operation
-   Need ability to specify and ordering for attribute values or the ability to retrieve attributes values in a certain order - control? attr subtype?
-   Need ability to retrieve the MS extended DN with the GUID and SUID in the DN
-   Slapi plugins extension to be able to mark some modification as "not to be checked against the ACIs", this will allow to add modifications to an entry in a pre-op plugin that the identity performing the original operation would not normally be able to touch and that the plyugin have authority to generate.

Console Features
----------------

In addition to support for core server features mentioned above:

-   Replace the Java based Management Console with a web-based framework
-   Option to automatically create posixAccount and/or shadowAccount users
-   Add host based access control to posixAccount attributes (e.g. a list of hostnames to which the user is allowed login access)
-   Although 389 1.1 and later can auto-increment uidNumber and gidNumber, the console should allow the admin to override this and assign specific numbers
-   Support for netgroups
    -   Allow netgroups management from the console
    -   allow the admin to specify netgroups to add a new user to
-   Support for autofs maps
-   allow in the 389 Console to switch to other instance to search entries

