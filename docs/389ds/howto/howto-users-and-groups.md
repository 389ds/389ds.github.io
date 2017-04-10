---
title: "Howto: Users and Groups"
---

389 Directory Server's primary use is storing users and groups. In this we will show you how to create basic users and groups.

You may find tools like ldapvi and Apache Directory Studio useful for this task.

# LDIF
------

LDAP modifications are performed through the LDAP Data Interchange Format. This describes object additions, deletion, or modification.

Addition takes the form:

    dn: <fqdn to add>
    changetype: add
    objectclass: ...
    attributes: ...

Delete takes the form:

    dn: <fqdn to delete>
    changetype: delete

Modifications takes the form:

    dn: <fqdn to alter>
    changetype: modify
    <action>: attribute
    attribute: new value

Action must be one of "add" to add new attribute values, "replace" to change an attribute and "delete" to remove an attribute value.

**NOTE: Always take backups before performing changes on production systems**

These files are then applied to the server with the "ldapmodify" command. For example:

    ldapmodify -f "example.ldif" -D 'bind dn' -H ldap://<hostname>

# Creating groups
-----------------

To create a posix group you can use the following template:

    dn: cn=GROUPNAME,ou=Groups,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfUniqueNames
    gidNumber: 12345
    cn: GROUPNAME
    # uniqueMember: <DN of member>

# Creating users
----------------

To create a posix user you can use the following template:

    dn: uid=USERNAME,ou=People,dc=example,dc=com
    changetype: add
    uid: USERNAME
    objectClass: top
    objectClass: account
    objectClass: posixaccount
    objectClass: inetOrgPerson
    objectClass: person
    objectClass: inetUser
    objectClass: organizationalPerson
    uidNumber: 1001
    gidNumber: 1001
    sn: surname
    homeDirectory: /home/username
    cn: common name

If you wish to set a password on the account:

    userPassword: <cleartext password>

The server will hash the password securely for you.

