---
title: "Update resolution for single valued attributes"
---

# Update resolution for single valued attributes
------------------------------------------------

{% include toc.md %}

Problem description
===================

In multisupplier replication updates can be applied to an entry on different suppliers concurrently ( at the same time) where concurrent means an update on one supplier is done before the update from an other supplier is received. Even conflicting or contradictory changes can happen These situations are handled by the update resolution protocol (URP). It tries to achieve two goals:

**GOAL 1: After the modifications are replicated the entries are consistent on all servers in the topology**
**GOAL 2: The final state is the same as if the modifications would have been applied on a single supplier in the order given by the CSNs associated with the modification.**

This cannot be achieved for single valued attributes (SVA) in all scenarios, even in very simple scenarios. Example1: an entry has no value of a SVA, concurrently on supplier1 a value V1 is added and on supplier2 a value of V2 is added. After replication of these two mods the entry would have two values for SVA. In the single supplier model the second modification would be rejected. Example2: modrdn

So there is a need for additional rules in URP for single valued attributes, the current design implements the following rules:

**RULE 1: the latest modification succeeds**
**RULE 2. modrdn has priority over other operations.**

In RULE 1 "latest" means the operation with the highest CSN, this could be different from the clients perception

The implementation of URP for single valued attributes is complex and there still are scenarios where the results are not correct and inconsistent states are encountered.

The intention of this document is to cover all potential update scenarios for single valued attributes, define the expected results and design a test suite to verify URP for single valued attributes. If possible the implementation should be simplified.

Attribute states
================

For single valued attributes there are only three states

Attribute with no value: S0
---------------------------

The SVA does not exist

Attribute with one value: S1
----------------------------

The SVA does exist and has one value

Attribute with one distinguished value: S2
------------------------------------------

The attribute exists, has one value and the attribute is part of the RDN of the entry. Pending values ????

State changes and allowed operations
====================================

For each state we determine which potential operations are allowed an what is the resulting state

S0 --\> S0
----------

### Empty replace (op0)

    Changetype: modify
    replace: SVA
    -

S0 --\> S1
----------

### Add value (op1)

    Changetype: modify    
    add: SVA    
    SVA: value    
    -    

### Replace value (op2)

    changetype: modify    
    replace: SVA    
    SVA: value    
    -    

S0 --\> S2
----------

### Modrdn, keepoldrdn(op3)

    Changetype: modrdn    
    newrdn: SVA=value    
    deleteoldrdn: 0    
    -    

Note: for SVA deleteoldrdn: 1 makes no difference, but the current RDN could be a required attribute.

3.4. S1 --\> S0
---------------

### Empty replace ( see op0)

### Delete Attribute ( op4)

    Changetype: modify    
    delete: SVA    
    -    

### Delete Value (op5)

    Changetype: modify    
    delete: SVA    
    SVA: value    
    -    

S1 --\> S1
----------

### Replace value (see op 2)

### Delete Attribute, add value (op6)

    Changetype: modify    
    delete: SVA    
    -    
    add: SVA    
    SVA: newvalue    

### Delete Value, add value (op7)

    Changetype: modify    
    delete: SVA    
    SVA: oldvalue    
    -    
    add: SVA    
    SVA: newvalue    

### Empty replace, add value

    changetype: modify    
    replace: SVA    
    -    
    add: SVA    
    SVA: newvalue    
    -    

S1 --\> S2
----------

### Modrdn, keepoldrdn (see op3)

       Existing value gets distinguished. This is the same ldap operation as op3, but the value to be made distinguished has to be the existing value    

### Modrdn, deleteoldrdn (op9)

    Changetype: modrdn    
    newrdn: SVA=newvalue    
    deleteoldrdn: 1    
    -    

S2 --\> S0
----------

### Modrdn, newattr, deleteoldrdn (op 10)

    changetype: modrdn    
    newrdn: otherattr=somevalue    
    deleteoldrdn: 1    
    -    

S2 --\> S1
----------

### Modrdn, newattr, keepoldrdn (op 11)

    Changetype: modrdn    
    newrdn: otherattr=somevalue    
    deleteoldrdn: 0    
    -    

S2 --\> S2
----------

