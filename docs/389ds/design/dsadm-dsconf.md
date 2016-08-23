---
title: "dsadm and dsconf"
---

Introduction
==============

Administration of Directory Server has always been a complex topic. We have a variety of helper perl scripts that are installed with the instance. These administer specific parts of the server, but the server greater cannot be managed with them alone. We often have pushed people to the Java Console, or application of ldifs to the server.

These are at opposite extremes, the Java Console having it's own issues, but easy to use, where as the application of ldifs is at the opposite end of being highly complex.

As a result, we need a new way to administer Directory Server. It should contain extensive help, be a complete one stop, and command line focused.

Goal
======

A deployment and instance of Directory Server should be able to be setup, administered, and eventually decommisioned without ever applying an ldif. This should accomodate advanced usage, and basic usage.

Naming
======

dsconf and dsadm were the names used by another company for their similar tools. Despite this being a clean, unrelated implementation, we may change the name.

Current suggestions are:

* dsadm
* adm389
* dsctl
* nsadm

* dsconf
* conf389
* dscfg
* nsconf

This document will refer to these tools as dsadm and dsconf, but these may change in the future.

Design
========

dsconf vs dsadm
-----------------

dsadm is the tool to manage the "components of Directory Server that exist on the local host or container". This means that it will required root or privileged access, generally needs access to the filesystem, and will make changes to it. This will be used to create, start, stop, backup, restore and destroy instances.

dsconf is the tool to manage "configuration of Directory Server instances". This means that it can be run remotely, and will administer the server completely via the LDAP protocol. This will be used to manage backends/suffixes, indicies, plugins, logging and more.

The reason for the seperation is that dsadm requires different arguments and privileges (instance name, generally root) to run. dsconf will not need root, and can be run remotely (and requires a hostname) or while on the localsystem, can use ldapi autobind as root to access the Directory Manager account.

why python
------------

Lib389, our testing framework, already has all the parts needed to make an administrative toolkit. dsconf and dsadm are just wrappers on this. Consider

    # Not a complete script, misses the opening of a connection
    from lib389.backend import Backends
    bes = Backends()
    be_uroot = bes.get('userRoot')
    be_uroot.set('nsslapd-cachememsize', 10485760)

This is how we can set the database cachesize, using pure python. To wrap this to a command line is a very simple extension.

What will it look like
------------------------

    <command> <resource> <action> [<options>]

IE

    dsconf backend create dc=example,dc=com userRoot

For extra arguments these are provided with the same command flags as the openldap cli tools. IE

    dsconf -D 'cn=Directory Manager' -Z -H ldap://localhost backend list

New installer
---------------

A major component of this, is that dsadm will not use or rely on any of the existing perl scripts. As a result we will include and use the new SetupDs from lib389.

The new installer itself uses a simplified inf format compared to the current answer file.

A minimal install should only need:

    [general]
    config_version = 2
    [slapd]
    instance_name = standalone
    root_password = `pwdhash-bin password`

However, the new installer file also adds far more options. The goal is that *every* part of the Directory Server should be able to be configured from this answer file. This allows repeatable, scalable deployment both on hosts, containers, cloud and other uses cases I haven't even thought of yet.

A complete example can be generated with:

    dsadm instance example > /tmp/example.inf

The example being *generated* over commited, means we keep the internal code helptext up to date, and it *will* throw exceptions if it's not there. We are forced to keep it correct and up to date as a result.

Unit testing
--------------

The command line interface can be unit tested, and the current components are already tested in the pytest suite. This works because our output to the user is via the python logging module, and I have a loghandler that intercepts the output, and can assert it contains expected outputs. This brings gives us guarantees about our command lines tools and their correctness that we have never had before.

