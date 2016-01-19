---
title: 389 Web UI Design Page
---


# 389 Directory Server Management Web Console
----------------------------------------------

{% include toc.md %} 

## Naming Candidates

-   389 Directory Management Console

-----------------------

## 389 Java Console Shortcomings

-   Rigid Configuration
-   Difficult to extend
-   “o=netscaperoot”/console layout not robust, too hostname centric, replication is only good for backup purposes – single point of console failure
-   Not network management friendly
-   Requires installing a client package (e.g. 389-console)
-   User experience is generally poor, features are not in sync with actual main 389-ds features.

---------------------------

## New Design Concepts

### Terminology

- Directory Server Instance: A single, operating instance of the ns-slapd binary. A server may only host a single instance of ns-slapd.
- Suffix: A naming backend, such as dc=example,dc=com. In the context of o=dmc, a suffix is a named backend which make exist on one or more instances.
- Domain: The o=dmc which contains all registered Directory Server instances and suffixes.

### “Floating” Configuration

-   Directory Management Configuration suffix “o=dmc” replaces “o=netscaperoot”
-   Seperation of host, domain and suffix specific configurations.
-   Can be replicated, and still fully functional on every system
-   Allows the DMC to administer all servers in the registered deployment simultaneously
-   Allows the DS server to be "brought into line" with the contents of o=dmc (Fast system repair, deployment and validation)
-   Local Admin/HTTP server will use config file to know which Configuration DS to use (see below): // wibrown may not be needed ... // mreynolds - it is needed!

### Configuration Synchronization

-   Synchronze key configuration settings
-   Enforce consistency throughout a domain
-   Customizable
    -   Select individual attributes(or all attrs) from particular cn=config entries
    -   Indexing
    -   Plugins
    -   Database settings
    -   etc...

### Administration Delegation

Grant "users" rights to manage part, or all, of o=dmc
    - Add aci's to the proper branches of o=dmc
    - Users will exist within o=dmc, allowing seperation of administrative accounts.
    - Users from within a suffix in the domain may be added to be able to administer the o=dmc domain.
    - Default roles for acis?

------------------------------

## Installation of DMC

-   Admin Server (http, rest389)
-   Directory Server instance with a single (initial) suffix of o=dmc. Backend tuning needs to be optimized for o=dmc functionality.
    - This instance only stores o=dmc - nothing else.  You need to create a new instance for entry data.
-   Every physical machine must have one, and only one, "Admin Server + Configuration Directory Server"

### New Tools

#### setup-ds-dmc.py

-   Based on setup-ds-rest
-   Creates the http server(Admin Server), and ...
-   Creates the DS instance
-   Creates a separate Configuration Directory Server for (o=dmc)
-   May create named suffixes for the domain.

#### register-ds-dmc.py

-   Registers an existing instance and suffixes with the local Configuration Server
-   Sanity checking of the suffix to validate if it exists already in the domain ...

#### slapd-master.py

-   dbus triggered backend to start / stop / restart instances when required.
-   // mreynolds - can we change the name of this?  **master** sounds like a replication term

#### o=dmc paintbrush

-   Well, if we are applying config, we need to use a tool to apply it broadly
-   paintbrush will check for o=dmc updates and apply them
-   Enforce local node consistentcy in cn=config

------------------------------

## Configuration Synchronization - Part 2

### Potential Issues

So to handle config changes that occur outside of the UI we can use what we discussed last night, something that runs very 24 hours(or whatever interval) and does the "direct" config comparison to double check if a server's config is out of sync - then mark any instances (using configversion, see below...) that need to be resync'ed in o=dmc(or auto resync, whatever).

### Overview
  
A Global Config with multiple profiles.  Each profile consists of the following:

- cn=config entry
- SSL
- suffix
- backend & indexes
- plugins*  (could be tricky, especially with custom plugins - could use config templates that can be updated manually?)
- schema?  (let DS replication handle it?)

