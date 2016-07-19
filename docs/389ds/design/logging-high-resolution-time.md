---
title: "High Resolution Logging Timestamps"
---

# Introduction
--------------

When sorting logs, we need to know the order they arrived in. Because Directory Server is capable of handling thousands of events per second, sometimes during sorting the order of operations is lost as timestamps were only accurate to the second.

# Use Cases
-----------

This feature is a win in nearly all cases. It allows better sorting, accurate analysis of time of events, and has no draw backs. The implementation actually *speeds up* the timestamp process.

# Configuration options
-----------------------

A single configuration option in cn=config controls this feature

    nsslapd-logging-hr-timestamps-enabled: [on|off]

This feature defaults to "on".

When enabled, logs are of the form:

    [19/Jul/2016:08:48:41.008480297 +1000] conn=1017 op=3 fd=64 closed - U1

When disabled, logs are of the form:

    [19/Jul/2016:08:48:41 +1000] conn=1017 op=3 fd=64 closed - U1

This can be enabled or disabled during runtime with no server restart.

# Implementation
----------------

This change removes the timestamp string cache and locking. It replaces the call to localtime_r to posix clock_gettime.

# Updates and upgrades
----------------------

During an upgrade from 1.3.4 to 1.3.5 or later, this will automatically be enabled.

# Author
--------

William Brown <william at redhat.com>
