---
title: "Howto: LdapAdmin"
---

# LdapAdmin, and Postfix
----------------------

[LdapAdmin Website](http://ldapadmin.sourceforge.net/)

LdapAdmin is a very useful tool that runs on windows and understands Posix and Samba accounts, groups, mailing lists, and mail attributes.

The Posix and Samba stuff works out of the box. The mail option won't work unless FDS has a compatible mail schema.

Inserting [this mail schema] into the ..../config/schema folder fulfills that criteria.

Windows die-hard admins then have a nice shiny application which lets them control domain users, groups, email accounts, and mailing lists all under one roof.

Postfix
-------

There are already how-to's provided, both of which work very well. The only reason to consider yet another solution is if you really like LdapAdmin as an admin tool (which I do!) The only real difference is the attributes used.

### main.cf

    virtual_maps = ldap:/etc/postfix/ldapaliases.cf ldap:/etc/postfix/ldapgroups.cf

### ldapgroups.cf

    server_host = fds1.example.com:389     
    search_base = ou=Email Groups,dc=foobar,dc=com    
    query_filter = (&(mail=%s)(objectclass=mailGroup))    
    special_result_attribute = member    

### ldapaliases.cf

    server_host = fds1.example.com:389     
    search_base = dc=foobar,dc=com    
    query_filter = (&(mail=%s)(objectclass=mailUser))    
    result_attribute = maildrop    
