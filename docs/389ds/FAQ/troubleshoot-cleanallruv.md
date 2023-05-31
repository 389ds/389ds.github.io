---
title:  "Troubleshooting CleanAllRUV Task"
---

# Troubleshooting CleanAllRUV Task
------------

{% include toc.md %}

---------------

## Introduction

The CleanAllRUV Task is the only way to remove a deleted replica's RUV information across all the configured replicas without the RUV being re-polluted during the process.  The original CLEANRUV task is still available, but it does not prevent the RUV from getting polluted with the deleted replica's information, because of this its use is not recommended anymore.

The way the CleanAllRUV task is designed there can be a few "issues" that arise when it s not properly used.  The task can "hang" for various reasons(although good reasons).  The CleanAllRUV abort task can also hang, and then can not be removed.  And there are other potential issues.  This page will describe these scenarios in more detail and tell you how to troubleshoot and resolve them.


### Task Entry Reference

    dn: cn=clean 222, cn=cleanallruv, cn=tasks, cn=config
    objectclass: top
    objectclass: extensibleObject
    replica-base-dn: dc=example,dc=com
    replica-id: 222
    replica-force-cleaning: no
    cn: clean 222

    dn: cn=abort 222, cn=abort cleanallruv, cn=tasks, cn=config
    objectclass: top
    objectclass: extensibleObject
    cn: abort 222
    replica-base-dn: dc=example,dc=com
    replica-id: 222
    replica-certify-all: no 


------------------------

## The CleanAllRUV Process


Here is a step by step list of what the task actual does during the process.  This is also described in the [CleanAllRUV Design Page](../design/cleanallruv-design.html)

-   Find the maxcsn for the replica that is being deleted.  This is used to make sure that all the replicas have seen the last update that was sent by the replica that was removed.  The idea here is that we don't want to lose any changes because of the ruv cleaning process.
-   Mark the deleted replicas RID (replica ID) as being cleaned.  This prevents the local ruv from getting re-polluted.
-   The CleanAllRUV task is then written to the replication configuration entry.  It is stored here so that in case of a server restart or crash.  The server knows that CleanAllRUV task was started, and it will resume at the next server startup.  Once the task completes, it removes itself from the replication configuration.
-   The task waits to make sure the local server has seen the maxcsn from the deleted replica before it continues.  If it hasn't it will wait indefinitely unless the "force cleaning" option was specified - more on this later.
-   Then the task checks that all the configured replicas are online (it does this by looking at the replication agreements and trying to do a search on those replicas).  If a replica is not online(aka can not be successfully searched), the task will wait, forever, until all the servers are up.  This is a common reason for the CleanAllRUV Task to "hang".
-   Then task waits for all the replicas to have also processed the maxcsn from the deleted replica.  Now we know all the servers have seen all the updates that came from the deleted replica.
-   Once all the updates have been seen, the server blocks all updates coming in, or going out, that came from the deleted replica.  This prevents the server from polluting other replicas.
-   Then the task sends out the "CleanAllRUV Extended Operation" via oid **"2.16.840.1.113730.3.6.5"** to all the configured replicas.  When a replica receives the extended operation it fires of its own CleanAllRUV Task, to clean itself and any other replicas that it might have configured.  This allows the task to cascade through an entire replication deployment.
-   The task waits for all the replicas to receive the CleanAllRUV task before continuing
-   The task finally cleans the local RUV's (Database and Replication Changelog).  This is what the old CLEANRUV task would do.
-   Then the task waits for all the replicas it sent an extended operation to, to be cleaned.  It does this through another extended operation (**2.16.840.1.113730.3.6.8**).  The task will wait indefinitely until all the replicas have been cleaned.
-   Once all the replicas are cleaned, the task is removed from the replication configuration, and the task finishes.

As you can see there are several steps where the task will wait for certain actions to complete.  These are common points of "hanging".  This is by design as the task can not continue until certain steps are complete, otherwise the whole process would break, and RUV would not be correctly/permanently cleaned.

-----------------------

## The CleanAllRuv Task

The **replica-force-cleaning** option is sometimes misunderstood, or the attribute name can be confusing.  So it will be discussed in more detail below.


### The Force Cleaning Option

The force cleaning option just tells the task to not check if the maxcsn of the deleted replica was received by all the replicas.  The risk of using this option is that technically there is a potential for lost changes using this option, but sometimes it is not possible that all the replicas can receive all of these changes, and in that case we can force the cleaning process to move forward by skipping over this maxcsn check.

In 389-ds-base-1.3.4 this is all it did, just skip the deleted replica maxcsn check, but in 389-ds-base-1.3.5 it will also ignore replicas that are not online.  This could potentially get backported, but there are no plans to do so at this time (8/11/2015).  The risk of ignoring replica that are not inline, is that if they come back online they will re-pollute the RUV's in all the replica's.  So this should be done if you know that that replica is permanently down.


