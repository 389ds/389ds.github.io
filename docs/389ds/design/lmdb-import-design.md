---
title: "LMDB Import Design"
---

# LMDB Import - Software Design Specification
-------------------------------------------------------

{% include toc.md %}

Introduction
------------

The first implementation of "import" functionality based on import for bdb has two major drawbacks:
    - bad performance compared to bdb import
    - database size grows out of control
This document present a proposal to fix theses issues.
By "import" I mean the ldif2db, reindex, total update and upgrade functionalities.

## bdb import synopsys
--------------------
In bdb plugibn code there are two way to import things
    - reindex / upgrade
    - import / total update

### bdb reindex / upgrade synopsys
---------------------------------

reindex is handled by a single thread that read the entries then update the indexes.

### bdb import / total update  synopsys
--------------------------------------

importi/total update is handled by a set of threads:

| thread | role |
| --- | --- |
|ldif2db provider |read ldif entries and push them towards foreman |
|total update provider |push added entry towards foreman |
|foreman |write entry in db, update special indexes like entryrdn, push entry towards workers |
|worker |There are one worker per attributes (regular or vlv) to index.  a worker thread is in charge of updating a single attribute |

This is quite efficient because a thread handled all the write in a db instance. Infortunately lmdb allows only a single active write txn
so the write cannot be parallelized (and by calling back some backend function, read txn are implicitely used which also cause trouble with lmdb )

Proposed lmdb import synopsys
-----------------------------
The idea is to have the same model for all functions with the following threads:

| thread | role |
| --- | --- |
|index/upgrade provider | read entries from id2entry (releasing the txn aftewards) and push them towards workers |
|ldif2db provider | read ldif entries and push them towards workers |
|total update provider | push added entry towards workers |
|workers | Compute ancestors ids (from DN or from parent id) using entryrdn cache or entryrdn db instance<br> Push toward writer the 3 entryrdn keys (The entry, The parent entry, The child entry (of parent)) and data<br> Push toward writer the ancestorid keys and data<br> Push toward writer the id2entry  key and data<br> Push toward writer all indexes keys and data |
|writer | Wait until enough triplet (dbi, key, data) are in the queue the open a write txn<br> put key,data in dbi then commit the txn and flush the entryrdn cache |

This way read txn are only used when looking up entryrdn (if not in cache)
and write txn are not only serialized but handled in batch.


## Detailed Design

### Functions

#### InitWorkerSlots
    Change backend state (to referral)
    if Import of Total update:
        delete the backend bdi ...

    Generate be attribute list and open/create associated dbi
        Special dbi/indexes:	
            id2entry (if upgrade rename it to :id2entry to avoid overwriting it.
            ANCESTORID
            ENTRYRDN
            numsubordinates
	    Note: in upgrade/reindex case the entries keep the same id, and entryrdn is not recomputed because:
          * migration from old dn model to "new" dn model support is not supported over bdb.
          * if entryrdn is broken we are no more able to get the entry dn anyway
        avl_apply(job->inst->inst_attrs, (IFP)dbmdb_import_attr_callback,
                  (caddr_t)job, -1, AVL_INORDER);
        vlv_getindices((IFP)dbmdb_import_attr_callback, (void *)job, be);
    if upgrade/reindex:
        Determine which attribute must be indexed
    For all reindexed file:
        reset the dbi and mark it as DIRTY
        set the index off line (index->ai->ai_indexmask &= ~INDEX_OFFLINE)
    Compute nbslot accoding to util_get_hardware_threads()
    start worker threads and writer thread

#### Provider:

| Mode | Caller | Action |
| --- | --- | --- |
| index/upgrade | index/upgrade | Get next entry in id2entry (reopening a txn and a cursor / moving to last seen id and getting next one) ==> push id and entry data to worker |
| import | dbmdb_db2ldif | Get next entry in ldif file, generate an id and push the id and the entry ldif string to worker |
| total update | dbmdb_bulk_import_queue | push the entry to worker |

    Find a free slot to store entry with id PidE and DN rdn/nrdn and idP (and reserve it)
    if no free slot wait until we can get a free slot)
    store in slot: entry id (import/total udate case) and entry data
      id2entry data in (reindex/update case)
      ldif entry stanza in import case
      plain fully decoded entry in total update case
    mark slot as ready
    get next entry

