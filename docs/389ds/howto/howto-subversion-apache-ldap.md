---
title: "Howto: Subversion Apache LDAP"
---

# Subversion Apache LDAP
------------------------

The following describes how to get your SVN server authenticating users against a FreeIPA installation (which uses 389 as the directory server). This document was written using the following software:

Subversion Apache server:

-   subversion-1.4.2-4.el5
-   openldap-2.3.43-3.el5
-   httpd-2.2.3-22.el5.centos.2
-   mod\_ssl-2.2.3-22.el5.centos.2
-   mod\_dav\_svn-1.4.2-4.el5
-   mod\_authz\_ldap-0.26-8.el5

This document assumes you have a working installation of FreeIPA using the default LDAP schemas. If you are just trying to join SVN -\> LDAP with 389 standalone, you do not need FreeIPA installed. The main difference is the DNs used for looking up users.

/etc/httpd/conf.d/svn-ldap.conf
-------------------------------

    <---------------     /etc/httpd/conf.d/svn-ldap.conf    -------------->    
    <IfDefine SVN>
     # Work around authz and SVNListParentPath issue    
     RedirectMatch ^(/svn)$ $1/    
     # Enable Subversion logging    
     CustomLog logs/svn_logfile "%t %u %{SVN-ACTION}e" env=SVN-ACTION    
     # Load Subversion Apache Modules    
      <IfModule !mod_dav_svn.c>
       LoadModule dav_svn_module       modules/mod_dav_svn.so    
      </IfModule>
      <IfDefine SVN_AUTHZ>
        <IfModule !mod_authz_svn.c>
         LoadModule authz_svn_module     modules/mod_authz_svn.so    
        </IfModule>
      </IfDefine>
      <Location /svn>
      # Enable Subversion    
      DAV svn    
      # Require SSL    
      # See NOTE #1 for explanation    
      # RequireSSL    
      # Directory containing all repository for this path    
      SVNParentPath /svn    
      # List repositories colleciton    
      SVNListParentPath On    
      # Enable WebDAV automatic versioning    
      SVNAutoversioning On    
      # Repository Display Name    
      SVNReposName "Subversion Repository"    
      # Do basic password authentication in the clear    
      AuthType Basic    
      # The name of the protected area or "realm"    
      AuthName "Subversion Repository"    
      # Make LDAP the authentication mechanism    
      AuthBasicProvider ldap    
      # Make LDAP authentication is final    
      AuthzLDAPAuthoritative on    
      # Bind LDAP server using 'svn' account    
      AuthLDAPBindDN "uid=svn,CN=sysaccounts,CN=etc,DC=example,DC=com"    
      # This is the password for the AuthLDAPBindDN user    
      AuthLDAPBindPassword password    
      # The LDAP query URL -- NOTE: LDAP using SSL    
      AuthLDAPURL "ldaps://ipa.example.com/CN=users,CN=accounts,DC=example,DC=com?uid,nsAccountLock?sub?(ObjectClass=*)"    
      # Not exactly sure if this does anything...    
      # See NOTE #2 for explanation    
      Require ldap-attribute nsAccountLock!="true"    
      # Require a valid user    
      Require valid-user    
      # Authorization file    
      AuthzSVNAccessFile /svn/svn.acl    
      </Location>
      <Directory /svn>
       Options +Indexes FollowSymLinks    
       AllowOverride All    
       Order Allow,Deny    
       Allow from all    
      </Directory>
    </IfDefine>

### NOTE \#1

When RequireSSL is set, if your subversion clients try to access the repositories via HTTP then will get a 403 forbidden error. Attempting to redirect the SVN clients HTTP -\> HTTPS is unknown to me. I have tried everything from 'Redirect' apache tags, to simple 'meta refresh' redirections. They do not work. This is because the SVN client does not actually follow any redirects, just exits print the redirect header. I believe this is a security feature of SVN.

### NOTE \#2

nsAccountLock is a boolean LDAP attribute which is set to 'true' when the account in question is 'inactive' or set to 'false' when the account is active.

### NOTE \#3

The DN used for looking up users above is **CN=users,CN=accounts,DC=example,DC=com** - this is what FreeIPA uses. If using plain 389, the default location for users is **OU=People,DC=Example,DC=Com** (or whatever your base suffix is).

### NOTE \#4

You will need to first create the proxy user specified by the **AuthLDAPBindDN** directive, and set the password for that user to be used in the **AuthLDAPBindPassword** directive. The DN used above is for FreeIPA. For plain 389, the default user container is **OU=People,DC=Example,DC=Com**.

/etc/httpd/conf.d/ldap.conf
---------------------------

    <----------      /etc/httpd/conf.d/ldap.conf     --------->    
    <IfModule ldap_module>
      #  Number of search/bind entries to cache (default 1024)    
      # See NOTE #1 for explanation of why this is disabled    
      LDAPCacheEntries 0    
      #  The number of entries we use to cache    
      # LDAP compare operations.    
      LDAPOpCacheEntries 600    
      #  Seconds that an item in the search/bind    
      # cache remains valid (default 10 mins).    
      LDAPCacheTTL 600    
      #  Shared mem cache file    
      LDAPSharedCacheFile /etc/httpd/cache.shm    
          
      #  Bytes to allocate for the shared memory    
      # cache (default 1k).    
      LDAPSharedCacheSize 2048    
      #  Seconds that entries in the operation     
      # cache remain valid (default 10 mins).    
      LDAPOpCacheTTL 600    
    </IfModule>

NOTE #1
--------

Cache for LDAP needs to be disabled within Apache. If an account is set to be 'inactive', by default the user will have 10 minutes access to SVN repositories. Our organization needs this to be an atomic operation. Immediately after running the 'ipa-lockuser <user>' the account needs to be disabled, with no access to subversion.

From here you should be able to checkout SVN repos using user accounts defined within your LDAP database. Also note that when an account is disabled, Apache will return a 500 error code. It is thought that the error code returned from LDAP (53) is not recognized by the mod\_ldap plugin, and therefore believes it to be a server error.

