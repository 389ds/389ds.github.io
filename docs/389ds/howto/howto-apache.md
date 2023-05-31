---
title: "Howto: Apache"
---

{% include toc.md %}

# How to setup Apache to authenticate against Fedora Directory Server
-------------------------------------------------------------------

There are two modules available for Apache that handle authentication through LDAP: [mod\_authnz\_ldap](http://httpd.apache.org/docs/2.2/mod/mod_authnz_ldap.html), which ships with Apache itself, and [mod\_authz\_ldap](http://authzldap.othello.ch/index.html), which is an external module.

The following example configurations assume you have the directory server on the same host as Apache and listening on the default ldap port, 389. If this isn't the case, then change the value of the **AuthzLDAPServer** or **AuthLDAPURL** directive as appropriate. Also, change instances of "dc=example,dc=com" to the DN for your particular domain. No SSL/TLS is used in these examples.

### Authenticate Users
----------------------

The first example allows any user in the directory server to authenticate. This configuration assumes you use the default "uid" attribute to hold the login name of your users.

#### mod\_authnz\_ldap

    <Location "/files">
       AuthType Basic
       AuthName "Secure Area"
       AuthBasicProvider ldap
       AuthzLDAPAuthoritative   Off
       AuthLDAPURL              "ldap://localhost:389/ou=People,dc=example,dc=com)"
       Require valid-user
    </Location>

##### **BindDn**

If you need a user account to query the LDAP server you can add the following to bind as that user.

    AuthLDAPBindDN "uid=tux,ou=Special Users,dc=example,dc=com"
    AuthLDAPBindPassword "secret"

Change the DN to the correct user, and also replace secret with your password.

#### mod\_authz\_ldap

    <Location "/files">
      AuthType Basic
      AuthName "Secure Area"
      AuthzLDAPAuthoritative   On
      AuthzLDAPMethod          ldap
      AuthzLDAPProtocolVersion 3
      AuthzLDAPServer          localhost:389
      AuthzLDAPUserBase        ou=People,dc=example,dc=com
      AuthzLDAPUserKey         uid
      Require valid-user
    </Location>

##### **BindDn**

If you need a user account to query the LDAP server you can add the following to bind as that user.

    AuthzLDAPBindDN "uid=tux,ou=Special Users,dc=example,dc=com"
    AuthzLDAPBindPassword secret

Change the DN to the correct user, and also replace secret with your password.

### Authorize by Group

The second example allows any user in the directory server to authenticate provided that they are a member of a specified group. This configuration assumes you use the default "uid" attribute to hold the login name of your users, the default "cn" attribute to hold the name of your groups and the default "uniquemember" attribute to hold the full DN of users who are members of the group.

    <Location "/files">
      AuthType Basic
      AuthName "Secure Area"
      AuthzLDAPAuthoritative   On
      AuthzLDAPMethod          ldap
      AuthzLDAPProtocolVersion 3
      AuthzLDAPServer          localhost:389
      AuthzLDAPUserBase        ou=People,dc=example,dc=com
      AuthzLDAPUserKey         uid
      AuthzLDAPGroupBase       ou=Groups,dc=example,dc=com
      AuthzLDAPGroupKey        cn
      AuthzLDAPMemberKey       uniquemember
      AuthzLDAPSetGroupAuth    ldapdn
      Require group MyGroup
    </Location>

If the attribute specified by **AuthzLDAPMemberKey** only holds the login names of group members, rather than the full DN, change the **AuthzLDAPSetGoupAuth** directive to:

    AuthzLDAPSetGroupAuth    user

This method only allows for checking group membership to a single group. Fedora Directory Server also does not have the concept of dynamically generated memberOf attributes on objects.

### Authorize by Role

The third example authenticates users by verifying that they are part of a [Role](http://www.redhat.com/docs/manuals/dir-server/ag/7.1/roles.html#1115402).

This example uses mod\_authnz\_ldap and **require-attribute**

The concept of Roles is a replacement for the concept of groups in LDAP. It is a dynamic property on objects in the LDAP database, and as such more generic than the memberOf concept.

    <Location "/files">
      AuthType Basic
      AuthName "Secure Area"
      AuthBasicProvider "ldap"
      AuthLDAPURL          "ldap://localhost:389/ou=People,dc=example,dc=com)"
      # these are OR'd
      require ldap-attribute nsRole=cn=group1,ou=People,dc=example,dc=com
      require ldap-attribute nsRole=cn=group2,ou=People,dc=example,dc=com
    </Location>

### Authorize over SSL

This example demonstrates authorizing Apache 2.0 over SSL.

**Notes**

Apache 2.0 needs to use mod\_auth\_ldap as mod\_authz\_ldap does not support SSL.

Apache 2.2 has been re-worked you will need to view the associated directives on their website. [mod\_authnz\_ldap](http://httpd.apache.org/docs/2.2/mod/mod_authnz_ldap.html)

These global directives need to be placed in httpd.conf :

    LDAPTrustedCA /etc/openldap/cacerts/ldap-ca.pem
    LDAPTrustedCAType BASE64_FILE

The location section may be added directly into your httpd.conf as well:

    <Location /mypath>
       AuthLDAPAuthoritative On
       AuthLDAPEnabled On
       AuthType Basic
       AuthName "LDAP Login"
       AuthLDAPURL "ldaps://ldap.example.com:636/ou=users,dc=example,dc=com?uid?sub)"
       require valid-user
    </Location>

### Authorize using ldap-attribute

This example combines both authz\_ldap\_module and authnz\_ldap\_module on Apache 2.2.

This allows a user to have access to a URL if they have your\_attribute\_name=whatever\_you\_want.

    <Location />
       AuthType Basic
       AuthName "389 Rocks!"
       #this part provides authentication
       AuthzLDAPMethod ldap
       AuthzLDAPProtocolVersion 3
       AuthzLDAPServer ldap1.example.com
       AuthzLDAPUserBase ou=people,dc=example,dc=com
       AuthzLDAPUserKey uid
       AuthzLDAPAuthoritative Off
       #this part provides authorization
       AuthLDAPUrl ldap://ldap.example.com:389/ou=people,dc=example,dc=com
       require ldap-attribute your_attribute_name=whatever_you_want
    </Location>

