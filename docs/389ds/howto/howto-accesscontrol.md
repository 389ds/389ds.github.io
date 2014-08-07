---
title: "Howto: AccessControl"
---

# How to use access control - create restricted administrative account
--------------------------------------------------------------------

By using access control, it is possible to create restricted administrative accounts, so one can view or modify attributes if existing users, but is not allowed to add or remove users. One example is to allow a separate LDAP web management application to perform some management operations.

To accomplish that, you can either use an individual user and grant access to that user, or create a group or role and grant access to that group or role.

As an example, you can find default aci's for:

-   the administrator (uid=admin,ou=Administrators, ou=TopologyManagement,o=NetscapeRoot)

        aci: (targetattr="*")(version 3.0; acl "Configuration Administrator"; allow (a
         ll) userdn="ldap:///uid=admin,ou=Administrators, ou=TopologyManagement, o=Ne
         tscapeRoot";)

-   members of the configuration administrators group :

        aci: (target="ldap:///dc=test")(targetattr="*")(version 3.0; acl "admin group"
         ;allow(write) groupdn = "(ldap:///cn=Directory Administrators, dc=sometest";)

You can create aci's with targetfilter and targetattr keywords to apply to a subset of attributes in the targeted entries.

Short example: allows members of a group called "group1 admins", to have write access for the departmentNumber and manager attributes of all entries in a business category called "group1":

    dn: dc=example,dc=com
    objectClass: top
    objectClass: organization
    aci: (targetattr="departmentNumber || manager")(targetfilter="(businessCategor
     y=group1)")(version 3.0; acl "group1-admins-write"; allow (write)groupdn ="ld
     ap:///cn=group1 admins, dc=sometest";)

Another example would be to define access based on value matching, you can specify that a bind dn for a user or a group or a role or a url must match the dn in defined in another attribute of a given entry, example of acl if users entries have a manager attribute:

    aci: (target="ldap:///dc=example,dc=com")(targetattr=*)(version 3.0;acl "manag
     er-write"; allow (all) userattr = "manager#USERDN";)

There is a detailed online documentation, for RHDS 7.1 in the deployment guide, as well as in the Admin Guide, like for example on how to select permission, bind rules, role access, access from an ip address, domain or auth method, in <http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Managing_Access_Control.html>


