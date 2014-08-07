---
title: "LDAPI and access control"
---

# LDAPI and Access Control
------------------------

Overview
--------

Access control should be LDAPI aware, and have the ability to accept or reject operations that come through an LDAPI connection.

Use Cases
---------

Situations where one might want to protect sensitive data, and only allow connections that come from the server machine over LDAPI.

Design
------

LDAPI support was added by extending the "authmethod" keyword. "authmethod" is used to control access by the connection protocol(Simple, SSL, SASL, etc). Now you can specify "ldapi" as an authentication method.

    (targetattr = "*") (version 3.0;acl "LDAPI ACI";allow (all)
    (userdn = "ldap:///anyone" and authmethod = "ldapi" );)

Since LDAPI connections do not have an IP address/hostname, be very careful when adding "ip" and "dns" rules. If you choose to "and" an "ip" rule with authmethod(LDAPI), the ACI will always reject access, so use an "or" in this case.

    (targetattr = "*") (version 3.0;acl "LDAPI ACI";allow (all)
    (userdn = "ldap:///anyone" and authmethod = "ldapi" or ip = "127.0.0.1" );)

Implementation
--------------

No additional requirements.

Feature Management
-----------------

UI

Right click on the suffix/branch you want to add the ACI to -\> "Set access permissions", then you have to "Edit visually" to set the authmethod.

CLI

Use ldapmodify to add the aci.

Major configuration options and enablement
------------------------------------------

No configuration options.

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

