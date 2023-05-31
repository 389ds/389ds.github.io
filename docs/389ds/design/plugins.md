---
title: "Plugin Design"
---

# Plugin Design
---------------

{% include toc.md %}

Directory Server Plug-ins Overview
==================================

If you want to extend the capabilities of the 389, you can write your own server plug-in. A server plug-in is a shared object or library (or a dynamic link library on Windows) containing your own functions.

You can write your own plug-in functions to extend the functionality of the directory server in the following ways:

-   You can validate data before the server performs an LDAP operation on the data.
-   You can perform some action (that you define) after the server successfully completes an LDAP operation. (For example, you can send mail after an operation successfully completes.)
-   You can define extended operations (which are part of the LDAP v3 protocol).
-   You can provide alternate matching rules when comparing certain attribute values.
-   You can set up the server to use your own type of database for storing data.

There are many different types of plug-ins.

Directory Server Plug-in Type
=============================

Pre-Operation (preoperation)
----------------------------

The pre-operation plug-in type is one of the most commonly used. The "pre" refers to the fact that this type of plug-in will be called before accessing the backend database (either to read from it for a search, or write to it for a modify). This allows you to intercept operation and reject it if it's doing something you don't want to allow. Another use would be to modify or append something extra to certain operations, such as adding an extra attribute to any new entries that are added. They are also used to implement BIND operation plug-ins which can be used to authenticate users against other systems, such as PAM or a SecurID ACE server. The Directory Server uses this to support SASL, allowing users to authenticate to the Directory with their Kerberos credentials.

Some examples of pre-operation plug-ins are:

-   Attribute Uniqueness

> The attribute uniqueness plug-in intercepts incoming operations that would add or modify attributes in the database (ADD or MOD operations). It looks at the new values being added and ensures that the value is unique for within the database if the attribute being modified is configured for uniqueness. If uniqueness would be violated, the plug-in would return an error to the client and stop the server from processing the operation.

-   Distributed Numeric Assignment (DNA)

> The DNA plug-in intercepts incoming ADD operations and checks if they are a part of a managed numeric range (such as posixAccount entries needing automatically assigned uidNumber values). If the operation needs a managed numeric value, the DNA plug-in will add an auto-assigned value to the ADD operation as if the user specified the value themselves. The plug-in then lets the server continue processing the operation as normal.

-   Schema Compatibility

> The schema compatibility plug-in intercepts incoming search operations to see if they are against a specific suffix that is used to maintain an alternate presentation of LDAP entries. If the search is against this special suffix, the plug-in returns it's own results to the client instead of searching the database used by the rest of the server.

#### Pre-Operation Callbacks

A pre-operation plug-in allows you to register callbacks to respond for different operation types. The callbacks that you can register are:

       SLAPI_PLUGIN_PRE_BIND_FN    
       SLAPI_PLUGIN_PRE_UNBIND_FN    
       SLAPI_PLUGIN_PRE_SEARCH_FN    
       SLAPI_PLUGIN_PRE_COMPARE_FN    
       SLAPI_PLUGIN_PRE_MODIFY_FN    
       SLAPI_PLUGIN_PRE_MODRDN_FN    
       SLAPI_PLUGIN_PRE_ADD_FN    
       SLAPI_PLUGIN_PRE_DELETE_FN    
       SLAPI_PLUGIN_PRE_ABANDON_FN    
       SLAPI_PLUGIN_PRE_ENTRY_FN    
       SLAPI_PLUGIN_PRE_REFERRAL_FN    
       SLAPI_PLUGIN_PRE_RESULT_FN    

Most of these callbacks should be self-explanatory as they just refer to the LDAP operation type that they will be invoked for. Some notes:

-   A pre-operation search function will be called for both internal and external searches.
-   A pre-operation entry function is called prior to an entry being sent to a client.
-   A pre-operation result function is called prior to the final result being send to a client.

A callback is registered using the slapi\_pblock\_set() function call in your plug-ins initialization function. This will be described a bit later.

Data Interoperability plug-ins are just pre-operation plug-ins with some special extra configuration (in the mapping tree) that allows them to intercept requests for the root DSE as well (so you can do a subtree search with a base of ""). These are used to put an LDAP front-end on external data sources without having to implement the full database plug-in interface.

Post-Operation (postoperation)
------------------------------

The Post-Operation plug-ins are called after database activity has occurred. These can be thought of as triggers. They are typically used to perform some other operation that depends on the outcome of the original operation (whether positive or negative). For example, removing references to a user (e.g. from groups) after the user has been successfully removed, or sending an email to an administrator if a certain operation with a certain value failed.

Some examples of post-operation plug-ins are:

-   MemberOf

> The memberOf plug-in looks for an operation that modifies group membership via altering the "member" attribute in a group entry. After this update of membership has been allowed to succeed by being committed to the database, the memberOf plug-in will perform a series of internal modify operations to make all member entries contain a memberOf entry that points back to the groups it belongs to.

-   Replication Changelog

> The replication plug-in's changelog callbacks are triggered after a write operation has updated a database that is configured for change logging. It then records this change in a changelog that can be used for replaying operations to replicas.

#### Post-Operation Callbacks

