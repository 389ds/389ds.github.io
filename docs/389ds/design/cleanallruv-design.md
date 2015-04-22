---
title: "CleanAllRUV Design"
---

# CleanAllRUV Task Design Doc for 389-ds-base-1.3.0
-----------------------------------------------------

{% include toc.md %}

## Task Process

    Task added    
       - Base DN    
       - Replica id    
       - Forcing (yes/no)  default is “no”    
             - This skips some RUV checks    
             - Risk of losing changes from the deleted replica    

    Find the highest maxcsn    
       - Use the replication agreements to contact all the replicas    
       - Using the replication agmts is a method used throughout this task    
       - Send an extended op to retrieve the maxcsn for the rid (avoids ACL issues)    

    Launch cleanallruv_thread()    

    Mark/pre-set the rid so that other replicas do not try and send the same cleanallruv extended op.    

    Mark the replica config that the cleaning for this rid has begun    
       - Adds an attribute (nsds5ReplicaCleanRUV)    
       - This allows for the task to resume after a server restart    
       - This is used to determine if the replica is done cleaning    

    Wait to get caught up with deleted replica’s maxcsn    
       - The “forcing” option skips this check    

    Wait for all the replicas to be online    
       - Issues root dse search to determine if the replica is running    

    Wait for all the replicas to be covered by the deleted replica’s maxcsn    
       - The “forcing” option skips this check    

    Everyone should now be caught up with all the changes from the deleted replica    

    Mark the rid as “cleaned”    
       - Blocks all operations that have the deleted replica’s rid    
       - Prevents the changelog from sending/writing updates from this rid    
       - This is to prevent the RUV from getting polluted during the cleaning process    

    Send the “cleanallruv” task to all the replicas via extended ops    
       - If a replica does not support this extended op, manually add the old “cleanruv” task to its config.  The Replica Bind DN needs access control permissions for this to work.    

    Wait for all the replicas to successfully receive the extended op    

    Clean the local database RUV and changelog RUV    

    Wait for all the replicas RUV’s to be cleaned    

    Trigger changelog trimming    

    Mark the replica config that we are done cleaning    
       - Just delete the “clean” attribute (nsds5ReplicaCleanRUV)    

    Wait for all the other replicas to be done cleaning    
       - Remote config is checked with an extended op to avoid ACL issues.    

    Release the rid    

## CleanALLRUV - Remote Replicas

    Receives “cleanallruv” extended op    

    Check if this rid is already being cleaned, or is being aborted (more on this later).    
       - If it is, then just return success, and stop.    

    Decode the payload from the extended op, and prepare our data    

    Launch cleanallruv_thread()    

    This process allows the “task” to cascade through the entire replication deployment    

## Abort CleanAllRUV Task

    Task added    
       - Replica id    
       - Base DN    
       - certify (yes/no) default is “no” (the old default was "yes", this was recently changed to "no" 4/22/15)    

    Make sure the rid specified is being cleaned, and is not already in an “abort” mode    

    Mark replica config that an abort task has been started    
       - Adds an attribute (nsds5ReplicaAbortCleanRUV)    
       - Used for resuming after a restart    
       - Used to determine is abort task is finished    

    Trigger cleaning task to stop    

    Launch abort thread    

    Send “abort” extended op to all the replicas    

    Mark the config that we are done “aborting”    
       - We just delete the abort attribute (nsds5ReplicaAbortCleanRUV)    

    Wait for all the replicas to finish “aborting”    
       - If “certify” is set to “off” it skips this check    

    Release the rid    

## Abort Task – remote replica

    Receives “Abort” extended op    

    Checks if the rid is being cleaned, and is not already being aborted    
       - If it is, we just return success, and stop.    

    Marks config that we have started the “abort”    

    Launch abort thread    

## Best Process For Cleaning a RUV

       On the Replica to be removed (if not already removed)    
           - Put into read-only mode to prevent further updates    
       On all the other replicas    
           - Remove repl agmts to the “to be removed” replica.    
       On the Replica to be removed    
           - Remove all replication agmts and config    
           - Remove Replica    
       Add “cleanAllRUV task” to a top master replica    

## Misc
--------

### Source code

repl5\_replica\_config.c

       - cleanallruv_thread()    
       - abort_cleanallruv_thread()    
       - Task functions    
       - Helper functions    

repl5\_extop.c

       - cleanallruv extop    
       - retrieve maxcsn extop    
       - check status extop    
       - abort cleanallruv extop    

repl5\_replica.c

       - Checks for incomplete tasks at startup    

### OIDs

       REPL_CLEANRUV_OID "2.16.840.1.113730.3.6.5"    
       REPL_ABORT_CLEANRUV_OID "2.16.840.1.113730.3.6.6"    
       REPL_CLEANRUV_GET_MAXCSN_OID "2.16.840.1.113730.3.6.7"    
       REPL_CLEANRUV_CHECK_STATUS_OID "2.16.840.1.113730.3.6.8"    

