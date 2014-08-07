---
title: "Configuring scope for Referential Integrity Plugin"
---

# Configuring Scope for Referential Integrity Plugin
----------------------------------------

Overview
--------

The referential integrity plugins maintains references between entries and containers, eg groups. If an entry is deleted the references are deleted or modified to reflect the rename. But this is applied to all entries and to all groups, what can have a performance impact and doesn't allow the flexibility of restricting the referential integrity to specific subtrees or exclude subtrees. This problem is addressed with the introduction of scope.

Use Cases
---------

Example: 1 There is one suffix dc=example,dc= com and the retrochangelog is enabled, so there is also a suffix cn=changelog, but referential integrity should only handle the main suffix and not the changelog

Example: 2 There is one suffix, dc=example,dc=com with two subtrees: ou=active users,dc=example,dc=com ou=deleted users,dc=example,dc=com

entries in "deleted users" should not be handled

Example 3: combination of 1 and 2 no handling of entries in cn=changelog, no handling of entries in ou=deleted users,dc=example,dc=com

Design
------

1] Delete operation If an entry is deleted the referint post\_del plugin is called. If an excludeEntryScope is defined and the deleted entry is within this scope no operation is performed If one or more entryScopes are defined and the entry is in none of them, no operation is performed. If the above checks result in handling the entry then it is removed from all containers in all backends unless a containerScope is defined in that case the removal is restricted to containers in the container Scope

2] modrdn The determination of scope is as described for delete operations, but now three cases need to be distinguished 2.1] The entry is in scope before and after renaming, then the member attributes in the containers will be modified 2.2] The entry is moved out of scope, then it is handled like a delete operation 2.3] The entry is moved into scope, then all references to the pre-modrdn entry in the container scope are found and replaced by the new entrydn

Implementation
--------------

No additional requirements or changes discovered during the implementation phase.

Major configuration options and enablement
------------------------------------------

There are three new attributes in the referential integrity plugin configuration. Two controls the scope of the entry which is deleted or renamed:

    nsslapd_pluginEntryScope: <dn> (multivalued)
    nsslapd_pluginExcludeEntryScope: <dn>

One controls the scope of containers(groups), where references will be updated

    nsslapd_pluginContainerScope: <dn>

Replication
-----------

no impact

Updates and Upgrades
--------------------

no impact

Dependencies
------------

no dependencies

External Impact
---------------

no external impact