A post-operation plug-in allows you to register callbacks to respond for different operation types. The callbacks that you can register are:

       SLAPI_PLUGIN_POST_BIND_FN    
       SLAPI_PLUGIN_POST_UNBIND_FN    
       SLAPI_PLUGIN_POST_SEARCH_FN    
       SLAPI_PLUGIN_POST_COMPARE_FN    
       SLAPI_PLUGIN_POST_MODIFY_FN    
       SLAPI_PLUGIN_POST_MODRDN_FN    
       SLAPI_PLUGIN_POST_ADD_FN    
       SLAPI_PLUGIN_POST_DELETE_FN    
       SLAPI_PLUGIN_POST_ABANDON_FN    
       SLAPI_PLUGIN_POST_ENTRY_FN    
       SLAPI_PLUGIN_POST_REFERRAL_FN    
       SLAPI_PLUGIN_POST_RESULT_FN    
       SLAPI_PLUGIN_POST_SEARCH_FAIL_FN     

Most of these callbacks are self-explanatory. The SLAPI\_PLUGIN\_POST\_SEARCH callback only called if the search operation was successful. The SLAPI\_PLUGIN\_POST\_SEARCH\_FAIL\_FN callback will be called in the event of a failed search operation.

Internal Pre-Operation (internalpreoperation)
---------------------------------------------

An internal pre-operation plug-in is very nearly the same as a regular pre-operation plug-in. The one difference is that an internal pre-operation is only triggered by internal operation. An internal operation is an LDAP operation that is initiated via SLAPI as opposed to an external LDAP client. An internal operation will always be initiated via the DS itself, or one of it's plug-ins. It is important to note that an internal operation is not restricted by any access controls (i.e. - It's given the permissions of the "cn=Directory Manager" user).

The examples for internal pre-operation plug-ins are basically the same as the ones used for the regular pre-operation plug-ins. In many cases, you would want your pre-operation plug-in to be triggered for both internal and external operations. This will ensure that your plug-in can catch things like new users being added via a Windows Sync Agreement, which uses internal operations for everything coming in from Active Directory.

#### Internal Pre-Operation Callbacks

       SLAPI_PLUGIN_INTERNAL_PRE_ADD_FN    
       SLAPI_PLUGIN_INTERNAL_PRE_MODIFY_FN    
       SLAPI_PLUGIN_INTERNAL_PRE_MODRDN_FN    
       SLAPI_PLUGIN_INTERNAL_PRE_DELETE_FN     

Internal Post-Operation (internalpostoperation)
-----------------------------------------------

The internal post-operation is a post-operation callback for internal operations. See the description of internal pre-operation plug-ins above for details on internal operations.

#### Internal Post-Operation Callbacks

       SLAPI_PLUGIN_INTERNAL_POST_ADD_FN    
       SLAPI_PLUGIN_INTERNAL_POST_MODIFY_FN    
       SLAPI_PLUGIN_INTERNAL_POST_MODRDN_FN    
       SLAPI_PLUGIN_INTERNAL_POST_DELETE_FN     

Backend Pre-Operation (bepreoperation)
--------------------------------------

A backend pre-operation plug-in is called before accessing the database, but after calling all pre-operation and internal pre-operation plug-ins. This gives you some basic ability to order pre-operation plug-ins.

#### Backend Pre-Operation Callbacks

       SLAPI_PLUGIN_BE_PRE_ADD_FN    
       SLAPI_PLUGIN_BE_PRE_MODIFY_FN    
       SLAPI_PLUGIN_BE_PRE_MODRDN_FN    
       SLAPI_PLUGIN_BE_PRE_DELETE_FN     

Backend Post-Operation (bepostoperation)
----------------------------------------

A backend post-operation plug-in is called after accessing the database, but before calling all post-operation and internal post-operation plug-ins. This gives you some basic ability to order post-operation plug-ins.

#### Backend Post-Operation Callbacks

       SLAPI_PLUGIN_BE_POST_ADD_FN    
       SLAPI_PLUGIN_BE_POST_MODIFY_FN    
       SLAPI_PLUGIN_BE_POST_MODRDN_FN    
       SLAPI_PLUGIN_BE_POST_DELETE_FN     

Backend Transaction Pre-Operation (betxnpreoperation)/Backend Transaction Post-Operation (betxnpostoperation)
-------------------------------------------------------------------------------------------------------------

Backend Transaction Pre and Post Operation (betxn) plug-ins are similar to those described above, except that they are called inside the database transaction and can therefore be used to perform atomic operations. An error during a pre or post operation plugin can cause the entire enclosing database transaction to be rolled back. An update (add/modify/modrdn/delete) internal operation (e.g. slapi\_modify\_internal\_pb) performed inside of a betxn plugin will be done as a child transaction of the enclosing parent transaction. This means:

-   the plugin uses data that has been committed already by other child transactions of the parent transaction
    -   for example, a modify operation will see the data that has been modified and committed by another child transaction of the enclosing parent transaction
    -   a search operation will return data that has been modified and committed by another child transaction of the enclosing parent transaction
-   if the plugin writes to the database, but a subsequent operation fails in the same enclosing parent transaction, the plugin's write will be rolled back
    -   any aborted transaction at any child level will unwind all the way up to the original update operation's transaction and will abort and roll back all of them

