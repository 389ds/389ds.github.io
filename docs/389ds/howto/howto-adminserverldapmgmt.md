---
title: "Howto: AdminServerLDAPMgmt"
---

# How to manage the Admin Server using LDAP
-----------------------------------------

{% include toc.md %}

### Introduction

The [Admin Server](../administration/adminserver.html) uses the Directory Server to store its configuration. One of the directory server instances has the o=NetscapeRoot suffix. This instance is also referred to as the Configuration Directory Server. This is the one that the Admin Server uses to store its configuration in. This is usually the first directory server instance that is installed - if there is not one during the setup process, setup will configure the directory server being setup as a configuration directory server.

The Admin Server uses the [AdminUtil](../administration/adminutil.html) library to store its configuration. This library not only uses the directory server but also uses a local read-only cache file (/etc/dirsrv/admin-serv/local.conf or with Fedora DS 1.0.4 /opt/fedora-ds/admin-serv/config/local.conf) that it uses for bootstrap purposes. Since the file is read-only, the real configuration must be edited in the directory server.

NOTE WELL: **The Configuration Directory Server must be running in order to start the Admin Server**. You will get errors like the following if you attempt to start or run the admin server if the configuration directory server is not running:

    [Fri Dec 16 12:00:00 2005] [crit] mod_admserv_post_config(): unable to build user/group LDAP server info: unable to set User/Group baseDN

So if you get strange LDAP errors in your Admin Server error log (/var/log/dirsrv/admin-serv/error or with Fedora DS 1.0.4 /opt/fedora-ds/admin-serv/logs/error), check to make sure that the directory server is running, and even check the directory server access log (/var/log/dirsrv/slapd-instancename/access or with Fedora DS 1.0.4 /opt/fedora-ds/slapd-instancenamelogs/access) to see if the admin server is BINDing and SRCHing.

NOTE WELL: **Firewalls must allow localhost access**. If you are using iptables or some other firewall, you must allow access to the directory server and the admin server from localhost (127.0.0.1) and your DNS hostname if you have configured DNS.

### How to find the Admin Server configuration entry

The Admin Server configuration entry has an objectclass of nsAdminConfig. You can find it using ldapsearch and modify it using ldapmodify. These tools are usually found in /usr/bin on linux systems. If those are not found, use /usr/lib/mozldap or /usr/lib64/mozldap. If you are using Fedora DS 1.0.4, these tools are in /opt/fedora-ds/shared/bin. NOTE that /usr/bin/ldap\* require the -x argument - so if you see [-x] below, that means to use -x with /usr/bin/ldap\* but omit it with the others.

    ldapsearch [-x] -b o=netscaperoot -D "cn=directory manager" -w password "objectclass=nsAdminConfig" dn

If you want to see all of the data in the entry, omit the trailing " dn". Example:

    dn: cn=configuration, cn=admin-serv-localhost, cn=Fedora Administration Server
    , cn=Server Group, cn=localhost.localdomain, ou=localdomain, o=NetscapeRoot
    objectClass: nsConfig
    objectClass: nsAdminConfig
    objectClass: nsAdminObject
    objectClass: nsDirectoryInfo
    objectClass: top
    cn: Configuration
    nsServerPort: 34866
    nsSuiteSpotUser: nobody
    nsServerAddress:
    nsAdminEnableEnduser: on
    nsAdminEnableDSGW: on
    nsDirectoryInfoRef: cn=Server Group, cn=localhost.localdomain, ou=localdomain,
      o=NetscapeRoot
    nsAdminCacheLifetime: 600
    nsAdminAccessAddresses: *
    nsAdminOneACLDir: adminacl
    nsDefaultAcceptLanguage: en
    nsAdminAccessHosts: * 
    ...

### How to set the hosts/IP addresses allowed to access the Admin Server

This is controlled by attributes nsAdminAccessAddresses and nsAdminAccessHosts in the Admin Server configuration entry (see above). If you're not sure about your DNS and reverse DNS configuration, you should not use host based access, you should use IP address based access. You can use ldapmodify to configure these attributes (see above for NOTE about ldap\* commands and -x):

    ldapmodify [-x] -D "cn=directory manager" -w password
    dn: dn of your admin server config entry
    changetype: modify
    replace: nsAdminAccessAddresses
    nsAdminAccessAddresses: 192.168.1.*
    -
    replace: nsAdminAccessHosts
    nsAdminAccessHosts: *

You will need to restart the admin server for these changes to take effect.

    service dirsrv-admin restart

or with Fedora DS 1.0.4:

    /opt/fedora-ds/restart-admin

If you want to just allow access from everywhere, just use "*" for the value of nsAdminAccessAddresses, and make nsAdminAccessHosts empty e.g. with ldapmodify:

    dn: dn of your admin server config entry
    changetype: modify
    replace: nsAdminAccessAddresses
    nsAdminAccessAddresses: *
    -
    delete: nsAdminAccessHosts

### How to change the user/group LDAP server

You can also get the following error

    [Fri Dec 16 12:00:00 2005] [crit] mod_admserv_post_config(): unable to build user/group LDAP server info: unable to set User/Group baseDN

if you have changed the configuration for the directory server used by the admin server. There are a couple of files and directory entries that the admin server uses to get information about which directory server to use. The file /etc/dirsrv/admin-serv/adm.conf or with Fedora DS 1.0.4

    /opt/fedora-ds/admin-serv/config/adm.conf
    /opt/fedora-ds/shared/config/dbswitch.conf

The entry can be found by first doing the following ldapsearch:

    ldapsearch -x -b o=netscaperoot -D "cn=directory manager" -w password "nsDirectoryURL=*"

On my test system, my DN is

    dn: cn=UserDirectory, ou=Global Preferences, ou=localdomain, o=NetscapeRoot

Next, use ldapmodify to fix the url:

    ldapmodify [-x] -D "cn=directory manager" -w password
    dn: DN of your entry (as above)
    changetype: modify
    replace: nsDirectoryURL
    nsDirectoryURL: ldap[s]://FQDN:port/suffix

You can use ldaps instead of ldap for a secure connection (be sure to change the port number) e.g. on my system:

    nsDirectoryURL: ldap://localhost.localdomain:10200/dc=example,dc=com

You'll need to restart the admin server for the changes to take effect (and the console too).

