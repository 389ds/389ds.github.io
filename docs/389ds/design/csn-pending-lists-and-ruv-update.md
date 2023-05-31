---
title: "CSN Pending Lists and RUV update"
---

# CSN Pending Lists and RUV update
----------------

# Introduction
The RUV (replication update vector) maintains for every master replica (identified by the replicaID) in the replication topology the largest CSN (change sequence number) it has seen that originated at that replica. In a replication session the supplier compares its own RUV with the RUV of the consumer and decides if there are changes to be sent. At the end the RUV of the consumer is updated and is used as staribg point in a new replication session.

# Problem:
Therefor it is crucial that the menchanism of applying updates to the local database, updating the local RUV and sendin changes (and so updating the consumer RUV) are synchronized and no changes will be lost. Zhis is managed by maintaining a CSN pending list:
A csn pending list is a list of CSNs which have not yet been used to update the maxcsn of the RUV. There are two scenarios where it is necessary to keep a pending list and only update the RUV with a specific CSN of this list after all CSN in the list which are smaller are committed. It is also required to ensure that the RUV is not updated if an operation is aborted.


Scenario 1: There are parallel write operations.

Assume operations 1,2,3 are started with csn_1 < csn_2 < csn_3. If op_3 completes first and would commit and update the ruv, the server would send op_3 to a consumer, the consumer would update it's RUV with csn_3 and if later op_1 and op_2 are committed they would not be sent to the consumer because their csn < csn_3.

    NOTE: this scenario is not possible with the current use of the backend lock, but I think this very scenario was the reason to introduce the pending list.


Scenario 2: Internal operations inside the main operation.

An operation is started with csn_1. Plugins are called and can trigger internal updates with csn_2,....csn_5. All these operations are done in nested transactions- If one of the plugins or the main operation fails, the transactions are aborted and undone. None of the changes will survive and they will not be in the changelog. If any of the CSNs csn_1 ... csn_5 would have updated the RUV then the RUV would be ahead of the changelog and cursor position will fail. Therefore the pending list should ensure that only after all the csns 1..5 have successfully be committed the RUV is updated.


There are two variants of this scenario:

Scenario 2.1: the main operation is a direct client operation, so all csns have the same replica id

Scenario 2.2: the main operation is a replicated operation, so the csn for the main operation and the internal operation have different replica ids

Scenario 2.3: One of the plugins triggers an internal update in an otehr backend with different RUV and pending lists.


# Original implemention


We have two types of csn pending list.

1] A pending list of min csns maintained in the replica object.

This is a very specific list and only used until the min csn in the RUV for the local replicaID is set.
It will not be affected by this design change.


2] a pending list in each ruv element

When a csn is created or received (either in replica_generate_next_csn() or in process_operation() in mmr preop), it is inserted into the pending list of the ruv element with the corresponding replica ID.


When an operation fails, in process_postop the csn is cancelled and removed from the pending list.


When an operation succeeds write_changelog_and_ruv() triggers a special handling of the pending list.

It sets the state of the csn of the completed operation to committed and it rolls up the pending list to detect the highest committed csn and updates the RUV with this csn.


Problems with original implementation


All csns in the pending list are seen as csns of independent operation, the fact that csn of internal ops are tied to the main op is not reflected. If the main op is aborted the ruv can already have been updated with a csn from an internal op.

Since the fix for ticket #359 the pending list rollup ignores not committed csns and selects the highest commited csn to update the ruv
the pending lists for the different ruv elements are treated independently. Even if the fix for #359 would be reverted, this would handle only scenario 2.1, not 2.2