To correctly abort the changes in the error case, plug-ins which type is backend transaction pre or post must return non-zero value if the plugin operation failed. And preferably, the result code (SLAPI\_RESULT\_CODE in pblock) or opreturn (SLAPI\_PLUGIN\_OPRETURN in pblock) is supposed to be set in case any error occurred.

Due to the nature of the database, deadlocks could occur in the database operations. Other database errors cause the transaction abort and returns the error. However in case deadlock occurs, it retires up to 50 times. The backend transaction pre- and post-plugins are called as many as the retry is attempted, while the backend pre- and post- plugins are not.

Notes on the transaction handles:

-   as of 389-ds-base 1.2.11, plugins no longer have to deal with SLAPI\_TXN or SLAPI\_PARENT\_TXN at all - all of the txn management happens internally in the server code - plugins don't have to do anything
-   an internal search operation will search \_in the transaction\_ using the txn handle - that means, if you do an internal search from a betxn plugin, your search results may include data modified by earlier update operations in child transactions of the current parent transaction

Starting from 389-ds-base 1.3.0, backend transactions are exposed to plug-ins:

      slapi_back_transaction_begin|commit|abort    

Sample code is available in the 389-ds-base source code plugins/memberof/memberof.c.

#### Backend Transaction Pre-Operation Callbacks

       SLAPI_PLUGIN_BE_TXN_PRE_ADD_FN    
       SLAPI_PLUGIN_BE_TXN_PRE_MODIFY_FN    
       SLAPI_PLUGIN_BE_TXN_PRE_MODRDN_FN    
       SLAPI_PLUGIN_BE_TXN_PRE_DELETE_FN     

#### Backend Transaction Post-Operation Callbacks

       SLAPI_PLUGIN_BE_TXN_POST_ADD_FN    
       SLAPI_PLUGIN_BE_TXN_POST_MODIFY_FN    
       SLAPI_PLUGIN_BE_TXN_POST_MODRDN_FN    
       SLAPI_PLUGIN_BE_TXN_POST_DELETE_FN    

Extended Operation (extendedop)
--------------------------------

An extended operation plug-in allows you to register a callback to handle a specified extended operation. You register your callback to be invoked when an extended operation using a certain OID is received by the server. The plug-in can then do whatever processing is required and return a response to the client.

This plug-in type is used by the DNA plug-in as well as the replication plug-in.

#### Extended Operation Callbacks

       SLAPI_PLUGIN_EXT_OP_FN

Syntax (syntax)
---------------

A Syntax plug-in implements support for LDAP syntaxes, controlling how values of a certain syntax are indexed and compared. For example, the Telephone Number Syntax plug-in makes sure that "800-555-1212" and "800 555 1212" compare to the same value. All of the LDAP syntax support in the Directory Server is implemented as Syntax plug-ins.

Matching Rule (matchingrule)
----------------------------

A matching rule plug-in can be written to handle extensible match search filters. A matching rule consists of the logic used to compare attribute values to an assertion value when performing a search. You associate your plug-in with a matching rule OID. When this OID is used as part of an extensible match search filter, your plug-ins comparison functions will be used. This allows different matching rules to be used with an attribute of the same syntax.

An example of a matching rule plug-in is the Internationalization (collation) plug-in that is shipped as a part of Directory Server. The collation plug-in allows one to search and sort results using various languages. Another example is the bitwise plug-in that is in the Directory Server source tree. The bitwise plug-in allows an extensible search filter to perform bitwise search operations against an attribute value containing a bitfield.

ACL (accesscontrol)
-------------------

An ACL plug-in is used for implementing an access control mechanism with the Directory Server. When access needs to be checked, the Directory Server will call all registered ACL plug-ins to either grant or deny access.

The access control features in Directory Server are implemented via a plug-in of this type.

Password Storage Scheme (pwdstoragescheme)
------------------------------------------

A password storage scheme plug-in allows you to specify a new storage mechanism for a hashed password attribute. You supply an encryption function along with a comparison function. You then associate these functions with a password storage scheme prefix (such as {SSHA}) that tells the server which plug-in to use when dealing with a password. This allows you to store the password using whatever custom hashing scheme you like.

All of the default supported hashing schemes in the Directory Server are implemented using this plug-in type.

Reversible Password Storage Scheme (reverpwdstoragescheme)
----------------------------------------------------------

A reversible password storage scheme plug-in allows you to specify a new storage mechanism for a reversibly encrypted password attribute. You supply a set of encryption and decryption functions along with a comparison function. You then associate these functions with a password storage scheme prefix (such as {DES}) that tells the server which plug-in to use when dealing with a password. This allows you to store the password using whatever custom encryption scheme you like.

The Directory Server includes a plug-in of this type that is used to encrypt the replication and chaining bind credentials when using simple password authentication.

Object (object)
---------------

An object plug-in is a generic plug-in type. It is common for a single plug-in (at the shared library level) to consist of a number of the above plug-in types (or perhaps none of the above types). In these cases, you register your plug-in as an object plug-in type in it's plug-in configuration entry. Your plug-in can then register it's various plug-in types via the slapi\_register\_plugin() function at it's initialization time.

