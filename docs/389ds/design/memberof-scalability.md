---
title: "MemberOf Scalability"
---

# MemberOf Scalability
-----------------------------------------

{% include toc.md %}

Overview
========

MemberOf plugin manages the values of LDAP attribute **memberOf**. When updating a group, it does two actions:
1. Lookup **down** in the groups tree to determine the list of entries (leaf or groups) impacted by the operation
2. For each impacted entry, lookups **up** in the groups tree to determine which groups the entry belongs to, and finally update the entry (**fixup**)
Those two actions are necessary but can be very expensive in terms of:
* response time of each single operation
* scalability as during those operations others write operations are on hold (memberof is a betxn)
* cpu consumption
* significant replacement of entries being cached in the entry cache
This document presents some possible improvements.

Use Case
========

An administrator needs to provision many users within a fixed period (typically over a week end). He can use CLI or batch commands or even importing entries from a ldif file. The rate of the provisioning is critical to be sure to complete the task in an acceptable period.



Design
======

Why is it expensive
-------------------
Tests done with [Nested groups provisioning](http://www.freeipa.org/page/V4/Performance_Improvements#Memberof_plugin). It was seen that **by far the main contributor** was the [Number of internal searches](http://www.freeipa.org/page/V4/Performance_Improvements#Small_DB_.2810K_entries.29).

The initial thought that the update of the entry (fixup) was the main responsible of preformance hit, **was a wrong idea*. In fact disabling retroCL has no significant impact on provisioning duration, so **write IO is not the main contributor**.
----
Nested (an entry can be fixup several times)
multiple membership attributes
group size

It is preferred to keep the plug-in configuration backwards compatible to prevent breaking existing deployments during upgrade. This is easily done by simply allowing the **memberOfGroupAttr** attribute to have multiple values. Here is an example:

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    memberofgroupattr: member
    memberofgroupattr: uniqueMember
    memberofattr: memberOf

It is important to note that an attribute used as a **memberOfGroupAttr** must be defined with either the **Distinguished Name** or **Name and Optional UID** syntaxes. An attempt to use an attribute defined with any other syntax will be rejected.

