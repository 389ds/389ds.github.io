---
title: "Howto: Class of Service"
---

# Class of Service
------------------

{% include toc.md %}

Introduction
============

Class of Service (CoS) - a virtual attribute service - some attribute values may not be stored with the entry itself - instead, they are generated by CoS logic as the entry is sent to the client application

Each CoS specification is comprised of the following two types of entry

-   CoS Definition Entry - The CoS definition entry identifies the type of CoS you are using - it is stored as an LDAP subentry below the branch at which it is effective
-   CoS Template Entry - this entry contains a list of the shared attribute values - changes to the template entry attribute values are automatically applied to all the entries sharing the attribute - single CoS might have more than one template entry associated with it

Documentation
-------------

Detailed documentation about Class of Service can be found here - [Assigning Class of Service](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Advanced_Entry_Management-Assigning_Class_of_Service.html)

Class of Service Types
----------------------

-   CoS Pointer - identifies the template entry associated with this CoS definition using the template entry's DN value
-   CoS Indirect - identifies the template entry using the value of one of the target entry's attributes e.g. an indirect CoS might specify the manager attribute of a target entry - the value of the manager attribute is then used to identify the template entry - the target entry's attribute must be single-valued and contain a DN
-   CoS Classic - identifies the template entry using both the template entry's DN and the value of one of the target entry's attributes

cosAttribute
------------

The attribute cosAttribute in the CoS definition entry provides the name of the attribute for which you want to generate a value - you can specify more than one cosAttribute value

    cosAttribute: postalCode

By default, you can override this value by setting an actual value in the entry - if you do not want to allow this, use the override modifier

    cosAttribute: postalCode override

This will cause the entry to always use the generated value for postalCode

Operational attributes with CoS
-------------------------------

You can also create operational attributes by use of the cosAttribute operational modifier

    cosAttribute: postalCode operational

Operational attributes are not subject to schema checking, operational also includes override, the user cannot override CoS operational attributes

Indexing limitations
--------------------

You can not index virtual attributes unless you write a custom virtual attribute indexing plug-in.

This search will return erroneous results:

    ldapsearch -s sub -b ou=people "postalCode=<some value>"

if the postalCode value is generated by a CoS scheme and postalCode has an index. If postalCode is not indexed the correct results are returned.

Class of Service Pointer Examples
---------------------------------

Create a cosPointer definition and template to add the value of the st attribute to ou=people children. The first entry is the CoS Pointer definition entry.

    dn: cn=cosPointer,ou=People,dc=example,dc=com
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosPointerDefinition
    description: cosPointer example
    costemplatedn: cn=cosTemplateExample,ou=people,dc=example,dc=com
    cosAttribute: st
    cn: cosPointer

The second entry is the template which lists the value to supply for the virtual attribute st.

    dn: cn=cosTemplateExample,ou=People,dc=example,dc=com
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    st: OR
    cn: cosTemplateExample

Use ldapsearch to verify the presence of the attribute and value

    ldapsearch -x -b dc=example,dc=com "uid=scarter" st

The st attribute can be overwritten in each user's entry with this scheme. If you want the value to be read-only, change

    cosAttribute: st

to

    cosAttribute: st override

If you want to create an operational attribute, use the "operational" modifier. This is primarily useful to create attributes that are not part of the schema of the entry. For example, instead of

    cosAttribute: st

use

    cosAttribute: foo operational

to make the operational attribute foo appear in each user's entry. (You will also have to create a cosTemplate entry for the foo attribute and add the attribute foo to it and the value you want to use).

Class of Service Priority
-------------------------

cosPriority - the only required attribute in the cosTemplate objectclass â€“ it is possible for CoS schemes to compete to provide values - the cosPriority attribute allows specifying which value from which template "wins". The value of cosPriority goes from 0 (zero) to the maximum integer value (2 billion and change) - 0 (zero) is the highest value. Templates with higher priorities will be favored over and to the exclusion of templates with lower priorities. Templates which do not have a cosPriority attribute are considered to have no priority. In the case where the value cannot be determined from the priority, the result is undefined, but does not exclude the possibility that a value will be returned, however arbitrarily chosen. Templates closer to the entry have higher priority than templates further away - e.g. templates in the parent's subentry override templates further up the tree - this overrides any cosPriority setting.

You can use the following CoS definition and template entries. Both have a priority of 0 now. You can change the priorities and see how that affects search results:

    dn: cn=makestateWV,ou=People,dc=example,dc=com
    description: generate st attr with value WV
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosPointerDefinition
    costemplatedn: cn=stWVCoSTemplate,ou=people,dc=example,dc=com
    cosAttribute: st
    cn: makestateWV

    dn: cn=stWVCosTemplate,ou=People,dc=example,dc=com
    cosPriority: 0
    cn: stWVCosTemplate
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    st: WV

    dn: cn=makestateOR,ou=People,dc=example,dc=com
    description: generate st attr with value OR
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosPointerDefinition
    costemplatedn: cn=stORCoSTemplate,ou=people,dc=example,dc=com
    cosAttribute: st
    cn: makestateOR

    dn: cn=stORCosTemplate,ou=People,dc=example,dc=com
    cosPriority: 0
    cn: stORCosTemplate
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    st: OR

Class of Service Indirect
-------------------------

