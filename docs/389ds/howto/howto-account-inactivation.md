---
title: "Howto: Account Inactivation"
---

# How to Inactivate Accounts using nsAccountLock
----------------------

### How To Inactivate a Single Account

The CLI can be used for that purpose since 389-ds-base-1.4.2:

    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com account lock USER_DN
    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com account unlock USER_DN

And the legacy command:

    ns-inactivate.pl -Z instance_name -h localhost -p 389 -D "cn=directory manager" -w password -I USER_DN
    ns-activate.pl -Z instance_name -h localhost -p 389 -D "cn=directory manager" -w password -I USER_DN

If you want to do that manually, the simpliest option is to set **nsAccountLock: true** to the user entry. This way the server will reject the bind.

If we remove **nsAccountLock: true** attribute it will allow the user to bind again (if nothing else prevents it from doing so).

    ldapmodify -D "cn=directory manager" -w password
    dn: USER_DN
    changetype: modify
    replace: nsAccountLock
    nsAccountLock: true

    ldapmodify -D "cn=directory manager" -w password
    dn: USER_DN
    changetype: modify
    delete: nsAccountLock

### How To Inactivate a Group of Accounts

For the group of entries we should use **role** subcommand instead of **account**. Like this:

    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com role lock ROLE_DN
    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com role unlock ROLE_DN

And for the legacy command:

    ns-inactivate.pl -Z instance_name -h localhost -p 389 -D "cn=directory manager" -w password -I ROLE_DN
    ns-activate.pl -Z instance_name -h localhost -p 389 -D "cn=directory manager" -w password -I ROLE_DN

If you want to do that manually, it'll be tricker. We should use CoS definition and Role if we want to set **nsAccountLock** to a group of entries. It can be done this way:

1. Find out the root suffix where your entries belong to. You can check entries under **cn=mapping tree,cn=config** and find the closest one to your entry DN. For example, it is **dc=example,dc=com**.
2. Create an entry **cn=nsManagedDisabledRole,dc=example,dc=com**. This role will be assigned to the accounts we want to lock.

    ldapmodify -D "cn=directory manager" -w password
    dn: cn=nsManagedDisabledRole,dc=example,dc=com
    changetype: add
    objectClass: nsSimpleRoleDefinition
    objectClass: nsManagedRoleDefinition
    objectClass: nsRoleDefinition
    objectClass: ldapSubEntry
    objectClass: top
    cn: nsManagedDisabledRole

3. Create an entry **cn=nsDisabledRole,dc=example,dc=com**. This role will distribute **nsAccountLock** through other roles.

    ldapmodify -D "cn=directory manager" -w password
    dn: cn=nsDisabledRole,dc=example,dc=com
    changetype: add
    objectClass: nsComplexRoleDefinition
    objectClass: nsNestedRoleDefinition
    objectClass: nsRoleDefinition
    objectClass: ldapSubEntry
    objectClass: top
    cn: nsDisabledRole
    nsRoleDN: cn=nsManagedDisabledRole,dc=example,dc=com

4. Now create a Classic CoS set up for the **cn=nsDisabledRole,dc=example,dc=com**. 

    ldapmodify -D "cn=directory manager" -w password
    dn: cn=nsAccountInactivationTmp,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: nscontainer
    cn: nsAccountInactivationTmp
     
    dn: cn=cn\3DnsDisabledRole\2Cdc\3Dexample\2Cdc\3Dcom,cn=nsAccountInactivationTmp,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: cosTemplate
    objectClass: extensibleObject
    cosPriority: 1
    nsAccountLock: true
    cn: cn=nsDisabledRole,dc=example,dc=com
     
    dn: cn=nsAccountInactivation_cos,dc=example,dc=com
    c
    objectClass: nscontainer
    cn: nsAccountInactivationTmp
     
    dn: cn=cn\3DnsDisabledRole\2Cdc\3Dexample\2Cdc\3Dcom,cn=nsAccountInactivationTmp,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: cosTemplate
    objectClass: extensibleObject
    cosPriority: 1
    nsAccountLock: true
    cn: cn=nsDisabledRole,dc=example,dc=com
     
    dn: cn=nsAccountInactivation_cos,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: cossuperdefinition
    objectClass: cosClassicDefinition
    objectClass: ldapSubEntry
    cosAttribute: nsAccountLock operational
    cosspecifier: nsRole
    costemplatedn: cn=nsAccountInactivationTmp,dc=example,dc=com
    cn: nsAccountInactivation_cos

5. You can set more roles to **cn=nsDisabledRole,dc=example,dc=com** and all of entries of these roles and their children will be locked.

    ldapmodify -D "cn=directory manager" -w password
    dn: cn=nsDisabledRole,dc=example,dc=com
    changetype: modify
    add: nsRoleDN
    nsRoleDN: cn=managers,ou=groups,dc=example,dc=com

If you need to unlock the role, you can just remove **nsRoleDN** attribute from **cn=nsDisabledRole,dc=example,dc=com** entry.

    ldapmodify -D "cn=directory manager" -w password
    dn: cn=nsDisabledRole,dc=example,dc=com
    changetype: modify
    delete: nsRoleDN
    nsRoleDN: cn=managers,ou=groups,dc=example,dc=com

### How To Monitor Inactivated Accounts And Roles

You can check the status of a single entry or a subtree using these CLI tools:

    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com account entry-status USER_DN
    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com account subtree-status SUBTREE_DN

    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com role entry-status USER_DN
    dsconf ldap://localhost:389 -D "cn=Directory Manager" -w password -b dc=example,dc=com role subtree-status SUBTREE_DN

The legacy tools option:

    ns-accountstatus.pl -Z standalone1 -h localhost -p 389 -D "cn=directory manager" -w password -I ENTRY_DN
    ns-accountstatus.pl -Z standalone1 -h localhost -p 389 -D "cn=directory manager" -w password -b SUBTREE_DN -f "(objectclass=*)"