Virtual Attribute Service Provider (vattrsp)
--------------------------------------------

A virtual attribute service provider plug-in allows one to define virtual attributes that get their value from some source other than the entry itself. The plug-in supplies functions that are called whenever the registered attribute type is requested or when a comparison is needed. The plug-in is then responsible for fetching/generating the values as well as performing comparisons.

Some examples of this plug-in type are the roles, class-of-service and presence plug-ins that are a part of Directory Server(note - presence is no longer shipped, but the code is still in the source tree). The presence plug-in adds virtual attributes whose value indicates if the user represented by the entry is currently online for a particular instant messaging service. The plug-in queries the external service to generate the value (and caches the result for a specified period of time). There is also a template source example for this type of plug-in in the Directory Server tree (the vattrsp\_template plug-in).

Database (back-ldbm)
--------------------

A database plug-in implements an interface to a particular type of data store. The Directory Server uses a database plug-in called back-ldbm (no relation to the LDBM database anymore) to implement an interface to Berkeley DB. The Directory Server also has a database plug-in called Chaining which uses one or more other LDAP servers as the data store, and a pseudo, hidden database called DSE that stores the schema and configuration information in LDIF text files.

A plug-in can be disabled. When disabled, the plug-in's configuration information remains in the directory but its function will not be used by the server.

On startup, the directory server loads your library and calls your functions during the course of processing various LDAP requests.

For more details, see the Plug-in Programmers Guide.

An Annotated Pre-Operation Plug-in Example
==========================================

This example is taken from the file ldap/servers/slapd/test-plugins/testpreop.c

     #include <stdio.h>
     #include <string.h>
     #include "slapi-plugin.h"

Every plug-in must include slapi-plugin.h - this defines the interface to the server.

    static void *my_plugin_identity = NULL;

Every plug-in is assigned an identity by the server plug-in code. The plug-in can retrieve this in the plug-in init function (see below). The plug-in must use this identity in order to call internal LDAP operations (slapi\_modify\_internal\_pb et. al.).

     Slapi_PluginDesc preoppdesc = { "test-preop", "My Company", "1.0",
        "sample pre-operation plugin" };

The Slapi\_PluginDesc is some data that populates the corresponding entries in the plug-in entry. The first field is the plugin name which is also the cn attribute in the plug-in entry which is used as the RDN (e.g. cn=test-preop,cn=plugins,cn=config). Choose something that works well in a DN (e.g. avoid 8 bit characters, commas, equal signs, etc.). The second field identifies the plugin vendor or author. The third field is the plug-in version. The fourth field is a brief description of the plug-in.

    /* Pre-operation plug-in function */
    int
    testpreop_bind( Slapi_PBlock *pb )

