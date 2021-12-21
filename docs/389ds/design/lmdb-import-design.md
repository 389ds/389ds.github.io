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
   prepare the entry
       decode the data to get a fully decoded backentry
   process entryrdn
       determine the ancestors ids and rdn_element by querying the rdncache (either from parent id or from parent dn) 
           [0] From worker slot micro cache (that contains last entry and its ancestors (id + rdn_elem))
           [1] From writer cache (containing the not yet commited write txn (id + rdn_elem))
           [2] From rdn index (using entryrdn_index_read_ext)
        if not found
            mark the entry as skipped (if import) or as fatal error (otherwise)
            mark slot as free
            loop back to "Wait until slot s get ready"
        update entryrdn cache and check if added elem has the right id 
	    otherwise try to handle duplicate DN 
	      either by aborting or skipping the entry or renaming the entry or then as tombstone entry
        push in writer queue  entryrdn: 'P' entry id ==> rdn_element(parent id, parent RDN)
        push in writer queue entryrdn: entry id ==>  rdn_element(entry id, entry RDN)
        push in writer queue entryrdn: 'C' parent id ==> rdn_element(entry id + entry RDN)
        ( note if entry is the suffix only nrdn ==> rdn_element(entry id, entry RDN) is pushed )
        push in writer parentid: queue parent id ==> entry id
        for each id in ancestors
        push in writer queue ancestorid: id-ancestor ==> id->entry
    Release the slot s and signal the other threads 
	process foreman
        encode and push the entry in writer thread queue. (id2enytry: entry id ==> encoded data 
    process standard index:
	    for each attribute in entry
          if attribute is indexed
            generate index key (similar to what is done in index_addordel_values_ext_sv without storing the data)
    process vlv index:
	    for each vlv index
	      if entry matchs the filter
            generate the key (as vlv_update_index without storing the data)
            push in writer queue index dbi: key -> entry Id


###  Writer
   Wait until producer and all worker threads have finished or until queue has more than 2000 elements.
   use compare and swap atomic operation to get the queued elements and 
   reset the queue 
   If no element finish the thread
   Open write txn
   for each element in queue
    put dbi  -> key, data
   Commit TXN
   and loop back to waiting for element

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

######Why using a cache:
The main goal of this cache is to held the entryrdn elem that have been queued to the writer thread but not yet fully written in the entryrdn.db database instance (i.e before txn get committed).
It also store the ancestors elem in the cache to try to speed up the ancestor discovery. 
( this is efficient if there is lot of entries having same parent and not so efficient if tree is deeply nested )

######Access method
There are mostly 3 methods:
* Adding a new elem:
    RDNcacheElem_t *rdncache_add_elem(RDNcache_t *cache, WorkerQueueData_t *slot, ID entryid, ID parentid, int nrdnlen, const char *nrdn, int rdnlen, const char *rdn)
* lookup by entry id:
    RDNcacheElem_t *rdncache_id_lookup(RDNcache_t *cache,  WorkerQueueData_t *slot, ID entryid)
   This is typically used to retrieve the ancestors when having the parentid
* lookup by parent id and nrdn:
    RDNcacheElem_t *rdncache_lookup_by_rdn(RDNcacheHead_t *head,  ID parentid, const char *nrdn)
    this is typically used to retrieve the parent ID when having the DN.
    Note: suffix parent ID is 0

######Data Stored
They are the data needed to build the entryrdn.db dbi records:
* entry ID
* parent entry ID
* entry rdn
* normalized entry rdn
Beside the elem:
* an ordered table pointing on the elements and ordered by entry ID
* an ordered table pointing on the elements and ordered by parent ID + nrdn
* a refcnt counter that tells how many elements are used by other threads

######Cache flushing strategy
The strataegy is too keep two list of elements and rotate them when writing thread txn is commited.
Current list is where new data are added.
Whenever the writer thread commits a txn the cache is rotated:
  previous queue get released (and freed if no other thread is still using an element)
  current queue is moved to previous queue
  a new empty current queue is alloced.

######Lookup algorythm
The lookup is done in two phases of 3 subphases:
* First phase: Looks in
    * current queue - if found returns
    * previous queue - if found add in current queue and returns.
    * entryrdn.db database instance - if found add in current queue and returns.
* Second phase is same as first one and run after waiting that all worker threads working on wait_id smaller than our have processed their entry.

#### Other data:
##### ImportCtx:
There is one ImportCtx struct per ImportJob and it contains
the global data needed to perform the import over mdb 

|Field|Usage |
| --- | --- |
| job | The ImportJob |
| ctx | The db-mdb plugin context |
| entryrdndbi | the entryrdn database instance |
| slots | the array of worker threads contextes (cf ImportSlot) |
| nbslots | number of worker threads |
| cache | entrrdn cache |
| worker_queue | worker queue |
| writer_queue | writer queue |

##### ImportSlot:
This struct represent a worker thread context

|Field|Usage |
| --- | --- |
|wait_id | A value that determine the order in which the slots have been filled | 

##### ImportJob:
The ImportJob struct is reused with the following restriction:

|Field|Usage |
| --- | --- |
|task | task |
|flags |flags |
|input_filenames |ldif filenames |
|index_list |index_list |
|worker_list |worker_list |
|number_indexers |Not used |
|starting_ID |Not used |
|first_ID |Not used |
|lead_ID |Not used |
|ready_ID |Not used |
|ready_EID |Not used |
|trailing_ID |Not used |
|current_pass |Not used |
|total_pass |Not used |
|skipped |skipped |
|not_here_skipped |not_here_skipped |
|merge_chunk_size |Not used |
|voodoo logic for deciding when to begin |Not used |
|uuid_gen_type |uuid_gen_type |
|uuid_namespace |uuid_namespace |
|mothers |??? |
|average_progress_rate |average_progress_rate |
|recent_progress_rate |recent_progress_rate |
|cache_hit_ratio |Not used |
|start_time |start_time |
|progress_history |progress_history |
|progress_times |progress_times |
|job_index_buffer_size |Not used |
|job_index_buffer_suggestion |Not used |
|include_subtrees |include_subtrees |
|exclude_subtrees |exclude_subtrees |
|fifo |Not used |
|task_status |task_status |
|wire_lock |Used with wire_cv |
|wire_cv |Used to wait until main-thread initialization is done and we are reading to queue entries |
|main_thread |main import thread (dbmdb_import_main) tid |
|encrypt |encrypt |
|usn_value |usn_value |
|upgradefd |??? |
|numsubordinates |??? |
|writer_ctx |the ImportCtx struct |
