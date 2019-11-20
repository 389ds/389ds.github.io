---
title: "Directory Server operation metrics"
---
    
# Operation metrics
----------------

{% include toc.md %}

This document describes how Directory Server will log metrics related to each individual operation. The metrics are counters (count, duration, timestamp, threshold, flags...) specific for a given operation. The counters are related to internal mechanism used by Directory Server core / plugins to process an operation. The counters are intended to be used for analyzing performance of separated operation but are not intended to measure load performance.

Overview
--------

When applying a given workload on a Directory Server we can see the operation <i>response time</i> (<b>etime</b>) in the access log. If we want to know the layout of the response time (i.e. database or index access, evaluation of aci, filter evaluation/check, values matching...) we can use <b>debug logging</b> or <b>external tools (pstack, stap, strace...)</b>. The drawbacks of those approaches are that they interfere with the server (slowdown). Also analyzing the logs/traces is time consuming (all operations logs/traces are mixed) and finally requires a good knowledge of DS internals to do  a diagnostic.

The purpose of this design is to present the layout of the response time with a mechanism with minimal impact on the server, because of the use of access logs that are buffered. Providing metrics per operation allow to isolate metrics from the others operations. If an operation has a large response time, many times it is due to very few expensive components. There is a hope that metrics from those expensive components will be significantly high to help diagnose without the need of good knowledge of DS internals.

Use Cases
---------

When monitoring performance we can see logs like

    [25/Oct/2019:16:23:28.620364576 +0200] conn=1 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(sn=user*)" attrs=ALL
    [25/Oct/2019:16:23:28.623701596 +0200] conn=1 op=1 RESULT err=0 tag=101 nentries=20 etime=0.003488420

This RFE will extend access logs with per operation statistics like

    [25/Oct/2019:16:23:28.620364576 +0200] conn=1 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(sn=user*)" attrs=ALL
    [25/Oct/2019:16:23:28.623678548 +0200] conn=1 op=1 STAT filter index lookup: attribute=objectclass key(eq)=referral --> count 0
    [25/Oct/2019:16:23:28.623697194 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=ser --> count 21
    [25/Oct/2019:16:23:28.623698763 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=use --> count 24
    [25/Oct/2019:16:23:28.623700176 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=^us --> count 20
    [25/Oct/2019:16:23:28.623701596 +0200] conn=1 op=1 RESULT err=0 tag=101 nentries=20 etime=0.003488420

For this operation we can see, for example, that the index lookups (db read) during filter evaluation were

   - (objectclass=referral)  -> 0 lookup (this value did not exist)
   - (sn=user*) -> 21+24+20= 65 lookup 

In such case 65 is not optimal but acceptable. For a long lasting operation, a value of let's say 100.000 lookup would have ring a bell as a possible responsible of the bad response time.

# Design
------

The principle is to collect metrics, during the processing of an operation, and to log them along with the operation result. The collect of metrics is done during specific <b>probes</b> of the operation processing, so collect could impact operation performance. The logging of the operation result is done <b>after</b> the operation result is sent back (for direct operation) or stored in the pblock (internal operations). So the <b>logging has no performance impact</b> for the operation itself. For operations that trigger internal operations <b>collect and logging of internal operations</b> impact the parent operation.

In order to limit the performance impact of the <b>probes</b>, we can turn <b>on/off</b> the collect in probes with a set of new config parameters <b>nsslapd-stat-&lt;operation&gt;-level</b>

## Configuration

<b>nsslapd-stat-bind-level</b>: default value is 0 (no stat collect)
<b>nsslapd-stat-search-level</b>: default value is 0 (no stat collect)
|Value|Name|Description|
|-----|----|-----------|
|1| OP_STAT_KEY_LOOKUP | For each key of a filter, it collect statistics for candidate IDs |
<b>nsslapd-stat-modify-level</b>: default value is 0 (no stat collect)
<b>nsslapd-stat-add-level</b>: default value is 0 (no stat collect)
<b>nsslapd-stat-delete-level</b>: default value is 0 (no stat collect)
<b>nsslapd-stat-modrdn-level</b>: default value is 0 (no stat collect)

## Data structure

The function <b>op_stat_init</b> called from <b>main</b> registers an <b>operation extension</b>.  The operation extension is retrieved by <b>Op_stat *op_stat_get_operation_extension(Slapi_PBlock *pb)</b>.

The structure of <b> Op_stat</b>
    typedef struct op_search_stat {
        /* Probe OP_STAT_KEY_LOOKUP */
        struct component_keys_lookup *keys_lookup;

        /* Probe OP_STAT_FILTER_COMP_IDL */
        ....
    } Op_search_stat;
    typedef struct op_bind_stat {
        ....
    }
    ...
    typedef struct op_stat {
        Op_bind_stat *bind_stat;
        Op_search_stat *search_stat;
        Op_modify_stat *modify_stat;
        ....
    } Op_stat;


## operation extension

During startup (main) <b>op_stat_init</b> is called to register (<i>slapi_register_object_extension</i>), an operation extension for module SLAPI_OP_STAT_MODULE ("Module to collect operation stat"). This extension is retrieved by <b>Op_stat *op_stat_get_operation_extension(Slapi_PBlock *pb)</b>

The operation extension desctructor (<b>op_stat_destructor</b>) should free all structures allocated during the collect of metrics. So it is modified each time a collect is changed.

## logging

Before the operation result is logged (<i>log_result</i>), <b>log_op_stat(Slapi_PBlock *pb)</b> is called. It logs each collected metrics of the operation.

The timestamp of the log is at the time of the log of the result. So the collected metrics should contain their own timestamp. This will allow to select all operations that were running at the same period.

## collected metrics

### Search

#### OP_STAT_KEY_LOOKUP

It collects the metrics related to index database lookup. For a given database key it can exist several entries (duplicate). To grab all the duplicates it calls db->get for each of them.

For example 1M entries <i>uid</i> starts with <i>user_</i> and the filter component is <i>(uid=user_1*)</i>. It creates '^us', 'use', 'ser', 'er_' and 'r_i' keys. Each of the keys will trigger 1M db->get, so a total of 5M for that component.

To catch impact of index db->get, OP_STAT_KEY_LOOKUP accounts for each key: <b>number of lookup</b> and <b>duration of lookups</b>
Also to correlate a lookup, for a given operation, with lookup from others operation it <b>timestamp begining and end</b> of all keys.

    struct component_keys_lookup
    {
        struct component_key_lookup *keys_lookup; /* list of all keys metrics */
        struct timespec start;  /* start of index lookup for a given filter component */
        struct timespec end;    /* end of index lookup for a given filter component */
    }
    struct component_key_lookup
    {
        char *index_type;
        char *attribute_type;
        char *key;
        int id_lookup_cnt;
        struct timespec duration;
        struct component_key_lookup *next;
    };


