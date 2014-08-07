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

### Multi-master replication

For our Directory Server, multi-master means the ability to write to two or more masters at the same time, with automatic conflict resolution, as opposed to just having one master at a time with hot failover. This feature provides a highly available directory service for both read and write operations. Multi-master replication can be combined with simple and cascading replication scenarios to provide a highly flexible and scalable replication environment. You can also use fractional replication to restrict the attributes that are replicated (e.g. if you don't want certain data to be present on a replica).

### Microsoft Windows Synchronization

User, group, and password information can be synchronized with an Active Directory (2003 and 2008 32-bit and 64-bit) domain controller and with an NT4 domain controller.

### Powerful access control mechanism

The access control information is contained with the data (in operational attributes), which means that it is always available when the data is imported or restored from backup. Provides support for macros that dramatically reduce the number of access control statements used in the directory, and increase the scalability of access control evaluation. Supports the [Get Effective Rights operation](../design/get-effective-rights-design.html) allowing admins and data designers to perform "What If?" queries when designing the access control structure.

### SSL/TLS

Provides SSLv3/TLSv1 secure communications over the network including ciphers with up to 256-bit encryption. Clients can use certificates for authentication with flexible cert subject to LDAP identity mapping. Supports the LDAP startTLS operation allowing the use of crypto on a non-secure port. FDS uses [Mozilla NSS](http://www.mozilla.org/projects/security/pki/nss/) as the crypto engine.

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

