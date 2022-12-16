---
title: "Slapi membership"
---

# Slapi Membership
----------------

{% include toc.md %}

# Overview
---------

In LDAP an entry that is a static group has a name and a list of *members*. The *members* are the values of a *membership* attribute  (e.g. 'member', 'uniquemember', 'manager',...) with *DistinguishedName* syntax. For many client applications it is convenient to retrieve the groups (direct or indirect) that a given entry belongs to. As a consequence the server implements a way to retrieve those groups (DN) in an efficient way, via *memberof* attribute managed by *memberof plugin*.
Not only client applications need to retrieves those groups but also others plugins. For example, referential integrity plugin, ACI plugin and of course memberof plugin also need that. At the moment each plugin implement its own mechanism to retrieve those groups, this design is to create a new plugin API interface *slapi_memberof()* to return those groups (DN) and evaluate if/how existing plugins (memberof, referential integrity and ACI) can reuse it.

This new plugin API function is also required by a futur implementation of *Inchain plugin* (1.2.840.113556.1.4.1941)



# Use cases
-----------

A plugin uses *slapi_memberof* to retrieve the list of entries that refer to a given entry. It specifies 
  - an entry SDN
  - a *membership* attributes to consider 
  - optional scopes to take into account (multi backends, included/excluded scopes)
  - retrieve direct or direct+indirect referencing entries
  
Upon success, *slapi_memberof* returns a couple of valueset with nsuniqueid/dn of the referring entries.


# Configuration changes
--------------------------------------------
N/A


# Design
--------

## membership

In LDAP a group entry has a name and contains a membership relation to its members via attributes  (e.g. 'member', 'uniquemember', 'manager',...) with *DistinguishedName* syntax. The reverse relation from a member to the set of groups it belongs to (directly or indirectly) is also maintained via an *DistinguishedName* syntax attribute (e.g. 'memberof', 'ismemberOf'). 

In 389ds the reverse relation use a single attribute *memberof*, although we can imagine in other implementations to subtype it to reflect the original relation like 'memberof;member' or 'memberof;uniquemember'.

### base membership

Let call *base* membership the relation between a single given (*base*) entry to the groups it belongs to. 

base membership uses a filter like '(*membership_attr*=*target_entry*)'.

### subtree direct membership

In some specific cases (referential integrity) we want to retrieve all the groups that a set of entries belongs to.

When an entry is renamed, the entries in the subtree of that top entry are also renamed. The subtree direct membership is to retrieve, for a set of entries in a given subtree, the groups that the set of entries is direct member.

subree direct membership uses a filter like '(*membership_attr*=**\*** *target_entry*)'.



## Write vs read

In 389DS, the reverse membership relation (i.e. *memberOf*, *ismemberOf*) is stored in the attribute values of the member entry. Another approach is to compute the values on the fly (via virtual attribute) for example in ODSEE (*ismemberOf*).

Storing the value improves READ response time but slow down WRITE. Computing the value improve WRITE and slow down READ. Reverse membership needs to be computed anyway. Both approaches have benefit/loss. This design assumes that '*memberof*' attribute is a real attribute stored in the entry. 


## slapi_memberof interface

    
    typedef enum {
        REUSE_ONLY,
        REUSE_IF_POSSIBLE,
        RECOMPUTE
    } memberof_flag_t;
    
    typedef struct _slapi_memberofresult {
        Slapi_ValueSet *nsuniqueid_vals;
        Slapi_ValueSet *dn_vals;
    } Slapi_MemberOfResult;
    
    typedef struct _slapi_memberofconfig
    {
        char *groupattr;
        PRBool subtree_search;
        PRBool allBackends;
        Slapi_DN **entryScopes;
        Slapi_DN **entryScopeExcludeSubtrees;
        PRBool recursive;
        memberof_flag_t flag;
        char *error_msg;
        int errot_msg_lenght;
    } Slapi_MemberOfConfig;
    
    

    int
slapi_memberof(Slapi_MemberOfConfig *config, Slapi_DN *member_sdn, Slapi_MemberOfResult *result)

### description

    Slapi_memberof retrieve all entries that are directly or indirectly referring to <member_sdn>
    
