---
title: "Delay accepting updates after initialization"
---

# Delay accepting updates after initialization
------------------

{% include toc.md %}

Problem
=======

If a supplier is initialized from an ldif or backup or from another supplier and there exist changes for the local replicaID on some server with csns greater 
than what was contained in the initialization data the following problem can happen.

If the initialized supplier accepts a direct update it will create a csn highere than changes it has not yet received from the other servers.
The outstanding changes will be lost. 

A detailled problem description is in the referenced tickets #47986 and #48976

General solution
================
After the initialization of a backend set the backend state to "referral-on-update". When the 
replicas are all in sync the state will be set back to "backend".
A flag in the replica object triggers the change of the backend state.

This flag to reject direct updates can be reset on the following conditions:

1] an admin modifies the state flag (after verifying that no more updates for the replica are outstanding)

2] a timeout is defined and passed 

3] the replica has automatically detected that it is up to date.  

Exceptions
==========
The rejections of updates is too strict in some situations and should not be set

## Single supplier topologies
If there is only one supplier it should always start to accept updates. It is possible that on a read only
consumer there are more advanced changes for the local RID, but the consumers will not be able to replicate back.
So the server should accept updates, but stop replicating to these consumers until they are reinitialized 

## Adding a new replica

If a new replica is added to the topology and initialized the first time no updates for this replica 
will be otstanding. Updates should be accepted immediately.

The detiction of this situation is that the RUV of the imported database does not have an element for this replica.
(it requires that the referral of this replica was not added to another replica as long as the database generation was different.

## Import without replica information

If a replica is initialized from an ldif without any replication metadata "it's" RUV is recreated and it should immediately
accept updates. The database generation is different than in the rest of the topology and no other server will be able 
to replicate to this replica  

Configuration
=============

The config entry for a replica gets a new attribute to track if local updates are accepted

    nsslapd-replica-accept-updates-state: on/off

If this is set to off the backend will be set to "referral on update". When it is changed to on by any of the described methods
the backend state will be set to "backend" again. 
After an init there is a check if we are in one of the exception scenarios and if not it will be set to off.

The method if and when the replica should reset the accpet-updates flag can also be configured.

    nsslapd-replica-accept-updates-delay: -1/0/n
    nsslapd-replica-accept-updates-auto: on/off

where the values mean:

    -1: wait until an admin has reset the update flag or until auto detection resets it
    0: immediately accept updates
    n: wait n seconds after "lastinittime"
    auto: try to detect the csn which allows to accept updates

Autodetection if server is up to date
=====================================

A mechanism and function which was developped for cleanallruv can be reused. In cleanallruv there is the option to detect if all
servers are in sync before cleaning a specific RID. An extended operation is sent to the reachable consumers/suppliers to get their 
greatest CSN for the given replica ID. 
When this csn is retrieved the local replica will regulariliy compare its local maxCSN and once it is equal to that csn it can start to
accept updates again.

Tickets
=======
* Ticket [\#47986](https://fedorahosted.org/389/ticket/47986) Recovered supplier need to reject direct update until it is in sync with the topology
* Ticket [\#48976](https://fedorahosted.org/389/ticket/48976) After reinit a topology can silently diverge instead of breaking replication
