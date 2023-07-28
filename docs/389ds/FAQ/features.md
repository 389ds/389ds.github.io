---
title: "Features"
---

# Features
----------

{% include toc.md %}

### Database

389 Directory Server uses the [Berkeley Database](http://www.oracle.com/database/berkeley-db/db/index.html) as its data store. This data store is very high performance and is transacted to ensure ACID data updates. 389 DS automatically detects if the data was not written cleanly and does a database restore at startup if necessary.

#### Multiple databases

Provides a simple way of breaking down your directory data to simplify the implementation of replication and chaining in your directory service. Import into one suffix without affecting the other suffixes.

### Multi-supplier replication

For our Directory Server, multi-supplier means the ability to write to two or more suppliers at the same time, with automatic conflict resolution, as opposed to just having one supplier at a time with hot failover. This feature provides a highly available directory service for both read and write operations. Multi-supplier replication can be combined with simple and cascading replication scenarios to provide a highly flexible and scalable replication environment. You can also use fractional replication to restrict the attributes that are replicated (e.g. if you don't want certain data to be present on a replica).

### Microsoft Windows Synchronization

User, group, and password information can be synchronized with an Active Directory (2003 and 2008 32-bit and 64-bit) domain controller and with an NT4 domain controller.

### Powerful access control mechanism

The access control information is contained with the data (in operational attributes), which means that it is always available when the data is imported or restored from backup. Provides support for macros that dramatically reduce the number of access control statements used in the directory, and increase the scalability of access control evaluation. Supports the [Get Effective Rights operation](../design/get-effective-rights-design.html) allowing admins and data designers to perform "What If?" queries when designing the access control structure.

### TLS

Provides TLSv1 secure communications over the network including ciphers with up to 256-bit encryption. Clients can use certificates for authentication with flexible cert subject to LDAP identity mapping. Supports the LDAP startTLS operation allowing the use of crypto on a non-secure port. FDS uses [Mozilla NSS](http://www.mozilla.org/projects/security/pki/nss/) as the crypto engine.

**NOTE: SSLv3 is considered insecure and has been deprecated.**

### [SASL](SASL_GSSAPI_Kerberos_Design "wikilink") - Simple Authentication and Security Layer

A method for adding authentication support to connection-based protocols. Especially useful in conjunction with Kerberos, allow the use of Kerberos credentials to authenticate to the directory.

### [Attribute encryption](Attribute_Encryption_Design "wikilink")

Allows individual sensitive attributes to be encrypted on disk for more security.

### On line configuration and management

Almost all server configuration and management can be done on line, over LDAP, including import/export/backup/restore - no downtime.

#### [Task invocation via LDAP](Task_Invocation_Via_LDAP "wikilink")

389 DS provides a special entry called cn=tasks,cn=config with several sub-entries for each type of task supported: cn=import; cn=export; cn=backup; cn=restore; cn=index. The creation of an entry under one of these sub-entries causes the directory server to invoke that operation. Parameters are passed to the operation as attributes in the entry (e.g. the name of the LDIF file to export to). Status information is reported as attributes in that entry allowing clients to query for task status and completion.

### Password Policy and Account Lockout

Allows you to define a set of rules that govern how passwords and user accounts are managed in the Directory Server. Password policy can be applied to the entire server, a subtree, or a single user, whatever granularity is desired.

### Account Inactivation

Allows the admin to inactivate an account, to prevent that user from being able to login to the system, while preserving the user's information for later use or re-activation.

### Chaining and referrals

Increases the power of your directory by storing a complete logical view of your directory on a single server while maintaining data on a large number of directory servers, transparently for clients. Chaining can be used in conjunction with entry distribution to distribute the entries in one suffix among many servers, so that one suffix can have the appearance of holding hundreds of millions of entries. For example, by using a hash of the userid, or an alphabetical range, or any number of schemes.

### Plug-in Interface

Allows developers to extend the functionality of the server using a well defined C/C++ interface. Many of the core features of the server (such as replication, access control, roles, et. al.) are implemented as plug-ins.

#### Data Interoperability Plugins

Allow the use of an RDBMS for the data source, or any other data source.

### High performance logging

Full access logging in production environments, with flexible log rotation policies, plus access log analysis tools. The error log level can be adjusted in a running server to provide very detailed information to debug problems in production systems with no downtime.

### Language handling

Out of the box, Directory Server correctly sorts 38 languages; you can use plug-in handlers for foreign languages that Directory Server does not already sort

### Resource-limits by bind DN

Gives you the power to control the amount of server resources allocated to search operations based on the bind DN of the client.

### Roles and Class of Service

Class of Service provides a very flexible virtual attribute mechanism which allows attribute values to be shared among many entries, including the indexing of those attributes for fast searching. Roles leverages this facility to provide a high performance grouping capability.

### Server Side Sorting

Allows search results to be sorted in any number of ways. By using this in conjunction with Virtual List View, this allows powerful GUI components to be built allowing users to scroll or page through search results.

### Virtual Views

The data can be stored in a flat DIT, and hierarchical views, based on properties of the entries, can be displayed. For example, a tree based on location, or employee status, or anything else.

### Directory Server Gateway/Phonebook

A web application that provides a search/query interface for directory server data. It allows administrators to add and modify data in the directory server via a simple HTML based interface, and allows users to "self service" their own data (e.g. so they can modify their password, or mobile number, or etc.).

### Directory Server Org Chart

A web application that shows the organizational chart of the user data in a tree like format. This tree is based on the manager attribute in each user's entry.

### [DSML Gateway](DSML_Gateway_Design "wikilink")

DSMLv2 is a SOAP/HTTP based protocol for communicating with directory services. 389 DS provides a gateway that runs apart from the server on a web or application server (such as Tomcat).

### Supported RFCS

Some relevant RFCs that Directory Server supports include:

-   [RFC 1274](https://www.ietf.org/rfc/rfc1274.txt) - The COSINE and Internet X.500 Schema
-   [RFC 1558](https://www.ietf.org/rfc/rfc1558.txt) - A String Representation of LDAP Search Filters
-   [RFC 1777](https://www.ietf.org/rfc/rfc1777.txt) - Lightweight Directory Access Protocol
-   [RFC 1778](https://www.ietf.org/rfc/rfc1778.txt) - The String Representation of Standard Attribute Syntax's
-   [RFC 1779](https://www.ietf.org/rfc/rfc1779.txt) - A String Representation of Distinguished Names
-   [RFC 1823](https://www.ietf.org/rfc/rfc1823.txt) - The LDAP Application Program Interface
-   [RFC 2222](https://www.ietf.org/rfc/rfc2222.txt) - Simple Authentication and Security Layer (SASL)
-   [RFC 2247](https://www.ietf.org/rfc/rfc2247.txt) - Using Domains in LDAP/X.500 Distinguished Names
-   [RFC 2251](https://www.ietf.org/rfc/rfc2251.txt) - Lightweight Directory Access Protocol (v3)
-   [RFC 2252](https://www.ietf.org/rfc/rfc2252.txt) - Lightweight Directory Access Protocol (v3): Attribute Syntax Definitions
-   [RFC 2253](https://www.ietf.org/rfc/rfc2253.txt) - Lightweight Directory Access Protocol (v3): UTF-8 String Representation of Distinguished Names
-   [RFC 2254](https://www.ietf.org/rfc/rfc2254.txt) - The String Representation of LDAP Search Filters
-   [RFC 2255](https://www.ietf.org/rfc/rfc2255.txt) - The LDAP URL Format
-   [RFC 2256](https://www.ietf.org/rfc/rfc2256.txt) - A Summary of the X.500(96) User Schema for use with LDAPv3
-   [RFC 2307](https://www.ietf.org/rfc/rfc2307.txt) - An Approach for Using LDAP as a Network Information Service
-   [RFC 2377](https://www.ietf.org/rfc/rfc2377.txt) - Naming Plan for Internet Directory-Enabled Applications
-   [RFC 2829](https://www.ietf.org/rfc/rfc2829.txt) - Authentication Methods for LDAP
-   [RFC 2830](https://www.ietf.org/rfc/rfc2830.txt) - Lightweight Directory Access Protocol (v3): Extension for Transport Layer Security
-   [RFC 2849](https://www.ietf.org/rfc/rfc2849.txt) - The LDAP Data Interchange Format (LDIF) - Technical Specification
-   [RFC 3377](https://www.ietf.org/rfc/rfc3377.txt) - Lightweight Directory Access Protocol (v3): Technical Specification
-   [RFC 3673](https://www.ietf.org/rfc/rfc3673.txt) - LDAPv3: All Operational Attributes
-   [RFC 4527](https://www.ietf.org/rfc/rfc4527.txt) - Support for Read Entry Controls (pre and post read)


