---
title: "Howto: CLEANRUV"
---

# CLEANALLRUV/CLEANRUV Tasks
----------------------

{% include toc.md %}

When to use the tasks to cleanup the RUV
----------------------------------------

In a replicated environment, when you decommission a master, the meta-data for that master is still contained in the other servers. There are special tasks you can use to remove this meta-data. When you start up the server, you may get a warning like this in your errors log:

    [09/Sep/2011:09:03:43 -0600] NSMMReplicationPlugin - ruv_compare_ruv: RUV [changelog max RUV] does not
     contain element [{replica 55 ldap://localhost.localdomain:9389} 4e6a27ca000000370000 4e6a27e8000000370000]
     which is present in RUV [database RUV]
    ... more of these ...
    [09/Sep/2011:09:03:43 -0600] NSMMReplicationPlugin - replica_check_for_data_reload: Warning: for replica    
     dc=example,dc=com there were some differences between the changelog max RUV and the database RUV.  If    
     there are obsolete elements in the database RUV, you should remove them using the CLEANRUV task.  If they    
     are not obsolete, you should check their status to see why there are no changes from those servers in the changelog.    

This indicates that the database RUV (the replication meta-data) contains data for obsolete masters (they should be listed in the errors log). You can see these for yourself with ldapsearch:

    # ldapsearch -xLLL -D "cn=directory manager" -W -b dc=example,dc=com \
     '(&(nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff)(objectclass=nstombstone))'

There may be more than one replicated sub-suffix, so pay attention to which replica the message is complaining about.

CleanAllRUV
-----------

How to remove a replica and clean its RUV's from the remaining active replica servers.

1. On the Replica we want to remove put the database into read only mode to stop updates coming in.  This allows for the replica to flush out all its pending changes to the active replica servers.

        dn: cn=userRoot,cn=ldbm database,cn=plugins,cn=config
        changetype: modify
        replace: nsslapd-readonly
        nsslapd-readonly: on

2. On the other valid replicas, delete the agreements to the replica we want to remove

        dn: cn=to repl_to_remove,cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
        changetype: delete

3. On the Replica we want to remove, delete all the agreements, and remove the replica entry

        dn: cn=to repl1,cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
        changetype: delete
        ...
        dn: cn=to repl_last_one,cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
        changetype: delete
        dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
        changetype: delete

4. Run the CleanAllRUV task. This operation will be "replicated" to all the servers in the replication environment.

        dn: cn=clean 222, cn=cleanallruv, cn=tasks, cn=config
        objectclass: extensibleObject
        replica-base-dn: dc=example,dc=com
        replica-id: 222
        replica-force-cleaning: no  --> if set to "yes" the task does not check the maxcsn's.  Meaning, it won't force the replicas to get to get caught up with updates from the deleted replica.  However, the task will still run until all the configured replicas have been cleaned, or the task is aborted.
        cn: clean 222

    You can also abort the CleanAllRUV task, as the CleanAllRUV task can run for a long time if a replica is down during the cleaning process:

        dn: cn=abort 222, cn=abort cleanallruv, cn=tasks, cn=config
        objectclass: extensibleObject
        cn: abort 222
        replica-base-dn: dc=example,dc=com
        replica-id: 222
        replica-certify-all: no  --> if set to "no" the task does not wait for all the replica servers to have been sent the abort task, or be online, before completing.  If set to "yes", the task will run forever until all the configured replicas have been aborted.  Note - the orginal default was "yes", but this was changed to "no" on 4/21/15.  It is best to set this attribute anyway, and not rely on what the default is.  
 

5. You can monitor the task via the attribute "nsTaskStatus" and "nsTaskExitCode".

6. You can also manually confirm the result by searching on the tombstone entry on each remaining replica:

        # ldapsearch -xLLL -D "cn=directory manager" -W -b dc=example,dc=com \
         '(&(nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff)(objectclass=nstombstone))

7. Delete the replica server.

8. Done.

Also checkout the [Design Document](../design/cleanallruv-design.html)

CLEANRUV
--------

In order to run the CLEANRUV task, you will need to know

-   the replica config entry DN - you can find this using ldapsearch

        # ldapsearch -xLLL -D "cn=directory manager" -W -s sub -b cn=config objectclass=nsds5replica
        dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
        cn: replica
        ... more output ...

In this case, the DN to use is **cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config** - it looks funny because of the DN escapes, but they are necessary.

-   the replica ID - you can get this from the RUV tombstone entry like this:

        # ldapsearch -xLLL -D "cn=directory manager" -W -b dc=example,dc=com \
         '(&(nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff)(objectclass=nstombstone))'

Look at the nsds50ruv attribute - the replica ID is the number after the "{replica " in the RUV element - for example, in

    {replica 55 ldap://localhost.localdomain:9389} 4e6a27ca000000370000 4e6a27e8000000370000    

The replica ID is 55

To execute the CLEANRUV task, use ldapmodify:

    # ldapmodify -x -D "cn=directory manager" -W <<EOF
    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    changetype: modify
    replace: nsds5task
    nsds5task: CLEANRUV55
    EOF    

Where the **dn: ....** is the DN of the replica config entry, and the number after **CLEANRUV** in

    nsds5task: CLEANRUV55    

is the replica ID of the entry you want to remove.

After running ldapmodify, you can use

    # ldapsearch -xLLL -D "cn=directory manager" -W -b dc=example,dc=com \    
     '(&(nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff)(objectclass=nstombstone))'    

to see that the entry for the obsolete replica has been removed.

If there are multiple entries you need to get rid of, just execute the ldapmodify again with each replica ID number.

NOTE: **This operation does not replicate. You will have to perform this operation on all of your servers (masters, hubs, consumers).**

