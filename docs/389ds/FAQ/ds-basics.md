---
title: "Directory Server Basics For Certificate Server"
---

Directory Server Basics For Certificate Server
======================================================

{% include toc.md %}

## Introduction

This is a Directory Server essentials training class for users of Certificate Server.  It covers the essential tasks one would need to do to work with and troubleshoot common DS issues.

## The Database Suffix & Name

The database suffix is a DN that identifies the root node, or top entry, of the database tree.  The database "name" is a text string that is used in the configuration, and optionally CLI tools, to identify the backend database.  The database name is also used as part of the file system layout for the database files.  Our docs always default to "userRoot" as the database name, but the name could be anything.  So for example the database suffix could be:  "dc=example,dc=com", and the database name of "userRoot".  So there are two ways to identify the database.  This is necessary because you can have many databases and sub-databases in a single instance of Directory Server.

## The Configuration

Due to legacy issues the configuration for the database(s) (dse.ldif/cn=config) is slightly confusing/redundant. There are two configuration entries for each database/suffix.  The first one is the "mapping tree" entry, and the other is the backend config entry.  The reason there are two entries is because many years ago you could have multiple suffixes under a single database name.  This "functionality" was removed many years ago, but for each suffix/database we are stuck with this two entry config model.  It is what it is...

So here is an example of these entries:

    dn: cn=dc\3dexample\2cdc\3dcom,cn=mapping tree,cn=config
    objectClass: top
    objectClass: extensibleObject
    objectClass: nsMappingTree
    cn: dc=example,dc=com
    cn: dc\=example\,dc\=com
    nsslapd-state: backend
    nsslapd-backend: userRoot
    
The important attributes in this entry are:  **nsslapd-backend** and **cn** which define the suffix and database identifier.  Then we have the backend database entry:

    dn: cn=userroot,cn=ldbm database,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    objectClass: nsBackendInstance
    cn: userRoot
    nsslapd-suffix: dc=example,dc=com
    nsslapd-cachesize: -1
    nsslapd-cachememsize: 2818572288
    nsslapd-readonly: off
    nsslapd-require-index: off
    nsslapd-require-internalop-index: off
    nsslapd-dncachememsize: 335544320
    nsslapd-directory: /var/lib/dirsrv/slapd-instance/db/userRoot
    
So it would look like the mapping tree entry is not needed since the backend database entry basically has the same information.  Like I said it is a bit redundant and confusing, but it's what we have to work with.  Most of the CLI tools accept either the database name or the suffix as arguments to identify the database you want to work with.  Well all but "dsctl", it always expects the database name verses the suffix.  We'll go over this later, but it's not a big deal.

## Initializing the Database

When we talk about initializing the database, this really means "importing" an LDIF file to **replace** the existing database content.  It does not *append* to the existing database!  It is also important to note that when you initialize the database it also regenerates all the indexes.  There are no post-import processes required.  Here are some examples of how to initialize the database while the server is stopped, or running.

LDIF files are typically stored in the server's **ldif** directory:

    /var/log/dirsrv/slapd-INSTANCE/ldif/

### Stopped Server

Note "/usr/sbin/dsctl" is mostly used to perform tasks on a "stopped" server, and "dsctl" typically only uses the database name (vs the suffix). Ok so here an example:

    # dsctl slapd-instance ldif2db userRoot /var/lib/dirsrv/slapd-instance/ldif/users.ldif
    
### Running Server

When the server is running, we use "/usr/sbin/dsconf" which is actually just an LDAP client that issues "ldapmodify" commands behind the scene.  Now there are many ways to authenticate using "dsconf" but the simplest, and default behavior, is to use LDAPI.  So you have to run the command as **root** which will map to the *Root DN*, or "cn=Directory Manager" account.  All you need to do is specify the instance name, and the tool will do the rest:

    # dsconf slapd-instance backend import userroot users.ldif
    
Note - DS requires that all LDIF files are stored in the server's LDIF directory:  **/var/lib/dirsrv/slapd-instance/ldif/**  This is mainly due to Selinux restrictions.  This is why I did not use the full path to the LDIF location in the CLI example.  But with "dsctl" you do need to specify the full path (that might get addressed some day to make it more consistent).

## Exporting the Database

Exporting the database is simply exporting a database/suffix to an LDIF file.  Some people call this a backup and while technically that is true in a sense, we do have an official backup/restore process which does not use LDIF's and preserves the entire database.  More on that later...

