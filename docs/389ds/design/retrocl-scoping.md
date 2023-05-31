---
title: "Retro Changelog Plugin Scoping"
---

# Retro Changelog Plugin Scoping
----------------

Overview
--------

Retro Changelog Plugin scoping defines what suffixes the plugin will act upon.  You can define multiple *"include"* and/or *"exclude"* suffixes.  This allows for more fine grained control over what is recorded in the retro changelog.

Use Cases
---------

If there are multiple backends, or a heavily nested suffix, it might be desirable to only record changes for certain subtrees.  For example:

    ou=internal,dc=example,dc=com
    ou=external,dc=example,dc=com
           ou=staff,o=company.com
    
You might only want to record changes to **"ou=external,dc=example,dc=com"**, or you might want to record changes for all branches/suffixes except **"ou=staff,o=company.com"**.

Design
------

There are two new multivalued configuration attributes that can be added to the Retro Changelog Plugin configuration:

    nsslapd-include-suffix: <DN of a suffix to include>
    nsslapd-exclude-suffix: <DN of a suffix to exclude>

**Note "exclude" scopes always override "include" scopes!**

Here is a configuration example:

    nsslapd-include-suffix: dc=example,dc=com
    nsslapd-exclude-suffix: ou=internal,dc=example,dc=com
    nsslapd-exclude-suffix: ou=private,dc=example,dc=com

This example records changes for all entries under **"dc=example,dc=com"**, except entries under **"ou=internal,dc=example,dc=com"** & **"ou=private,dc=example,dc=com"**

Or, you can exclude entire suffixes

    nsslapd-exclude-suffix: o=company.com

So any entry under **"o=company.com"** is excluded, but any other backend or suffix is recorded.

**Note if "nsslapd-include-suffix" is omitted, it implies that all backends/suffixes are recorded.**

Changes to these attributes are NOT applied dynamically (unless the dynamic plugins feature is enabled), and do require the server to be restarted to take effect.

Implementation
--------------

None

Major configuration options and enablement
------------------------------------------

Configuration can be set in the plugin entry under *cn=config*

Replication
-----------

None

Updates and Upgrades
--------------------

None

Dependencies
------------

None

External Impact
---------------

None

Author
------

<mreynolds@redhat.com>
