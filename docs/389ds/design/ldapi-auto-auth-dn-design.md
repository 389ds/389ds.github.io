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

Add a new LDAPI configuration setting where you can specify an attribute that server should look at when trying to map a process ID to a LDAP entry.  The attribute, **nsslapd-ldapiAuthDNAttr**, specifies an attribute that contains the DN of an LDAP entry that the authenticating identity(bind dn) should be mapped/rewritten to.


Implementation
--------------

Here is an example of possible configuration

    dn: cn=config
    nsslapd-ldapientrysearchbase: cn=autobind,cn=config
    nsslapd-ldapiAuthDNAttr: authenticateAsDN

    dn: cn=bind-dyndb-ldap,cn=autobind,cn=config
    cn: bind-dyndb-ldap
    uidNumber: 25
    gidNumber: 25
    authenticateAsDN: krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com

    dn: cn=repl manager,cn=autobind,cn=config
    cn: bind-dyndb-ldap
    uidNumber: 33
    gidNumber: 33
    authenticateAsDN: krbprincipalname=DNS/replica57.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com

An LDAPI connection for 25:25 (UID/GID) would then get mapped to and bind as user **krbprincipalname=DNS/server.ipa.example@IPA.EXAMPLE,cn=services,cn=accounts,dc=ipa,dc=example,dc=com** instead of **cn=bind-dyndb-ldap,cn=autobind,cn=config**. If the target entry does not exist, then authentication would fail. If an entry does not have *authenticateAsDN* then bind as the direct entry instead.


Origin
-------------

<https://pagure.io/freeipa/issue/8544>
<https://github.com/389ds/389-ds-base/issues/4381>

Author
------

<mreynolds@redhat.com>

