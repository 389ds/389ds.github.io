---
title: "Error Logging Format"
---

# Error Logging Format
----------------

Overview
--------

The "errors" log had a very inconsistent format, and it was difficult to distinguish between "informational" and "error" messages.  There needs to be a way to define the severity of the "error message".  So, a new severity level has been added to each error log line.  These severity levels are based off of syslog's error log levels.  Also, the format of every log message has been made to comply with a new standard format.  This will make reading and parsing an error log possible and useful.


Design
------

The new "severity" log levels are based off of syslog's error levels.  See syslog.h:

    0       EMERG - Typically this is logged when the server fails to start.
    1       ALERT - The server is in a critical state and possible action must be taken.
    2       CRIT - Severe error.
    3       ERR - General error.
    4       WARNING - Warning message (not necessarily an error).
    5       NOTICE - Normal but significant condition occur.  Typically logged when the server intervenes with the expected behavior.
    6       INFO - Informational messages:  startup, shutdown, import/export, backup/restore, etc.
    7       DEBUG - Debug-level messages.  Also used by default when using a verbose logging level like "trace function calls", "access control list processing", "replication", etc.


The new logging format takes two different forms, one for the core server, and one for the plugins.

**Server Format**

    <date/time> - <severity level> - <function> - <message>

    [10/Oct/2016:14:51:41.475989901 -0400] - INFO - main - 389-Directory/1.3.6.0.20161010git04a9c89 B2016.284.1845 starting up
    [10/Oct/2016:14:51:41.615038336 -0400] - INFO - slapd_daemon - slapd started.  Listening on All Interfaces port 389 for LDAP requests


**Plugin Format**

    <date/time> - <severity level> - <plugin> - <function> - <message>

    [10/Oct/2016:14:57:00.564944685 -0400] - ERR - NSMMReplicationPlugin - bind_and_check_pwp - agmt="cn=My Repl Agmt" (localhost:6666) - Replication bind with SIMPLE auth failed: LDAP error -1 (Can't contact LDAP server) ()

- Note with the *plugin format* it is the developers responsibility to add the function name as part of the message (See below)



Implementation
--------------

Internally several things have changed.  LDAPDebug() has been removed, and slapi_log_error() has been replaced with slapi_log_err().  slapi_log_err() is a macro function like LDAPDebug was.  This allows us to undefine LDAP_DEBUG and completely remove the presence of "error" logging for performance testing.  For the new severity levels we have these new identifiers:

    SLAPI_LOG_EMERG
    SLAPI_LOG_ALERT
    SLAPI_LOG_CRIT
    SLAPI_LOG_ERR     --->  This is the standard severity level for generic error messages.  This replaces SLAPI_LOG_FATAL.  SLAPI_LOG_FATAL should be considered deprecated.
    SLAPI_LOG_WARNING
    SLAPI_LOG_NOTICE
    SLAPI_LOG_INFO
    SLAPI_LOG_DEBUG

NOTE - All other error log levels trigger the severity "DEBUG" in the errors log.  So SLAPI_LOG_PLUGIN, SLAPI_LOG_REPL, SLAPI_LOG_CONNS, etc, show up as "DEBUG" severity level in the errors log.

**Debug Level Example**

    slapi_log_err(SLAPI_LOG_PLUGIN, LINK_PLUGIN_SUBSYSTEM, "linked_attrs_start - Unable to retrieve plugin dn\n");

    Gets logged as:

    [10/Oct/2016:14:51:41.615038336 -0400] - DEBUG - linkedattrs-plugin - linked_attrs_start - Unable to retrieve plugin dn

**Core Server/Plugin Example**

    slapi_log_err(SLAPI_LOG_ERR, "global_plugin_init", "Failed to create global plugin rwlock.\n");
    slapi_log_err(SLAPI_LOG_ERR, LINK_PLUGIN_SUBSYSTEM, "linked_attrs_start - Failed to create rwlock\n");   --->  The plugin function name is still part of the message text - there is no separate parameter.  So as a developer you must remember to add the function name for plugin logging.

    Gets logged as:

    [10/Oct/2016:14:51:41.615038336 -0400] - ERR - global_plugin_init - Failed to create global plugin rwlock.
    [10/Oct/2016:14:51:41.615038337 -0400] - ERR - linkedattrs-plugin - linked_attrs_start - Failed to create rwlock



Major configuration options and enablement
------------------------------------------

None


Origin
-------------

<https://fedorahosted.org/389/ticket/48978>

Author
------

<mreynolds@redhat.com>

