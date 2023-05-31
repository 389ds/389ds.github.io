---
title: "Task Invocation Via LDAP Design"
---

# Task Invocation Via LDAP Design
---------------------------------

{% include toc.md %}

Implementation
==============

cn=tasks The general framework of cn=tasks is laid out in [Task Invocation Via LDAP Design](task-invocation-via-ldap-design.html) so read that first: the general idea is to create a section of the DSE under cn=config where server maintenance tasks can be started. Each task becomes its own entry, and the attributes of the entry track the task's parameters (for example, the files to import) and running status.

There are five tasks:

-   cn=import, cn=tasks, cn=config
-   cn=export, cn=tasks, cn=config
-   cn=backup, cn=tasks, cn=config
-   cn=restore, cn=tasks, cn=config
-   cn=index, cn=tasks, cn=config

The entries under each task share a common base objectClass (to be defined) with the following attributes:

-   cn (cis) - descriptive name given by the client ("cn=initial import" or whatever)
-   nsTaskStatus (ces) - transient info about the task; for example, running statistics -- the contents of this field may be completely replaced periodically
-   nsTaskLog (ces) - collected log entries of the task, generally warning & information messages -- the contents of this field usually grow (with new information appended) without erasing the original contents
-   nsTaskExitCode (int) - only valid after the task is complete; 0 indicates success and anything else indicates an error code - the presence of this entry is used to indicate task completion
-   nsTaskCurrentItem (int) - the number of "work items" of this task that are complete; if the task can't be easily broken down into "work items", then nsTaskTotalItems should be 1, and nsTaskCurrentItem should stay 0 while the task is running, switching to 1 when the task is complete -- the admin console will probably use this info to generate bar graphs of progress
-   nsTaskTotalItems (int) - total number of "work units" expected -- when nsTaskCurrentItem = nsTaskTotalItems, the task is considered to have finished
-   nsTaskCancel (cis TRUE/FALSE) modifiable by the user - the user can set this to "TRUE" to ask a task to abort
-   ttl (int) modifiable by the user - the amount of time (in seconds) this entry will still exist in the DSE after the task has finished or aborted -- this allows you to periodically poll the entry for new status info without missing any exit code

In addition, each task type has its own special attributes (for passing parameters to the task on startup). == cn=import ==

-   nsFilename (ces multiple) - names of the files to import
-   nsInstance (ces) - name of the instance to import into (ie "NetscapeRoot")
-   nsIncludeSuffix (dn multiple optional) - equivalent to the old '-s' option - limit the import to specific suffixes from the LDIF files
-   nsExcludeSuffix (dn multiple optional) - equivalent to the old '-x' option - exclude certain suffixes from the import
-   nsImportChunkSize (int optional) old '-c' option - lets the user override the detection of when to start a new pass during import
-   nsImportIndexAttrs (cis TRUE/FALSE optional) - defaults to TRUE: whether or not to index attributes too
-   nsUniqueIdGenerator (cis optional) - which kind of unique ID to generate (old '-g' option)
-   nsUniqueIdGeneratorNamespace (cis optional) - namespace for namespace-oriented unique IDs (old '-G' option)

cn=export
---------

-   nsInstance (ces multiple) - names of the instances to export from
-   nsFilename (ces) - name of the file to dump the ldif into
-   nsIncludeSuffix (dn multiple optional) - old '-s' option - limit the exported ldif file to specific suffixes
-   nsExcludeSuffix (dn multiple optional) - old '-x' option - exclude certain suffixes from the ldif file
-   nsUseOneFile (cis TRUE/FALSE optional) - defaults to FALSE - whether to export all of the instances into a single ldif file
-   nsExportReplica (cis TRUE/FALSE optional) - defaults to FALSE - old '-r' option - whether this is an export for replication
-   nsPrintKey (cis TRUE/FALSE optional) - defaults to TRUE - old '-N' option - whether to print out entry ids
-   nsUseId2Entry (cis TRUE/FALSE optional) - defaults to FALSE - old '-C' option - whether to use only the id2entry index for exporting
-   nsNoWrap (cis TRUE/FALSE optional) - defaults to FALSE - old '-U' option - whether to avoid wrapping long lines
-   nsDumpUniqId (cis TRUE/FALSE optional) - defaults to TRUE - old '-u' option - whether to dump unique id values

cn=backup
----------

-   nsArchiveDir (ces) - old '-a' option - directory to copy the backup into
-   nsDatabaseType (ces) - defaults to "ldbm database" - which backend plugin to backup

cn=restore
-----------

-   nsArchiveDir (ces) - old '-a' option - directory to restore from
-   nsDatabaseType (ces) - defaults to "ldbm database" - which backend plugin to restore

cn=index
----------

-   nsIndexAttribute (cis multiple optional) - old '-t' option - attribute to index, optionally followed by a colon and list of index types (example: "cn:pres,eq,sub")
-   nsIndexVLVAttribute (cis multiple optional) - old '-T' option - vlv index to regenerate

Backend Implementation Details
==============================

When calling the backend db2ldif/ldif2db/etc functions, there's now a new parameter in the pblock:

    Slapi_Task *pb_task;    

which can be pulled by the flag SLAPI\_BACKEND\_TASK. This parameter will be NULL for tasks that weren't started via the cn=tasks mechanism. For tasks that were, it will point to a structure containing lots of useful info (defined at the bottom of slapi-plugin.h) like the dn of the task. To update a task's progress, fill in the fields in the Slapi\_Task structure, and then call

    void slapi_task_status_changed(Slapi_Task *task);    

which will automatically do the modification of the cn=tasks entry for you. This function also checks the task state (task\_state), and if the state is SLAPI\_TASK\_FINISHED or SLAPI\_TASK\_CANCELLED, it considers the task done and schedules the cleanup of the task entry (based on the user-supplied ttl).

There are two callback functions in Slapi\_Task: cancel() is called if the user asynchronously requests the task to be canceled, and this callback should be set if the task can be canceled. destructor() is called after a task has finished (or aborted) and the user-supplied ttl has expired -- it's meant to be used for cleaning up any allocated memory, and it's called right before the Slapi\_Task structure is deallocated.

Update: Only ldif2db sets any of the state info or calls slapi\_task\_status\_changed(). The other (simpler) tasks are handed a Slapi\_Task structure that's already filled in, and these other tasks only need to call slapi\_task\_log\_notice() or slapi\_task\_log\_status() when they want to log an event or status change. The rest is handled by the frontend.

