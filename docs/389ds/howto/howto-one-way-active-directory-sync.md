---
title: "Howto: One Way Active Directory Sync"
---

# One Way Active Directory Sync
-------------------------------

{% include toc.md %}

Overview
--------

Some deployments would prefer that AD sync is only performed in one direction. Certain deployments would like updates to originate from the AD side while other deployments would like updates to originate from the DS side.

Configuration
-------------

To implement one-way sync, we need to add a new configuration attribute to the sync agreement entry. This attribute will be named **oneWaySync**. If this attribute is not present, the sync agreement will be bi-directional. To configure a uni-directional agreement, this attribute can be set to **toWindows** or **fromWindows** as desired.

Implementation Details
----------------------

### From Windows Case (AD -\> DS)

Inside of the replication plug-in, we simply skip sending updates in both the total and incremental replication protocol sessions when **oneWaySync** is set to **fromWindows**. We don't want to change the RUV implementation for a one way sync agreement, so we will just fast-forward the RUV that we maintain for the AD system as if we had successfully sent the changes.

### To Windows Case (DS -\> AD)

Inside of the replication plug-in, we skip sending the Dirsync control to AD in both the total and incremental replication protocol sessions when **oneWaySync** is set to **toWindows**.

Consistency Issues
------------------

### From Windows Case (AD -\> DS)

If one way sync is enabled and changes are made to a synced entry on the AD side, a replication session with AD will be started. In this session, we will not send any updates, but we will send the Dirsync control to AD to pull any updates. This will result in an inconsistency in the modified entry between AD and DS. This inconsistency will be resolved the next time any update is made to the entry on the AD side since we compare the entire entry between AD and DS when we receive a change via Dirsync. To avoid these inconsistencies, it is recommended to not allow direct updates to synced attributes in entries on the DS side. One can configure access control to help enforce this.

Another inconsistency that can occur is if a synced entry is directly deleted from DS. This deletion is not sent to AD. In this case, an update to the entry on the AD side will result in the entry being added back to DS. The direct deletion of synced entries on the DS side should be avoided to prevent these inconsistencies.

### To Windows Case (DS -\> AD)

Similar to the from windows case, updates on the AD side will not be synced to DS, causing an inconsistency between AD and DS. One needs to avoid making changes on the AD side in this case to prevent consistency issues.
