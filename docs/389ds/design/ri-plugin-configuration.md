---
title: "RI Plugin Configuration"
---

# Referential Integrity Plugin Configuration
------------------------------------------

Overview
--------

The RI plugin configuration has had two significant changes done to it. First, the "pluginarg0-N" style configuration has been deprecated. The old style "pluginargs" will still work, but now there are "real" attributes for each setting. The other new change is that you can can store the configuration in a separate entry, that can also be located in any backend(and replicated for that matter).

Use Cases
---------

The new shared configuration entry for the plugin allows the configuration to be replicated, so that all the servers can use the exact same settings.

Design
------

For the new configuration attributes there are a few things to be aware of. The new style configuration attributes will always take precedence over the plugin arg style attributes. These attributes(old/new) can not be interchanged. It is either one of the other. If a shared configuration entry is defined, any settings in the plugin entry itself are ignored, and only the settings in the shared config entry are applied.

All the configuration settings are now dynamic(including adding or removing a shared configuration entry), and do not require a server restart to take effect.

Implementation
--------------

None.

Feature Management
------------------

CLI

Major configuration options and enablement
------------------------------------------

Old-style (pluginargs):

    nsslapd-pluginarg0: 0
    nsslapd-pluginarg1: /var/log/dirsrv/slapd-localhost/referint
    nsslapd-pluginarg2: 0
    nsslapd-pluginarg3: member
    nsslapd-pluginarg4: uniquemember
    nsslapd-pluginarg5: owner
    nsslapd-pluginarg6: seeAlso

New style:

    referint-update-delay: 0
    referint-logfile: /var/log/dirsrv/slapd-localhost/referint
    referint-logchanges: 0
    referint-membership-attr: member
    referint-membership-attr: uniquemember
    referint-membership-attr: owner
    referint-membership-attr: seeAlso 

New shared configuration:

    nsslapd-pluginConfigArea: <entry DN>
       
    The entry DN must be a valid entry, that contains the config settings seen above.

Replication
-----------

Configuration can now be replicated.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No impact.

External Impact
---------------

No impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

