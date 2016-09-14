---
title: "MemberOf Scalability"
---

# MemberOf Scalability
-----------------------------------------

{% include toc.md %}

## Overview

Membership attributes creates a directed graph that can contains cycles. Having cycles in membership makes almost no sense and add complexity. This is the reason why memberof plugin assums that the directed graph is actually an **acyclic tree** and enforce during evaluation of the tree that there is no cycle.

The nodes of the tree are directed by membership attributes (member, uniquemember, memberuser...). MemberOf plugin manages the values of LDAP attribute **memberOf** into the tree. This attribute creates an other tree with direct edges from a node to all the nodes it is member of. 

![acyclic tree](../../../images/memberof_acyclic_tree.png "acyclic tree")

The nodes linked to other node(s) (with blue arrow) are called **groups or intermediate nodes** (e.g. node_0_1, node_1_1, node_2_2). The nodes linked to no other node (with blue arrow) are called **leafs**.

When updating a group, MemberOf plugin needs to update the *memberof* attribute of several nodes. To do so, it does two actions:

-   Lookup **down** in membership tree to determine the list of entries (leafs or intermediate nodes) impacted by the operation
-   For each impacted entry (nodes or leafs), lookups **up** in the tree to determine which groups the entry belongs to, and eventually update the entry (**fixup**)

Those two actions are necessary but can be expensive in terms of:

-   response time of each single operation
-   scalability as during those operations others write operations are on hold (memberof is a betxn)
-   cpu consumption
-   significant replacement of entries being cached in the entry cache

This document presents some possible improvements.

## Use Case

An administrator needs to provision many entries (leafs or groups) within a fixed period of time(typically over a week end). He can use CLI or batch commands or even importing entries from a ldif file. The rate of the provisioning is critical to be sure to complete the task in an acceptable delay.



## Design

### Simplifications

The graph of membership can be very complex. For simplification, this document will evaluate the impact of membership update on limited types of trees with same leaf depth:

- **Type 1** <a name="Type 1"></a>: Tree with one uniq path root to each leaf

![Membership tree](../../../images/memberof_image1.png "uniq path to leaf")

- **Type 2** <a name="Type 2"></a>Tree with multiple paths root to some of the leafs

![Membership tree](../../../images/memberof_type_multiple_path_to_leaf.png "multiple paths to leaf")

- **Type 3** <a name="Type 3"></a>Tree with multiple paths to intermediate nodes

![Membership tree](../../../images/memberof_type_multiple_path_to_node.png "multiple paths to nodes")

### Cost of memberof update