#### Worker (slot s):
   Wait until slot s get ready:
   Mark slot as busy
   decode entry to get a fully decoded entry
   determine the ancestors ids and rdn_element (either from parent id or from parent dn)
       [0] From worker slot micro cache (that contains last entry and its ancestors (id + rdn_elem))
       [1] From writer cache (containing the not yet commited write txn (id + rdn_elem))
       [2] From rdn index (using entryrdn_index_read_ext)
   if not found
       wait until no worker works on id below the entry id and retest [1] and [2]
	   if still not found
	        mark the entry as skipped (if import) or as fatal error (otherwise)
                mark slot as free
                loop back to "Wait until slot s get ready"
    update the micro cache
    push in writer queue  entryrdn: 'P' entry id ==> rdn_element(parent id, parent RDN)
    push in writer queue entryrdn: entry id ==>  rdn_element(entry id, entry RDN)
    push in writer queue entryrdn: 'C' parent id ==> rdn_element(entry id + entry RDN)
    push in writer cache queue entry id + entry rdn_element
    for each id in ancestors
      push in writer queue ancestorid: id-ancestor -> id->entry
    for each attribute in entry
      if attribute is indexed
        generate index key (similar to what is done in index_addordel_values_ext_sv without storing the data)
    for each vlv index
	  if entry matchs the filter
        generate the key (as vlv_update_index without storing the data)
        push in writer queue index dbi: key -> entry Id
    encode entry to string (similar to id2entry_add_ext but without storing the entry)
    push in writer queue  id2enytry:  entryid (id_internal_to_stored(e->ep_id, temp_id);)  ==> entrystr


###  Writer
   Wait until (WriterDone is pushed) or Queue is full
   Clear parent cache
   Open write txn
   for each item in queue
    put dbi  -> key, data
   Commit TXN
   if writerDone has been it
       mark thread as finished.
       exit the thread

###Epilogue
    if (abort flags is set) {
        remove all backend dbis
        exit
    }

    if numsubordonate is being indexed
        walk id2entry (or renamed id2entry)
            if id in ancestorid
                decode entry
                update numsubordonate
                reencode entry
                write it back in id2entry
    Mark all reindexed dbi as not DIRTY
    Mark all reindexed index as online
    change backend state back to the original state

### Data
#### Queues:
##### Worker queue
 		The "queue" should have:
            - a global mutex and condvar to:
                -  wait until a slot gets free (when all slots are busy)
                -  wait until current slot gets ready
            - the number of slots (i.e the number of workers)
            - an array of slots
            - a counter for wait_id
        each queue element (slots) should contains:
            - A state flag - telling whether slot is free - ready - busy 
 		    - ID wait_id - (the ID is a simple counter which may be used as entryID in import or total update case.
            - A FifoItem to determine the entry and its error logging data
 			  Note: the "entry" field contains:
                 - ldif text in case of import
                 - id2entry data in case of reindex or upgrade
                 - pointer to backentry in total update case
        functions should be:
            - void ImportWorkerQueuePush(InfoJob *info, FifoItem *item)
            - ImportWorkerQueuedata ImportWorkerQueuePop(InfoJob *info, int slotid) 

##### Writer queue
 		The "queue" should have:
            - a global mutex and condvar to:
                -  wait until enough data get queueed to start a write txn into the db
            - a counter (the queue lenght)
            - the entryrdn current cache
            - the entryrdn previous cache ( current cache is moved to previous one when 
            -  flushing the queue (just before starting the write txn)
 		The queue element should contains:
            - dbi
            - key
            - data
    Writer cache queue (illimitee)
        parent entry id - parent entry rdn - parent entry dn
		
#### Caches:
##### EntryRdn cache
That is typically the entryrdn caches
We need it:
* to convert a DN into ancestor id list
* to convert an ID into ancestor id list
* get the rdn_elem of the parent to generate the new entryrdn records
So a cache entry should contains:
* entryID
* parentID
* rdn_elem (i.e the "data" within entryrdn.db record)
* wait_id (wait_id is used to determine what to do if value is not found:
    * wait until all wait_id lesser than current wait_id are removed then retry.
    * returns NO_SUCH_OBJECT error
* the cache handle (so we can release it to be able to free the resources when they are no more used)
And is looked up either by:
    *id + wait_id
    *parent id + rdn + wait_id
Actions:
    cacheInit(maxworkers)
    cacheAddWaitID(cache, wait_id, workerId)
    cacheAddEntry(cache, wait_id, entryId, parentId, rdn_elem)
    cacheClear(cache) remove all entries except wait_id
    cacheIDLookup(cache, wait_id, entryId)
    cacheRDNLookup(cache, wait_id, parentId, rdn)

#### Other data:
##### ImportJob:
The ImportJob struct is reused with the following restriction:

|Field|Usage |
| --- | --- |
|task |x |
|flags |x |
|input_filenames |x |
|index_list |x |
|worker_list |x |
|number_indexers |x |
|starting_ID |x |
|first_ID |x |
|lead_ID |x |
|ready_ID |x |
|ready_EID |x |
|trailing_ID |x |
|current_pass |x |
|total_pass |x |
|skipped |x |
|not_here_skipped |x |
|merge_chunk_size |x |
|voodoo logic for deciding when to begin |x |
|uuid_gen_type |x |
|uuid_namespace |x |
|mothers |x |
|average_progress_rate |x |
|recent_progress_rate |x |
|cache_hit_ratio |x |
|start_time |x |
|progress_history |x |
|progress_times |x |
|job_index_buffer_size |x |
|job_index_buffer_suggestion |x |
|include_subtrees |x |
|exclude_subtrees |x |
|fifo |x |
|task_status |x |
|wire_lock |x |
|wire_cv |x |
|main_thread |x |
|encrypt |x |
|usn_value |x |
|upgradefd |x |
|numsubordinates |x |
|writer_ctx |x |
