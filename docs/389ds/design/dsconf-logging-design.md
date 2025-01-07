---
title: "dsconf logging subcommands design"
---

# CLI dsconf logging subcommands design
----------------

Overview
--------

Updating the logging settings, especially log levels, requires special knowledge before using the CLI dsconf command. It would be nice to have a CI interface for working with these specific settings. The main motivation for this was the frustration of setting log levels: having to find the level values in the docs (not always easy), and trying to figure out what levels are set by just looking at a number and doing some math. The CLI should make working with this easier, and if we are going to do this for the logging levels then we should do it for all the log settings.


Design
------

Use a more positional argument style of setting values that requires less argument values

    dsconf INSTANCE logging "access|error|security|audit|auditfail" get  --> get the configuration for that log
    dsconf INSTANCE logging "access|error|security|audit|auditfail" list-levels  --> list all log levels using friendly names instead of numbers
    
    dsconf INSTANCE logging "access|error|security|audit|auditfail" set logging-enabled
    dsconf INSTANCE logging "access|error|security|audit|auditfail" set logging-disabled
    dsconf INSTANCE logging "access|error|security|audit|auditfail" set buffering-enabled
    dsconf INSTANCE logging "access|error|security|audit|auditfail" set max-size <size in MB>
    dsconf INSTANCE logging "access|error|security|audit|auditfail" set level <level name> <level name> <level name>
    dsconf INSTANCE logging "access|audit" set log-format <format>  --> JSON logging only
    dsconf INSTANCE logging "access|audit" set time-format <format> --> JSON logging only
    ...
    ...
    
Examples
-----------

    # dsconf slapd-localhost logging error get 
    Buffering enabled = off
    Compression enabled = off
    Deletion interval = 1
    Deletion interval unit = month
    File mode = 600
    Log level = 
    Log name and location = /var/log/dirsrv/slapd-localhost/errors
    Logging enabled = on
    Max disk space = 100
    Max log size = 100
    Max logs = 2
    Minimum free disk space = 5
    Rotation interval = 1
    Rotation interval unit = week
    TOD rotation enabled = offs
    TOD rotation hour = 0
    TOD rotation minute = 0
    
    # dsconf slapd-localhost logging access list-levels
    
    Level         Description
    --------------------------------------------------------------------------------
    entry         Log entry and referral stats
    default       Standard access logging
    internal      Log internal operations
    
    
    # dsconf slapd-localhost logging error list-levels
    
    Level         Description
    --------------------------------------------------------------------------------
    acl           Provides very detailed access control list processing information
    aclsumary     Summarizes information about access to the server, much less verbose than level 'acl'
    backend       Backend debug logging
    ber           Logs the number of packets sent and received by the server
    cache         Database entry cache logging
    config        Prints any .conf configuration files used with the server, line by line, when the server is started
    connection    Logs the current connection status, including the connection methods used for a SASL bind
    default       Default logging level
    filter        Logs all of the functions called by a search operation
    heavytrace    Logs when the server enters and exits a function, with additional debugging messages
    house         Logging for housekeeping thread
    packet        Network packet logging
    parse         Logs schema parsing debugging information
    plugin        Plugin logging
    pwpolicy      Debug information about password policy behavior
    replication   Debug replication logging
    shell         Special authentication/connection tracking
    trace         Logs a message when the server enters and exits a function


    # dsconf slapd-localhost logging error set level replication plugin
    Successfully set error log level
    
    # dsconf slapd-localhost logging error set max-logs 9999
    Successfully updated error log configuration
    
    # dsconf slapd-localhost logging error get 
    Buffering enabled = off
    Compression enabled = off
    Deletion interval = 1
    Deletion interval unit = month
    File mode = 600
    Log level = replication,plugin
    Log name and location = /var/log/dirsrv/slapd-localhost/errors
    Logging enabled = on
    Max disk space = 100
    Max log size = 100
    Max logs = 9999
    Minimum free disk space = 5
    Rotation interval = 1
    Rotation interval unit = week
    TOD rotation enabled = off
    TOD rotation hour = 0
    TOD rotation minute = 0


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/6468>

Author
------

<mreynolds@redhat.com>
