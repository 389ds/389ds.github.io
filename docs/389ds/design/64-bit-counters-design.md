---
title: "64-bit counters design"
---

# 64-bit Counters Design
------------------------

{% include toc.md %}

### Introduction
----------------

The directory server currently uses 32-bit counters for keeping track of things such as the number of connections, number of operations, number of search requests, etc. The implementation uses NSPR and the function PR\_AtomicIncrement which only works with the *PRUint32* type which corresponds on most platforms to the C type *unsigned int*. Using atomic increment allows us to safely increment these values in the multi-threaded server environment without sacrificing performance. However, in a large directory server which is under a heavy load, the values can wrap around too quickly. The directory server should use 64-bit values for these counters to allow longer term statistics gathering, even on 32-bit systems or other systems which may not support native atomic operations on 64-bit values.

### Design
----------
 
#### Native Architecture Support

Intel x86 supports an instruction called *cmpxchg8b* [1](http://www.exit.com/blog/archives/000361.html) - a compare-and-exchange of a 64-bit value. This can be used on x86 platforms to implement an atomic increment for 64-bit values. GCC provides functions such as \_\_sync\_add\_and\_fetch [2](http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html#Atomic-Builtins).

On HP-UX Itanium you can increment 32-bit and 64-bit integers with inline assembly [3](http://h21007.www2.hp.com/portal/site/dspp/PAGE.template/page.document?ciid=4308e2f5bde02110e2f5bde02110275d6e10RCRD)

    #include <machine/sys/inline.h>
    long long ll=1, ll2;
    ll2 = _Asm_fetchadd(_FASZ_D, _SEM_ACQ, &ll, +1, _LDHINT_NONE);

This would leave ll set to 2 and ll2 to 1 (the value before incrementing). The first argument is the operand size and can be either \_FASZ\_W for word or \_FASZ\_D for double word. The fourth argument is increment value, it can be -16, -8, -4, -1, 1, 4, 8 or 16.

NSPR has 32-bit atomic increment implemented with the fetchadd assembly instruction on IPF [4](http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/md/unix/os_HPUX_ia64.s#41):

On HP-UX PA-RISC we only have one atomic operation, ldcws [5](http://h21007.www2.hp.com/portal/download/files/unprot/itanium/spinlocks.pdf) (load and clear word). This can be used to implement a spinlock around the increment code. However, for PA-RISC, we will probably have to use the same implementation for 64-bit that NSPR uses for 32-bit increment operations (PR\_AtomicIncrement()), which is pthread locks [6](http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/misc/pratom.c#165).

Sparc v9 uses the Compare and Set (CASA, CASXA) [7](http://developers.sun.com/solaris/articles/sparcv9.pdf) instructions. The implementation for NSPR PR\_Atomic\* on sparcv9 [8](http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/md/unix/os_SunOS_sparcv9.s)uses the CAS instruction to implement support for 32-bit atomic operations. The manual claims CASAX can be used for 64-bit values.

#### Support For Other Architectures


If the platform has no native support for 64-bit atomic operations, we will have to use a mutex. Depending on the performance, we may be able to use a read/write lock - use the write lock for increment and the read lock for accessing the value. The Slapi\_Counter API will hide these details.

#### SLAPI Support


    typedef struct Slapi_Counter {
        PRUint64 value;
    #ifndef ATOMIC_64BIT_OPERATIONS
        Slapi_Mutex *mutex;
    #endif
    } Slapi_Counter;

The structure is just a wrapper around the actual 64-bit value. The mutex is used on those platforms that do not provide 64-bit atomic operations. The configure script will set ATOMIC\_64BIT\_OPERATIONS if either NSPR provides support or the directory server supports that platform's native 64-bit atomic operations.

    Slapi_Counter *slapi_counter_new();

This uses malloc to create the counter, and calls slapi\_counter\_init to initialize it.

    void slapi_counter_init(Slapi_Counter *);

This initializes a Slapi\_Counter struct, sets the initial *value* to 0 and creates and initializes the mutex if necessary. The use case for this is when the counter is declared as a static struct e.g.

    static Slapi_Counter operation_counter;    
    ...    
    slapi_counter_init(&operation_counter);    

This may be preferred to malloc() in some cases.

    PRUint64 slapi_counter_increment(Slapi_Counter *);    

This increments the value in the counter and returns the new value.

    PRUint64 slapi_counter_get_value(Slapi_Counter *);    

This returns the current value in the counter.

    PRUint64 slapi_counter_set_value(Slapi_Counter *, PRUint64 newvalue);    

This sets the counter to the new value and returns the new value.

#### SNMP Changes

There is an SNMP type called Counter64. The current code uses type PRUint32 for the SNMP counter implementation in the directory server code (agtmmap.h) and the ASN\_COUNTER type in the ldap-agent.c code. These will have to be changed to PRUint64 and ASN\_COUNTER64 respectively. The existing code makes use of the ASN\_GAUGE type which is 32-bits, but we don't support those values anyway, so we won't change those. The MIB file that we distribute will need to have the types changed to use the 64-bit types.

#### Stats MMAP file

It will be best to simply remove the old file and start over. If this is not desirable, it is possible to write a small C program to convert the 32-bit values in the file to 64-bit values. It is expected that this will be done in the native packaging code (e.g. in an RPM %post script). It may be possible to do this in the server itself - have the server detect the old format and upgrade it in place, assuming the dsVersion field in the hdr\_stats\_t struct contains useful information.

#### Building

Counters will be enabled by default. There will be a configure option

    --disable-counters - Turn off all code related to Slapi_Counters

This will be useful for testing the performance impact of counters, especially on those platforms that do not have native 64-bit atomic operations.

<font color="red">Note: this option has not been implemented yet as of today (2008/10/28).</font>

#### Configuration Parameter

    cn=config    
    nsslapd-counters: on | off    

By default, nsslapd-counters is on and it does not appear in the configuration file dse.ldif. Since the functionality is turned on/off at the server's start up time, the setup cannot be dynamically changed. To switch from on to off or off to on, you have to shutdown the server, modify dse.ldif to set the new value, then restart the server.

### Links
--------

1 - <http://www.exit.com/blog/archives/000361.html>
2 - <http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html#Atomic-Builtins>
3 - <http://h21007.www2.hp.com/portal/site/dspp/PAGE.template/page.document?ciid=4308e2f5bde02110e2f5bde02110275d6e10RCRD>
4 - <http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/md/unix/os_HPUX_ia64.s#41>
5 - <http://h21007.www2.hp.com/portal/download/files/unprot/itanium/spinlocks.pdf>
6 - <http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/misc/pratom.c#165>
7 - <http://developers.sun.com/solaris/articles/sparcv9.pdf>
8 - <http://lxr.mozilla.org/seamonkey/source/nsprpub/pr/src/md/unix/os_SunOS_sparcv9.s>