### arguments
    
    **groupattr** is the attribute name. It is used, along with **subtree**, to build the filter matching the referring entries. If **subtree** is False the filter looks like "<groupattr>=<member_dn>". If **subtree_search** is True then the filter is "<groupattr>=*<member_dn>".
    
    For a given **member_sdn**, Slapi_memberof retrieves referring entries in the same suffix where **member_sdn** is. If **allBackend** is True, it retrieves referring entries in all the backends. **entryScopes** and **entryScopeExcludeSubtree** are used to check that entries (referred and referring) are considered or not. If the entry is in **entryScopeExcludeSubtree**, it is ignored. Else the server search referring entries in the full suffix or in **entryScopes** if it only part of the suffix.
    
    When **recursive** is False, it retrieves the directly referring entries to **member_sdn**. Else it retrieves the directly and indirectly referring entries. For example U1 is referenced by G1 and G1 is referenced by G2, if **recursive**=True then it returns G1 and G2 else it returns G1.
    
	If slapi_memberof is called with **groupattr** that is identical to **memberofgroupattr** in memberof plugin then there is a possibility to speed up slapi_memberof computation using **memberof** attribute from **member_sdn** entry. The **flag** is used to specify if slapi_memberof should use or not **memberof** to retrieve referencing entries. It exists limitations to reuse **memberof** attribute:
	- memberof plugin must be enabled
	- **groupattr** should be in *memberofgroupattr** value set
	- **entryScopes**, **entryScopeExcludeSubtree** and **allBackend** should match the configuration of memberof plugin
	- **recursive** should match **memberOfSkipNested**
The **flag** values are:
	- RECOMPUTE: computes **result** even if values of **memberof** could be reused.
	- REUSE_ONLY: Only set **result** if the **memberof** values from memberof plugin are used. Meaning that all limitations are fulfill. If some limitations are not fulfill, slapi_memberof fails
	- REUSE_IF_POSSIBLE: If all limitations are fulfill, use **memberof** to set **result**, else recomputes **result**
	
**error_msg** and **error_msg_length** are used to store a message explaining the reason of the failure of slapi_memberof

### result

The **result** contains a valuset *nsuniqueid* and *dn* of the matching entries. The valuesets are ordered similarly, so the first *nsuniqueid* and first *dn* are related to the first entry. The second  *nsuniqueid* and second *dn*are related to the second entry,... Those valuesets are allocated by slapi_memberof and the caller is responsible to free them. If needed the plugin can retrieve Slapi_Entry using *slapi_search_get_entry*.

### returned code


## Plugins potentially using slapi_memberof

### Referential Integrity

When a target entry is *deleted* or *renamed*, the plugin updates the entries (groups) that are *Directly* refering to the target entry. 
The reference is stored in a *DistinguishedName* attribute. The plugin supports several refering attribute names. For example, by default *member*, *uniquemember*, *owner* and *seeAlso*.

referint update is done within original transaction or done later with a dedicated thread. Weither it is insync or not it uses *update_integrity()* to update the refering groups. **slapi_memberof** is called by *update_integrity()*

#### membership attributes

If entry *DN_A* is DEL, the plugins does as many internal **searches** as there are refering attributes. Then for each entries refering to *DN_A*, it **MOD_DEL** the value '*refering_attribute_name*: *DN_A*')

If entry *DN_A* is MODDN into *DN_B*, the plugins does as many internal **searches** as there are refering attributes. Then for each entries refering to *DN_A* or some of entries is *DN_A* subtree, it **MOD_DEL** the value '*refering_attribute_name*: *DN_A*' then **MOD_ADD* the '*refering_attribute_name*: *DN_B*')

So *referencing entries* are searched with a **single** membership attribute at a time

#### Scopes

The plugin updates references to the target entry at the condition the *target entry* belongs to *target scopes* and if *referencing entries* (aka static groups) belong to *referencing scopes*.

*target scopes* are related to **Target entry**. They are configured with '*nsslapd-pluginEntryScope*' (multi-valued) and '*nsslapd-pluginExcludeEntryScope*' (single valued). A *target entry* belongs to *target scopes* if it is not into '*nsslapd-pluginExcludeEntryScope*' and in '*nsslapd-pluginEntryScope*'. By default, there is no '*nsslapd-pluginExcludeEntryScope*' and any entry is in '*nsslapd-pluginEntryScope*', so any **target entry** belongs to **target scopes**. Those configuration attributes are enforced before the call to *update_integrity()*. So *target scopes* are enforced **before** the call to *update_integrity()* and *slapi_memberof*. 

