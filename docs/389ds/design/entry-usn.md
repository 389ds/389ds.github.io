---
title: "Entry USN Design"
---

# Entry USN Design
------------------

{% include toc.md %}

Overview
========

Entry USN (Update Sequence Number) is a feature which adds USN to each updated entry. "Update" includes add, modify, modrdn and delete. Replicated operation is also considered as "update".

Requirements
============

1. There should be some method for LDAP clients to know "has something changed". A global counter over the Directory Server assigns Update Sequence Number on each update (add, modify, and delete).
2. A search with a filter (entryUSN \>= x) is supposed to return entries that changed since x-th update made against the server.
3. aggregate in rootDSE: There needs to be an attribute in the rootDSE that contains that last USN generated on the server. This also works like the lastChangeNumber attribute in Retro-Changelog.
4. The USN feature should be configurable.
   USN values are local to the server. USN never be replicated.
   Once Retro Change Log plugin is enabled, search on rootDSE returns the following:

        ldapsearch -b "" -s base "(objectclass=*)"
        [...]
        changeLog: cn=changelog
        firstchangenumber: 1
        lastchangenumber: 3

Design notes
============

Standalone
----------

-   ENTRYUSN OID: LDBM\_ENTRYUSN\_OID "2.16.840.1.113730.3.1.606" (defined in ldap/servers/slapd/back-ldbm/back-ldbm.h)
-   Use slapi\_counter to generate USN (Update Sequence Number).
-   The USN is local to a backend instances. I.e., one USN counter exists per backend instance (held by the backend structure: backend-\>be\_usn\_counter).
-   If USN plugin is enabled, add/modify/delete operation adds "entryusn: \#" to the target entry in the backend pre plugin (bepreop). If entryusn already exists in the entry, the value is replaced with the newly assigned one.
-   The entryusn attribute type is indexed with integerOrderingMatch (defined in template-dse.ldif.in).
-   In case the operation is delete, the deleted entry is converted to tombstone as the replication plugin does. USN plugin holds a csn generator and assign a CSN to the entry to be deleted. Csn generator requires a replica ID. USN uses the special ID 65535.
-   This release provides a tool usn-tombstone-cleanup.pl to clean up the USN tombstones.
-   When the server starts up, it reads the last key of each entryusn index file, increments by 1 and use the value as the initial value of the slapi\_counter (backend-\>be\_usn\_counter).
-   The entryusn attribute is one of the operational attributes. Clients are not allowed add/modify/delete the attribute value using ldap clients. When searched, the entryusn attribute value pair is returned only when "entryusn" is specified in the attribute list.
-   The entryusn attribute value pair will not be exported into the ldif file (by setting "nsslapd-exclude-from-export: entryusn ..." in "dn: cn=config,cn=ldbm database,cn=plugins,cn=config") to keep the exported ldif file compatible with the older DS as well as other LDAP servers. (Note: this is one of the suggestions by Andrey Ivanov.) If ldif file happens to contain the entryusn attribute value pair, import imports the pair without making any changes, which may cause some duplicated entryusn problem. Ldif files to be imported should not include entryusn.
-   Per request from users, import (ldif2db) adds "entryusn: 0" to every entry unless the entry already contains the entryusn attribute. (See also Bug [531642](https://bugzilla.redhat.com/show_bug.cgi?id=531642) - EntryUSN: RFE: a configuration option to make entryusn "global")

### Import and Replica Initialization

Entryusn value in the entries which are imported or initialized by a master are configurable. A configuration parameter nsslapd-entry-import-initval has been introduced for the purpose.

    cn=config
    ...
    nsslapd-entryusn-import-initval: VALUE | next

If the value is a *digit*, e.g., 0, 10, 100 ..., the entries will have the entryusn value. If the value is not digit, e.g., "next", the entries will have the last entryusn + 1 from the database existed before the import or the replica initialization was executed.

Sample case 1

    nsslapd-entryusn-import-initval: 123
    # ldif2db -n backend -i /path/to/ldif

    $ ldapsearch ... -b "dc=example,dc=com" "(cn=*)" entryusn
    dn: dc=example,dc=com
    entryusn: 123

    dn: ou=Accounting,dc=example,dc=com
    entryusn: 123

    dn: ou=Product Development,dc=example,dc=com
    entryusn: 123
    ...
    entryusn: 123

Sample case 2

    nsslapd-entryusn-import-initval: next
    The last entryusn value is 9.
    # ldif2db -n backend -i /path/to/ldif

    $ ldapsearch ... -b "dc=example,dc=com" "(cn=*)" entryusn
    dn: dc=example,dc=com
    entryusn: 10

    dn: ou=Accounting,dc=example,dc=com
    entryusn: 10

    dn: ou=Product Development,dc=example,dc=com
    entryusn: 10
    ...
    entryusn: 10

### Global mode

By default, entryusn is unique per backend database instance. Some users may need to assign entryusn unique per entire database. To fulfill the requirement, a configuration parameter nsslapd-entryusn-global is introduced. By default, this parameter is off. And if the parameter does not exist, that means it's off.

    cn=config
    ...
    nsslapd-entryusn-global: on|off

This configuration parameter is effective only when Entry USN plugin is enabled

    dn: cn=USN,cn=plugins,cn=config
    ...
    nsslapd-pluginEnabled: off

(See also Bug [531642](https://bugzilla.redhat.com/show_bug.cgi?id=531642) - EntryUSN: RFE: a configuration option to make entryusn "global")

The last entry USN value is available by searching rootdse. Here is the difference between the default mode and the global mode.

    Default mode
    $ /usr/lib64/mozldap/ldapsearch [...] -b "" -s base "(objectclass=*)" lastusn
    dn:
    lastusn;backend0: last_entry_usn_value_in_backend0
    lastusn;backend1: last_entry_usn_value_in_backend1
    ...

    Global mode
    $ /usr/lib64/mozldap/ldapsearch [...] -b "" -s base "(objectclass=*)" lastusn
    dn:
    lastusn: global_last_entry_usn_value

With Replication
----------------

-   Entryusn is local to the server. Thus, for instance, an added entry to Server A is replicated to Server B, the two entries have different entryusn value.
-   EntryUSN is configured not to be replicated regardless of the user's configuration. Even if it does not set in the fractional replication panel when an replication agreement is created, it will be dropped from the replicated data. See also [To Suppress Replicating EntryUSN](http://directory.fedoraproject.org/wiki/Entry_USN#To_Suppress_Replicating_EntryUSN) for more details.
-   Both USN plugin and Replication plugin converts deleted entries into tombstones. When converting, CSN is assigned to the deleted entry's DN. The CSN assigned by USN plugin is different from the one assigned by Replication plugin in terms of the replica ID. CSNs assigned by USN has 65535, which is a special replica ID used by hub. Master servers have their own Replica ID. Here's a sample scenario. Let's assume a server is running as a standalone server with USN plugin enabled. Assume the backend contains USN tombstones. Then, configure the server as a part of replication topology. Now, if you delete an entry, an EntryUSN value is assigned to the entry by USN plugin and it's converted to a tombstone by Replication plugin. That is, the server ends up having 2 different sets of tombstones -- old tombstones generated by USN plugin and new tombstones generated by Replication plugin. Both tombstones are purged by the MMR tombstone reaping. But to reduce the confusion, we recommend to clean up USN tombstones if any before configuring the server as a master/replica.
-   Recommended steps.

        1. Assuming USN is enabled.
        2. If any delete operations were done, run usn-tombstone-cleanup.pl (see below for the usage).

-   USN tombstone cleanup tool usn-tombstone-cleanup.pl fails with LDAP_UNWILLING_TO_PERFORM, if the suffix is replicated

To Suppress Replicating EntryUSN
--------------------------------

### Plugin Default Config Entry

Plugin default config entry cn=plugin default config,cn=config is introduced to store default configuration attributes. Configuration attributes could be added and retrieved dynamically. The caller which sets a configuration attribute and the getter which processes it could be different plugins.

USN plugin requires "entryusn" attribute not to be replicated. To exclude "entryusn" from the replicated attributes, we could put "entryusn" into the EXCLUDE list of nsDS5ReplicatedAttributeList in each Replication Agreement [sample format: nsDS5ReplicatedAttributeList: (objectclass=\*) \$ EXCLUDE userpassword employeetype]. An issue is when the USN plugin is started, Multimaster Replication plugin might not be enabled nor agreements might not be created yet. But there need to be some place to put the request and when the replication is configured and the agreement is generated, the replication plugin picks up the request and processes it. To solve this problem, we could use this plugin default config entry.

When USN plugin starts, it calls slapi\_set\_plugin\_default\_config with the attr value pair "nsDS5ReplicatedAttributeList: (objectclass=\*) \$ EXCLUDE entryusn", which is added to the entry.

Notes on slapi\_set\_plugin\_default\_config:

    1) If the plugin default config entry does not exist, slapi\_set\_plugin\_default\_config creates it with the given attribute value pair.
    2) If the entry exists but the given attribute does not, the attribute value pair is added to the entry.
    3) If the entry exists and the given attribute does, as well, but not the value, the attribute value pair is added to the entry. The plugin default config entry allows multi-values. The plugin which processes the values (in this case, the Multimaster Replication plugin) is responsible to take care all the values in the entry.
    4) If the entry exists, so does the given attribute value, slapi\_set\_plugin\_default\_config does not do anything.

