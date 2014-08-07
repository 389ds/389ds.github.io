---
title: "Replication Protocol Timeout"
---

# Replication Protocol Timeout
----------------------------

Overview
--------

When stopping the server, disabling replication, or removing a replication agreement, there is a timeout on how long to wait before stopping replication when the server is under load. Prior to 1.3.1, the server could wait up to 20 minutes which would look like a hang. In 1.3.1 you can now configure this timeout, and the default timeout has been reduced to 2 minutes.

Use Cases
---------

There could be cases where a timeout of 2 minutes is too long, or not long enough. There could also be situations where a particular agreement should be given more time before ending a replication session during a shutdown.

Design
------

This attribute **nsds5ReplicaProtocolTimeout** can be added to the main replica configuration entry: e.g. Z**cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config**

Or, to the a replication agreement. The replication agreement protocol timeout will override the timeout set in main replica configuration entry. This allows some different timeout for different replication agreements.

Implementation
--------------

None.

Feature Management
------------------

CLI

Major configuration options
---------------------------

    nsds5ReplicaProtocolTimeout: <value in seconds> The default is 120 seconds.

This can be added the main replication config entry for a backend: **cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config**

Or to any replication agreement: **cn=agmt to remote replica,cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config**

Replication
-----------

If a replication session is in progress the new timeout will abort that session and allow the server to shutdown.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

