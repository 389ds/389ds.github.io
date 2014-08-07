---
title: "Howto: Ldap/Nss With SSL"
---

# How to configure NSS LDAP for SSL usage with PAM ?
---------------------------------------------

This topic is related to the Linux client configuration for PAM, but in this article, we just want to configure the NSS library so that glibc can lookup user or group information into LDAP using SSL.

Please note that:

-   Configuring SSL on the ldap server is documented [here](howto-ssl.html)
-   Configuring the ldap server to only listen on SSL is documented [here](howto-listensslonly.html)
-   Configuring PAM is documented [here](howto-pam.html)
-   Password policies are documented at <https://www.redhat.com/docs/manuals/dir-server/ag/7.1/password.html#1077081>

If you want to use startTLS, you need the non-secure port 389, if you only want SSL or TLS, then just use port 636.
To add support for SSL in to nss\_ldap on the clients, you will have to edit and modify the nss\_ldap and pam\_ldap configuration file, /etc/ldap.conf

Example, for SSL only:

Provide with the IP address of your ldap server

    host 1.2.3.4    

Provide with the base to search in, and scope to search the entire subtree

    base dc=sometest    
    scope sub    

Provide using an uri with ldap over ssl

    uri ldaps://<some-fully-qualified-hostname>/

LDAP protocol version and port for SSL

    ldap_version 3    
    port 636    

Provide with a root dn to bind with. The associated password in in /etc/ldap.secret by default, and with mode 0400

    rootbinddn uid=<some-nss-ldap-bind-uid>,dc=<some-component>,dc=sometest    

Provide some time out values

    timelimit 120    
    bind_timelimit 120    
    idle_timelimit 3600    

So, /etc/ldap.conf looks like this (note there is no pam info for this example, as we focus on SSL only in this article):

    host 1.2.3.4
    base dc=sometest
    scope sub
    uri ldaps://<some-fully-qualified-hostname>/
    ldap_version 3
    port 636
    rootbinddn uid=<some-nss-ldap-bind-uid>,dc=<some-component>,dc=sometest
    timelimit 120
    bind_timelimit 120
    idle_timelimit 3600

Ldapsearch command line example using SSL:
Note: the CA cert was manually imported as described in <http://directory.fedoraproject.org/wiki/Howto:SSL#Import_the_CA_cert_into_another_Fedora_DS>

    export LD_LIBRARY_PATH=/opt/fedora-ds/shared/lib/
    /opt/fedora-ds/shared/bin/ldapsearch -Z -W <some-key-file-password> -P /opt/fedora-ds/alias/slapd-<instance-name>-cert8.db \
    -h <some-ldap-server> -D "uid=<some-nss-ldap-bind-uid>,dc=<some-component>,dc=sometest" -w <some-nss-ldap-bind-pw> \
    -b dc=sometest "(&(objectClass=posixGroup))"

LDAP server access log example:

    [17/Oct/2007:16:17:33 -0700] conn=30 fd=64 slot=64 SSL connection from 1.2.3.4 to 5.6.7.8    
    [17/Oct/2007:16:17:33 -0700] conn=30 SSL 256-bit AES    
    [17/Oct/2007:16:17:33 -0700] conn=30 op=0 BIND dn="uid=<some-nss-ldap-bind-uid>,dc=<some-component>,dc=sometest" method=128 version=3    
    [17/Oct/2007:16:17:33 -0700] conn=30 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=<some-nss-ldap-bind-uid>,dc=<some-component>,dc=sometest"    
    [17/Oct/2007:16:17:33 -0700] conn=30 op=1 SRCH base="dc=sometest" scope=2 filter="(&(objectClass=posixGroup))" attrs="cn userPassword memberUid uniqueMember gidNumber"    
    [17/Oct/2007:16:17:33 -0700] conn=30 op=1 RESULT err=0 tag=101 nentries=51 etime=0    

