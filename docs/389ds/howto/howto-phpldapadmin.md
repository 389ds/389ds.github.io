---
title: "Howto: phpLdapAdmin"
---

# PHP and LDAP
--------------

The following is still incomplete, but should help you get started.

{% include toc.md %}

What does "cannot find default naming contexts" mean?
-----------------------------------------------------

Try adding the following aci to your root dse. For example, using /usr/bin/ldapmodify:

    ldapmodify -x -D "cn=directory manager" -w password
    dn:
    changetype: modify
    add: aci
    aci: (targetattr = "subschemaSubentry || aliasedObjectName ||
     hasSubordinates || objectClasses || namingContexts || matchingRuleUse
     || ldapSchemas || attributeTypes || serverRoot || modifyTimestamp ||
     icsAllowRights || matchingRules || creatorsName || dn || ldapSyntaxes
     || createTimestamp")
     (version 3.0;
      acl "Anonymous access for phpldapadmin";
      allow (read,compare,search)
      (userdn = "(ldap:///anyone)")
     ;)    

NOTE: The dn is the empty string "".

PLA config.php
--------------

The following settings work:

    $ldapservers->SetValue($i,'server','name','whatever you like');    
    $ldapservers->SetValue($i,'server','host','10.0.0.x'); // or DNS name    
    $ldapservers->SetValue($i,'server','base',array('dc=my,dc=domain'));    
    $ldapservers->SetValue($i,'server','auth_type','config');    
    $ldapservers->SetValue($i,'login','dn','cn=directory manager');    
    $ldapservers->SetValue($i,'login','pass','mypassword');    

PHP Memory Size
---------------

It seems you need to increase the memory\_size value in /etc/php.ini to 32M to make anything work at all. (default is 8M). Then restart your webserver.

How to create a posixUser in Fedora DS
--------------------------------------

In the templates/creation directory, edit the file new\_user\_template.php, search for 'value="gn"' and replace it with 'value="givenname"'

Script to add a user and auto-increment uidNumber
-------------------------------------------------

Here is a script to help with adding a user and auto-incrementing the uidNumber:

<http://www.netauth.com/~jacksonm/ldap/newuser.pl.txt>

It supports uid uniqueness checking and specified or auto-incrementing uidnumber, as well as specified or auto-incrementing gidnumber. It even hashes the user's password before sending it over-the-wire, but it doesn't encrypt the bind password. If you have SSL turned on on your LDAP server, you could just use stunnel or you could modify that script to use SSL. It's pretty simple, just change this:

    my $ldap    = Net::LDAP->new($SERVER)    

to this:

    my $ldap    = Net::LDAPS->new($SERVER)    

How to create a groupOfUniqueNames (as opposed to just a groupOfNames)
----------------------------------------------------------------------

Edit the file templates/modification/group\_of\_names.php. Around line 21, " \$attr\_name = 'member'; " I replaced member with uniqueMember - a hack, I know, but it worked. Now I can create the initial member as a uniqueMember.

