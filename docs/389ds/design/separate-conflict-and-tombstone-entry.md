---
title: "Separate Conflict and Tombstone Entry"
---

# Separate Conflict and Tombstone Entry
-------------------------------------

{% include toc.md %}

### Entry format

#### conflict entry:

       Current format

       dn: nsuniqueid=<UNIQID>+<RDN>,<PARENTDN>
       <attr>: <value>
       [...]    
       nsds5ReplConflict: namingConflict <DN>

       proposing format (internal; Slapi_Entry)
       dn: <RDN>,<PARENTDN>
       objectclass: nsConflict    
       <attr>: <value>
       [...]    
       nsdsEntryType: 1    
       nsds5ReplConflict: namingConflict <DN>

       proposing format (external; search result/exported)
       dn: nsuniqueid=<UNIQID>+<RDN>,<PARENTDN>
       objectclass: nsConflict    
       <attr>: <value>
       [...]    
       nsdsEntryType: 1    
       nsds5ReplConflict: namingConflict <DN>     

#### tombstone entry:

       current format
       dn: nsuniqueid=<UNIQID>,<RDN>,<PARENTDN>
       objectclass: nsTombstone    
       <attr>: <value>
       [...]    

       proposing format (internal; Slapi_Entry)
       dn: <RDN>,<PARENTDN>
       objectclass: nsTombstone    
       <attr>: <value>
       [...]    
       nsdsEntryType: 2    

       proposing format (external; search result/exported)
       dn: nsuniqueid=<UNIQID>,<RDN>,<PARENTDN>
       objectclass: nsTombstone    
       <attr>: <value>
       [...]    
       nsdsEntryType: 2    

#### ordinary entry (no changes):

       dn: <RDN>,<PARENTDN>
       <attr>: <value>
       [...]    

### Goal

#### General

-   Separate conflict entries and tombstone entries from ordinary entries.
-   No change in the DN of the conflict entry and the tombstone entry in the DB (id2entry.db/entryrdn.db).
-   The entries remain in id2entry.db with system attribute specifying the type:
    -   no type (or nsdsEntryType: 0) is for the ordinary entry
    -   nsdsEntryType: 1 for conflict
    -   nsdsEntryType: 2 for tombstone, for instance

> The system attribute nsdsEntryType is single-valued and integer. The motivation to have this system attribute is speeding up the entry type checking especially for the search-all "(objectclass=\*)" case. We have the type info in the objectclass with the string value "nsConflict/nsTombstone". But checking the type using the string would be much slower than checking the integer value.

-   Add conflict\_entryrdn for the conflict entry and tombstone\_entryrdn for the tombstone entry. DN of the ordinary entries are managed in the entryrdn index; the conflict entries are in the conflict\_entryrdn index / the tombstone entries are in the tombstone\_entryrdn index.
-   Add "objectclass: nsConflict" for the conflict entry as "objectclass: nsTombstone" for the tombstone entry.
-   The internal entry does not include the special "nsuniqueid=<UNIQID>" in the DN.
-   An entry could be a conflict and a tombstone entry at the same time. The entry would look like this and the RDN list is both in the conflict\_entryrdn and tombstone\_entryrdn.

        dn: <RDN>,<PARENTDN>
         objectclass: nsConflict    
         objectclass: nsTombstone    
         <attr>: <value>
         [...]    
         nsdsEntrytype: 3 <== 1 | 2    
         nsds5ReplConflict: namingConflict <DN>     

-   We may not put the conflict / tombstone entry and its DN into the entry / DN cache not to waste the memory with the less prioritized objects, respectively.

#### Search

-   Search requires "(objectclass=nsConflict)" / "(objectclass=nsTombstone)" in the filter to return the conflict / tombstone entry, respectively.
-   DN in the returned entry has the following format to support multiple conflict/tombstone entries originated from the same DN.
    -   **conflict entry** nsuniqueid=<UNIQID>+<RDN>,<PARENTDN>
    -   **tombstone entry** nsuniqueid=<UNIQID>,<RDN>,<PARENTDN>
-   BaseDN in the search could include the special "nsuniqueid=<UNIQID>". In the current plan, both 2 cases return the same entry:

case 1 
     BaseDN: "nsuniqueid=<UNIQID>+<RDN>,<PARENTDN>
     Filter: (&(objectclass=nsConflict)(nsuniqueid=<UNIQID_N>))    
     case 2
     BaseDN: "<RDN>,<PARENTDN>
     Filter: (&(objectclass=nsConflict)(nsuniqueid=<UNIQID_N>))    
     Returned DN
     nsuniqueid=<UNIQID>+<RDN>,<PARENTDN>

