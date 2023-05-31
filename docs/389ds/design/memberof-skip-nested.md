---
title: "MemberOf Plugin Skip Nested Groups"
---

# MemberOf Plugin Skip Nested Groups
----------------

Overview
--------

By default when a user is added to or removed from a group we check if that group is a member of another group.  We do this for each group that the user belongs to to the plugin can properly handle nested groups.  If that same user already belongs to many groups, the plugin needs to perform a search for each one of those groups.  This can get quite expensive, and can consume unexpected high amounts of cpu.

If you are *not* using nested groups then this "nested group" searching can be disabled.

Use Cases
---------

This scenario becomes quite expensive if you have for example 10,000 groups with the same members.  A single addition of a new member to a group can take a long time, and it will consume a lot of resources.  If you are using nested groups then this is a performance hit you are going to have to accept, but if you are not using nested groups then this searching can be disabled.

Design
------

A new configuration attribute has been added to the MemberOf Plugin that specifies if nested group searching should be skipped:

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    memberOfSkipNested: on|off

The default setting is "off".  Setting this value is applied dynamically and does not require a server restart to take effect.

If **memberOfSkipNested** is set to **on**, and there are nested groups, then the **memberOf** attribute in member entries will not be properly maintained.


Implementation
--------------

None

Major configuration options and enablement
------------------------------------------

New configuration attribute in the MemberOf plugin entry under cn=config

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    memberOfSkipNested: on|off

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
