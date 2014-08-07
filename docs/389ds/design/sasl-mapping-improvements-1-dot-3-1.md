---
title: "SASL Mapping Improvements 1.3.1"
---

# Sasl Mapping Fallback and Prioritization Design
-------------------------------------------------

Overview
--------

Previously, only the first matching sasl mapping was checked, and if that mapping failed, the bind operation would fail- even if there were other matching mappings that might have worked. Sasl mapping fallback will keep checking all the matching mappings. A mapping prioritization option has also available for each mapping.

Use Cases
---------

Deployments where many SASL mappings are used, and/or are designed to have overlapping matching criteria.

Design
------

Since multiple mappings are now checked, a new mapping prioritization configuration option has been added to the mappings. The attribute **"nsSaslMapPriority"** takes a value between 1 and 100, where 1 is the highest priority, and 100 is the lowest. You can also use the same prioritization for multiple mappings. If you omit this config attribute from a mapping, that mapping will have a default priority of 100.

To use this new functionality, SASL mapping fallback must be enabled by setting "nsslapd-sasl-mapping-fallback" to "on" under cn=config. By default this feature is turned "off".

SASL config changes do not require a server restart now.

Implementation
--------------

No additional requirements are needed.

Feature Management
-----------------

CLI usage only.

Major configuration options and enablement
------------------------------------------

In the cn=config entry:

    nsslapd-sasl-mapping-fallback: on|off

In a SASL mapping entry, for example: **cn=Kerberos uid mapping,cn=mapping,cn=sasl,cn=config**

    nsSaslMapPriority: [1-100]

Replication
-----------

No impact on replication.

Updates and Upgrades
--------------------

No impact on updates.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