*referencing scopes* are related to **referencing entries**. They are configured with '*nsslapd-pluginContainerScope*' (single-valued). A *referencing entries* belongs to *referencing scopes* if it is under '*nsslapd-pluginContainerScope*'. By default, there is no '*nsslapd-pluginContainerScope*' and scopes covers *all suffixes*, so any *referencing entries* belongs to *referencing scopes*. So if '*nsslapd-pluginContainerScope*' is defined '*entryScopes*' contains it unique value and '*allBackends*' is false.

So membership is computed when searching for *referencing entries* and the scope is either defined by '*nsslapd-pluginContainerScope*' or by the set of *suffixes*. The scope is used as base search during internal search.

#### key considerations

So for referential integrity plugins key considerations are

- Although **multiple** referencing attributes (i.e *member*, *uniquemember*, *owner* and *seeAlso*) with *DN Syntax* can be configured, the search of *referencing entries* uses only **one** *referencing attribute* at a time. In short for *member*, *uniquemember*, *owner* and *seeAlso* it triggers 4 searches.  This is because the plugins does a **MOD_DEL** of a specific value.
- Only **Direct** refering entries are retrieved and fixup
- An internal search use one single base. If all the suffixes will be searched (no '*nsslapd-pluginContainerScope*') it triggers as much search as there are suffixes.
- filters: '(member=*targetDN*)' or '(member=\**targetDN*)' (for MODRDN and children entries)
- take groups from the result of a search (filter)

In conclusion, referential integrity can use *slapi_memberof*.

	
        - groupattr: there is a call to slapi_memberof for each referencing attribute
        - subtree_search: True for MODRDN, False else
        - allBackends: if *nsslapd-pluginContainerScope* is set, then it is False, else it is True 
        - entryScopes:  if *nsslapd-pluginContainerScope* is set, then *entryScopes* is set to *nsslapd-pluginContainerScope*, else it is NULL
        - entryScopeExcludeSubtrees: is NULL
        - recursive is False
        - flag is RECOMPUTE
	

### ACL Plugin

When access control is evaluated, it selects which ACI apply before evaluating them. During the selection it checks the bind rule against the bound entry.
bind rule 'groupdn' requires to evaluate if the bound entry is member of groups. If 'groupdn' uses a filter several groups are evaluated, else only one.
DS_LASGroupDnEval check (acllas_eval_one_group/acllas__user_ismember_of_group) if the bound entry is a direct member. It iterates with some limitations of nesting (5 by default SLAPD_DEFAULT_GROUPNESTLEVEL) and the total number of evaluated groups (50 by default ACLLAS_MAX_GRP_MEMBER). When a group is retrieved, it is stored into a per operation cache.

It iterates through members and nested members using internal search with the following fixed constraints.

The membership for ACI is defined with static definitions.  membership attributes are: member uniquemember memberURL memberCertificateDescription. The static groups matches this filter "(|(objectclass=groupOfNames) (objectclass=groupOfUniqueNames)(objectclass=groupOfCertificates)(objectclass=groupOfURLs))". 

Matching entries are added into a cache *info->memberInfo* ( acllas__handle_group_entry)

Referencing entries are all stored into a cache (per operation) and not using internal search.



So for acl group key considerations are

- Hardcoded **multiple** refering attribute (*member* *uniquemember* *memberURL* *memberCertificateDescription*)
- Enforce max nesting and groups
- **Direct** and **indirect** referring entries are retrieved
- fetched groups are kept into per operation cache and the cache keeps reference of the hierarchy of the nested group
- Complexity of DS_LASGroupDnAttrEval

In conclusion: 
For the following reasons, even if it is theoretically possible to use *slapi_memberof*, I think we should not use slapi_membership in ACL plugin.
 - it is security code and any regression will be a CVE
 - DS_LASGroupDnAttrEval/acllas__handle_group_entry are complex code so the fix will not be easy
 - For cache management, it keeps the hierarchy of the nested groups. This info is not available with *slapi_memberof* and I do not know if we can easily get rid of it.
 - Because ACL does use slapi_memberof, the interface of slapi_memberof does not support maximum nesting and maximum groups

### Memberof Plugin