On the Multimaster Replication plugin side, it reads the Replication Agreement to create the internal replica handle, which stores the excluded attribute list, if any. Before setting it, it gets the replicated attribute lists nsDS5ReplicatedAttributeList from the plugin default config, then merge them with the list from the Replication Agreement.

By adding "entryusn" to the EXCLUDE list of nsDS5ReplicatedAttributeList, we could use the full functionality of fractional replication which covers the ordinary updates as well as the consumer initialization to suppress the replication of "entryusn".

Sample Plugin default config entry

    dn: cn=plugin default config,cn=config
    objectClass: top
    objectClass: extensibleObject
    nsDS5ReplicatedAttributeList: (objectclass=*) $ EXCLUDE entryusn
    cn: plugin default config

New slapi APIs
--------------

#### int slapi_set_plugin_default_config(const char *type, Slapi_Value *value); ####
**Description:**  Add given "type: value" to the plugin default config entry (cn=plugin default config,cn=config) unless the same "type: value" pair already exists in the entry. <br>
**Parameters:**   type - Attribute type to add to the default config entry value - Attribute value to add to the default config entry<br>
**Return Value:** 0 if the operation was successful, non-0 if the operation was not successful<br>

#### int slapi_get_plugin_default_config(char *type, Slapi_ValueSet **valueset); ####
**Description:** Get attribute values of given type from the plugin default config entry (cn=plugin default config,cn=config).<br>
**Parameters:**  type - Attribute type to get from the default config entry valueset - Valueset holding the attribute values<br>
**ReturnValue:** 0 if the operation was successful, non-0 if the operation was not successful<br>
**warning:**     Caller is responsible to free attrs by slapi_ch_array_free<br>

