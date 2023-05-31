---
title: "Directory Server operation metrics"
---
    
# Operation metrics
----------------

{% include toc.md %}

This document describes how Directory Server logs metrics related to each individual operation. The metrics are stored in a per operation structure (in operation extension). The metrics (counters, duration, timestamp, threshold, flags...) are collected in specific functions in core server or plugins. Then printed in access logs. The metrics are intended to be used for analyzing performance of separated operation but are not intended to measure load performance.

Overview
--------

When applying a given workload on a Directory Server we can see the operation <i>response time</i> (<b>etime</b>) in the access log. If we want to know the layout of the response time (i.e. database or index access, evaluation of aci, filter evaluation/check, values matching...) we can use <b>debug logging</b> or <b>external tools (pstack, stap, strace...)</b>. The drawbacks of those approaches are that they interfere with the server (slowdown). Also analyzing the logs/traces is time consuming (all operations logs/traces are mixed) and finally requires a good knowledge of DS internals to do a diagnostic.

The purpose of this design is to present a mechanism to collect/report *per operation metrics* with minimal impact on the server. Because of the use of access logs that are buffered and written after the operation result is sent, the overall impact is low. If an operation has a large response time, many times it is due to very few expensive components. There is a hope that metrics from those expensive components will be significantly high to help diagnose without the need of good knowledge of DS internals.

The document also present an example of collect/report related to indexes used during searchs.

Use Cases
---------

When monitoring performance we can see logs like

    [16/Nov/2022:11:34:11.834135997 +0100] conn=1 op=73 SRCH base="dc=example,dc=com" scope=2 filter="(cn=user_*)" attrs=ALL
    [16/Nov/2022:11:34:11.843185322 +0100] conn=1 op=73 RESULT err=0 tag=101 nentries=24 wtime=0.000078414 optime=0.001614101 etime=0.001690742

This RFE will extend access logs with per operation statistics like

    [16/Nov/2022:11:34:11.834135997 +0100] conn=1 op=73 SRCH base="dc=example,dc=com" scope=2 filter="(cn=user_*)" attrs=ALL
    [16/Nov/2022:11:34:11.835750508 +0100] conn=1 op=73 STAT read index: attribute=objectclass key(eq)=referral --> count 0
    [16/Nov/2022:11:34:11.836648697 +0100] conn=1 op=73 STAT read index: attribute=cn key(sub)=er_ --> count 24
    [16/Nov/2022:11:34:11.837538489 +0100] conn=1 op=73 STAT read index: attribute=cn key(sub)=ser --> count 25
    [16/Nov/2022:11:34:11.838814948 +0100] conn=1 op=73 STAT read index: attribute=cn key(sub)=use --> count 25
    [16/Nov/2022:11:34:11.841241531 +0100] conn=1 op=73 STAT read index: attribute=cn key(sub)=^us --> count 24
    [16/Nov/2022:11:34:11.842230318 +0100] conn=1 op=73 STAT read index: duration 0.000010276
    [16/Nov/2022:11:34:11.843185322 +0100] conn=1 op=73 RESULT err=0 tag=101 nentries=24 wtime=0.000078414 optime=0.001614101 etime=0.001690742

For this operation we can see, for example, that the index lookups (db read) during filter evaluation were

   - (objectclass=referral)  -> 0 lookup (this value did not exist)
   - (cn=user_*) -> 24+25+25+24= 98 lookups

In such case 98 is not optimal but acceptable. For a long lasting operation, a value of let's say 100.000 lookup would have ring a bell as a possible responsible of the bad response time.

# Design
------

The document present a mechanism, base on object extension, to store/retrieve collected metrics.

The principle is to collect metrics, during the processing of an operation, and to log them along with the operation result. The collect of metrics is done during specific <b>probes</b> of the operation processing, so collect could impact operation performance and special care should be taken to limit collection cost. The logging of the operation result is done <b>after</b> the operation result is sent back (for direct operation) or stored in the pblock (internal operations). So the <b>logging has no performance impact</b> for the operation itself. For operations that trigger internal operations <b>collect and logging </b> is done for each internal operation but of course impact the overall duration of the parent operation. An example of is describe in that document with collect/log statistics during <b>indexes access during read</b>.

In order to limit the performance impact of the <b>probes/log</b>, we can select which probes to measure using a new configuration parameter <b>nsslapd-statlog-level</b>

## Mechanism store/retrieve statistics

During startup (main) <b>op_stat_init</b> is called to register (<i>slapi_register_object_extension</i>), an operation extension for module SLAPI_OP_STAT_MODULE ("Module to collect operation stat"). It registers constructor <b>op_stat_constructor</b> and desctructor <b>op_stat_destructor</b>. This extension is retrieved by <b>Op_stat *op_stat_get_operation_extension(Slapi_PBlock *pb)</b>

## Statistics collected/logged

### indexes read

It collects the metrics related to index database lookup. For a given database key it can exist several entries (duplicate). To grab all the duplicates it calls db->get for each of them.

For example 1M entries <i>uid</i> starts with <i>user_</i> and the filter component is <i>(uid=user_1*)</i>. It creates '^us', 'use', 'ser', 'er_' and 'r_i' keys. Each of the keys will trigger 1M db->get, so a total of 5M for that component. Knowing the number of lookup and the overall duration help to diagnose why such filter <i>(uid=user_1*)</i> is expensive.

To enable collection of index read statisitics, the admin should do

    dsconf instance config replace nsslapd-statlog-level=1  (LDAP_STAT_READ_INDEX=0x01 proto-slap.h)

In <i>filterindex.c:keys2idl</i> it collects for each key (e.g. 'use') the number of IDs. Each ID triggers a db->get lookup. Also it collect timestamps (start/end) of the lookups.

     struct component_keys_lookup
    {
         char *index_type;
         char *attribute_type;
         char *key;
         int id_lookup_cnt;
         struct component_keys_lookup *next;
    };
    typedef struct op_search_stat
    {
        struct component_keys_lookup *keys_lookup; /* list of all keys metrics */
        struct timespec keys_lookup_start; /* start of index lookup for a given filter component */
        struct timespec keys_lookup_end; /* end of index lookup for a given filter component */
    } Op_search_stat;

In <i>log.c:log_result</i> it calls <i>log_op_stat</i> to log the statistics. This is called for any type of operation. For searches, if nsslapd-statlog-level=LDAP_STAT_READ_INDEX, it logs the read indexes statistics. Note that <i>log_op_stat</i> is called before the RESULT is logged so that the statistics are logged between the SRCH and RESULT records.


## Configuration

To enable collection/log of per operation statistics, the admin should do

    dsconf instance config replace nsslapd-statlog-level=<level>

Currently supported level are

- LDAP_STAT_READ_INDEX=0x01




