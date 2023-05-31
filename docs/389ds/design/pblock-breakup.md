---
title: "Pblock Performance Improvement"
---

### Overview

The pblock is the fundamental structure in Directory Server. It's used for communication
between multiple parts of the server. From making search requests, to initiating plugin
operations, internal IPC. It is the key to our API stability and our extensibility.

However, the pblock is a complex, large structure. It has many overheads, and to continue
to scale we must improve it.

### The problem with the pblock

#### Large Size

The pblock is a 712 byte struct, containing many other structs. This is *huge* to
allocate both on the stack, and on the heap. To make this worse, we often us very
few parts of the pblock

#### Member access

Thankfully, member access is protected in this struct. We use a get/set api. However
this api is a 1600 line long case switch statement that uses #defined constants
to access. This is very cache inefficient and complex to maintain and read. We have
no guarantee over api versions because we just don't know *what* api's are in use,
we only know that some #defines exist and they are used at some point.

#### Single point of communication

Because the pblock is our communication layer to many other parts of the server,
it's used a lot. Combine this with the large size and cost to access members we
have the potential for cache inefficency and memory waste at a large scale due
to the sheer number of pblocks we allocate for a single operation.

#### Safety

The pblock uses a number of nested structs, some of which are heap allocated. No
all the code paths of the get/set check for null pointers which may add a saftey
risk to the structure.

#### Memory fragmentation

We have signifigant issues with memory fragmentation and reclaimation. Reducing
the size of our structs will help to ease the burden on the memory allocator.

### How to resolve it

The properties of the pblock really show that we tend to use different parts. We
need to minimise the cost of allocation, improve cache locality and safety.

We see that a number of locations in the code will use a pblock for a single
search then destroy it. Others use the pblock just to register a set of plugin
functions. Others use it for operation access. Each of these is a different use
case. We can thus take the pblock and break it down into a tree of nested structures
that are dynamically allocated as needed.

#### Analyse

We must understand the groupings of access to the pblock. To do this, the first
step is to created a version of the pblock that "profiles" it's access. We would
count the number of get/set accesses to each member for each instance. For example
a search pblock would use the operation components such as:

    SLAPI_OPERATION_SEARCH
    SLAPI_OPERATION
    SLAPI_ORIGINAL_TARGET_DN
    SLAPI_TARGET_SDN
    SLAPI_SEARCH_SCOPE
    SLAPI_SEARCH_STRFILTER
    SLAPI_CONTROLS_ARG
    SLAPI_SEARCH_ATTRS
    SLAPI_SEARCH_ATTRSONLY
    SLAPI_TARGET_UNIQUEID
    SLAPI_PLUGIN_IDENTITY

Where as a plugin that is registering function calls would use say:

    SLAPI_PLUGIN_IDENTITY
    SLAPI_PLUGIN_DESCRIPTION
    SLAPI_PLUGIN_START_FN
    SLAPI_PLUGIN_CLOSE_FN
    SLAPI_PLUGIN_PRE_BIND_FN

By counting the access to get/set of these defines, we would see 'clumps' of access
and a logical pattern to the use of the pblock.

#### Seperate.

Once we know the "clumps" of usage, we could then break the pblock up into sub-structs
that are allocated on demand. Consider

    struct _slapi_pblock {
        struct _slapi_plugin_pblock *plugin_pblock;
        struct _slapi_operation_pblock *operation_pblock;
    } typedef slapi_pblock

Inside of each substructure, we would group the related parts. When we call get/set
we could check if the values are NULL. If we call set, we can allocate the substructure
as needed.

This has a benefit that allocation of the pblock such as:

    Slapi_Pblock *pb = slapi_pblock_new();

Would allocate less than 712 bytes. Consider we were able to cut the pblock up into say
10 unique parts. That would mean the top level pblock is now only 80 bytes. This is
faster to allocate, and wastes less 'NULL' space.

By grouping the struct fields, we would only allocate the needed substruct, so consider
the plugin struct had 20 member pointers, this would mean that we would only need to allocate
160 bytes. For an example plugin operation, this would allocate only 240 bytes rather than the
full 712, which would be a signifigant saving. A small performance test of this on my laptop
shows that the speed of allocation and deallocation is greatly changed by this:

240 bytes alloc and free (1 million times)

     Performance counter stats for './test':

            177.404650      task-clock (msec)         #    0.999 CPUs utilized          
                     0      context-switches          #    0.000 K/sec                  
                     2      cpu-migrations            #    0.011 K/sec                  
                63,044      page-faults               #    0.355 M/sec                  
           442,478,522      cycles                    #    2.494 GHz                    
           587,333,900      instructions              #    1.33  insn per cycle         
           122,080,632      branches                  #  688.148 M/sec                  
                77,868      branch-misses             #    0.06% of all branches        

           0.177619114 seconds time elapsed

712 bytes alloc and free (1 million times)

     Performance counter stats for './test':

            354.125348      task-clock (msec)         #    0.999 CPUs utilized          
                     1      context-switches          #    0.003 K/sec                  
                     2      cpu-migrations            #    0.006 K/sec                  
               176,325      page-faults               #    0.498 M/sec                  
           883,253,412      cycles                    #    2.494 GHz                    
           986,196,061      instructions              #    1.12  insn per cycle         
           193,484,029      branches                  #  546.372 M/sec                  
               225,371      branch-misses             #    0.12% of all branches        

           0.354337974 seconds time elapsed

We can see that the 712 byte allocation takes roughly twice the time to execute. There are
many more branch misses, and greater number of pagefaults, more cpucycles. This is even just
allocating and freeing, let alone using the struct.

### Compatability checking

A critical point of this change is that we do not want to break the pblock for plugin v3 api.

To ensure this, before changes are made we must guarantee they are tested in the cmocka tests behaviourally,
so that when we make the underlying change, we do not affect the api.


### Conclusion

The pblock is a low hanging fruit, and cleanup and improvement of our structure can potentially
yield a signifigant performance and memory improvement to the server.