Tests done with [Nested groups provisioning](http://www.freeipa.org/page/V4/Performance_Improvements#Memberof_plugin) shown that **by far the main contributor** was the [Number](http://www.freeipa.org/page/V4/Performance_Improvements#Small_DB_.2810K_entries.29) of internal searches.

The initial thought that the update of the entry (fixup) was the main responsible of preformance hit, **was not completely right**. Update of the member entry (to update ***memberof***) has IO cost but IO is not that main contributor. For example, in the same test case, disabling retroCL, that divides IO by factor 2 had no significant impact on provisioning duration.

So in the rest of the document the **cost** will be expressed in terms of **internal searches**.

![Membership tree](../../../images/memberof_image1.png "Cost of a node update")

The figure above shows a membership tree. At the bottom of the tree **leafs** are typically **users**. Those users are directly member of a *leaf groups* of **Depth 3** (i.e. *Grp3_A*), for example *Grp 3_A* is *'Devel Kernel Group'*. Then this group is member of **Depth 2** group (i.e. *Grp 2_A*) like *'Framework Devel Group'*. This group is member of **Depth 1** group (i.e. *Grp 1_A*) like *'Engineering'*. 

- Let the tree composed of **nodes**. 
- The **parents** of a node are the nodes with a membership link to the node. 
- The set of nodes that are **parents** are called **groups or intermediate nodes**
- A **leaf** is a node that is not a parent
- Let **D** the depth of a given node in the membership tree
- Let **P_down(x)** the number of paths from root to nodes at the depth x (i.e. **paths with length = x**)
- Let **L** the maximum lenght of all paths from root to nodes and leafs (i.e. Max Depth + 1)
- Let **plg** is the number of plugins that triggers one internal search when a entry is updated (e.g. mep). It is >= 1.

#### Look down the impacted members

When a group is updated, the txn postop callback searches for all entries being direct and indirect members of that group. This is done by a **single** internal search of each node (leaf or intermediate node) **each** time the entry is found in the membership tree. The purpose of this look down is to build a list of impacted members that later will be fixup.

    SRCH base="<node_dn>" scope=0 filter="(|(objectclass=*)(objectclass=ldapsubentry))" attrs="attr_1 ... attr_N"
    attr_1,...,attr_N: are membership attributes (defined in "cn=MemberOf Plugin,cn=plugins,cn=config")

This internal base search is very rapid at the condition *node_dn* **remains in the entry cache**.

The cost of the look down is C = sum from l=1 to l=L of P_down(l). For example with *leaf groups* (node of Depth 3) having **100** leafs:

- tree [type 1](#Type 1): **608** - 600 paths root to each leafs + 8 paths root to intermediate nodes
- tree [type 2](#Type 2): **608** - 600 paths root to each leafs + 8 paths root to intermediate nodes
- tree [type 3](#Type 3): **709** - the 101 additional paths are due to Grp_3_C (and its leafs) that is found twice

The lookup is quite efficient (it retrieves/process all the membership attributes in a single search) but it can be improved:

An entry (node or leaf) may appears several times in the tree (and triggers several int_search). The possibilities for finding entries several times are:

- several paths conduct to the same entry (node or leaf)
- being listed in several membership attribute

The ticket [48861](https://fedorahosted.org/389/ticket/48861) was opened for this improvement. It should make sure that an entry is **search once** during *Look down* (preferably) or **Fixed once** during *Look up*. This improvement has no impact if entries appears only once in the tree.

The expected cost of look down with a fix for [48861](https://fedorahosted.org/389/ticket/48861), for example with *leaf groups* (node of Depth 3) having **100** leafs

- tree [type 1](#Type 1): **C = 608**: all the paths root to nodes/leafs are uniq
- tree [type 2](#Type 2): **C - 2 = 606**: there are two paths root to LeafN and root to LeafM
- tree [type 3](#Type 3): **C - 101 = 608**: there are two paths root to Grp_3_C and root to Grp_3_C s leafs

#### Look up group membership of impacted members

When a group is updated, for each **impacted members** it computes all the groups containing (direct or indirect) the impacted members. So for each given impacted member (leafs and intermediate nodes) it does an internal search for each node from the impacted member up to the root.

    SRCH base="<suffix>" scope=2 filter="(|(attr_1=<node_dn>)..(attr_N=<node_dn))" attrs=ALL
    attr_1,...,attr_N: are membership attributes (defined in "cn=MemberOf Plugin,cn=plugins,cn=config")
    They are supposed to be indexed in equality

If this search is indexed and fast but item that can influence the cost are

- the more there are membership attributes the more expensive it is
- the search will retrieves *groups* that are possibly big entries. It is more expensive if the *groups* are not in the **entry cache**


It is quite difficult to express in mathematical way the cost of the look down. Here is an attempt to describe it:
Having a *list of impacted nodes* (possibly containing *duplicates*), for each of them it goes thru **all** paths from this node back to the root. Starting from a given node, the lenght of the paths can be different although they end to the root. It triggers an internal search for each nodes on each paths. So the cost (for a given node) is the sum of the number of nodes on all paths from *given node to root*. A mechanism to detect cycle can reduce the cost so that common parts of the paths are accounted once. Finally, there are **plg** internal searches per fixup node. 
For example with *leaf groups* (node of Depth 3) having **100** leafs:


- tree [type 1](#Type 1):  **3030** internal searches
- tree [type 2](#Type 2): **3036** internal searches
- tree [type 3](#Type 3): **3736** internal searches


Making sure that the *list of impacted nodes* does not contain duplicate ([48861](https://fedorahosted.org/389/ticket/48861)) has a significant impact during *look up*. In [type 3 tree](#Type 3), each member of Grp_3_C have 2 paths back to root so the look up cost of each of them will be divided by 2. **The more paths it exists to a node, the more expensive is the node**.

### Improvements

#### Prevent duplicate 48861

When updating membership attributes of a group, a direct or indirect impacted member of that group can be found several times. The ticket [48861](https://fedorahosted.org/389/ticket/48861) will prevent that an impacted member is listed/fixed several times. A first [patch](https://fedorahosted.org/389/attachment/ticket/48861/0001-Ticket-48861-Memberof-plugins-can-update-several-tim.patch), caching in an hash table the already fixed nodes, divides by **2** the duration of provisioning of a tree. The tree being creates with [create_test_data.py](https://github.com/freeipa/freeipa-tools/blob/master/create-test-data.py)


#### caching of groups 48856

The vast majority of the [Look up](#Look up group membership of impacted members) internal searches is to retrieve the *parent groups of a given node*.

    SRCH base="<suffix>" scope=2 filter="(|(attr_1=<node_dn>)..(attr_N=<node_dn>))" attrs=ALL
    attr_1,...,attr_N: are membership attributes (defined in "cn=MemberOf Plugin,cn=plugins,cn=config")

But looking at internal searches filters we can see an increasing number of them as the * <node_dn> * moves toward the root. It also fluctuates  highly as soon as there are nested groups and nodes/leafs belong to several groups. 

In the three following figures, the number in red (close to * <node_dn> *) is the number of this type of searche:

    SRCH base="<suffix>" scope=2 filter="(|(attr_1=<node_dn>)..(attr_N=<node_dn))" attrs=ALL

Type 1 

![Membership tree](../../../images/memberof_type_1_cost_of_groups.png "Type 1: Cost of groups")

Type 2 

![Membership tree](../../../images/memberof_type_2_cost_of_groups.png "Type 2: Cost of groups")

Type 3

![Membership tree](../../../images/memberof_type_3_cost_of_groups.png "Type 3: Cost of groups")


In conclusion:

- The number of searches with *filter="(\|(attr_1=leaf_n)(attr_N=leaf_n))"* remains low (1 or 2) in all types of trees 
- The number of searches with *filter="(\|(attr_1=group_n)(attr_N=group_n))"* is very high compare to the leaf
- The number of searches with *filter="(\|(attr_1=group_n)(attr_N=group_n))"* increases rapidly if members (direct and indirect) belong to several groups
- The number of searches with *filter="(\|(attr_1=group_n)(attr_N=group_n))"* increases as moving up in the three

The search *filter="(\|(attr_1=group_n)(attr_N=group_n))"* builds the *memberof* values of groups that *group_n* is a direct member: Let named them **parent groups** and *group_n* being the **child group**.  If we can retrieve those **parent groups** with only 1 internal search per child group it will reduce the cost of * look up * by **80% up to 85%**

- Type 1: From ~3000 to ~600 internal searches
- Type 2: From ~3000 to ~600 internal searches
- Type 3: From ~3700 to ~600 internal searches


The proposal for the ticket [48856](https://fedorahosted.org/389/ticket/48856) is to create a **parent groups** cache. *memberof_call_foreach_dn* builds a filter that will be the key to look up the cache. 

If the filter does not exist in the cache, it triggers an internal search with the *filter* (callback_data) and a callback function that will store the **parent groups** DNs into the cache using *filter* as key.

Then it lookup the **parent groups** from the cache. For each of them it calls  *memberof_get_groups_callback* (taking DN instead of slapi_entry as argument).



#### keeping groups in the entry cache

During internal searches, the candidates entries are retrieved from the entry cache and possibly reloaded from Database in case of cache miss. The lookup of [parent groups](#caching of groups) requires to find/reload many groups into the entry cache. A typical group is a large entry with quite few attributes having a large set of values. Loading those entries is expensive (read of several overflow pages, allocation/sort of many member values).

When an entry gets to the lru it can get out of the entry cache. It would be benefical to delay a bit a group to get out of the entry cache. For example, we can imagine a counter on each entry in the lru. If the next entry to free, from the lru, is a group then increment the counter and move the entry to the begining of the lru. When the counter reaches a limit (e.g. 3) then the group is freed. When an entry goes entry_cache->lru, the counter is reset.

## Implementation

None

## Major Configuration options

# Replication

The proposed changes have no impact in the way replication is managing *memberof* updates. Each update of *memberof* attribute, will go into the changelog. Replication agreement will replicate those updates unless they are skipped.

## updates and Upgrades

None

## Dependencies

None