This is the function that we have registered in testpreop\_init() (see below) to be called during the pre-operation phase of each BIND operation.

     {
        char    *dn;
        int method;
        char    *auth;

        /* Get the DN that the client is binding as and the method
           of authentication used. */
        if ( slapi_pblock_get( pb, SLAPI_BIND_TARGET, &dn ) != 0 || 
             slapi_pblock_get( pb, SLAPI_BIND_METHOD, &method ) != 0 ) {
            slapi_log_error( SLAPI_LOG_PLUGIN,
            "testpreop_bind", "Could not get parameters\n" );
            return( -1 );
        }

pblock stands for Parameter Block. This contains all of the parameters about the operation, connection, etc. See the [Plug-in Programmers Guide](http://www.redhat.com/docs/manuals/dir-server/plugin/contents.htm) for full details about what parameters are available for each operation. This is a BIND operation, and two of the parameters are the BIND DN (i.e. who is attempting to bind) and the method. The dn is a pointer into the internal pblock structure - do not free it or otherwise modify it. Use slapi\_ch\_strdup() to make a copy of it to modify or use the slapi\_sdn\_\* functions. slapi\_pblock\_get() should return a 0 upon success. slapi\_log\_error is the mechanism used to write messages to the errors log file. The first argument is the error level (not a severity!). These levels are listed in slapi-plugin.h. In general, use SLAPI\_LOG\_FATAL for urgent messages - these are always logged. Use SLAPI\_LOG\_PLUGIN for everything else unless you are writing a special purpose plug-in that would make more sense to use one of the other log levels. The second argument is the subsystem - in this case "testpreop\_bind". This is mainly used to help search and categorize related error messages. The third argument is a format string in the style of printf, and the remaining arguments (if any) are treated as vararg arguments. The format string should end in \\n unless you just really want your log message to be on the same line as the next message (you probably don't).

        switch( method ) {
        case LDAP_AUTH_NONE:
            auth = "No authentication";
            break;
        case LDAP_AUTH_SIMPLE:
            auth = "Simple authentication";
            break;
        case LDAP_AUTH_SASL:
            auth = "SASL authentication";
            break;
        default:
            auth = "Unknown method of authentication";
            break;
        }

LDAP\_AUTH\_NONE, LDAP\_AUTH\_SIMPLE, and LDAP\_AUTH\_SASL are defined in ldap-deprecated.h. An SSL client cert auth connection will be LDAP\_AUTH\_SASL and the cert information will be in the pblock.

        /* Log information about the bind operation to the
           server error log. */
        slapi_log_error( SLAPI_LOG_PLUGIN, "testpreop_bind",  
            "Preoperation bind function called.\n" 
            "\tTarget DN: %s\n\tAuthentication method: %s\n",
            dn, auth );

Here is an example of using slapi\_log\_error() with additional arguments. This formats the output on separate lines, which is not usually recommended - it just makes parsing the log harder.

        return( 0 );    /* allow the operation to continue */

A return code of 0 means that you want the regular bind processing in the server to occur, including sending the result back to the client. A return code of 1 means that the plugin already handled the rest of the processing, including returning the result to the client along with any response controls.

    }

    /* Pre-operation plug-in function */
    int
    testpreop_add( Slapi_PBlock *pb )

This is the function that we have registered in testpreop\_init() (see below) to be called during the pre-operation phase of each ADD operation.

    {
        Slapi_Entry *e;
        Slapi_Attr  *a;
        Slapi_Value *v;
        struct berval   **bvals;
        int     i, hint;
        char        *tmp;
        const char  *s;

        /* Get the entry that is about to be added. */
        if ( slapi_pblock_get( pb, SLAPI_ADD_ENTRY, &e ) != 0 ) {
            slapi_log_error( SLAPI_LOG_PLUGIN,
                "testpreop_add", "Could not get entry\n" );
            return( -1 );
        }

SLAPI\_ADD\_ENTRY is the entry that is going to be added to the database. It is ok to modify it here. It is not recommended to free it and/or replace it with another one.

        /* Prepend the name "BOB" to the value of the cn attribute
           in the entry. */
        if ( slapi_entry_attr_find( e, "cn", &a ) == 0 ) {
            for ( hint = slapi_attr_first_value( a, &v ); hint != -1;
                    hint = slapi_attr_next_value( a, hint, &v )) {
                s = slapi_value_get_string( v );

All of the slapi\_entry, slapi\_attr, and slapi\_value functions used here return pointers into the internal data structures - do not free them or modify them directly.

                tmp = slapi_ch_malloc( 5 + strlen( s ));
                strcpy( tmp, "BOB " );
                strcat( tmp + 4, s );
                slapi_value_set_string( v, tmp );

slapi\_ch\_malloc() works just like system malloc(). You must use the slapi\_ch malloc and free functions when passing memory to other slapi functions. slapi\_value\_set\_string will free the current value (if any) and set the value to a **copy** of the passed in string.

                slapi_ch_free_string( &tmp );

We have to free our temporary string to avoid a memory leak. slapi\_ch\_free() and slapi\_ch\_free\_string() accept a pointer to the string to free. This is because it sets its argument to NULL after the free to avoid freeing freed memory. It also checks for NULL so it is safe to pass in a NULL pointer. These added features protect against hard to find memory errors.

            }
        }

        return( 0 );    /* allow the operation to continue */
    }


    /* Pre-operation plug-in function */
    int
    testpreop_abandon( Slapi_PBlock *pb )

This is the function that we have registered in testpreop\_init() (see below) to be called during the pre-operation phase of each ABANDON operation.

    {
        int msgid;

        /* Get the LDAP message ID of the abandon target */
        if ( slapi_pblock_get( pb, SLAPI_ABANDON_MSGID, &msgid ) != 0 ) {
            slapi_log_error( SLAPI_LOG_PLUGIN,
            "testpreop_abandon", "Could not get parameters\n" );
            return( -1 );
        }

msgid is the LDAP message ID.

        /* Log information about the abandon operation to the
           server error log. */
        slapi_log_error( SLAPI_LOG_PLUGIN, "testpreop_bind",  
            "Preoperation abandon function called.\n" 
            "\tTarget MsgID: %d\n",
            msgid );

        return( 0 );    /* allow the operation to continue */
    }


    static void
    get_plugin_config_dn_and_entry( char *msg, Slapi_PBlock *pb )

This is a helper function called from the plug-in start function testpreop\_start() below.

    {
        char        *dn = NULL;
        Slapi_Entry *e = NULL;
        int         loglevel = SLAPI_LOG_PLUGIN;

        if ( slapi_pblock_get( pb, SLAPI_TARGET_DN, &dn ) != 0 || dn == NULL ) {
            slapi_log_error( loglevel, msg, "failed to get plugin config DN\n" );
        } else {
            slapi_log_error( loglevel, msg, "this plugin's config DN is \"%s\"\n",
                    dn );
        }

        if ( slapi_pblock_get( pb, SLAPI_ADD_ENTRY, &e ) != 0 || e == NULL ) {
            slapi_log_error( loglevel, msg, "failed to get plugin config entry\n" );
        } else {
            char    *ldif;

The plug-in start function has access to the DN and the entry of the plug-in. The plug-in entry is a very useful place to store the plug-in configuration information. For example, if this plug-in entry has a DN of cn=test-preop,cn=plugins,cn=config, this DN and entry will be available here. Most non-trivial plug-ins will have some sort of static structure which represents the configuration parameters of the plug-in. The values can be derived from the attributes and values in the plug-in. An objectclass and attributes can be created for the plug-in configuration and added to the schema. DSE callbacks can be registered so that the plug-in can be notified when the values change, so that the plug-in can be dynamically configured during operation. In this case, use mutexes to protect your configuration parameters when modifying and accessing their values. Remember, this is a multi-threaded server, and your plug-in may be called many times simultaneously.

            ldif = slapi_entry2str_with_options( e, NULL, 0 );

This converts the entry to a string in LDIF format. The memory returned is allocated and must be freed with slapi\_ch\_free\_string().

            slapi_log_error( loglevel, msg,
                    "this plugin's config entry is \"\n%s\"\n", ldif );
            slapi_ch_free_string( &ldif );

Frees the allocated string.

        }
    }

    static int
    testpreop_start( Slapi_PBlock *pb )

This function is called when the server is initialized and ready to start processing operations, but before the first operation has been received. The server is still in "single threaded" mode at this point, so it is generally safe to do things which are not thread safe, such as initializing static variables and the like. The start function is different from the init function (below) which is called when the plugin shared object is loaded for the first time (usually at server start up).

    {
        get_plugin_config_dn_and_entry( "testpreop_start", pb );
        return( 0 );
    }

    /* Initialization function */
    #ifdef _WIN32
    __declspec(dllexport)
    #endif
    int
    testpreop_init( Slapi_PBlock *pb )

This function is called when the plug-in shared object is first loaded into memory, usually at server start up time. This function name must be specified in the plug-in configuration entry under cn=plugins,cn=config. This function should not do very much, mostly just set the operation specific callback functions. The rest of the configuration should be done in the start function when the plug-in has access to the plug-in entry (which should have all of the plug-in configuration information).

    {
            slapi_pblock_get( pb, SLAPI_PLUGIN_IDENTITY, &my_plugin_identity);
            PR_ASSERT (my_plugin_identity);

Get the identity of this plug-in (as assigned by the plug-in system) and make sure it is not NULL.

        /* Register the two pre-operation plug-in functions,
           and specify the server plug-in version. */
        if ( slapi_pblock_set( pb, SLAPI_PLUGIN_VERSION,
            SLAPI_PLUGIN_VERSION_01 ) != 0 ||
            slapi_pblock_set( pb, SLAPI_PLUGIN_DESCRIPTION,
            (void *)&preoppdesc ) != 0 ||

These two things are always required.

            slapi_pblock_set( pb, SLAPI_PLUGIN_START_FN,
            (void *) testpreop_start ) != 0 ||

The plug-in should always have a start function. This is where the plug-in will normally do its configuration.

            slapi_pblock_set( pb, SLAPI_PLUGIN_PRE_BIND_FN,
            (void *) testpreop_bind ) != 0 ||
            slapi_pblock_set( pb, SLAPI_PLUGIN_PRE_ADD_FN,
            (void *) testpreop_add ) != 0 ||
            slapi_pblock_set( pb, SLAPI_PLUGIN_PRE_ABANDON_FN,
            (void *) testpreop_abandon ) != 0 ) {

This plug-in only registers interest in pre BIND, ADD, and ABANDON operations. You can register callbacks for one or all or any combination of LDAP operations. Other types of plug-ins (post op, extended op, etc.) have different callbacks that can be set here.

            slapi_log_error( SLAPI_LOG_PLUGIN, "testpreop_init",
                "Failed to set version and function\n" );
            return( -1 );
        }

        return( 0 );
    }

### An Annotated LDAP Extended Operation Plug-in Example

This example is taken from the file ldap/servers/slapd/test-plugins/testextendedop.c. See RFC 2251 for more information about LDAP extended operations.

    #include <stdio.h>
    #include <string.h>
    #include "slapi-plugin.h"

Always need slapi-plugin.h.

    /* OID of the extended operation handled by this plug-in */
    #define MY_OID  "1.2.3.4"

All extended operations have an OID. See the LDAP RFCs for more information about extended operations and their OID assignments.

    Slapi_PluginDesc expdesc = { "test-extendedop", "Fedora", "0.5",
        "sample extended operation plugin" };

Our plug-in description information. Required.

    /* Extended operation plug-in */
    int
    testexop_babs( Slapi_PBlock *pb )

This is the function that we have registered below (in the init function) to handle our extended operation.

    {
        char        *oid;
        struct berval   *bval;
        char        *retval, *msg;
        struct berval   retbval;

        /* Get the OID and the value included in the request */
        if ( slapi_pblock_get( pb, SLAPI_EXT_OP_REQ_OID, &oid ) != 0 ||
            slapi_pblock_get( pb, SLAPI_EXT_OP_REQ_VALUE, &bval ) != 0 ) {
            msg = "Could not get OID and value from request.";
            slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs", "%s\n",
                 msg );
            slapi_send_ldap_result( pb, LDAP_OPERATIONS_ERROR, NULL,
                 msg, 0, NULL );
            return( SLAPI_PLUGIN_EXTENDED_SENT_RESULT );
        } else {
            slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs", 
                "Received extended operation request with OID %s\n",
                oid );
            slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs",
                "Value from client: %s\n", bval->bv_val );
        }

