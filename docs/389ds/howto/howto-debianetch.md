---
title: "Howto :DebianEtch"
---

# Fedora DS on Debian Etch Howto
------------------------------

This document describes howto install the Fedora Directory Server (FDS) on Debian Gnu/Linux 4.0 (Etch). I presume you already have done a minimal installation of the OS of choice. This brief howto is based on [Howto-DebianUbunto](howto-debianubuntu.html) article and can be found [here](http://el-directorio.org/Fedora_Directory_Server/Instalaci%C3%B3n_Debian_Etch) in Spanish.

{% include toc.md %}

### Get the software

Download a prebuild rpm from [Download](../download.html). Choose the version suitable for Fedora Core 5.

### Install alien-package

Alien is a tool that supports converting software in 'rpm' format to 'deb' format.

    # apt-get install alien    

### Build the fedora-ds .deb package

    # alien -d --scripts fedora-ds-1.0.4-1.FC5.i386.opt.rpm    

### Build dependencies

The Fedora Directory Server needs 'libtermcap.so.2', but in Debian Etch does not exist as package. Then, you need:

    # apt-get install libncurses5-dev    
    # ln -s /usr/lib/libncurses.so /usr/lib/libtermcap.so.2    

Install the Sun Java SDK or JRE version 1.4.2. Don't forget to set the JAVA\_HOME and PATH variables! The admin-server of FDS depends on Apache2 compiled conform the worker model, so let's install it

    # apt-get install apache2-mpm-worker    

As Fedora calls the daemon 'httpd' while Debian calls it 'apache2', we want to create a symbolic link to satisfy FDS' setup utility.

    # ln -s /usr/sbin/apache2 /usr/sbin/httpd    

### Install .deb package

    # dpkg -i fedora-ds_1.0.4-2_i386.deb    

You can ignore the error message:

    /var/lib/dpkg/info/fedora-ds.postinst: line 10: [: configure: integer expression expected     

### Create a user and group for the daemon

    # groupadd fds    
    # useradd -s /bin/false -g fds fds    

### Run the setup program

Now we want to configure the FDS. As the setup utility won't find the Apache2 modules on Debian by default, we'll have to help it. First we'll create an install.inf file by running the setup utility with the '-k' option.

    # /opt/fedora-ds/setup/setup -k    

Choose '1' for as minimal questions as possible. Choose 'fds' when asked which user and group apply. After finalizing the setup wizard the directory server itself will be started as user 'fds'. It listens on the port you just configured (i chose port '389', the default LDAP-port). When done, copy the install.inf file to /opt

    # cp /opt/fedora-ds/setup/install.inf /opt    
    # chmod 640 /opt/install.inf    

Then add this rule to the [admin] section of the file:

    ApacheRoot=   /usr/lib/apache2    

Afterwards rerun the setup utility with the following options:

    # /opt/fedora-ds/setup/setup -s -f /opt/install.inf    

Ignore all the error messages:

    NMC_ErrInfo:     
    NMC_STATUS: -2    
    Can't start Admin server [/opt/fedora-ds/start-admin > /tmp/filep8BhwK 2>&1]     
    ...(error: No such file or directory)    

This will generate the required start/stop scripts for apache.

### Adjust the admin-server's httpd.conf

We have to make some changes to the '/opt/fedora-ds/admin-serv/config/httpd.conf' file. Some modules do not have to be loaded as they are compiled in statically. So un-comment these line (131):

    #LoadModule log_config_module /usr/lib/apache2/modules/mod_log_config.so    

### Now try to start the admin-server

    # /opt/fedora-ds/start-admin    

If it works, Good :-) If not, you probably didn't have enough coffee!

Cheers, Polkan GarcÃ­a

