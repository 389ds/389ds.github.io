---
title: "Replication Retry Settings"
---

# Replication Retry Settings
----------------------------

Overview
--------

Currently if a remote replica is busy the replication protocol will go into a "back off" state, and it will retry to send it updates at the next interval of the backoff timer. By default the timer starts at 3 seconds, and has a maximum wait period of 5 minutes. These default settings maybe not be sufficient under certain circumstances. In 389-ds-base-1.3.1 you can now configure the minimum and maximum wait times.

Use Cases
---------

In environments where there is heavy replication traffic, and updates need to be sent as fast as possible, having a maximum retry time of 5 minutes is too long.

Design
------

Two new configuration attributes have been added to the replication configuration entry(per backend):

    cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    ...
    ...
    nsds5ReplicaBackoffMin <value in seconds>  default is 3 seconds
    nsds5ReplicaBackoffMax <value in seconds>  default is 300 seconds

Implementation
--------------

No additional requirements are needed.

Feature Management
-----------------

The configuration must be handled through CLI tools.

Major configuration options and enablement
------------------------------------------

The configuration settings can be applied while the server is online, and do not require a server restart. If invalid settings are used, then the default values will be used instead.

Replication
-----------

Impacts the back-off timers in the incremental update replication protocol.

Updates and Upgrades
--------------------

No impact on upgrades/updates.

Dependencies
------------

Feature was added to 389-ds-base-1.3.1.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

