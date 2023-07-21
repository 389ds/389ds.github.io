---
title: "Replication Keep alive entry"
---


{% include toc.md %}

# Overview

Replication between a supplier and a consumer is handled by a replication agreement thread runnning on the supplier side. This thread runs a replication protocol session that basically acquires exclusive access to the consumer suffix, *send updates* (if any) and releases the consumer suffix. If *send updates* last long, others suppliers will fall back in backoff state for quite long period. 

This scenario would not create issue if *send updates* state effectively sends updates but with **fractional replication**, we can imagine that a full *send updates* state will only evaluate updates to skip (because of fractional replication). The replication state (RUV) of the consumer at the end of the session would be exactly the same as it was at the begining of the session. So next session will start at the same point, will last long to finally skip all updates...

To address this issue there were different options (keep alive entry, add fractional RUVelement in RUV, force pause of replica agreement, log warnings,...). It was decided to create/update **keep alive entries**.

The **keep alive entries** is used to prevent this issue with the following mechanism. In the context of **fractional replication**, if a replication session skip all updates **and** the number of skipped updates is **greater than a fixed threshold (100)**, then the keep alive entry is updated. This update will not be skipped by fractional replication, so in such session the update of the keep alive entry is replicated. As a consequence, the replication state (RUV) of the consumer will progress and next replication session will no evaluate the skipped updates.

# Use Case

In a fractional replication topology, a supplier is receiving majority of the updates. For example, a skipped attribute is updated at each bind.
The replica agreements of that supplier will be frequently waken up (by updates) but replication session will send no updates (all skipped) and others supplier are going into backoff longer and longer.
So updates received by those others suppliers will appear very late on the consumers because supplier have few chances to acquire the consumers.



# Design

## keep alive entry

A keep alive entry is a *ldapsubentry*, that means this entry is only visible if the search filter contains *(objectclass=ldapsubentry)*.

In a given replication topology (for a given suffix), there is **0 or 1 keep alive entry per supplier** and a given keep alive entry is associated to *one* supplier (its RDN contains the replicaID of the supplier).

A keep alive entry is created/updated on demand, so by default a supplier will not create **its** keep alive entry.

The keep alive entry is looking like

        dn: cn=repl keep alive 14,dc=example,dc=com
        objectclass: top
        objectclass: ldapsubentry
        objectclass: extensibleObject
        cn: repl keep alive 14
        keepalivetimestamp: 20170227190346Z

Where *14* is the replicaID of the supplier and **keepalivetimestamp** contains the last time the protocol decided to update the entry.

## keep alive entry creation/update

Keep alive entry is created:

- When a fractional replication agreement skips more than **100** updates and does not send any updates before ending the replication session, it updates its keep alive entry and **created** it if needed.
- When a supplier does a total initialization of a consumer, it first creates its keep alive entry. A consumer that is also a supplier does not create its keep alive entry unless it also does a total initialization of an other consumer.

For example, let Supplier_1 (ReplicaID: 1), Supplier_2 (ReplicaID: 2), Supplier_3 (Replica_ID: 3). All in fractional replication.
When Supplier_1 does a total initialization of Supplier_2, it creates **cn=repl keep alive 1,dc=example,dc=com** first. So at the end of the initialization, both Supplier_1 and Supplier 2 contain **cn=repl keep alive 1,dc=example,dc=com**. Then Supplier_2 does a total initialization of Supplier_3, Supplier_2 first creates **cn=repl keep alive 2,dc=example,dc=com**. So at the end of the initialization, both Supplier_2 and Supplier 3 contain **cn=repl keep alive 1,dc=example,dc=com** and **cn=repl keep alive 2,dc=example,dc=com**. A later replication session Supplier_2 to Supplier_1 will detect that Supplier_1 does not know **cn=repl keep alive 2,dc=example,dc=com** and will replicate it. At the end M1,M2 and M3 will all contains keep alive **1 and 2** but not keep alive **3** that was not created because M3 did not initialize any consumer.

Keep alive entry is updated:

- When a fractional replication agreement skips more than **100** updates and does not send any updates before ending the replication session, it updates its keep alive entry. (update **keepalivetimestamp**)


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
