---
title: "Plugin Transactions"
---

# Plug-in Transaction Support
---------------------------

{% include toc.md %}

Overview
--------

The backend transaction mechanism provides operations in the same transaction session atomic and isolated. By including the plug-in operations in the primary operation's transaction session, it is guaranteed that the changes made by the plug-ins are always in sync with the primary operation.

Use Cases
---------

The existing plug-ins are switched to be backend transaction aware. For instance, MemberOf Plug-in "cn=MemberOf Plugin,cn=plugins,cn=config" could have "betxnpostoperation" plugin type instead of "postoperation" which used to be. If the plugin type is "postoperation", the plug-in is executed at the post-operation timing which is after the backend transaction is committed. If the type is "betxnpostoperation", it is executed inside of the transaction but after the target entry is updated in the backend database. If any error is occurred between the target entry's update and the Plug-in's operation or in the Plug-in's operation itself, it is easy to roll back the entire operation if "betxnpostoperation" is set. Otherwise, it will leave inconsistent results unless the error handling is enough.

Design
------

### Configuration Plug-in entry

The configuration Plug-in entry could have additional plugin types:

    nsslapd-pluginType: betxnpreoperation    
    nsslapd-pluginType: betxnpostoperation    

For the object pluginType plug-in, setting "on" to nsslapd-pluginbetxn turns the plug-in to execute the plug-in operations in the same transaction session as the primary operation.

### Backend transaction hooks

The following plug-in hooks are implemented for each operation:

    [Backend pre operation]    
    SLAPI_PLUGIN_BE_TXN_PRE_ADD_FN    
    SLAPI_PLUGIN_BE_TXN_PRE_MODIFY_FN    
    SLAPI_PLUGIN_BE_TXN_PRE_MODRDN_FN    
    SLAPI_PLUGIN_BE_TXN_PRE_DELETE_FN    
    SLAPI_PLUGIN_BE_TXN_PRE_DELETE_TOMBSTONE_FN    

    [Backend post operation]    
    SLAPI_PLUGIN_BE_TXN_POST_ADD_FN    
    SLAPI_PLUGIN_BE_TXN_POST_MODIFY_FN    
    SLAPI_PLUGIN_BE_TXN_POST_MODRDN_FN    
    SLAPI_PLUGIN_BE_TXN_POST_DELETE_FN    

### Plug-in init

Plug-in init function set to nsslapd-pluginInitfunc registers operation based init function, where betxn preop init function is set as follows.

    slapi_register_plugin("betxnpreoperation", 1 /* Enabled */,    
                           "    <pluginname>    _betxnpreop_init",    
                               <pluginname>    _betxnpretop_init,    
                           "    <pluginname>     betxnpreoperation plugin",    
                           NULL, identity);    

Also, betxn postop init function is set as follows.

    slapi_register_plugin("betxnpostoperation", 1 /* Enabled */,    
                           "    <pluginname>    _betxnpostop_init",    
                               <pluginname>    _betxnpostop_init,    
                           "    <pluginname>     betxnpostoperation plugin",    
                           NULL, identity);    

In each betxn preop and post op init function could set the function to these hook as being set to the existing hook:

    slapi_pblock_set(pb, SLAPI_PLUGIN_BE_TXN_POST_ADD_FN, add_fn);    
    slapi_pblock_set(pb, SLAPI_PLUGIN_BE_TXN_POST_MODIFY_FN, modify_fn);    
    slapi_pblock_set(pb, SLAPI_PLUGIN_BE_TXN_POST_MODRDN_FN, modrdn_fn);    
    slapi_pblock_set(pb, SLAPI_PLUGIN_BE_TXN_POST_DELETE_FN, delete_fn);    

### Deadlock warning

The existing Plug-ins are implemented as functioning with as well as without setting betxn. I.e., if you install 389-ds-base-1.3.1, plug-ins, betxnpre/postoperation is set to plugin type and nsslapd-pluginbetxn is "on" , by default. But by removing "betxn" from the plugin type and set "off" to nsslapd-pluginbetxn, the server works in the same way as the older versions do. If you have custom plug-ins which call update operations at the non betxn position, combining such plug-ins with betxn aware plug-ins could cause deadlock. Thus, until you update your plug-ins betxn aware, you may want to disable the betxn settings in the configuration.

### Transaction start, commit and abort Slapi API

In case, the plug-in needs to initiate the transaction, the transaction start, commit and abort Slapi APIs are available.

    slapi_back_transaction_begin(Slapi_PBlock *)    
    slapi_back_transaction_commit(Slapi_PBlock *)    
    slapi_back_transaction_abort(Slapi_PBlock *)    

There is an example in memberof\_fixup\_task\_thread (memberof.c) which requires the transaction to protect the task.

Please note that starting transaction acquires the backend lock, which could easily cause the deadlock with the other threads especially if the plug-in uses its own local mutex. Thus, initiating the transaction has to be implemented very carefully.

Updates and Upgrades
--------------------

As described in the above section, upgrading to 389-ds-base-1.3.1 enables betxn. If you have custom plug-ins which update entries in the database, you may need to disable betxn in the configuration. To disable betxn, remove "betxn" from nsslapd-pluginType value, i.e., betxnpreoperation -\> preoperation. And set "off" to nsslapd-pluginbetxn.