### Replica Config

       - nsds5ReplicaCleanRUV: <rid>:<replica root dn>:<maxcsn>:<force option>
       - nsds5ReplicaAbortCleanRUV: <rid>:<replica root dn>:<certify option>
       This is also the format of the extended op payloads

### Task Output

Error Log, or this can be found in task entry in cn=config

       [16/Nov/2012:15:09:02 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Initiating CleanAllRUV Task...    
       [16/Nov/2012:15:09:02 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Retrieving maxcsn...    
       [16/Nov/2012:15:09:02 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Found maxcsn (50a7ddfc0001014d0000)    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Cleaning rid (333)...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Waiting to process all the updates from the deleted replica...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Waiting for all the replicas to be online...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Waiting for all the replicas to receive all the deleted replica updates...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Sending cleanAllRUV task to all the replicas...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Cleaning local ruv's...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Waiting for all the replicas to be cleaned...    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Replica is not cleaned yet (agmt="cn=to replica" (localhost:18243))    
       [16/Nov/2012:15:09:03 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Replicas have not been cleaned yet, retrying in 10 seconds    
       [16/Nov/2012:15:09:14 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Waiting for all the replicas to finish cleaning...     
       [16/Nov/2012:15:09:14 -0500] NSMMReplicationPlugin - CleanAllRUV Task: Successfully cleaned rid(333).     

### Access Log Breakdown

Retrieve the maxcsn:

       [16/Nov/2012:15:09:02 -0500] conn=8 fd=65 slot=65 connection from 127.0.0.1 to 127.0.0.1    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=0 BIND dn="uid=replica,cn=config" method=128 version=3    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=1 EXT oid="2.16.840.1.113730.3.6.7" name="Netscape Replication CleanAllRUV Retrieve MaxCSN"    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=1 RESULT err=0 tag=120 nentries=0 etime=0    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=2 UNBIND    
       [16/Nov/2012:15:09:02 -0500] conn=8 op=2 fd=65 closed – U1    

Check if replica is running:

       [16/Nov/2012:15:09:02 -0500] conn=9 fd=67 slot=67 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:02 -0500] conn=9 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:02 -0500] conn=9 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:02 -0500] conn=9 op=1 SRCH base="" scope=0 filter="(objectClass=top)" attrs=ALL     
       [16/Nov/2012:15:09:02 -0500] conn=9 op=1 RESULT err=0 tag=101 nentries=1 etime=0     
       [16/Nov/2012:15:09:02 -0500] conn=9 op=2 UNBIND     

Check if replica is caught up with maxcsn:

       [16/Nov/2012:15:09:02 -0500] conn=9 op=2 fd=67 closed - U1     
       [16/Nov/2012:15:09:02 -0500] conn=10 fd=65 slot=65 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=1 EXT oid="2.16.840.1.113730.3.6.7" name="Netscape Replication CleanAllRUV Retrieve MaxCSN"     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=1 RESULT err=0 tag=120 nentries=0 etime=0     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=2 UNBIND     
       [16/Nov/2012:15:09:02 -0500] conn=10 op=2 fd=65 closed – U1     

Send the cleanAllRUV extendop:

       [16/Nov/2012:15:09:03 -0500] conn=11 fd=67 slot=67 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=1 EXT oid="2.16.840.1.113730.3.6.5" name="Netscape Replication CleanAllRUV"     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=1 RESULT err=0 tag=120 nentries=0 etime=0     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=2 UNBIND     
       [16/Nov/2012:15:09:03 -0500] conn=11 op=2 fd=67 closed – U1     

Check if replica’s RUV has been cleaned:

       [16/Nov/2012:15:09:03 -0500] conn=12 fd=65 slot=65 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=1 EXT oid="2.16.840.1.113730.3.6.7" name="Netscape Replication CleanAllRUV Retrieve MaxCSN"     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=1 RESULT err=0 tag=120 nentries=0 etime=0     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=2 UNBIND     
       [16/Nov/2012:15:09:03 -0500] conn=12 op=2 fd=65 closed – U1    

Replica’s RUV has not been cleaned yet, retry in 10 seconds:

       [16/Nov/2012:15:09:13 -0500] conn=13 fd=65 slot=65 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=1 EXT oid="2.16.840.1.113730.3.6.7" name="Netscape Replication CleanAllRUV Retrieve MaxCSN"     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=1 RESULT err=0 tag=120 nentries=0 etime=0     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=2 UNBIND     
       [16/Nov/2012:15:09:13 -0500] conn=13 op=2 fd=65 closed – U1     

Replica’s RUV is clean, now check if replica is finished cleaning:

       [16/Nov/2012:15:09:14 -0500] conn=14 fd=65 slot=65 connection from 127.0.0.1 to 127.0.0.1     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=0 BIND dn="uid=replica,cn=config" method=128 version=3     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=replica,cn=config"     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=1 EXT oid="2.16.840.1.113730.3.6.8" name="Netscape Replication CleanAllRUV Check Status"     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=1 RESULT err=0 tag=120 nentries=0 etime=0     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=2 UNBIND     
       [16/Nov/2012:15:09:14 -0500] conn=14 op=2 fd=65 closed – U1     

Done.

