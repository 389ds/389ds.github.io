---
title: "Howto: OpenWebmail"
---

# Integrating Openwebmail with FDS
------------------------------------

This application is used so that the openwebmail could connect to FDS.

{% include toc.md %}

**Openwebmail File And Modify**
-------------------------------

Edit /var/www/cgi-bin/openwebmail/etc/defaults/auth\_ldap.conf

     # 
     # Config file for auth_ldap.conf
     #
     
     ldaphost      127.0.0.1             # If localhost with run FDS
     ou            People                # Organization Unit create in FDS with you need authenticate
     cn            Directory Manager     # Ldap User. You no need this for working if installing default. This is necessary if you need the change                           
                                         # password in openwebmail.
     dc1           example               # First DC, example.com
     dc2           com                   # Second DC
     password      dsmanager             # Ldap password. You no need this for working if installing default.This is necessary if you need the change                           
                                         # password in openwebmail.

**FDS Changes and Modify**
--------------------------

-   Go to FDS console with /opt/fedora-ds/ and run ./startconsole
-   Login with admin user. Default is admin.
-   In the tree go to Directory Server.
-   Press the button Open.
-   Go to Directory tab.
-   Expand your Directory and select your organization.
-   In People Organization Unit (ou=People) locate or create the User ID account (uid).
-   In type of user select Posix User and enable it.
-   Fill the fields. Its good idea UID and GID number equal to UID and GID number of the accounts in the system, equal with the home directory.

**Long Domain Name**
--------------------

If the Domain Name is longer than example.com (dc=example, dc=com) with this other.example.com (dc=other, dc=example, dc=com) do:

Edit /var/www/cgi-bin/openwebmail/etc/defaults/auth\_ldap.conf

     # 
     # Config file for auth_ldap.conf
     #
     
     ldaphost      127.0.0.1 # If localhost with run FDS
     ou            People    # Organization Unit create in FDS with you need authenticate
     cn                      # Ldap User. You no need this for working if installing default.
     dc1           other     # Firt DC, other.example.com
     dc2           example   # Second DC
     dc3           com       # Third DC
     #dc[n]        more      # [n] DC
     password                # Ldap password. You no need this for working if installing default.

Edit /var/www/cgi-bin/openwebmail/auth/auth\_ldap.pl

-   Go to ldap search definition

        my $ldapHost = $conf{'ldaphost'};
        my $ou  = "ou=$conf{'ou'}";
        my $cn  = "cn=$conf{'cn'}";
        my $dc1 = "dc=$conf{'dc1'}";
        my $dc2 = "dc=$conf{'dc2'}";
        my $pwd = $conf{'password'};

-   Add the line of the extra dc

        my $dc3 = "dc=$conf{'dc3'}";
        my $dc[n] = "dc=$conf{'dc[n]'}"; # More if you need

-   Find and modify some line with make reference to the ldap search for example:

        $ldap->bind (dn=>"$cn, $dc1, $dc2", password =>$pwd) or  return(-3, "LDAP error $@");
        Change to
        $ldap->bind (dn=>"$cn, $dc1, $dc2, $dc3", password =>$pwd) or  return(-3, "LDAP error $@");
        Or every you need
        $ldap->bind (dn=>"$cn, $dc1, $dc2, $dc3, $dc[n]", password =>$pwd) or  return(-3, "LDAP error $@");

**Change password from openwebmail to FDS**
-------------------------------------------

-   Edit file auth\_ldap.pl (/var/www/cgi-bin/openwebmail/etc/auth/auth\_ldap.pl)

     Locate the perl function change_userpassword.    
     Modify the line     

        $ldap->bind (dn=>"$cn, $dc1, $dc2", password =>$pwd) or  return(-3, "LDAP error $@");
        for    
        $ldap->bind (dn=>"$cn", password =>$pwd) or  return(-3, "LDAP error $@");

**Openwebmail Address Book**
----------------------------

-   Find and modify openwebmail.conf (/var/www/cgi-bin/openwebmail/etc/openwebmail.conf).

Add de variables:

     enable_ldap_abook    yes    
     ldap_abook_host      example.com #or the ip address    
     ldap_abook_user      uid=ldapuser,ou=People,dc=example,dc=com #create the user account you need in ldap or leave in blank.    
     ldap_abook_password  ldapuserexample #create the user account you need in ldap or leave in blank.    
     ldap_abook_base      dc=example,dc=com # Or the path you need for seek the user account data.    
     ldap_abook_prefix    ou # In this example, the openwebmail-abook extract the information of every ldap tree.    
     ldap_abook_cache     1 # 1 minute for refresh the data.    

If you need more help see openwebmail.conf.help in the some path of openwebmail.conf.

