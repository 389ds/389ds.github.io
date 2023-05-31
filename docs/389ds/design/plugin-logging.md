---
title: "Plugin Logging"
---

# Plugin Internal Operation Logging
-----------------------------------

Overview
--------

By default, even if access logging is set to record internal operation, plugin internal operations are not logged in the access log. There is an undocumented plugin attribute that be added to a plugin config entry called "nsslapd-logAccess" that can be set to "on". Since adding this to every plugin can be tedious, a new configuration setting has been created under cn=config that allows all plugins to be logged: nsslapd-plugin-logging: on|off

However, it is still required that the access logging level is set for internal searches. Except for one case, unindexed searches. If the access log level is not set to record internal operation, the server still record unindexed searches in the error log:

    [17/Sep/2013:18:26:36 -0400] Internal search - Unindexed search: source (cn=referential integrity postoperation,cn=plugins,cn=config) base dn "dc=example,dc=com" filter "(seeAlso=uid=4,dc=example,dc=com\*)" etime (0) nentries (0) notes=U

Use Cases
---------

Troubleshoot plugins, especially if plugins are doing expensive operations like unindexed searches. So this now allows for admins to find potential issues and fixes much more easily.

Design
------

New config setting "nsslapd-plugin-logging" allows for plugin internal operations to be logged. If the access log level is not set, this new setting will still record unindexed searches in the error log instead. If the access log level is set to record internal operations, then those unindexed searches & other internal operations, will be recorded in the access log.

Implementation
--------------

None.

Feature Management
-----------------

CLI

Use ldapmodify to set "nsslapd-plugin-logging" and "nsslapd-accesslog-level"

Major configuration options and enablement
------------------------------------------

New config setting **"nsslapd-plugin-logging: on\|off"**. The default is "off"

Replication
-----------

No impact.

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

mreynolds@redhat.com

