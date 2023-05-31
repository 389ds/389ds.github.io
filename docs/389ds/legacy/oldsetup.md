---
title: "OldSetup"
---
**This page describes Fedora Directory Server setup in 1.0.4 and earlier.** For newer versions, see [Setup](Setup "wikilink")

# Setup
-------

Quick Start
-----------

### Running Setup

To run the setup utility, change to the following directory:

    /opt/fedora-ds/setup    

Next, execute the setup utility:

    ./setup    

### License Agreement

You will be presented with the license terms. When you see the following question:

    Do you accept the license terms? (yes/no)    

Type "yes" and hit ENTER, if you agree to the license terms. Otherwise, type "no".

### Information

If you agreed to the license terms, next you will be presented with an information paragraph:

    =======================================================================     
                          Fedora Directory Server 1.0.4    
    =======================================================================    
    .    
    The Fedora Directory Server is subject to the terms detailed in the    
    license agreement file called LICENSE.txt.    
    .    
    Late-breaking news and information on the Fedora Directory Server    
    available at the following location:    
    .    
       http://fedora.redhat.com/
    .    
    Continue? (yes/no)    

Type "yes" and hit ENTER.

### System Parameter Check

Next, you may be presented with some notices and warnings about your system configuration:

    Fedora Directory Server system tuning analysis version 04-APRIL-2005.    
    .    
    NOTICE : System is i686-unknown-linux2.6.9-11.EL (1 processor).    
    .    
    WARNING: 1010MB of physical memory is available on the system. 1024MB is recommended for best performance on large production system.    
    .    
    NOTICE : The net.ipv4.tcp_keepalive_time is set to 7200000 milliseconds    
    (120 minutes).  This may cause temporary server congestion from lost    
    client connections.    
    .    
    WARNING: There are only 1024 file descriptors (hard limit) available, which    
    limit the number of simultaneous connections.      
    .    
    WARNING: There are only 1024 file descriptors (soft limit) available, which    
    limit the number of simultaneous connections.      
    .    
    .    
    Continue? (yes/no)     

If you are just installing a server to experiment with, then you can ignore all of those notices and warnings, type "yes", and hit ENTER.

If you are installing a production server, then you will probably want to cancel setup, tune your system according to the recommendations, and execute setup again.

Below are some recommendations for large production servers. More details may be found in the [Red Hat Directory Server Installation Guide](http://www.redhat.com/docs/manuals/dir-server/install/7.1/sn.prereq.osreqs.html)

1- create a new user and group "fedora-ds" to use when the setup promtp for it.

2- edit the /etc/sysctl.conf file:

    net.ipv4.tcp_keepalive_time = 300    
    net.ipv4.ip_local_port_range = 1024 65000    
    fs.file-max = 64000    

save, then sysctl -p to confirm everything is ok,

3- edit the /etc/security/limits.conf

    *        -        nofile        8192    

save

4- edit the /etc/pam.d/login file:

    session    required     /lib/security/pam_limits.so    

if is not already there.

### Install Mode

Next, you will be asked to choose the install mode:

    Please select the install mode:    
     1 - Express - minimal questions    
     2 - Typical - some customization (default)    
     3 - Custom - lots of customization    
    .    
    Please select 1, 2, or 3 (default: 2)     

Type "2" and hit ENTER.

### Hostname

You will be prompted for the hostname to use:

    Hostname to use (default: foohost.bigcorp.com)    

Hit ENTER.

### LDAP Server User ID

You will be prompted for the unprivileged user ID to run the LDAP server as:

    Server user ID to use (default: nobody)    

Hit ENTER or type fedora-ds if you created the suggested user and group above.

### LDAP Server Group ID

You will be prompted for the unprivileged group ID to run the LDAP server as:

    Server group ID to use (default: nobody)    

Hit ENTER or type fedora-ds if you created the suggested user and group above.

### Configuration Information Registration

You will be asked if you want to store the configuration information for this server in another Fedora Directory Server installation:

    Do you want to register this software with an existing    
    Fedora configuration directory server? [No]:     

Hit ENTER. Do not choose "yes" unless you know what you are doing (tm).

### Data Storage Directory

You will be asked if you want to use another directory server to store your data:

    Do you want to use another directory to store your data? [No]:    

Hit ENTER. Do not choose "yes" unless you know what you are doing (tm).

### LDAP Server Port

You will be prompted for the port number to run the directory server on:

    Directory server network port [389]:    

Hit ENTER.

### Directory Server Identifier

You will be prompted for the directory server identifier:

    Directory server identifier [foohost]:    

This is used to create the instance name, in this case "slapd-foohost", which is next to impossible to change later. This defaults to the hostname of the machine you are on. It is strongly recommended to change this to something more generic, and use the same identifier for all of the FDS instances in your organization.

If this is just a test installation, hit ENTER.

### Administrator User ID

You will be prompted for the administrator user ID:

    Fedora configuration directory server    
    administrator ID [admin]:     

Hit ENTER.

### Administrator Password

You will be prompted to assign a password for the admin user:

    Password:    

Type a password and hit ENTER. Type the same password again and hit ENTER.

### Suffix (Naming Context)

You will be prompted to assign a suffix to your directory tree:

    Suffix [dc=bigcorp, dc=com]:    

Hit ENTER. HINT: If you are evaluating Fedora Directory Server, use a suffix of dc=example,dc=com during setup. This will allow you to load the example database files which demonstrate the basic functions of the server as well as more advanced features such as Roles, Virtual Views, and i18n handling.

### Directory Manager Distinguished Name

You will be prompted for the distinguished name of the directory manager:

    Directory Manager DN [cn=Directory Manager]:    

Hit ENTER.

### Directory Manager Password

You will be prompted to assign a password for the directory manager user:

    Password:    

Type a password and hit ENTER. Type the same password again and hit ENTER.

### Administration Domain

You will be prompted for the administration domain:

    Administration Domain [bigcorp.com]:    

Hit ENTER.

### Administration Server Port

You will be prompted for the administration server port, with a random number:

    Administration port [20454]:    

It is strongly recommended to assign an easy to remember number, and use the same number in all the FDS instances in your organization.

Type "1500" and hit ENTER.

### Administration Server User ID

You will be asked whether to run the administration server as root:

    Run Administration Server as [root]:    

Hit ENTER.

### Path to Apache HTTPD Server

You will be asked for the path to the httpd or httpd.worker binary for Apache 2. On most Linux systems, this is /usr/sbin. On Solaris, it may be /usr/local/apache2/bin. On other operating systems, it may be /opt/httpd/bin.

    Path to Apache [/usr/sbin]:    

If the default is correct, hit ENTER, otherwise type in the path.

### Completion

At this point, the setup utility will configure a database instance and start the LDAP server (ns-slapd), and the administration server (httpd).

If everything went as expected, you should be now able to connect to your LDAP server as "cn=directory manager", using the password you supplied earlier. You can also type "./startconsole". For the username and password, you can provide the Administrator ID and password. For the server url, if there is no default value in there already, you can use "[http://localhost:administrationport/](http://localhost:administrationport/)" - i.e. the same port you provided above for the administration server.

