---
title: "=Memberof Plugin Configuration"
---

# MemberOf Plugin Shared Configuration
--------------------------------------

Overview
--------

The memberOf plugin configuration can now be stored in a shared configuration entry.

Use Cases
---------

This allows the plugin configuration to be replicated, so all the servers in a replicated environment will have the exact same configuration.

Design
------

In the plugin entry, a shared config entry can be specified using "nsslapd-pluginConfigArea: <entry DN>". This DN is validated in a preop phase and rejected if the entry does not exist.

Implementation
--------------

None.

Feature Management
------------------

CLI

Major configuration options and enablement
------------------------------------------

The attribute nsslapd-pluginConfigArea can now be used in the plugin entry to specify the location of the configuration.

Replication
-----------

Configuration can now be replicated.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

None.

External Impact
---------------

No impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

