---
title: "Replication Agreement Status"
---

# Replication Agreement Status
------------------------------

Overview
========

For each replication agreement a thread is created which contacts the consumer, detects if updtes have to be sent, locates these updates
in its own changelog and sends the updates to the consumer.
The status of the replication agreement is maintained in a attrinbute of the agreement: _*nsds5ReplicaLastUpdateStatus*_ and can be queried by client searches.

This document will list and explain the potential update states that can be see by a client

Disabled agreements
===================

If an replication agreement is disabled the update status no longer is updated. The message that is seen has two variants:

If the replication agreement was disabled when the server started

    "Error (0) No replication sessions started since server startup"

If the agreement was disabled while the server was running

    "Error (0) Replica acquired successfully: agreement disabled"

General agreement status
========================


    "Error (0) Replica acquired successfully: Protocol stopped"

    "Error (0) Replica acquired successfully: Incremental update started"

    "Error (0) Replica acquired successfully: Incremental update succeeded"

    "Error (0) Replica acquired successfully: Incremental update succeeded and yielded"
Error messages
==============

## State: ACQUIRING_REPLICA.

In the first step of a replication session the supplier wants to acquire the comsumer, it has to establish the connection, to bind to the consumer, to verify that the consumer is not already updated by another
supplier and some more checks.

 error, NSDS50_REPL_CONN_ERROR, "Problem connecting to replica"

 error, NSDS50_REPL_CONN_ERROR, "Problem connecting to replica (SSL not enabled)"

    "Error (extop_result) :Failed to acquire replica: Internal error occurred on the remote replica"

    "Error (extop_result) :Unable to acquire replica: permission denied. The bind dn does not have permission to supply replication updates to the replica. Will retry later."

    "Error (extop_result) :Unable to acquire replica: there is no replicated area on the consumer server. Replication is aborting."

    "Error (extop_result) :Unable to acquire replica: the consumer was unable to decode the startReplicationRequest extended operation sent by the supplier. Replication is aborting."

    "Error (extop_result) :Unable to acquire replica: the replica is currently being updated by another supplier."

    "Error (extop_result) :Unable to acquire replica: the replica is supplied by a legacy supplier.  Replication is aborting."

    "Error (extop_result) :Unable to aquire replica: the replica has the same Replica ID as this one. Replication is aborting."

    "Error (extop_result) :Unable to acquire replica: the replica instructed us to go into backoff mode. Will retry later."

    "Error (extop_result) :Unable to acquire replica"

    0, NSDS50_REPL_DECODING_ERROR, "Unable to parse the response to the startReplication extended operation. Replication is aborting."

 error, NSDS50_REPL_CONN_ERROR, "Unable to receive the response for a startReplication extended operation to consumer. Will retry later."

    "Error (0) Unable to obtain current CSN. " "Replication is aborting."


## state SENDING_UPDATES

If a replica was successful acquired the session goes to the next state: sending updates 

There are several steps in this state with different error messages

### step 1: examine RUV

First the RUV of the consumer is examined, potential errors are:

    "Error (19) : Replica is not initialized"

This means the consumer replica has no update vector, replication was probably not enabled on the consumer

    "Error (19) : Replica has different database generation ID, remote replica may need to be initialized"

The consumer has not been initialized with a database containing the same database generation. Either the supplier or the consumer need to be initialized 

    "Error (19) : Replica needs to be reinitialized"

The consumer replica is too old ??


### step 2: updating csn generator

    "Error (2) : fatal error - too much time skew between replicas"

    "Error (2) : fatal internal error updating the CSN generator"



### step 3: initial changelog positioning

    0, NSDS50_REPL_CL_ERROR, "Invalid parameter passed to cl5CreateReplayIterator"

    0, NSDS50_REPL_CL_ERROR, "Unexpected format encountered in changelog database"

    0, NSDS50_REPL_CL_ERROR, "Changelog database was in an incorrect state"

    0, NSDS50_REPL_CL_ERROR, "Incorrect dbversion found in changelog database"

    0, NSDS50_REPL_CL_ERROR, "Changelog database error was encountered"

    0, NSDS50_REPL_CL_ERROR, "changelog memory allocation error occurred"

    0, NSDS50_REPL_CL_ERROR, "Data required to update replica has been purged from the changelog. " "The replica must be reinitialized."

    0, NSDS50_REPL_CL_ERROR, "Changelog data is missing"


### step 4: sending next update

    0, rc, "Failed to create result thread"


    0, NSDS50_REPL_CL_ERROR, "Invalid parameter passed to cl5GetNextOperationToReplay"

    0, NSDS50_REPL_CL_ERROR, "Database error occurred while getting the next operation to replay"

    0, NSDS50_REPL_CL_ERROR, "Memory allocation error occurred (cl5GetNextOperationToReplay)"



### step 6: subentry update

    0, -1, "Agreement is corrupted: missing suffix"


### general send_updates result:
    0, NSDS50_REPL_TRANSIENT_ERROR, "Incremental update transient error.  Backing off, will retry update later."

    0, NSDS50_REPL_CONN_ERROR, "Incremental update connection error.  Backing off, will retry update later."

    0, NSDS50_REPL_CONN_TIMEOUT, "Incremental update timeout error.  Backing off, will retry update later."



