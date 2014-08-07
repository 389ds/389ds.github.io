---
title: "Howto: PAM Pass Through"
---

# PAM Pass Through Authentication Plug-in for Directory Server
---------------------------------------------------

{% include toc.md %}

Introduction
------------

Many organizations have authentication mechanisms already in place. They may not want to have the LDAP server be the central repository for authentication credentials and the authentication mechanism. The typical deployment would use PAM as the gateway to authentication. They do want to have many apps use the LDAP server for authentication and for authorization, user information, etc., just not as the authoritative data source for credentials. GSS/SASL is typically used for this e.g. for Kerberos, you can use your ticket to authenticate to the DS - the DS "passes through" the authentication to Kerberos. But many apps cannot (or will not) use SASL as their authentication mechanism - they must use simple cleartext password BINDs. For these applications, it would be very useful to have the DS pass through the auth creds to PAM.

BIND Preoperation Plugin for PAM
--------------------------------

The PAM BIND Preoperation Plugin intercepts the BIND request and uses the PAM API to authenticate the user.

Configuration
-------------

The administrator must be able to configure the following options in the plugin. These are the attributes of the objectclass pamConfig which is one of the objectclasses of the plugin entry:

-   suffixes (list of DNs) - suffixes to which this applies - these are suffixes that have been configured to be suffixes - these cannot be arbitrary subtrees
    -   pamExcludeSuffix - suffixes to be excluded from checking
    -   pamIncludeSuffix - suffixes to be included in checking and exclude all others
    -   excludes "win" in case of duplicates
    -   default is to apply to all suffixes if no includes or excludes are specified
-   pamMissingSuffix (string)
    -   ERROR: error and abort if excluded or included suffix does not exist
    -   ALLOW (default): warn if exclude or include is missing, but continue
    -   IGNORE: allow missing suffixes and don't log error
-   pamFallback (boolean) - if false, if PAM auth fails, the BIND operation fails. If true, if PAM auth fails, the DS will attempt other BIND mechanisms e.g. userPassword.
-   pamSecure (boolean) - if true, a secure connection is required
-   pamIDAttr (string) - The value of this attribute, present in the user's entry, holds the PAM identity of the user - it maps the LDAP identity to the PAM identity
-   pamIDMapMethod (string)
    -   RDN (default) - uses the value from the leftmost RDN in the BIND DN
    -   ENTRY - gets the value of the PAM identity attribute from the BIND DN entry
    -   DN - uses the full DN string
    -   NOTE: if ENTRY is specified as the method, pamIDMapAttr must be set in the plugin config entry, and user entries should have the named attribute
-   pamService (string) - the service argument to pam\_start()

Beginning in 389-ds-base version 1.2.11, there are some enhancements to allow for more flexible configuration. There is now support for using a LDAP filter to specify which entries the PAM passthru configuration applies to:

-   pamFilter - LDAP filter to identify entries which config applies to

In addition to the ability to specify a filter version 1.2.11 allows multiple PAM passthru configuration entries. Each child of the top-level PAM Passthru plug-in config entry in cn=config is expected to be a pamConfig entry in addition to the default config entry. This allows different configuration to be used for different sets of entries, such as different PAM service files used for different potions of the tree, or using a different mapping method for entries with a particular objectclass value.

There is also support in version 1.2.11 for using an alternate config area by setting the nsslapd-pluginConfigArea attribute to point to the area where the PAM passthru config entries reside. This allows the configuration entries to be in a replicated tree to have consistent config across all replicas. If an alternate config area is used, all children of the alternate config container are expected to be pamConfig entries. The alternate config container itself, as well as the top-level plug-in config entry in cn=config, are not treated as pamConfig entries.

Design
------

BIND -\> this plugin -\> get config -\> make sure arguments and state conform to config settings -\> pam\_start() -\> pam handshakes -\> get auth status -\> pam\_end() -\> report BIND status back to LDAP client

The big problem is - how to map the BIND DN to the user name given to pam\_start(). There are a couple of different ways to do this. One way is to just use the value part of the leftmost RDN in the BIND DN e.g. if you bound as uid=richm,ou=people,dc=example,dc=com, you would pass "richm" to PAM. Another way is to specify some attribute that must exist in the user's entry and use that value e.g. if my entry looks like this:

    dn: uid=richm,ou=people,dc=example,dc=com ... objectclass: inetOrgPerson objectclass: myOrgPerson \# has the extra attr ... myuid: rmeggins ...

"myuid" would be specified in the PAM plugin config. When I bind as uid=richm, the plugin would look up my entry, get the value of the "myuid" attribute, and use that value for PAM.

The password is the same password passed in as the BIND credentials.

We do not need to worry about PAM sessions - all we want to do is use PAM to verify the auth creds. However, we could implement sessions - we could do a pam\_open\_session() upon bind success and a pam\_close\_session() upon rebind, unbind, closure, or shutdown. However, this adds considerable complexity - must persist the pam\_handle\_t throughout the connection (probably in a connection extension), must ensure thread safe access to connection extension resources, must ensure clean up in a variety of situations. So, best to avoid it if possible.

We may have to worry about different PAM policy in different suffixes e.g. maybe for dc=coke,dc=com you want to use the ENTRY map method, but for dc=pepsi,dc=com you want to use the RDN method. We could probably do this by having the pamIDMapMethod attr be multivalued, and have it's value like this:

    pamIDMapMethod: RDN dc=coke,dc=com pamIDMapMethod: RDN dc=sprite,dc=com pamIDMapMethod: ENTRY dc=pepsi,dc=com pamIDMapMethod: DN (the default for all other suffixes)

The suffix that uses that map method would follow the map method used.

