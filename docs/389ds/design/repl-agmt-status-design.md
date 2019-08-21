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

To address these issues the status messages should use different identifiers for the state: "Red", "Amber", and "Green".  "*Green*" messages imply that the state is *good* and working properly, "*Amber*" messages imply that replication is currently not in progress, but it will retry to acquire the replica and continue without any needed intervention.  "*Red*" messages implies that replication is broken/halted, and needs some type of intervention (reinit, etc)

Due to backwards compatibilty isusue, a new attribute was created that will store the new revised replication status called  **replicaLastUpdateStatusJSON**.  It will contain a JSON string version of the status message.  It will contain the replication error (and error description text), the ldap error (and description text), the date in ISO 8601 format, and the complete status message:

    {
        "state": "green/amber/red",
        "date": "2019-06-13T15:40:23Z",
        "repl_rc": "0",
        "repl_rc_text": "replica acquired",
        "ldap_rc" : "0",
        "ldap_rc_text": "success",
        "message": "status message"
    }

When combined the results are as follows

    replicaLastUpdateStatus: Error (0) Replica acquired successfully: Incremental update succeeded
    replicaLastUpdateStatusJSON: {"state": "green", "date": "2019-06-13T15:40:23Z", "repl_rc": "0", "repl_rc_text": "replica acquired", "ldap_rc" : "0", "ldap_rc_text": "success", "message": "Replica acquired successfully: Incremental update succeeded"

    replicaLastUpdateStatus: Error (1) Can't acquire busy replica, will retry
    replicaLastUpdateStatusJSON: {"state": "amber", "date": "2019-06-13T15:40:23Z", "repl_rc": "1", "repl_rc_text": "replica busy", "ldap_rc" : "0", "ldap_rc_text": "success", "message": "Can't acquire busy replica, will retry"

    replicaLastUpdateStatus: Error (19) Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)
    replicaLastUpdateStatusJSON: {"state": "red", "date": "2019-06-13T15:40:23Z", "repl_rc": "19", "repl_rc_text": "RUV error", "ldap_rc" : "0", "ldap_rc_text": "success", "message": "Replication error acquiring replica: Replica has different database generation ID, remote replica may need to be initialized (RUV error)"


For "Total Init" status there is a new attribute **replicaLastInitStatusJSON** that will contain a JSON string version of the friendly status message.  It will contain the replication return code (and description text), the connection result code (and description text), the ldap return code (and description text), the date in ISO 8601 format, and the complete status message:

    {
        "state": "green/amber/red",
        "date": "2019-06-13T15:40:23Z",
        "repl_rc": "0",
        "repl_rc_text": "replica acquired",
        "conn_rc": "0",
        "conn_rc_text": "operation success",
        "ldap_rc" : "0",
        "ldap_rc_text" : "success",
        "message": "status message"
    }

Dependencies
------------

Impacts FreeIPA status parsing.


Origin
-------------

<https://pagure.io/389-ds-base/issue/49602>

Author
------

<mreynolds@redhat.com>