usn-tombstone-cleanup.pl
------------------------

Utility usn-tombstone-cleanup.pl deletes tombstone entries. It is located in each server instance directory (/usr/lib[64]/dirsrv/slapd-*ID*, by default). usn-tombstone-cleanup.pl fails with LDAP_UNWILLING_TO_PERFORM if the suffix is the target of replication. Either "-s suffix" or "-n backend" needs to be passed. If both are passed, "-n backend" is ignored.

    Usage: ./usn-tombstone-cleanup.pl [-v] -D rootdn { -w password | -w - | -j filename } -s suffix | -n backend [ -m maxusn_to_delete ]
    Opts: -D rootdn           - Directory Manager
        : -w password         - Directory Manager's password
        : -w -                - Prompt for Directory Manager's password
        : -j filename         - Read Directory Manager's password from file
        : -s suffix           - Suffix where USN tombstone entries are cleaned up
        : -n backend          - Backend instance in which USN tombstone entries
                                are cleaned up (alternative to suffix)
        : -m maxusn_to_delete - USN tombstone entries are deleted up to
                                the entry with maxusn_to_delete
        : -v                  - verbose

Usages
======

Standalone
----------

The USN plugin is disabled, by default:

    dn: cn=USN,cn=plugins,cn=config    
    cn: USN    
    nsslapd-pluginPath: libusn-plugin    
    nsslapd-pluginInitfunc: usn_init    
    nsslapd-pluginEnabled: off    
    [...]    

Set "on" to nsslapd-pluginEnabled, and restart the server:

    dn: cn=USN,cn=plugins,cn=config    
    cn: USN    
    nsslapd-pluginPath: libusn-plugin    
    nsslapd-pluginInitfunc: usn_init    
    nsslapd-pluginEnabled: on    
    [...]    

Add a user uid=tuser0,dc=example,dc=com. Search entries with entryusn:

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 0    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =0       10    
    # dbscan -f id2entry.db4 -K 10    
    id 10    
       dn: uid=tuser0,dc=example,dc=com    
       uid: tuser0    
       [...]    

dbscan dumps the contents of the db files, which may not contain the latest updates since they are not checkpointed immediately. You need to wait up to 1 min. (nsslapd-db-checkpoint-interval: 60), by default.

