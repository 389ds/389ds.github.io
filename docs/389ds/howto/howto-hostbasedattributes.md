---
title: "Howto:HostBasedAttributes"
---

# Host Based Attributes
-----------------------

It is sometimes useful to have different attribute values for different hosts. For example, for production machines, you may want to use a different shell (rbash) than you use for development machines (bash). Here is one way to do it.

You can use two different attributes (or the subtypes of an attribute). But it implies that the nss\_ldap configuration file on development servers is different. That's the way we do it. Example:

the user entry :

    dn: uid=test.user,ou=People,dc=example,dc=com    
    loginShell: /bin/rbash    
    loginShell;devel: /bin/bash    
    uid: test.user    
    ...    

If you use RedHat/CentOS 5.x the only difference between the nss\_ldap configuration files (/etc/ldap.conf) will be the mapping part on development servers :

    nss_map_attribute loginShell loginShell;devel    

This example uses the attribute subtype ';devel' but you are free to choose anything you like.

It's not a pure ldap solution, but rather a mix of ldap and server-side solution. Don't know whether it helps you but that's how we use it (this way,the same ldap user may have several "personalized" posix attributes depending on the /etc/ldap.conf configuration of the server) :

    nss_map_attribute uidNumber uidNumber;devel    
    nss_map_attribute gidNumber gidNumber;devel    
    nss_map_attribute homeDirectory homeDirectory;devel    
    nss_map_attribute loginShell loginShell;devel    