### Stopped Server

    # dsctl slapd-instance db2ldif userRoot /var/lib/dirsrv/slapd-instance/ldif/users.ldif
    
### Running Server

    # dsconf slapd-instance backend export userroot users.ldif

## Back Up & Restore

The backup process takes a snapshot of the entire database and copies it to a different location.  This backup can later be restored as needed.  It is important to note what is different about a **backup** verses an **export**.  An *export* just creates an LDIF file, but it does not contain the replication changelog, tombstone entries, or the replication metadata that might be present.  Backups are also much faster to create and restore then trying to process a large LDIF file.

Backups are located in:

    /var/log/dirsrv/slapd-INSTANCE/bak/

### Backup & Restore Stopped server

    # dsctl slapd-instance db2bak <backup name/directory name>
    
    # dsctl slapd-instance bak2db <backup name/directory name>

### Backup & Restore Running Server

    # dsconf slapd-instance backup create <backup name/directory name>

    # dsconf slapd-instance backup restore <backup name/directory name>

## Schema

The objectclasses and attributes that can be used in the database.  This also describes the type of data that the attributes are allowed to contain (aka attribute syntax).  Objectclasses basically group the attributes into what is allowed and what is required.  So some objectclasses require "cn" and "uid", and allow "description", and "userpassword".

The schema can be updated two ways.  Either by using an LDAP client like ldapmodify, or by adding a schema file to the server.  When adding the schema with an LDAP client the new schema is automatically added to the server and is available to use.  If you provide a file, then you must either restart the server or run the "schema reload" task:

    # dsconf slapd-instance schema reload PATH_TO_SERVER_SCHEMA_FILES

## Searching & Modifying Data

### ldapsearch

#### Search Base DN (-b)

This is where the search should start in the tree.  Usually it is the top node:  **dc=example,dc=com**, or **o=ipaca**  But it could be branch further down in the tree:  **ou=people,dc=example,dc=com**

#### Search Scope (-s)

Defines how far to look into the tree for result candidates

- "base" = This means the search is looking at a single entry - the search base DN!
- "one" = One level scope means look at the parent and all the entries directly underneath it by one level.  It will not look deeper into the tree
- "sub" = Subtree scope will search for everything under the Search Base DN


#### Filter

The search filter that will be applied to the entries under the search base and within the search scope.  You do not use any special arguments/option for filters, they just placed at the end of the command

#### Attributes

In the search request you can request to retrieve only certain attributes in the resulting entries.  By default all standard attributes are returned (except for operational attributes).  Again this goes at the very end of the command

#### Examples

    # ldapsearch -D <BIND_DN> -w <PASSWORD> -b <SEARCH_BASE> <FILTER> <ATTRS>
    
    # ldapsearch -D "cn=directory manager" -w Secret123 -b "dc=example,dc=com" objectclass=top cn

    # ldapsearch -D "cn=directory manager" -W -b "o=ipaca" -s one objectclass=top
    
    # ldapsearch -D "cn=directory manager" -W -b "ou=people,dc=example,dc=com" "(&(objectclass=person)(uid=edewata))" uid

### ldapmodify

#### Changetype

- "add" = Add an entry
- "modify" = Modify an entry
    - "add" = Add an attribute
    - "replace" = Replace the attribute (all attribute values)
    - "delete" = Delete an attribute (or specific attribute)
- "delete" = Delete an entry
- "modrdn" = Rename an entry

#### Examples

    # ldapmodify -D "cn=directory manager" -W
    
    dn: <Entry DN>
    changetype: add
    objectclass: top
    objectclass: person
    sn: last name
    cn: common name
    
    dn: <Entry DN>
    changetype: modify
    add: cn
    cn: another CN value
    
    dn: <Entry DN>
    changetype: modify
    delete: cn
    cn: another CN value
    
    ^^^ Deletes specific value
    
    dn: <Entry DN>
    changetype: modify
    delete: cn
    
    ^^^ deletes all "cn" attributes

    dn: <Entry DN>
    changetype: modify
    replace: sn
    sn: new SN value
    
    ^^^ replaces all "sn" values with a single value "new SN value"
    
    dn: <Entry DN>
    changetype: modify
    replace: sn
    sn: new SN value
    -
    add: userpassword
    userpassword: mySecret123
    -
    delete: description
    
    ^^^ You can do update multiple attributes to the same entry inside of a single operation by using a hyphen to separate each attribute update
    
    dn: <Entry DN>
    changetype: delete
    
    dn: uid=mark,ou=people,dc=example,dc=com
    changetype: modrdn
    deleteoldrdn: 1
    cn: marcus
    
    ^^^ changes entry DN from "uid=mark,ou=people,dc=example,dc=com" to "cn=marcus,ou=people,dc=example,dc=com"


