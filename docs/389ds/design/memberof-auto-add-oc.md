---
title: "MemberOf Plugin - Auto Add Objectclass"
---

# MemberOf Plugin - Auto Add Objectclass
----------------

Overview
--------

Starting in 389-ds-base-1.3.3 most the DS plugins are now backend transaction plugins, which means that is a plugin fails to perform its "*task*" the entire operation is aborted.  This can cause unexpected failures after upgrading.  A very common problem with the MemberOf Plugin is that *"member entries"* do not have an objectclass that allows the **"memberOf"** attribute.  This new feature allows you set a predefined objectclass in the plugin config entry that will be added to a *"member entry"* if that entry does not have an objectclass that allows the **"memberOf"** attribute.

Use Cases
---------

When using the MemberOf Plugin for the first time you would need to add an objectclass that allows the **"memberOf"** attribute like *"inetUser"* to all the entries that could be potential members of groups (including groups).  This can potentially be a lot of work, and it can also be hard to diagnose that the reason memberOf plugin is not working as expected is because of schema.  This new feature can automatically update all your entries to have a proper objectclass for you.  Saving a lot of time and frustration.

Design
------

If an objectclass is predefined, and the plugin fails to add the **"memberOf"** attribute due to a objectclass violation (*error 65*), the plugin will attempt to add the predefined objectclass to the entry and retry to add the **"memberOf"** attribute to the entry.  If it fails again, the entire operation is aborted.  Here is an example of the new config setting **memberofAutoAddOC**:

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: MemberOf Plugin
    memberofGroupAttr: member
    memberofAttr: memberOf
    memberofAutoAddOC: inetUser

Here we are using the standard objectclass **inetUser**, but it could be any objectclass that allows the **"memberOf"** attribute.  This config setting takes effect immediately, and does not require a server restart to take effect.

Implementation
--------------

Need to an existing objectclass that allows the attribute **"memberOf"**

Major configuration options and enablement
------------------------------------------

The memberOf plugin config entry, or the shared config entry, need to be updated.

Replication
-----------

None.

Updates and Upgrades
--------------------

None.

Dependencies
------------

None.

External Impact
---------------

None.

Author
------

<mreynolds@redhat.com>

