---
title: " Use Correct Tombstone RDNs "
---

# Use Correct Tombstone RDNs
-------------------------------------

{% include toc.md %}

## Current solution

If an entry is deleted it is transformed into a tombstone entry and stored until it is
removed by tombstone purging or an explicit delete operation. Tombstones are needed for 
certain update resolution procedures.

The transformation of an entry into a tombstone does:

Create  a new DN for this entry:

    dn: nsuniqueid=<UNIQID>,<OLD_RDN>,<PARENTDN>

Add the attribute/values:

    objectClass;vucsn-5b222aa5000a00030000: nsTombstone
    nstombstonecsn: 5b222aa5000a00030000

Entries with objectclass tombstone are not returned by client searches unless explicitely requested in
the search filter.

## Problems with current solution

The core problem of the current solution is that a tombstone entry now has two RDNs: 

       nsuniqueid=<UNIQID>,<OLD_RDN>

and for these entries the entryrdn index handles rdn tuples.

But as complained in ticket #49507 this is not consistent with the LDAP RFCs and it exposes problems with nested tombstones.
If we have two entries, one the child of the other and then delete first the child then the parent we have nested tombstones
which would give:

    nsuniqueid=<P_UNIQID>,<P_RDN>,<SUFFIX>
    nsuniqueid=<C_UNIQID>,<C_RDN>,nsuniqueid=<P_UNIQID>,<P_RDN>,<SUFFIX> 

For the child tombstone we now have a DN consisting of multiple RDNs which need to be grouped and unfortunately a simple 
parsing of the DN to determine the proper dns of the subtree levels is only possible with very specific handlig of the
special tombstone cases.
And it turns out that even the DNs for nested tombstones are not correctly constructed, see ticket #49615.

Although the non compliance and problems with nesting do exist since the beginning there was not much complaint. But with the 
redesign of replication conflicts and update resolution, where tombstones are used in more resolution paths than before
this limitation becomes a real burden.
 

## New tombstone RDN

To resolve these problems we should change the generated name of the tombstone.

A straight forward solution would be to change

    nsuniqueid=<UNIQID>,<OLD_RDN>

to

    nsuniqueid=<UNIQID>+<OLD_RDN>

But there are two problems with this suggestion:

1] this is already the naming scheme for conflict entries

2] if a conflict entry is deleted it is also transformed into a tombstone and then would become:

    nsuniqueid=<UNIQID>+nsuniqueid=<UNIQID>+<OLD_RDN>

with a duplicate nsuniqid component, which is not possible and if falling back to nsuniqueid=<UNIQID>+<OLD_RDN> would
generate tombstones with a different naming scheme.

My proposal is therfor to introduce a new attribute to be used as identifier in a tombstone RDN:

    tombstoneID=<UNIQID>+<OLD_RDN>

This clearly distinguishs tombstones from conflicts and identifies tombstones in their DN. The following sections 
describe what needs to be done to implement this and the backward compatibility-

## Required changes

### Extend Schema

The new attribute tombstoneID has to be added to the schema and be allowd in the nstombstone objectclass:

    attributeTypes: ( 2.16.840.1.113730.3.1.2345 NAME 'tombstoneID' DESC 'Netscape defined attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE X-ORIGIN 'Netscape Directory Server' )
    ....
    objectClasses: ( 2.16.840.1.113730.3.2.113 NAME 'nsTombstone' DESC 'Netscape defined objectclass' SUP top MAY ( nstombstonecsn $ nsParentUniqueId $ nscpEntryDN $tombstoneID) X-ORIGIN 'Netscape Directory Server' )


### Create correct RDN and DN

when an entry is deleted and a tombstone is created, create proper rdn and dn:

    tombstone_rdn = slapi_ch_smprintf("%s=%s,%s", SLAPI_ATTR_UNIQUEID, uniqueid, entryrdn);

becomes

    tombstone_rdn = slapi_create_dn_string("%s=%s+%s",SLAPI_ATTR_TOMBSTONEID, uniqueid, entryrdn);

and the existing function: 

    compute_entry_tombstone_dn

is only used for the tombston RUV element which is unchanged and is renamed to 

    compute_ruv_tombstone_dn

The new compute_entry_tombstone_dn now creates a proper tombstone dn:


    tombstone_dn = slapi_ch_smprintf("%s=%s+%s",
                                     SLAPI_ATTR_TOMBSTONEID,
                                     uniqueid,
                                     entrydn);

### Handle tombstoneID attribute

When a tombstone with the new RDN is created the new attribute tombstoneID needs to be added to the entry to get a correct entry.
When a tombstone is resurrected this attribute nees to be removed along with the other tombstone specific attributes


### Manage nested tombstones

The problem with nested tombstones is that if an entry which has tombstone children is deleted these 
children need to be renamed like children in a MODRDN operation. We implement a variant of the existing

    entryrdn_rename_subtree()

    as

    entryrdn_rename_subtombstones()

and whenever an entry with tombstone children is deleted the entryrdn index is coorrected

### Remove tombstone children from cache

A further problem with nested tombstones is that the entryrdn_rename_subtombstones() function does update the
entryrdn index it does not affect tombstone child entries which are in the entry cache and a search could return 
entries with the old, now incorrect, dn.

Fortunately this problem exists in MODRDN and is solved there. It loads all child entries of a renamed entry in the
entry cache and the removes them from the cache, so the cache is cleared.
The existing static function to load the children into the entry cache:

    IDList *moddn_get_children(back_txn *ptxn, Slapi_PBlock *pb, backend *be, struct backentry *parententry, Slapi_DN *parentdn, struct backentry ***child_entries, struct backdn ***child_dns, int is_resurect_operation);

is made public and the code to remove the entries from the cache, which exists in two slightly different forms in ldbm_modrdn.c is put into a now public function:

    void moddn_remove_children_from_cache(ldbm_instance *inst, struct backentry **child_entries, struct backdn **child_dns, int is_resurect_operation);

 

## Backward compatibility

The proposed changes do only affect new tombstones, the existing code for special handling of old tombstone RDNs is not removed, but only triggered by existing tombstones.
WE look into two specific areas of potentially existence of mixed versions of tombstones.

### Tombstone purging

Tombstone purging is searching tombstones based on (objectclass=nstombstone) and (nstombstonecsn<= ...). Both attributes are not affected by the changes and the deletion of the found entries doe work for
both naming schemes. The new version can be installed over an instance with existing tombstones and the old tombstones will be purged


### LDIF Import with Old Tombstones

If a ldif file contains tombstones following the old naming scheme these tombstones will be imported correctly

### Behaviour in replication topologies with older versions

Tombstones are maintained locally, so each server can have its own method to handle and name tombstones.

But in replication initialization the tombstones are included as well and the receiving server needs to be able to handle them. With online initialization from
a server with this new naming scheme to an older one it will work as no schema checking is done. Also if the "schema learning" works correctly there will be no prolems.

For offline initialization there is no schema update and import can fail because of "tombstoneID not allwed". The schema woul have to be managed by an administrativ task.

Related Ticket/Bug
------------------

* Ticket [\#49507](https://pagure.io/389-ds-base/issue/49507) tombstone dn format is not technically correct
* Ticket [\#49615](https://pagure.io/389-ds-base/issue/49615) dn of nested tombstones is incorrect
