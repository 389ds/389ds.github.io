---
title: "Access control on trees specified in MODDN operation"
---

# Access control on entries specified in MODDN operation
--------------------------------------------------------

{% include toc.md %}

Overview
--------

MODDN operation specifies a target entry and an optional '' 'new superior dn' ''. If the '' 'new superior dn' '' is different than the parent of the targeted entry, that means the operation tries to **move** the targeted entry from one part of the DIT (aka 'source tree') to an other (aka 'target tree').

Currently, access control requires that the bind user is granted the permission to ' **ADD** ' an entry in the ' **target tree** '. That means 389-DS makes no difference between a user doing a ' **ADD**' and a **'MODDN**'. In addition 389-DS does no access control on the **'source tree**', although it could be valuable to control that a given user is allowed to move an entry from one part of the DIT but not from an other part.

This document describes how to enhance the **'MODDN**' operation and **'ACI** to support access control during a MODDN on:

-   Source tree
-   Target tree

This changes is handled with ticket <https://fedorahosted.org/389/ticket/47553>

Use case
--------

Being bound as user ''uid=admin\_accounts, dc=example,dc=com" (for example), we want to control that this user can:

-   move an entry from *staging* to *accounts* (blue arrow)

but can not:

-   move entry from *test* to *accounts* (red arrow)
-   move entry from *staging* to *tests* (red arrow)
-   delete entry from *staging*
-   add entry to *account*

![](moddn_aci2.png "moddn_aci2.png")

Design
------

### Extends ACI permission and target

Access control is implemented in ACI code. There is no ACI permission specific to the MODDN operation, so we need a new permission keyword **moddn**. In MODDN there is a *source entry* and a *destination entry*. We want to restrict the **MODDN** permission to an entry/subtree that is a specified *source entry/subtree* and a specified *destination entry/subtree*. To do this we will introduce new *target* keyword **target\_from** and **target\_to**.

-   **moddn** permission grant the permission (allow/deny) to do a moddn (move)
-   **target\_from** specifies a slapi\_filter that restrict the *moddn* permission to the resources that will match (equality or substring) an entry and its subtree
-   **target\_to** specifies a slapi\_filter that restrict the *moddn* permission to the resources will match (equality or substring) an entry and its subtree destination where the **moddn** permission is granted

For example, the following ACI will allow 'uid=admin\_accounts,dc=example,dc=com' to move an entry from *staging* to *production*:

    aci: (target_from="ldap:///cn=staging,dc=example,dc=com")(target_to="ldap:///cn=production,dc=example,dc=com)")
    (version 3.0; acl "MODDN from"; allow (moddn))
     userdn="ldap:///uid=admin_accounts,dc=example,dc=com";)

#### target\_to/target\_from are filters

The values of those target will be filters. So the following aci is legal:

    dn: dc=example,dc=com    
    aci: (target_from="ldap:///uid=*,cn=staging,dc=example,dc=com")(target_to="ldap:///cn=production,dc=example,dc=com")
    (version 3.0; acl "MODDN from"; allow (moddn))    
     userdn="ldap:///uid=admin_accounts,dc=example,dc=com";)

It will grant the *moddn* right to entries that are moved from any of the subtrees "*uid=\*,cn=staging,dc=example,dc=com*" to *cn=production,dc=example,dc=com*

#### target\_to/target\_from are missing

As usual the ACI only applies in the subtree where it is defined. So in the previous example it applies under "*dc=example,dc=com*" but not under "*dc=tests,dc=com*".

If target\_to is missing, the ACI can match any destination resource under where it is defined ("*dc=example,dc=com*").

If target\_from is missing, the ACI can match any source resource under where it is defined ("*dc=example,dc=com*").

#### example

The following example shows how to grant a user (*bind\_entry*) to move an entry from **staging** to **accounts** with a restriction that deny to move an entry under **cn=except,cn=accounts,dc=example,dc=com**

![](moddn_aci5.png "moddn_aci5.png")

#### compatibility

Currently MODRDN/MODDN is authorized if the bound user is allowed to **'ADD**' and **'WRITE**' under the target entry.

This ticket introduces a new ACI permission **moddn** to better control MODRDN/MODDN.

If **'ADD**' and **'WRITE**' permissions were granted, the customer use to be able to process successfully MODRDN/MODDN. If the customer wants to keep this ability *without* adding the *moddn* aci there is three alternatives:

-   add a compatibility flag, that will either check for **MODDN** aci or for **ADD** aci. (**WRITE** ACI will be checked only if the RDN is changed).
-   *moddn* permission is enforced only if there is no **ADD** granted permission
-   ldbm\_back\_modrdn would evaluate **ADD or MODDN** rights.