Add another user uid=tuser1,dc=example,dc=com Search entries with entryusn:

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 0    
    dn: uid=tuser1,dc=example,dc=com    
    entryusn: 1    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =0       10    
    =1       11    

Modify user uid=tuser0,dc=example,dc=com

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 2    
    dn: uid=tuser1,dc=example,dc=com    
    entryusn: 1    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =1       11    
    =2       10    

Delete user uid=tuser0,dc=example,dc=com

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=tuser1,dc=example,dc=com    
    entryusn: 1    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =1       11    
    =3       10    

Add user uid=tuser0,dc=example,dc=com

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=tuser1,dc=example,dc=com    
    entryusn: 1    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 4    

The deleted tombstone is not resurrected.

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =1       11                                
    =3       10                                
    =4       12    

Modify RDN of uid=tuser1,dc=example,dc=com

    $ ldapmodify -D "cn=Directory Manager" -w password
    dn: uid=tuser1,dc=example,dc=com    
    changetype: modrdn    
    newrdn: uid=testuser1    
    deleteoldrdn: 0    

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=testuser1,dc=example,dc=com    
    entryusn: 5    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 4    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =3       10                                
    =4       12                                
    =5       11    

Restart the server and add user uid=nuser0,dc=example,dc=com to make sure the next USN is picked up from the entryusn index.

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=testuser1,dc=example,dc=com    
    entryusn: 5    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 4    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =3       10    
    =4       12                                
    =5       11                                
    =6       13    

Do some operation to fail, e.g., add an existing user uid=tuser0,dc=example,dc=com, then add another user uid=nuser1,dc=example,dc=com which should be successful. Verify the USN is consecutive.

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=testuser1,dc=example,dc=com    
    entryusn: 5    
    dn: uid=tuser0,dc=example,dc=com    
    entryusn: 4    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =3       10    
    =4       12                                
    =5       11                                
    =6       13                                
    =7       14    

Delete users uid=testuser1,dc=example,dc=com and uid=tuser0,dc=example,dc=com to prepare multiple tombstone entries.

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: nsuniqueid=2b195681-722911de-b839bb60-0f75a616, uid=testuser1,dc=example,dc=com    
    entryusn: 8    
    dn: nsuniqueid=ba266e81-722911de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 9    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    

Add uid=nuser2,dc=example,dc=com and uid=nuser3,dc=example,dc=com to make sure entryusn is sorted as integer.

    $ ldapsearch --b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: nsuniqueid=2b195681-722911de-b839bb60-0f75a616, uid=testuser1,dc=example,dc=com    
    entryusn: 8    
    dn: nsuniqueid=ba266e81-722911de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 9    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    
    dn: uid=nuser2,dc=example,dc=com    
    entryusn: 10    
    dn: uid=nuser3,dc=example,dc=com    
    entryusn: 11    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =3       10    
    =6       13  
    =7       14                          
    =8       11                            
    =9       12                          
    =10      15                             
    =11      16    

Try some range searches

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn>=10)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=nuser2,dc=example,dc=com    
    entryusn: 10    
    dn: uid=ntest3,dc=example,dc=com    
    entryusn: 11    

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn<=7)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=5485b2ee-722811de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 3    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn>=7)(entryusn<=10)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=2b195681-722911de-b839bb60-0f75a616, uid=testuser1,dc=example,dc=com    
    entryusn: 8    
    dn: nsuniqueid=ba266e81-722911de-b839bb60-0f75a616, uid=tuser0,dc=example,dc=com    
    entryusn: 9    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    
    dn: uid=nuser2,dc=example,dc=com    
    entryusn: 10    

Delete tombstones under "dc=example,dc=com"

    # cd <server_instance_dir>
    # usn-tombstone-cleanup.pl -D "cn=Directory Manager" -w password -s "dc=example,dc=com"    

Make sure there is no more tombstone entries

    $ ldapsearch -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=nuser0,dc=example,dc=com    
    entryusn: 6    
    dn: uid=nuser1,dc=example,dc=com    
    entryusn: 7    
    dn: uid=nuser2,dc=example,dc=com    
    entryusn: 10    
    dn: uid=nuser3,dc=example,dc=com    
    entryusn: 11    

Check the entryusn index with dbscan

    # dbscan -f entryusn.db4 -r    
    =3       10    
    =6       13                                
    =7       14                                
    =10      15                                
    =11      16    

Assume more operations are done and tombstones are generated...
Clean up tombstone entries up to entryusn = 19 in the backend userroot

    # usn-tombstone-cleanup.pl -D "cn=Directory Manager" -w Secret123 -n userroot -m 19    

