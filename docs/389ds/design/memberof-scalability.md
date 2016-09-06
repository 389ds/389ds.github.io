---
title: "MemberOf Scalability"
---

# MemberOf Scalability
-----------------------------------------

{% include toc.md %}

## Overview

MemberOf plugin manages the values of LDAP attribute **memberOf**. When updating a group, it does two actions:
*   Lookup **down** in the groups tree to determine the list of entries (leaf or groups) impacted by the operation
*   For each impacted entry, lookups **up** in the groups tree to determine which groups the entry belongs to, and finally update the entry (**fixup**)

Those two actions are necessary but can be very expensive in terms of:
-   response time of each single operation
-   scalability as during those operations others write operations are on hold (memberof is a betxn)
-   cpu consumption
-   significant replacement of entries being cached in the entry cache

This document presents some possible improvements.

## Use Case

An administrator needs to provision many entries (leaf or groups) within a fixed period (typically over a week end). He can use CLI or batch commands or even importing entries from a ldif file. The rate of the provisioning is critical to be sure to complete the task in an acceptable period.



## Design

### Cost of memberof update

Tests done with [Nested groups provisioning](http://www.freeipa.org/page/V4/Performance_Improvements#Memberof_plugin) shown that **by far the main contributor** was the [Number](http://www.freeipa.org/page/V4/Performance_Improvements#Small_DB_.2810K_entries.29) of internal searches.

The initial thought that the update of the entry (fixup) was the main responsible of preformance hit, **was not completely right**. Update of the member entry (to update ***memberof***) has IO cost but IO is not the main contributor (disabling retroCL has no significant impact on provisioning duration).

Number of membership attribute has no impact.

![Membership tree](../../../images/memberof_image1.png "Cost of a node update")
The formula to compute the number of internal searches is
 N: Number of members to update (nested or not)
    In a ADD/DEL/MOD_REPL N = all members in the operation are updated
    In a MOD_ADD/MOD_DEL N = members added/removed are updated
 G: Number of groups that a given member is member of (groups being nested or not)
 P: Number of plugins that lookup each members
    (for example *mep* plugin lookup the member during the update)
 
 Total_internal_search = N * (G + P + 1)
 
 for example with groups of **1000** members and each member being member of **5** groups. Assuming P=3 (memberof, mep,...), (G + P + 1) = 9:
  - adding a group => 9000 internal_searches
  - add/del 10 members to a group => 90 internal searches

What increase the number of internal searches

-   Fixup several times the same entry [48861](https://fedorahosted.org/389/ticket/48861)
   - With **nested groups**, a same entry can be found serveral times as impacted
   - If an entry member of a group
-   If an entry is present only once in a single group (for a given membership attribute)When building the list of impacted entries, **Nested groups** means that (an entry can be fixup several times)
-   multiple membership attributes
   -   The task to 
   -   If an entry is present

- keep group in cache
group size

It is preferred to keep the plug-in configuration backwards compatible to prevent breaking existing deployments during upgrade. This is easily done by simply allowing the **memberOfGroupAttr** attribute to have multiple values. Here is an example:

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    memberofgroupattr: member
    memberofgroupattr: uniqueMember
    memberofattr: memberOf

It is important to note that an attribute used as a **memberOfGroupAttr** must be defined with either the **Distinguished Name** or **Name and Optional UID** syntaxes. An attempt to use an attribute defined with any other syntax will be rejected.

