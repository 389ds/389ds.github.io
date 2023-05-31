---
title: "register-ds-admin.pl and Remote Servers"
---

# register-ds-admin.pl and Remote Servers
----------------

{% include toc.md %}

Overview
--------

Previous versions of *register-ds-admin.pl* only allowed you to register local Directory Servers with an Admin Server/Configuration Server.  New to 389-admin-1.1.36, you can now register with remote servers.  In order to register with, or to, a remote server, both systems need to have an Admin Server installed that is registered with its local Directory Server configuration instance.  The Configuration Instance, or Configuration Server, is the Directory Server instance that contains the "**o=netscaperoot**" suffix.

Additionally the "silent" install/mode for those script was not fully implemented.  The new script can now be run completely without being prompted for data using an "**.inf**" file.

Use Cases
---------

Allowing remote servers to be registered with the Configuration Server will allow a single Admin Server/Console to manage all the Directory/Admin Servers in your network.  There is no longer a need to login into a separate Admin Server/Console for individual systems.  This makes managing a large deployment much easier, and centralized.

Design
------

### Remote Registration

Remote 389 deployments can now be registered with a local Configuration Server, or a local server can be registered on a remote Configuration Server.  It is important to note, all the systems involved must have an Admin Server installed, along with a configuration Directory Server instance.  If running the script on a system where an Admin Server is not yet installed, the script will create the admin server, and register it with a local Directory Server instance.  However, the script can not remotely install an Admin Server - so any remote system must always have a Admin Server installed.

Here is a image showing two separate systems being managed under one Admin Server/Configuration Server

![](../../../images/remote-console.png "Console Administration Tree")

### Silent Mode

The script can now be run in "*silent*" mode using an "**.inf**" file.  There are three types of registration processes to consider.  One, registering a local Directory Server instance with a local Admin Server.  Two, taking a standalone instance, adding the configuration suffix **o=netscaperoot**, and creating an admin server.  Three, registering with, or to, a remote *Configuration Server*.  Here are examples of an "**.inf**" file for each type:

#### Register Local Instance with Existing Configuration Server/Admin Server

This example adds/registers a standalone instance (*slapd-instance*) to the local Configuration Server (*slapd-configInstance*)

**register.inf**

    [General]
    FullMachineName= localhost.localdomain
    SuiteSpotUserID= dirsrv
    SuiteSpotGroup= dirsrv
    AdminDomain= example.com
    ConfigDirectoryAdminID= cn=directory manager
    ConfigDirectoryAdminPwd= password
    ConfigDirectoryLdapURL= ldap://localhost.localdomain:389/o=NetscapeRoot

    [register]
    configinst= slapd-configInstance::cn=directory manager::password
    localinst= slapd-instance::cn=directory manager::password

#### Create the Admin Server and convert a standalone instance into a Configuration Server

This example takes a single instance on a system, and creates an Admin Server (see the **[admin]** directive) and turns the Directory Server instance into a *Configuration Instance*.  The end result is as if you ran setup-ds-admin.pl the first time the instance was installed.

**register.inf**

    [General]
    FullMachineName= localhost.localdomain
    SuiteSpotUserID= dirsrv
    SuiteSpotGroup= dirsrv
    AdminDomain= example.com
    ConfigDirectoryAdminID= cn=directory manager
    ConfigDirectoryAdminPwd= password
    ConfigDirectoryLdapURL= ldap://localhost.localdomain:389/o=NetscapeRoot

    [admin]
    Port= 9830
    ServerIpAddress= 127.0.0.1
    ServerAdminID= admin
    ServerAdminPwd= password

    [register]
    configinst= slapd-standaloneInstance::cn=directory manager::password

#### Register the Local Configuration Server with a remote Configuration Server

This example demonstrates the versatility of this tool.  In this case we are taking a local Configuration Server, and adding it to a remote Configuration Server.  We are also registering a standalone instance (**slapd-standalone**) with the local Configuration Server prior to registering with the remote configuration server.  So two things are happening, we are adding/registering a standalone instance to the local Configuration Server.  Then we are registering the local Configuration Server, which now includes *slapd-standalone*, with a remote Configuration Server.

*register.inf*

    [General]
    FullMachineName= localhost.localdomain
    SuiteSpotUserID= dirsrv
    SuiteSpotGroup= dirsrv
    AdminDomain= example.com
    ConfigDirectoryAdminID= admin
    ConfigDirectoryAdminPwd= password
    ConfigDirectoryLdapURL= ldap://localhost.localdomain:389/o=NetscapeRoot


    [register]
    configinst= slapd-localhost::cn=directory manager::password
    localinst= slapd-standalone::cn=directory manager::password
    remotehost= hp-dl380pgen8-02-vm-11.lab.bos.redhat.com
    remoteport= 636
    localcertdir= /etc/dirsrv/slapd-localhost
    remotebinddn= cn=directory manager
    remotebindpw= password
    admindomain= beaker.com
    admindn= uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot
    adminpw= password
    destination= remote

#### Silent Install INF Register Parameters

Here is a detailed explanation of the parameters in the "**register**" directive section:

-   **configinst** = The local configuration server instance, or the instance you want to become the local Configuration Instance.  The value is always in the form "slapd-*INSTANCE*", as found in the **/etc/dirsrv/** directory.
-   **localinst** = Optional parameter.  Specifies additional Directory Server instances to register with the Configuration Instance.  This parameter is multivalued, so you can register as many local instances as you like.
-   **remotehost** = The remote host to which we are registering to, or with.
-   **remoteport** = The remote host's port/secure port.
-   **remotebinddn** = The bind DN used to authenticate to the remote server.  The root DN, or "*cn=directory manager*", is the preferred account.
-   **remotebindpw** = The password for the remotebinddn.
-   **localcertdir** = Optional parameter.  Specifies the the certificate database directory.  This is the directory where the cert8.db and key3.db files exist.  This is usually the Directory Server configuration directory:  **/etc/dirsrv/slapd-INSTANCE**
-   **admindomain** = This is the Admin Domain for the server that is being registered.  If registering the local server to the remote server, it would be the domain from the local server.  If registering a remote server to the local Configuration Server, it would be the Admin Domain from the remote server.
-   **admindn** = This is the local configuration Administrator's entry.  Using *Directory Manager* is also acceptable.
-   **adminpw** = The local configuration Administrators password.
-   **destination** = This is either set to "**local**" or "**remote**".  If "*local*", we registering the remote server with the local server.  If "*remote*", we are registering the local server with the remote configuration server.


Implementation
--------------

None

Major configuration options and enablement
------------------------------------------

None

Replication
-----------

None

Updates and Upgrades
--------------------

None

Dependencies
------------

None

External Impact
---------------

None

Author
------

<mreynolds@redhat.com>

