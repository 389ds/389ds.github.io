---
title: "Deferred update of memberof attribute"
---

# Deferred update of memberof attribute

## Overview
--------

Memberof plugin maintains the values of membership attribute (like memberof) in entries that are member (direct or indirect) of a group. To do so it monitor updates of groups. For such update it computes which member entries are impacted by the update. Then for each target entry, it computes all the groups that the entry belongs to , then adds the list of groups to the attribute 'memberof' in the target entry.

A concern with this plugin is that the update of a group can trigger many updates of the members (for example adding 10K members to a group). As a consequence a large number of entries (e.g. 10K) are updated, in an atomic way with a **single** transaction. The more entries are impacted the more likely the transaction last. Until the transaction is committed, no other operation can access (read or write) the database pages impacted by the transaction.


The problem with this approach is that many other operations may have to wait until the transaction is committed, **slowing down** the waiting operations and in worse case making the LDAP server **unresponsive** in case all its workers are waiting for the commit.

This problem is specific to the current default database (Berkeley DB).

In short, because of memberof plugin, a large update of a group can freeze (in read and in write) a large portion of the database for a long period of time.

## Deferred update Design
------------

### Description of the solution
------------

The main constraint is that BDB transaction model blocks read access to a database page when the page is held in write. This constraint creates a problem when pages are held in write for a long time. To mitigate the problem, so reduce duration and likelywood of page contention, the **single** large transaction is split into **several** smaller transactions. Each targeted entry (impacted by the original update) is now updated with a specific transaction.

The drawback is that such updates are **no longer atomic** and we can imagine that some updates may fail while others are successful. In such case, the only solution is to rebuild membership with memberof fixup task.

### Implementation
------------

#### Server Startup
------------

When the RFE is enabled, memberof plugin creates **a pipe** (*deferred_list*) into its configuration structure and **spawn a dedicated thread** (*deferred update thread*) that will consume what will be written in the pipe. If at startup of the thread, the attribute *memberOfNeedFixup* is set to 'true' then the thread launch a **fixup** task before processing any other update.

Before entering its main loop, the deferred update thread updates the memberof plugin configuration entry and set *memberOfNeedFixup: true*. So if the server would terminate unexpectedly it will run fixup at restart

If the RFE is disabled, no pipe nor dedicated deferred update thread is spawn

#### Server running

If the RFE is **disabled**, then during the update of a group then the impacted members are updated the normal way according to the plugin type BE_TXN_POST (i.e. the **same** transaction and the **same** thread)

In the rest of the paragraph we assume that the RFE is enabled.

When the server processes an update (ADD/DEL/MOD/MODRDN), in BE_TXN_POSTOP callback, it flags the operation (*pb_deferred_memberof* in the pblock) as still running and temporary stored the operation (*memberof_deferred_task* via *SLAPI_MEMBEROF_DEFERRED_TASK*) in pblock_intop. Then it returns successfully , letting complete the transaction of the update of group. So the group is updated immediately and independently of the updates of the members.

The operation is **added** in the pipe by **BE_POSTOP** callbacks. This is because the update of the group must be committed (TXN) so that the deferred update thread will access a database up to date. The be_postop handler is the callback *memberof_push_deferred_task* and is registered for ADD/DEL/MOD/MODRDN. Once an operation is added to the pipe, then *memberof_push_deferred_task* callback signals (*deferred_list_cv*) the deferred update thread that an operation is available.

The flag *pb_deferred_memberof* (define *SLAPI_DEFERRED_MEMBEROF*) is useful to delay the response to the update of the group until all members have been updated. It is set during BE_TXN_POSTOP callback and consumed by the backend callback (ldbm_back_xxx). The backend callbacks, are **waiting** until *pb_deferred_memberof* is reset before returning the operation result.

Operations added to the pipe are **consumed** by the deferred update thread (*deferred_thread_func*). This thread loops until shutdown. It waits (*deferred_list_cv*) for operation to process. When an operation is read from the pipe, the thread evaluates the impacted members and updates each of them. Each of the update use its **own** transaction. When this is completed it reset the flag *pb_deferred_memberof* (define *SLAPI_DEFERRED_MEMBEROF*) to "signal" the backend callbacks to return the result.

#### Server Shutdown
------------

At exit of its main loop, the deferred update thread updates the memberof plugin configuration entry and set *memberOfNeedFixup: false*. Indeed all tasks have been completed so there is no need to run fixup at next restart.


#### data structure

The RFE supports two new attributes in the configuration entry of the memberof plugin
 - memberOfDeferredUpdate ON|OFF
 - memberOfNeedFixup true|false

*memberOfDeferredUpdate* request that the plugin run the updates of the impacted member (add/del 'memberof') in different transactions than the update of the group. *memberOfNeedFixup* is set to 'true' at the startup of the deferred update thread and to 'false' at shutdown. So in case of unexpected termination of the process, the plugin will run memberof fixup task at restart.

The RFE updates the configuration of the plugin with 3 new
 - deferred_update is set to TRUE when the configuration attribute of the 

```
    typedef struct memberofconfig
     {
         ...
         PRBool deferred_update;
         MemberofDeferredList *deferred_list;
         int need_fixup;
     } MemberOfConfig;

```

The RFE updates the pblock to flag that the operation is still under process, to prevent to return the result immediately

```
typedef struct slapi_pblock
{
    /* common */
    ...
    int pb_deferred_memberof;

} slapi_pblock;

```

The RFE updates the pblock_intop to temporary store the deferred update. The deferred update is stored during
BE_TXN_POSTOP then consumed and push into the pipe during BE_POSTOP

```
    typedef struct _slapi_pblock_intop
    {
       ....

        void *memberof_deferred_task;
    } slapi_pblock_intop;
```

## Configuration
------------------------

To enable the RFE set the value: **memberOfDeferredUpdate: on** in the configuration entry of the memberof plugin

```
    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    memberOfDeferredUpdate: on
```


Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6304>


Author
-----------------------

<tbordaz@redhat.com>

