---
title: "LDAPI and AutoBind"
---

# LDAPI and AutoBind
--------------------

Overview
========

LDAP client-server connection using the UNIX socket. It's opened in parallel with the ordinary TCP connections. Since it's a UNIX socket, the client and the server should be on the same host.

Implementation
==============

LDAPI
-----

The server checks nsslapd-ldapifilepath and nsslapd-ldapilisten config attributes at the start up time. If both values are set and nsslapd-ldapilisten is "on", a UNIX socket is opened and bound to the UNIX socket file path specified by nsslapd-ldapifilepath. The LDAPI socket is opened in addition to the ordinary TCP/IP sockets in the same internal function createprlistensockets.

AUTO-BIND
---------

Auto-bind is implemented as a part of LDAPI. If LDAPI is not enabled, auto-bind never be functional. By turning on auto-bind "nsslapd-ldapiautobind: on", clients are authenticated with the UNIX uid and gid that the client program is executed as. To avoid the confusion with the anonymous bind, the auto-bind feature is effective only when the authentication request is passed with SASL/EXTERNAL.

The auto-bind feature is made from three functions.

-   If "nsslapd-ldapimaptoentries" value is "on", the uid and gid are searched with the filter "(&(uidNumber=<uid>)(gidNumber=<gid>)" under the search base "nsslapd-ldapientrysearchbase" value. Once a matched entry is found, the client is authenticated as the entry. If none or multiple entries are found, the map-to-entries is considered failed and falls through the next step. The uidNumber and gidNumber attribute name are configurable with "nsslapd-ldapiuidnumbertype" and "nsslapd-ldapigidnumbertype", respectively. Password is not necessary in the authentication.
-   If "nsslapd-ldapimaptoentries" is "off" or no or multiple entries are found, auto-bind gives up if the client is an ordinary user. But if the client is a super user, the identity is mapped to the value of nsslapd-ldapimaprootdn and authenticated as the entry. Password is not necessary in the authentication since the client is already authenticated as the UNIX user. If the value is "cn=Directory Manager", the client is authenticated as the Directory Manager.
-   The last chance is the value specified by "nsslapd-ldapiautodnsuffix" (auto dn suffix). If the value exists (assuming the value is <autodnsuffix>), the client is authenticated as "gidNumber=<gid>+uidNumber=<uid>, <autodnsuffix>. The default value of <autodnsuffix> is "cn=peercred,cn=external,cn=auth". Note: auto dn suffix is not built in by default. To enable auto dn suffix, build the directory server with --enable-auto-dn-suffix.
-   None of the above is satisfied, anonymous bind.


                             nsslapd-ldapiautobind
                             /                  \
                            / on                 \ off
                           v                      \
              nsslapd-ldapimaptoentries            \
                 |                    \             \
                 | on                  \ off         \
                 v                      \             \
               search w/                 \             \
               (&(uidNumber=<uid>)        \             \
                 (gidNumber=<gid>))        \             \
            from <entrysearchbase>          \             \
               |             |               \             \    
               | an entry    | no or multiple |             \    
               | found       | entries found  |              \    
               v             \                |               \    
             bound as the     \               |                \    
             entry             \              |                 \    
                                v             v                  \    
                                Is <uid> root?                    \    
                               / yes         \ no                  \ 
                              v               v                     \ 
                        bound as       [nsslapd-ldapiautodnsuffix]  |
                        <rootdn>              |                     |
                                              v                     |
                                         bound as                   |
                                 "gidNumber=<gid>+                  v
                                  uidNumber=<uid>,             anonymous bind
                                  <autodnsuffix>"


Build configuration parameters
==============================

        --enable-ldapi          enable LDAP over unix domain socket (LDAPI) support (default: yes)
        --enable-autobind       enable auto bind over unix domain socket (LDAPI) support (default: no)
        --enable-auto-dn-suffix enable auto bind with auto dn suffix over unix
                                domain socket (LDAPI) support (default: no)

Directory Server configuration attributes (cn=config in dse.ldif)
=============================================

config in dse.ldif) = With --enable-ldapi, these attribute value pairs are added to cn=config. By default, nsslapd-ldapilisten is off. Set "on" to turn on the LDAPI functionality.

        nsslapd-ldapifilepath: /var/run/slapd-<ID>.socket
        nsslapd-ldapilisten: off

The value of nsslapd-ldapifilepath is used for the UNIX socket path.

