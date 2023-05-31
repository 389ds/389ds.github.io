---
title: "ACL Utility"
---

# ACL Utility Design
-------------------

Overview
--------

This tool allows the user to find out the effect of an ACI on Directory Server entries. It shows the user the DN of the entries or the number of entries that the ACI matches

Use Cases
---------

**Use Case 1:** 

-   *INPUT:* 

        aclutil -h ldaphost -p ldapport -D "cn=directory manager" -w Secret123 -a "monitor" -b "dc=example,dc=com" -t

-   *OUTPUT:* the dn of the entries to which the aci "monitor" is applicable

**Use Case 2:** 

-   *INPUT:* 

        aclutil -h ldaphost -p ldapport -D "cn=directory manager" -w Secret123 -v "(target="<ldap:///cn=plugins,cn=config>")(version 3.0; acl "testaci"; allow (read, search) userdn="<ldap:///anyone>";)" -b "dc=example,dc=com" -tn ; 

-   *OUTPUT:* the count of the entries to which the aci "testaci" is applicable

**Use Case 3:** 

-   *INPUT:* 

        aclutil -h ldaphost -p ldapport -D "cn=directory manager" -w Secret123 -v "(target="<ldap:///cn=plugins,cn=config>")(version 3.0; acl "testaci"; allow (read, search) userdn="<ldap:///anyone>";)" -b "dc=example,dc=com" -tx ; 

-   *OUTPUT:* the dn and attributes of the entries to which the aci "testaci" is applicable

Design
------

This tool is implemented as a command line utility. It performs a search operation on the directory server to find out the entries(or count of entries) to which the given aci is applicable. The syntax of this tool is:

    aclutil [-h ldaphost] [-p ldapport] -D <binddn> -w \< binddnpw\> -a "aci\_name" | -v "aci\_value" [-b basedn] [-t[-n][-x]]

**-b basedn**: If basedn is given, entries under the basedn are matched; otherwise, everything is matched;

**-a "aci\_name"**: aci\_name finds out the aci target dn and target attributes and returns the entries which match that target. If the name does not exist, it reports it.

**-v "aci\_value"**: aci\_value allows the user to specify the complete aci value. It may or may not be present in the directory server. This aci value is then used to perform the search in the directory server

**-t**: (targetdn) returns the DN of the entries that match the given aci's target entries. If the target contains wildcards and/or macros, they are evaluated and matched DNs are returned.

**-tn**: only the count of the DNs is returned.

**-tx**: (target attribute) returns the matched DNs and attributes based on the given aci.

**-tnx**: count of the DNs as well as count of attributes is returned.

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

Depends on the presence of LDAPsearch client library

External Impact
---------------

No external impact
