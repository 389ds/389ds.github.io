---
title: "DNA Remote Server Settings"
---

# DNA Plugin Remote Server Settings
---------------------------------

{% include toc.md %}

Overview
--------

When a server using the DNA plugin in a multimaster environment attempts to get a new range from a server listed in the "Shared Server Config" list, but there is no direct replication agreement to that shared server, then the plugin fails to get the requested range of new values. This is because the plugin uses the bind information/credentials from the agreement to authenticate and retrieve the new range from that remote replica server. Now, you explicitly set remote server bind information(bind DN + password, bind method, etc), for a server that is outside of the immediate replication environment.

Use Cases
---------

Circular MMR is a situation where everything is in sync, but each master does not aware of all the other replicas/masters in the environment.

Design
------

Extend the the "Shared Server Config" entries to include the bind method and protocol:

    dn: dnaHostname=127.0.0.1+dnaPortNum=389,ou=ranges,dc=example,dc=com
    objectClass: extensibleObject
    objectClass: top
    dnaHostname: 127.0.0.1
    dnaPortNum: 389
    dnaSecurePortNum: 636
    dnaRemainingValues: 500
    dnaRemoteBindMethod:SIMPLE
    dnaRemoteConnProtocol: LDAP

Extend the DNA plugin config entry to include the bind DN and password.

    dn: cn=DNA Config Entry, cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: DNA Config Entry
    dnaType: description
    dnaInterval: 1
    dnaMaxValue: 5000
    dnaMagicRegen: 0
    dnaThreshold: 100
    dnaFilter: (objectclass=groupofuniquenames)
    dnaScope: dc=example,dc=com
    dnaSharedCfgDN: ou=ranges,dc=example,dc=com
    dnaNextValue: 2503
    dnaRemoteBindDN: uid=replication manager,cn=config
    dnaRemoteBindCred: {DES}UgEJ6yX1JrMZXjA62EKqfw==

New DNA plugin schema and definitions

    dnaRemoteBindMethod   - "SIMPLE", "SSL" (client auth), "SASL/GSSAPI", or "SASL/DIGEST-MD5".
    dnaRemoteConnProtocol - "LDAP", "SSL", or "TLS".
    dnaRemoteBindDN       - Replication Manager DN
    dnaRemoteBindCred     - Replication Manager's password

Now, when the server needs a new range, it first checks the replication agreements, if there are no matching agreements then it checks if the bind method is set. If so, it then gathers the necessary information to complete the range request to the remote server.

If using a bind method that requires bind DN and password, then each server in the replication deployment must set "dnaRemoteBindDN and "dnaRemoteBindCred" in the plugin configuration entry(under cn=config). DES hashed passwords can not be replicated and correctly decoded, so each server needs its own copy.

The server must be restarted after making configuration changes.

Implementation
--------------

If using a bind method that requires a password, you must add "dnaRemoteBindCred" to the DES password storage plugin. This also means that you must set the password over LDAP so it gets properly hashed.

Feature Management
-----------------

CLI only.

Major configuration options and enablement
------------------------------------------

If using a bind method that requires a password(for example, SIMPLE), you must add "dnaRemoteBindCred" to the DES password storage plugin. This also means that you must set the password over LDAP so it gets properly hashed.

Replication
-----------

No impact.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No dependencies.

External Impact
---------------

No impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