### Modrdn, deleteoldrdn (see op9)

Pathological operations
=======================

The basic operations for state changes are simple and limited, but the schema check is performed only after all sub-operations of a modify request have been applied and all kind of intermediate states can exist. Example: Assume attribute is in state S0

    changetype: modify    
    add: SVA    
    SVA: value    
    SVA: value2    
    -    
    delete: SVA    
    SVA: value1    
    -    
    add: SVA    
    SVA: value3    
    -    
    delete: SVA    
    SVA: value2    
    -    

Finally the attribute has only one value: value3, but in the intermediate states it has two values. The variety of these operations is unlimited and a hopefully sufficient set of pathological operations has to be designed for testing. The problem with these type of operations is not in concurrency, they always will finally result in basic state change, but it has to be verified that the final state of the attribute is consistent on all servers in the topology

p1
--

to be defined

p2
--

to be completed

Pending values
==============

The basic rules say that modrdn has precedence over modify operations and that the latest change should win. So there is a specific scenario when an attribute is no longer distinguished and a modification was rejected at the time it was distinguished.

    Example: Attribute is in state S0    
    On supplier1 there is a state change (t0, S0->S2, v0)    
    On supplier2 there is a state change (t1, S0->S1, v1)    
    t0,t1 concurrent, t1>t0, after replication attribute is in state S2 with value v0    
    On supplier1 there is a state change (t2, S2->S1), this would result in v0, but v1 was applied later and v0 is no longer distinguished, so v1 could become the current value.    

To handle scenarios like this the attribute keeps a value which should be applied because of Rule1, but cannot because of Rule2 as a pending value. Note: It is sufficient to identify the scenarios in the concurrent state changes which could and should lead to pending values and extend the scenarios to make the attribute undistinguished

Question: Shouldn't there be pending deletes ? If an attribute cannot be deleted because it is distinguished, that could be done as soon as it is no longer distinguished.

DISCUSSION TOPIC: Do we need to handle pending values at all ? Assume a mod of a value to v2 and a modrdn with the present value v1 with a csn(v1) \< csn(v2), the modrdn has priority and the value remains v1. Now two weeks later there is another modrdn, making an other attribute distinguished and suddenly the value changes to v2, it could be a surprise.

Concurrent state changes
========================

There are many operations which lead to state changes in a SVA, they can be applied in any combination and order and on a wide range of suppliers.

To determine the correct behaviour all combinations in a two supplier topology are considered. If more suppliers are involved the variety increases, but in URP there will always be only the resolution of a current state with a state change received via replication.

So systematically all combinations involving two suppliers are investigated, for the test setup an extended topology with three suppliers and one consumer is used to verify consistency and expected states and values

Two supplier topology
-------------------

The following table lists all the combinations of state changes in two supplier topology, each state change has to be executed with the potential operations to achieve this state change. It is assumed that the CSN of the state change on supplier 1 is always lower than that on supplier 2. This is also the reason that the table contains the full combinations since (--\>S0,--\>S1) and (--\>S1,--\>S0) are not symmetric.

### Attribute state: S0

|Supplier 1|Supplier2|Resulting state|Resulting value|Pending value|
|--------|-------|---------------|---------------|-------------|
|--\> S0|--\> S0|S0|-|-|
|--\> S0|--\> S1(v1)|S1|v1|-|
|--\> S0|--\> S2(v2)|S2|v2|-|
|--\> S1(v1)|--\> S0|S0|-|-|
|--\> S1(v1)|--\> S1(v2)|S1|v2|-|
|--\> S1(v1)|--\> S2(v2)|S2|v2|-|
|--\> S2(v1)|--\> S0|S2|v1|Why not pending delete ??|
|--\> S2(v1)|--\> S1(v2)|S2|v1|v2 gets pending|
|--\> S2(v1)|--\> S2(v2)|S2|v2|-|

### Attribute state: S1

The operations to create the state changes are different, but results should be as in table for S0

### Attribute state: S2

The operations to create the state changes are different, but results should be as in table for S0

Three supplier topology
---------------------

