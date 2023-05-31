---
title: "Howto:systemd"
---

# systemd
---------

{% include toc.md %}

Introduction
------------

<http://www.freedesktop.org/wiki/Software/systemd>

Use **systemctl** instead of **service** to control 389 daemons and get the running status.

Install
-------

The 389-ds-base package installs the following during yum/rpm install:

-   /lib/systemd/system/dirsrv@.service - this is the systemd template file used for instances
-   /lib/systemd/system/dirsrv.target - this is the "target" file used to operate on all instances of directory server together
-   /etc/systemd/system/dirsrv.target.wants/ - this is the directory used for instances created with setup (see below)
-   /etc/sysconfig/dirsrv.systemd - you can add systemd directives to this file such as LimitNOFILE or LimitCORE - they will apply to all instances
    -   if you need to add systemd directives that are specific to an instance

    rm /etc/systemd/system/dirsrv.target.wants/dirsrv@INSTANCENAME.service    
    cp /lib/systemd/system/dirsrv@.service /etc/systemd/system/dirsrv.target.wants/dirsrv@INSTANCENAME.service    
    edit /etc/systemd/system/dirsrv.target.wants/dirsrv@INSTANCENAME.service    
    add the systemd directives to the [Service] section    
    systemctl daemon-reload    

-   /etc/sysconfig/dirsrv and /etc/sysconfig/dirsrv-INSTANCENAME are still used to set environment variables - but you cannot use shell syntax - for example do this

    KRB5_KTNAME=/path/to/ds.keytab    

not

    export KRB5_KTNAME=/path/to/ds.keytab    

nor

    KRB5_KTNAME=/path/to/ds.keytab ; export KRB5_KTNAME    

If you try to use shell syntax to set the environment variable, your definition will be silently ignored

The 389-admin package installs the following during yum/rpm install:

-   /lib/systemd/system/dirsrv-admin.service - this is the systemd service file

dirsrv-admin.service has a dependency on dirsrv.target so that if it is enabled to start at boot time, it will be started after dirsrv.target - that is, after all dirsrv instances have been started.

Setup
-----

Running setup-ds.pl or setup-ds-admin.pl will create the symlink /etc/systemd/system/dirsrv.target.wants/dirsrv@INST.service -\> /lib/systemd/system/dirsrv@.service. This is what allows dirsrv.target to operate on all of the service instances together. Running remove-ds.pl or remove-ds-admin.pl will remove the symlink.

FAQ
---

<http://www.freedesktop.org/wiki/Software/systemd/FrequentlyAskedQuestions>

### How do I stop/start/restart/check status/etc. of the 389 daemons? Or where did /etc/init.d/dirsrv go

#### Old Way

-   In 389 in older versions EL6, EL5, very old Fedoras

        service dirsrv start

#### New way Fedora 15+

-   cite: <http://fedoraproject.org/wiki/Systemd#What_is_the_status_of_systemd_in_Fedora.3F>

For 389-ds-base (dirsrv) - it depends on if you want to operate on all instances at once, or if you want to operate on a per-instance basis. All of the slapd instances on the system use the target **dirsrv.target**. Individual instances use **dirsrv@INSTNAME.service**. For example, if you have two instances - /etc/dirsrv/slapd-foo and /etc/dirsrv/slapd-bar:

    systemctl start dirsrv.target    

would start both instances. If you just wanted to restart instance *foo*:

    systemctl restart dirsrv@foo.service    

### How do I make it start at boot time?

systemctl enable|disable

    systemctl enable dirsrv.target # start all instances at boot time    
    systemctl enable dirsrv@instname.service # start only instance instname at boot time    

### How to get the servers status with systemctl

"systemctl status <options>" returns the status of the server(s).  If the options are a list of instance name of the servers or PIDs, the status is accurate.  While if the option is dirsrv.target, it may not be.  We recommend to use the instance names or PIDs to get the servers status.

On the systemd version 219 or newer, systemctl option takes a wildcard (*).  Using the wildcard, the command line 

    systemctl status dirsrv@*

works in the same way as 

    systemctl status dirsrv@instance1 dirsrv@instance2 ...

does without specifying every server instance name.  See also https://bugzilla.redhat.com/show_bug.cgi?id=1202178 for more details.

### How do I do the run level configuration?

### Where did chkconfig go?

See <https://fedoraproject.org/wiki/Systemd#How_do_I_change_the_runlevel.3F> and <https://fedoraproject.org/wiki/Systemd#How_do_I_change_the_default_runlevel.3F>

### How do I set global or per-instance environment variables?

You still use /etc/sysconfig/dirsrv and /etc/sysconfig/dirsrv-INSTANCE - **But you must use systemd syntax, not shell syntax** - for example, use this

    KRB5_KTNAME=/path/to/ds.keytab    

not

    export KRB5_KTNAME=/path/to/ds.keytab    

nor

    KRB5_KTNAME=/path/to/ds.keytab ; export KRB5_KTNAME    

If you try to use shell syntax to set the environment variable, your definition will be silently ignored

### <a name="enablecore"></a>How do I enable core files?

With sysv init, you would just add something like

    ulimit -c unlimited    

to /etc/sysconfig/dirsrv - but systemd doesn't support that

Edit /etc/sysconfig/dirsrv.systemd - in the [Service] section add

    LimitCORE=infinity    

then do

    systemctl daemon-reload    

you will also have to restart the directory server for the changes to take effect.

### <a name="increase-fd"></a>How do I increase the file descriptor limit?

With sysv init, you would just add something like

    ulimit -n 8192    

to /etc/sysconfig/dirsrv - but systemd doesn't support that

Edit /etc/sysconfig/dirsrv.systemd - in the [Service] section add

    LimitNOFILE=8192    

or whatever number you want, then do

    systemctl daemon-reload    

you will also have to restart the directory server for the changes to take effect.

Links
-----

Note: the systemd documentation is still undergoing changes as of this writing (April 26, 2011)

-   <http://fedoraproject.org/wiki/Features/systemd>
-   <https://fedoraproject.org/wiki/TomCallaway/Systemd_Revised_Draft>
-   <http://0pointer.de/public/systemd-man/daemon.html>
-   <https://fedoraproject.org/wiki/User:Johannbg/QA/Systemd/compatability>

