---
title: "Extended Operation Plugin Transactions"
---

# Extended Operation Plugin Transaction Support
------------------------------------------------

{% include toc.md %}

Overview
--------

Pre-operation and Post-operations have a Backend Transaction (BE_TXN) type that provides guarantees of atomicity and isolation. This ensures that all plugins and operations succeed, or none do.

Extended operation plugins do not have this guarantee. Inside of an operation this may expose race conditions, deadlocking due to operation ordering, and other issues.

We should add a BE_TXN type for extended operations to optionally use. 

Use Cases
---------

Plugins should not have to consider transactions or database consistency. Plugin developers should know that either their operation suceeded, and they can continue, or to return an error, and trust that slapd will rollback the transaction.

We also prevent race conditions such as in password-extop, where between the password validation check, and the password being change, time elapses. Consider someone changes their password from two locations at the same time: Which one wins? If we used transactions around password-exop, one operation would fail as the current password no longer matches as it was changed by the former change.

We have seen deadlocks between plugins that implement both extended operations and BE_TXN_PRE_OP and BE_TXN_POST_OP types: This is due to lock ordering being inconsistent between the exop type, and the pre/post op types.

This also helps to make extended operation plugins that are developed in the future safer.

Design
------

### Configuration plugin entry

The new plugin type is added:

    nsslapd-plugintype: betxnextendedop

The following backend hooks are added:

    SLAPI_PLUGIN_EXT_OP_FN
    SLAPI_PLUGIN_EXT_OP_BACKEND_FN

For a plugin to be betxnextendedop both plugin hooks must be implemented.

### Plugin init

This is identical to extendedop plugin initialisation.

        slapi_register_plugin("betxnextendedop", /* op type */                   
                              1,        /* Enabled */                            
                              "dna_init",   /* this function desc */             
                              dna_exop_init,  /* init func for exop */           
                              DNA_EXOP_DESC,      /* plugin desc */               
                              NULL,     /* ? */                                                                 
                              plugin_identity   /* access control */             
        ) 

The dna_exop_init function then registers the backend hooks:

        slapi_pblock_set(pb, SLAPI_PLUGIN_EXT_OP_FN,                             
                         (void *) dna_extend_exop) != 0 ||                       
        slapi_pblock_set(pb, SLAPI_PLUGIN_EXT_OP_BACKEND_FN,                     
                         (void *) dna_extend_exop_backend) != 0) {  


### Deadlock warning

Plugins that implement betxnextendedop should be re-designed to use this. IE they should start no transactions of their own, and should be careful to return correct error codes.

Additionally, plugins that implement Pre/Post operations should commit to either BE_TXN for ALL hook types, or none of them. A mixture of BE_TXN for Pre/Post, but normal extended op types will lead to deadlock.

### Backend helper hook

The primary difference between BE_TXN for extended operations versus normal pre and post operations is determination of the backend to work upon.

During the BE_TXN for a pre-post op, early in the operation, the backend is selected for use base on the base dn of the operation in question. This allows transactions on the backend to proceed.

However, extended operations don't have this clearly in their operations. Each operation has their own ASN.1 structure and encoding. It's up to the extended operation plugin to know what they are working on.

As a result, this is why the SLAPI_PLUGIN_EXT_OP_BACKEND_FN hook has been added. This allows the plugin, given some operation and ASN.1 structure to indicate to slapd what backend *will* be operated on, without any other interaction taking place.

Once the backend hint is complete, the transaction can then begun on the correct backend for the extended operation.

Updates and Upgrades
--------------------

Due to the addition of a new plugin type, some external plugin implementations may need recompilation.

