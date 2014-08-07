---
title: "Howto: Default Console Object Objectclass"
---

# Default Console Object Objectclasses
--------------------------------------

{% include toc.md %}

You can set the list of objectclasses the console uses to create new objects.
-----------------------------------------------------------------------------

### Find the defaultObjectClassesContainer entry

Use ldapsearch to find the entry which is the parent entry for the object-objectclass entries.

    ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot cn=defaultObjectClassesContainer

The dn will be something like this:

    cn=defaultObjectClassesContainer,ou=1.1,ou=Admin,ou=Global Preferences,ou=example.com,o=NetscapeRoot

Under this entry are entries for objects that the console knows how to create. By default there are:

-   cn=user - for a New User object
-   cn=group - for a New Group object
-   cn=ou - for a New Organizational Unit object

Each of these entries has objectClass: nsdefaultObjectClasses. This provides the nsDefaultObjectClass attribute. This attribute lists the objectclasses applied when a new object of that type is created. For example, by default, cn=user has this:

    nsDefaultObjectClass: top
    nsDefaultObjectClass: person
    nsDefaultObjectClass: organizationalPerson
    nsDefaultObjectClass: inetorgperson

You can add additional objectclasses to this list. It is safest to add AUXILIARY object classes that do not have any required (MUST) attributes. **WARNING** - do not add an objectclass that has **REQUIRED/MUST** attributes unless the UI will ensure that there is always a value. For example, the mailUser has MUST ( uid \$ mail \$ maildrop ). If you added nsDefaultObjectClass: mailUser to cn=user, you would not be able to create a New User unless you went into the Advanced... editor and added *mail* and *maildrop* attributes with valid values. *uid* is ok because it is also required by inetorgperson, and the regular New User window will ensure the presence of a valid uid value. **WARNING** - do not add a STRUCTURAL objectclass to the list unless it has as a SUP objectclass one of the other objectclasses already in the list. Although 389 currently permits this, it is a violation of LDAPv3 and may cause interoperability problems.

### Example: adding the inetUser objectclass

When using memberOf, it is useful to have the inetUser objectclass added to New User entries. inetUser works well because it has no required (MUST) attributes and is an AUXILIARY objectclass.

-   First, find the dn of the cn=user entry

        ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot cn=user

Note the dn: line

-   next, add inetUser

        ldapmodify -x -D "cn=directory manager" -w password<<EOF
        dn: the full dn of the cn=user entry from the ldapsearch
        changetype: modify
        add: nsDefaultObjectClass
        nsDefaultObjectClass: inetUser
        EOF

