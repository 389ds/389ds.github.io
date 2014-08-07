---
title: "Subtree Rename Design"
---

# Subtree Rename Design
-----------------------

{% include toc.md %}

Background
----------

Red Hat/389 Directory Server has not supported moving subtree to the new superior (1) nor renaming an RDN which has subordinates (2). These features have been requested by internal and external customers.
1) Moving subtree to a new superior

    $ ldapmodify -D "cn=Directory Manager" -w password
    dn: uid=VLeBaron, ou=Payroll, l=France, dc=example, dc=com
    changetype: modrdn
    newrdn: uid=VLeBaron
    deleteoldrdn: 0
    newsuperior: ou=Accounting, l=France, dc=example, dc=com
    modifying RDN of entry uid=VLeBaron, ou=Payroll, l=France, dc=example, dc=com and/or moving it beneath a new parent
    ldap_rename: DSA is unwilling to perform
    ldap_rename: additional info: server does not support moving of entries

2) Renaming non-leaf entry

    $ ldapmodify -D "cn=Directory Manager" -w password
    dn: ou=Payroll, l=France, dc=example,dc=com
    changetype: modrdn
    newrdn: ou=Finance
    deleteoldrdn: 0
    modifying RDN of entry ou= Finance, l=France, dc=example,dc=com
    ldap_rename: Operation not allowed on nonleaf

### Current implementation (older or equal to RHDS8.x | 389DS1.2.5)

In the current implementation, the backend db stores full DN as a string in the primary db file (id2entry.db4):

    # dn: preserves what users input    
    dn: ou=Accounting,dc=example,dc=com    
    # entrydn: normalized dn, which matches the key of the entrydn index    
    entrydn: ou=accounting,dc=example,dc=com    

as well as in the entrydn index file (entrydn.db4):

    # normalized dn: equality indexed       entry id    
    =ou=accounting,dc=example,dc=com        2    

Having these full DN strings in each entry and index key, moving a subtree / renaming a non-leaf entry would be costly since every single entry and index key which are affected need to be modified. To solve the problem, entries in the primary db file could have just the RDN (not having entrydn attribute) and instead of using entrydn as a key to look up the entry id, creating a special tree structured index file. We call the index file entryrdn.

New Implementation
------------------

### subtree rename switch

In the configuration file dse.ldif, the backend configuration entry "cn=config,cn=ldbm database,cn=plugins,cn=config" has a switch "nsslapd-subtree-rename-switch" as follows:

    dn: cn=config,cn=ldbm database,cn=plugins,cn=config    
    [...]    
    nsslapd-subtree-rename-switch: on    

If the value is on, the entryrdn index is generated and used instead of entrydn. If off, the entrydn index is used. When the server starts up it checks the existence of the index files and the value of nsslapd-subtree-rename-switch. If they mismatch, the server logs an error and does not start.

    nsslapd-subtree-rename-switch: on and the entryrdn.db4 does not exist:    
     nsslapd-subtree-rename-switch is on, while the instance <inst_name> is in the DN format.     
     Please run dn2rdn to convert the database format.    
     nsslapd-subtree-rename-switch: off and the entrydn.db4 does not exist:    
      nsslapd-subtree-rename-switch is off, while the instance <inst_name> is in the RDN format.    
      Please change the value to on in dse.ldif.    

An utility dn2rdn is provided to convert entrydn to entryrdn. See below.

All the codes related to this subtree-rename change are supposed to be in the if clause that entry\_get\_switch() is true as follows:

    if (entryrdn_get_switch()) {    
        subtree-rename related code
    }    

### Entryrdn index

Entryrdn index file stores the double linked tree structure. Operations such as subtree move and rename non-leaf node is done by updating the links. The index provides the way to get the entry id from the full DN, look up full DN with RDN and entry id, and so on.

Here is the sample tree in the server:

    dn: dc=example,dc=com    
    dn: cn=Directory Administrators,dc=example,dc=com    
    dn: ou=Groups,dc=example,dc=com    
    dn: ou=People,dc=example,dc=com    
    dn: cn=Accounting Managers,ou=Groups,dc=example,dc=com    
    dn: uid=tuser0,ou=People,dc=example,dc=com    

