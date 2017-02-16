---
title: "DS Cache Structure"
---

### Overview

Inside of Directory Server we maintain a number of caches. This ranges from the large
and important entry cache, the DN cache, Normalised DN cache and even the member of cache.
When the NDN cache was added, it never added the performance that was expected of it. This
is not a fault of the idea, but a fault of the chosen datastructures. Our server is highly
multi threaded but today we are bottlenecked on lock contention which limits our parallelism.

To solve our cache performance issues, and our multicore parallelism we need to rethink
our approach to caching and locking.

### The problem with hashmaps

Hashmaps in isolation, are an exceptional and fast datastructure. However there are
fundamental issues with the use of hashmaps in Directory Server.

* Locking. Hash Maps can not be parallelised due to their design. You are either
reading the map or you are changing it in some way.
* Tuning. Hash Maps rely on there being an exact number of buckets for entries
to be placed into. If there are not sufficent, hash maps devolve into a linked list
of performance. To make this worse, hashing algorithms for distribution of values are
not always perfect, and as a result they may not disperse entries as needed for optimal
access. Hash Maps can not *dynamically* resize to accomodate larger datasets, and need
to be destroyed and recreated in these situations.

### The problem with LRU

LRU is the "least replacement used" policy for caches. It requires maintenance of
a doubly linked list of items. Generally, the construction of a cache is a Hash Map that points to entries of the
doubly linked list. When the entry is read, the item is "cut" out of the middle of the
list and appended to the tail.

When we exceed the capacity of the cache, the items at the head are "evicted" from
the cache as needed.

This seems like a good policy, but it has an issue in multi threaded programming:
locking. Queues can not be manipulated by multiple threads at a time. As a result
to manipulate the LRU list, we need to lock it. This means that we lose parallelism
in our system, and are serialised over access to the LRU in order to keep it maintained.

### The problem in Directory Server

