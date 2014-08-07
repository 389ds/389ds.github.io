---
title: "Howto: ListenSSLonly"
---

# How to configure the directory server to listen on secure port only ?
-------------------------------------------------

If you want to configure your ldap server to only listen on secure port, stop the server, edit the main server configuration file, dse.ldif for the entry cn=config, and change the value of nsslapd-port to 0, save and restart.

When you set nsslapd-port to 0, the server will not listen for non-secure connections. If this attribute is not present in the entry, add it as the last line in the cn=config entry - make sure there are no empty lines before this one, and make sure there is a single empty line after it, before the start of the next entry.

Example:

Stop your ldap instance:

    /opt/redhat-ds/slapd-    <instance-name>    /stop-slapd    

Save and edit the main configuration file:

    cp -p /opt/redhat-ds/slapd-<instance-name>/config/dse.ldif /opt/redhat-ds/slapd-<instance-name>/config/dse.ldif-`/bin/date +%F-%R`
    vi /opt/redhat-ds/slapd-<instance-name>/config/dse.ldif    

Under dn: cn=config, change from:

    nsslapd-port: 389    

to:

    nsslapd-port: 0    

Then restart your ldap instance:

    /opt/redhat-ds/slapd-<instance-name>/start-slapd    

You should see something similar to this in the error logs:

    [17/Sep/2007:15:08:57 -0700] - Information: Non-Secure Port Disabled, server only contactable via secure port
    Enter PIN for Internal (Software) Token: 
    [17/Sep/2007:15:09:04 -0700] - Red Hat-Directory/7.1 SP3 B2006.207.178 starting up
    [17/Sep/2007:15:09:06 -0700] - Listening on All Interfaces port 636 for LDAPS requests

To configure SSL, please refer to:

-   <http://directory.fedoraproject.org/wiki/Howto:SSL>
-   <http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Managing_SSL.html>

