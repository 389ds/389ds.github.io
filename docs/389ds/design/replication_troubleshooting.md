---
title: "Replication Troubleshooting"
---


{% include toc.md %}

# Overview

TBD

# Use Case

TBD



# Design

## Replication basics

Replication contains two parts

The first part (named *Replica*) is responsible to process received updates and record them into a changelog. The second part (*replicat agreement*) is responsible to send updates from one server, acting as supplier, to another server acting as a consumer.

On a given directory instance, *Replica* and *replica agreement* are sharing few structures:

- changelog: this is a dedicated database where updates are stored in chronological way based on **CSN**
- **Local** RUV (aka replication update vector) it contains the state of local replica. The state being the **CSN** of the latest update it **directly** received, and the **CSNs** of the lastest updates the remote replicas received and sent to the local replica.

Note that a supplier *replica agreement* is sending updates to consumer *replica*. If replication is going wrong, it is very often required to get information from the **supplier Replica agreement** and from the **Consumer Replica**.
### CSN

A csn is basically a timestamp concatenated with the identifier of the replica where the timestamp was taken.

A csn can look like: 590891180001001a0000. 590891180001 is the timestamp and 001a the identifier of the replica

CSN are generated such a way that a newly generated CSN (on a replica) contains a timestamp that is larger that any CSN the replica generated **AND** received. So newly generated timestamp can be greater than the current time on the replica.

### RUV

A RUV is looking like this

       dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
       nsds50ruv: {replicageneration} 5908aac8000000010000
       nsds50ruv: {replica 2 ldap://localhost:39002} 5908ab05000200020000 5908abe5000000020000
       nsds50ruv: {replica 1 ldap://localhost:39001} 5908aae1000000010000 5908ab05000000010000
       nsds50ruv: {replica 3 ldap://localhost:39003} 5908abf9000000030000 5908abf9000000030000
       
This information should be retrieved with a ldapsearch command:

       ldapsearch -LLL -o ldif-wrap=no -h localhost -p 39002 -D "cn=directory manager" -w password -b "cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config" nsds50ruv

The localhost:port refers to a specific *Replica*. If there are 3 servers (ldap://localhost:3900[123]) in the topology, **troubleshooting MUST retrieve all of them**.

### Replication error logging

This is a log level that records replication events (from both Replica and Replica Agreements). Those logs can be difficult to interpret because of parallelism. In fact if only one update can be processed by the *Replica*, severals *replica agreements* can be running at the same time. Lines of logs of all those threads are mixed making troubleshooting difficult the more there are updates and replica agreements.

# Major Configuration options

None

# Replication


# updates and Upgrades


# Dependencies

None
