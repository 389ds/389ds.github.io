---
title: "Contention on global counters"
---

# Contention on global counters
----------------

{% include toc.md %}

# Overview
---------

The servers manages a set of counters in order to report metrics either with SRCH "cn=monitor" or with SNMP agent. The counters are global and so the threads updating the counters are all accessing the same counters and same memory addresses. The counters are accessed by workers and/or listener threads. All of them are in competition to access the counter memory addresses that creates contention.

This design proposes to allocate a set of counters per worker threads and a default set of counters for the listener.

# Use cases
-----------

The contention was detected during high search rate on highend machine. Using 'perf c2c' it showed that global counters memory lines were some of the most accessed lines.
On the machine, disabling management of global counters (on a craft build) increased throughput by 2%


# Design
--------

## Current implementation
Global counters are stored in the following structure. The struct mostly contains counters related to processed operations (*ops_tbl*), the others counters are either not managed or administrive purpose (related to counters themself).

    struct snmp_vars_t
    {
        struct snmp_ops_tbl_t ops_tbl;
        struct snmp_entries_tbl_t entries_tbl;
        struct snmp_int_tbl_t int_tbl[NUM_SNMP_INT_TBL_ROWS];
    };

The structure is a static variable **global_snmp_vars**, allocated when the binary is loaded, and threads get a reference to it with the function **g_get_global_snmp_vars**. For example

    slapi_counter_increment(g_get_global_snmp_vars()->ops_tbl.dsStrongAuthBinds);

Some counters are not updated via a call to **g_get_global_snmp_vars**. They are directly access, they are 

- dsOpInitiated - number of received operation
- dsOpCompleted - number of processed operation
- dsEntriesSent - number of entries returned to a search
- dsBytesSent - number of bytes sent over the network

## New implementation

### All counters being private

Those global counters are moved from global definition to the struct snmp_vars_t that is now private per thread

- dsOpInitiated - number of received operation
- dsOpCompleted - number of processed operation
- dsEntriesSent - number of entries returned to a search
- dsBytesSent - number of bytes sent over the network


    struct snmp_server_tbl_t
    {
        /* general purpose counters */
        Slapi_Counter *dsOpInitiated;
        Slapi_Counter *dsOpCompleted;
        Slapi_Counter *dsEntriesSent;
        Slapi_Counter *dsBytesSent;
    };
    struct snmp_vars_t
    {
        struct snmp_ops_tbl_t ops_tbl;
        struct snmp_entries_tbl_t entries_tbl;
        struct snmp_server_tbl_t server_tbl;
        struct snmp_int_tbl_t int_tbl[NUM_SNMP_INT_TBL_ROWS];
    }


### counters private to thread

Each thread has now its own set of counters. An array of per thread sets of counters is allocated at startup **per_thread_snmp_vars**. Then each thread gets a reference to its set with the function **g_get_per_thread_snmp_vars**. For example

    slapi_counter_increment(g_get_per_thread_snmp_vars()->ops_tbl.dsStrongAuthBinds);

### Initialization of the threads
At startup, each worker thread (connection_threadmain) is granted an *index* (CreateThread argument) into **per_thread_snmp_vars**. The thread keeps the *index* into a thread private area (*thread_private_snmp_vars_idx*). Later when calling **g_get_per_thread_snmp_vars**, the *index* is retrieved and the private set of counters is returned **per_thread_snmp_vars[*index*]**

If a thread has no *index* (*thread_private_snmp_vars_idx*), then **g_get_per_thread_snmp_vars** fallback to the common set of counters: **per_thread_snmp_vars[0]**.

The listener thread has no *index*, thus it uses **per_thread_snmp_vars[0]** counters

### Initialization of the per thread set of counters
**per_thread_snmp_vars** is allocated in two phases. Early in *main*, before reading dse.ldif, the first slot **per_thread_snmp_vars[0]** is allocated (calling **alloc_global_snmp_vars**). Later when the workers threads are started, private thread area is defined (**init_thread_private_snmp_vars**) and **per_thread_snmp_vars[]** is reallocated (calling **alloc_per_thread_snmp_vars**).

### snmp lookup

With the new array of counters, snmp lookup need to iterate over the slots of **per_thread_snmp_vars[]**. For this, each snmp counter is now the sum of the counter in all slots **per_thread_snmp_vars[]**.
To iterate over the array new functions are *g_get_first_thread_snmp_vars* and *g_get_next_thread_snmp_vars*.

# Tests

# Reference
-----------------

[4312](https://github.com/389ds/389-ds-base/issues/4312)

# Author
--------

<tbordaz@redhat.com>
