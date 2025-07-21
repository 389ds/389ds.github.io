---  
title: "Howto: Migrate database from BerkeleyDB to lmdb"  
---

# How to migrate 389 directory server database from BerkeleyDB to lmdb

{% include toc.md %}

## Why is migration needed ?

Berkeley db support is getting removed from 389-ds-base ldap directory.  
Migrating the database to db is needed before/after upgrading to Fedora 43

## Why is the migration not done automatically when upgrading ?

There is a lot of different 389-ds-base deployment types  
 and in some cases the automatic migration procedure could take hours   
  and there could be trouble (especially if disk space is too spare to have   
  3 versions of the ldap data ( bdb, ldif, lmdb )  at the same time

## How to migrate the database ?

The way to migrate is different according to the way the directory server is used:

1) ### Topology having freeipa:

There are two sub cases:

#### 1a) Topology having several freeipa replicas (and CA replica)

Better deconfigure the replica from freeipa before the upgrade and reconfigure it afterward similarly to the method explained in [https://docs.redhat.com/en/documentation/red\_hat\_enterprise\_linux/10/html/migrating\_to\_identity\_management\_on\_rhel\_10/migrating-your-idm-environment-from-rhel-9-servers-to-rhel-10-servers](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/migrating_to_identity_management_on_rhel_10/migrating-your-idm-environment-from-rhel-9-servers-to-rhel-10-servers)

#### 1b) Topology having a single freeipa instance

In that case the fastest method is to use the same method as when not having freeipa after stopping freeipa.  
So if there is enough disk space:

| \# ipactl stop \<br\>  \# dsctl EXAMPLE-COM dblib bdb2mdb  \<br\> \# ipactl start |
|:--------------------------------------------------------------------------------- |

2) ### The Topology not having freeipa
   
   #### 2a) if all the backend are replicated
   
   In that case, the fastest method is to:  
* evaluate the lmdb maximum size (Step B of manual import method)  

* stop the instance  

* switch the database type to mdb ( steps E to G )  

* start the instance  

* Reintialize all the backends from another replica through the replication
  
  #### 2b) if there is enough disk space
  
  If there is enough disk space to hold 3 versions of the data  
  (in other words: you must have at least twice the size computed at step B as free disk space in /var/lib/ before starting the migration)   
  You can use the automatic migration procedure:

| \# dsctl supplier1 dblib bdb2mdb |
|:-------------------------------- |

  This command performs automatically all the steps described in the manual procedure.  
  It does not remove the old bdb data, so in case of trouble, you can always 

  make sure that the instance is stopped, then edit the dse.ldif to change nsslapd-backend-implement back to bdb to get back to the original state

#### 3b) otherwise:

  you must use the manual import method that is a bit painful  
   you need some external/network storage to:

1) Perform a preliminary backup of the directory server instance  

2) store the ldif files 
   
   Then and you will probably need to delete the bdb database before switching the database implementation

## Questions/Answers

### What value should I use as dsctl first parameter ?

dsctl first parameter is the instance name. (a parameter provided when creating the ldap server instances)

