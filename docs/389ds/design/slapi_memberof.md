
---
title: "Slapi membership"
---

# Slapi Membership"
----------------

{% include toc.md %}

# Overview
---------

In LDAP an entry that is a static group has a name and a list of *members*. The *members* are the values of a *membership* attribute  (e.g. 'member', 'uniquemember', 'manager',...) with *DistinguishedName* syntax. For many client applications it is convenient to retrieve the groups (direct or indirect) that a given entry belongs to. As a consequence the server implements a way to retrieve those groups (DN) in an efficient way, via *memberof* attribute managed by *memberof plugin*.
Not only client applications need to retrieves those groups but also others plugins. For example, referential integrity plugin, ACI plugin and of course memberof plugin also need that. At the moment each plugin implement its own mechanism to retrieve those groups, this design is to create a new plugin API interface *slapi_memberof()* to return those groups (DN) and evaluate if/how existing plugins (memberof, referential integrity and ACI) can reuse it.

This new plugin API function is also required by a futur implementation of *Inchain plugin* (1.2.840.113556.1.4.1941)



# Use cases
-----------

A plugin uses *slapi_memberof* to retrieve the list of groups DN that a given entry DN belongs to. It specifies 
  - an entry SDN
  - a list of *membership* attributes to considere
  - optional a filter to search with
  - optional the base of the DIT to look into 
  - optional maximum nesting level 
  - optional maximum group to retrieve
  - Flag to reuse_only / reuse_if_possible / recompute *memberof* values
*slapi_memberof* returns an array of slapi_sdn containing all the groups DN that a given entry belongs to

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


## memberof attribute

When configured and enabled, memberof plugin maintain a valid set of *memberof* values (*memberOfAttr*). As consequence *slapi_memberof* could reuse those values at the following conditions:


- The Flag is set to 'reuse_only' or 'reuse_if_possible' *memberof* values
- the base of the DIT (slapi_memberof) is included in memberOfEntryScope (memberof plugin). If it is not the case it fails and returns -2.
- *membership* attributes (slapi_memberof) are the same as memberOfGroupAttr (memberof plugin). If it is not the case it fails and returns -3.


Limitations are:

- if *slapi_memberof* is called with a flag to 'recompute', it computes (internal search) *memberof* values.
- *memberof* plugin computes membership taking into account **all** configured membership attributes.  This is the current behavior of *memberof* plugin and *slapi_memberof* behave similarly. For example:

    	G1 --member--> G2 --uniquemember--> U1. 
    	U1.memberof = [G1, G2]
    	slapi_memberof(U1, [member, uniquemember], flag=reuse) => [G1, G2]
    	slapi_memberof(U1, [member, uniquemember], flag=recompute) => [G1, G2]
    

- with 'reuse' flag, maximum nesting is not enforced
- with 'reuse' flag, maximum groups is not enforced

*memberof* plugin will eventually use *slapi_memberof*, it calls *slapi_memberof* with flag 'recompute'.

## slapi_memberof interface

    int slapi_memberof(slapi_sdn *target_entry, char **membership_attr, char *filter, slapi_sdn *base, slapi_sdn **group_sdn, int max_nesting, int max_groups, int flag, char *error_msg, int error_msg_lgth)
    
	According to the value of 'flag' , it returns or computes 'group_sdn'. 'group_sdn' contains the set of groups that 'target_entry' belongs to (directly or indirectly). The server uses the set of membership attributes membership_attr to determine if the entry belongs or not to a group. If slapi_memberof computes group_sdn, then it enforces that not more the max_groups are returned and that the depth of nested group is less than max_nesting.
	If 'filter' is specified it uses it without using 'target_entry', 'membship_attr' and force max_nesting to 1. 
	Input parameters
		- target_entry is the target entry SDN 
		- membership_attr is a NULL terminated array of membership attribute
		- filter to use to retrieve the groups
		- base is the SDN of the base entry. If NULL, it uses the base suffix containing *target_entry*
		- max_nesting is the length of the path 'group' to 'target_entry'. 1 means direct members. By default, for safety reason max_nesting is limited to 20.
		- max groups is the maximum number of groups to put into 'group_sdn' array. By default, for safety reason max_groups is 1000.
		- error_msg_lgth: lenght of the error_msg buffer
		- flag
			- reuse_only: it returns the values of 'memberof' in 'group_sdn'. If 'base' or 'membership_attr' are not conform, it fails.
			- reuse_if_possible: If 'base' or 'membership_attr' conform to *memberof plugin* configuration, it returns the values of *memberof* in group_sdn. Else it switches to 'recompute' mode.
			- recompute: It uses 'base' , 'membership_attr', 'filter', 'max_groups', 'max_nesting' to compute membership and return the groups DN in 'group_sdn'.
		
	Output parameters
		- group_sdn, NULL terminated array of slapi_sdn containing the DN of the groups having target_entry as member
                  the group_sdn should be freed by the caller
	        - error_msg: buffer that contains a message explaining the return code != 0. If rc = 0, buffer is not changed
	        
	Return code:
		-  2 maximum nesting hit
		-  1 maximum groups hit
		-  0 success
		- -1 internal error
		- -2 flag to return memberof values is invalid because of the base
		- -3 flag to return memberof values is invalid because of the membership_attr
	

