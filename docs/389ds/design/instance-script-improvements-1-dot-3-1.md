---
title: "Instance Script Improvements 1.3.1"
---

# Directory Server Scripts
--------------------------

Overview
--------

Most of the instance specific scripts have been converted to be system scripts located in /usr/sbin/. There are still "wrapper" scripts in the instance directory(/usr/lib64/dirsrv/slapd-INSTANCE) that call the scripts in /usr/sbin, and take the same usage. For the scripts that make LDAP connections to the Directory Server, you now have the option to specify the protocol**(StartTLS, LDAPS, LDAPI, or LDAP)**.

Use Cases
---------

Have the ability to call a single script, and be able to update any instance on the system. As well as control the protocol used to connect to the LDAP server.

Design
------

The new script take a new option, **-Z \<Server instance identifier\>**. The script will then use this information to gather things like the server location, and gather necessary configuration settings: port, root dn, security settings, etc. If there is only one instance on the system, then the **-Z** option can be omitted.

   Example where the server identifier is localhost(/etc/dirsrv/slapd-localhost):
       
    db2ldif -Z localhost -a /tmp/db.ldif -n userRoot

For the scripts that connect to the LDAP server, you can specify the protocol. Protocols include StartTLS, LDAPS, LDAPI, and LDAP. To set the protocol there is a new option -P \<protocol\>:

    db2ldif.pl -Z localhost -a /tmp/db.ldif -n userRoot -P LDAPI

If you omit the -P option, the script will attempt to use the most secure protocol available to the server instance. If you specify a protocol that is not supported or not available, the script will try and use the next most secure available protocol.

Implementation
--------------

No additional requirements.

Feature Management
-----------------

CLI only.

Major configuration options and enablement
------------------------------------------

New command line arguments:

    -Z <Server Instance Identifer>
      
        The server ID can be located by looking for the value after "slapi-":  /etc/dirsrv/slapd-localhost  --\>  "localhost" is the server identifier.  
      
    -P <Protocol>
      
        Valid protocol values are: StartTLS, LDAPS, LDAPI, and LDAP

Replication
-----------

No impact.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

