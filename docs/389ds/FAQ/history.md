---
title: "History"
---

# History
---------

Introduction
------------

The Directory Server project dates back to 1996, when Netscape hired the inventor of LDAP, Tim Howes, and his colleagues such as Mark Smith and Gordon Good from the University of Michigan. In 1999 AOL acquired Netscape and formed the iPlanet Alliance with Sun to jointly develop Netscape servers. From 1999 to 2001 the Netscape Directory Server team worked with Sun's Directory Server team, and later the Innosoft Directory Server (IDDS) team, in the U.S. in Santa Clara, CA and Austin, TX and in Grenoble, France on Directory Server and related products such as Meta Directory and Directory Access Router. The iPlanet alliance ended in October 2001, and Sun and Netscape forked the code base. From 2001 to 2004 the Netscape Directory Server team invested heavily on performance and multisupplier replication. In December 2004, the Netscape Directory Server was acquired by Red Hat.

In the late 1990s, as Linux started to gain acceptance in companies, Netscape Directory Server was the first Netscape server to be officially released on Linux. In 2001 there was an effort at AOL's Strategic Business Solutions unit to improve Netscape server performance on Red Hat Linux. The team has a long history with Linux.

Feature History
---------------

### Features Present in 2001

-   Multi-Supplier Replication (2-way)
-   Multiple, Disjoint Database backends (independent import, export, etc.)
-   Access control mechanism - in-tree (with data); advanced features (userattr); macro ACIs; proxy ACIs
-   SSLv3/TLSv1 - LDAP startTLS operation
-   On line configuration and management - cn=config, tasks
-   Chaining, entry distribution
-   Password Policy - password expiration/lockout, different hashes, some syntax checking
-   Account Inactivation
-   Roles
-   Class of Service
-   Resource-limits by bind DN
-   Server Side Sorting
-   Virtual List View
-   Logging - high performance, rotation
-   Plug-in interface
-   Pass Through Authentication

### Features added in Netscape DS 6.1 (2002)

-   Plug-ins - Data Interoperability support
-   Virtual DIT Views

### Features added in Netscape DS 6.2 (2003)

-   Multi-Supplier Replication (4-way)
-   Password Policy - per-user, per-subtree
-   Upgrade to Berkeley DB 4.1
-   Org Chart application

### Features added in Netscape DS 6.21 (early 2004)

-   Access Control - Get Effective Rights operation (no UI)

### Features added in Netscape DS 7.0 (late 2004 - unreleased)

-   Attribute Encryption
-   64 Bit support (Solaris, HP-UX)
-   DSML Gateway
-   SASL/Kerberos
-   Write performance improvements - new IDL

### Features added in Fedora DS 7.1 (June 1, 2005 - first open source release)

-   Windows Sync
-   Multi-Supplier Replication - WAN improvements, fractional replication (attributes), replica init from database backup
-   Password Change operation
-   Console UI support for Get Effective Rights
-   RPM packaging

### Features added in Fedora DS 1.0 (December 8, 2005)

-   All open source
-   Apache HTTPD for Admin Server
-   Security - Support SHA-256, SHA-384, SHA-512, and MD5 for hashed password storage
-   Support for Fedora Core 4 (32 and 64 bit)

### Features added in Fedora DS 1.0.2 (February 20, 2006)