With freeipa, it is the kerberos realm after rep\[lacing dot per dash.  
Anyway you can list existing instance names with: dsctl \-l  
   You can these use the whole name or you can also omit the slapd- prefix:

| \# dsctl \-l  \<br\> slapd-standalone1  \<br\> \# dsctl standalone1 status  \<br\> Instance "standalone1" is not running |
|:------------------------------------------------------------------------------------------------------------------------ |

### How do I know what type of database is used ?

If the instance is running, you can use:

| \# dsconf standalone1 backend config get | grep nsslapd-backend-implement  \<br\> nsslapd-backend-implement: bdb |
| :---- |

For new deployment you'd get 'mdb'.

If the instance is stopped you can use:

| \# grep nsslapd-backend-implement /etc/dirsrv/slapd-standalone1/dse.ldif |
|:------------------------------------------------------------------------ |

What are precisely the command to perform the manual migration:

dsctl slapd-supplier1 db2ldif \--replication userroot /var/lib/dirsrv/slapd-su  
 pplier1/ldif/userroot.ldif

where:

* slapd-supplier1 is the instance name (as shown by dsctl \-l)  
* userrrot is the backend name

### Where are things ?

#### Paths

| Entity           | Path                                  | associated parameter in dse.ldif                                                             |
|:---------------- |:------------------------------------- |:-------------------------------------------------------------------------------------------- |
| ldif             | /var/lib/dirsrv/slapd-supplier1/ldif/ | nsslapd-ldifdir                                                                              |
| database         | /var/lib/dirsrv/slapd-supplier1/db/   | nsslapd-directory                                                                            |
| main config file | /etc/dirsrv/slapd-supplier1/dse.ldif  |                                                                                              |
| log files        | /var/log/dirsrv/slapd-supplier1/      | nsslapd-accesslog nsslapd-securitylog nsslapd-errorlog nsslapd-auditlog nsslapd-auditfaillog |
| backends         |                                       | nsslapd-backend                                                                              |

Note: for people using non root user installation, the path should be prefixed by the non root installation path that was chosen when setting up the instance

#### Some dsctl/dsconf command parameters:

| Item                     | What it is                                                                 | How to find it                                                                                                   |
|:------------------------ |:-------------------------------------------------------------------------- |:---------------------------------------------------------------------------------------------------------------- |
| instanceNme              | The directory server instance identifier                                   | dsct \-lIn most deployment there is a single instance.in dsconf/dsctl command the slapd- prefix may be omitted |
| backend name referred in | Backends are the repository of data associated to a suffix or a sub suffix | grep nsslapd-backend /etc/dirsrv/slapd-instanceName/dse.ldif                                                     |

Note that things are slightly different when using the above name in database instance path:  
instanceName should be prefixed by slapd- in the different paths  
backend name may be different:  
   Typically in lmdb paths the names are in lowercases:  
And beware that characters may need to be escape for the shell (using quotes around the name/path or backslash to escape spaces and other special characters)   
A example of complex name that need to be escaped:

|                             | Path                                                                               |
|:--------------------------- |:---------------------------------------------------------------------------------- |
| Backend name                | ‘A Special Name / with & surprises’                                                |
| LMDB database instance path | ‘/var/lib/dirsrv/slapd-supplier1/db/a special name / with & surprises/id2entry.db’ |
| BDB database instance path  | ‘/var/lib/dirsrv/slapd-supplier1/db/A Special Name / with & surprises/id2entry.db’ |

### What are the precise command to run when doing manual migration (ldif method):  In the command example in this section:

* slapd-supplier1 is the instance name as displayed by dsctl \-l  
* userroot is the backend name found by:  
     grep nsslapd-backend /etc/dirsrv/slapd-supplier1/dse.ldif  
1. Determine  the instance name:

| \# dsctl \-l |
|:------------ |

   The following steps should be applied for all instances (but usually there is only one)

2. Compute the current backends database size:

| \# du \-s \-h  /var/lib/dirsrv/slapd-supplier1/db/\*/ |
|:----------------------------------------------------- |

   sum it all then add a 20% margin. That is the expected lmdb map size  

3. For every instances determine its backend names

| \# grep nsslapd-backend /etc/dirsrv/slapd-supplier1/dse.ldif |
|:------------------------------------------------------------ |

   The following steps should be done for each backends (of each instances)

4. For every instances and backens export the backend to ldif  
   
       Note: export should be done off line so make sure that the instance is stopped:

| \# systermctl stop [dirsrv@supplier1.service](mailto:dirsrv@supplier1.service)   \# Or:   \# dsctl supplier1 stop |
|:----------------------------------------------------------------------------------------------------------------- |

   If backed is replicated and is a supplier or a hub:

| \# dsctl slapd-supplier1 db2ldif \--replication userroot /var/lib/dirsrv/slapd-supplier1/ldif/userroot.ldif\# dbscan \-D bdb \--export /var/lib/dirsrv/slapd-supplier1/ldif/userroot.clldif  \-f /var/lib/dirsrv/slapd-supplier1/db/userroot/replication\_changelog.db |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

   If backed is replicated and is a consumer:

| \# dsctl slapd-supplier1 db2ldif \--replication userroot userroot.ldif |
|:---------------------------------------------------------------------- |

   If backed is not replicated:

| \# dsctl slapd-supplier1 db2ldif  userroot userroot.ldif |
|:-------------------------------------------------------- |

   In case of doubt: try the replicated supplier method:  
    if dsctl fails immediately, try again without the –replication parameter (not replicated case)  
    if dbscan fails telling that changelog file cannot be found, just ignore the error  (replicated consumer case)

5. Switch to lmdb database:   
   edit the dse.ldif configuration file (/etc/dirsrv/slapd-supplier1/dse.ldif) and replace the nsslapd-backend-implement value from bdb to mdb   
   Typically for vi users:

| vi \+/nsslapd-backend-implement /etc/dirsrv/slapd-supplier1/dse.ldif |
|:-------------------------------------------------------------------- |

   Then replace bdb by mdb, save then quit 

6. Restart the instance  
7. Set the lmdb map maximum map size  
    using the value computed at step B

| dsconf supplier1 backend config set \--mdb-max-size 3G |
|:------------------------------------------------------ |

8. Stop the instance

| \# systermctl stop [dirsrv@supplier1.service](mailto:dirsrv@supplier1.service)  \<br\> \# \# Or:  \<br\> \# dsctl supplier1 stop |
|:-------------------------------------------------------------------------------------------------------------------------------- |

9. For each backend, Import The backend from ldif and import the changelog if it exists  

| \# dsctl slapd-supplier1 ldif2db \--replication userroot \<br\>/var/lib/dirsrv/slapd-supplier1/ldif/userroot.ldif  \<br\>\# dbscan \--import /var/lib/dirsrv/slapd-supplier1/ldif/userroot.clldif  –do-it \-f /var/lib/dirsrv/slapd-supplier1/db/userroot/replication\_changelog.db |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

### Too late, I upgraded and now dirsrv service fails to start. What can I do ?

dirsrv service will not start until the database type is switched to mdb  ⇒ no ldap authentication is doable toward this host  
some off line command are still available and  can be used to perform the migration:  
 typically:

* dsctl instanceName dblib bdb2mdb  
* dsctl instanceName ldif2db  
* dbscan \-D bdb \--export

dsconf does not work because it vrequires that the instance is started.

Note: backup/restore commands (i.e: dsctl instanceName db2bak / dsctl instanceName bak2db does not work )    

### What are the precise parameters of the commands

Your best friend is the on line help activated with the –help op\[tion:  
  At top level, it provides the list of global options and subcommands  
  At the various subcommand levels it describes the options/nested subcommands specific to that subcommand. Here are some example:

* dsctl –help  
* dsctl instance db2ldif \--help  
* dsconf –help  
* dsconf instanceName backend –help  
* dsconf instanceName backend suffix –help  
* dsconf instanceName backend suffix list –help  
* dbscan –help

### What sanity test can I do ?

#### Before the migration:

* Compute the database size and make sure that there is twice this amount of free disk space in /var/lib/dirsrv/slapd-instanceName/db

#### After the migration

##### Perform some smoke tests

* Check that the dirstv service is started  
  * systemctl status dirsrv@instanceName or  
  * dsctl instanceName status  
* If Replication is enabled, check that replication is in sync or in progress  
* If freeipa is used:  
  * ???  
* Check that the database is not empty  
  * dbscan \-L /var/lib/dirsrv/slapd-InstanceName/db  
    should list database instances for all backends

##### Verify that everything is working as expected

##### Clean the old BerkeleyDB databases

Once everything is working fine for some time, to clean up things::  
Run:

| \# dsctl instanceName dblib cleanup |
|:----------------------------------- |

Or do things manually:

Remove everything in /var/lib/dirsrv/slapd-supplier1/db/ expect these 3 files:

| data.mdb | The database                                                                   |
|:-------- |:------------------------------------------------------------------------------ |
| INFO.mdb | Some meta data about the database (versions and some configuration parameters) |
| lock.mdb | Some data about lmdb lock system                                               |

You may also want remove:

1. Any existing backup in  /var/lib/dirsrv/slapd-supplier1/bak/ and generate a new one (anyway you cannot restore from a bdb backup )  
2. The ldif files generated by the migration in /var/lib/dirsrv/slapd-supplier1/ldif/

# Pending questions:

## Should we disable the upgrade if databases are not migrated ?

- Probably better for freeipa users   
- (~~not sur that local upgrade works for freeipa~~)

## Should we perform automatic migration if the database is small and there is enough spare disk space?

Let say if thec database size is less than 2 Gb

## Should we switch the database to lmdb and start with empty db ?

This will allow the service to start and allow replication initialization from another supplier (maybe doing this only if all backends are replicated ?)
