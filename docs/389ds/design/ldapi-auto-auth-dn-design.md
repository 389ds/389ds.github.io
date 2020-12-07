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

Add a new LDAPI configuration entry that maps a UID/GID to a specific DN


Implementation
--------------

Here is an example of possible configuration

    dn: cn=config
    nsslapd-ldapientrysearchbase: cn=auto_bind,cn=config

    dn: cn=bind-dyndb-ldap,cn=auto_bind,cn=config
    objectclass: top
    objectclass: nsLDAPIAuthMap
    cn: bind-dyndb-ldap
    uidNumber: 25
    gidNumber: 25
    nsslapd-authenticateAsDN: krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com

An LDAPI connection for 25:25 (UID/GID) would then get mapped to and bind as user **krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com** instead of **cn=bind-dyndb-ldap,cn=autobind,cn=config**. If the target entry does not exist, then authentication would fail. If an entry does not have *nsslapd-authenticateAsDN* then bind as the direct entry instead.


Origin
-------------

<https://pagure.io/freeipa/issue/8544>
<https://github.com/389ds/389-ds-base/issues/4381>

Author
------

<mreynolds@redhat.com>

