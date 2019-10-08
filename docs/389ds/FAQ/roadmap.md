---
title: "Roadmap"
---

# Directory Server Roadmap
--------------------------

The following describes what we would like to get done in various releases of Directory Server.  This is a living document and RFE's could be added, removed, or shifted to and from different releases.

{% include toc.md %}


## Red Hat Directory Server 11
------------------------------

RHDS 11 refers to the 389-ds-base-1.4.x series in RHEL 8/CentOS 8. For example the 389-ds-base-1.3.x releases were used in Red Hat Directory Server 10 on RHEL 7.  So eventually REDS 12 (RHEL 9) will be the 1.5.x series.


## What is new in 389-ds-base-1.4.1 (RHDS 11)
---------------------------------------------

### Enhanced Password Policy

We added the following new syntax checks:

- **Dictionary Checks** - The server uses the CrackLib dictionary for this check

- **Monotonic Sequence Checks** - You can define the maximum number of monotonic sequence characters that are allowed to be in a password. A monotonic sequence is a series of characters (numbers or letters) that are in order (forwards or backwards): **abed, dcba, 1234, 4321**

- **monotonic Sequence Set Checks** - You can define the maximum number monotonic sequence characters that are allowed to appear more than once: abc9284abc

- **Consecutive Character Classes** - Maximum number of consecutive characters from the same class of characters (digits, alphas, specials, etc). If this is set to 4 then the following password would be rejected because it has 5 consecutive numbers (the digits class): **ajd83955_#**

- **Palindrome Check** - Checks if the password is a palindrome: **mattam, 1234321**

- **Bad word list** - A custom case-insensitive list of words separated by a space that can not appear in a password.

- **User attribute list** - A custom list of attributes to compare the password to in the user's entry.  These are typically **uid, mail, cn**, etc...

<br>

### New CLI tools

Instead of having to use *ldapmodify* to configure the server, or use the old perl/shell scripts, we now have a new python CLI tool set.  


#### dscreate

Install an instance of directory server.  You can use a INF file for "silent" installations, or there is a *interactive* mode which promotes you for the minimum required settings.

#### dsctl

This tool is used to perform operations on the server whether it's running or not.

- Remove an instance
- Start/Restart/Stop the server instance
- Perform backups and restores
- Export/Import of LDIF files

#### dsconf

This tool handles all the online configuration of the server.  Many of the major configurations are now simplified into single steps

- Managing TLS/Certificates
- Managing replication
- Creating new suffixes, sub-suffixes, and chaining databases
- Managing password policy
- Schema
- Monitoring (server, replication, database, SNMP, logs)
- Health Check
- Etc...

#### dsidm

This is the identity/database content tool.  This is used to manage a variety of database users and groups

<br>

### New Web UI (Cockpit plugin)

We have a new web UI Cockpit plugin.  Now you can manage the server in Cockpit via a new plugin for the Directory Server.  Setting up things like Replication, databases, and monitoring have been greatly improved since the old Java console.

WARNING - Currently there is no LDAP browser/editor in the UI.  For now, you need to use CLI tools, or other browsers like Apache Directory Studio, ldapvi, etc.  That being said, we do plan to add a generic browser/editor (more on this later).

<br>

## What is coming in 389-ds-base-1.4.next (REDS 11.x)
---------------------------------------------

- **Container support**(both openshift and docker).  In 389-d-base-1.4.2 (upstream) we do offer a docker file, and have many people successfully using it already.

- **New Backend** - We are working toward replacing the libdb (Sleepycat) database backend with LMDB (Lightning Memory-Mapped Database).  We expect greatly improved database performance, and entry cache improvements.

- **Self-Service Web Portal** - A basic Flask web application that users can log into and update some of their information and password.

- **TLS Database Password Protection** - We are adding a way to store the TLS/NSS database password so that it is not in clear text on the file system, but still accessible to the server.

- **Concurrent Connection Improvements** - A new connection framework is in the works that will allow much improved management of concurrent connections.

- **LDAP Editor for Web UI** - A simple, but versatile, LDAP browser/editor that will also include an improved ACI editor.

<br>

## What is the future
---------------------------------------------

### Performance improvements!

This is always our goal, and we are making progress in this area by replacing the backend database and connection framework.  We want to improve the entry cache performance as well.  Replication performance improvement are on our radar, but this will probably take a while as replication is a delicate feature.

### REST Interface

Adding a REST interface to the database is a long term goal.