For FIXUP task, the server retrieves the entries to fixup with the filter set in the fixup task.
For each of them it computes the groups it belongs to (memberof_get_groups) and finally fixup the members.

For MOD (memberof_modop_one_replace_r/memberof_fix_memberof_callback) the server finds any entry impacted by the MOD (look down).
For each of them it computes the groups it belongs to (memberof_get_groups) and finally fixup the members.

For ADD of a new group, for *each* membership attribute, the servers finds (memberof_add_attr_list/memberof_fix_memberof_callback) all new members of the group including indirect members (look down).
For each of them it computes the groups it belongs to (memberof_get_groups) and finally fixup the members.

For DEL of a group, the plugin acts first as referential integrity then fixup the membership.
In a first phase (memberof_del_dn_from_groups) the server removes the reference to the target entry in all the groups that have the target entry as *direct* member (for *all* membership attributes).
In a second phase, for *each* membership attribute, the server finds (memberof_del_attr_list/memberof_fix_memberof_callback) any member of the group including indirect members(look down).
For each of them it computes the groups it belongs to (memberof_get_groups) and finally fixup the member.

For MODRDN of a group, the plugin fixup the membership then acts as referential integrity.
In a first phase, for *each* membership attribute, the server finds (memberof_moddn_attr_list/memberof_fix_memberof_callback) any member of the renamed group including indirect members (look down).
For each of them it computes the groups it belongs to (memberof_get_groups) and finally fixup the member.
In a second phase (memberof_del_dn_from_groups/memberof_replace_dn_from_groups) the servers updates the reference to the target entry in all the groups that have the target entry as direct member (for *all* membership attributes).

#### membership attributes

The membership attributes can contain several attributes that are defined in the configuration entry '*memberOfGroupAttr*'.


#### scopes


*scopes* are related to a **group entry** (entry that is listing its members). By defaults *scopes* are limited to the backend where the *target group entry* is located, so if there are several backends then membership is *not* updated if *target group entry* and *referred member entry* are in different backends. In order to extend the *scopes* to all backends (not only the backend of the *target entry*), the configuration attribute '*memberOfAllBackends*' must be set to '*on*' (it is '*off*' by default). If a backend/suffix is a sub-suffix of *parent* suffix and if the *target group entry* is in *parent* suffix then *referred member entries* are updated even if they are into the *sub-suffix*.

*scopes* They are configured with '*memberOfEntryScope*' (multi-valued) and '*memberOfEntryScopeExcludeSubtree*' (multi-valued). A *group entry* belongs to *scopes* if it is not into '*memberOfEntryScopeExcludeSubtree*' and in '*memberOfEntryScope*'. By default, there is no '*memberOfEntryScope*' and no '*memberOfEntryScopeExcludeSubtree*', so by default *scopes* covers *all suffixes* and any **group entry** belongs to the **scopes**. 

#### key considerations

For memberof plugin key considerations are

- **multiple** refering attribute (*member* *uniquemember* *memberURL* *memberCertificateDescription*) via memberOfGroupAttr attribute of the memberof plugin config entry.
- The computation of reverse relation of membership
	- done with *all* referring attributes
	- not limited in nesting/total number

- For an entry that is member of some groups, the fixup procedure (in memberof_fix_memberof_callback) is called *after* computing all the groups (memberof_get_groups) the entry is member of. So fixup procedure is separated from the computation of membership.
- **Direct** and **indirect** referring entries are retrieved
- scopes contains include/exclude scopes (memberOfEntryScope, memberOfEntryScopeExcludeSubtree)

In conclusion memberof plugin can use slapi_memberof with

        - groupattr: there is a call to slapi_memberof for each referencing attribute (*memberOfGroupAttr*)
        - subtree_search: False
        - allBackends: if *memberOfAllBackends* is 'on', then it is True, else it is False 
        - entryScopes:  array of *memberOfEntryScope*
        - entryScopeExcludeSubtrees: array of memberOfEntryScopeExcludeSubtree
        - recursive True if fixup task or *memberOfSkipNested* is False. else it is False.
        - flag is RECOMPUTE

# Tests
--------------------------

Should run successfully 
 - tests/suites/plugins/referint_test.py
 - tests/suites/plugins/memberof_test.py
 - tests/suites/memberof_plugin


# Reference
-----------------

# Author
--------

<tbordaz@redhat.com>