There is an asymmetry between committing and cancelling an csn. The commit is inside the txn and backend lock, wheres the cancelling is in postop and in some cases (urp) the ldap_errror could already have been reset and the csn will not be cancelled and remain uncommitted (this was the scenario which was fixed in #359)


# New Design

## Terminology:

Operation csn (op_csn): csn of a processed operation, either internal, direct external or replicated external operation

Primary csn (prim_csn): the csn of an external operation, direct or replicated. For an external operation op_csn == prim_csn

Primary csn context (prim_ctx): the context of the primary csn identified by the prim_csn itself, the replica it applied to and the thread handling it


## Valid conditions:

 1. All operations for a primary csn and its secondary csns are processed in one thread

 2. There are only one or two replica IDs used in the pending list for one replica in a full operation. In the scenario 2.3 there are several replicas affected, but in the replicas different from the primary replica only a csn with the local replicaID can be generated.

 3. In one thread the identical csn can be generated if if multiple backends do have the same replicaID. The thread ID is not sufficient to distinguish a prim_csn from an op_csn in another replica

 4. For one replica no two identical csns can be generated, even if threads would apply operations in parallel. The replica reference is sufficient to tarck the prim_csn-

## Proposal:

Define a primary csn context, consisting of a prim_csn and an array of replicas having csns generated in that context.

    #define CSNPL_CTX_REPLCNT 4
    typedef struct CSNPL_CTX
    {
        CSN *prim_csn;
        int repl_alloc; /* max number of replicas  */
        int repl_cnt; /* number of replicas affected by operation */
        Replica *def_repl[CSNPL_CTX_REPLCNT]; /* pirm array of affected replicas */
        Replica **replicas; /* additional replicas affected */
    } CSNPL_CTX;

    NOTE 1: In most deployments there will be only one or a few replicas affected by operations in a prim_ctx, so there will be no need for rallocations.
    replicas will be set to def_repl and only allocated if needed (in add_replica_to_primcsn() )

    NOTE 2: the primary replica will always be replicas[0]

Maintain the primary csn context in thead local data, like it is used for the agreement name (or txn stack): prim_ctx.

    void set_thread_primary_csn (const CSN *prim_csn, Replica *repl)
    CSNPL_CTX* get_thread_primary_csn(void)

Extend the data structure of the pending list to keep prim_csn and replica for each inserted csn.

    typedef struct _csnpldata
    {
        PRBool  committed;  /* True if CSN committed */
        CSN     *csn;       /* The actual CSN */
    +   Replica * prim_replica; /* The replica where the prom csn was generated */
        const CSN *prim_csn;  /* The primary CSN of an operation consising of multiple sub ops*/
    } csnpldata;

If a csn is created or received check prim_ctx: if it exists use it, if it doesn't exist set it

When inserting a csn to the pending list:

- pass the prim_csn

- check if the replica is contained in the prim_ctx, if not add it

        prim_csn = get_thread_primary_csn();
        if (prim_csn == NULL) {
            set_thread_primary_csn(csn);
            set_thread_primary_csn(csn, (Replica *)repl);
            prim_csn = get_thread_primary_csn();
        } else {
           /* the prim csn data already exist, need to check if
            * current replica is already present
            */
           add_replica_to_primcsn(prim_csn, (Replica *)repl);
        }

When cancelling a csn,

- if it is the prim_csn also cancel all secondary csns in all replicas in the prim_ctx

        int ruv_cancel_csn_inprogress (void *repl, RUV *ruv, const CSN *csn, ReplicaId local_rid)
        ...
        if (prim_csn &&
            csn_is_equal(csn, prim_csn->prim_csn) &&
           (Replica *)repl == prim_csn->replicas[0]) {
               for all replicas[i] != 0
                   get ruv for local rid
                   ....
                   csnplRemoveAll(....)
           }

- else just remove the csn from the local pending list

        else
            csnplRemove(.)


When committing a csn,

- if it is not the primary csn, do nothing

- if it is the prim_csn

    - commit all op_csns for the prim_csn in all replicas in the prim_ctx

    - trigger the pending list rollup, stop at the first not committed csn and update the maxcsn in the RUV

    - in the primary replica, if the RID of the prim_csn is not the local RID also rollup the pending list for the local RID.

            if local rid != prim rid
                ruv_update_ruv_elememt (ruv element for prim rid)
            for all replicas[i] != 0
                ruv_update_ruv_elememt (ruv element for local rid of replicas[i])



# Origin
-------------

* Ticket [\#2067](https://github.com/389ds/389-ds-base/issues/2067) aborted operation can leave RUV in incorrect state
* Ticket [\#2346](https://github.com/389ds/389-ds-base/issues/2346) replication halt - pending list first CSN not committed, pending list increasing

Author
------

<lkrispen@redhat.com>