Root DSE includes the last usn on the backend userroot

    $ ldapsearch -b "" -s base "(objectclass=*)" lastusn    
    dn:    
    lastusn;userroot: 22    

Add another suffix "dc=test,dc=com", backend instance name testBackend, initialize the backend the base dn entry "dc=test,dc=com", then add a user uid=tuser0,dc=test,dc=com:

    $ ldapsearch -b "dc=test,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=tuser0,dc=test,dc=com    
    entryusn: 0    

Root DSE includes the last usn on all the backends

    $ ldapsearch -b "" -s base "(objectclass=*)" lastusn    
    dn:    
    lastusn;userroot: 22    
    lastusn;testbackend: 0    

With Replication
----------------

Preparation: Configure 2 way MMR between Server A and Server B on "dc=example,dc=com" with excluding entryusn:

    dn: cn=    <agreement>    , cn=replica, cn="dc=example,dc=com", cn=mapping tree, cn=config    
    objectClass: top    
    objectClass: nsDS5ReplicationAgreement    
    [...]    
    nsDS5ReplicatedAttributeList: (objectclass=*) $ EXCLUDE entryusn    

On Server A, run initialize consumer.

Server A has entries with entryusn's.

    $ ldapsearch -p portA -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: uid=tuser10,dc=example,dc=com    
    entryusn: 12    
    dn: uid=tuser11,dc=example,dc=com    
    entryusn: 13    
    dn: uid=tuser12,dc=example,dc=com    
    entryusn: 14    
    dn: uid=tuser13,dc=example,dc=com    
    entryusn: 15    
    dn: uid=tuser14,dc=example,dc=com    
    entryusn: 16    
    dn: uid=tuser15,dc=example,dc=com    
    entryusn: 17    
    dn: uid=nuser10,dc=example,dc=com     
    entryusn: 22    
    dn: nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff, dc=example,dc=com    
    entryusn: 24    

Server B has none. Initialize consumer as well as import does not set entryusn's.

    $ ldapsearch -p portB -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    $    

Add a user uid=ruser2\_0,dc=example,dc=com to server A:

    ldapsearch -p portA -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    version: 1    
    dn: uid=tuser10,dc=example,dc=com    
    entryusn: 12    
    dn: uid=tuser11,dc=example,dc=com    
    entryusn: 13    
    dn: uid=tuser12,dc=example,dc=com    
    entryusn: 14    
    dn: uid=tuser13,dc=example,dc=com    
    entryusn: 15    
    dn: uid=tuser14,dc=example,dc=com    
    entryusn: 16    
    dn: uid=tuser15,dc=example,dc=com    
    entryusn: 17    
    dn: uid=nuser10,dc=example,dc=com    
    entryusn: 22    
    dn: nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff, dc=example,dc=com    
    entryusn: 27    
    dn: uid=ruser2_0,dc=example,dc=com    
    entryusn: 25    

Search on server B

    $ ldapsearch -p portB -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    $    
    # oops, USN was not enabled on server B...    

Enable USN on server B.

Add a user uid=ruser2\_1,dc=example,dc=com to server A. \$ ldapsearch -p *portA* -b "dc=example,dc=com" "(&(entryusn=\*)(|(objectclass=nsTombstone)(objectclass=\*)))" entryusn

    dn: uid=tuser10,dc=example,dc=com    
    entryusn: 12    
    dn: uid=tuser11,dc=example,dc=com    
    entryusn: 13    
    dn: uid=tuser12,dc=example,dc=com    
    entryusn: 14    
    dn: uid=tuser13,dc=example,dc=com    
    entryusn: 15    
    dn: uid=tuser14,dc=example,dc=com    
    entryusn: 16    
    dn: uid=tuser15,dc=example,dc=com    
    entryusn: 17    
    dn: uid=nuser10,dc=example,dc=com    
    entryusn: 22    
    dn: nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff, dc=example,dc=com    
    entryusn: 30    
    dn: uid=ruser2_0,dc=example,dc=com    
    entryusn: 25    
    dn: uid=ruser2_1,dc=example,dc=com    
    entryusn: 28    

Search on Server B.

    $ ldapsearch -p portB -b "dc=example,dc=com" "(&(entryusn=*)(|(objectclass=nsTombstone)(objectclass=*)))" entryusn    
    dn: nsuniqueid=ffffffff-ffffffff-ffffffff-ffffffff, dc=example,dc=com    
    entryusn: 3    
    dn: uid=ruser2_1,dc=example,dc=com    
    entryusn: 1    

