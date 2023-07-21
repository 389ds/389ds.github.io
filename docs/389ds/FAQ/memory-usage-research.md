---
title: "Memory Usage Research"
---

# Memory Usage Research
-----------------------

Overview
========

Directory Server calls malloc and free in many places, which could cause the memory fragmentation, then it prevents the further memory allocation. This is a memo which explains the experiments I tried to investigate to reduce malloc and free.

Testcase
========

`Test Environment:`
`OS: Fedora 9`
`HW: dual core, 3.9GB memory, 64-bit`
`Fedora Directory Server 1.1.1`
`nsslapd-cachememsize: 1GB`
`nsslapd-dbcachesize: 100MB`
`Test:`
`ldclt with 3 "jpeg" files to randomize the size (1.5MB, 3.5KB, 28B).`
`ldclt operations: {add , delete, modify, search on uid, search on seealso} x 2 threads`
`search all (above nsslapd-idlistscanlimit) to evict entries in the entry cache`

Experiments: modification made on the server
============================================

1. A shared memory pool among threads; protected by mutex
1-1. Store system structures pblock, backentry, Slapi\_Entry, internal Slapi\_Operation in the memory pool and reuse them.
Almost no positive effect. It shows the similar growth curve as the original server.

1-2. Store system structures pblock, backentry, Slapi\_Entry, internal Slapi\_Operation + attribute values in the range between 512KB and 64MB in the memory pool and reuse them.
This implementation stores attribute values referred from the entry, which is retrieved from BDB, in the memory pool. The server size increased only 50% of the original server.

1-3. Store system structures pblock, backentry, Slapi\_Entry, internal Slapi\_Operation + attribute values in the range between 2KB and 64MB in the memory pool and reuse them; if the requested size is larger than 128KB, instead of calling malloc, call mmap directly.
The result looks flat, but the performance went down 20% of the original server.

Note on M\_TRIM\_THRESHOLD (glibc): By default, M\_TRIM\_THRESHOLD is 128K. If the requested size is larger than M\_TRIM\_THRESHOLD, it tends to call mmap and when munmap is called, the memory is supposed to return to the system. But for the performance reason, even if the requested size is larger than 128KB, if the size is available in the heap, it's allocated from there. And it contributes to the process size growth and the memory fragmentation. To see if it could affect the server size increase, I ran the test with M\_TRIM\_THRESHOLD = 32KB as well as M\_TRIM\_THRESHOLD = 2GB, but there were almost no difference between the 2 server size growth charts.

2. Per thread memory pool combined with slapd malloc functions (the current code in ifdef MEMOPOOL\_EXPERIMENTAL)
Limited system structures and attribute values referred from the entry are just a small part of the entire malloc/free calls in the server. Especially, there are many occasions in BDB and in the back-end layer which calls BDB. To let mempool cover wider mallocs, I extended the internal malloc functions to use mempool and set the malloc functions to use in the linked libraries such as LDAP C SDK, SASL, and BDB. This approach shows the better/lower server size growth rate as well as the performance compared to the shared mempool handling just some system structures and attribute values in the entry.

Here's the implementation memo.

-   the mempool and integrated malloc functions (slapi\_ch\_\*alloc) are located in ldap/servers/slapd/mempool.c. All the code is in ifdef MEMPOOL\_EXPERIMENTAL. mempool.c is not put in Makefile.am, thus the file never be compiled by default. Also, even if it's put in automake makefile, unless the macro is defined, the code is not compiled in.
-   Steps how slapi\_ch\_malloc (including its friend functions) works
    -   slapi\_ch\_malloc (including the friend functions) checks the requested size
    -   If the size is less than or equal to 1KB, it allocates extra sizeof(unsigned long) to store the size. When returning the memory, it returns the offset sizeof(unsigned long) from the allocated address.
    -   If the size is larger than 1KB, it checks the mempool free list. If the list is not empty, return the memory from the free list (mempool\_get). If the list is empty, it allocates the requested size + sizeof(unsigned long). It returns the offset sizeof(unsigned long) from the address.
    -   If the size is larger than 64MB, it calls mmap and allocate the requested size + sizeof(unsigned long), then returns the offset sizeof(unsigned long) from the address.
    -   Currently, the size allocated for mempool is the smallest power of 2 that is larger than the requested size. It needs to be improved to have better granularity.
-   Steps how slapi\_ch\_free works
    -   slapi\_ch\_free gets the size from the head size area, then it decides the following behavior.
    -   If the size is less than or equal to 1KB, it calls free. Then set NULL to the address.
    -   If the size is larger than 1KB, it returns the memory to the mempool free list (mempool\_return). If max free list size is set and the current free list size is equal to the max free list size, the mempool\_return fails and the memory is freed. NULL is set to the address.
    -   If the size is larger than 64MB, it calls munmap. NULL is set to the address.

-   Per thread mempool is implemented using NSPR thread private index. A mempool is created when the first mempool\_return is called by the thread. Every time mempool\_get/mempool\_return is called, it gets the memory pool by PR\_GetThreadPrivate. When there is any updates, it updates by PR\_GetThreadPrivate.
-   Mempool can be turned on/off with the configuration parameter nsslapd-mempool: on/off, respectively.
-   Mempool basically maintains the free list. mempool\_get returns memory if the free list is not empty. mempool\_return accepts memory and put it into the free list. It provides configurable parameter nsslapd-mempool-maxfreelist. If the value is positive, the free list rejects to accept memory in mempool\_return and the function returns PR\_GetThreadPrivate.

Issues/Leftovers
================

-   ldap\_init (ldapssl\_init, prldap\_init) These LDAP C SDK init function needs to be revisited. In ldap\_init called via ldapssl\_init and prldap\_init initializes options and set default values including memalloc\_fns, then it initializes as sasl client by calling sasl\_client\_init. In sasl\_client\_init, it creates mechlist using the malloc function available at the moment which could mismatch the malloc/free functions set later. The ldap\_init functions are necessary when the server behaves as an LDAP client of the other server (e.g., chaining backend, replication, pass through).
-   Therefore, these functionalities are not evaluated, which need to be.
-   The granularity of the allocated is low. If x bytes is requested to allocate, the smallest 2\^n bytes which is larger than or equal to x is allocated. It could be the smallest multiple of the page size (e.g., 4KB).

Appendix: Non glibc approach
============================

There is an OpenLDAP report that other memory allocator library shows better performance / less process size growth (http://highlandsun.com/hyc/malloc/). I also tested the DS linked with tcmalloc without mempool code (http://goog-perftools.sourceforge.net/doc/tcmalloc.html). The test configuration: single supplier - single replica; update 30MB attribute to (30MB + n \* 4KB) every 15 minutes under the constant ldclt add and search stress. Both glibc and tcmalloc increases the process size, but the growth rate is 1/5 with tcmalloc.