Since this is an extended operation, the OID sent by the client and the extended op data will be available in the pblock. The oid and bval returned are actual pointers into the internal data structures of the pblock and should not be freed or modified. Use slapi\_ch\_strdup() to make a copy of oid, and use ber\_bvdup() to make a copy of bval, if needed. The OID should be exactly the same as the one we registered in the init function below. This plug-in performs some data validation, and actually returns the LDAP result back to the client using slapi\_send\_ldap\_result(). The return code SLAPI\_PLUGIN\_EXTENDED\_SENT\_RESULT tells the server that the result was already handled. NOTE: It is a bad idea to print the bval-\>bv\_val using a %s printf specifier since it may not be a NULL terminated string. Use the field width format specifier with the bv\_len as the value. You never know what a malicious client might try to do (can you say buffer overflow or DoS?).

        /* Set up the value that you want returned to the client.
           In this case, it's just the value sent from the client,
           preceded by the string "Value from client: "  */

        msg = "Value from client: ";
        retval = ( char * )slapi_ch_malloc( bval->bv_len + strlen( msg ) + 1 );
        sprintf( retval, "%s%s", msg, bval->bv_val );

Again, this is a bad idea in production code. Use a length modifier when printing the bval-\>bv\_val and make sure the retval string is properly null terminated.

        retbval.bv_val = retval;
        retbval.bv_len = strlen( retbval.bv_val );

        /* Prepare to return the OID and value back to the client.
           Note that if you want, you can return a different OID to
           the client (for example, if you want to use the OID as 
           an indicator of something). */
        if ( slapi_pblock_set( pb, SLAPI_EXT_OP_RET_OID, "5.6.7.8" ) != 0 ||
            slapi_pblock_set( pb, SLAPI_EXT_OP_RET_VALUE, &retbval ) != 0 ) {
            slapi_ch_free( ( void ** ) &retval );
            msg = "Could not set return values";
            slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs", "%s\n",
                    msg );
            slapi_send_ldap_result( pb, LDAP_OPERATIONS_ERROR, NULL,
                    msg, 0, NULL );
            return( SLAPI_PLUGIN_EXTENDED_SENT_RESULT );
        }

        /* Send the response (containing the OID and value you set)
           back to the client. */
        slapi_send_ldap_result( pb, LDAP_SUCCESS, NULL,
            "operation babs successful!", 0, NULL );
        slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs", 
            "OID sent to client: %s\n", "5.6.7.8" );
        slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_babs",
            "Value sent to client: %s\n", retval );
            
        /* Free any memory allocated by this plug-in. */
        slapi_ch_free( ( void ** ) &retval );

        /* Let front end know we sent the result */
        return( SLAPI_PLUGIN_EXTENDED_SENT_RESULT );

