---
title: "SELinux Policy"
---

# SELinux Policy
----------------

{% include toc.md %}

Overview
--------

The long running server executables should be protected by SELinux policy. The policy will dictate what ports and files each given executable is allowed to access.

Executables to Protect
----------------------

### Directory Server (ns-slapd)

This is the main directory server daemon. It has the ability to run in different modes (such as **ldif2db** mode for importing). Only the normal daemon mode (such as **start-slapd** or **service dirsrv start**) will be confined by SELinux.

The ns-slapd daemon will be confined in a domain called **dirsrv\_t**.

It should be noted that a set of new scripts related to controlling the **ns-slapd** process were added to assist in transitioning the process into the confined **dirsrv\_t** domain. These are the **start-dirsrv**, **stop-dirsrv**, and **restart-dirsrv** scripts. These scripts are generally useful for controlling the running state of your Directory Server instances. They work similar to our dirsrv init script. If you run these scripts with no arguments, they operate on all instances. You can optionally specify the instance name you want the script to operate on (with the **slapd-** prefix).

#### Path Access

The dirsrv policy allows the confined **ns-slapd** daemon to work with it's default paths (settings such as nsslapd-dbdir, nsslapd-rundir, nsslapd-ldapifilepath). It is highly recommended that these paths not be altered when confining **ns-slapd**, otherwise the administrator will need to configure their own policy to ensure that all files and directories are labelled properly.

Below is a table listing the file contexts used by the dirsrv policy for **ns-slapd**:

|Path|Context|Description|
|----|-------|-----------|
|/etc/dirsrv/\*|dirsrv\_config\_t|Config files|
|/usr/sbin/ns-slapd|dirsrv\_exec\_t|Main server executable|
|/usr/sbin/start-dirsrv|initrc\_exec\_t|Server start script|
|/usr/sbin/restart-dirsrv|initrc\_exec\_t|Server restart script|
|/usr/lib\<64\>/dirsrv/\*|dirsrv\_lib\_t|Server libraries, plug-in libraries|
|/usr/share/dirsrv/\*|dirsrv\_share\_t|Property files, templates|
|/var/lib/dirsrv/\*|dirsrv\_var\_lib\_t|Database files, ldif files, backups|
|/var/lock/dirsrv/\*|dirsrv\_var\_lock\_t|Lock files|
|/var/log/dirsrv/\*|dirsrv\_var\_log\_t|Log files|
|/var/run/dirsrv/\*|dirsrv\_var\_run\_t|PID files & SNMP stats file|

File labeling will need to be taken into account for any file that **ns-slapd** may need to access. Keep this in mind when doing things like online imports or exports. The default paths will work fine. Another situation worth mentioning is when setting up Kerberos for SASL/GSSAPI support, you will need to ensure that **ns-slapd** is allowed to access the keytab you specify by setting KRB5\_KTNAME in the dirsrv sysconfig script. The best way of ensuring this is to copy your keytab into /etc/dirsrv to ensure it is labeled as **dirsrv\_config\_t**.

#### Port Access

The confined **ns-slapd** daemon will only be allowed to listen on ports labelled as **ldap\_port\_t**. The base SELinux policy already uses this label on the standard LDAP ports (**389** and **636**).

The regular (non-SSL/TLS) LDAP port used by DS is configurable at setup time. The setup scripts will modify the policy to properly label the selected port if they are not labelled already. The remove scripts will unlabel the port from the policy when an instance is removed.

