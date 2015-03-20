---
title: "Referential Integrity Plugin and Replication Design"
---

# <Feature Name>
----------------

Overview
--------

This document describes how the Referential Integrity Plugin handles replicated delete/modrdn operations, and how to change this behavior.

Use Cases
---------

By default the Referential Integrity Plugin (RI Plugin) will ignore replicated "delete" and "modrdn" operations.  The RI Plugin should be enabled on at least one of the "master" replicas in the replication environment.  However, there are certain cases where the "master" or "supplier" server does not, or can not, use the RI Plugin.  To maintain group integrity on the remaining servers a new config attribute can be set to "allow" replicated operations to be processed by the plugin.  A common example is if the "master/supplier" is actually an Active Directory Server - which of course does not have an RI Plugin.

    Real World Example:

    We have a Directory Server with a windows replication agreement in order to get data from our AD domain controller using Windows Synchronization. The AD server is the master of the information.  We are syncing users and groups.  When we delete a user in AD, the user is deleted correctly in the Directory Server, but the groups they belong to are not updated correctly in the Directory Server, and after the user deletion, the deleted user appears in the member list of those groups (appears as a non valid user because the user is deleted in the Directory Server).  So this is a feature request to make RI Plugin work with replicated entries.

Design
------

A new configuration attribute has been added the RI Plugin configuration entry:

    cn=referential integrity postoperation,cn=plugins,cn=config
    ...
    nsslapd-pluginAllowReplUpdates: on/off

    The default is "off"

During the postop phase of a delete or modrdn operation a check is performed to see if the operation is replicated or not.  Depending on this setting a replicated delete/modrdn operation is simply ignored, or is processed.

Care should be taken when "allowing" replication updates in a Multi-Master Replication environment.  It should only be used when there is only one master, or only hubs/consumers.  As previously mentioned, the main use case is when an Active Directory server is being used as the "master" replication server.  Setting **nsslapd-pluginAllowReplUpdates** to **on** on multiple masters, even if an Active Directory Server is present, can lead to replication problems.  So if there are multiple master replicas, only one should use this setting, and the other masters should not have the plugin enabled.  The same goes for multiple/connected "hubs".  Basically you only need it set once on the top most Directory Server in the replication tree.

Implementation
--------------

Requires modifying the plugin configuration entry.


Replication
-----------

Incorrectly setting *nsslapd-pluginAllowReplUpdates* to *on* on multiple master replica servers can lead to replication errors, and requires a full initialization to fix the problem.

Updates and Upgrades
--------------------

No issues

Dependencies
------------

None

External Impact
---------------

None

Author
------

<mreynolds@redhat.com>


