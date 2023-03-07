---
title: "Roadmap"
---

# Directory Server Roadmap
--------------------------

The following describes what we would like to get done in various releases of Directory Server.  This is a living document, and RFE's could be added, removed, or shifted to and from different releases.

{% include toc.md %}


## Red Hat Directory Server 11
------------------------------

RHDS 11 refers to the 389-ds-base-1.4.x series in RHEL 8/CentOS 8. For example, the 389-ds-base-1.3.x releases were used in Red Hat Directory Server 10 on RHEL 7.


### What is new in 389-ds-base-1.4.1 (RHDS 11)
---------------------------------------------

### Enhanced Password Policy

We added the following new syntax checks:

- **Dictionary Checks** - The server uses the CrackLib dictionary for this check

- **Monotonic Sequence Checks** - You can define the maximum number of monotonic sequence characters that are allowed to be in a password. A monotonic sequence is a series of characters (numbers or letters) that are in order (forwards or backwards): **abcd, dcba, 1234, 4321**

- **Monotonic Sequence Set Checks** - You can define the maximum number of monotonic sequence characters that are allowed to appear more than once: abc9284abc

- **Consecutive Character Classes** - Maximum number of consecutive characters from the same class of characters (digits, alphas, specials, etc). If this is set to 4, then the following password would be rejected because it has 5 consecutive numbers (the digits class): **ajd83955_#**

- **Palindrome Check** - Checks if the password is a palindrome: **mattam, 1234321**

- **Bad word list** - A custom case-insensitive list of words separated by a space that can not appear in a password.

- **User attribute list** - A custom list of attributes to compare the password to in the user's entry.  These are typically **uid, mail, cn**, etc...

<br>

### New CLI tools

Instead of having to use *ldapmodify* to configure the server or use the old perl/shell scripts, we now have a new python CLI tool set.  


#### dscreate

Install an instance of directory server.  You can use an INF file for "silent" installations, or there is an *interactive* mode which promotes you for the minimum required settings.

#### dsctl

This tool is used to perform operations on the server, whether it's running or not.

- Remove an instance
- Start/Restart/Stop the server instance
- Perform backups and restores
- Export/Import of LDIF files
- Health check

#### dsconf

This tool handles all the online configuration of the server.  Many of the major configurations are now simplified into single steps

- Managing TLS/Certificates
- Managing replication
- Creating new suffixes, sub-suffixes, and chaining databases
- Managing password policy
- Schema
- Monitoring (server, replication, database, SNMP, logs)
- Etc...

#### dsidm

This is the identity/database content tool.  This is used to manage a variety of database users and groups

<br>

### New Web UI (Cockpit plugin)

We have a new web UI Cockpit plugin.  Now you can manage the server in Cockpit via a new plugin for the Directory Server.  Setting up things like Replication, databases, and monitoring have been greatly improved since the old Java console.

UPDATE - There is now an LDAP browser/editor in the UI.
<br>

## Red Hat Directory Server 12

RHDS 12 is based of off the 389-ds-base-2.x series.  RHDS 12.0 (389-ds-base-2.0) maps to RHEL/Centos 9.0, RHDS 12.1 (389-ds-base-2.1) to RHEL/Centos 9.1, etc

### Initial Phase of LMDB Support

We will be replacing the internal backend database library (libdb or sleepcat DB) with LMDB.  This will not be fully supported until 389-ds-base-3.0, but you can enable it in 389-ds-base-2.3 and play around with it, but it's not fully ready for production.

### Container Support

389-ds-base-2.x does work in Openshift and Docker.  See this [link]() for information on how to set it up.

### LDAP Editor/Browser in UI

This is now available, and is also being continuously backported to 389-ds-base-1.4.3 (Centos/RHEL)

### Concurrent Connection Improvements

Improvements are currently being made to improve performance  when handling 1000's of concurrent connections.  There is still more work to do, but it is improving...

### New Security Audit Log

There is a new log written in JSON that tracks BIND operations (failed and successful, account lockout/password policy, TCP errors, etc.  The JSON format allows easy parsing and handing off to other tools like Splunk for processing.  For more info see the [Design Page]()


<br>

## What is the future
---------------------------------------------

### Performance improvements!

This is always our goal, and we are making progress in this area by replacing the backend database and connection framework.  We want to improve the entry cache performance as well.  Replication performance improvement are on our radar, but this will probably take a while as replication is a delicate feature.

### REST Interface

Adding a REST interface to the database is a long-term goal.

### Self-Service Web Portal

A basic Flask web application that users can log into and update some of their information and password.  This is more of an exmaple, that people can use as they want and customize.  It will proably not be a fully supported feature (just like the old Directory Server Gateway for those who remember that).

