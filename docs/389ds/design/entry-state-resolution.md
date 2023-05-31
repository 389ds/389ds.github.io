---
title: "Entry State Resolution"
---

# Entry State Resolution
------------------------

{% include toc.md %}

Background
----------

In Multimaster replication clients can modify the same entry on different masters simultaneously. To keep the entries consistent across a replication topology the 'single master model' is used. Each operation gets a timestamp (or change sequence number, CSN) and the final state of the entry has to be equivalent to the result when the operations would have been applied in the order of the CSNs on a single master.

But in a real works deployment the operations can arrive out of csn order and entry state resolution has to ensure that on each server the final state is consistent. To achieve this it can be necessary to keep deleted values and their CSN for state resolution. Two examples demonstrate why it is needed.

Example 1:

    The entry has an attribute a with values u,v,w.    
    On one Master (M1) the following operations are done:    
    T1: delete: v    
    T2: add:  v    

    On master M2, the following op is done before T1 and T2 are received    
    T3: delete v.    
    If T3 is replayed to M1, the operations are applied in order and the result is a = {u,w}.    
    When M2 receives T1, it is ignored because v is already deleted.    
    When M2 receives T2, it should not be added, but to be able to come to this conclusion M2 needs the information that v was deleted and that it was deleted with a CSN greater than the CSN of T2.     

Example 2:

    There are three masters M1, M2, M3. Consider the entry     
    dn: cn=u    
    cn = {u,v,w}   
 
    Now apply independently:     
    On M1:    
    T1: modrdn u->v    
    On M2:    
    T2: modrdn u->w    
    On M3    
    T3: delete: v    
    If M1 and M2 receive the operation T3, it is newer than T1,T2, the cn contains still the value v and it will be deleted, the final state is dn: cn=w, cn={v,w}    
    The situation is more complex on M3. The value v is deleted, when T1 arrives, the value v gets distinguished and it has to be added to the present values. If T2 is applied v is no longer distinguished and there needs to be enough state information present to decide to remove v.     

Conclusion: We need to keep deleted values and we need to keep CSN for each value and type of operation done with this value.

But the goals have to be:

-   Keep enough state information to allow entry state resolution to generate a consistent state.
-   Keep only the minimal state info to avoid the growth of the entry.

There are two potential phases where the state information can be reduced:

-   Entry state resolution when an LDAP operation is applied.
-   Entry state purging.

Concepts and Terminology
------------------------

Before proceeding, here is a quick recall of terminology, the different types of CSN in use and some general concepts:

-   Deleted attributes

    If replication is enabled, each entry has a set of present attributes and deleted attributes.  If an attribute is deleted or the last value of the attribute is deleted, it is moved to the deleted attributes    

-   Deleted values

    A deleted value is not removed, it is moved to the list of deleted values so that it is still available for entry state resolution    

-   Operation CSN: OP-csn

    This is the CSN which is created when an ldap operation is received and it is associated with this operation across all servers in a replica.    
    The CSN generation ensures that this CSN is ahead of all other CSNs seen by this server (as specified in the RUV) and the current local time.    

-   Value Update CSN: VU-csn

    This CSN is associated with a value when the value is added to an attribute. It can be a  new value, or a value which was on the list of deleted values and is moved to the present values by an ldap MOD_ADD, MOD_REPLACE, or MODRDN operation.    

-   Value Delete CSN: VD-csn

    This csn is associated with a value when it is explicitly deleted either by ldap MOD_DELETE or MODRDN(deleteoldvalue)    

-   Attribute Deletion CSN: AD-csn

    This CSN is created when an attribute is deleted either by ldap MOD_REPLACE(with no values), or MOD_DELETE.  It is stored in memory in the attribute.  When the entry is written to disk, it is added to the first present value.  If no present values exist, it is added to the first deleted value.  The case where no deleted values exists also needs to be investigated.    
    Note: The attribute deletion CSN must not be set when the last present value is removed, otherwise the following example would lead to inconsistent data:    
    Assume an entry with the description attribute with two values:    

    dn: cn=x    
    description: aaa    
    description: bbb    
    If you do on master1 at time t1:    
    add: description    
    description: ccc    
    and on master 2 at time t2>t1    
    delete: description    
    description: aaa    
    description: bbb    
    After replication, ccc should survive, but if you set AD-csn to t2 then VD-csn(ccc)    <AD-csn and it would not be moved to the present values.