You can run these tests with the following:

    sudo PREFIX=/opt/dirsrv py.test-3 lib389/tests/cli/*
    sudo PREFIX=/opt/dirsrv py.test-3 lib389/tests/instance/*

As we add more commands and functions, we must add these to be tested also.

Examples
==========

Listing instances of Directory Server

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm instance list
    INFO:dsadm:No instances of Directory Server

Displaying the example inf

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm instance example
    ...snip...

Installing an instance (will do nothing)

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm instance create -n -f /tmp/example.inf

Actually dryrun installing an instance, acknowledging we know what we are up to (because pre-release, it may trash your system)

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm instance create -n -f /tmp/example.inf --IsolemnlyswearthatIamuptonogood
    INFO:dsadm:
     _________________________________________
    / This is not what you want! Press ctrl-c \
    \ now ...                                 /
     -----------------------------------------
    INFO:dsadm:4 ...
    INFO:dsadm:3 ...
    INFO:dsadm:2 ...
    INFO:dsadm:1 ...
    INFO:dsadm:0 ...
    INFO:dsadm:Launching ...
    INFO:dsadm.SetupDs:NOOP: dry run requested
    INFO:dsadm.SetupDs:FINISH: completed installation
    INFO:dsadm:FINISH: Command succeeded

Actually install now that dryrun passed.

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm instance create -f /tmp/example.inf --IsolemnlyswearthatIamuptonogood 
    INFO:dsadm:
     _________________________________________
    / This is not what you want! Press ctrl-c \
    \ now ...                                 /
     -----------------------------------------
    INFO:dsadm:4 ...
    INFO:dsadm:3 ...
    INFO:dsadm:2 ...
    INFO:dsadm:1 ...
    INFO:dsadm:0 ...
    INFO:dsadm:Launching ...
    INFO:lib389.tools:Setup error log
    WARNING:lib389.tools:Running command: '/opt/dirsrv/sbin/start-dirsrv localhost' - timeout(60)
    INFO:lib389.tools:start was successful for /opt/dirsrv/usr/lib64/dirsrv localhost
    INFO:dsadm.SetupDs:FINISH: completed installation
    INFO:dsadm:FINISH: Command succeeded

All the commands take a verbose flag, which adds greater output. Here is the install with verbose.

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsadm -v instance create -f /tmp/example.inf --IsolemnlyswearthatIamuptonogood 
    DEBUG:dsadm:The 389 Directory Server Administration Tool
    DEBUG:dsadm:Inspired by works of: ITS, The University of Adelaide
    DEBUG:dsadm:Called with: Namespace(ack=True, dryrun=False, file='/tmp/example.inf', func=<function instance_create at 0x7f66c45ad7b8>, instance=None, verbose=True)
    INFO:dsadm:
     _________________________________________
    / This is not what you want! Press ctrl-c \
    \ now ...                                 /
     -----------------------------------------
    INFO:dsadm:4 ...
    INFO:dsadm:3 ...
    INFO:dsadm:2 ...
    INFO:dsadm:1 ...
    INFO:dsadm:0 ...
    INFO:dsadm:Launching ...
    INFO:dsadm.SetupDs:Running setup with verbose
    INFO:dsadm.SetupDs:Using inf from /tmp/example.inf
    INFO:dsadm.SetupDs:Configuration ['general', 'slapd']
    DEBUG:dsadm.SetupDs:general:selinux not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:general:strict_host_checking not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:general:full_machine_name not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:general:defaults not in inf, or incorrect type, using default
    INFO:dsadm.SetupDs:Configuration general {'config_version': 2, 'selinux': True, 'strict_host_checking': True, 'full_machine_name': 'ldapkdc.example.com', 'defaults': '99999'}
    DEBUG:dsadm.SetupDs:slapd:user not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:lock_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:log_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:config_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:local_state_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:secure_port not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:tmp_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:db_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:run_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:root_dn not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:sysconf_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:cert_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:bin_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:backup_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:lib_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:sbin_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:port not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:ldif_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:group not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:schema_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:inst_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:data_dir not in inf, or incorrect type, using default
    DEBUG:dsadm.SetupDs:slapd:prefix not in inf, or incorrect type, using default
    INFO:dsadm.SetupDs:Configuration slapd {'user': 'dirsrv', 'lock_dir': '/opt/dirsrv/var/lock/dirsrv/slapd-localhost', 'log_dir': '/opt/dirsrv/var/log/dirsrv/slapd-localhost', 'config_dir': '/opt/dirsrv/etc/dirsrv/slapd-localhost', 'local_state_dir': '/opt/dirsrv/var', 'secure_port': 636, 'tmp_dir': '/tmp', 'db_dir': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost/db', 'run_dir': '/opt/dirsrv/var/run/dirsrv', 'root_dn': 'cn=Directory Manager', 'sysconf_dir': '/opt/dirsrv/etc', 'cert_dir': '/opt/dirsrv/etc/dirsrv/slapd-localhost', 'bin_dir': '/opt/dirsrv/bin', 'root_password': 'password', 'backup_dir': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak', 'lib_dir': '/opt/dirsrv/usr/lib64/dirsrv', 'sbin_dir': '/opt/dirsrv/sbin', 'port': 389, 'ldif_dir': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif', 'group': 'dirsrv', 'schema_dir': '/opt/dirsrv/etc/dirsrv/slapd-localhost/schema', 'instance_name': 'localhost', 'inst_dir': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost', 'data_dir': '/opt/dirsrv/share', 'prefix': '/opt/dirsrv'}
    INFO:dsadm.SetupDs:Configuration backends []
    INFO:dsadm.SetupDs:READY: preparing installation
    INFO:dsadm.SetupDs:PASSED: using config settings 99999
    INFO:dsadm.SetupDs:PASSED: user / group checking
    INFO:dsadm.SetupDs:PASSED: Hostname strict checking
    INFO:dsadm.SetupDs:PASSED: prefix checking
    INFO:lib389:dir (sys) : /opt/dirsrv/etc/sysconfig
    INFO:lib389:dir (priv): /root/.dirsrv
    INFO:dsadm.SetupDs:PASSED: instance checking
    INFO:dsadm.SetupDs:PASSED: root user checking
    INFO:dsadm.SetupDs:PASSED: network avaliability checking
    INFO:dsadm.SetupDs:READY: beginning installation
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/etc/dirsrv/slapd-localhost
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/etc/dirsrv/slapd-localhost
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/lock/dirsrv/slapd-localhost
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/log/dirsrv/slapd-localhost
    INFO:dsadm.SetupDs:ACTION: creating /opt/dirsrv/var/run/dirsrv
    INFO:dsadm.SetupDs:ACTION: Creating certificate database is /opt/dirsrv/etc/dirsrv/slapd-localhost
    INFO:dsadm.SetupDs:ACTION: Creating dse.ldif
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with localhost:389
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with localhost:389
    INFO:lib389:dir (sys) : /opt/dirsrv/etc/sysconfig
    INFO:lib389:dir (priv): /root/.dirsrv
    INFO:lib389:List from /root/.dirsrv
    INFO:lib389:list instance {'suffix': None, 'user-id': b'dirsrv', 'PRODUCT_NAME': 'slapd', 'deployed-dir': '/opt/dirsrv', 'ldap-port': 389, 'root-dn': b'cn=Directory Manager', 'DS_ROOT': '', 'SERVER_DIR': '/opt/dirsrv/usr/lib64/dirsrv', 'ldap-secureport': None, 'CONFIG_DIR': '/opt/dirsrv/etc/dirsrv/slapd-localhost', 'INST_DIR': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost', 'ldapi_enabled': None, 'ldapi_autobind': None, 'ldapi_socket': None, 'RUN_DIR': '/opt/dirsrv/var/run/dirsrv', 'hostname': b'ldapkdc.example.com', 'SERVERBIN_DIR': '/opt/dirsrv/sbin', 'SERVER_ID': 'localhost', 'server-id': 'localhost'}

    DEBUG:lib389.tools:Starting server <lib389.DirSrv object at 0x7f66c40dce10>
    INFO:lib389:dir (sys) : /opt/dirsrv/etc/sysconfig
    INFO:lib389:dir (priv): /root/.dirsrv
    INFO:lib389:List from /root/.dirsrv
    INFO:lib389:list instance {'suffix': None, 'user-id': b'dirsrv', 'PRODUCT_NAME': 'slapd', 'deployed-dir': '/opt/dirsrv', 'ldap-port': 389, 'root-dn': b'cn=Directory Manager', 'DS_ROOT': '', 'SERVER_DIR': '/opt/dirsrv/usr/lib64/dirsrv', 'ldap-secureport': None, 'CONFIG_DIR': '/opt/dirsrv/etc/dirsrv/slapd-localhost', 'INST_DIR': '/opt/dirsrv/var/lib/dirsrv/slapd-localhost', 'ldapi_enabled': None, 'ldapi_autobind': None, 'ldapi_socket': None, 'RUN_DIR': '/opt/dirsrv/var/run/dirsrv', 'hostname': b'ldapkdc.example.com', 'SERVERBIN_DIR': '/opt/dirsrv/sbin', 'SERVER_ID': 'localhost', 'server-id': 'localhost'}

    INFO:lib389.tools:Setup error log
    WARNING:lib389.tools:Running command: '/opt/dirsrv/sbin/start-dirsrv localhost' - timeout(60)
    DEBUG:lib389.tools:current line: '389-Directory/1.3.5.13 B2016.230.651'
    DEBUG:lib389.tools:current line: 'ldapkdc.example.com:389 (/opt/dirsrv/etc/dirsrv/slapd-localhost)'
    DEBUG:lib389.tools:current line: ''
    DEBUG:lib389.tools:current line: '[18/Aug/2016:11:21:33.376145057 +1000] 389-Directory/1.3.5.13 B2016.230.651 starting up'
    DEBUG:lib389.tools:current line: '[18/Aug/2016:11:21:33.723931690 +1000] slapd started.  Listening on All Interfaces port 389 for LDAP requests'
    INFO:lib389.tools:start was successful for /opt/dirsrv/usr/lib64/dirsrv localhost
    DEBUG:lib389:Retrieving entry with [('cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config
    nsslapd-accesslog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/access
    nsslapd-auditlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/audit
    nsslapd-bakdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak
    nsslapd-certdir: /opt/dirsrv/etc/dirsrv/slapd-localhost
    nsslapd-errorlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/errors
    nsslapd-instancedir: 
    nsslapd-ldifdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif
    nsslapd-schemadir: /opt/dirsrv/etc/dirsrv/slapd-localhost/schema

    ]
    DEBUG:lib389:Retrieving entry with [('cn=config,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config,cn=ldbm database,cn=plugins,cn=config
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db

    ]
    INFO:lib389:open(): Connecting to uri ldap://localhost:389/
    INFO:lib389:open(): bound as cn=Directory Manager
    DEBUG:lib389:Retrieving entry with [('cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config
    nsslapd-accesslog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/access
    nsslapd-auditlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/audit
    nsslapd-bakdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak
    nsslapd-certdir: /opt/dirsrv/etc/dirsrv/slapd-localhost
    nsslapd-errorlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/errors
    nsslapd-instancedir: 
    nsslapd-ldifdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif
    nsslapd-schemadir: /opt/dirsrv/etc/dirsrv/slapd-localhost/schema

    ]
    DEBUG:lib389:Retrieving entry with [('cn=config,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config,cn=ldbm database,cn=plugins,cn=config
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db

    ]
    INFO:lib389:open(): Connecting to uri ldap://localhost:389/
    INFO:lib389:open(): bound as cn=Directory Manager
    DEBUG:lib389:Retrieving entry with [('cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config
    nsslapd-accesslog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/access
    nsslapd-auditlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/audit
    nsslapd-bakdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak
    nsslapd-certdir: /opt/dirsrv/etc/dirsrv/slapd-localhost
    nsslapd-errorlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/errors
    nsslapd-instancedir: 
    nsslapd-ldifdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif
    nsslapd-schemadir: /opt/dirsrv/etc/dirsrv/slapd-localhost/schema

    ]
    DEBUG:lib389:Retrieving entry with [('cn=config,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config,cn=ldbm database,cn=plugins,cn=config
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db

    ]
    DEBUG:Config:cn=config set('nsslapd-rootpw', 'password')
    INFO:dsadm.SetupDs:FINISH: completed installation
    INFO:dsadm:FINISH: Command succeeded
    DEBUG:dsadm:dsadm is brought to you by the letter R and the number 27.

Now that we have an instance, show the backends:

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -D 'cn=Directory Manager' -H ldap://localhost backend list
    Enter password for cn=Directory Manager on ldap://localhost : 

    INFO:dsconf.backend_list:No objects to display

Create a backend

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -D 'cn=Directory Manager' -H ldap://localhost backend create
    Enter password for cn=Directory Manager on ldap://localhost : 

    Enter value for nsslapd-suffix : dc=example,dc=com
    Enter value for cn : userRoot
    INFO:dsconf.backend_create:Sucessfully created userRoot

Create a backend without interaction

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -D 'cn=Directory Manager' -H ldap://localhost backend create dc=another,dc=com anotherRoot
    Enter password for cn=Directory Manager on ldap://localhost : 

    INFO:dsconf.backend_create:Sucessfully created anotherRoot

List the backends

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -D 'cn=Directory Manager' -H ldap://localhost backend list
    Enter password for cn=Directory Manager on ldap://localhost : 

    INFO:dsconf.backend_list:anotherRoot
    INFO:dsconf.backend_list:userRoot

Again, dsconf has a verbose mode.

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -v -D 'cn=Directory Manager' -H ldap://localhost backend list
    DEBUG:dsconf:The 389 Directory Server Configuration Tool
    DEBUG:dsconf:Inspired by works of: ITS, The University of Adelaide
    DEBUG:dsconf:Called with: Namespace(basedn=None, binddn='cn=Directory Manager', func=<function backend_list at 0x7f2b3118fc80>, ldapurl='ldap://localhost', starttls=False, verbose=True)
    DEBUG:lib389:SER_SERVERID_PROP not provided
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with ldap://localhost
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with None:None
    Enter password for cn=Directory Manager on ldap://localhost : 
    DEBUG:lib389:SER_SERVERID_PROP not provided
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with ldap://localhost
    INFO:lib389:Allocate <class 'lib389.DirSrv'> with None:None
    INFO:lib389:open(): Connecting to uri ldap://localhost
    INFO:lib389:open(): bound as cn=Directory Manager
    DEBUG:lib389:Retrieving entry with [('cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config
    nsslapd-accesslog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/access
    nsslapd-auditlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/audit
    nsslapd-bakdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/bak
    nsslapd-certdir: /opt/dirsrv/etc/dirsrv/slapd-localhost
    nsslapd-errorlog: /opt/dirsrv/var/log/dirsrv/slapd-localhost/errors
    nsslapd-instancedir: 
    nsslapd-ldifdir: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/ldif
    nsslapd-schemadir: /opt/dirsrv/etc/dirsrv/slapd-localhost/schema

    ]
    DEBUG:lib389:Retrieving entry with [('cn=config,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=config,cn=ldbm database,cn=plugins,cn=config
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db

    ]

    DEBUG:Backend:cn=anotherRoot,cn=ldbm database,cn=plugins,cn=config getVal('cn')
    DEBUG:lib389:Retrieving entry with [('cn=anotherRoot,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=anotherRoot,cn=ldbm database,cn=plugins,cn=config
    cn: anotherRoot
    nsslapd-cachememsize: 10485760
    nsslapd-cachesize: -1
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db/anotherRoot
    nsslapd-dncachememsize: 10485760
    nsslapd-readonly: off
    nsslapd-require-index: off
    nsslapd-suffix: dc=another,dc=com
    objectClass: top
    objectClass: extensibleObject
    objectClass: nsBackendInstance

    ]
    INFO:dsconf.backend_list:anotherRoot
    DEBUG:Backend:cn=userRoot,cn=ldbm database,cn=plugins,cn=config getVal('cn')
    DEBUG:lib389:Retrieving entry with [('cn=userRoot,cn=ldbm database,cn=plugins,cn=config',)]
    INFO:lib389:Retrieved entry [dn: cn=userRoot,cn=ldbm database,cn=plugins,cn=config
    cn: userRoot
    nsslapd-cachememsize: 10485760
    nsslapd-cachesize: -1
    nsslapd-directory: /opt/dirsrv/var/lib/dirsrv/slapd-localhost/db/userRoot
    nsslapd-dncachememsize: 10485760
    nsslapd-readonly: off
    nsslapd-require-index: off
    nsslapd-suffix: dc=example,dc=com
    objectClass: top
    objectClass: extensibleObject
    objectClass: nsBackendInstance

    ]
    INFO:dsconf.backend_list:userRoot
    DEBUG:dsconf:dsconf is brought to you by the letter H and the number 25.

Finally, we can delete backends, and there are checks to make sure administrators know what they are doing.

    I0> sudo PREFIX=/opt/dirsrv /usr/sbin/dsconf -D 'cn=Directory Manager' -H ldap://localhost backend delete "cn=userRoot,cn=ldbm database,cn=plugins,cn=config" 
    Enter password for cn=Directory Manager on ldap://localhost : 

    Deleting Backend cn=userRoot,cn=ldbm database,cn=plugins,cn=config :
    Type 'Yes I am sure' to continue: Yes I am sure
    INFO:dsconf.backend_delete:Sucessfully deleted cn=userRoot,cn=ldbm database,cn=plugins,cn=config


Limitations
=============

Because lib389 is seperate to 389-ds-base there are a number of limitations.

Only silent installs are currently supported.

If you are running 389-ds-base in a seperate prefix (ie /opt/dirsrv), you *must* add the environment variable "PREFIX=/opt/dirsrv" to all your commands.

These new commands are highly likely to work under python3 only, but python2 support will be added in retrospect.

You will need to run this on at least Fedora 24 or greater.

Because of the prefix issue, there are issues determining default paths for 389-ds-base components. Due to this, you may neet to alter the content of Slapd2Base to allow your install to proceed, or override the values in your inf file. This will be solved by:

* Merging lib389 with 389-ds-base, and allowing the autotools to template the paths correctly.
* Adding a small python library to 389-ds-base that contains the base options, and we import those to lib389 (this creates a dependency loop)
* Having 389-ds-base generate an info file during build time that lib389 can then read. Issue with this is determining the known location of this file on various platforms where the prefix in the install changes and we cannot always deterministically control the location of this file (ie we would need to search multiple locations ....)

Future ideas
============

* .dsconfrc or similar that stores default hostname, binddn, starttls. and other options. To make the cli usage smoother.
* Ability to clone an existing server and output to an 'setup.inf'. Because of the structure of the installer, this is completely possible, even down to duplicating the rootdn password hash (even though we don't know it's content!)
* More strict checks for the pre-install verification. Including memory, cpu, filehandles etc. Basically absorb dsktune.
* When errors are found in the verification (dry run or not), output the offending settings, and what needs to change in the inf to correct the issue.

Author
--------

William Brown <wibrown at redhat.com>


