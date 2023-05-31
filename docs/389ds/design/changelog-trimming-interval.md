---
title: "Changelog Trimming interval"
---

# Replication Changelog Trimming Interval

Overview
--------

Allow setting the changelog trimming interval.

Use Cases
---------

In some scenarios the default trimming interval(5 minutes) been not be an optimal value.

Design
------

A new configuration attribute "nsslapd-changelogtrim-interval" was added to the changelog configuration entry "dn: cn=changelog5,cn=config". If this is not set, then the default of 5 minutes (300 seconds) is used. This does not require a server restart to take effect.

Implementation
--------------

None.

Feature Management
------------------

CLI

Major configuration options and enablement
------------------------------------------

       dn: cn=changelog5, cn=config
       nsslapd-changelogtrim-interval: <value in seconds>

Replication
-----------

Impacts changelog trimming

Updates and Upgrades
--------------------

None.

Dependencies
------------

None.

External Impact
---------------

None.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>
