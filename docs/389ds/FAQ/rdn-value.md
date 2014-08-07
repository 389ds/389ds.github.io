---
title: "RDN Value"
---

# RDN Value
-----------

Introduction
============

The rdnValue is a directory-managed attribute similar to Active Directory's name attribute. The following is an excerpt from MSDN Library:

Active Directory includes the name attribute on every object. An object's value of name equals the value of the object's RDN attribute.

The name attribute has special behavior. Even if an object is renamed (LDAP Modify DN), the object's name attribute remains equal to the object's RDN attribute. As with the distinguishedName attribute, the name attribute is not declared in the schema as a constructed attribute, but it behaves like one.

Because Active Directory requires that the value parts of the RDNs of all children of an object be distinct, it follows that the name attribute of all children of an object are distinct.

Requirements
============

-   The rdnValue can be enabled/disabled via cn=config.
-   The rdnValue must exist in all entries in the directory (probably except root DSE, configuration entries, subentries).
-   The rdnValue must always reflect the value of the RDN of the entry. When the entry is renamed the rdnValue must be updated automatically.
-   The rdnValue must be searchable using the search filter.
-   The rdnValue should be indexable for performance.
-   The rdnValue can be required to be unique among all children of an entry. LDAP operations that violate this requirement must be rejected to maintain the integrity.

Use Cases
=========

Add Operation
-------------

Add an entry without rdnValue:

    dn: uid=bob,dc=example,dc=com
    objectClass: inetOrgPerson
    cn: Bob Smith
    sn: Smith
    uid: bob

When the entry is searched the rdnValue will appear:

    dn: uid=bob,dc=example,dc=com
    objectClass: inetOrgPerson
    cn: Bob Smith
    sn: Smith
    uid: bob
    rdnValue: bob

Rename Operation
----------------

Rename an existing entry:

    dn: uid=bob,dc=example,dc=com
    objectClass: inetOrgPerson
    cn: Bob Smith
    sn: Smith
    uid: bob
    rdnValue: bob

When the new entry is searched the rdnValue will show the new value:

    dn: uid=bsmith,dc=example,dc=com
    objectClass: inetOrgPerson
    cn: Bob Smith
    sn: Smith
    uid: bsmith
    rdnValue: bsmith

Search Operation
----------------

The rdnValue can be specified in the search filter:

    % ldapsearch -x -b "dc=example,dc=com" "(rdnValue=bob)"

Uniqueness
----------

The following entries can exist in the directory because they are under different parents:

    dn: uid=bob,ou=bos,dc=example,dc=com
    rdnValue: bob

    dn: uid=bob,ou=mtv,dc=example,dc=com
    rdnValue: bob

The following entries cannot exist in the directory because they are under the same parent:

    dn: uid=bob,dc=example,dc=com
    rdnValue: bob

    dn: cn=bob,dc=example,dc=com
    rdnValue: bob (duplicate)

Questions
=========

-   What is the behavior when the RDN contains multiple values?

    dn: uid=bob+uid=bsmith,dc=example,dc=com
    rdnValue: ?

    dn: givenName=Bob+sn=Smith,dc=example,dc=com
    rdnValue: ?

Design
======

References
==========

-   [Samba4 need 'name' implementation like AD (RDN-Name)](http://www.openldap.org/its/index.cgi/Development?id=6055;selectid=6055)
-   [MS-ADTS - objectClass, RDN, DN, Constructed Attributes](http://msdn.microsoft.com/en-us/library/cc223167(PROT.13).aspx)

