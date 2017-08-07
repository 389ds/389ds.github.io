---
title: "New Entry RDN index design"
---

# New Entry RDN index design

{% include toc.md %}

# Background
------------

The Entry RDN index was introduced to have efficient modrdn operations where subtrees are moved to a new superior.
If the dn of each entry is stored in the entry and the access to the entry by dn is managed by the entrydn index this would require to update each entry in the moved subtree and also update the entrydn index.

With the entryrdn index only the rdn of the entry is stored in the entry. This allows moving a subtree without needing to update any of its entries.

The drawback of this is that whenever an entry is read from the database its dn needs to be constructed. or if a dn is used to udentify an entry in an update operation the id corresponding to this dn needs to be determined. The entryrdn index implements these features, but

- it is very complex and has an overhead of records to be maintained in the entryrdn index
- it uses duplicate keys and the bulk load feature of BDB, which is in LMDB only supported if the values for the duplicates have the same size (which is not the case)
- it uses binary data in the values and registers its own sorting functions, this should be supported in LMDB but does not work correctly

This document proposes a new implememtation of the entryrdn index which reduces complexity and works with LMDB: no duplicat keys, no sorting of values required

# Records in database

## Parent records:

    key: eID 			# id of an entry (with children)
    value: pID, eRDN  		# parentID of the entry
				# rdn of the entry
				# format could be identical to rdn_elem struct

parent records are used to determine the DN of a given entry
if we start with an entry found by id2entry and just want to generate the dn of this entry these records are required only for entries with children

## Entry records.

Every entry is uniquely defined by its RDN and parent id.
entry records are used to find the entry id for a given dn.

    Key: eRDN;pID  	# RDN of the entry, parentID of the entry
			# alterantively : pID;eRDN , would allow range searches on pID if required)
    Value: ID;  		# the  ID of the entry

a special case is the entry record for the suffix. Key is 
    suffixDN;0


# Algorithms


## entryrdn_lookup_dn

This function is called when an entry is read from the datbase and has no DN (only RDN). If the entry is read also the parentID of the entry is available, but generating the DN has to be done after parsing the entry.

    input params: eRDN, pID

    pID = 0;
    dn = entryRDN; 
    while (pID != 0) {
        db_get (key=pID, &data);
        pID is data.pID;
        dn = concat(dn,data.pRDN)
    }
    return dn

The construction of the dn starting with an emtry could be done without a special index, the information is a available in the id2entry db itself and the dn could be constructed by recursively reading the parent entries. If the parents are in the entrycache this would be the method with the least overhead, but havibg to load a sequence of parents to generate the dn could result in a excessive cache loading.
A simple compromise without overhead would be doing just one cache lookup, no extra loading:

    if (parent = cache_find_id(pID))
        dn = concat(eRDN, parent.dn)
    else
        dn = entryrdn_lookup_dn(eRDN,pID)
    

##  entryrdn_lookup_id

This function is called when the entryID for a given DN needs to be found

params: dn

    split dn to (rdn(N),..., rdn(1),suffix)
    get (key=suffix,&data)
    id =data.id
    while (i<N) {
        db_get (key=rdn(i);id, &data)
        id = data.id;
        i++
    }
    return id;

# index operations for ldapoperations

## MOD

    nothing to do

## ADD

    add <rdn;parentid> record
    if first child add <parentid> record (can be handled when parent's numsuboridnates attribute is initialized

## DEL

    delete <rdn;parentid> record
    if last child delete <parentid> record
    TODO: tombstones

## MODRDN

### no newsuperior

    delete <oldrdn;parentid> record
    add <newrdn;parentid> record
    if entry has children
        replace <entryid> record

### newsuperior

    delete <oldrdn;parentid> record
    add <newrdn;newparentid> record
    if has children (parent.numsubordinates > 0)
        replace <entryid> record
        delete <oldrdn;oldparentid> record
        add <newrdn;newparentid> record