-----------------------------

## The Abort CleanAllRUV Task

The abort task will cancel an existing "clean" task that is stuck or "hanging", but there are also issues you need to be aware before issuing an "abort" task.


### The Certify All Option

The certify all option means that the task will not end unless the abort task is received by all replicas.  So if you are aborting the task because one or more replicas are not online, then this task will never finish!  This option should only be set "yes" if all the replicas are started and available.

So if you are aborting a task because the clean task is waiting for a replica to be online, then you better set **replica-certify-all** to **"no"**.


--------------------------------------

## Troubleshooting The CleanAllRUV Task


### Check The Logs

The cleanallruv task has detailed logging that can used to identify why the task failed, or why it is not progressing(aka hanging).

Lets look at an example...

Add a CleanAllRUV task for replica ID 222

    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Initiating CleanAllRUV Task...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Retrieving maxcsn...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Found maxcsn (55ca560e000000de0000) 
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Cleaning rid (222)...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting to process all the updates from the deleted replica...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting for all the replicas to be online...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting for all the replicas to receive all the deleted replica updates...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Sending cleanAllRUV task to all the replicas...
    [11/Aug/2015:16:11:56 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Cleaning local ruv's...
    [11/Aug/2015:16:11:57 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting for all the replicas to be cleaned...
    [11/Aug/2015:16:11:57 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting for all the replicas to finish cleaning...
    [11/Aug/2015:16:11:57 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Successfully cleaned rid(222).
Successfully cleaned rid(222).


Each log line represents a different phase where things can go wrong.  Typically the phases are sending operations to all the configured replicas.  When something does go wrong the logging well display which replication agreement and host that is misbehaving.  You can then go and check the logs on that host to see what is going wrong.  Sometimes you have follow the errors and go from server to server to truly find the cause, but it is there and you can find it.

**Note - It is best to simply grep the errors log for the particular task you are looking for.  This makes it much easier to trouble a particular task, especially when there are multiple tasks being run at the same time.**

    grep "CleanAllRUV Task (rid 222)" errors


#### Replica-Down Scenario

    ...
    ...
    [11/Aug/2015:16:25:06 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Waiting for all the replicas to be online...
    [11/Aug/2015:16:25:06 -0400] slapi_ldap_bind - Error: could not send bind request for id [uid=replica,cn=config] authentication mechanism [SIMPLE]: error -1 (Can't contact LDAP server), system error -5987 (Invalid function argument.), network error 107 (Transport endpoint is not connected, host "localhost.localdomain:7777")
    [11/Aug/2015:16:25:06 -0400] NSMMReplicationPlugin - agmt="cn=replica B" (localhost:7777): Replication bind with SIMPLE auth failed: LDAP error -1 (Can't contact LDAP server) ()
    [11/Aug/2015:16:25:06 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Replica not online (agmt="cn=replica B" (localhost:7777))
    [11/Aug/2015:16:25:06 -0400] NSMMReplicationPlugin - CleanAllRUV Task (rid 222): Not all replicas online, retrying in 10 seconds...

Here we can see that the replica pointed to by the replication agreement "cn=replica B (localhost:7777)".  The host and port are listed which makes it much easier to know which instance is down and needs to be investigated.


### The Obvious Way To Get Around Offline Replicas

Obviously if a replica is offline, it's offline and probably can not come back online at the moment.  So, you can always delete the replication agreement to the offline replica, and the task will stop checking if that replica is online, and it should continue progressing at the next pass.  Design recap: it's the replication agreements that tell the CleanAllRUV task where to go and what to clean.  If an agreement is misbehaving, then *disable* it, or delete it.


### How to Manually Remove a Clean/Abort Task

There can be situations where you can't abort a clean task, or you can't abort an abort task.  Whatever the reason is, you can manually kill a task.  Now since the tasks are design to survive restarts we will need to manipulate the config to remove the tasks.

Each task will write its own *"Task Info"* in a backend replication configuration entry.

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    nsds5ReplicaCleanRUV: 222:00000000000000000000:no

Each running task will have an attribute:

    nsds5ReplicaCleanRUV: <rid><maxcsn><force cleaning>

You can delete this attribute and restart the server, and the task will resurrect itself at startup.  But...  You need to do this to all the replicas that have the task running, otherwise the task will resurrect itself by another replica trying to send its cleanallruv task to this replica.  It's very similar to how the RUV get polluted.

So the best approach is to use ldapmodify and remove these unwanted attributes from all the replicas, and then restart then in tandem.  *Easier said that done*

You also do the same for an abort task that probably had "replica-certify-all" set to "yes":

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    nsds5ReplicaAbortCleanRUV: 222:dc=example,dc=com

You can also stop each server, and manaully remove these attributes from the *dse.ldif*