Although with more than two suppliers the update resolution procedure should sequentially applied and result in the same state resolution existing bugs show that this is not the case with the current implementation. This chapter will handle all scenarios with 3 suppliers, this also allows all three different state changes applied in parallel. An extension to more than three supplier should not be necessary. In the tests a consumer should be added to the topology, it serves as a reference where the modifications are applied in the csn order.

|Test|Supplier 1|Supplier2|Supplier3|Resulting state|Resulting value|Pending value|
|----|--------|-------|-------|---------------|---------------|-------------|
|1|--\> S0|--\> S0|--\> S0|S0|-|-|
|2|--\> S0|--\> S0|--\> S1(v3)|S1|v3|-|
|3|--\> S0|--\> S0|--\> S2(v3)|S2|v3|-|
|4|--\> S0|--\> S1(v2)|--\> S0|S0|-|-|
|5|--\> S0|--\> S1(v2)|--\> S1(v3)|S1|v3|-|
|6|--\> S0|--\> S1(v2)|--\> S2(v3)|S2|v3|-|
|7|--\> S0|--\> S2(v2)|--\> S0|S2|v2|Pend. delete?|
|8|--\> S0|--\> S2(v2)|--\> S1(v3)|S2|v2|v3|
|9|--\> S0|--\> S2(v2)|--\> S2(v3)|S2|v3|-|

|Test|Supplier 1|Supplier2|Supplier3|Resulting state|Resulting value|Pending value|
|----|--------|-------|-------|---------------|---------------|-------------|
|10|--\> S1(v1)|--\> S0|--\> S0|S0|-|-|
|11|--\> S1(v1)|--\> S0|--\> S1(v3)|S1|v3|-|
|12|--\> S1(v1)|--\> S0|--\> S2(v3)|S2|v3|-|
|13|--\> S1(v1)|--\> S1(v2)|--\> S0|S0|-|-|
|14|--\> S1(v1)|--\> S1(v2)|--\> S1(v3)|S1|v3|-|
|15|--\> S1(v1)|--\> S1(v2)|--\> S2(v3)|S2|v3|-|
|16|--\> S1(v1)|--\> S2(v2)|--\> S0|S0|v2|Pend. Delete?|
|17|--\> S1(v1)|--\> S2(v2)|--\> S1(v3)|S0|v2|v3|
|18|--\> S1(v1)|--\> S2(v2)|--\> S2(v3)|S0|v3|-|

|Test|Supplier 1|Supplier2|Supplier3|Resulting state|Resulting value|Pending value|
|----|--------|-------|-------|---------------|---------------|-------------|
|19|--\> S2(v1)|--\> S0|--\> S0|S2|v1|Pend. Delete?|
|20|--\> S2(v1)|--\> S0|--\> S1(v3)|S2|v1|v3|
|21|--\> S2(v1)|--\> S0|--\> S2(v3)|S2|v3|-|
|22|--\> S2(v1)|--\> S1(v2)|--\> S0|S2|v1|V2 or delete?|
|23|--\> S2(v1)|--\> S1(v2)|--\> S1(v3)|S2|v1|v3|
|24|--\> S2(v1)|--\> S1(v2)|--\> S2(v3)|S2|v3|-|
|25|--\> S2(v1)|--\> S2(v2)|--\> S0|S2|v2|Pend delete?|
|26|--\> S2(v1)|--\> S2(v2)|--\> S1(v3)|S2|v2|v3|
|27|--\> S2(v1)|--\> S2(v2)|--\> S2(v3)|S2|v3|-|

Test setup
==========

Concurrent state changes
------------------------

Usually replication is very fast and performing updates concurrently on different Suppliers before the changes are replicated cannot be guaranteed. So common test setup is:

    Check consistency of entry on all servers in the topology    
    Pause replication between suppliers    
    Apply changes to different servers    
    Re-enable replication    
    Wait for replication convergence    
    Check consistency and expected results    

Test topology
-------------

To perform the tests out lined above, a topology of three suppliers and on consumer is used. This allows to apply all the independent state changes and if replication to consumers is not disabled the consumer will perform update resolution exactly for changes applied exactly in csn order

Basic tests
-----------

Pathological tests
------------------

Two supplier tests
----------------

Three supplier tests
------------------

Redesign of update resolution for single valued attributes
==========================================================