### ldapdelete

Good for deleting entire subtrees (See "-r"), use with caution!

    # ldapdelete -D "cn=directory manager" -W [-r] DN


## VLV Indexes

"Virtual List View" searches.  While there is a lot that a VLV index can do you should think of a VLV index an a way to index a "search request & result".  Even with standard indexing there are situations where the search itself can not be indexed using standard attribute indexes.  So here comes VLV indexes.  Basically you define a search request: filter, base, scope, sorting.  Then the server will index that "search" and maintain the search results in an index.  This allows for what would normally be very expensive searches to become extremely fast.

<https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/creating_indexes-creating_vlv_indexes>
<https://frasertweedale.github.io/blog-redhat/posts/2020-09-17-dogtag-vlv-corruption.html>

### VLV Configuration

A VLV index is actually a minimum of two entries under cn=config:  The VLVSearch entry, and one or more VLVIndex entries.  So a VLVSearch can have many VLVIndex emntrues.  The VLV index entry is just "sorting" definition.  Typically you just have one "VLV index" entry per "VLV search" entry, but you can define as many different sorting entries as you would like.

    dn: cn=VLVSearchEntry, cn=ipaca, cn=ldbm database, cn=plugins, cn=config
    objectClass: top
    objectClass: vlvSearch
    cn: VLVSearchEntry
    vlvBase: ou=certificateRepository,ou=ca,o=ipaca
    vlvScope: 1
    vlvFilter: (certstatus=*)

    dn: cn=VLVIndexEntry, cn=VLVSearchEntry,cn=ipaca, cn=ldbm database, cn=plugins, cn=config
    objectClass: top
    objectClass: vlvIndex
    cn: VLVIndexEntry
    vlvSort: serialno
    vlvEnabled: 0
    vlvUses: 0
    
    dn: cn=VLVIndexEntry2, cn=VLVSearchEntry,cn=ipaca, cn=ldbm database, cn=plugins, cn=config
    ...
    ...
    
### Enable Index

To enable the index you must "index it".  You always index the "VLV Search Entry", not the "VLV Index Entries".  Since the "VLV Index Entries" are child entries of the VLV Search Entry they will all get properly indexed.  So no worries. 

    # dsconf slapd-localhost backend vlv-index reindex --parent-name=VLVSearchEntry o=ipaca
    
Check the VLV index to see if it is now enabled:

    # dsconf slapd-localhost backend vlv-index list o=ipaca
    dn: cn=VLVSearchEntry,cn=ipacaRoot,cn=ldbm database,cn=plugins,cn=config
    cn: VLVSearchEntry
    vlvbase: ou=certificateRepository,ou=ca,o=ipaca
    vlvscope: `
    vlvfilter: (certstatus=*)
    Sorts:
        - dn: cn=VLVIndexEntry,cn=VLVSearchEntry,cn=userroot,cn=ldbm database,cn=plugins,cn=config
        - cn: VLVIndexEntry
        - vlvsort: serialno
        - vlvenabled: 1
        - vlvuses: 0

### Test the VLV Search Is Configured Correctly

You can use ldapsearch to verify the VLV is correctly configured.  If everything is good you will see "vlvuses" increase and you won't see a "notes=U", which means unindexed search, in the Directory Server access log.

    # ldapsearch -D "cn=directory manager" -W -b "ou=certificateRepository,ou=ca,o=ipaca" -s one -E 'sss=uid' -E 'vlv=1/0:0' "(certstatus=*)"


Access log when the search is working:

    [21/Jul/2022:15:38:04.565520711 -0400] conn=104 op=0 BIND dn="cn=directory manager" method=128 version=3
    [21/Jul/2022:15:38:04.620125290 -0400] conn=104 op=0 RESULT err=0 tag=97 nentries=0 wtime=0.000066782 optime=0.054620274 etime=0.054683120 dn="cn=directory manager"
    [21/Jul/2022:15:38:04.620335293 -0400] conn=104 op=1 SRCH base="ou=certificateRepository,ou=ca,o=ipaca" scope=1 filter="(certstatus=*)" attrs=ALL
    [21/Jul/2022:15:38:04.622147958 -0400] conn=104 op=1 SORT serialno 
    [21/Jul/2022:15:38:04.622167280 -0400] conn=104 op=1 VLV 1:0:09267911168 2:2 (0)
    [21/Jul/2022:15:38:04.622318925 -0400] conn=104 op=1 RESULT err=0 tag=101 nentries=2 wtime=0.000058754 optime=0.001984478 etime=0.002041084
    
We can see in the VLV index that it was "used":

    # dsconf slapd-localhost backend vlv-index list o=ipaca
    dn: cn=VLVSearchEntry,cn=ipacaRoot,cn=ldbm database,cn=plugins,cn=config
    cn: VLVSearchEntry
    vlvbase: ou=certificateRepository,ou=ca,o=ipaca
    vlvscope: `
    vlvfilter: (certstatus=*)
    Sorts:
        - dn: cn=VLVIndexEntry,cn=VLVSearchEntry,cn=userroot,cn=ldbm database,cn=plugins,cn=config
        - cn: VLVIndexEntry
        - vlvsort: serialno
        - vlvenabled: 1
        - vlvuses: 8

