---
title: "Replication Convergence Improvement"
---

# Replication Convergence Improvement
----------------

Overview
--------

In a busy MMR environment where multiple masters are being updated at the same time the replica sessions stay open for a very long time.  This causes other masters to wait to send their updates.  This causes lopsided convergence.  Where entries added to the MMR environment, but on different masters, take a very different amount of time until they are each seen on all the replicas.

A new configuration setting was added (nsds5ReplicaReleaseTimeout) to the replica configuration entry.  So when replica A tries to acquire a replica B, replica B send a control back to the master(master C) that is updating replica B to abort the session.  Master C will continue sending updates for the amount of time specified in the "release timeout", then it will "yield" its current session so other replicas can acquire that replica.

Use Cases
---------

This new feature will benefit MMR deployments where there are 2 or more masters, and each master receives updates at the same time. 

Design
------

The release timeout is designed to prevent a single replica from monopolizing another replica.  By breaking up the replication session, we allow an equal opportunity for all replicas to update each other.  By doing this we get a much more equal convergence of replication updates across all the replicas.

When using the "release timeout" we also automatically use the "busy backoff" timer after sessions are aborted, as compared to the standard backoff timers that slowly increment.  By default the "busy backoff" timer is 3 seconds.  

Implementation
--------------

The new configuration attribute can be set using ldapmodify, and the change takes effect immediately.  It does not require a server restart.

Major configuration options and enablement
------------------------------------------

The new configuration attribute is:  **nsds5ReplicaReleaseTimeout**, and it accepts any value of zero or higher.  This value represents a timeout in seconds.  This attribute is set in each replica mapping tree entry.  It should be set on Masters and Hubs - there is no need to set this on consumers.  Setting the timeout to zero is the same as disabling the timeout feature.  Below is an example of setting a timeout.

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    changetype: modify
    replace:  nsds5ReplicaReleaseTimeout
    nsds5ReplicaReleaseTimeout: 60
        
Internal testing has shown that 60 seconds seems to be the ideal value.  Any value below 30 seconds has an adverse impact on replication performance.

Replication
-----------

Impacts replication session handling

Updates and Upgrades
--------------------

None

Dependencies
------------

None

External Impact
---------------

None

Origin
-------------

https://fedorahosted.org/389/ticket/48636

Author
------

<mreynolds@redhat.com>