usn-tombstone-cleanup.pl
------------------------

Run usn-tombstone-cleanup.pl on replicated backend

    # ./usn-tombstone-cleanup.pl -D "cn=Directory Manager" -w password -n userroot    
    adding new entry cn=usn_cleanup_2009_7_16_17_5_52, cn=USN tombstone cleanup task, cn=tasks, cn=config    
    ldap_add: DSA is unwilling to perform    

errors log:

    [...] usn-plugin - Suffix dc=example,dc=com is replicated. Unwilling to perform cleaning up tombstones.    

More failure cases of usn-tombstone-cleanup.pl
Run usn-tombstone-cleanup.pl on non-existing backend

    # ./usn-tombstone-cleanup.pl -D "cn=Directory Manager" -w password -n bogus    
    adding new entry cn=usn_cleanup_2009_7_16_17_5_36, cn=USN tombstone cleanup task, cn=tasks, cn=config    
    ldap_add: Bad parameter to an ldap routine    

errors log:

    [...] usn-plugin - Backend bogus is invalid.    

Run usn-tombstone-cleanup.pl on non-existing suffix

    # ./usn-tombstone-cleanup.pl -D "cn=Directory Manager" -w Secret123 -s "o=bogus"    
    adding new entry cn=usn_cleanup_2009_7_16_17_45_58, cn=USN tombstone cleanup task, cn=tasks, cn=config    

errors log:

    [...] usn-plugin - USN tombstone cleanup: no such suffix o=bogus.    

ToDo List
=========

Suggestions by Andrey Ivanov
----------------------------

-   The USNs seem to be unique within a suffix/backend. Should we enable the uniqueness plug-in for them? If not can we be sure that a manual change of entryUSN will not interfere with the correct functioning of the plug-in?

==\> Nathan suggested to set SLAPI_ATTR_FLAG_NOUSERMOD to the attribute entryusn. The flag prevents the manual update on EntryUSN.

    ldapmodify -D "cn=Directory Manager" -w /password/    
    dn: uid=tuserX,dc=example,dc=com    
    changetype: modify    
    replace: entryusn    
    entryusn: 100    
         
    modifying entry uid=tuserX,dc=example,dc=com    
    ldap_modify: DSA is unwilling to perform    
    ldap_modify: additional info: no modifiable attributes specified     

-   When the plug-in is activated no entry has entryUSN or maybe some entries do already have it in some disorder. Maybe we should initialize (while plug-in in started for the VERY first time) all the entries without entryUSN with entryUSN=-1 or something like that?

==\> Another good idea to have a method to correct the disorder. I'd like to have it as a utility, though. DS could have millions of entries and if it has to go through all of them every time the server is started, it would bring another headache...

-   Maybe it's a good idea to deactivate the replication of entryUSN attribute during the server installation by default?

==\> Done. Please see [To\_Suppress\_Replicating\_EntryUSN](http://directory.fedoraproject.org/wiki?title=Entry_USN#To_Suppress_Replicating_EntryUSN)

-   When we do an export with a utility like db2ldif.pl - should the entryUSN attributes be exported or not?

==\> Done. The entryusn attribute pair will not be exported. See the last item of [Standalone](http://directory.fedoraproject.org/wiki?title=Entry_USN#Standalone)

-   What happens during the import of a whole ldif subtree by something like "ldif2db -n userRoot -i /tmp/current\_prod\_database.ldif" if the entryUSNs are already present in the imported ldif? If they are not present? if they are present only in a part of the entries?

==\> If some of the entries in an ldif file have EntryUSNs and others don't, import treats EntryUSN as an ordinary attribute value. Import does not add any EntryUSNs nor it does not reset the values. When import is done, the server gets the last key of the entryusn index and USN counter starts from the (value + 1).

-   Should usn-tombstone-cleanup be integrated in the server core with the thread purging the tombstones or not? Should it be configurable as some attributes like nsds5ReplicaPurgeDelay and nsds5ReplicaTombstonePurgeInterval?

==\> It'd be nice to have this, indeed... Please note that if Replication is enabled with USN, all tombstones are purged by the Replication Plugin. They need to be manually purged if it's standalone.

Suggested by Nathan
-------------------

If the server is standalone, the internal deletion does not convert the to-be-deleted entry into a tombstone. Such cases should be taken care, as well. Note: USN needs to be tested with plugins which could cause internal deletion. DNA and memberOf are good candidates.