Setting up SSL/TLS is something that is done post-setup, so we have no way of automatically labeling the LDAPS port if it is something other than the standard port **636**. The administrator will need to label the port themselves in this case. This can be done from the command line as follows (example assumes port **1636** is being labelled:

    semanage port -a -t ldap_port_t -p tcp 1636    

To remove the label from the command line, the following command would be used:

    semanage port -d -t ldap_port_t -p tcp 1636    

Port labeling can also be managed from the GUI tool **system-config-selinux**.

### SNMP Subagent (ldap-agent)

This is the SNMP sub-agent program used for monitoring Directory Server instances via SNMP. It will be confined by the **dirsrv\_snmp\_t** domain.

To aid in confining **ldap-agent**, some changes were made around the subagent. An init script was added, so the recommended way of controlling the running state of **ldap-agent** now is using the **service** command like so:

    service dirsrv-snmp start    
    service dirsrv-snmp stop    
    service dirsrv-snmp restart    
    service dirsrv-snmp status    

When the service command is used, **ldap-agent** will use **/etc/dirsrv/config/ldap-agent.conf** as it's config file. We now provide this file as a config template which should cut down on configuration errors.

#### Port Access

The subagent does not listen on any ports itself. The sub-agent simply communicates with the snmpd main agent, which accesses the ports itself.

#### Path Access

The **ldap-agent** daemon is allowed to access certain files covered by the **ns-slapd** file contexts listed above. The table below lists the file contexts specific to **ldap-agent**: ! Path !! Context !! Description |- | /usr/sbin/ldap-agent-bin || dirsrv\_snmp\_exec\_t || SNMP subagent daemon |- | /var/run/ldap-agent.pid || dirsrv\_snmp\_var\_run\_t || SNMP subagent PID file |- | /var/log/dirsrv/ldap-agent.log || dirsrv\_snmp\_var\_log\_t || SNMP subagent log file |}

### Admin Server (httpd)

The Admin Server daemon is really just the Apache webserver (**httpd.worker**). We simply extend the existing httpd SELinux policy, so Admin Server will run under the **httpd\_t** domain. During startup, the start script itself does run under the **dirsrvadmin\_t** domain, but it will transition to **httpd\_t** when we actually start the webserver.

An important issue to note is that you must use the **service** command to start Admin Server if you want it to be properly confined. The **start-ds-admin** script will not be supported when SELinux is being used. Here are some examples of using the **service** command to control Admin Server:

    service dirsrv-admin start    
    service dirsrv-admin restart    
    service dirsrv-admin stop    

The CGIs invoked by the Admin Server run under their own special confined domain named **httpd\_dirsrvadmin\_script\_t**.

#### Path Access

The table below lists the file contexts specific to the extended **httpd.worker** daemon. There are other contexts within the httpd policy that apply as well, but there is no need to document those here.

    ! Path !! Context !! Description |- | /usr/sbin/start-ds-admin || dirsrvadmin\_exec\_t || Admin Server start script |- | /usr/sbin/restart-ds-admin || dirsrvadmin\_exec\_t || Admin Server restart script |- | /usr/sbin/stop-ds-admin || dirsrvadmin\_exec\_t || Admin Server stop script |- | /etc/dirsrv/admin-serv/\* || dirsrvadmin\_config\_t || Config files |- | /var/log/dirsrv/admin-serv/\* || httpd\_log\_t || Log files |- | /var/run/dirsrv/admin-serv.\* || httpd\_var\_run\_t || PID file |- | /usr/lib/dirsrv/cgi-bin/\* || httpd\_dirsrvadmin\_script\_exec\_t || CGI programs |}

#### Port Access

The confined **httpd.worker** daemon will only be allowed to listen on ports labelled as **http\_port\_t**. The base SELinux policy already uses this label on the standard HTTP ports (including **80** and **443**).

The regular (non-SSL/TLS) HTTP port used by Admin Server is configurable at setup time. The setup script will modify the policy to properly label the selected port if it is not labelled already. The remove script will unlabel the port from the policy when the Admin Server instance is removed.

Setting up SSL/TLS is something that is done post-setup, so we have no way of automatically labeling the HTTPS port if it is something other than the standard port **443**. The administrator will need to label the port themselves in this case. This can be done from the command line as follows (example assumes port **1443** is being labelled:

    semanage port -a -t http_port_t -p tcp 1443    

To remove the label from the command line, the following command would be used:

    semanage port -d -t http_port_t -p tcp 1443    

Port labeling can also be managed from the GUI tool **system-config-selinux**.
