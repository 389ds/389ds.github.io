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

Add a new LDAPI mapping entry that maps a UID/GID to a specific DN in the database.  At startup the server will look through the new a new configuration settings for the LDAPI DN mapping base subtree (**nsslapd-ldapiDNMappingBase**) for entries that contain objectclass **nsLDAPIAuthMap**.  This is similar to **nsslapd-ldapientrysearchbase**, but this is only LDAPI mapping entries.  Those new mapping entries will contain the system user name (**nsslapd-ldapiUsername**) and the LDAP DN of the entry it should be mapped to(**nsslapd-authenticateAsDN**).  The server will take the configured system username and find the UID/GID (via getpwnam) that is associated with it and store it in a in-memory mapping structure.  This approach can also handle cases when UID/GID assignment is dynamic (e.g. systemd dynamic users).  So during LDAPI authentication the uid/gid of the incoming connection can then be checked against the in-memory mapping and perform the bind dn rewrite if there is a match.  This design allows for these mapping entries to also be replicated because there is nothing system specific about them, it's the server that will set the UID/GID locally.

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

    dn: cn=bind-dyndb-ldap,cn=auto_bind,dc=example,dc=com
    objectclass: top
    objectclass: nsLDAPIAuthMap
    cn: bind-dyndb-ldap
    description: LDAPI mapping for system user bind-dyndb-ldap
    nsslapd-ldapiUsername: bind-dyndb-ldap
    nsslapd-authenticateAsDN: krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com

An LDAPI connection from system user **bind-dyndb-ldap** would then get mapped to a LDAP DN and bind as **krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com**.


Origin
-------------

<https://pagure.io/freeipa/issue/8544>

<https://github.com/389ds/389-ds-base/issues/4381>

Author
------

<mreynolds@redhat.com>