Could also return 0 here to let the server handle the result.

    }

    /* Initialization function */
    #ifdef _WIN32
    __declspec(dllexport)
    #endif
    int
    testexop_init( Slapi_PBlock *pb )

This function is called when the plug-in shared object is first loaded into memory, usually at server start up time. This function name must be specified in the plug-in configuration entry under cn=plugins,cn=config. This function should not do very much, mostly just set the operation specific callback functions. The rest of the configuration should be done in the start function when the plug-in has access to the plug-in entry (which should have all of the plug-in configuration information). This plug-in has no start function, but a non-trivial extended operation handling plug-in would.

    {
        char    **oidlist, **namelist;

        oidlist = (char **) slapi_ch_malloc( 2 * sizeof( char * ) );
        oidlist[0] = MY_OID;
        oidlist[1] = NULL;
        namelist = (char **) slapi_ch_malloc( 2 * sizeof( char * ) );
        namelist[0] = "test extended op";
        namelist[1] = NULL;

        /* Register the plug-in function as an extended operation
           plug-in function that handles the operation identified by
           OID 1.2.3.4.  Also specify the version of the server 
           plug-in */ 
        if ( slapi_pblock_set( pb, SLAPI_PLUGIN_VERSION,
            SLAPI_PLUGIN_VERSION_01 ) != 0 || 
             slapi_pblock_set( pb, SLAPI_PLUGIN_DESCRIPTION,
            (void *)&expdesc ) != 0 ||

These two are always required.

             slapi_pblock_set( pb, SLAPI_PLUGIN_EXT_OP_FN,
            (void *) testexop_babs ) != 0 ||

This is required because this is an extended operation plug-in. We could also have a start function.

             slapi_pblock_set( pb, SLAPI_PLUGIN_EXT_OP_OIDLIST, oidlist ) ||
             slapi_pblock_set( pb, SLAPI_PLUGIN_EXT_OP_NAMELIST, namelist ) != 0 ) {

These are required. The oidlist is the NULL terminated array of strings, where each string is the OID handled by this plug-in. The namelist is a NULL terminated array of user friendly names corresponding to the OIDs in the OIDLIST.

            slapi_log_error( SLAPI_LOG_PLUGIN, "testexop_init",
                "Failed to set plug-in version, function, and OID.\n" );
            return( -1 );
        }

        return( 0 );
    }

### An Annotated Internal Modify Operation

The following is an example of how to perform a modify operation from a plug-in. You might want to do this, for example, after a BIND operation, to record the last login time in the user's entry.