* Value distinguished CSN: MD-csn

 When a value is used in the RDN component of an entry, the value is called distinguished (part of the distinguished name). The latest MD-csn is stored in the entry.

### What needs to be done ###

This chapter will investigate what needs to be done to achieve both goals.

**Digression1:** what is different with urp ?

What is the difference for entry state resolution if it is done on the primary master (operation is from an ldapclient) or on a consumer (operation is via replication connection),noted as URP ?

 There are two differences:

-    On a primary master the operation csn: OPcsn is generated to be newer than any csn this master has ever seen , so there is no need to check if any value Vdcsn or Vuscn >     OP csn exists.    
    
-    The operation is verified not to violate the protocol, so it is impossible to delete a non existing value or to add an existing value, this can be used in deciding how present/deleted valuesets will be handled    

**Digression2:** is there a difference for single valued and multivalued attributes ?    
    Yes. the handling of single valued attributes is simpler in general and more complicated in specific cases. The next sections on purging and entry state resolution deal with multi valued attributes. Handling of single valued attributes follows in an extra section.    

Purging
---------

Entry state resolution will ensure that all values are in the correct set of values: present or deleted and that values with CSNs which could be needed for state resolution will not be removed. But there will be a time when they no longer can contribute to state resolution and can be removed. This removal of obsolete values is called purging. When is a value no longer needed ? A value needs to be retained as long as an operations can be received via replication which have a VD/VU-csn \< VU/VD-csn. Which csns can be received are determined by the the RUV, the RUV is exchanged in the replication protocol and a supplier will start at the min(maxRUV-csn)). So all deleted values with max(VD-csn, VU-csn) \< min(maxRUV-csn) can be purged.

State resolution
------------------

The section reviews the different LDAP operations and which values and state information needs to be kept.

### Adding values

An ldapmodify operation adding a set of one or more values to an attribute, eg:

    dn: cn=x    
    changetype: modify    
    add: a    
    a: v1    
    ...    
    a: vn    

-   Each value vi in the set of values {v1,..,vn} will be added to the set of present values, unless:
    -   There exists vi in the set of deleted values with a VD-csn \> OP-csn

This check only needs to be done in URP.

-   If the value exists in the set of deleted values and VD-csn\<OP-csn the csnset of the existing deleted value and the new value need to be merged, the value will be removed from the deleted values and added to the present values.

### Deleting specific values

An ldapmodify operation deleting a set of one or more values from an attribute, eg:

    dn: cn=x    
    changetype: modify    
    delete: a    
    a: v1    
    ...    
    a: vn    

For each of the values vi in {v1,..vn} do:
\* if vi in present values and VU-csn \< OP-csn, move to deleted values
\*if vi in present values and VU-csn \> OP-csn, update csnset and keep in present values URP only

-   if vi not in present values update or add to deleted values
-   if vi is distinguished do not remove from present values

### Deleting all values

A LDAP operation removing an attribute, either directly dn: cn=x changetype: modify delete: a \< no values specified\>

or an implicit delete by a replace operation dn: cn=x changetype: modify replace: a \<0 to n values\>

Set attribute deletion csn AD-csn to OP-csn.

For all values vi in present values, remove from present values, unless value is distinguished. All values with an VD-csn or a VU-csn \< AD-csn cannot become present by state resolution, the presence of the AD-csn will prevent this. So, values removed from teh set of present values need not be preserverd. In addition the set of deleted values (VD-csn<AD-csn) can also be cleared, since individual values will no longer be needed.
Question: if there are no more values left, where will the AD-csn be stored when the entry is saved to disk ? In that case a dummy, empty deleted value can be created: it cannot become present, clients will not see deleted values.

Renaming an entry
----------------------

Modrdn will generate a set of mods, which will be applied by calling entry_apply_moods_wsi, so it will be handled like the above cases
In addition it sets the mdcsn for the rdn attribute(s), need to check if this involves further entry state resolution.
Also need to check if it is correct to set the mdcsn after the mods are applied

Single valued attributes
-----------------------

