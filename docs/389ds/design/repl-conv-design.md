---
title: "Replication Convergence Improvement"
---

# Replication Convergence Improvement
----------------

Overview
--------

In a busy MMR environment where multiple masters are being updated at the same time the replication sessions stay open for a very long time.  This causes the other masters to wait before they can send their updates.  This causes lopsided replication convergence.  When entries are added to the MMR environment, but on different masters, it can take a very different amount of time for each entry to be seen on all the replicas.  It can get as high as hours until an update is replicated to a different replica.

A new configuration setting was added (nsds5ReplicaReleaseTimeout) to the replication configuration entry.  This setting defines how long a replication master should send updates before it yields its replication session.  This allows other replication masters to update this replica.  Here an example involving three Multimaster Replication Servers, that we will call them Master A, Master B, and Master C.  So when Master A tries to acquire Master B to send it updates, and Master B is already being updated by Master C, this triggers Master B to send a control back to Master C telling it that other masters would like to update this replica and we should stop the current replication session after the number of seconds defined in nsds5ReplicaReleaseTimeout.  So Master C will continue sending updates for the amount of time specified in the "release timeout", then it will "yield" its current session so Master A can finally acquire Master B.  This allows for a much more even distribution of replication updates.

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
        
Testing has shown that 60 seconds seems to be the ideal value.  Any value below 30 seconds, or above 120 seconds, has an adverse impact on replication performance.  So if the value is too low the replication servers are constantly reacquiring one another, and the servers end up not sending many updates.  Heavy replication traffic "might" benefit from a slightly longer timeout of 120 seconds, but any setting over 120 seconds just slows things down.  The best approach is to start at 60 seconds, and monitor replication.  If you start seeing too many replication sessions, then increasing the value might help move the replication traffic through more efficently. 

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

