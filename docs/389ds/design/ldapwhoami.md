---
title: "ldapwhoami"
---

# LDAP whoami
-------------

Overview
--------

This feature provides a mechanism for LDAP clients to obtain the authorization identity the server has associated with the user or application entity.

Use Cases
---------

If the client specifies the binddn and password attributes with the ldapwhoami command, the appropriate client dn is returned otherwise the client receives 'anonymous'.
**Use Case 1:** *INPUT:* ldapwhoami -x -D "cn=Directory Manager" -w pwd -h ldaphost -p ldapport ; *OUTPUT:* dn: cn=directory manager.
**Use Case 2:** *INPUT:* ldapwhoami -x -h ldaphost -p ldapport ; *OUTPUT:* anonymous

Design
------

The feature works as an extended operation plugin. The whoami request sent by the client has a requestName field containing the whoami OID "1.3.6.1.4.1.4203.1.11.3" and an absent requestValue field. The whoami response received from the server has the responseName field empty and the response field either empty or containing the authzId. The format used for the authzid is dn: distinguishedname. 'ldapwhoami' handles opening the connection to an LDAP server, binding, and performing the whoami operation. If the server is unwilling or unable to provide the authorization identity it associates with the client, the server returns a whoami Response with an appropriate non-success result code.

Implementation
--------------

No additional requirements

Major configuration options and enablement
------------------------------------------

None required

Replication
-----------

No impact

Updates and Upgrades
--------------------

No impact

Dependencies
------------

The feature depends on the presence of whoami client library

External Impact
---------------

No external impact
