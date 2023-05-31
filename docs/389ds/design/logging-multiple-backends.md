---
title: "Logging to Multiple Backends"
---

# Introduction
--------------

Historically slapd has managed and maintained it's own logging backend. This has afforded a high level of control and flexibility for system administrators using this system. Logs are critical to security and analysis of server behaviour.

As time as progressed we have access to many other logging systems now. Slapd should be capable of consuming alternate logging systems, or a combination of logging systems each with their own characteristics.

We will develop and introduce syslog and journald backends as part of this improvement.

# Notice:
---------

As of 2016-04-13 Journald support has been disabled by default due to concerns over it's production capability.

Syslog support will still be provided.

Journald can be enabled with --with-systemd --with-journald, but it is extremely likely that this will not be added to most distributions.

# Use Cases
-----------

System administrators deploy log monitoring and aggregation tools. These often rely on log forwarding. By adding a syslog interface, this will enable shipping of logs for further analysis and queries.

Projects such as FreeIPA wish to be able to internal query and aggregate logs in their tools. By adding a journald backend, this will support their desire to query the journald system.

# Major configuration options and enablement
--------------------------------------------

A single configuration item is added to the server for this.

    nsslapd-logging-backend: [internal|syslog|journald]

This configuration takes a comma seperated list of the options above.

If an invalid option is provided, it is ignored.

If no valid options are provided, the server will fail to start.

Option ordering does nothing.

Journald can be enabled through the addition of "--with-systemd" to configure.


# Implementation
--------

The majority of logging in slapd internally goes through the following function calls:

    slapd_log_audit
    slapd_log_auditfail
    slapi_log_error
    slapi_log_access

This include Macros and plugin error logging.

These functions tend to call some other internal code to actually carry out the logging function. This leaves them prime to be converted into "routers" for logs.

Regardless of configuration item ordering, messages are sent to logging services in the following order:

    internal
    syslog
    journald

This is to ensure that the most "reliable" service gets events first to guarantee correct logging.

Inside of these functions, the logging backend is selected from a bitmask. This enables events to be logged to many backends simultaneously. In code this looks like:

    if (loginfo.log_backend & LOGGING_BACKEND_INTERNAL) {
        ...
    }
    if (loginfo.log_backend & LOGGING_BACKEND_SYSLOG) {
        ...
    }
    #ifdef WITH_SYSTEMD
    if (loginfo.log_backend & LOGGING_BACKEND_SYSTEMD) {
        ...
    }
    #endif

Considerations and Warnings
---------------------------

Adding more backends may cause a delay in processing of events by the slapd instance. No detailed studies of performance impact has been carried out, but as you enable the syslog and journald backend there is a risk of slight performance degredation to events.

For syslog, you may be able to improve this through the use of the async flag on log types. This is a '-' prefixed to the path, such as "-/path/to/log".

Journald by default is not configured to keep all log events. As slapd generates a huge number of events you must alter a number of configuration values to make journald usable. It is highly recommended that journald.conf contains the following:

    # /etc/systemd/journald.conf

    RateLimitInterval=0
    RateLimitBurst=0
    SystemMaxUse=100%
    RuntimeMaxUse=100%

Without this, journald will DROP events rapidly, and will rotate the log in a matter of minutes.

With this configuration, journald will use up to 4G of space. This is a hardcoded maximum within journald.

At the rate that slapd generates events you may find that at a busy site you will not be able to retain journald events for more than a matter of hours. Some testing has shown you may only be able to retain up to 2 hours of events for the whole system with slapd logging to journald.

We highly recommend the use of internal at all times (Despite the fact internal is optional). Internal provides the greatest control for logging stability, persistence and rotation. We advise the optional use of syslog for forwarding, and journald for short term querying. IE:

    nsslapd-logging-backend: internal
    OR
    nsslapd-logging-backend: internal,syslog
    OR
    nsslapd-logging-backend: internal,journald
    OR
    nsslapd-logging-backend: internal,syslog,journald

Updates and Upgrades
--------------------

No changes will occur during an upgrade. Logging defaults to "internal".

External Impact
---------------

No external impact.

Future
------

Rewrite the logging system to buffer events to all three backends rather than just internal.

Cleanup and streamline the logging code.


