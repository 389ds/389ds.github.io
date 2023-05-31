---
title: "Task Invocation Via LDAP Design"
---

# Task Invocation Via LDAP Design
----------------------

{% include toc.md %}

Goal
====

The goal is to reduce our reliance on the Admin server. One of the main things we use the admin server for is to run CGIs to perform various tasks, such as backup, restore, import/export (not over LDAP), start, stop, etc. Many of these tasks can be initiated via LDAP. The server could handle the request inside the process space of the server e.g. export, or spawn an external process if necessary (e.g. perl scripts).

Design
======

1) A new entry will be created under cn=config to serve as the parent for internal tasks, cn=tasks. 1 motivation) cn=config is typically used for server configuration and other internal purposes.

2) Each task will have an entry under cn=tasks. 2 motivation) This makes it easy to find out where the tasks are, to enumerate them, and to determine what tasks are supported. This also makes it easy to assign ACLs to specific tasks and to all tasks as a whole.

3) Each specific task entry will have a descriptive name for the cn attribute e.g. cn=export, cn=tasks, cn=config. Each entry should (but might not) have a description attribute whose value will describe the usage of the task, the allowed attributes and their usage, and the default values for the task. 3 motivation) user friendly

4) When the user wants to invoke a task, the user creates an entry under the type of task to run e.g. cn=myexport, cn=export, cn=tasks, cn=config. Each specific instance of a type of task will inherit from objectclass nsDirectoryServerTask which has the following allowed attributes:

attribute nsTaskStatus of type ces. This is the "output" of the task e.g. what used to be printed to stdout and stderr when the task was run from the command line, or what gets sent back to the http client when the CGI is run. As soon as a line of output is read from the command, it will be appended to the value of this attribute. The line separator character will be \\n. The client will be responsible for displaying the status to the end user in a consistent manner.

attribute nsTaskExitCode of type int. This is the old exit code from the task, which can be used to hold the value of errno.

attribute nsTaskCancel of type cis (TRUE or FALSE). If this is set to TRUE by the client, the task will be canceled if it is in progress.

attribute ttl (already defined). This determines how long after the completion of the task the entry will be available. The client may set this, otherwise an appropriate default value will be provided by the server, possibly in one of the parent entries.

attribute nsTaskCancelttl of type int. This determines how long the server should wait for the task to cancel itself upon shutdown before it is killed with extreme prejudice.

attribute description (already defined). This describes how to create the specific task entry, the allowed attributes and their usage, and default values.

attribute nsTaskCurrentItem of type int attribute nsTaskTotalItems of type int. This pair of attributes can be used to implement a progress bar/meter on the client. The units would be different for each type of task, but a unit independent number should suffice for all tasks. For example, for the export task, the current item would be the number of entries exported, and the total items would be the total number of entries to export. For import, the current item would be the position of the file pointer, and the total items would be the file size. And so on. For some tasks, it may not make sense to measure progress in this manner, so the nsTaskTotalItems for those tasks would be 0.

4 motivation) The client uses standard LDAP to initiate and monitor task status. Each task of a specific type can easily be found e.g. what is the status of all current export tasks. The value of the nsTaskStatus attribute provides information about the task for end users. The nsTaskExitCode provides an easy way to determine success/failure e.g. 0 for success and non-zero for failure. The nsTaskCancel attribute gives us a way to cancel operations in progress, something which is very difficult to do with CGIs. The ttl gives us a way to do garbage collection.

Example: Database Export to LDIF
================================

    objectclass nsDirectoryExportTask superior nsDirectoryServerTask    
    allows    
     nsFileName - ces single - name of output LDIF file; if no directory is given, the file will be written to the ldif \    
      subdirectory of this server's instance directory    
     nsIncludeSuffix - dn multiple - DNs of suffixes to dump    
     nsExcludeSuffix - dn multiple - DNs of suffixes not to dump    
     nsDumpChangeNumber - cis single (TRUE or FALSE) - dump change number or not    
     nsDumpUniqueIDs - cis single (TRUE or FALSE) - dump unique IDs or not    
     nsPrintKey - cis single (TRUE or FALSE) - print database keys in output or not    
     nsId2EntryOnly - cis single (TRUE or FALSE) - use the id2entry index only if perhaps other indices are corrupted    

Client - add entry

    dn: cn=myexport, cn=export, cn=tasks, cn=config    
    nsFileName: foo.ldif    
    nsIncludeSuffix: ou=People, dc=example, dc=com    

Server: 1) add the entry 2) change the message/error logging function so that the printouts from the backend db2ldif function update the nsTaskStatus attribute in addition to logging messages to the error log 3) do basically what slapd\_exemode\_db2ldif (in main.c) does i.e. build a pblock with the appropriate variables set and pass it to the backend db2ldif function. 4) write the return value to the nsTaskEditCode attribute 5) after the ttl expiration has been reached, delete the entry

