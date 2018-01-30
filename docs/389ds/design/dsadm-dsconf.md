---
title: "dsctl, dsconf and dsidm"
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

There are three tools we provide

dsctl - controls all aspects of a local instance. Generally needs root permissions.
dsconf - controls all aspects of an instances configuration. Uses ldap protocol against a live server, and can be used remotely. Generally needs cn=Directory Manager access.
dsidm - controls all aspects of data in a backend, ie users, groups, permissions. Can be used for self service commands. Can have delegated permissions.


Design
========

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

    dsconf ldaps://localhost backend create dc=example,dc=com userRoot

For extra arguments these are provided with the same command flags as the openldap cli tools. IE

    dsconf -D 'cn=Directory Manager' ldaps://localhost backend list

Many arguments can be preconfigured in a ~/.dsrc file, for example:

    [localhost]
    uri = ldaps://localhost
    basedn = dc=example,dc=com
    binddn = cn=Directory Manager

This allows you to use "aliases" of the configuration, rather than always typing URIs.

    dsconf localhost backend list


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

A complete example can be generated with:

    dscreate example > /tmp/instance.inf

The example being *generated* over commited, means we keep the internal code helptext up to date, and it *will* throw exceptions if it's not there. We are forced to keep it correct and up to date as a result.

The instance can then be installed with:

    dscreate fromfile /tmp/instance.inf

Unit testing
--------------

The command line interface can be unit tested, and the current components are already tested in the pytest suite. This works because our output to the user is via the python logging module, and I have a loghandler that intercepts the output, and can assert it contains expected outputs. This brings gives us guarantees about our command lines tools and their correctness that we have never had before.

You can run these tests with the following:

    sudo PREFIX=/opt/dirsrv py.test-3 lib389/tests/cli/*
    sudo PREFIX=/opt/dirsrv py.test-3 lib389/tests/instance/*

As we add more commands and functions, we must add these to be tested also.

Example usage
=============

Listing instances of Directory Server

    ???

Displaying the example inf

    I0> dscreate example
    ...snip...

Dryrun installing an instance (will verify your environment)

    I0> dscreate fromfile -n /tmp/instance.inf

Actually installing an instance

    I0> dscreate fromfile /tmp/instance.inf
    READY: Preparing installation for localhost
    READY: Beginning installation for localhost
    FINISH: Completed installation for localhost
    FINISH: Command succeeded

Doing a verbose install. All commands support a verbose flag that may help you understand issues or processes.

    I0> dscreate -v fromfile /tmp/instance.inf
    DEBUG: The 389 Directory Server Creation Tool
    DEBUG: Inspired by works of: ITS, The University of Adelaide
    DEBUG: Called with: Namespace(ack=False, containerised=False, dryrun=False, file='/tmp/instance.inf', func=<function instance_create at 0x7f2f2668fea0>, verbose=True)
    INFO: Running setup with verbose
    INFO: Using inf from /tmp/instance.inf
    INFO: Configuration ['general', 'slapd']
    DEBUG: general:strict_host_checking not in inf, or incorrect type, using default

    ...

    DEBUG: Pid of 30104 for localhost and running
    DEBUG: Pid of 30104 is not running for localhost
    WARNING: WARNING: Starting instance with ASAN options. This is probably not what you want. Please contact support.
    INFO: INFO: ASAN options will be copied from your environment
    INFO: FINISH: Completed installation for localhost
    INFO: FINISH: Command succeeded

Configure our .dsrc to make our instance easier to administer:

    [localhost]
    uri = ldaps://localhost
    basedn = dc=example,dc=com
    binddn = cn=Directory Manager
    tls_cacertdir = /opt/dirsrv/etc/dirsrv/slapd-localhost/

Now that we have an instance, show the backends. Remember, backends store suffixes of data like users and groups:

    I0> dsconf localhost backend list
    Enter password for cn=Directory Manager on ldaps://localhost :
    No objects to display
    Command successful.

Create a backend. First checking help for what we might need.

    I0> dsconf localhost backend create --help
    usage: dsconf instance backend create [-h] [--nsslapd-suffix [NSSLAPD_SUFFIX]]
                                          [--cn [CN]]

    optional arguments:
      -h, --help            show this help message and exit
      --nsslapd-suffix [NSSLAPD_SUFFIX]
                            Value of nsslapd-suffix
      --cn [CN]             Value of cn

    I0> dsconf localhost backend create       
    Enter password for cn=Directory Manager on ldaps://localhost : 
    Enter value for nsslapd-suffix : dc=example,dc=com
    Enter value for cn : userRoot
    Sucessfully created userRoot
    Command successful.

List the backends again to see it's there.

    I0> dsconf localhost backend list
    Enter password for cn=Directory Manager on ldaps://localhost : 
    userRoot
    Command successful.

We can populate our new backend with sample data. Because this is part of the database, it's in dsidm. This populates the suffix from your .dsrc "basedn" parameter.

    I0> dsidm localhost initialise
    Enter password for cn=Directory Manager on ldaps://localhost : 
    Command successful.

You can see there are demo users and groups:

    I0> dsidm localhost user list
    Enter password for cn=Directory Manager on ldaps://localhost : 
    demo_user
    Command successful.
    I0> dsidm localhost group list
    Enter password for cn=Directory Manager on ldaps://localhost : 
    demo_group
    Command successful.

We can even add our demo_user to the demo_group:

    I0> dsidm localhost group add_member demo_group uid=demo_user,ou=people,dc=example,dc=com
    Enter password for cn=Directory Manager on ldaps://localhost : 
    Command successful.

We can create users

    I0> dsidm localhost user create
    Enter password for cn=Directory Manager on ldaps://localhost : 
    Enter value for uid : william
    Enter value for cn : William
    Enter value for displayName : William Brown
    Enter value for uidNumber : 1000
    Enter value for gidNumber : 1000
    Enter value for homeDirectory : /home/william
    Sucessfully created william
    Command successful.

Lock their accounts

    I0> dsidm localhost user lock
    Enter password for cn=Directory Manager on ldaps://localhost : 
    Enter uid to check : william
    locked william
    Command successful.

Check that they can't login

    I0> dsidm localhost user status william
    Enter password for cn=Directory Manager on ldaps://localhost : 
    uid: william
    locked: True
    Command successful.

Unlock their account

    I0> dsidm localhost user unlock william
    Enter password for cn=Directory Manager on ldaps://localhost : 
    unlocked william
    Command successful.

There is much more that we can do today too, but this is just a taste. Please contact 389-users@lists.fedoraproject.org for more details or questions.

Author
--------

William Brown <william at blackhats.net.au>


