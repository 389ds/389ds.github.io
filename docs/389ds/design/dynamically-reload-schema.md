---
title: "Dynamically Reload Schema"
---

# Dynamically Reload Schema Design
----------------------------------

{% include toc.md %}

Overview
--------

"Dynamically reload schema via task interface" is introduced to support the requirements:

-   managing user specified schema file names instead of putting all the user defined schema into 99user.ldif
-   reloading schema from the schema files without the server downtime

[Slapi Task API](http://directory.fedoraproject.org/wiki/Slapi_Task_API) framework is used to implement this functionality.

Implementation
--------------

Schema reload task plugin location: ldapserver/ldap/servers/plugin/schema\_reload/schema\_reload.c

The task registers the task start function task\_schemareload\_start at the plugin initialization time. When a schema reload task instance is added by a client, the task is invoked and the registered start function is called. The task instance exists until the task is finished.

sample task invocation

    ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=sample schema reload task, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: sample schema reload task
    schemadir: /path/to/schema/dir

The schema reload task has two phases: the schema validation and the schema reload. Unless the schema validation is successful, the schema reload will not be called. Both schema validation and schema reload depend on the schema initialization function (init\_schema\_dse\_ext in schema.c) but with the different flag sets. The schema validation calls it with DSE_SCHEMA_NO_LOAD \| DSE\_SCHEMA\_NO\_BACKEND. I.e., the schema read from the files are not loaded nor the dse schema backend is registered. On the other hand, the schema reload does it with DSE\_SCHEMA\_NO\_CHECK \| DSE\_SCHEMA\_LOCKED. It means the schema checking is skipped in the schema reload phase, and the entire schema reload should be done only when all the necessary locks are acquired. Once the schema reload is called, the internal schema is cleaned up and reinitialized with the schema files in the specified schema directory.

In terms of locking, 4 kinds of locks are involved. The outermost one is schemareload\_lock, which is used to serialize the schema reload task. Both the schema validation and the schema reload are in schemareload\_lock. After that, their locking policies differ each other. The schema validation acquires locks in the original style with the smaller granularity. By contrast, the schema reload acquires 3 other necessary locks -- dse schema backend lock, schema dse lock, and objectclass lock -- in the beginning, and the rest of the task is done assuming already locked.

To reload the schema files, you need to have all the schema files in a directory as the default schema directory does: /etc/dirsrv/slapd-ID/schema/\*.ldif. The location could be the default path or any other path. You could add your schema files, which are supposed to have a file name "[1-9][0-9][a-z-]\*.ldif". Or you could remove unnecessary schema files. If the location is different from the default schema directory, the schema reload task does not touch the default schema files. That is, if you restart the server without copying the new schema files to the default schema directory, the server goes back to the original schema set.

Configuration Entries
---------------------

Plugin entry (dse.ldif); created in the server instance creation.

    dn: cn=Schema Reload,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: Schema Reload
    nsslapd-pluginPath: libschemareload-plugin
    nsslapd-pluginInitfunc: schemareload_init
    nsslapd-pluginType: object
    nsslapd-pluginEnabled: on
    nsslapd-pluginId: schemareload
    nsslapd-pluginVersion: <plugin_version
    nsslapd-pluginVendor: <vendor name>
    nsslapd-pluginDescription: task plugin to reload schema files

Task entry in dse.ldif (registered in task\_schemareload\_start)

    dn: cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task

Usage samples
-------------

Dump the original schema into a file to compare with the test results later.

    ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
     \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.orig

perl is used to unwrap the wrapped ldif lines produced by ldapsearch - without the unwrapping, comparing two ldif files (or grepping, etc.) becomes very difficult. Since *objectclasses* and *attributetypes* are operational attributes, they must be explicitly specified on the command line.

**Test case 0.** Make sure it requires the directory manager privilege.

    $ ldapmodify -a
    dn: cn=schema reload task 0, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 0
    schemadir: /tmp/schema
    adding new entry cn=schema reload task 0, cn=schema reload task, cn=tasks, cn=config
    ldap_add: Insufficient access

**Test case 1.** No schema file change. Reload the original schema files.

    $ ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=schema reload task 1, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 1
    schemadir: /etc/dirsrv/slapd-ID/schema
    adding new entry cn=schema reload task 1, cn=schema reload task, cn=tasks, cn=config

    [errors log]    
       [..] schemareload - Schema reload task starts (schema dir: /etc/dirsrv/slapd-ID/schema) ...    
       [..] schemareload - Schema validation passed.    
       [..] schemareload - Schema reload task finished.    

    Check the reloaded schema.    
       $ ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
          \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.1
       $ diff /tmp/schema.orig /tmp/schema.1
       $    

**Test case 2.** No schema file change. Reload the original schema files from the implicit schema path.

    $ ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=schema reload task 2, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 2
    adding new entry cn=schema reload task 2, cn=schema reload task, cn=tasks, cn=config

    [errors log]    
       [..] schemareload - Schema reload task starts (schema dir: default) ...    
       [..] schemareload - Schema validation passed.    
       [..] schemareload - Schema reload task finished.    

    Check the reloaded schema.
       $ ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
          \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.2
       $ diff /tmp/schema.orig /tmp/schema.2

**Test case 3.** No schema file change. Reload the original schema files from the user specified schema path.

    $ ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=schema reload task 3, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 3
    schemadir: /tmp/schema
    adding new entry cn=schema reload task 3, cn=schema reload task, cn=tasks, cn=config

    [errors log]    
       [..] schemareload - Schema reload task starts (schema dir: /tmp/schema) ...    
       [..] schemareload - Schema validation passed.    
       [..] schemareload - Schema reload task finished.    

    Check the reloaded schema.    
       $ ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
          \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.3
       $ diff /tmp/schema.orig /tmp/schema.3


**Test case 4.** Added user defined schema file 90tmp.ldif to the default schema directory. Reload the schema files from the default schema path.

    $ ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=schema reload task 4, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 4
    adding new entry cn=schema reload task 4, cn=schema reload task, cn=tasks, cn=config

    [errors log]    
       [..] schemareload - Schema reload task starts (schema dir: /etc/dirsrv/slapd-ID/schema) ...    
       [..] schemareload - Schema validation passed.    
       [..] schemareload - Schema reload task finished.    

    Check the reloaded schema.    
       $ ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
          \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.4
       $ diff /tmp/schema.orig /tmp/schema.4
       157a158    
       > objectClasses: ( 1.2.3.4.5.6.7 NAME 'MozillaObject' SUP top STRUCTURAL MUST cn MAY ( givenName $ sn ) X-ORIGIN 'user defined' )    
       171a173    
       > attributeTypes: ( 8.9.10.11.12.13.14 NAME 'MozillaAttribute'  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORIGIN 'Mozilla Dummy Schema' )    

**Test case 5.** Added user defined schema file 90tmp.ldif to the user specified schema directory. Reload the schema files from the user specified schema path.

    $ ldapmodify -D "cn=Directory Manager" -w password -a
    dn: cn=schema reload task 5, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task 5
    schemadir: /tmp/schema
    adding new entry cn=schema reload task 5, cn=schema reload task, cn=tasks, cn=config

    [errors log]    
       [..] schemareload - Schema reload task starts (schema dir: /tmp/schema) ...    
       [..] schemareload - Schema validation passed.    
       [..] schemareload - Schema reload task finished.    

    Check the reloaded schema.    
       $ ldapsearch -xLLL -D "cn=Directory Manager" -w password -b "cn=schema" "(objectclass=*)" \
          \* objectclasses attributetypes | perl -p0e 's/\n //g' > /tmp/schema.5
       $ diff /tmp/schema.orig /tmp/schema.5
       157a158    
       > objectClasses: ( 1.2.3.4.5.6.7 NAME 'MozillaObject' SUP top STRUCTURAL MUST cn MAY ( givenName $ sn ) X-ORIGIN 'user defined' )    
       171a173    
       > attributeTypes: ( 8.9.10.11.12.13.14 NAME 'MozillaAttribute'  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORIGIN 'Mozilla Dummy Schema' )    

**Test case 6.** Concurrency check. Run the following 2 scripts at the same time. No deadlock is expected.

    $ cat schema.mod.sh
    i=0
    while [ $i -lt 1000 ]
    do
    ldapmodify -D "cn=Directory Manager" -w password << EOF
    dn: cn=schema
    changetype: modify
    add: attributetypes
    attributetypes: ( 9.10.11.12.13.14.15 NAME 'SchemaReloadTestAttribute' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORIGIN 'SchemaReloadTest Dummy Schema' )
    -
    add: objectclasses
    objectclasses: ( 2.3.4.5.6.7.8 NAME 'SchemaReloadObject' SUP top MUST ( objectclass $cn ) MAY ( givenName $ sn ) X-ORIGIN 'user defined' )
    EOF

    ldapmodify -D "cn=Directory Manager" -w password << EOF
    dn: cn=schema
    changetype: modify
    delete: attributetypes
    attributetypes: ( 9.10.11.12.13.14.15 NAME 'SchemaReloadTestAttribute' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORIGIN 'SchemaReloadTest Dummy Schema' )
    -
    delete: objectclasses
    objectclasses: ( 2.3.4.5.6.7.8 NAME 'SchemaReloadObject' SUP top MUST ( objectclass $cn ) MAY ( givenName $ sn ) X-ORIGIN 'user defined' )
    EOF
      i=`expr $i + 1`
    done

    $ cat schema.reload.sh
    i=0
    while [ $i -lt 10 ]
    do
    rm /tmp/schema/90tmp.ldif
    ldapmodify -D "cn=Directory Manager" -w password -a << EOF
    dn: cn=schema reload task $i.0, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task $i.0
    schemadir: /tmp/schema
    EOF

    cat > /tmp/schema/90tmp.ldif << EOF
    dn: cn=schema
    attributetypes: ( 8.9.10.11.12.13.14 NAME 'MozillaAttribute' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORIGIN 'Mozilla Dummy Schema' )
    objectclasses: ( 1.2.3.4.5.6.7 NAME 'MozillaObject' SUP top MUST ( objectclass $ cn ) MAY ( givenName $ sn ) X-ORIGIN 'user defined' )
    EOF

    chown nobody /tmp/schema/*
    ldapmodify -D "cn=Directory Manager" -w password -a << EOF
    dn: cn=schema reload task $i.1, cn=schema reload task, cn=tasks, cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: schema reload task $i.1
    schemadir: /tmp/schema
    EOF
      i=`expr $i + 1`
    done

Script schema-reload.pl
-----------------------

To simplify to launch the task, a perl script schema-reload.pl is provided in the instance directory.

    Usage: ./schema-reload.pl [-v] -D rootdn { -w password | -w - | -j filename } 
            [-d schemadir]
     Opts: -D rootdn           - Directory Manager
         : -w password         - Directory Manager's password
         : -w -                - Prompt for Directory Manager's password
         : -j filename         - Read Directory Manager's password from file
         : -d schemadir        - Directory where schema files are located
         : -v                  - verbose

To reload the schema files in the default schema dir, run

    schema-reload.pl -D rootdn -w password

To reload the schema files in user specified dir, run

    schema-reload.pl -D rootdn -w password -d /user/specified/schemadir


Notes
---------------

-   The schema file reload task is a local operation. In the MMR environment, the updated schema won't be replicated. Thus, to execute the schema file reload in the MMR environment, the following steps would be needed.

        1. stop the replication    
        2. run the schema file update task on each supplier and replica server    
        3. resume the replication    

-   When the task happens to fail, the ldapmodify command-line does not return any errors:

        # ldapmodify -D "cn=Directory Manager" -w password -a
        dn: cn=schema reload task 1, cn=schema reload task, cn=tasks, cn=config
        objectClass: top
        objectClass: extensibleObject
        cn: schema reload task 1
        schemadir: /bogus
        adding new entry cn=schema reload task 1, cn=schema reload task, cn=tasks, cn=config

The result is supposed to be checked in the errors log:

    [..] schemareload - Schema reload task starts (schema dir: /bogus) ...    
    [..] schema - No schema files were found in the directory /bogus    
    [..] schema_reload - schema file validation failed    
    [..] schemareload - Schema validation failed.    

