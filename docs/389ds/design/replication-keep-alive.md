---
title: "Replication Keep alive entry"
---


{% include toc.md %}

# Overview

Replication between a supplier and a consumer is handled by a replication agreement thread runnning on the supplier side. This thread runs a replication protocol session that basically acquires exclusive access to the consumer suffix, *send updates* (if any) and releases the consumer suffix. If *send updates* last long, others suppliers will fall back in backoff state for quite long period. 

This scenario would not create issue if *send updates* state effectively sends updates but with **fractional replication**, we can imagine that a full *send updates* state will only evaluate updates to skip (because of fractional replication). The replication state (RUV) of the consumer at the end of the session would be exactly the same as it was at the begining of the session. So next session will start at the same point, will last long to finally skip all updates...

To address this issue there were different options (keep alive entry, add fractional RUVelement in RUV, force pause of replica agreement, log warnings,...). It was decided to create/update **keep alive entries**.


# Use Case

In a fractional replication topology, a master is receiving majority of the updates. For example, a skipped attribute is updated at each bind.
The replica agreements of that master will be frequently waken up (by updates) but replication session will send no updates (all skipped) and others supplier are going into backoff longer and longer.
So updates received by those others masters will appear very late on the consumers because master have few chances to acquire the consumers.



# Design

## keep alive entry

A keep alive entry is a *ldapsubentry*, that means this entry is only visible if the search filter contains *(objectclass=ldapsubentry)*.

In a given replication topology (for a given suffix), there is **0 or 1 keep alive entry per master** and a given keep alive entry is associated to *one* master (its RDN contains the replicaID of the master).

A keep alive entry is created/updated on demand, so by default a master will not create **its** keep alive entry.

The keep alive entry is looking like

        dn: cn=repl keep alive 14,dc=example,dc=com
        objectclass: top
        objectclass: ldapsubentry
        objectclass: extensibleObject
        cn: repl keep alive 14
        keepalivetimestamp: 20170227190346Z

Where *14* is the replicaID of the master and keepalivetimestamp contains the last time the protocol decided to update the entry.

## keep alive entry creation/update

Keep alive entry is created:

- When a master does a total initialization of a consumer, it first creates its keep alive entry. A consumer that is also a master does not create its keep alive entry unless it also does a total initialization of an other consumer.
- When a fractional replication agreement skips more than **100** updates and does not send any updates before ending the replication session, it updates its keep alive entry and created it if needed.

Keep alive entry is updated:

- When a fractional replication agreement skips more than **100** updates and does not send any updates before ending the replication session, it updates its keep alive entry.


# Implementation

- keep alive entry is updated during *send_updates* by calling *replica_subentry_update*
- keep alive entry is created by *replica_subentry_check*


# Major Configuration options

None

# Replication

This design is related to replication see Design

# updates and Upgrades

Keep alive entry is regular LDAP entry (although ldapsubentry), so creation/update is replicated through regular replication in all versions

# Dependencies

None
