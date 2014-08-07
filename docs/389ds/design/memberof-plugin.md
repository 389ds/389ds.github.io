---
title: "MemberOf Plugin"
---

# MemberOf Plugin Design
------------------------

{% include toc.md %}

Overview
--------

The memberOf LDAP attribute is an attribute used for grouping of user entries. Typically, when you add a user as a member of a group, you add a "member" attribute that contains the DN of the user to a "groupOfUniqueNames" group entry. This approach makes it easy to get a list of all users who belong to a specific group by searching against the specific group you are interested in for all "member" attributes. If you are interested in knowing all groups that a specific user is a member of, things get more complex on the client side. To eliminate this complexity being pushed onto the client application, the "memberOf" attribute can be used. In addition to adding a "member" attribute to a group entry, you would add a "memberOf" attribute to the user entry that point to the group. This allows you to do a simple search against a specific user entry to find all groups that the user is a member of.

If the "memberOf" and "member" attributes are both being used, you run the risk of having errors in consistency. These inconsistency issues can arise in the case where either the group or user entry is modified, but the other side is not. This would result in different membership results when you check via the group entry versus checking the user entry. To avoid these inconsistency issues, the "memberOf" attribute should be automatically managed by the Directory Server when a change is made to a group entry that affects membership.

Architecture
============

