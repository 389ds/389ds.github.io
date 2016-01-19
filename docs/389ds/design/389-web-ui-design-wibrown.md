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
-   Local Admin/HTTP server will use config file to know which Configuration DS to use (see below): // wibrown may not be needed ...

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
-   Directory Server instance with a single (initial) suffix of o=dmc. Backend should be very targeted in tunining, indcies for o=dmc functionality.
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

#### o=dmc paintbrush

-   Well, if we are applying config, we need to use a tool to apply it broadly
-   paintbrush will check for o=dmc updates and apply them
-   Enforce local node consistentcy in cn=config

------------------------------

## New configuration suffix:  “o=dmc” (Directory Management Configuration)

Lets consider a topology with two hosts:

-   master-a.example.com
-   master-b.example.com

And two suffixes:

-   dc=example,dc=com
-   dc=bazaar,dc=com

The final state of the installed system master-a would be:

![o=dmc tree](../../../images/o_dmc_configuration_tree.svg "Directory Management Configuration Tree")


The key element of this tree is the distinction between domain wide settings (cn=settings,o=dmc), per host (cn=settings,cn=HOSTNAME,cn=hosts,o=dmc) and per suffix (cn=settings,dc=example,dc=com,cn=suffixes,o=dmc).

Consider TLS or SSL settings. We want to enforce that all hosts in a domain have the same TLS and cipher policies. We may also want to enforce a global password policy over the domain and all suffixes.

Consider a single host. We may wish to configure it's backups or tasks individually from all other nodes. We also want to determine it's port, hostname, etc from all other nodes. Database cache values may also be tuned here.

Finally, the suffix. For example indcies should be consistent through all servers that serve the suffix, so we should configure them at the suffix level. Replication would be configured at the suffix level.

Remember, in a domain, that not all hosts in the domain need to serve a suffix in the domain. In our example, we may add a third suffix, dc=foo,dc=com, that is only served by master-a. This would be valid in this configuration.


### Configuration Servers (cn=Configuration Servers, o=dmc)

There is only one config server per server host. Hosts can have per host configuration defined for relevant attributes.

    cn=settings, cn=master-a.example.com, cn=hosts, o=dmc
    cn: master-a.example.com
    port: 3890
    securePort: 6360
    SecurityDir: /etc/dirsrv/slapd-configuration/

Some settings are domain wide. For example, encryption policy, or password policy.

    cn=settings, o=dmc

    security: on
    SSLVersionMin: TLS1.1
    SSLVersionMax: TLS1.2
    AuthMethod: SIMPLE, SASL
    AuthProtocol: LDAP, STARTTLS, etc
    AuthURLFarm:  <LDAP URL> <LDAP URL> ...   (used for console logins)
    ...

Suffixes can have settings that apply to them, such as indicies, some plugins and replication.

    dc=example,dc=com,cn=suffixes,o=dmc

    // Maybe there should be a cn=hosts container in the suffix to keep it neat?

    cn=master-a.example.com, dc=example,dc=com,cn=suffixes,o=dmc
    replicatesTo: master-b.example.com

    cn=master-b.example.com, dc=example,dc=com,cn=suffixes,o=dmc
    replicatesTo: master-a.example.com

    cn=settings, dc=example,dc=com, cn=suffixes, o=dmc
    backendType: ldbm
    ...

    cn=ATTR,cn=index,cn=settings, dc=example,dc=com, cn=suffixes, o=dmc
    nsIndexType: eq
    ...

Administrative users are placed into:

    cn=administrators,o=dmc

Permissions are granted through aci's, which refer to role groups in cn=roles,o=dmc. An example of this is cn=domain admin,cn=roles,o=dmc which would be equivalent to cn=Directory Manager for the purpose of o=dmc.

When we create a suffix in cn=suffixes,o=dmc, paintbrust would detect this change, and apply the new backend to the hosts that have been nominated to serve it. It would also apply the replication configuration to these hosts.


---------------------------

## HTTP/REST Server

// If we only allow one ns-slapd instance per server, then we don't need this. Because we only have one instance, lib389 auto discover will find it, and we know the backend will always be o=dmc.

Each Admin/HTTP Server will have a config file that it will use to know how to talk to the Configuration DS.

**dmc-adm.conf**

    port: 9830
    security: on
    SecurityDir: /etc/dirsrv/slapd-inst1/
    SSLVersionMin: TLS1.1
    SSLVersionMax: TLS1.2
    AuthMethods: SIMPLE, kerberos, ....
    AuthProtocol:  LDAP, STARTTLS (no LDAPS)
    LocalConfgServer: ldaps://host1.domain1.com:6360
    FailoverConfigServers: ???  ???  ???
    ...

*LocalConfigServer* is what the Admin Server uses to know which “Configuration Server” config to use.

-----------------------------

## UI Layout

 WARNING: I haven't edited this bit yet ...

-   Tasks
-   Configuration Servers
-   Directory Servers
-   Replication

### Tasks page
-   Start, Stop, Restart HTTP server
-   Security Management

### Configuration Servers Page

-   “Tree” listing the network structure (just like the existing console), but only listing the configuration servers
-   Might group this into the Directory Servers page/topology, but I'd like to somehow keep it separate.
-   Register to/with Remote Config Servers
-   Authentication LDAP URLS – ordered list of servers to search for console authentication
-   Administrators (cn=administrators, o=dmc)
    -   uid=admin, cn=administrators, cn=host1.domain1.com, ou=domain1.com, ou=Configuration Servers, o=dmc
    -   uid=admin-new york, cn=administrators, cn=host.domain2.com, ou=domain1.com, ou=Configuration Servers, o=dmc

### Directory Servers Page

-   “Tree” listing the network structure (domains/hosts) (just like the existing console)
    -   Create a new instances
    -   Synchronize Server Config?
        -   Indexing, limits, cache, etc
   
-   DS Instance Actions 
    - "Unopened" Instance:
        - Start/Stop/Restart
        - Backup/Restore
        - Unregister instance
        - Monitor/Stats?
        - Delete instance
        - Synch Configuration with another instance (to and from)
    - “Opened” Instance:
        - Server Configuration  
            - Global settings
            - Schema
            - Security
            - Password Policy
            - Disk Monitoring
            - Password Admins
            - Limits (size, time, idletimeout, etc)
            - etc.  
        - Plugins   
            - Add, delete, enable/disable, and configure plugins
        - Backend    
            - DB config/perf tuning
            - Suffix Management
            - Backup/Restore
            - Import/export
        - Replication 
            - Configure replication
            - Changelog
        - Logging & Monitoring 
            - Configure logging settings
            - Manage logs (force rotation, removal, etc)
            - View Logs
                - Reports
                - Integrate logconv.pl ?  


### Replication Page

-   Replication overview 
-   Configure/deploy replication across all registered servers in a single proceedure
    -   Select "instances"
    -   Specify instance role (master, hub, consumer)
    -   Specify suffix
    -   Define other configurations(fractional, attributes to strip/ignore, protocol timeouts, etc)
    -   Define Authentication(method + protocol)
    -   Initialize All (one click)
    -   Done!

--------------------


## Integration

This would use rest389, which heavily relies on lib389. Any python code that interacts with the ds would use lib389.