The second alternative is possible but will have a performance impact as ACIs will be scanned/evaluated first on **ADD** then on **MODDN**. The last alternative triggers large changes as *acl\_access\_allow* only supports a single *access* value (although *access* is a bit mask).

To address this compatibility issue, we will introduce a new config parameter (under cn=config): **nsslapd-moddn-aci: on/off**. By default (value **on**), during a MODDN operation (move) we will check for **moddn** permission and during a MODRDN operation (rename RDN) we will check for **moddn** and **write** permissions. If the value is **off**, during a MODDN operation (move) we will check for **ADD** permission and during a MODRDN operation (rename RDN) we will check for **ADD** and **write** permission.

#### ACI scope and targets

To be selected, the **MODDN** ACIs should be added in an ancestor of the destination entry. It is not required that the ACI is at a common ancestor of both source/destination entries (TBC). Others targets keywords (''target, targetfilter, targetattr ?, targattrfilter ?) are allowed with **target\_to** and **target\_from**.

#### Readonly backends

If the operation applies on a readonly backend, the **moddn** permission is not granted

#### Get Effective Rights

Get Effective Rights is a search control (*1.3.6.1.4.1.42.2.27.9.5.2*), that returns the *rights* granted (for a given bound user) on each returned entry and attributes. When this control is present, for each returned entry it calls *acl\_get\_effective\_rights* that adds the operational attributes: **entryLevelRights** and **attributesLevelRights**. Each granted *rights* is coded in those attributes as described in <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Viewing_the_ACIs_for_an_Entry-Get_Effective_Rights_Control.html>.

MODDN *right* is an entry level *right* and is returned with **entryLevelRights**. If MODDN (aka *rename*) *right* is granted it returns the character **n**.

### Alternative n.1

#### Reasons why dropping this alternative

The main drawback of this alternative is *source* and *destination* rights are not evaluated in a single aci. The problem is that if we have

-   subtrees A, B, C and D
-   we want to allow moves A-\>B and C-\>D
-   aci \#1 that allows **move to B**
-   aci \#2 that allows **move from A**
-   aci \#3 that allows **move to D**
-   aci \#4 that allows **move from C**

Then although we do not want to allow the move C-\>B, aci \#1 will allow the move to B and aci \#4 will allow the move from C.

#### Extends ACI permission

Access control is implemented in ACI code. There is no ACI permission specific to the MODDN operation, so we need a new permission keyword. For this new permission we need to specify if the target entries of an ACI are either the **source tree** or the **target tree**. In addition of the permission keyword for MODDN, the permission keyword must also specify if the target entries are the **source tree** of the **target tree** of the MODDN. The new permission keywords are:

-   **MODDN\_TO** that grant a permission to move an entry under the target entries
-   **MODDN\_FROM** that grant a permission to move an entry from the target entries

For example, the following ACI will allow 'uid=admin\_accounts,dc=example,dc=com' to move an entry from *staging*:

    aci: (target="ldap:///cn=staging,dc=example,dc=com")(version 3.0; acl "MODDN from"; allow (moddn_from))
     userdn="ldap:///uid=admin_accounts,dc=example,dc=com";)

The following ACI will allow 'uid=admin\_accounts,dc=example,dc=com' to move an entry to *accounts*:

    aci: (target="ldap:///cn=accounts,dc=example,dc=com")(version 3.0; acl "MODDN to"; allow (moddn_to))
     userdn="ldap:///uid=admin_accounts,dc=example,dc=com" ;)

#### compatibility

##### MODRDN

Currently MODRDN is granted if the bound user is allowed to **'ADD** and **'WRITE** under the target entries. If such permissions are granted, MODRDN will not be impacted by the changes. The behavior of 389-DS processing MODRDN will be identical whether it exists or not **moddn\_to** and/or **moddn\_from** ACIs.

##### MODDN or move an entry (new superior)

Currently MODDN is granted if the bound user is allowed to **'ADD**' an entry under the *new superior*. With this changes MODDN will **FAIL**, if there is no ACI granting **moddn\_from**. In fact, superior changing from one DIT to an other, having the **ADD** permission to the target DIT does not give the right to move the entry from the source DIT.

One can imagine a config compatibility flag, to allow the move.

#### ACI scope and targets

The ACI scope is the set of entries where the aci is defined and its subtree. We may specify *aci targets* (target, targetfilter, targetscope, targetattr, targattrfilter) to limit entries where the ACI applies.