-   Support for Fedora Core 5 (32 and 64 bit)
-   Password policy - improved syntax checking (\# of uppercase, \# of lowercase, etc.)

### Features added in Fedora DS 1.0.3 (October 10, 2006)

-   Server can generate new password with password change extended operation
-   Upgrade to NSPR 4.6.3, NSS 3.11.3, LDAPCSDK 6.0.0 (with sasl/ipv6 support)
-   One step build uses system cyrus-sasl, net-snmp where possible

### Features added in Fedora DS 1.0.4 (November 8, 2006)

-   No new features, just a couple of bug fixes

### Features added in Fedora DS 1.2.0 - April 3, 2009

-   [Automatically maintained memberOf attribute](design/memberof-plugin.html)
-   [Server-side LDAPI support (LDAP over a UNIX domain socket)](FAQ/ldapi-and-autobind.html)
-   [Distributed Numeric Assignment (for auto-incrementing uid/gid across multi-supplier replication)](design/dna-plugin.html)
    -   Note that this feature is already in Fedora DS 1.1 but it is not documented
-   [Server to Server connection improvements (startTLS, SASL, Kerberos)](design/server-to-server-conn.html)
-   [Get Effective Rights for non-present attributes](design/get-effective-rights-for-non-present-attributes.html)
-   [Expose Password Policy via SLAPI](design/password-policy-api.html)
-   [Expose Task interface via SLAPI & improve API](design/slapi-task-api.html)
-   [Dynamically reload Schema via Task Interface](design/dynamically-reload-schema.html)
-   [64-bit counters](design/64-bit-counters-design.html)

### Features added in 389 DS 1.2.1 - August 17, 2009

NOTE: This is the first release that is branded as **389**. All of the RPMs have been marked as obsoleting their Fedora DS counterparts. When upgrading via yum, you must use yum **upgrade** (not update) so that the obsoletes will be processed.

NOTE: **389-console** is the command to run the console. This replaces fedora-idm-console.

-   [Support links between two attributes](design/linked-attributes-design.html) (like memberOf but with other/configurable attributes)
-   Support dereferencing control - <http://www.openldap.org/devel/cvsweb.cgi/~checkout~/doc/drafts/draft-masarati-ldap-deref-xx.txt>
-   [Simple paged results](design/simple-paged-results-design.html) - <http://www.ietf.org/rfc/rfc2696.txt>
-   [Entry USN](design/entry-usn.html) - sort of like a per entry CSN
-   [Use thread aware library for complex regex searches](FAQ/thread-aware-regex.html)
-   [Syntax validation checking](design/syntax-validation-design.html)
    -   NOTE that syntax validation is off by default in 1.2.1
    -   There is a new syntax validate task and script that can be used to validate data in an existing server
-   Support additional standard attribute syntaxes
    -   Numeric String, Bit String, Delivery Method, Enhanced Guide, Facsimile Telephone Number, Fax, Guide, Name And Optional UID, Printable String, Teletex Terminal Identifier, Telex Number
    -   NOTE that 1.2.1 does not change the schema to use any of these syntaxes yet. That will come when we update to the current versions of the standard schema from the LDAP RFCs.
-   Strict DN Syntax enforcement
    -   The DN syntax has become more restrictive over time, and the current rules are quite strict. Strict adherence to the rules defined in RFC 4514, section 3, would likely cause some pain to client applications. Things such as spaces between the RDN components are not allowed, yet many people use them still since they were allowed in the previous specification outlined in RFC 1779.
    -   To deal with the special circumstances around validation of the DN syntax, a configuration attribute is provided named nsslapd-dn-validate-strict. This configuration attribute will ensure that the value strictly adheres to the rules defined in RFC 4514, section 3 if it is set to on. If it is set to off, the server will normalize the value before checking it for syntax violations. Our current normalization function was designed to handle DN values adhering to RFC 1779 or RFC 2253
-   Security Enhancements
    -   Add require secure binds switch
        -   This adds a new configuration attribute named nsslapd-require-secure-binds. When enabled, a simple bind will only be allowed over a secure transport (SSL/TLS or a SASL privacy layer). An attempt to do a simple bind over an insecure transport will return a LDAP result of LDAP\_CONFIDENTIALITY\_REQUIRED. This new setting will not affect anonymous or unauthenticated binds.
        -   The default setting is to have this option disabled.
-   [Support OpenLDAP client libs](howto/howto-use-openldap-clients-in-389.html) - allow the use of OpenLDAP client libs in addition to mozldap
    -   There is a new configure option --with-openldap that can be used to build the server with OpenLDAP instead of mozldap
    -   In 1.2.1, the default is still to use mozldap, but those hardy souls adventurous enough can try to build 389 with OpenLDAP
    -   More work is planned
-   Can now use SASL + TLS/SSL
    -   earlier versions had a limitation in that you could not use SASL encrypted I/O over a connection encrypted with TLS/SSL
    -   the SASL I/O layer has been reworked as a push-able NSPR I/O layer

### Features added in 389 DS 1.2.2 - August 26, 2009

This was a bug fix release - no new features.

### Features added in 389 DS 1.2.3 - October 7, 2009

-   Ability to set resource limits (sizelimit, timelimit, look through limit) specifically for anonymous connections
    -   This is useful when you want to have different limits for regular users and anonymous users
    -   Set the attribute **nsslapd-anonlimitsdn** in cn=config to the DN of the entry that you want to use as the "template" entry. This is a dummy entry that you have to create. Then you set whatever resource limits you want to apply to anonymous to that dummy entry, and those limits will apply to anonymous users.
-   Access based on the security strength of the connection
    -   There is a new ACI keyword - **minssf** - this allows you to set access control based on how secure the connection is
    -   There is a global server setting in cn=config - **nsslapd-minssf** - that allows you to reject operations based on how secure the connection is
-   Ability to shut off anonymous access
    -   This adds a new config switch in cn=config - **nsslapd-allow-anonymous-access** - that allows one to restrict all anonymous access. When this is enabled, the connection dispatch code will only allow BIND operations through for an unauthenticated user. The BIND code will only allow the operation through if it's not an anonymous or unauthenticated BIND.

### Features added in 389 DS 1.2.4 - November 4, 2009

-   Support for Salted MD5 (SMD5) hashes. These are supported for migration purposes only. You should not use SMD5 for new passwords - use SSHA256

### Features added in 389 DS 1.2.5 - January 13, 2010

-   [Named Pipe Log Script](howto/howto-use-named-pipe-log-script.html)
    -   provide script which allows you to replace one or all log files with a named pipe script to do circular buffering, filtering, notifications, etc.

-   [Plug-in Ordering](design/plugin-ordering.html)
    -   Allow the order that plug-ins are invoked in to be defined.

### Features added in 389 DS 1.2.6 - September 13, 2010

-   [Upgrade to New DN Format](howto/howto-upgrade-to-new-dn-format.html)
    -   in order to make sure DN valued attributes can be searched correctly, an upgrade will automatically fix these values in the database

-   [Replication Session Hooks](design/replication-session-hooks.html)
    -   API for plugins to intercept replication session at various points

-   [Managed Entries](design/managed-entry-design.html)
    -   Used, for example, to automatically create the user's group entry when adding a user entry

-   Subtree Rename and Entry Move (modifyDN with newSuperior)
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=429005>
    -   ability to rename a node that has children
    -   ability to move a node, with or without children, to another parent node

-   Security Enhancements
    -   [SELinux Policy](FAQ/selinux-policy.html)
        -   <https://bugzilla.redhat.com/show_bug.cgi?id=442228>

-   Matching rules
    -   support for all RFC 4517 matching rules (except the FirstComponent ones)

### Version 1.2.7

-   [One Way Active Directory Sync](howto/howto-one-way-active-directory-sync.html) - allow Windows Sync to go only from AD to DS, or only from DS to AD, instead of just the default bi-directional sync
-   [Use OpenLDAP instead of Mozilla LDAP](howto/howto-use-openldap-clients-in-389.html) - On Fedora 14 and later, the 389 packages are built with OpenLDAP instead of Mozilla LDAP
    -   On Fedora 14 and later, openldap is built with Mozilla NSS for crypto instead of OpenSSL
    -   Also includes all components such as admin server, adminutil, dsgw, and perl-Mozilla-LDAP
-   [Account Policy Design](design/account-policy-design.html) - keep track of last login, automatically disable unused accounts
-   [Move changelog](howto/howto-move-changelog.html) - the replication changelog has been moved into the main server database environment
-   [MemberOf Multiple Grouping Enhancements](design/memberof-multiple-grouping-enhancements.html) - Member Of supports multiple membership attributes
-   Coverity bug fixes - we ran Coverity over the 389-ds-base source code and fixed many of the reported issues
-   Allow the replication functionality to be built separately from the main server
-   Allow Class of Service (CoS) values to be merged - CoS values can be merged and create multi-valued attributes. One can append "merge-schemes" to the end of the cosAttribute value in a definition entry to allow values to be merged.
-   Merge 389 SELinux policy with base OS policy - there are too many inter-dependencies to have a separate policy module - starting with 1.2.7, the policy for 389 will be part of the base OS policy

### Version 1.2.8

Mostly bug fixes

### Version 1.2.9

-   Auto Membership - This allows one to define rules that can assign newly added entries to groups
    -   [Auto Membership Design](design/auto-membership-design.html)
-   More Coverity fixes

### Version 1.2.10

-   Latest 1.2.10 release is 1.2.10.14
-   Account Usability Control support
-   database transaction pre/post plugins
    -   Changelog writes use main database transaction
-   native systemd support
-   slapi\_rwlock support replaces direct NSPR PR\_RWLock support

### Version 1.2.11

-   Support multiple Simple Paged Result searches in a single connection [Simple Paged Results Design](design/simple-paged-results-design.html)
-   Support SASL/PLAIN
-   logconv.pl improvements
-   Support for Berkeley DB version 5
-   Improved support for transactions and backend transaction plugins
    -   DNA and USN use backend transaction plugins
    -   Allow most plugins to be backend transaction plugins (for testing)
-   Allow internal operations triggered by external operations (referential integrity, memberof, etc.) to use modifiersName/creatorsName from original external operation
    -   Added a new config attribute **nsslapd-plugin-binddn-tracking** to cn=config. It is off by default. If set to on, the server will update a set of new operational attributes: **internalModifiersname** & **internalCreatorsname**. These attributes will store the DN of the plugin that made the update, while modifiersname/creatorsname will now be the bind dn that initiated the original external operation. [Plugin Track Bind DN](design/plugin-track-bind-dn.html)
-   Windows Sync API version 3 [Windows Sync Plugin API](design/windows-sync-plugin-api.html)
    -   support for multiple winsync plugins
    -   support for plugin precedence
    -   support for pre DS to AD user and group ADD operation callbacks
    -   support for post operation callbacks
-   Ability to disable replication agreements
    -   **nsds5ReplicaEnabled** - if this is set to "off" in the replication agreement entry, the agreement will be disabled
-   CLEANRUV improvements [How to CLEANRUV](howto/howto-cleanruv.html)
    -   New CLEANALLRUV task
-   Disk monitoring [Disk Monitoring](design/disk-monitoring.html)
    -   Can enable monitoring of disk usage, particularly for databases and log files, with warnings upon reaching certain thresholds of disk usage
-   Allow setup to work with IPv6
-   Support of IPv6 addresses in plugins (acl, replication, chaining, etc)
-   Root DN Access Control Plugin [RootDN Access Control](design/rootdn-access-control.html)
-   Added ability to track the time when a password was last changed [Track Password Update](design/track-password-update.html)
-   Added ability to disable the legacy password policy behavior. PasswordMaxFailure doesn't behave as some newer LDAP clients might expect [Legacy Password Policy](design/legacy-password-policy.html)
-   Windows Sync - support for [WinSync  Posix](design/winsync-posix.html)
    -   NOTE: This version does not support ADD operations from DS to AD - POSIX attributes will not be synced - AD to DS works fine
-   Windows Sync - support for [WinSync Move Action](FAQ/winsync-move-action.html) - control how winsync processes out of scope AD entries

### Version 1.3.0

Version 1.3.0 of 389-ds-base adds the following new features:

-   [Transaction support for SLAPI plug-ins](design/plugin-transactions.html)
-   IPv6 address support for ACIs, replication agreements, and chaining agreements.
-   Normalized DN caching.

The full list of tickets addressed in version 1.3.0 is available at <https://fedorahosted.org/389/report/14>


2014

...
...


Initial Release
---------------

The initial release of Fedora Directory Server (version 7.1) was 6/1/2005. This included the source code to the complete Directory Server engine. It also included pre-built binaries (on selected platforms) for the admin server daemon and the console administration front-end, but not the source code for those. The entire product was open sourced on 12/1/2005 as Fedora Directory Server version 1.0 - see [Release Notes](release/release-notes.html) for more information about that release, which uses Apache as the admin server daemon. This was a week short of a year since Red Hat acquired the Directory Server from AOL, fulfilling the promise Red Hat made when it acquired the code to open source it within the year.

