---
title: "LDAPI Autobind DN Rewriter"
---

# LDAPI Autobind DN Rewriter
----------------

Overview
--------

LDAPI autobind allows to authenticate by mapping the effective UID and GID of a process to an LDAP entry.  Some UIDs and GIDs for system services are hard-coded and preallocated.  Others are assigned randomly when a service is installed.  In a replication environment you can not rely on UIDs/GIDs being consistent across all the replicas.  In those cases we need local (server specific) mappings for UID/GID to an LDAP entry.


Design
------

Add two new LDAPI mapping entries that maps a UID/GID to a specific DN in the database.  At startup the server will look through the new a new configuration settings for the LDAPI DN *mapping base* subtree (**nsslapd-ldapiDNMappingBase**) for entries that contain objectclasses **nsLDAPIAuthMap/nsLDAPIFixedAuthMap**.  This is similar to **nsslapd-ldapientrysearchbase**, but this is only LDAPI mapping entries.  

The first LDAP Mapping entry (*nsLDAPIAuthMap*) is the "dynamic" mapping of a system username to whatver the system returns as its UID/GID.  The other mapping entry is a "fixed" mapping (*nsLDAPIFixedAuthMap*) where the UID/GID is hardcoded into the mapping entry.

The *Dynamic* mapping works like this.  The dynamic mapping entries will contain the system user name (**nsslapd-ldapiUsername**) and the LDAP DN of the entry it should be mapped to.  The server will take the configured system username and find the UID/GID (via getpwnam) which it will store in an in-memory mapping structure.  This design allows for these mapping entries to also be replicated because there is nothing system specific about them, it's the server that will set the UID/GID locally.

The *Fixed* mapping takes a hard coded uidNumber and gidNumber and maps that to a specifc LDAP entry via **nsslapd-authenticateAsDN**.  Then this mapping is added the in-memory mapping structure. 


Since this configuration is only processed at server startup if you add, modify, or delete an LDAPI mapping entry you must restart the server for that change to take effect.


Implementation
--------------

Here is an example of a possible configuration.

    dn: cn=config
    nsslapd-ldapilisten: on
    nsslapd-ldapifilepath: /var/run/slapd-standalone1.socket
    nsslapd-ldapiautobind: on
    nsslapd-ldapimaptoentries: on
    nsslapd-ldapiDNMappingBase: cn=auto_bind,dc=example,dc=com

    dn: cn=dynamic example,cn=auto_bind,cn=config
    objectclass: top
    objectclass: nsLDAPIAuthMap
    cn: dyanmic example
    description: Take the system user bind-dyndb-ldap and find whatever the OS has set for its UID/GID, and then map that uid/gid to the ldap entry
    nsslapd-ldapiUsername: bind-dyndb-ldap
    nsslapd-authenticateAsDN: krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com
    
    dn: cn=fixed example,cn=auto_bind,cn=config
    objectclass: top
    objectclass: nsLDAPIFixedAuthMap
    cn: fixed example
    description: Map system user with this UID/GID to nsslapd-authenticateAsDN entry
    uidNumber: 25
    gidNumber: 25
    nsslapd-authenticateAsDN: krbprincipalname=DNS/server222.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com

In the **dynamic** example, an LDAPI connection from system user **bind-dyndb-ldap** would then get mapped to a LDAP DN and bind as **krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com**.

In the **fixed** case, we take whatever system user that has uid/gid of 25 and map it to **krbprincipalname=DNS/server222.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com**


Origin
-------------

<https://pagure.io/freeipa/issue/8544>

<https://github.com/389ds/389-ds-base/issues/4381>

Author
------

<mreynolds@redhat.com>