For example, we may add the ACI attribute directly at the entry (cn=accounts) where it should apply or set it at an upper level and use the *aci targets* to select the subtree/entries where it will apply (cn=staging).

![](moddn_aci3.png "moddn_aci3.png")

#### ACI allow/deny rights

The granted rights can be **ALLOW** or **DENY** as usual ACI mechanism. It can be useful to put a subtree as a DENY exception to upper level being ALLOWED. In that case the 'bind\_entry' user can move entries from *staging* to *accounts* subtree except under *cn=except,cn=accounts,dc=example,dc=com*.

![](moddn_aci4.png "moddn_aci4.png")

Implementation
--------------

### ACL parsing

Support of new 'targets' **target\_to** and **target\_from**

-   add new acl\_target\_\* and ACI\_TARGET\_MODDN (acl.h)
-   add in *struct aci*, Slapi\_Filters target\_to/target\_from (acl.h)
-   add support of target\_to/target\_from in aci parser (\_\_aclp\_\_parse\_aci). To be done before looking from *target* keyword.

Support of new 'permission' **moddn**

-   add new access\_str\_\* (acl.h)
-   update get\_acl\_rights\_as\_int/acl\_access2str

### Access control processing

When calling access control (plugin\_call\_acl\_plugin), it checks if given **'rights**' are allowed on a given **entry**.

Before evaluating the rights, ACI code selects a set of ACIs. It goes through the list of the ACIs checking for each ACI if it deals with the expected **rights** and if its targets match the given **entry**. Once the list of interesting ACIs is built, it then checks the binding rule to see if the ACI applies or not.

The difficulty here is that plugin\_call\_acl\_plugin deals with the **rights** on **one** entry, but in case of this new ACI (target\_to, target\_from) we have to check that **target\_to** matches the destination entry and **target\_from** matches the source entry. To do this checking on two entries, a new field is required in **aclpb**, to store the source entry SDN.

The changes are:

-   add a new field *aclpb\_moddn\_source\_sdn* in *aclpb* (acl.h) and initialize it in acl\_access\_allowed (in case of moddn) with the source entry SDN (taken from the pblock).
-   When looking for the interesting ACIs (acl\_\_resource\_match\_aci) checks that **target\_to** filter matches the entry provided as plugin\_call\_acl\_plugin argument and check that **target\_from** filter matches the entry stored in *aclpb\_moddn\_source\_sdn*.

### ACI logging

Update print\_access\_control\_summary/aclanom\_match\_profile so that if the **moddn** permission is granted, to display the source/destinations entry DN in case of MODRDN/MODDN.

### MODDN operation

If the **ADD** permission is not granted (this is for compatibility), then it checks if **MODDN** is granted.

If the RDN is not changed (move an entry), do not check if **WRITE** permission is granted.

### Get Effective Right

This is done by adding in *\_ger\_get\_entry\_rights* a call to *acl\_access\_allowed* with **SLAPI\_ACL\_MODDN** access

### Alternative n.1

In the ACI code, new permissions "moddn\_to" and "moddn\_from" should be added (at least get\_acl\_rights\_as\_int and acl\_access2str).

In slapi\_plugin.h, new aclpb\_access code to support SLAPI\_ACL\_MODDN\_TO and SLAPI\_ACL\_MODDN\_FROM

In ldbm\_back\_modrdn, if the **ADD** permission is not granted check that we have the MODDN\_TO permission. If we change to a new superior, check that we have the MODDN\_FROM permission on the old superior.

Major configuration options and enablement
------------------------------------------

A new *on/off* configuration parameter is created under 'cn=config': nsslapd-moddn-aci. Its default value is **on**.

By default (value 'on'), during a MODDN operation (move) we will check for moddn permission and during a MODRDN operation (rename RDN) we will check for moddn and write permissions.

If the value is 'off', during a MODDN operation (move) we will check for ADD permission and during a MODRDN operation (rename RDN) we will check for ADD and write permission.

Replication
-----------

When the new ACIs are replicated to an older version of 389-DS. The new permission **moddn** and targets **target\_to** and **target\_from** are not recognized. The consequence on replica that do not support this enhancement, is that ACI parser fails to parse the ACIs and they are ignored. A consequence would be that a MODDN user operation can be authorized on a server implementing this ticket and rejected on older version.

ACIs are not checked on replicated operation, so a legacy version of 389-DS will successfully process a replicated MODDN. This even if the original MODDN was authorized by a **ADD** and **WRITE** or by a **MODDN** permission.

Update or Upgrades
------------------

N/A

Dependencies
------------

N/A

External impact
---------------

N/A
