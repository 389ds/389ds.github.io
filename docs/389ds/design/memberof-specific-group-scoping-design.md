---
title: "MemberOf Plugin Specific Group Scoping"
---

# MemberOf Plugin Specific Group Scoping
----------------

Overview
--------

While you can include/exclude subtrees/containers that the memberOf plugin should process there is currently no way to specify individual groups to include or exclude. This feature allows Administrators to control if specific groups should be included or excluded from the MemberOf plugin updates.

Use Cases
---------

Admins may only need select groups to be maintained by the memberOf plugin. Or, they may have certain groups that do not need the memberOf plugin updates. Limiting the scope of the memberOf plugin can improve performance and reduce the overhead of group updates.

Design
------

There is already a "scoping" function in the code: **memberof_entry_in_scope**  This function is used to check any entry involved with the group update - meaning both groups and members.  Members can be "users" or non-groups, and they can also be other/nested groups. Previously this function just checked if there was included/excluded subtrees. Now we will also check for "specific groups".

This presents a challenge when trying to scope specific "groups" and not scope "non-group" members.  For example,  **memberof_entry_in_scope** is also used when processing new "members". So it needs to know if the member is a group or not. If it is a group, then we need to check the include/exclude specific group constraints, otherwise we can just proceed with updating that member. 

To overcome this issue we must determine if an entry is a "group" or not. This entry identification is done early in each postop function using the **memberof_set_entry_info** function where we check if the entry has certain "group" objectclasses. If it has one of these objectclasses then we mark the entry as a group. This list of group-defining objectclasses defaults to: *groupOfNames*, *groupOfUniqueNames*, and *nsAdminGroup* (this list of objectclasses can also be customized). So by identifying the entry type as a group or non-group, **memberof_entry_in_scope** can correctly apply the scoping rules.

This is implemented by passing a new *entry_info C struct*, that contains the group DN and its entry type, to **memberof_entry_in_scope**. Now this scoping function knows whether it needs to apply "specific group" scoping or not. Note that we only need this entry-type distinction for handling individual membership updates. The original target entry passed to the plugin is always assumed to be a group (scoping always applies regardless of its objectclasses).



Behavior
--------

The specific group constraints are strict.  If you specify one specific group to include, then all other groups in the DIT will be excluded, regardless of their location. If it's not a "specific group", then it's not updated. Similarly for excluding specific groups, if the group is not in the exclude list, then it gets updated. It doesn't make sense to both include and exclude specific groups simultaneously. Instead, choose one approach that best fits your needs. Using "exclude" rules is the preferred approach as it requires less maintenance, but the choice depends on your specific database usage.

Major configuration options and enablement
------------------------------------------

The "entry_info" struct in memberof.c

    typedef struct _MemberofEntryInfo
    {
        Slapi_DN *sdn;
        bool group;
    } MemberofEntryInfo;

There are three new multi-valued configuration attributes that can be set in: **cn=MemberOf Plugin,cn=plugins,cn=config**:
   
    - memberOfSpecificGroup: <group DN>
    - memberOfsExcludeSpecificGroup: <group DN>
    - memberOfSpecificGroupOC: <objectclass name>

For example
    
    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    ...
    memberOfSpecificGroup: cn=test_group1,ou=groups,dc=example,dc=com
    memberOfSpecificGroup: cn=test_group2,ou=groups,dc=example,dc=com
    memberOfExcludeSpecificGroup: cn=large_group,ou=groups,dc=example,dc=com
    memberOfExcludeSpecificGroup: cn=ignore_group,ou=groups,dc=example,dc=com
    memberOfSpecificGroupOC: groupOfUniquenames
    memberOfSpecificGroupOC: groupOfNames
    memberOfSpecificGroupOC: customGroupObjClass
    
    NOTE: You would not want to use both scopes at the same time: memberOfSpecificGroup & memberOfExcludeSpecificGroup. They are only listed as an example of its usage

Origin
-------------

<https://github.com/389ds/389-ds-base/issues/7035>

Author
------

<mreynolds@redhat.com>