In the following function, the dn is the DN of the entry to modify, the attrname is the name of the attribute to modify, and the newvalue is the value to REPLACE it with. REPLACE will add the attribute if it doesn't already exist, and will delete any old values. Note that this does not bypass schema checking, but it does bypass access control. Use slapi\_access\_allowed() if you need to check access.

You can only use this if you are sure that newvalue is a properly NULL terminated string. Otherwise, pass in the length explicitly, or use a struct berval.

orig\_pb is the original pblock from the plugin function called by the server. It is not used in this example, but provided in case there are parameters needed for subsequent operations.

    static int
    my_internal_modify(Slapi_PBlock *orig_pb, const char *dn, const char *attrname, const char *newvalue)
    {
        Slapi_PBlock *pb = NULL; /* every operation needs a pblock */
        Slapi_Mods *smods = NULL; /* to hold our modifies */
        int rc = 0; /* the result code of the operation */

        pb = slapi_pblock_new(); /* must allocate and init the pblock */
        smods = slapi_mods_new(); /* must allocate and init the smods */

This allocates memory that we need to free - see below.

        slapi_mods_add_string(smods, LDAP_MOD_REPLACE, attrname, newvalue);

You can only use slapi\_mods\_add\_string if you are absolutely positive that newvalue is a properly NULL terminated string. If not, use slapi\_mods\_add() and explicitly pass in the length, or use a struct berval \* with slapi\_mods\_add\_modbvps(). The slapi\_mods\_add\*() functions make copies of all strings passed in, and slapi\_mods\_free() will clean up all of those.

        slapi_modify_internal_set_pb(pb, dn, slapi_mods_get_ldapmods_byref(smods),
                                     NULL /* ldap controls */, NULL /* uniqueid */,
                                     my_plugin_identity /* my plugin identity */, 0 /* operation flags */);

This sets our modify arguments into the pb. slapi\_mods\_get\_ldapmods\_byref() passes the LDAPMod\*\* pointer. The first NULL is an LDAPControl\*\* list of any controls we want to apply. The second NULL is the uniqueid of the entry, which is primarily used in replication code. Every plug-in has an identity which is used internally to keep track of the plug-in. This is obtained in the plug-in init or start function and is usually kept in a static void\* (see above). The operation flags are any special modifiers we want to apply to this operation.

        slapi_modify_internal_pb(pb);

This is the actual call to perform the modifications.

        slapi_pblock_get(pb, SLAPI_PLUGIN_INTOP_RESULT, &rc);

This is the result code of our operation. If successful, rc will be 0 (LDAP\_SUCCESS). Otherwise, it will either be an LDAP result code that would normally be returned by an LDAP modify operation (e.g. LDAP\_CONSTRAINT\_VIOLATION, LDAP\_OBJECT\_CLASS\_VIOLATION, LDAP\_UNWILLING\_TO\_PERFORM, etc.) or a -1 which means some internal error occurred.

        if (LDAP_SUCCESS != rc) {
            char ebuf[BUFSIZ];
            slapi_log_error(SLAPI_LOG_FATAL, "my_plugin_name",
                            "Error [%d] for internal modify op for entry [%s] attribute [%s] value [%s]\n",
                            rc, escape_string(dn, ebuf), attrname, newvalue);
        }

Log an error message. Note: do not log newvalue if it could contain sensitive information. The escape\_string() is to make sure the DN value is readable by humans and parse-able by scripts.

        slapi_mods_free(&smods);

We pass in the address because slapi\_mods\_free will also set the pointer to NULL to avoid a double free. In simple code like this, it's no big deal. But if you have dozens of lines of code with branching and looping, it can be a real life saver.

        slapi_pblock_destroy(pb);

Have to clean up after ourselves.


        return rc;
    }

Here is the function in its entirety, un-annotated:

    static int
    my_internal_modify(Slapi_PBlock *orig_pb, const char *dn, const char *attrname, const char *newvalue)
    {
        Slapi_PBlock *pb = NULL; /* every operation needs a pblock */
        Slapi_Mods *smods = NULL; /* to hold our modifies */
        int rc = 0; /* the result code of the operation */

        pb = slapi_pblock_new(); /* must allocate and init the pblock */
        smods = slapi_mods_new(); /* must allocate and init the smods */

        slapi_mods_add_string(smods, LDAP_MOD_REPLACE, attrname, newvalue);

        slapi_modify_internal_set_pb(pb, dn, slapi_mods_get_ldapmods_byref(smods),
                                     NULL /* ldap controls */, NULL /* uniqueid */,
                                     my_plugin_identity /* my plugin identity */, 0 /* operation flags */);

        slapi_modify_internal_pb(pb);

        slapi_pblock_get(pb, SLAPI_PLUGIN_INTOP_RESULT, &rc);

        if (LDAP_SUCCESS != rc) {
            char ebuf[BUFSIZ];
            slapi_log_error(SLAPI_LOG_FATAL, "my_plugin_name",
                            "Error [%d] for internal modify op for entry [%s] attribute [%s] value [%s]\n",
                            rc, escape_string(dn, ebuf), attrname, newvalue);
        }

        slapi_mods_free(&smods);

        slapi_pblock_destroy(pb);

        return rc;
    }

Windows Sync Plugins
--------------------

[Windows Sync Plugin API](windows-sync-plugin-api.html)
