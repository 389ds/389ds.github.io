---
title: "Howto: Postfix"
---

# How to get Postfix email working with Fedora DS
-----------------------------------------------

### General Information

The Postfix LDAP HOWTO contains good information and is probably a good starting place: <http://www.postfix.org/LDAP_README.html>

You might also find this information is almost the same as previous but its an alternative way using mailgroup object built-in schema on Fedora DS instead of Courier LDAP Schema.

For a third solution [see](howto-ldapadmin.html) which is specific to that admin tool.

### Example

This is a quick outline of how to configured Postfix look up virtual aliases in LDAP using TLS and using the built-in mail schema for attributes (mailgroup). In this example, every users stores all of their mail aliases under their ou=people,dc=fdsvr,dc=co,dc=id entry:

    dn: uid=jsomebody,ou=people,dc=fdsvr,dc=co,dc=id
    objectClass: top
    objectClass: mailgroup
    ...
    mail: jsomebody@fdsvr.co.id
    mgrpDeliverTo: jsomebody

With this setup Postfix will deliver all mail for jsomebody@fdsvr.co.id to the local user "jsomebody". Now, for the related Postfix configurations we will be working with three files. They are, main.cf, ldap-aliases.cf, ldap-users.cf (adjust the names and locations according to your Postfix installation).

/etc/postfix/main.cf:

    ## keep all system related aliases local    
    alias_maps = hash:/etc/postfix/aliases    
    virtual_alias_maps = ldap:/etc/postfix/ldap-aliases.cf
    local_recipient_maps = $alias_maps, ldap:/etc/postfix/ldap-users.cf

/etc/postfix/ldap-aliases.cf:

    bind = no    
    version = 3    
    timeout = 20    
    ## set the size_limit to 1 since we only    
    ## want to find one email address match    
    size_limit = 1    
    expansion_limit = 0    
    start_tls = yes    
    tls_require_cert = no    
    server_host = ldap://ldap.fdsvr.co.id/ ldap://ldap2.fdsvr.co.id/
    search_base = ou=people,dc=fdsvr,dc=co,dc=id    
    scope = sub    
    query_filter = (mail=%s)    
    result_attribute = mgrpDeliverTo    
    special_result_filter = %s@%d    

/etc/postfix/ldap-users.cf:

    bind = no    
    version = 3    
    timeout = 20    
    ## set the size_limit to 1 since we only    
    ## want to find one email address match    
    size_limit = 1    
    expansion_limit = 0    
    start_tls = yes    
    tls_require_cert = no    

    server_host = ldap://ldap.fdsvr.co.id/ ldap://ldap2.fdsvr.co.id/
    scope = sub    
    search_base = ou=people,dc=fdsvr,dc=co,dc=id    
    query_filter = (mail=%s)    

That's it, that's all there is to it. Granted this is a simple example and has lots of room for customizing and tuning, so I would suggest looking at the Postfix LDAP documentation (there are a lot more options available to you. try: man 5 ldap\_table).

### More Information

If the uid of the user is where you would actually deliver the mail, you could probably just use that. Your postfix configuration for alias lookups would look something like this:

    ~  search_base = dc=fdsvr,dc=co,dc=id    
    ~  scope = sub    
    ~  query_filter = (mail=%s)    
    ~  result_attribute = uid    
    ~  special_result_filter = %s@%d    

Postfix does two different LDAP lookups, one to verify there is a user by that name (local\_recipient\_maps) on the system, and two, where to deliver the email (virtual\_alias\_maps; my configuration above is for this second part). Here are my two lines out of the main.cf:

    ~  virtual_alias_maps = ldap:/etc/postfix/ldap-aliases.cf
    ~  local_recipient_maps = $alias_maps, ldap:/etc/postfix/ldap-users.cf


