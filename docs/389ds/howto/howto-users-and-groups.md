---
title: "Howto: Users and Groups"
---

389 Directory Server's primary use is storing users and groups. In this we will show you how to create basic users and groups.


{% include toc.md %}

# DS version 1.4.x
------------------

We provide a number of tools that help you manage users and groups with out of box schema. The
primary tool is "dsidm", and you can list what's possible with:

    dsidm <instancename>

We recommend you setup a .dsrc file to make this simpler - this is covered in the [install guide](howto-install-389.html).

## Managing groups

You can list groups on the system with:

    # dsidm localhost group list
    demo_group

If you installed the sample entries, you should see a singel demo group. We can create a new group
with:

    # dsidm localhost group create
    Enter value for cn : my_awesome_group
    Sucessfully created my_awesome_group

## Users

We can list all our users with:

    # dsidm localhost user list
    demo_user

We can display the user with:

    # dsidm localhost user get demo_user
    dn: uid=demo_user,ou=people,dc=example,dc=com
    cn: Demo User
    displayName: Demo User
    gidNumber: 99998
    homeDirectory: /var/empty
    legalName: Demo User Name
    loginShell: /bin/false
    objectClass: top
    objectClass: nsPerson
    objectClass: nsAccount
    objectClass: nsOrgPerson
    objectClass: posixAccount
    uid: demo_user
    uidNumber: 99998

So let's create a new user. If you want to do this in one shot, have a look at the --help for:

    # dsidm localhost user create --help

This shows you all the required fields you need to supply to create a user.

Alternately you can use the interactive tool:

    # dsidm localhost user create
    Enter value for uid : william
    Enter value for cn : william
    Enter value for displayName : William Brown
    Enter value for uidNumber : 1000
    Enter value for gidNumber : 1000
    Enter value for homeDirectory : /home/william
    Sucessfully created william

We can now add them to our new group:

    # dsidm localhost group add_member my_awesome_group uid=william,ou=people,dc=example,dc=com
    added member: uid=william,ou=people,dc=example,dc=com

HINT: You can see the DN of the user with the dsidm <instance> user get <name> command. But we
create everyone in "ou=people" anyway, so you can normally assume "uid=<name>,ou=people,<domain>"
is valid.

## Accounts

Accounts are different to users, but contain them. Accounts represent "all objects in the server that
*could* login". It does not imply they can login, but only that the possibility to authenticate (bind)
exists.

As a result, the account command is used to manage authentication related tasks such as locking,
unlocking or reseting passwords.


# DS version 1.3.x or before: LDIF
----------------------------------

You may find tools like ldapvi and Apache Directory Studio useful for this task.

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

## Creating groups

To create a posix group you can use the following template:

    dn: cn=GROUPNAME,ou=Groups,dc=example,dc=com
    changetype: add
    objectClass: top
    objectClass: posixGroup
    objectClass: groupOfUniqueNames
    gidNumber: 12345
    cn: GROUPNAME
    # uniqueMember: <DN of member>

## Creating users

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