With --enable-autobind, these attribute value pairs are added to cn=config. Autobind is implemented to use the UNIX uid and gid for the LDAP authentication. It first detects the client's uid and gid. If it's root (uid == 0), it's mapped to "nsslapd-ldapimaprootdn" value. If it's not root, it searches an entry with the filter (&(uidNumber=<uid>)(gidNumber=<gid>)). If an entry is found, the client is authenticated as the searched user entry. The autobind is enabled if "nsslapd-ldapiautobind" is "on". The (&(uidNumber=<uid>)(gidNumber=<gid>)) mapping is executed only when "nsslapd-ldapimaptoentries" is "on". That is, if nsslapd-ldapimaptoentries is not on, only a superuser can be the target of autobind.

        nsslapd-ldapiautobind: off
        nsslapd-ldapimaprootdn: cn=Directory Manager
        nsslapd-ldapimaptoentries: off
        nsslapd-ldapiuidnumbertype: uidNumber
        nsslapd-ldapigidnumbertype: gidNumber
        nsslapd-ldapientrysearchbase: <your_suffix>

Usage samples
=============

Mozilla LDAP client does not support LDAPI yet. Therefore, the OpenLDAP client tools are used in the following test cases.

LDAPI
-----

### List all the entries under "cn=config" using the Directory Manager credential. ###

        # ldapsearch -x -H ldapi://%2fvar%2frun%2fslapd-ID.socket -D "cn=Directory Manager" -w password -b "cn=config" "(objectclass=*)"

AUTO-BIND
---------

### Login as root, search "cn=config" without passing the authentication credentials. ###

It requires Directory Manager privilege to obtain all the entries. Result: the search returns all the entries.

        # ldapsearch -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket -b "cn=config" "(objectclass=*)" dn    
        # config    
        dn: cn=config

        # encryption, config    
        dn: cn=encryption,cn=config 
   
        # features, config    
        dn: cn=features,cn=config
  
        # mapping tree, config    
        dn: cn=mapping tree,cn=config  
  
        # plugins, config    
        dn: cn=plugins, cn=config    
        [...]    

        # uniquemember, index, userRoot, ldbm database, plugins, config    
        dn: cn=uniquemember, cn=index, cn=userRoot, cn=ldbm database, cn=plugins, cn=config    
        # search result    
        search: 2    
        result: 0 Success    
        # numResponses: 125    
        # numEntries: 124    

Other authentication mechanisms including simple authentication

### Login as an ordinary user, search "cn=config" without passing the authentication credentials. ###

It requires Directory Manager privilege to obtain all the entries. Result: the search returns one entry which has the access right for the user.

        $ ldapsearch -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket -b "cn=config" "(objectclass=*)" dn    
        # SNMP, config    
        dn: cn=SNMP,cn=config    
        # search result    
        search: 2    
        result: 0 Success    
        # numResponses: 2    
        # numEntries: 1    

### 2 posix users are prepared, one has the test user's uid and gid; another has a bogus pair.

        $ ldapsearch -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket -b "dc=example,dc=com" "(uid=*)"    
        # iuser0, example.com    
        dn: uid=iuser0, dc=example,dc=com    
        objectClass: top    
        objectClass: person    
        objectClass: organizationalPerson    
        objectClass: inetOrgPerson    
        objectClass: posixAccount    
        cn: ldapi user0    
        sn: user0    
        uid: iuser0    
        uidNumber: 10000    
        gidNumber: 10000    
        givenName: ldapi    
        description: test user 0    
        mail: iuser0@example.com    
        homeDirectory: /home/iuser0    
        loginShell: /bin/bash 
   
        # iuser1, example.com    
        dn: uid=iuser1, dc=example,dc=com    
        objectClass: top    
        objectClass: person    
        objectClass: organizationalPerson    
        objectClass: inetOrgPerson    
        objectClass: posixAccount    
        cn: ldapi user1    
        sn: user1    
        uid: iuser1    
        uidNumber: 10001    
        gidNumber: 10001    
        givenName: ldapi    
        description: test user 1    
        mail: iuser1@example.com    
        homeDirectory: /home/iuser1    
        loginShell: /bin/bash    


### Modify an attribute value of the entry which uid and gid pair matches the login user's.

        $ ldapmodify -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket    
        dn: uid=iuser0, dc=example,dc=com    
        changetype: modify    
        replace: description    
        description: modified test user0    
        modifying entry "uid=iuser0, dc=example,dc=com"    

The value of description is successfully modified.

        $ ldapsearch -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket -b "dc=example,dc=com" "(uid=iuser0)" description    
        # iuser0, example.com    
        dn: uid=iuser0, dc=example,dc=com    
        description: modified test user0    
        # search result    
        search: 2    
        result: 0 Success    
        # numResponses: 2    
        # numEntries: 1    

### Modify an attribute value of the entry which uid and gid pair is different from the login user's.

        $ ldapmodify -Y EXTERNAL -H ldapi://%2fvar%2frun%2fslapd-ID.socket    
        dn: uid=iuser1, dc=example,dc=com    
        changetype: modify    
        replace: description    
        description: modified test user1    
        modifying entry "uid=iuser1, dc=example,dc=com"    
        ldap_modify: Insufficient access (50)    
               additional info: Insufficient 'write' privilege to the 'description' attribute of entry     
               'uid=iuser1,dc=example,dc=com'.

The operation fails due to the insufficient 'write' privilege as expected.

