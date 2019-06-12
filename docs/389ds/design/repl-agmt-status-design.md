---
title: "Replication Agreement Status Message Improvements"
---

# Replication Agreement Status Message Improvements
----------------

Overview
--------

Replication agreements have an attribute **replicaLastUpdateStatus** that contains a string about the state of that agreement.  All messages start with **Error (##)** followed by a text string.  Here are some examples:

    Error (0) Replica acquired successfully: Incremental update succeeded
    Error (1) Can't acquire busy replica, will retry
    Error (19) Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)

There are a few issues with this.  The first one is that we use the text "Error" for all replication states (good or bad).  This can be confusing as it is not obvious that **Error(0)** means success.  Other states are not severe and should be considered warnings, and some errors are fatal (breaking replication).  However the existing model makes it impossible to tell what the state truly is.  The other issue is that the status messages should also be machine friendly and easy to parse for client applications.

Design
------

To address these issues the status messages should use different identifiers for the state: "Error", "Warning", and "Info".  "Info" messages imply that the state is *good*, "warning" messages imply that replication is currently not in progress, but it will retry to acquire the replica and continue without issue.  "Error" messages implies that replication is broken/halted, and needs some type of intervention (reinit, etc)

    Info (0) Replica acquired successfully: Incremental update succeeded
    Warning (1) Can't acquire busy replica, will retry
    Error (19) Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)

To address the parsing issue a new attribute **replicaLastUpdateStatusJSON** will contain a JSON string version of the friendly status message

    {"state": "Good/Warning/Error", "repl_error": "0", "conn_error" : "0", "message": "status message"}

When combined the results are as follows

    replicaLastUpdateStatus: Info (0) Replica acquired successfully: Incremental update succeeded
    replicaLastUpdateStatusJSON: {"state": "Good", "repl_error": "0", "conn_error" : "0", "message": "Replica acquired successfully: Incremental update succeeded"

    replicaLastUpdateStatus: Warning (1) Can't acquire busy replica, will retry
    replicaLastUpdateStatusJSON: {"state": "Warning", "repl_error": "1", "conn_error" : "0", "message": "Can't acquire busy replica, will retry"

    replicaLastUpdateStatus: Error (19) Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)
    replicaLastUpdateStatusJSON: {"state": "Error", "repl_error": "19", "conn_error" : "0", "message": "Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)"


We also need to do the same thing with the *Total Init Status* messages:

    replicaLastInitStatus
    replicaLastInitStatusJSON

Dependencies
------------

Impact FreeIPA status parsing.


Origin
-------------

https://pagure.io/389-ds-base/issue/49602

Author
------

<mreynolds@redhat.com>