The handling of single valued attributes is simpler than for multivalued attributes since always only one value can be present, and at each update operation it can be determined which is the more recent value and needs to be kept. The older value can be removed as it never can become present by a later update operation. So no deleted values need to be maintained.
But there is one exception which makes it more complicated: the single valued attribute becomes part of the rdn, it gets distinguished. Consider the following example:

    Entry cn=xxx
    cn: xxx
    cn: yy
    sv: A

 where cn is multivalued and sv denotes a single valued attribute.
 Assume at time t0 on master A a modrdn operation takes place:

    dn: cn=xxx
    changetype: modrdn
    newrdn: sv=A
    deleteoldrdn: 0
 
 At time t1 on master B a modify operation changes sv

    dn: cn=xxx
    changetype: modify
    replace: sv
    sv: B
 
In a single master model the second operation would fail because cn=xxx no longer identifies an entry.
But the operation has been accepted by master B and acknowledged to the client and replication has to deal with the situation.
And what should happen if the rdn of teh entry is changed again, eg:

At time t2 on master A a modrdn operation is performed:

    dn: sv=A
    changetype: modrdn
    newrdn: cn=yy
    deleteoldrdn: 0

Now sv no longer is distinguished and an operation which did change its value from A to B was accepted. The design decision was to keep the state of the entry as close to what client operations have been performed.
so the value sv:B will be kept as a pending value, and as soon as the current value is no longer distinguished teh pending value replaces the current value, so after entry state resolution for operation t2, the entry is:

    dn: cn=yy
    cn: xxx
    cn: yy
    sv: B

Current  implementation
------------------------

The entry state resolution is done in the modify operation: entry_apply_mod_wsi()
It has three core functions:

* entry_add_present_values_wsi
* entry_delete_present_values_wsi
* resolve_attribute_state


**entry_add_present_values_wsi()**

 if no values to add
     do nothing

 if some values to add
    if attr doesn't exist -> create it

    not URP    
    get the subset of values to add which are on the deleted list    
    update the csns of this subset, remove from deleted list, add to present list    
    remove from values to add    
    update csn for values to add    
    add to present values    

    URP    
    remove valuestoadd from present values (transferring csnset to valuestoadd)    
    remove valuestoadd from deleted values (transferring csnset to valuestoadd)    
    update csn of valuestoadd    
    add valuestoadd to present values    
    resolve_attribute state    

**entry\_delete\_present\_values\_wsi()**

