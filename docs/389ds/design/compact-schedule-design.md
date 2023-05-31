---
title: "Database Compaction Scheduling Improvements"
---

# Database Compaction Scheduling
----------------

Overview
--------

Previously database compaction (and replication changelog compaction) occurred every 30 days from the time the server was last started.  The problem is that there is no way to have the server do the compaction at a specific time or day.  Since it's an expensive process it can cause problems during compaction during peak usage times.  This feature allows an Admin to set the Time Of Day (TOD) that task will run after the interval has been exceeded.  It also adds a "task" to trigger the compaction on demand.  This allows it to schedule the compaction in a Cronjob or custom script.


Design
------

There is a difference on how this works between 389-ds-base-1.4.3 and 1.4.4 (and up).  In 1.4.4 the replication changelog was moved into the main database.  This obsoleted the old changelog compaction interval (nsslapd-changelogcompactdb-interval) in favor of the main database compact interval (nsslapd-db-compactdb-interval).  So DB compaction will now do both the main database and its replication changelog at the same time.

All versions now have a new setting under *cn=config,cn=ldbm database,cn=plugins,cn=config*:  **nsslapd-db-compactdb-time**  This setting defines the Time Of Day that compaction will run.  By default the server will start the compaction task 1 minute prior to midnight (localtime).  To change this time use the following format:  **HH:MM**:

    nsslapd-db-compactdb-time: 23:59
    
To trigger database compaction manually a new task can be created (this is available in all version of 389-ds-base):

     dn: cn=compact_it,cn=compact db,cn=tasks,cn=config
     objectclass: top
     objectclass: extensibleObject
     cn: compact_it
    
### In 1.4.4 and newer

This will compact all the databases and their replication changelogs (if present).
    
There is also an additional setting for the task if you just want to compact just the changelog and not the main database (**justChangelog**):
    
     dn: cn=compact_it,cn=compact db,cn=tasks,cn=config
     objectclass: top
     objectclass: extensibleObject
     cn: compact_it
     justChangelog: yes
     
#### in 1.4.3

Since the changelog is separate in 1.4.3 you need to use separate configuration settings for compaction:

    nsslapd-changelogcompactdb-interval:   #####
    nsslapd-changelogcompactdb-time:  HH:MM
    
Like in newer version the compaction time will default to 1 minute prior to midnight (23:59).  You also need to use a separate replication task to manually trigger changelog compaction in 389-ds-base-1.4.3:

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    changetype: modify
    replace: nsds5task
    nsds5task: COMPACT_CL5

Note - This task does not exist in 1.4.4 or newer!  


Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=1748441>
<https://github.com/389ds/389-ds-base/issues/4778>

Author
------

<mreynolds@redhat.com>