-   The same is true for the tombstone entry.
-   Extra task for the search-all: search with "(objectclass=\*)" needs to check the nsdsEntryType value and ignore the conflict/tombstone marked entries.

#### Add conflict entry

-   Add the conflict entry with "objectclass: nsConflict" and "nsdsEntryType: 1" to id2entry.
-   Add the DN (a list of RDNs) to the conflict\_entryrdn index.
-   The conflict\_entryrdn could store the intermediate DNs which are not conflict entries. (the nodes could be marked as ordinary).

#### Delete entry/Add tombstone entry

-   Modify the entry adding "objectclass: nsTombstone" (already implemented) and "nsdsEntryType: 2" in id2entry
-   Delete the DN from the entryrdn.
-   Add the DN (a list of RDNs) to the tombstone\_entryrdn.
-   The tombstone\_entryrdn could store the intermediate DNs which are not tombstone entries. (the nodes could be marked as ordinary).

#### Export

If '-r' is added to the command line, conflict / tombstone entries are exported. The DN contains the special "nsuniqueid=<UNIQID>".

#### Import

Support the current ldif (no objectClass: nsConflict; no nsdsEntryType) as well as the new ldif.

#### Resurrection steps users take

-   If an ordinary entry with the same DN exists in the DB, delete it.
-   Modify the entry: removing "(objectclass=nsConflict)" / "(objectclass=nsTombstone)"
-   Internally, the modify is translated to.
    -   removing "(objectclass=nsConflict)" / "(objectclass=nsTombstone)"
    -   removing nsdsEntryType (if not specified)
    -   removing nsds5ReplConflict (if not specified; just for the conflict entry)
    -   removing the DN from conflict\_entryrdn / tombstone\_entryrdn, respectively.
    -   adding the DN to entryrdn.

#### Upgrade

-   Scan id2entry.
-   If an entry's RDN is "nsuniqueid=<UNIQID>+<RDN>" and nsds5ReplConflict is in the attr,
    -   rename the RDN to <RDN>
    -   add "objectclass: nsConflict"
    -   remove the DN from entryrdn and add it to conflict\_entryrdn
-   If an entry's RDN is "nsuniqueid=<UNIQID>,<RDN>" and objectclass contains "nsTombstone",
    -   rename the RDN to <RDN>
    -   remove the DN from entryrdn and add it to tombstone\_entryrdn

#### entrydn support

By setting "nsslapd-subtree-rename-switch: off" in cn=config, we could go back to the entrydn indexing. We have to introduce extra index files: conflict\_entrydn and tombstone\_entrydn, as well.

#### Internal format

To support the multiple conflict / tombstone entries having the same original DN, we allow entries having the same RDN and parentid in id2entry. (Note: the conflict / tombstone entries only)

       dbscan -f id2entry.db output    
       id N    
           rdn: <RDN>
           nsuniqueid: <UNIQID_N>
           parentid: M    
           entryid: N    

       id N+1    
           rdn: <RDN>
           nsuniqueid: <UNIQID_N+1>
           parentid: M    
           entryid: N+1    

Plus conflict\_/tombstone\_entryrdn should be able to store a list of entryids instead of one. (Again, this is only for the conflict/tombstone entries.)

#### Another approach to use the special suffix: The following change could be considered

       conflict entry
       dn: <RDN>,<PARENTDN>,<CONFLICTSUFFIX>
       objectclass: nsConflict    
       <attr>: <value>
       [...]    
       entrytype: 1    

       tombstone entry
       dn: <RDN>,<PARENTDN>,<TOMBSTONESUFFIX>
       objectclass: nsTombstone    
       <attr>: <value>
       [...]    
       entrytype: 2    

       Comments on this approach

> -   Adding the conflict / tombstone entry looks like a move in DIT, but it is not a move in terms of DN (since the original <SUFFIX> itself is not moved to <CONFLICTSUFFIX> or <TOMBSTONESUFFIX>, but a delete + add.
> -   ldbm\_entryrdn code needs to have a knowledge about the special suffixes; currently, it only takes one "suffix".
> -   One entryrdn index file instead of 3 (entryrdn, conflict\_entryrdn, tombstone\_entryrdn).
> -   Search with -b "<CONFLICTSUFFIX>" / "<TOMBSTONESUFFIX>" is executed on multiple backends if there are multiple.

Related Ticket/Bug
------------------

Ticket \#160 -- Make replication plugin put conflicts and tombstones in a special suffix
Bug 695797 - Invalid host record created during client enrollment with failover
Bug 747701 - [RFE] Make replication plugin put conflicts in a special suffix
Bug 772294 - Replication conflicts resolution