This feature will be implemented as a SLAPI plug-in that can be optionally enabled. A SLAPI plug-in implementing automatically maintained "memberOf" attribute functionality has been written as part of the [FreeIPA](http://www.freeipa.org) project. This plug-in can be used as a starting point, but development work will still be needed.

FreeIPA Plug-in Architecture
----------------------------

The FreeIPA memberOf SLAPI plug-in is currently implemented as a post-operation plug-in. The plug-in takes action when a change is made that affects group membership. The plug-in will then update the "memberOf" attribute where necessary, which is stored just like any other attribute in the database.

### Callbacks

The plug-in's initialization function (ipamo\_postop\_init) registers the following plug-in callbacks with Directory Server:

    static int ipamo_postop_del(Slapi_PBlock *pb );    
    static int ipamo_postop_modrdn(Slapi_PBlock *pb );    
    static int ipamo_postop_modify(Slapi_PBlock *pb );    
    static int ipamo_postop_add(Slapi_PBlock *pb );    
    static int ipamo_postop_start(Slapi_PBlock *pb);    
    static int ipamo_postop_close(Slapi_PBlock *pb);    

The first four callbacks deal with the core of this feature; that is they appropriately update the "memberOf" attribute for incoming DEL, MODRDN, MOD, and ADD LDAP operations. The ipamo\_postop\_start and ipamo\_postop\_close functions deal with startup and cleanup of the plug-in. An important thing to note about the ipamo\_postop\_start function is that it registers a task handler callback via the (not entirely exposed) SLAPI task interface. This task handler callback is:

    int ipamo_task_add(Slapi_PBlock *pb, Slapi_Entry *e,    
                       Slapi_Entry *eAfter, int *returncode, char *returntext,    
                       void *arg)    

This task handler allows an LDAP task entry to be added to the Directory Server to check for a grouping inconsistency and fix it. If everything is working correctly in the plug-in, there would never be a consistency issue to resolve. This task would still be useful if someone directly modified a "memberOf" attribute instead of allowing the plug-in to maintain it, which could cause an inconsistency problem. It would also be useful if you already have an existing database that is not using "memberOf" yet, but you want to populate the "memberOf" attribute.

### Handling of LDAP Operations

The basic operation of the plug-in is as follows:

1.  An operation comes in that affects a "member" attribute for a particular group.
2.  We locate a "member" entry that is being somehow modified.
3.  If the "member" is a group, we recurse into that group to locate it's members.
4.  When we encounter a user entry, we update their "memberOf" attribute appropriately.
5.  We continue the above three steps until all members are processed.

The below four sections will describe how the memberOf plug-in deals with specific incoming operations.

#### ADD

1.  Plug-in checks if the incoming add is adding a new group. It determines this by testing a filter of "(member=\*)" against the entry to be added. If we're not interested, we just let the operation continue being processed by the server as normal.
2.  Acquire memberOf lock.
3.  Go through each "member" attribute value from the new group, performing the following steps for each:
    1.  If this "member" is a nested group, recurse into that group and process it's members one at a time just as in this subsection.
    2.  Add new group's DN to the "memberOf" attribute of this "member" entry.
    3.  Go through each group that has the new group as a "member", performing the same steps as in this subsection, but adding this parent group DN as a "memberOf" to this "member" entry. This will result in all parent groups (including grandparents, etc.)being added to this "member" entry.

4.  Release memberOf lock.
5.  We let the operation continue being processed by the server as normal.

#### DEL

1.  Get a copy of the entry before it was deleted.
2.  Acquire memberOf lock.
3.  Look for any entries that have the entry being deleted as a "member" and remove that "member" value.
4.  Check if the we're deleting a group entry, and if so perform the following for each "member" of the group being deleted:
    1.  If this "member" is a nested group, recurse into that group and process it's members one at a time just as in this subsection.
    2.  If we've traced into a nested group, verify that the "member" is not a "member" through some other indirect grouping path.
    3.  Delete the "memberOf" value for the group from this "member".
    4.  Check if a group has been orphaned (need to research this).

5.  Release memberOf lock.
6.  We let the operation continue being processed by the server as normal.

#### MOD

#### MODRDN

### Fix-Up Task

The plugin provides a SLAPI task that may be started by administrative clients and that creates the initial memberOf list for imported entries and/or fixes the memberOf list of existing entries that have inconsistent state (for example, if the memberOf attribute was incorrectly edited directly).

To start the memberof task add an entry like:

    dn: cn=memberof task 2, cn=memberof task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: sample task
    basedn: dc=example, dc=com
    filter: (uid=test4)

The "basedn" attribute is required and refers to the top most node to perform the task on, and where "filter" is an optional attribute that provides a filter describing the entries to be worked on.

### Issues

-   Membership attribute is currently hard-coded to be "member".
-   Needs to be refactored to remove "ipa" from callbacks, defines, etc.
-   Uses task interface that is not currently exported via SLAPI.
-   Allows circular groupings, and doesn't deal with them properly.
-   The "memberOf" attribute can still be manually manipulated.
-   Uses static groups, so unsure of performance impact with large groups.
-   Adds performance hit for writes that affect membership.
-   Only works with groups/members in the same back-end (could run into consistency issues if a back-end was offline, etc.).
-   Written such that "memberOf" should be excluded from being replicated, which puts MMR out of the picture since fractional replication isn't supported between two masters.

Proposed Architecture
---------------------

The current architecture is pretty sound overall. As with any feature, there are trade-offs to be made with different approaches. The items below are some things that we could change with the architecture, but we need to determine if the trade-offs are acceptable.

-   The current architecture implements "memberOf" as a normal attribute that is stored in the database. This will result in good performance when performing searches to determine membership, but will have a performance impact when changes are performed that alter group membership. Using a virtual attribute computed on the fly would improve performance for changes affecting group membership, but have a negative impact on searches that check membership. This negative performance impact could be reduced by somehow indexing or caching the virtual "memberOf" attribute values, but this added complexity may not be worth the effort. It's also not determined if the performance impact of the current architecture is unacceptable.

-   It would be nice to not allow circular groupings to be added in the first place since I don't think there is ever a valid reason to have them. We could check if a modification creates a circular grouping at the pre-operation stage and reject it with DSA\_UNWILLING\_TO\_PERFORM. There are a few problems with doing this though. The first one is that it will impact performance to do this check, especially with complex grouping cases. The other problem is that there is a windows between the preop and postop stage where another modification can come in that would create a circular grouping, but it would be too late to reject it since we've already passed the preop stage for both operations. Multi-master replication would also have the potential of two changes on different masters creating a circular grouping when combined, which could cause replication to stop if we reject the replicated operation. For these reasons, I'm suggesting that we don't perform this preop check and just allow the circular grouping to be created. There's no real harm in this as long as the plug-in detects the recursion and doesn't try to process it endlessly.

-   The attribute used for group members should be configurable. We should default to "member", but allow a different attribute to be used instead if it is configured. The plug-in will expect this attribute to contain the DN of the member, not some other value such as their "uid". This means the plug-in would work fine for attributes such as "uniqueMember", but not for "memberUID".

-   We really should make this work with MMR. This means we either have to replicate the "memberOf" attribute, or figure out a way to exclude it from being replicated when using MMR (**note by <User:Olo>: How is it done in the [Roles](Architecture#Roles "wikilink") plugin? I didn't try it, but the documentation doesn't state that filtered roles don't work with MMR. It seems that this problem has been solved over there.**). This may require modifying fractional replication to be supported between masters. At first thought, there should be no problem doing this if the attributes replicated between all masters are the same. The approach of replicating the "memberOf" attribute might be feasible too, but it requires more thought before making a decision as there may be conflicts generated. Another possible approach would be to add a preop stage to the memberOf plug-in that pulls out any replicated modifications to the "memberOf" attribute and drops them. This approach assumes that we can be guaranteed that the memberOf plug-in is processing the operation before the replication plug-in.

-   A script should be added that performs the fix-up task creation for you. This simply needs to be a perl script that invokes the proper ldapmodify command as we do for other tasks. It may be nice to have an option to check the status of a running fix-up task in this script.

Usage
=====

Configuration
=============

To Do
=====

-   Refactor plug-in code from FreeIPA. [**done**]
-   Add refactored code to CVS and update makefiles to build as part of Directory Server. [**done**]
-   Use new SLAPI task API. See the [SLAPI Task Design Doc](slapi-task-api.html).
-   Handle circular groupings. [**done**]
-   Add plug-in config entry during new instance creation.
-   Run with valgrind to check for memory leaks.
-   Test with large groups to determine performance impact.
-   Make member attribute configurable.
-   Make filter configurable (currently hardcoded to objectclass=inetuser)
-   Block manual modification of "memberOf" attribute when plug-in is enabled?
-   Make "memberOf" work with multi-master replication. [**done**]
-   Add fix-up task perl script.

