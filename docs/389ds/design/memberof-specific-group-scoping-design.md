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

There is already a "scoping" function in the code: **memberof_entry_in_scope**  This function is used to check any entry involved with the group update - meaning both groups and members.  Members can be "users" or non-groups, and they can also be other/nested groups. Previously this function just checked if there was included/excluded subtrees. Now we will also check for "specific groups" using LDAP search filters.

This presents a challenge when trying to scope specific "groups" and not scope "non-group" members.  For example,  **memberof_entry_in_scope** is also used when processing new "members". So it needs to know if the member is a group or not. If it is a group, then we need to check the include/exclude specific group constraints, otherwise we can just proceed with updating that member. 

To overcome this issue we must determine if an entry is a "group" or not. This entry identification is done early in each postop function using the **memberof_set_entry_info** function where we check if the entry has certain "group" objectclasses. If it has one of these objectclasses then we mark the entry as a group. This list of group-defining objectclasses defaults to: *groupOfNames*, *groupOfUniqueNames*, and *nsAdminGroup* (this list of objectclasses can also be customized). So by identifying the entry type as a group or non-group, **memberof_entry_in_scope** can correctly apply the scoping rules.

This is implemented by passing a new *entry_info C struct*, that contains the group DN, the Slapi_Entry, and its entry type (group or not a group), to **memberof_entry_in_scope**. Now this scoping function knows whether it needs to apply "specific group" scoping or not. Note that we only need this entry-type distinction for handling individual membership updates. The original target entry passed to the plugin is always assumed to be a group (scoping always applies regardless of its objectclasses).



Behavior
--------

The specific group constraints are strict.  If you specify one specific group to include, then all other groups in the DIT will be excluded, regardless of their location. If it's not found by the "specific group" filters, then it's not updated. Similarly for excluding specific groups, if the group is not by the exclude filters, then it gets updated. It might not make sense to use both include and exclude specific group filters simultaneously. Instead, choose one approach that best fits your needs. 

Major configuration options and enablement
------------------------------------------

The "entry_info" struct in memberof.c

    typedef struct _MemberofEntryInfo
    {
        Slapi_Entry *e;
        Slapi_DN *sdn;
        bool group;
    } MemberofEntryInfo;

There are three new multi-valued configuration attributes that can be set in: **cn=MemberOf Plugin,cn=plugins,cn=config**:
   
    - memberOfSpecificGroupFilter: <LDAP search filter>
    - memberOfsExcludeSpecificGroupFilter: <LDAP search filter>
    - memberOfSpecificGroupOC: <objectclass name>

For example
    
    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    ...
    memberOfSpecificGroupFilter: (entrydn=cn=test_group1,ou=groups,dc=example,dc=com)
    memberOfSpecificGroupFilter: (&(objectclass=groupOfNames)(businessCatagory=customer))
    memberOfExcludeSpecificGroupFilter: (entrydn=cn=large_group,ou=groups,dc=example,dc=com)
    memberOfExcludeSpecificGroupFilter: (|(businessCatagory=staff)(businessCatagory=admins))
    memberOfSpecificGroupOC: groupOfUniquenames
    memberOfSpecificGroupOC: groupOfNames
    memberOfSpecificGroupOC: customGroupObjClass
    
CLI usage

    dsconf slapd-INSTANCE plugin memberof set --specific-group-filter=(cn=group)
    dsconf slapd-INSTANCE plugin memberof set --exclude-specific-group-filter=(cn=isolated group)

Origin
-------------

<https://github.com/389ds/389-ds-base/issues/7035>

Author
------

<mreynolds@redhat.com>