Each "area" has a list of attributes that are synched(replaced).  Each profile has its own version, and in the global entry we store the current profile version that is in use(to be used by **paintbrush**)

Then there will be an option to select a profile and choose "sync now".

#### o=dmc Global Config Example

    dn: cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    configversion: <current profile config version>
    cn: global config

    dn: cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    configversion: <config version>
    cn: default_scheme

    dn: cn=config, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: config
    nsslapd-sizelimit: 10000
    nsslapd-schemacheck: on
    nsslapd-allow-anonymous-access: off
    nsslapd-errorlog-level: 0

    dn: cn=encryption, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: encryption
    nsSSLClientAuth: allowed
    sslVersionMin: TLS1.0

    dn: cn=suffix, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: nsContainer
    cn: suffix

    dn: cn="dc=example,dc=com", cn=suffix, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: dc=example,dc=com
    nsslapd-state: backend
    nsslapd-backend: userroot

    dn: cn=backend, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: nsContainer
    cn: backend

    dn: cn=userroot, cn=backend, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: userroot
    nsslapd-cachesize: -1
    nsslapd-cachememsize: 10485760
    nsslapd-readonly: off
    nsslapd-require-index: off
    nsslapd-directory: /var/lib/dirsrv/slapd-localhost/db/userroot
    nsslapd-dncachememsize: 10485760

    dn: cn=indexes, cn=userroot, cn=backend, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: nsContainer
    cn: indexes

    dn: cn=cn, cn=indexes, cn=userroot, cn=backend, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: nsIndex
    cn: cn
    nsSystemIndex: false
    nsIndexType: eq

    ...
    ...

    dn: cn=plugins, cn=default_profile, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: nsContainer
    cn: plugins

    dn: cn=MemberOf Plugin, cn=plugins, cn=default_scheme, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: MemberOf Plugin
    nsslapd-pluginEnabled: on
    memberofgroupattr: member
    memberofattr: memberOf

    dn: cn=Referential Integrity Plugin, cn=plugins, cn=default_scheme, cn=global config, cn=Directory Servers, o=dmc
    objectclass: top
    objectclass: extensibleObject
    cn: Referential Integrity Plugin
    referint-update-delay: 0
    referint-logchanges: 0
    referint-membership-attr: member
    referint-membership-attr: uniquemember
    referint-membership-attr: owner
    referint-membership-attr: seeAlso

    dn: cn=Auto Membership Plugin, cn=plugins, cn=default_scheme, cn=global config, cn=Directory Servers, o=dmc
    ...
    ...


#### Config Profiles

Many profiles are possible, and the uses are endless.  We could even provide/ship other profiles for things like:

- maintainance - puts all the servers in read only mode, etc
- debug - enable certain logging levels
- security alert - disable anonymous access, require SSL, put in read-only mode, etc.

Note - default profile must always undo what other profiles do(reset log levels, etc)  Maybe this is best left to the customer to implement, and we just provide the concept of creating new profiles.

####  Applying config

Once a "config-sync" server instance has the configuration applied, we update the config version in that instance entry:

     dn: cn=slapd-instA, cn=host1.example.com, ou=example.com, cn=servers, cn=Directory Servers, o=dmc
     configversion: <timestamp>

     or in:

     dn: cn=settings, cn=slapd-instA, cn=host1.example.com, ou=example.com, cn=servers, cn=Directory Servers, o=dmc
     configversion: <timestamp>

So when we notice a instance is behind(becuase it was off line), we know its needs to be updated.

Then "**paintbrush**" just needs to look at config version in each server instance config entry to know if it needs it's config area reset.  There are actually several "configversion" attributes that need to be checked.  The global config version, and profile config versions.  The global configversion refers to a profile's configversion, when the global version changes, we need to find the profile with that matching version number so we know which profile to apply.

## o=dmc Tree

![o=dmc tree](../../../images/marks_dmc_tree.svg "Directory Management Configuration Tree")





