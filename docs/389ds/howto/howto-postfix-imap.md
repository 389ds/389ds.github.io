---
title: "Howto: Postfix IMAP"
---

# How to get Postfix email working with Fedora DS
-----------------------------------------------

If the uid of the user is where you would actually deliver the mail, you could probably just use that. Your postfix configuration for alias lookups would look something like this:

    ~  search_base = dc=example,dc=com    
    ~  scope = sub    
    ~  query_filter = (mail=%s)    
    ~  result_attribute = uid    
    ~  special_result_filter = %s@%d    

Postfix does two different LDAP lookups, one to verify there is a user by that name (local\_recipient\_maps) on the system, and two, where to deliver the email (virtual\_alias\_maps; my configuration above is for this second part). Here are my two lines out of the main.cf:

    ~  virtual_alias_maps = ldap:/etc/postfix/ldap-aliases.cf
    ~  local_recipient_maps = $alias_maps, ldap:/etc/postfix/ldap-users.cf