So we can see that the "SRCH base", "scope", and "filter" perfectly match the VLVSearchEntry.  And "SORT serialno" matches the VLVIndexEntry.   Everything must be exact or the VLV index will not be used and the search will be unindexed and very expensive/slow.  Take notice of the **notes=U** below when the request does not match the VLV configuration (the scope is different):

    [21/Jul/2022:15:43:55.463075239 -0400] conn=106 op=0 BIND dn="cn=directory manager" method=128 version=3
    [21/Jul/2022:15:43:55.463447501 -0400] conn=106 op=0 RESULT err=0 tag=97 nentries=0 wtime=0.000072772 optime=0.000383063 etime=0.000449009 dn="cn=directory manager"
    [21/Jul/2022:15:43:55.464005541 -0400] conn=106 op=1 SRCH base="ou=certificateRepository,ou=ca,o=ipaca" scope=2 filter="(certstatus=*)" attrs=ALL
    [21/Jul/2022:15:43:55.464418691 -0400] conn=106 op=1 SORT serialno (0)
    [21/Jul/2022:15:43:55.464455284 -0400] conn=106 op=1 VLV 1:0:0 0:0 (0)
    [21/Jul/2022:15:43:55.464611062 -0400] conn=106 op=1 RESULT err=0 tag=101 nentries=0 wtime=0.000116629 optime=0.000606568 etime=0.000718508 notes=U details="Partially Unindexed Filter"


So if any part of the search request does not match the VLV Search/Index then it will be unindexed, and in large databases it will cause serious problems.

### Debugging VLV

If the VLV search is not indexed it can only be two things (maybe a third):

- The VLV Index is not enabled (vlvEnabled).  This means you need to index it
- The VLV search request does not match any existing VLV configuration in the server's configuration.
- Index corruption - this should never happen but technically it's possible.  In this case, if the above two conditions are correct then the last thing to try is to reindex it again.


## Basic Troubleshooting

Next we will go over some common troubleshooting tips

### Logs

The logs are your friend, and here is how to look at them and what they mean.

#### Access Log

The **access** records client operations and the results

    [21/Jul/2022:15:25:27.618524526 -0400] conn=41 fd=64 slot=64 connection from local to /run/slapd-localhost.socket
    [21/Jul/2022:15:25:27.619087186 -0400] conn=41 AUTOBIND dn="cn=directory manager"
    [21/Jul/2022:15:25:27.619093608 -0400] conn=41 op=0 BIND dn="cn=directory manager" method=sasl version=3 mech=EXTERNAL
    [21/Jul/2022:15:25:27.619123474 -0400] conn=41 op=0 RESULT err=0 tag=97 nentries=0 wtime=0.000041176 optime=0.000125871 etime=0.000165548 dn="cn=dm"
    [21/Jul/2022:15:25:27.626840243 -0400] conn=41 op=1 SRCH base="cn=schema" scope=0 filter="(objectClass=*)" attrs="attributeTypes"
    [21/Jul/2022:15:25:27.776617785 -0400] conn=41 op=1 RESULT err=0 tag=101 nentries=1 wtime=0.000067957 optime=0.149779230 etime=0.149844137
    [21/Jul/2022:15:25:27.967504902 -0400] conn=41 op=2 UNBIND
    [21/Jul/2022:15:25:27.967522924 -0400] conn=41 op=2 fd=64 Disconnect - Cleanly Closed Connection - U1
    
Every operation (BIND, CMP, SRCH, MOD, ADD, DEL, and MODRDN) also has a corresponding RESULT.  **err=0** means *success*

