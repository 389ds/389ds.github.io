---
title: "SASL Buffer Design"
---

# SASL Buffer Design
---------------

Overview
--------

Previous to 389-ds-base-1.3.1 the server had a fixed size buffer for receiving SASL operations. This may not be sufficient for all cases.

Use Cases
---------

Products like IPA, that work with AD trust stores, can exceed the previous SASL buffer(2048 bytes).

Design
------

The default buffer size has been increased from 2k to 64k. The buffer can also be increased if 64k is not enough - by setting a new configuration attribute under cn=config:

    nsslapd-sasl-max-buffer-size: <value in bytes>

Implementation
--------------

No additional requirements.

Feature Management
-----------------

Currently only CLI tools can be used to set this option.

Major configuration options and enablement
------------------------------------------

Ldapmodify can be used to set the value. There is no need to restart the server after setting the value.

Replication
-----------

No impact on replication.

Updates and Upgrades
--------------------

No impact on updates and upgrades.

Dependencies
------------

No package and library dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

