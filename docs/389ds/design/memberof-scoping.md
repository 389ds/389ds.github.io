---
title: "MemberOf Plugin Scoping"
---

# MemberOf Plugin Scoping
----------------

Overview
--------

MemberOf Plugin scoping defines what suffixes the plugin will act upon.  You can define multiple *"include"* and/or *"exclude"* suffixes.  This allows for more fine grained control over what memberships are maintained by the plugin.

Use Cases
---------

If there are multiple backends, or a heavily nested suffix, it might be desirable to only maintain the memberOf attributes for certain subtrees.  For example:

    ou=internal,dc=example,dc=com
    ou=external,dc=example,dc=com
           ou=staff,o=company.com
    
You might only want to maintain the *"memberOf"* attribute for entries that exist under **"ou=external,dc=example,dc=com"**, or you might want to maintain *"memberOf"* for all branches except **"ou=staff,o=company.com"**.

Design
------

There are two new multivalued configuration attributes that can be added to the MemberOf Plugin configuration:

    memberOfEntryScope: <DN of a suffix to include>
    memberOfEntryScopeExcludeSubtree: <DN of a suffix to exclude>

**Note "exclude" scopes always override "include" scopes!**

Here is a configuration example:

    memberOfEntryScope: dc=example,dc=com
    memberOfEntryScopeExcludeSubtree: ou=internal,dc=example,dc=com
    memberOfEntryScopeExcludeSubtree: ou=private,dc=example,dc=com

This example updates the *"memberOf"* attribute for all entries under **"dc=example,dc=com"**, except entries under **"ou=internal,dc=example,dc=com"** & **"ou=private,dc=example,dc=com"**

Or, you can exclude entire suffixes

    memberOfEntryScopeExcludeSubtree: o=company.com

So any entry under **"o=company.com"** is excluded, but any other backend or suffix is processed.

**Note if "memberOfEntryScope" is omitted, it implies that all backends/suffixes are allowed.**

Changes to these attributes are applied dynamically, and do not require the server to be restarted.

Implementation
--------------

None

Major configuration options and enablement
------------------------------------------

Configuration can be set in the plugin entry or in it shared configuration entry

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