- SRCH
    - "base" is the search base
    - "scope" is the  search scope
        - "0" means its a *base* search
        - "1" means it's a one-level search
        - "2" means its a subtree search
    - "filter" is the search filter
    - "attrs" are the requested attributes to return in the result. 
        - "1.1" is a shortcut for just the "dn" attribute of the entry
        - "ALL" means all attributes
    	
- MOD/CMP/ADD/DEL/MODRDN
    - "dn" the target entry **DN**
    
- RESULT
    - "err" is the result code.   **err=0** means *success*
    - "tag" is a code for the operation type - not very interesting
    - "nentries" is the "Number of Entries" returned from the operation.  This only applies to SRCH operations
        - If you get nentries=0 when you would expect to get results this could be Access Control filtering the results.  A quick test would be to run the same search as **cn=directory manager** because this account bypasses Access Control.
    - "wtime" is the time the operation *Waited* in the worker queue before being assigned to a worker thread
    - "optime" is how long the *Operation* took once it actually started
    - "etime" is the total *Elapsed* time the operation took
    - notes=U/notes=A is recorded in the log if the search is unindexed.  **notes=A** means the entire search was unindexed.  This is the worst case scenario!  **notes=U** is partially unindexed search and it is bad, but not as bad as a *notes=A*
    - notes=P just means its a "Paged Result" from a *paged* search (it it not an error)


#### Error Log

Often when there is a failed operation you can check the errors log to see if additional information was logged about that failing client operation.  You will also find other information the errors log related to the server itself.  Some are informational, while other can be errors.  There are severity levels you can look at to help navigate the content

    [19/Jul/2022:10:20:06.671489812 -0400] - INFO - main - 389-Directory/2.2.1.202207181308gitfbe52ae23 B2022.199.1310 starting up
    [19/Jul/2022:10:20:06.674409469 -0400] - INFO - main - Setting the maximum file descriptor limit to: 1024
    [19/Jul/2022:10:20:24.377100858 -0400] - INFO - PBKDF2_SHA256 - Based on CPU performance, chose 2048 rounds
    [19/Jul/2022:10:20:24.525807165 -0400] - INFO - ldbm_instance_config_cachememsize_set - force a minimal value 512000
    [19/Jul/2022:10:20:24.540715918 -0400] - INFO - ldbm_instance_config_set - instance: userroot attr nsslapd-cachesize
    [19/Jul/2022:10:20:24.783047019 -0400] - WARN - bdb_start_autotune - Your autosized cache values have been reduced. Likely your nsslapd-cache-autosize percentage is too high.
    [19/Jul/2022:10:20:24.791895506 -0400] - WARN - bdb_start_autotune - This can be corrected by altering the values of nsslapd-cache-autosize, nsslapd-cache-autosize-split and nsslapd-dncachememsize
    [19/Jul/2022:10:22:10.281821318 -0400] - ERR - attrcrypt_cipher_init - No symmetric key found for cipher AES in backend userroot, attempting to create one...


#### Audit Log

This log is not enabled by default, but it logs the exact "update" operations that are done to the Directory Server.  So if you need to see what a "mod" operation actually did you need to enable this log and look.

    # dsconf slapd-localhost config replace nsslapd-auditlog-logging-enabled=on

The format of the log actually looks like an ldapmodify command, and you can *almost* copy and paste it to the command line:

    time: 20220721152619
    dn: cn=VLVSearchEntry,cn=userroot,cn=ldbm database,cn=plugins,cn=config
    result: 0
    changetype: add
    objectClass: top
    objectClass: vlvSearch
    cn: VLVSearchEntry
    vlvBase: dc=example,dc=com
    vlvScope: 2
    vlvFilter: (uid=*)
    creatorsName: cn=directory manager
    modifiersName: cn=directory manager
    createTimestamp: 20220721192618Z
    modifyTimestamp: 20220721192618Z


### Hangs & Crashes

In order to debug a crash/core file you will need to the debuginfo packages installed to get meaningful data, there are other OS settings that need to be enabled as well:

<https://www.port389.org/docs/389ds/FAQ/faq.html#sts=Debugging%C2%A0Crashes>

For hangs it is best to grab several full stack traces from the running server:

gdb -ex 'set confirm off' -ex 'set pagination off' -ex 'thread apply all bt full' -ex 'quit' /usr/sbin/ns-slapd `pidof ns-slapd` > stacktrace.`date +%s`.txt 2>&1

It is also useful to know if the CPU is high during the hang (deadlock verses spinning)



