---
title: "Howto:SysVInit"
---

# SysVInit
----------

{% include toc.md %}

NOTE: init script is already provided with Fedora DS 1.1 and later
------------------------------------------------------------------

On linux and Solaris the init script is already provided and installed in the correct place. On linux, you will still have to run

    chkconfig fedora-ds on    

to make fedora-ds start at boot time.

The following information is for 1.0.x and earlier versions only.

SysV Init scripts for Fedora DS
-------------------------------

[Here](http://directory.fedoraproject.org/download/FedoraDirectoryServer-init.d) is a link to an init script. [Here](http://directory.fedoraproject.org/download/fedora-ds-init.d) is another. [Here](http://directory.fedoraproject.org/download/fedora-ds-admin-init.d) is one for the Admin Server. There are some issues to take into consideration:

-   I tried to utilize whenever possible or sensible the existing scripts in /opt/fedora-ds/slapd-\*

-   The script iterates over each slapd server id.

-   The script does not cleanly fit into the existing model of service management as provided by the /etc/init.d/functions utility code. This is due to the following factors:
    -   we're controlling multiple "services" but pretending its one
    -   the slapd process is not named for the slapd instance (most of the init.d utility code assumes a correspondence between service name and process name)
    -   the pid location and interpretation is non-standard
    -   fedora ds has its own startup and shutdown scripts

-   The script treats all slapd servers as a member of the FedoraDirectoryServer service. It lists each slapd server it is operating on in a list. The return code is the first non-zero return code for a slapd server. If any slapd server has a non-zero return code the failing slapd servers are listed separately.

-   There was no status script in /opt/fedora-ds/slapd-\* therefore I copied the logic for testing status from start-slapd. The status is based on the "pid" file, its does not look at the "startpid" file. The reasoning is the pid file is valid when the slapd server is available to service clients, the "boot" period represented by startpid is not likely to be an interesting metric of running status.

-   The script fully supports start,stop,restart,reload,condrestart,status

-   We've initially installed the script as FedoraDirectoryServer

-   The chkconfig start/kill ordering numbers probably need to be adjusted.

-   The whole service control mechanism is going to be reworked in an upcoming release. This script represents a temporary stop gap. Reworking the service control mechanism probably makes sense because as outlined above the existing mechanism is a bit of a square peg in a round hole.

### Init Scripts for Suse 9/10

[Here](http://directory.fedoraproject.org/download/fedora-ds.suse) is a link to an init script for the directory server, and [here](http://directory.fedoraproject.org/download/fedora-ds-admin.suse) is one for the admin server. When you download and install the files, be sure to remove the .suse suffix.

Then, after downloading the files:

### fedora-ds script

    chmod 755 fedora-ds    
    cp fedora-ds /etc/init.d/    
    ln -s /etc/init.d/fedora-ds /usr/sbin/rcfedora-ds    

Edit /etc/init.d/fedora-ds and change APP\_NAME var value to name of you application, and enable the service in yast or in console.

    chkconfig fedora-ds on    

### fedora-ds-admin

    chmod 755 fedora-ds-admin    
    cp fedora-ds-admin /etc/init.d/    
    ln -s /etc/init.d/fedora-ds-admin /usr/sbin/rcfedora-ds-admin    

And enable the service in yast or in console

    chkconfig fedora-ds-admin on    