In directory server especially, we have *not* tuned our Hash Maps (beside the entry
cache and occasionally the NDN / DN cache. Our bucket values tend to be in the 2047 mark, which
testing has shown falls off a performance cliff past 10,000 items. Directory Server
often exceeds millions of objects. This is just not good enough for our needs.

In some places we "claim" to use a cache, but we use a bare NSPR hashmap: this grows
as a linked list in excess of the capacity despite "configuration" tuning. We are
not even bounding our growth!

Finally, due to the design of the LRU in the entry cache, we have to serialise
our access to it in order to update the LRU. We can only progress one operation
thread at a time!


### Proposal: Copy on Write Trees and LRU

If we invert the set of problems in our current system we can explore a list of
properties that we need in our new system.

* Minimisation of locking to allow parallel cache reading.
* Minimisation of cost to maintain the LRU.
* Allow dynamic resizing.
* Ability to enforce sizing boundaries on the cache content.
* Lessen reliance on optimal tuning.

From this we can design a better structure that can provide this.

I propose that we use a Copy on Write B+Tree LRU cache. This is able to satisfy
the properties required.

#### Tuning

B+Trees unlike Hash Maps don't fall off a cliff if they are not tuned with an
exact number of buckets. They only require a size (or lack of) for storing items.

This means that a number of our caches where we statically allocate a size, we are
able to either provide a better size limit as a proportion of ram (see our autotuning)
, or we can allow them to scale as needed based on demand.

#### Resizing

B+Trees automatically grow and contract based on values within, and do not have issues
with resizing. If built into an LRU, you could in software change the upper or lower bound
which would allow the values to be evicted (in case of shrink) live.

#### Size boundaries

Just like a hash map, we can track the number of values and nodes in the tree to gain
accurate values of size consumption of the cache. Rather than a hashmap which has a size
for number of buckets, the cache would actually enforce the size boundary.

#### Locking and LRU

These two both have a high cost that needs to be minimised, and are key to the choice of what I am proposing.

The cache would move through a number of states based upon the current size of the entries
in the tree.

* grow phase
* maintain phase
* evict phase

In the growing phase, the LRU lists are *not* maintained. Included entries included into the LRU, but
read operations would NOT cut and append them to the LRU list. Entries that are deleted here can still
be evicted, and just purged from the cache easily. This is the "fast" phase. Each "inclusion or eviction" 
is a COW write txn, but
all other cache reads can be COW read transactions. Because we don't need to maintain an LRU list in
this phase, read transactions can be in parallel, and do not need locking. This allows extremely
fast parallel cache behaviour. Updates to entries would be a write transaction, so previous holders
of a read lock see the "old" value of the entry, again increasing parallelism of the server.

In the maintain phase, the LRU lists *begin* to be maintained. All read transactions are allowed to
be completed. The entries are now pushed to the tail of the LRU on read. This phase *does* need locking,
so as a result, would be serialised (and incur a performance hit). Entries can still be included, reads
allowed etc. This is the same as the growphase, but just starts to maintain the LRU information for the
evict phase to process correctly. We don't remain in this phase for long. While in this phase, if the water
mark changes, we may go back to the grow phase.

The evict phase begins after a number of operations have completed to ensure we have a good profile
of "common entries" on the LRU tail. This way we won't evict popular entries. In a single batch transaction we
evict a large number of entries to bring us below a watermark. We now re-enter the grow phase for parallel
operations to proceed. Existing operations from before the "evict" would complete and then start again
in the grow phase.

The optimal usage in this design is for the cache to remain in the grow phase. I need to test this, but I suspect
this will be at 85% of cache maximum capacity or less. This means we would *never* evict (except on delete)
and all cache operations would be parallelised. LRU would not need to be maintained.

This allows resizing as if we want to shrink the tree, when we change the value it would immediately trigger a shift
to the maintain phase, followed by an eviction that would remove entries down to the required cachesize. It allows
growing easily by just lifting the watermarks which just delay the next phase.

The trick with the maintain phase, is that we don't want to *always* maintain the LRU on reads. We only really care
about keeping *hot* entries that are read a lot. It's been shown that RRU (random) is as fast as LRU in most cases.
This is basically an extended version of RRU with semi LRU semantics.

#### Write Back - Write Through

The cache could be designed to support write back and write through semantics. I think that for the most part
we want Write Through anyway, so I'm not very invested in making Write Back.

#### Other benefits

This would allow us to distinguish between a read only transaction versus a write transaction in DS plugin
calls. This would make our search paths faster, and allow us more parallelism in operations of the server.

### Questions

#### Why not just tune the Hash Maps better?

Because I'm sick of tuning things. Customers hate tuning things. We need to dynamically
scale, we need to get our server right. We should not place the burden of our mistakes
on the user, we must improve ourselves.

As well, Hash Maps are still unbounded in size, and require locking. Two things that
will prevent us truly scaling to larger hardware in the future.

#### This seems really complex

Not more so that having multiple different datastructures pulled into DS that all
required different locking and designs. By externalising this to libsds, we have a
single source of high quality, extensively tested, parallelised and documented structures that work,
and we can stop rolling new caches, trees, lists for each module. We can remove thousands
of lines of code from DS, and we can use something better.

#### How are we maintaining entry pages?

If we get pages from the database that are in memory (ie pointers to mmap db pages, not copies in memory), we need a way
to ensure these are not altered.

This is relying on an assumption that the COW Tree only copies references to an entry. This depends upon *your* value duplication function.

You may choose to allow the tree to use reference counted pointers to the same entries in the tree. Alternately, you can do a true deep copy
on the copy operation.

So assuming this was an entry cache, the most sense would be to deepcopy entries in the cache on modification so previous versions were not affected.

This means that entries in the cache *must not* be pointers to memory mapped from the database. They must have been allocated by the system allocator by us!

You may be able to use a hybrid approach with a change to the dup function, where values on copy leave a "shadow" entry, but the live "written to" item is a proper
pointer to the DB page. This would be quite expensive though.

#### How do we add an entry to the tree during a cache miss?

This partially ties to the question above, about how we will maintain entries in the cache when they are required to be owned in certain ways.

The issue is that we may have mulitple reads in the cache at a time, but if there is a cache miss, we now need to include the missed data into the cache: Other threads might need it too!

There are two solutions to this problem.

##### Solution 1

At startup we populate the cache with shadow, empty entries for each entry that exists in id2entry. This means we would *find* the entry in the tree, but it's data hadn't been filled in. We can then change the state of and populate the shadow entry. Eviction of this cache entry, would result in it becoming another shadow entry, deletion would remove it entierly.


This means that entries would have a lifecycle of:

    shadow (empty, no data)
    populated (no changes, all can view)
    expired (no change, will be removed soon)
    dirty (changed relative to db and older txns)
    deleted (IE not in tree)

We would allow the following transitions:

    shadow -> populated
    populated -> deleted, expired
    populated -> dirty, expired
    expired -> deleted
    dirty -> populated
    populated -> shadow

Each of these represents what can occur during the runtime of the cache.

* To delete an entry in the shadow state, we must populate it. This is so older transactions have the "data" in them if they access the entry.
* Writing to an entry cause it to split. We copy the entry for the write and future transactions to dirty state and on. We leave the old populated entry as "expired" to mark that once the read only transactions that are active are complete, we can remove this item.
* dirty items are written back to the database and considered "populated" again.
* expired items are deleted once there are no more references.
* populated items may be evicted from the cache and turned into shadow pointers again.

This means each entry has a small lifetime of it's own, and must maintain is own coherency (likely a per-entry rwlock). This would not be access a lot, only to change states, and to ensure counting of each item.


##### Solution 2

We leave the tree "as is", and on cache miss, we bypass and go to a staging cache. The staging cache has a seperated transaction lifecycle to the main cache. We pull up the entry to the staging cache, and access it from there. On the next write operation (or async task) the contents of the stage cache are moved to the main cache.

This way, if the item is in the main cache we pay no penalty, but if we miss, we have still got a fast copy on write structure we can reference, and we can then async populate the main cache.

