---
title: "Replication Session Hooks"
---

# Replication Session Hooks
----------------------------

{% include toc.md %}

### Introduction

Server applications that use DS as it's backend data store may want to have more control over when replication is allowed to occur. An example of this is how FreeIPA would like to deal with major version upgrades. In the FreeIPA case, replication should not occur between different major FreeIPA versions to prevent data inconsistency due to configuration or data format changes. This extra control can be provided by adding the ability to hook into the replication plug-in when a replication session is started.

Callback Hooks
--------------

A number of callback hooks need to be provided at various points in the replication session. The callback hooks need to be available for both the sending and receiving sides, for both total update and incremental update replication sessions. The callback functions need to have the ability to terminate the replication session before sending updates based on their return code. This termination should be possible from both the sending and receiving side.

Here are the available callback hooks listed in execution order:

     replication agreement init    
     acquire replica pre (sending side)    
     acquire replica receive (receiving side)    
     acquire replica reply (receiving side)    
     acquire replica post (sending side)    
     replication agreement destroy    

### Callback Data

The callback functions also need to be able to send and receive some arbitrary data on each end of the replication session. This will allow data such as a version number to be communicated between both parties, allowing the session to be allowed/disallowed as deemed appropriate by the callback functions.

In order to support arbitrary data being sent, there needs to be some sort of identifier sent along with the opaque data. If the identifier matches what the receiving side expects, it can then make assumptions about the format of the data. If the identifier does not match, the data must not be accessed, as the receiving side has no way of knowing the format of the data. This identifier is recommended to be a GUID. The GUID parameter is a null terminated string. The data parameter is a berval structure to allow complex data to be sent and cast to the appropriate type on the receiving side after the GUID is checked.

In order to be able to send extra data from the callbacks, the replication protocol needs to be slightly modified. These protocol changes are confined to the start replication request and replication response extended operations. A new version of these extended operations (with new OIDs) are defined with two extra optional fields for the GUID and the data. Support for these new extended operations will be advertised in the root DSE. The replication plug-in will check the root DSE to determine if it can send these newer style extended operations to another server prior to actually sending the operations. If the other side does not support the new style extended operations, it will fall back to the old style extended operations. No additional data will be sent in this case.

### Callback Implementation

#### Replication Agreement Init

This callback is called when a replication agreement is created. The repl\_subtree from the agreement is read-only. The callback can allocate some private data to return. If so the callback must define a repl\_session\_plugin\_destroy\_agmt\_cb so that the private data can be freed. This private data is passed to other callback functions on a master as the void \*cookie argument.

    typedef void * (*repl_session_plugin_agmt_init_cb)(const Slapi_DN *repl_subtree);    

#### Acquire Replica Callbacks

The pre and post callbacks are called on the sending (master) side. The receive and reply callbacks are called on the receiving (replica) side.

Data can be exchanged between the sending and receiving sides using these callbacks by using the data\_guid and data parameters. The data guid is used as an identifier to confirm the data type. Your callbacks that receive data must consult the data\_guid before attempting to read the data parameter. This allows you to confirm that the same replication session plug-in is being used on both sides before making assumptions about the format of the data. The callbacks use these parameters as follows:

      pre - send data to replica    
      recv - receive data from master    
      reply - send data to master    
      post - receive data from replica    

The memory used by data\_guid and data should be allocated in the pre and reply callbacks. The replication plug-in is responsible for freeing this memory, so they should not be free'd in the callbacks.

The return value of the callbacks should be 0 to allow replication to continue. A non-0 return value will cause the replication session to be abandoned, causing the master to go into incremental backoff mode.

    typedef int (*repl_session_plugin_pre_acquire_cb)(void *cookie, const Slapi_DN *repl_subtree,    
                                              int is_total, char **data_guid, struct berval **data);    

    typedef int (*repl_session_plugin_reply_acquire_cb)(const char *repl_subtree, int is_total,    
                                                       char **data_guid, struct berval **data);    

    typedef int (*repl_session_plugin_post_acquire_cb)(void *cookie, const Slapi_DN *repl_subtree,    
                                              int is_total, const char *data_guid, const struct berval *data);    

    typedef int (*repl_session_plugin_recv_acquire_cb)(const char *repl_subtree, int is_total,    
                                              const char *data_guid, const struct berval *data);    

#### Replication Agreement Destroy

The replication subtree from the agreement is passed in. This is read only. The plugin must define this function to free the cookie allocated in the init function, if any.

    typedef void (*repl_session_plugin_destroy_agmt_cb)(void *cookie, const Slapi_DN *repl_subtree);    

Callback Usage
--------------

The replication session hook callbacks are registered via the SLAPI API broker. A standard SLAPI plug-in is written that registers its replication session callbacks at plug-in initialization time.

A new header file named *replication-session-plugin.h* will be installed as a part of the 389-ds-base-devel subpackage. This header file has all of the callback typedefs and defines needed to register the replication session callbacks.

To register the callbacks, you must create an array of your callback functions in a particular order and pass it to the *slapi\_apib\_register()* function in your plug-in init function along with the replication session callback API GUID. The order that the callbacks must be listed in the array is:

    - agreement init    
    - pre acquire    
    - reply acquire    
    - post acquire    
    - receive acquire    
    - agreement destroy    

If you don't wish to register a particular callback, you can simply set that array element to *NULL*.

Here is an example of defining the callback array and registering the callbacks:

    static void *test_repl_session_api[] = {    
       NULL, /* reserved for api broker use, must be zero */    
       test_repl_session_plugin_agmt_init_cb,    
       test_repl_session_plugin_pre_acquire_cb,    
       test_repl_session_plugin_reply_acquire_cb,    
       test_repl_session_plugin_post_acquire_cb,    
       test_repl_session_plugin_recv_acquire_cb,    
       test_repl_session_plugin_destroy_cb    
    };    

    int test_repl_session_plugin_init(Slapi_PBlock *pb)    
    {    
    ...    
       if( slapi_apib_register(REPL_SESSION_v1_0_GUID, test_repl_session_api) ) {    
           slapi_log_error( SLAPI_LOG_FATAL, test_repl_session_plugin_name,    
                            "<-- test_repl_session_plugin_start -- failed to register repl_session api -- end\n");    
           return -1;    
       }    
    ...    
    }    
