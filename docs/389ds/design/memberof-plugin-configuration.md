---
title: "=Memberof Plugin Configuration"
---

# MemberOf Plugin Shared Configuration
--------------------------------------

{% include toc.md %}

Overview
--------

The MemberOf Plugin configuration can now be stored in a shared configuration entry that can exist outside of the **cn=config** suffix.  This means that the plugin configuratin can be stored in any backend or suffix.  This allows for the plugin configuration to be replicated to other servers so that all the replication servers use the same configuation. 

Use Cases
---------

Use replication to handle plugin configuration consistency on a network.  This is very useful for large deployments, because if the plugin configuration is replicated you only need to update the configuration on a supplier replication server, and the change will replicate to all the other servers.  This makes plugin management in a replicated environment much easier.


#### Example

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: MemberOf Plugin
    nsslapd-pluginPath: libmemberof-plugin
    nsslapd-pluginInitfunc: memberof_postop_init
    nsslapd-pluginType: postoperation
    nsslapd-pluginEnabled: on
    nsslapd-plugin-depends-on-type: database
    memberofgroupattr: member
    memberofattr: memberOf
    nsslapd-pluginConfigArea: cn=MemberOf Plugin Configuration,dc=example,dc=com


If **nsslapd-pluginConfigArea** is set, the configuration in the plugin entry is ignored, and the configuration attributes in the entry specified by nsslapd-pluginConfigArea are used.

    dn: cn=MemberOf Plugin Configuration,dc=example,dc=com
    objectClass: top
    objectClass: extensibleObject
    cn: MemberOf Plugin Configuration
    memberofgroupattr: uniquemember
    memberofattr: memberOf

So in this case the MemberOf Plugin is going to use **uniquemember** for the group attribute, and not **member**.

In a replicated environment, all you have to do is set the **nsslapd-pluginConfigArea** to the same DN/entry on all the replica's plugin entry, and then replication will handle all the future configuration changes.

Design
------

In the plugin entry, a shared config entry can be specified using **"nsslapd-pluginConfigArea: \<entry DN\>"**. This entry is validated when the plugin is started, or if using dynamic plugins, it is validated when the plugin is updated, and rejected if the entry does not exist or the entry has an invalid configuration.

The following configuration attributes can be used in the shared config entry:

|----------------|------------|-------|
|Configuration Attribute|Value|Example|
|-----------------------|-----|
|memberOfAttr|Attribute Name|memberOf|
|memberOfGroupAttr|Attribute Name|uniqueMember|
|memberOfAllBackends|on\|off|off|
|memberOfEntryScope|Entry DN|ou=people,dc=example,dc=com|
|memberOfSkipNested|on\|off|on|
|memberOfEntryScopeExcludeSubtree|Entry DN|ou=other,dc=example,dc=com|
|----------------|------------|
    
**"memberOfAttr" and "memberOfGroupAttr" are required configuration attributes.**

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