CoS Indirect are indirect because they do not specify the DN of the template entry, they specify an attribute in the target entry (e.g. some person entry under ou=people) which contains the DN of the template entry. The attribute cosIndirectSpecifier is used in the CoS definition entry to specify which attribute in the target entry contains the DN of the template entry. You do not need an entry of objectclass cosTemplate for the template entry - any entry may be an indirect template entry. The following example will generate the facsimiletelephonenumber attribute in each user's entry based on the value of facsimiletelephonenumber in the entry pointed to by the secretary value - that is - each user's fax number will be automatically be the same as the secretary's fax number, when you set the value of the secretary attribute in each user's entry.

    ldapmodify ...args...
    dn: uid=awhite,ou=people,dc=example,dc=com
    changetype: modify
    add: secretary
    secretary: uid=abergin,ou=people,dc=example,dc=com
    delete: facsimiletelephonenumber

    dn: cn=useFaxFromSecretary,ou=People,dc=example,dc=com
    description: generate fax number from the secretary's fax number
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosIndirectDefinition
    cosIndirectSpecifier: secretary
    cosAttribute: facsimiletelephonenumber
    cn: useFaxFromSecretary

Class of Service Classic
------------------------

CoS Classic - combines features of both CoS Pointer and CoS Indirect. The CoS definition entry contains the key attributes:

-   cosTemplateDN - the DN of the parent entry under which the template entry is found
-   cosSpecifier - names the attribute which holds the value which is used to form the RDN of the template entry - this entry is the child of the cosTemplateDN

CoS Classic Example: This entry is the CoS definition entry which specifies which attribute to generate, which attribute in the user's entry selects the CoS template, and which CoS template to use.

    dn: cn=generatePostalCode,ou=People,dc=example,dc=com
    description: generate postalCode attr based on location
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosClassicDefinition
    costemplatedn: cn=cosTemplates,ou=people,dc=example,dc=com
    cosAttribute: postalCode
    cosSpecifier: l
    cn: generatePostalCode

This is the container entry with dn equal to the costemplatedn above. This is the parent entry for the actual cosTemplate entries that provide the value.

    dn: cn=cosTemplates,ou=People,dc=example,dc=com
    objectclass: top
    objectclass: nsContainer
    cn: cosTemplates

This is the cosTemplate entry that provides the value for those users which have a locality "l" of Sunnyvale.

    dn: cn=Sunnyvale, cn=cosTemplates,ou=People,dc=example,dc=com
    cn: Sunnyvale
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    postalCode: 90125

This is the cosTemplate entry that provides the value for those users which have a locality "l" of Santa Clara.

    dn: cn=Santa Clara, cn=cosTemplates,ou=People,dc=example,dc=com
    cn: Santa Clara
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    postalCode: 91250

A real deployment would have more cosTemplate entries, one for each value of "l".

This is the user's entry. This user has a real attribute "l" with a value of Sunnyvale. The CoS logic supplies the value of the virtual attribute postalCode.

    dn: uid=afarmer,ou=people,dc=example,dc=com
    ...
    l: Sunnyvale <- value for RDN/cosTemplate above
    postalCode: 90125 <- value is generated

Role Based Attributes
=====================

You can tie Roles and Class of Service to provide different attributes and values depending on the role of a user. CoS Classic can be used with the nsRole attribute as the cosSpecifier. This provides the ability to generate different values for attributes based on the role membership of the entry e.g. give paying subscribers a 25MB mailbox quota but only give free subscribers a 10MB mailbox quota. In this case, the RDN value of the cosTemplate entry will be a DN - it looks strange but it works.

The server uses this method to implement features such as role based search limits, account inactivation, per user password policy, and others.

In this example, assume there is a role defined called "paidguys" - people who have paid for a higher mail quota. The first entry is the CoS definition Here are our CoS definition and CoS template - assumes there is a paidguys role defined:

    dn: cn=generateMailQuota,ou=people,...
    objectclass: cosClassicDefinition
    cosSpecifier: nsRole
    cosAttribute: mailQuota override
    cosTemplateDN: cn=cosTemplates,ou=people,...

Here is our cosTemplate entry that defines the mailQuota for the "paidguys":

    dn: cn=â€œcn=paidguys, ou=people, dc=example, dc=com, cn=cosTemplates, ou=people,...
    mailQuota: 10 000 000

And here is our entry with the generated mailQuota

    dn: uid=awhite,ou=people,...
    nsRole: cn=paidguys,ou=people,...
    mailQuota: 10 000 000

The override qualifier in the CoS definition assures that the user cannot change the mailQuota.

This example uses a Role called managedRole. All users with this role will have the secretary attribute generated with a value of "uid=abergin,ou=people,dc=example,dc=com".

    dn: cn=roleBasedAttrExample,ou=People,dc=example,dc=com
    description: generate secretary attr based on role
    objectClass: top
    objectClass: ldapsubentry
    objectClass: cossuperdefinition
    objectClass: cosClassicDefinition
    costemplatedn: cn=cosTemplates,ou=people,dc=example,dc=com
    cosAttribute: secretary
    cosSpecifier: nsRoleDN
    cn: roleBasedAttrExample

    dn: cn=cosTemplates,ou=People,dc=example,dc=com
    objectclass: top
    objectclass: nsContainer
    cn: cosTemplates
    dn: cn="cn=managedRole,ou=people,dc=example,dc=com", cn=cosTemplates,ou=People,dc=example,dc=com
    cn: "cn=managedRole,ou=people,dc=example,dc=com"
    objectClass: top
    objectClass: costemplate
    objectClass: extensibleobject
    secretary: uid=abergin,ou=people,dc=example,dc=com