The index is stored in the index file called entryrdn.db4:

    /var/lib/dirsrv/slapd-ID/db/userRoot/entryrdn.db4    

The contents of the file looks like this (This is the output from the dbscan utility -- explained later):

    dc=example,dc=com    
     ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C1:dc=example,dc=com    
       ID: 2; RDN: "cn=Directory Administrators"; NRDN: "cn=directory administrators"    
    2:cn=directory administrators    
       ID: 2; RDN: "cn=Directory Administrators"; NRDN: "cn=directory administrators"    
    P2:cn=directory administrators    
       ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C1:dc=example,dc=com    
       ID: 3; RDN: "ou=Groups"; NRDN: "ou=groups"    
    3:ou=groups    
       ID: 3; RDN: "ou=Groups"; NRDN: "ou=groups"    
    P3:ou=groups    
       ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C3:ou=groups    
         ID: 6; RDN: "cn=Accounting Managers"; NRDN: "cn=accounting managers"    
    6:cn=accounting managers    
         ID: 6; RDN: "cn=Accounting Managers"; NRDN: "cn=accounting managers"    
    P6:cn=accounting managers    
         ID: 3; RDN: "ou=Groups"; NRDN: "ou=groups"    
    C1:dc=example,dc=com    
       ID: 4; RDN: "ou=People"; NRDN: "ou=people"    
    4:ou=people    
       ID: 4; RDN: "ou=People"; NRDN: "ou=people"    
    P4:ou=people    
       ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C4:ou=people    
         ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    10:uid=tuser0    
         ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    P10:uid=tuser0    
         ID: 4; RDN: "ou=People"; NRDN: "ou=people"    

There are 3 kinds of keys: Self, Child and Parent. Self key is a string made from entry id and RDN separated by ':' "entry\_id:rdn". The value for the key is "rdn\_elem" (shown below), which is made from the entry\_id, RDN and normalized RDN. In this doc, the self key-value pair is called self link. This is a self link example:

    4:ou=people    
       ID: 4; RDN: "ou=People"; NRDN: "ou=people"    

Suffix (dc=example,dc=com, in this example) is an exception. It does not have "entry\_id:" part in the key to distinguish it from the rest of the keys.

Child key is a string starting with the character 'C' followed by "entry\_id:rdn". The value is "rdn\_elem" which stores the child's entry\_id, RDN and normalized RDN. There could be as many children as needed. In this doc, the Child key-value pair is called child link. This is a child link example.

    C4:ou=people    
         ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    

Parent key is a string starting with the character 'P' followed by "entry\_id:rdn". The value is "rdn\_elem" which stores the parent's entry\_id, RDN and normalized RDN. There is only one parent per each entry. In this doc, the Parent key-value pair is called parent link. This is a parent link example.

    P4:ou=people    
       ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    

#### entryrdn index data

The entryrdn index is implemented in the file ldap/servers/slapd/back-ldbm/ldbm\_entryrdn.c. The structure for the value (rdn\_elem) is declared in the file.

    typedef struct _rdn_elem {    
       char rdn_elem_id[sizeof(ID)];    
       char rdn_elem_nrdn_len[2]; /* ushort; length including '\0' */    
       char rdn_elem_rdn_len[2];  /* ushort; length including '\0' */    
       char rdn_elem_nrdn_rdn[1]; /* "normalized rdn" '\0' "rdn" '\0' */    
    } rdn_elem;    

