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

### replication session

A replication session is the set of ldap operations that a supplier sends to a consumer, in order to send the updates. 
The following paragraphs shows the logs of a session. The logs exists on both side supplier and consumer. They show the same event but with a different point of view.

The Supplier wants to know what (updates) the consumer knows and does not know, so that it can send missing updates.

The consumer is applying received updates like if the supplier was a ldap client with an exception: the received updated from a replication session must succeed. So replication on the consumer side is able to 

- at the entry level manage conflict, create tombstone, resurect entries
- at attribute level, to determine what is appropriate set of values depending on the csn.

#### Supplier logs

The following access log shows an ADD operation that was successfull. The csn=5909c984000200020000 gives the timestamps and the replica identifier (0x0002) where the operation was applied first.

      [03/May/2017:14:13:55.978594046 +0200] conn=1 op=26 ADD dn="cn=userX25,dc=example,dc=com"
      [03/May/2017:14:13:56.235660353 +0200] conn=1 op=26 RESULT err=0 tag=105 nentries=0 etime=0 csn=5909c984000200020000                

The following error log (with replication logging), shows that same operation when the csn is generated and inserted into the list of operations to be applied. Then, after the ADD is successfully applied in the database (of the **dc=example,dc=com** suffix), the server updates the changelog, so that the ADD can be replicated to others replicas. Finally the csn is removed from the pending list and the **RUV** updated.

      # Supplier generates a CSN for that update and keep it into the pending list
      [03/May/2017:14:13:56.027487946 +0200] - DEBUG - NSMMReplicationPlugin - ruv_add_csn_inprogress - Successfully inserted csn 5909c984000200020000 into pending list
      ...
      # Supplier successfully applied the update in the DB and now records it into the changelog
      [03/May/2017:14:13:56.069449921 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - cl5WriteOperationTxn - Successfully written entry with csn (5909c984000200020000)
      ...
      # Supplier remove the successfully applied CSN from the pending list and update the Supplier RUV
      [03/May/2017:14:13:56.132925087 +0200] - DEBUG - NSMMReplicationPlugin - csnplCommitALL: committing all csns for csn 5909c984000200020000
      [03/May/2017:14:13:56.175281009 +0200] - DEBUG - NSMMReplicationPlugin - ruv_update_ruv - Successfully committed csn 5909c984000200020000

The two samples of logs above **are not** part of a replication session. They shows a **direct** update (from a ldap client) to a server.

The following errors logs shows the **replication session**. On supplier side, error logs are the **only** place where a replication session can be seen.

      # This is the starting point of a replication session where the supplier **compares** its local RUV with the consumer RUV to determine if something needs to be sent
      [03/May/2017:14:13:55.571421655 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - _cl5PositionCursorForReplay - (agmt="cn=meTo_localhost:39001" (localhost:39001)): Consumer RUV:
      [03/May/2017:14:13:55.588858376 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replicageneration} 5909c967000000010000
      [03/May/2017:14:13:55.600694127 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replica 1 ldap://localhost:39001} 5909c977000000010000 5909c981000200010000 00000000
      [03/May/2017:14:13:55.612511057 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replica 3 ldap://localhost:39003}
      [03/May/2017:14:13:55.702632462 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replica 2 ldap://localhost:39002}
      [03/May/2017:14:13:55.717787518 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - _cl5PositionCursorForReplay - (agmt="cn=meTo_localhost:39001" (localhost:39001)): Supplier RUV:
      [03/May/2017:14:13:55.775765461 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replicageneration} 5909c967000000010000
      [03/May/2017:14:13:55.798957817 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replica 2 ldap://localhost:39002} 5909c982000000020000 5909c984000000020000 5909c983                                              
      [03/May/2017:14:13:55.837460815 +0200] - DEBUG - NSMMReplicationPlugin - agmt="cn=meTo_localhost:39001" (localhost:39001): {replica 1 ldap://localhost:39001} 5909c97e000000010000 5909c981000200010000 5909c982
      ...
      # Consumer (ldap://localhost:39001) does not know any update for replica 0x0002, so the supplier starts from the first csn=5909c982000000020000
      [03/May/2017:14:13:56.040199527 +0200] - DEBUG - clcache_initial_anchorcsn - anchor is now: 5909c982000000020000
      ...
      # Supplier tries to retrieve the csn from the changelog and finds it \o/
      [03/May/2017:14:13:56.088751270 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - agmt="cn=meTo_localhost:39001" (localhost:39001): CSN 5909c982000000020000 found, position set for replay
      ...
      # Suppliers sends all updates from 5909c982000000020000 up to 5909c984000000020000 (here only showing the last update)
      [03/May/2017:14:13:56.539798349 +0200] - DEBUG - NSMMReplicationPlugin - replay_update - agmt="cn=meTo_localhost:39001" (localhost:39001): Sending add operation (dn="cn=userX25,dc=example,dc=com" csn=5909c984000200020000)
      [03/May/2017:14:13:56.551137343 +0200] - DEBUG - NSMMReplicationPlugin - replay_update - agmt="cn=meTo_localhost:39001" (localhost:39001): Consumer successfully sent operation with csn 5909c984000200020000
      ..
      # Then the supplier notices there is nothing more to send and ends the session
      [03/May/2017:14:13:56.599378848 +0200] - DEBUG - NSMMReplicationPlugin - send_updates - agmt="cn=meTo_localhost:39001" (localhost:39001): No more updates to send (cl5GetNextOperationToReplay)



#### Consumer logs

The replication session is looking like this

      # Supplier replica agreement connect and authenticate to consumer
      [03/May/2017:14:13:50.641218061 +0200] conn=5 fd=66 slot=66 connection from 127.0.0.1 to 127.0.0.1
      [03/May/2017:14:13:50.641292477 +0200] conn=5 op=0 BIND dn="cn=replrepl,cn=config" method=128 version=3
      [03/May/2017:14:13:50.641528452 +0200] conn=5 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="cn=replrepl,cn=config"
      ...
      # Acquire the exclusive access of the consumer replica
      [03/May/2017:14:13:55.136953488 +0200] conn=5 op=8 EXT oid="2.16.840.1.113730.3.5.12" name="replication-multisupplier-extop"
      [03/May/2017:14:13:55.325003375 +0200] conn=5 op=8 RESULT err=0 tag=120 nentries=0 etime=0
      ...
      # Suppliers sends that update
      [03/May/2017:14:13:57.738898147 +0200] conn=5 op=14 ADD dn="cn=userX25,dc=example,dc=com"
      [03/May/2017:14:13:58.157064443 +0200] conn=5 op=14 RESULT err=0 tag=105 nentries=0 etime=1 csn=5909c984000200020000
      ...
      # Release the exclusive access to the consumer replica
      [03/May/2017:14:28:16.098754565 +0200] conn=5 op=21 EXT oid="2.16.840.1.113730.3.5.5" name="replication-multisupplier-extop"
      [03/May/2017:14:28:16.115133835 +0200] conn=5 op=21 RESULT err=0 tag=120 nentries=0 etime=0


With the following logs related to the operation csn=5909c984000200020000

[03/May/2017:14:13:57.856408010 +0200] - DEBUG - NSMMReplicationPlugin - ruv_add_csn_inprogress - Successfully inserted csn 5909c984000200020000 into pending list
..
03/May/2017:14:13:57.937398801 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - cl5WriteOperationTxn - Successfully written entry with csn (5909c984000200020000)
...
03/May/2017:14:13:58.105695948 +0200] - DEBUG - NSMMReplicationPlugin - csnplCommitALL: processing data csn 5909c984000200020000
[03/May/2017:14:13:58.120147284 +0200] - DEBUG - NSMMReplicationPlugin - ruv_update_ruv - Successfully committed csn 5909c984000200020000
[03/May/2017:14:13:58.132569793 +0200] - DEBUG - NSMMReplicationPlugin - ruv_update_ruv - Rolled up to csn 5909c984000200020000

#### Troubleshooting

Usually we want to troubleshoot replication session when a supplier knows some updates but we can not see those updates on a given consumer.

To simplify debugging, it is recommended to trigger a brand new replication session taking particular attention to the date it occurs. In fact, in logs there are many replication session and it is recommended to isolate the one that is problematic.

To trigger a replication session you have few methods:
    - restart the supplier
    - do a dummy update on the supplier
    - (recommended) do the following update

       ldapmodify -h host -p supplier_port -D "cn=Directory manager" -w passwd<<EOF
       dn: cn="cn=meTo_localhost:39001",cn=replica,cn="SUFFIX",cn=mapping tree,cn=config
       changetype: modify
       replace: nsds5replicaupdateschedule
       nsds5replicaupdateschedule: 0000-0001 0123456
       EOF
       sleep 3
       ldapmodify -h host -p supplier_port -D "cn=Directory manager" -w passwd<<EOF
       dn: cn="cn=meTo_localhost:39001",cn=replica,cn="SUFFIX",cn=mapping tree,cn=config
       changetype: modify
       replace: nsds5replicaupdateschedule
       nsds5replicaupdateschedule: 0000-2359 0123456
       EOF

To troubleshoot a replication session you need to know 
    - the consumer url : **ldap://localhost:39001**
    - the name of the replica agreement between the supplier and the consumer: **cn=meTo_localhost:39001**

Now it is highly recommended to put aside a copy of the access/errors logs of supplier/consumers.

First step is to look at the supplier error log to retrieve the **starting point of a replication session**:  Comparison of the RUV

      [03/May/2017:14:13:55.571421655 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - _cl5PositionCursorForReplay - (agmt="cn=meTo_localhost:39001" (localhost:39001)): Consumer RUV:
      ...
      [03/May/2017:14:13:55.717787518 +0200] - DEBUG - NSMMReplicationPlugin - changelog program - _cl5PositionCursorForReplay - (agmt="cn=meTo_localhost:39001" (localhost:39001)): Supplier RUV:

(you may search for "**Consumer RUV:**" string, with particular attention its timestamps correspond to your test.

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

## Troubleshoot approach

In order to accelerate diagnostic it is important to track issues independently. Several issues may popup around the same time. They could be related but it is not sure. It is better to focus on a specfic one, get the related dataset and submit the case.

Most of the issues can be understood with access/errors logs and configuration (dse.ldif).

    - Isolate in the access log when the issue starts using timestamps
    - Check the error log for messages around that time
    - If you suspect specfic components to be part of the issue, enable the related logs (replication, acl, plugins, connection..)
    - When you identify something you think suspicious, report precise time when it starts/stop. It really help to focus rapidely on your real concern


# Major Configuration options

None

# Replication


# updates and Upgrades


# Dependencies

None