## plugins potentially using slapi_memberof

### referential integrity

When a target entry is *deleted* or *renamed*, the plugin updates the entries (groups) that are *Directly* refering to the target entry. 
The reference is stored in a *DistinguishedName* attribute. The plugin supports several refering attribute names. For example, by default *member*, *uniquemember*, *owner* and *seeAlso*.

referint update is done within original transaction or done later with a dedicated thread. Weither it is insync or not it uses *update_integrity()* to update the refering groups.

If entry *DN_A* is DEL, the plugins does as many internal **searches** as there are refering attributes. Then for each entries refering to *DN_A*, it **MOD_DEL** the value '*refering_attribute_name*: *DN_A*')

If entry *DN_A* is MODDN into *DN_B*, the plugins does as many internal **searches** as there are refering attributes. Then for each entries refering to *DN_A*, it **MOD_DEL** the value '*refering_attribute_name*: *DN_A*' then **MOD_ADD* the '*refering_attribute_name*: *DN_A*')

So for referential integrity plugins key considerations are

- **multiple** refering attributes (i.e *member*, *uniquemember*, *owner* and *seeAlso*) with *DN Syntax*. Can be configured.
- Entries to fixup are retrieved by **one** refering attribute at a time (i.e. 1 internal search for each of those attributes *member*, *uniquemember*, *owner* and *seeAlso*). This is because the plugins does a **MOD_DEL** of a specific value.
- Only **Direct** refering entries are retrieved and fixup
- base: Only monitors users/groups under nsslapd-pluginEntryScope
- filters: '(member=*targetDN*)' or '(member=\**targetDN*)' (for MODRDN and children entries)
- take groups from the result of a search (filter)

In conclusion, referential integrity can use *slapi_memberof*.

	int slapi_memberof(target_entry, membership_attr, char *filter, slapi_sdn *base, slapi_sdn **group_sdn, int max_nesting, int max_groups, int flag, char *error_msg, int error_msg_lgth)
	
	For DELETE operation
	
	target_entry : DN of the deleted entry
	membership_attr: set of membership attribute (i.e.  member, uniqueMember, seeAlso,...)
	base: nsslapd-pluginEntryScope
	max_nesting: 1 (direct membership)
	max_groups: -1
	
	
	For MODRDN operation
	
	As many call as membership attributes
	filter="(<membership_attr>=*<target_entry>)"
	base: nsslapd-pluginEntryScope
	max_nesting: 1 (direct membership)
	max_groups: -1
	

### ACL plugin

When access control is evaluated, it selects which ACI apply before evaluating them. During the selection it checks the bind rule against the bound entry.
bind rule 'groupdn' requires to evaluate if the bound entry is member of groups. If 'groupdn' uses a filter several groups are evaluated, else only one.
DS_LASGroupDnEval check (acllas_eval_one_group/acllas__user_ismember_of_group) if the bound entry is a direct member. It iterates with some limitations of nesting (5 by default SLAPD_DEFAULT_GROUPNESTLEVEL) and the total number of evaluated groups (50 by default ACLLAS_MAX_GRP_MEMBER). When a group is retrieved, it is stored into a per operation cache.

It iterates through members and nested members using internal search with the following fixed constraints.

    
   	membership attributes: (member uniquemember memberURL memberCertificateDescription) 

	Groups are matching"(|(objectclass=groupOfNames) (objectclass=groupOfUniqueNames)(objectclass=groupOfCertificates)(objectclass=groupOfURLs))" )

Matching entries are added into a cache *info->memberInfo* ( acllas__handle_group_entry)



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

### memberof plugin


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

For memberof plugin key considerations are

- **multiple** refering attribute (*member* *uniquemember* *memberURL* *memberCertificateDescription*) via memberOfGroupAttr attribute of the memberof plugin config entry.
- The computation of reverse relation of membership
	- done with *all* referring attributes (.e.g SRCH "(|(member=target_dn)(uniquemember=target_dn)...)").
	- not limited in nesting/total number

- For an entry that is member of some groups, the fixup procedure (in memberof_fix_memberof_callback) is called *after* computing all the groups (memberof_get_groups) the entry is member of. So fixup procedure is separated from the computation of membership.
- **Direct** and **indirect** referring entries are retrieved
- scopes contains include/exclude scopes (memberOfEntryScope, memberOfEntryScopeExcludeSubtree)



# Tests

TBD

# Reference
-----------------

# Author
--------

<tbordaz@redhat.com>