We need to worry about account expiration or lockout e.g. the user's credentials are valid but the user has been locked out of his/her account, or the password has expired, or something like that. Some of this can be handled by LDAP e.g. returning password policy control values when the password has expired. So we need to call pam\_acct\_mgmt() somewhere during the pam handshakes and before pam\_end() to get this information. We also try to return an appropriate LDAP error code.

|PAM Error Code|LDAP Error Code|Meaning|
|--------------|---------------|-------|
|PAM\_USER\_UNKNOWN|LDAP\_NO\_SUCH\_OBJECT|User ID does not exist|
|PAM\_AUTH\_ERROR|LDAP\_INVALID\_CREDENTIALS|Password is not correct|
|PAM\_ACCT\_EXPIRED|LDAP\_INVALID\_CREDENTIALS|User's password is expired|
|PAM\_PERM\_DENIED|LDAP\_UNWILLING\_TO\_PERFORM|User's account is locked out|
|PAM\_NEW\_AUTHTOK\_REQD|LDAP\_INVALID\_CREDENTIALS|User's password has expired and must be renewed|
|PAM\_MAXTRIES|LDAP\_CONSTRAINT\_VIOLATION|Max retry count has been exceeded|
|Other codes|LDAP\_OPERATIONS\_ERROR|PAM config is incorrect, machine problem, etc.|

There are three controls we might possibly add to the response:

-   the auth response control - returned upon success - contains the BIND DN (u: not currently supported)
-   LDAP\_CONTROL\_PWEXPIRED - returned when PAM reports ACCT\_EXPIRED or NEW\_AUTHTOK\_REQD
-   the new password policy control - returned when PAM reports

ACCT\_EXPIRED, NEW\_AUTHTOK\_REQD, PERM\_DENIED, MAXTRIES The controls can be used to get more information in the case of error (password incorrect or expired?).

The latter two must be requested by the client.

The plugin should report status in attributes of the plugin entry e.g. successfuls auth attempts, failed attempts, last pam error code and message, etc. We could also do this in an entry under cn=monitor. TBD.

Configuration Example
---------------------

This feature depends on a PAM configuration file. This assumes you already have a file in /etc/pam.d that controls your authentication, and that's what you want to use for the PAM passthru feature as well. You can either use that file directly (and make sure pamService below points to that file), or create your own /etc/pam.d/ldapserver. You probably don't need to do the latter unless you need to customize authentication for directory server for some reason.

1.  Shutdown the server
2.  Make sure /etc/dirsrv/slapd-instance/schema contains the 60pam-config.ldif file
3.  Make sure plugindir/libpam-passthru-plugin.so exists
4.  Make sure your PAM file exists and is configured correctly
5.  If the configuration is not already in dse.ldif, append the following to /etc/dirsrv/slapd-instance/dse.ldif

        dn: cn=PAM Pass Through Auth,cn=plugins,cn=config
        objectclass: top
        objectclass: nsSlapdPlugin
        objectclass: extensibleObject
        objectclass: pamConfig
        cn: PAM Pass Through Auth
        nsslapd-pluginpath: libpam-passthru-plugin
        nsslapd-plugininitfunc: pam_passthruauth_init
        nsslapd-plugintype: preoperation
        nsslapd-pluginenabled: on
        nsslapd-pluginLoadGlobal: true
        nsslapd-plugin-depends-on-type: database
        pamMissingSuffix: ALLOW
        pamExcludeSuffix: o=NetscapeRoot
        pamExcludeSuffix: cn=config
        pamIDMapMethod: RDN
        pamFallback: FALSE
        pamSecure: TRUE
        pamService: ldapserver

Make sure there is a blank line at the end. The line with o=NetscapeRoot may be omitted if this is not a configuration DS. Then restart slapd.

Testing
-------

I find it convenient to just test against regular /etc/passwd accounts.

1.  Create a server instance with suffix dc=example,dc=com and load the Example.ldif file
2.  cd /etc/pam.d
3.  cp system-auth ldapserver (make sure ldapserver is readable by nobody or whatever your ldap server account is)
4.  useradd scarter (or any uid from Example.ldif)
5.  passwd scarter - use a different password than the LDAP password
6.  Make sure /etc/shadow is readable by nobody or whatever your ldap server account is

You might want to turn off pamSecure for testing purposes unless you have already set up your server and ldap clients to use TLS.

Then you can run a test like this:

    ldapsearch -x -D "uid=scarter,ou=people,dc=example,dc=com" -w thepassword -s base -b ""    

Check /var/log/secure for any PAM authentication failures

PAM Pass Through to AD
----------------------

You can use Samba and pam\_winbind to pass through authentication requests to AD. First, copy the standard system-auth PAM config file to one called ldapserver:

    cp /etc/pam.d/system-auth /etc/pam.d/ldapserver    

Next, add the pam\_winbind stack - the line with pam\_winbind should be added after the pam\_env line and before the pam\_unix line

    #%PAM-1.0    
    # This file is auto-generated.    
    # User changes will be destroyed the next time authconfig is run.    
    auth        required      pam_env.so    
    auth        sufficient    pam_winbind.so    
    auth        sufficient    pam_unix.so nullok try_first_pass    
    ... rest of file is the same ...    

Then configure PAM passthrough on the directory server to use ldapserver as the pamService (this is usually the default value).

See Also
--------

PAM API for Linux <http://www.kernel.org/pub/linux/libs/pam/Linux-PAM-html/pam_appl.html> PAM API for Solaris Writing PAM Applications and Services from the Solaris Security for Developers Guide <http://docs.sun.com/app/docs/doc/816-4863/6mb20lvfh?a=view> PAM API for HP-UX <http://docs.hp.com/en/B2355-60103/pam.3.html>