There are three main parts in this function

    -   handling not-existing and deleted attributes
    -   handling the case that a list of values to delete is present
    -   handling the case that no values to delete exist, eg delete full attribute

    if attr not found and op is replace    
       create an empty deleted attribute and store AD-csn    

    if attr deleted and not URP    
       return no_such_attr    

    if attr exists or (attr deleted and urp)     

    no specific values to delete    
    set AD-csn    
    URP -->    
      resolve_attribute_state    
      (if no values remain present, attr will be moved to deleted attrs    
    not URP    
      present_values_to_deleted_values    
      attr to deleted attrs    

    some values specified    
    URP    
      check present values for values to be deleted, update VD-csn, remove from values_to_delete    
      check deleted values for values to be deleted, update VD-csn, remove from values_to_delete    
      add remaining values_to_delete to deleted values    
      resolve_attribute_state    
    not URP    
      remove valuestodelete from present values    
      update VD-csn of valuestodelete    
      add valuestodelete to deleted values    
      if no more present values move attr to deleted attrs    

**resolve\_attribute\_state()**

It is called from both functions above in case of urp
It basically does a check for ALL values in the present and deleted set to determine if they are in the right set:

    for each value v in present_values    
    do    
       if VD-csn < VU-csn remove VD-csn    
       if VU-csn < max (VD-csn, AD-csn) &&    
           v NOT value_distinguished at max (VD-csn, AD-csn)    
               move v to deleted_values    
    for each value v in deleted_values    
    do    
       if VD-csn < VU-csn remove VD-csn    
       if VU-csn > max (VD-csn, AD-csn) ||     
           v  value_distinguished at max (VD-csn, AD-csn)    
               move v to present_values    
           

As a side effect it cleans up VD-csn no longer of potential use, but it does not remove any values. Also the check if a value was distinguished can be expensive.

-   value\_distinguished\_at\_csn

 the procedure to detect if a value was distinguished at a specific csn is used heavily in resolve\_attribute\_state and can require to inspect all values of all attributes.
 It seems to differ from the original design plan, which describes the dn-csn-set as: "csn ordered list of all know dns of the entry. Each node of the list contains csn of the rename operation and pointers to the values made distinguished by the operation. The last element of the list corresponds to the current entry dn". But the current implementation just keeps one (the latest) MD-csn in the dn-csn-set, although the function name entry\_add\_dn\_csn[\_ext] and comments suggest that it would be added or inserted.
 So to determine if a value was distinguished the following procedure is used

    if MD-csn(v)    
    get the most_recent MD-csn < OP-csn and the associated value set by    
       for all present attributes and all deleted attributes    
           for all present values and all deleted values w    
               if MD-csn(w) >= most_recent_mdcsn &&    
                  MD-csn(w) < MD-csn(v)    
                      most_recent_mdcsn=MD-csn(w)    
                      if MD-csn(w) == most_recent_mdcsn    
                         add w to valuset    
                      else    
                         replace valueset with {w}    
    for each value w in valueset compare with v    
        if v == w value_distinguished = TRUE    

Proposal
========

A new implementation should be based on the following guidelines

-   Remove the generic, operation unaware resolve\_attribute\_state() function

It inspects every value in the present and deleted valueset although they in most cases already have been touched and eventually modified. Handling this in a higher layer could avoid unnecessary traversals

-   Reduce the state resolution to what is needed for a specific operation and integrate into entry\_delete\_... and entry\_add\_... functions
-   For attribute deletion remove any present values and purge deleted values up to AD-csn

Do this as early as it can be determined to be safe, do not wait for purging if not needed

-   Base purging on the min(maxCSN) of the RUV
-   Separate functions for single and multivalued attributes

Currently there is a big difference in resolve\_attribute\_state for single and multivalued attributes, if this is to be integrated into the main entry\_delete\_ entry\_add functions it makes sense to differentiate at a higher level

Test cases
==========

This section list the potential scenarios that have to be handled by entry state resolution, and the resulting testcases. They will be different for single and multivalued attributes.
First the potential states an attribut can have are listed, then the operations to be applied and the expected result.
The required test cases will the cross product of all states with all operations although not all combinations will apply.
 not all potential states are easily to realize, the actions to reach a state have to be included

NOTE: only valid operations will be considered, invalid ldap operations eg, deleting a nonexisting value or adding several values to a single valued attribute should be rejected on the primary master

Single valued attributes
------------------------

For single valued attributes there are no deleted values stored, the set of deleted values can contain one value: a pending value, see section:

Potential states:

    S1: attribute does not exist    
    S2: present value, no pending value    
    S3: present value, no pending value, attr distinguished    
    S4: present value, one pending value    
    S5: present value, one pending value, attr distinguished    
    -: the situation with a pending value and no present value should not exist    

How to reach states:

    S1,S2,S3: create entry with required properties    
    S5: Create entry in state S2 with value v     
        on M1:T1 replace value v --> w    
        on M2:T0 make attr distinguished MD(v)    
    S4: does it exist ???A    

Potential operations:

    O1: delete attr    
    O2: replace attr with no values    
    O3: delete present value    
    O4: add value    
    O5: make attr distinguished with existing value    
    O6: make attr distinguished with new value    

Multi Valued Attributes
-----------------------

A multivalued attribute can have three states: not-existing, present or deleted (which means the attribute did exist, but the attribute or all values have been deleted and it is preserved just for entry state resolution)

    S1: attribute does not exist    

    S2: attribute deleted, no deleted values (just a dummy to keep the AD-csn)    
    S3: attribute deleted, some values in deleted_values set    

    S4: attribute present, one present value, no deleted values    
    S5: attribute present, multiple present values, no deleted values    
    S6: attribute present, multiple present values, some deleted values    
    S7: S4 + value once was distinguished    
    S8: S5 + value once was distinguished    
    S9: S6 + deleted value once was distinguished    
    S10: S4 + value is distinguished    
    S11: S5 + value is distinguished    

How to reach the states is straight forward, maybe S9 needs steps

Operations:

    O1: Delete attribute by delete attr    
    O2: Delete attribute by replace attr    
    O3: Delete attribute by delete all present values    

    O4: Delete subset of present values    

    O5: Add new value(s) by add attr    
    O6: Add new value(s) by replace attr value(s)    
    O7: O5 + some attrs in deleted vals    
    O8: O6 + some attrs in deleted vals    

    O9: make attr distinguished with new value    
    O10: make attr distinguished with present value    
    O11: make attr distinguished with deleted value    