The entryrdn value stored in the entryrdn index is marshaled. And when retrieved from the index, the data is un-marshaled and passed to the caller. By marshaling, rdn\_entry containing type ID and unsigned short in rdn\_elem could be put at any location in the memory without causing any alignment problem. This is useful to use MULTIPLE read functionality in the Berkeley DB. To Marshall/unmarshal ID, id\_internal\_to\_stored/id\_stored\_to\_internal is used. To marshal/unmarshal rdn/nrdn lengths (dn\_elem\_rdn\_len, rdn\_elem\_nrdn\_len), similar helper functions sizeushort\_internal\_to\_stored/sizeushort\_stored\_to\_internal are introduced. (See also Bug [616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments).

##### <a name="warning"></a> warning: upgrade from 389 v1.2.6 (a?, rc1 \~ rc6) to v1.2.6 rc6 or newer

Marshallng entryrdn data has been introduced since v1.2.6 rc6. If you upgrade from older v1.2.6 to v1.2.6 rc6 or newer, there will be an entryrdn index mismatch and it should be fixed as follows.
1. yum update 389-ds-base to upgrade to 389-ds-base-1.2.6-0.?.rc6.OS.ARCH or newer
2. Check /var/log/dirsrv/slapd-ID/errors. It'd contain errors related to the entryrdn mismatches:

    [..] - 389-Directory/1.2.6.rc6.VERSION BUILDINFO starting up    
    [..] - dn2entry: the dn "dc=example,dc=com" was in the entryrdn index, but it did not exist in id2entry of instance userRoot.    
    [..] - dn2entry: the dn "o=netscaperoot" was in the entryrdn index, but it did not exist in id2entry of instance NetscapeRoot.    
           ...    

3. Go to the DB instance directories and rename entryrdn.db4 as follows (repeat it on all the db instances):

    # cd /var/lib/dirsrv/slapd-ID/db/NetscapeRoot/    
    # mv entryrdn.db4 /safe/backup/dir/entryrdn.db4.bak    
    # cd /var/lib/dirsrv/slapd-ID/db/usrRoot/    
    # mv entryrdn.db4 /safe/backup/dir/entryrdn.db4.bak    
      ...    

4. Export the contents of DBs (repeat it on all the db instances):

    # cd /usr/lib[64]/dirsrv/slapd-ID    
    # ./db2ldif -n NetscapeRoot    
    Exported ldif file: /var/lib/dirsrv/slapd-ID/ldif/ID-NetscapeRoot-DATE.ldif    
    # ./db2ldif -n userRoot    
    Exported ldif file: /var/lib/dirsrv/slapd-ID/ldif/ID-userRoot-DATE.ldif    
      ...    

5. Import the exported ldif files (repeat it on all the DB instances):

    # ./ldif2db -n NetscapeRoot -i /var/lib/dirsrv/slapd-ID/ldif/ID-NetscapeRoot-DATE.ldif    
    # ./ldif2db -n userRoot -i /var/lib/dirsrv/slapd-ID/ldif/ID-userRoot-DATE.ldif    
      ...    

6. Start the server

    # ./start-slapd or service dirsrv start    

7. Check /var/log/dirsrv/slapd-ID/errors.

#### APIs available in the back-ldbm plugin

    void entryrdn_set_switch(int val);    

This function entryrdn\_set\_switch sets the integer value *val* to entryrdn\_switch, which is declared as a static variable in ldbm\_entryrdn.c. If *val* is non-zero, the entryrdn index is used and moving subtree and/or renaming an RDN which has children is enabled. If *val* is zero, the entrydn index is used.

    int entryrdn_get_switch();    

This function entryrdn\_get\_switch gets the value of entry\_switch. All the entryrdn related codes are supposed to be in the if (entryrdn\_get\_switch()) clauses.

    int entryrdn_compare_dups(DB *db, const DBT *a, const DBT *b);    

This function entryrdn\_compare\_dups is passed to the Berkeley DB library and used to sort the duplicated values under the same key. The child links in the entryrdn has a key "C\#\#:normalized\_rdn" (e.g., "C5:ou=people") and all the children under ou=people are stored as the values for the key. The values are sorted in the database using this compare function.

    int entryrdn_index_entry(backend *be, struct backentry *e, int flags, back_txn *txn);    

This function entryrdn\_index\_entry adds/deletes links (self, child, and parent) associated with the given entry *e* depending upon the flags (BE\_INDEX\_ADD or BE\_INDEX\_DEL). **ADD**: It starts from the suffix in the entryrdn index following the child links to the bottom. If the target leaf node does not exist, the nodes (the child link of the parent node and the self link) are added. **DEL**: It checks the existence of the target self link (key *entry\_id:RDN*; value entry\_id,RDN,normalized RDN) in the entryrdn index. If it exists and it does not have child links, then it deletes the parent's child link and the self link.

    int entryrdn_index_read(backend *be, const Slapi_DN *sdn, ID *id, back_txn *txn);    

This function entryrdn\_index\_read finds out the entry\_id of the given DN *sdn*. It starts from the suffix in the entryrdn index following the child links to the bottom. If it is successful, the entry\_is of the target node is set to the address that the argument *id* points to.

    int entryrdn_rename_subtree(backend *be, const Slapi_DN *oldsdn, Slapi_RDN *newsrdn, const Slapi_DN *newsupsdn, ID id, back_txn *txn);    

This function entryrdn\_rename\_subtree renames and/or moves the given subtree. The second argument *oldsdn* is the DN to be moved/renamed. In the modrdn operation, the value of newrdn is set to this third argument *newsrdn*. If the new RDN is not the same as the leaf RDN in the original DN *oldsdn*, the original RDN is renamed to the new RDN. If the newsuperior is set in the modrdn operation, the value is set to the fourth argument *newsupsdn*. If the value is non-zero, the original leaf RDN is moved under the new superior relinking the parent and child links.

    int entryrdn_get_subordinates(backend *be, const Slapi_DN *sdn, ID id, IDList **subordinates, back_txn *txn);    

This function entryrdn\_get\_subordinates gathers the entry\_ids of the subordinates of the given DN *sdn* which entry\_id is *id*. It returns them in the ID list format. The output ID list subordinates include the direct children as well as the indirect subordinates.

    int entryrdn_lookup_dn(backend *be, const char *rdn, ID id, char **dn, back_txn *txn);    

This function entryrdn\_lookup\_dn generates and returns the DN *dn* from the RDN *rdn* and its entry\_id *id* by looking up the entryrdn index.

    int entryrdn_get_parent(backend *be, const char *rdn, ID id, char **prdn, ID *pid, back_txn *txn);    

This function entryrdn\_get\_parent finds out and returns the parent's RDN *prdn* and entry\_id *pid* from the RDN *rdn* and its entry\_id *id*.

### Slapi\_Entry

Slapi\_Entry is defined as "struct slapi\_entry" in slap.h. The following field is added to store the RDN of the entry. "struct slapi\_rdn" is typedef'ed to Slapi\_RDN.

       struct slapi_rdn e_srdn;     /* RDN of this entry */    

Slapi\_RDN/struct slapi\_rdn has been also modified to support processing entryrdn. It could hold the array of RDNs and normalized RDNs, which are corresponding to DN and normalized DN. Order of the array is the same as in DN. (Leaf RDN is at the index 0 of the array and the suffix is at the last of the array.) Note that if the suffix include ',' in it (e.g., dc=example,dc=com), it's correctly handled by querying to the mapping tree module.

     struct slapi_rdn    
     {    
        unsigned char flag;    
        char *rdn;    
        char **rdns;       /* Valid when FLAG_RDNS is set. */    
        int butcheredupto; /* How far through rdns we've gone converting '=' to     
    +   char *nrdn;        /* normalized rdn */    
    +   char **all_rdns;   /* Valid when FLAG_ALL_RDNS is set. */    
    +   char **all_nrdns;  /* Valid when FLAG_ALL_NRDNS is set. */    
     };    

### id2entry, slapi\_entry2str\_with\_options, slapi\_str2entry\_ext

The id2entry layer (back-ldbm/id2entry.c) with slapi\_entry2str/str2entry is one of the main places that absorbs the entryrdn changes. The Berkeley DB database stores the entries only with the RDN in the primary db file (id2entry.db4). When an entry is read from the primary database, the non-formatted data includes the RDN and the entry id. (On the other hand, it contains the full DN in the previous implementation.) The id2entry looks up the entryrdn index with the RDN and the entry id (calling entryrdn\_lookup\_dn) and get the full DN. The returned DN is set to the entry (Slapi\_Entry). Once it's set, the entry has no difference from the ones in the previous implementation. Thus, layers above the id2entry layer could remain the same.

The API slapi\_entry2str\_with\_options is used to generate the non formatted data to store in the database (see id2entry\_add\_ext in back-ldbm/id2entry.c). A flag SLAPI\_DUMP\_RDN\_ENTRY was added to generate a non-formatted data that only contains RDN. The data is stored in the primary database (id2entry.db4).

To convert the non-formatted data to the Slapi\_Entry formatted entry, an API slapi\_str2entry\_ext was added. The API takes DN in addition to the non-formatted entry data and creates Slapi\_Entry. To get DN, first the DN cache is examined. If it's no in the cache, it looks up the entryrdn index using an API entryrdn\_lookup\_dn (see id2entry in back-ldbm/id2entry.c).

### dn cache

Since creating a full DN from an RDN and its entry\_id is an expensive operation, a DN cache is prepared. It uses the same cache APIs and hash algorithm that the entry cache depends upon. The entry cache caches the "struct backentry", while the dn cache caches the "struct backdn". Both structures must start with the same fields as the backcommon structure. The first field ep\_type is used to specify the item is an entry or a dn. The entry cache is made from an entry\_id hash table, a DN hash table, and additionally a UUID hash table. On the other hand, the DN cache only uses an ID hash table -- an entry\_id is given and the corresponding DN is returned. When a DN is returned from the DN cache, it is not supposed to refer by the address, but to duplicate and refer the copy. The DN extracted from the DN cache by dncache\_find\_id should be returned to the cache by CACHE\_RETURN immediately and the memory management should be left to the LRU algorithm in the cache module.

### Utilities

#### db2ldif, db2ldif.pl

The utilities db2ldif and db2ldif.pl export the contents of the database. The exported ldif file should be able to import back to the server. When the server did not support the subtree move in the previous implementation, there was a implicit rule that a parent entry's entry\_id was less than the child's entry\_id since when an entry was added, ancestor entries had to be in the database. Otherwise, the add operation failed. We cannot expect the rule is correct, any more.

Here is an example. We have one user and two organizational units under the suffix (all has parentid: 1).

    $ dbscan -f id2entry.db4    
    id 1007    
           rdn: uid=tuser0    
           uid: tuser0    
              ...    
           parentid: 1    
           entryid: 1007    
    id 1008    
           rdn: ou=sub ou0    
           ou: sub ou0    
              ...    
           parentid: 1    
           entryid: 1008    
             
    id 1009    
           rdn: ou=test ou0    
           ou: test ou0    
              ...    
           parentid: 1    
           entryid: 1009    

Move ou=sub ou0 under ou=test ou0

    $ ldapmodify -D 'cn=directory manager' -w password
    dn: ou=sub ou0,dc=example,dc=com    
    changetype: modrdn    
    newrdn: ou=sub ou0    
    deleteoldrdn: 0    
    newsuperior: ou=test ou0,dc=example,dc=com    
    modifying RDN of entry ou=sub ou0,dc=example,dc=com and/or moving it beneath a new parent    

Move uid=tuser0,dc=example,dc=com under ou=sub ou0.

    dn: uid=tuser0,dc=example,dc=com    
    changetype: modrdn    
    newrdn: uid=tuser0    
    deleteoldrdn: 0    
    newsuperior: ou=sub ou0,ou=test ou0,dc=example,dc=com    
    modifying RDN of entry uid=tuser0,dc=example,dc=com and/or moving it beneath a new parent    

Now the contents of the primary db id2entry.db4 have been modified as followed:

    $ ldapsearch -b "ou=test ou0,dc=example,dc=com" "(objectclass=*)" dn    
    dn: uid=tuser0,ou=sub ou0,ou=test ou0,dc=example,dc=com    
    dn: ou=sub ou0,ou=test ou0,dc=example,dc=com    
    dn: ou=test ou0,dc=example,dc=com    

If these entries are exported in this order, the ldif file cannot be used to import since when importing uid=tuser0, the parent (and its parent) are not in the database yet. The utility db2ldif and db2ldif.pl checks whether the parent's entry id is greater than the being exported entry id. If it is larger, then export the parents before the child.

    $ ./db2ldif -n userRoot    
    # entry-id: 1009    
    dn: ou=test ou0,dc=example,dc=com    
    ou: test ou0    
       ...    
    # entry-id: 1008    
    dn: ou=sub ou0,ou=test ou0,dc=example,dc=com    
    ou: sub ou0    
       ...    
    # entry-id: 1007    
    dn: uid=tuser0,ou=sub ou0,ou=test ou0,dc=example,dc=com    
    uid: tuser0    
       ...    

The exported ldif file has no problem to be used for the import:

    $ ./ldif2db -n userRoot -i /var/lib/dirsrv/slapd-ID/ldif/ID-userRoot-2010_01_12_105433.ldif    

Once reimported, the order of the entry id's is adjusted and children are placed after their parents.

    $ dbscan -f id2entry.db4    
    id 1007    
           rdn: ou=test ou0    
              ...    
           entryid: 1007    
    id 1008    
           rdn: ou=sub ou0    
              ...    
           parentid: 1007    
           entryid: 1008    
    id 1009    
           rdn: uid=tuser0    
              ...    
           parentid: 1008    
           entryid: 1009    

There is another requirement for db2ldif, which is the utility should be able to export without a help from the secondary indexes. In this implementation, each entry in the primary db id2entry.db4 does not have the full DN but just the RDN. The full DN is normally extracted from the entryrdn index. To support the case when the index is corrupted, db2ldif is coded to work with as well as without the entryrdn. If the entryrdn is not available, it uses the parentid in the entry to find out the parent entry. (Note: It should be much slower than using entryrdn.)

    # mv /var/lib/dirsrv/slapd-ID/db/userRoot/entryrdn.db4 /tmp    
    # ./db2ldif -n userRoot    
    Exported ldif file: /var/lib/dirsrv/slapd-ID/ldif/ID-userRoot-2010_01_12_111319.ldif    
    ldiffile: /var/lib/dirsrv/slapd-ID/ldif/ID-userRoot-2010_01_12_111319.ldif    
    [12/Jan/2010:11:13:19 -0800] - export userRoot: Processed 1009 entries (100%).    
    [12/Jan/2010:11:13:19 -0800] - All database threads now stopped    

#### db2index and db2index.pl

The reindex utilities db2index and db2index.pl share the same issues -- parents may be located after the children in the db, and the entryrdn index cannot be used to reindex itself. The same technique used by db2ldif(.pl) is shared with db2index(.pl), which allows the utilities to reindex even if the parents' entry id is greater than the children's. Also, if the entryrdn index is corrupted, it could be recreated.

    $ mv /var/lib/dirsrv/slapd-ID/db/userRoot/entryrdn.db4 /tmp    
    $ ./db2index -n userRoot -t entryrdn    
        ...    
    [12/Jan/2010:11:26:10 -0800] - userRoot: Indexed 1000 entries (99%).    
    [12/Jan/2010:11:26:10 -0800] - userRoot: Finished indexing.    
    [12/Jan/2010:11:26:10 -0800] - All database threads now stopped    
    $ dbscan -f entryrdn.db4 -k "1007:ou=test ou0"    
    1007:ou=test ou0    
     ID: 1007; RDN: "ou=test ou0"; NRDN: "ou=test ou0"    
    C1007:ou=test ou0    
       ID: 1008; RDN: "ou=sub ou0"; NRDN: "ou=sub ou0"    
    1008:ou=sub ou0    
       ID: 1008; RDN: "ou=sub ou0"; NRDN: "ou=sub ou0"    
    P1008:ou=sub ou0    
       ID: 1007; RDN: "ou=test ou0"; NRDN: "ou=test ou0"    
    C1008:ou=sub ou0    
         ID: 1009; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    1009:uid=tuser0    
         ID: 1009; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    P1009:uid=tuser0    
         ID: 1008; RDN: "ou=sub ou0"; NRDN: "ou=sub ou0"    

#### dbscan

The db dump utility dbscan is extended to support the entryrdn index format. If just "-f entryrdn.db4" is given, the key value pairs are printed out in the order stored in the index file.

    # dbscan -f     *    /path_to/    *    entryrdn.db4    
    10:uid=tuser0    
      ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    2:cn=directory administrators    
      ID: 2; RDN: "cn=Directory Administrators"; NRDN: "cn=directory administrators"    
    3:ou=groups    
      ID: 3; RDN: "ou=Groups"; NRDN: "ou=groups"    
    [...]    

If -k *top\_key* is added to it, the tree structure is printed starting from the *top\_key*.

*top_key* is the suffix:

    # dbscan -f     *    /path_to    *    /entryrdn.db4 -r -n -k "dc=example,dc=com"    
    dc=example,dc=com    
      ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C1:dc=example,dc=com    
        ID: 2; RDN: "cn=Directory Administrators"; NRDN: "cn=directory administrators"    
    2:cn=directory administrators    
        ID: 2; RDN: "cn=Directory Administrators"; NRDN: "cn=directory administrators"    
    P2:cn=directory administrators    
        ID: 1; RDN: "dc=example,dc=com"; NRDN: "dc=example,dc=com"    
    C1:dc=example,dc=com    
        ID: 3; RDN: "ou=Groups"; NRDN: "ou=groups"    
    [...]    

*top\_key* is a non-leaf node: (note: you have to include the "*entry\_id*:" string in the *top\_key* for the non-suffix RDN.)

    # dbscan -f     *    /path_to    *    /entryrdn.db4 -r -n -k "4:ou=people"         
    4:ou=people    
      ID: 4; RDN: "ou=People"; NRDN: "ou=people"    
    C4:ou=people    
        ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    10:uid=tuser0    
        ID: 10; RDN: "uid=tuser0"; NRDN: "uid=tuser0"    
    P10:uid=tuser0    
        ID: 4; RDN: "ou=People"; NRDN: "ou=people"    

#### dn2rdn

The utility dn2rdn converts the full DN formatted id2entry.db4 + entrydn index into the RDN formatted id2entry.db4 + entryrdn index.

Before:

    $ ls /var/lib/dirsrv/slapd-ID/db/userRoot/entry*    
    /var/lib/dirsrv/slapd-ID/db/userRoot/entrydn.db4    
    $ dbscan -f /path/to/id2entry.db4    
    id 1    
           dn: dc=example,dc=com    
              ...    
    id 2    
           dn: ou=Accounting,dc=example,dc=com    
              ...    
    id 3    
           dn: ou=Product Development,dc=example,dc=com    
              ...    

Turn on nsslapd-subtree-rename-switch:

    dn: cn=config,cn=ldbm database,cn=plugins,cn=config    
       ...    
    nsslapd-subtree-rename-switch: on    

Run dn2rdn.

    $ /usr/lib{64}/dirsrv/slapd-ID/dn2rdn    

After:

    $ ls /var/lib/dirsrv/slapd-ID/db/userRoot/entry*    
    /var/lib/dirsrv/slapd-ID/db/userRoot/entryrdn.db4    
    $ dbscan -f /path/to/id2entry.db4    
    id 1    
           rdn: dc=example,dc=com    
              ...    
    id 2    
           rdn: ou=Accounting    
              ...    
    id 3    
           rdn: ou=Product Development    
              ...    

### ancestorid investigation

The index ancestorid stores the information which could be replaced with the entryrdn. A non-public configuration parameter nsslapd-noancestorid is introduced to compare the pros and cons. Here is the quick comparison. Without the ancestorid, import and add are slightly faster. But the search before the cache is warmed up shows the significant performance degradation. Thus, I concluded that keeping the ancestorid index is preferable.

    import 10k entries    
       with ancestorid (nsslapd-noancestorid: off)    
       real    0m6.970s    
       user    0m14.901s    
       sys    0m0.611s    
       no ancestorid (nsslapd-noancestorid: on)    
       real    0m6.861s    
       user    0m14.956s    
       sys    0m0.617s    
    add 10k entries [cmdline: ldapmodify -a -f <add_file>"]
       with ancestorid (nsslapd-noancestorid: off)    
       real    3m8.513s    
       user    0m0.754s    
       sys    0m0.241s    
       no ancestorid (nsslapd-noancestorid: on)    
       real    2m58.401s    
       user    0m0.714s    
       sys    0m0.226s    
    Random search using rsearch [cmdline: rsearch -p 10389 -s "dc=example,dc=com" -i <uid_file> -f "(uid=%s)"]    
       with ancestorid (nsslapd-noancestorid: off)    
       20091217 13:47:11 - Rate: 25269.00/thr (2526.90/sec = 0.3957ms/op), total: 25269 (1 thr)    
       20091217 13:47:21 - Rate: 27728.00/thr (2772.80/sec = 0.3606ms/op), total: 27728 (1 thr)    
       20091217 13:47:31 - Rate: 27320.00/thr (2732.00/sec = 0.3660ms/op), total: 27320 (1 thr)    
       20091217 13:47:41 - Rate: 27173.00/thr (2717.30/sec = 0.3680ms/op), total: 27173 (1 thr)    
       20091217 13:47:51 - Rate: 26688.00/thr (2668.80/sec = 0.3747ms/op), total: 26688 (1 thr)    
       no ancestorid (nsslapd-noancestorid: on)    
       20091217 13:54:59 - Rate: 23543.00/thr (2354.30/sec = 0.4248ms/op), total: 23543 (1 thr)    
       20091217 13:55:09 - Rate: 27787.00/thr (2778.70/sec = 0.3599ms/op), total: 27787 (1 thr)    
       20091217 13:55:19 - Rate: 27403.00/thr (2740.30/sec = 0.3649ms/op), total: 27403 (1 thr)    
       20091217 13:55:29 - Rate: 27117.00/thr (2711.70/sec = 0.3688ms/op), total: 27117 (1 thr)    
       20091217 13:55:39 - Rate: 26804.00/thr (2680.40/sec = 0.3731ms/op), total: 26804 (1 thr)    

### Notes on the valgrind output

The 389 server is run with valgrind to guarantee for the server not to have memory leaks. The tool sometimes reports warnings related to "uninitialized value(s)" as follows:

    ==4374== Conditional jump or move depends on uninitialized value(s)    
    ==4374== at 0x88A8E61: __log_putr (log_put.c:731)    
    ==4374== by 0x88A87CD: __log_put_next (log_put.c:463)    
    ==4374== by 0x88A7EFF: __log_put (log_put.c:160)    
    ==4374== by 0x883FFBC: __db_addrem_log (db_auto.c:257)    
    ==4374== by 0x88598C2: __db_pitem (db_dup.c:130)    
    ==4374== by 0x8774B50: __bam_iitem (bt_put.c:376)    
    ==4374== by 0x876D8BD: __bamc_put (bt_cursor.c:1960)    
    ==4374== by 0x8850B1C: __dbc_put (db_cam.c:1520)    
    ==4374== by 0x8860B7B: __dbc_put_pp (db_iface.c:2456)    
             ...    

These warnings are benign. Here is a comment from a Berkeley DB support: "There's nothing serious about these warnings. Those uninitialized byes are for padding purposes. Please see the "--enable-umrw" build option for the Berkeley DB libraries: <http://www.oracle.com/technology/documentation/berkeley-db/db/programmer_reference/build_unix_conf.html> and use it when building the libraries to avoid seeing these errors."

See also (http://forums.oracle.com/forums/thread.jspa?messageID=3973943&\#3973943).

Related Bugs
------------

Bug [171338](https://bugzilla.redhat.com/show_bug.cgi?id=171338) - Enhancement: winsync modrdn not synced
Bug [557224](https://bugzilla.redhat.com/show_bug.cgi?id=557224) - subtree rename breaks the referential integrity plug-in
Bug [570107](https://bugzilla.redhat.com/show_bug.cgi?id=570107) - The import of LDIFs with base-64 encoded DNs fails, modrdn with non-ASCII new rdn incorrect
Bug [578296](https://bugzilla.redhat.com/show_bug.cgi?id=578296) - Attribute type entrydn needs to be added when subtree rename switch is on
Bug [616608](https://bugzilla.redhat.com/show_bug.cgi?id=616608) - SIGBUS in RDN index reads on platforms with strict alignments

ToDo's
------

. Performance measurement
. Evaluate parentid and numsubordinate indexes

