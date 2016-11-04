---
title: "Autotuning Directory Server as a Default"
---

# Autotuning Directory Server as a Default

Overview
========

Out of the box, Directory Server is not optimally tuned for a system. There are many instances of downstream products that integrate with DS that are not performing any tuning at all. As well, many admins are time pressed, and can't invest the hours and time needed to optimally create the dbcachesize numbers that yield perfect search times. Some admins from other product backgrounds may not even know that you need to configure these settings at all to make Directory Server performant.

Right now it's even worse, as out of the box we only configure the following:

    # LDBM
    nsslapd-dbcachesize: 10000000
    # Backend
    nsslapd-cachememsize: 10485760
    nsslapd-cachesize: -1
    nsslapd-dncachememsize: 10485760
    # Threads
    nsslapd-threadnumber: 30

Provided my maths is correct, out of the box we configure 10MB of dbcachesize, 10MB of cachememsize, 10MB of dncachesize and 30 threads. *This is insanely small for a production workload*, and means we probably have high rates of eviction which can be observed in cn=monitor on the ldbm database.

Our goal should be that out of the box, we provide the fastest Directory Server we possibly can, without sacrificing stability or reliability. We have to assume that the majority of our users and consumers will never tune their server, and their perceptions of our product depend on the defaults we ship. So how can we achieve this?

Out of the box today
====================

So lets assume we have a system with 10,000 entries, and we are going to do some load testing to search and bind those entries.

    /opt/dirsrv/bin/ldclt -h localhost -p 389 -n 30 -N 10 -D "uid=testXXXX,dc=example,dc=com" -w passwordXXXX -e "randombinddn,randombinddnlow=0001,randombinddnhigh=9999" -e bindeach,esearch -f '(uid=testXXXX)'
    ...
    ldclt[12306]: Global average rate: 2760.47/thr  (828.14/sec), total:  82814

Let's have a look at our monitor:

    dn: cn=monitor,cn=userRoot,cn=ldbm database,cn=plugins,cn=config
    entrycachehitratio: 66

We want this to be above 95%, perhaps even 99% if we can.

It's also not unreasonable to imagine sites with many more objects than this. Given the db that was created is only 9.9M, for a site with 100,000 entries, 99M would be a reasonable estimation of this size, if not more.


Initially Slightly Larger Defaults
==================================

Let's try increasing some of our numbers for memory:

    nsslapd-dbcachesize: 134217728
    nsslapd-cachememsize: 134217728
    nsslapd-dncachememsize: 33554432

In summary, 10Mb -> 128Mb of dbcache and entry cache, and 10Mb of dncache to 32Mb. We run the same loadtest:

    ldclt[12425]: Global average rate: 2856.27/thr  (856.88/sec), total:  85688

That's an improvement! Lets have a look at the cachehitratios:

    dn: cn=monitor,cn=userRoot,cn=ldbm database,cn=plugins,cn=config
    entrycachehitratio: 94

So over a long term, this higher entry cache hit ratio will serve us better, and will tend more towards 99%. Even if our database was much, much larger, we still have increased our entry cache and db cache by 12x out of the box, so this will help improve long term performance of common entries.

If our dataset was larger (say 100,000 entries) this would have an even more pronounced effect.

So my first proposal is that we change the default number from 10Mb of dbcache and entrycache to 128Mb. It's still not a lot, but it's an improvement already.


Design for Automatic  Thread Tuning
===================================

Something else that isn't considered is that more threads is not always better. In this case, more threads may be increasing contention, which is decreasing the overall performance. So we lower the threadnumber to something more appropriate for this system (dual core i7).

    nsslapd-threadnumber: 8
We re-run our test:

    ldclt[12529]: Global average rate: 2832.83/thr  (849.85/sec), total:  84985

Almost the same result! In fact, our past tuning advice was "cores * 2". Because this is an i7, we have 4 threads avaliable * 2, we get 8 threads for DS. Part of the reason for this is that with more threads, there is more contetion on locks, so then *all* the threads stall each other more. Less threads, less contetion, they can proceed faster into the work sections.

By the same token, DS is often installed on much larger system. I have seen DS on a dualsocket i7 xeon with 16 threads per socket. A setting of 30 threads for this system is far too low, and we are not effectively using the CPUs that are avaliable!

As a result, if nsslapd-threadnumber is not set, we can automatically set this at server start in libglobs.c. I propose that we use:

    nsslapd-threadnumber = (Number of Hardware Threads) * (Factor)

At the moment I have not decided on what "Factor" should be. I think that we should test this on various hardware systems and load test. I suspect that the correct number for Factor will be 2, 3 or 4. This way if one thread is blocked, another can still be operating.

This is a very easy, minimal and non-invasive change, and follows our own tuning advice.


Design for Automatic Memory Tuning
==================================

Automatic memory tuning is a harder problem for one reason: glibc memory fragmentation.

If we set our automatic tuning to use too much ram, depending on the dataset we will fragment and OOM. If we set it too low, we may not be using the hardware correctly.

The current design of the automatic tuning is around system ram percentages. For example:

    nsslapd-cache-autosize: 60
    nsslapd-cache-autosize-split: 60

This would mean "use 60% of the systems free ram, and split that space 60% to the dbcache, and 40% to the entry cache. This is a pretty aggresive setting.

In the experience of our team, it turns out that having a huge DB cache actually doesn't net you a huge improvement past 512Mb of dbcache. Of course we should test this assertion, but the proposed design at the moment is:

So first, our autosize-split should change to:

    pages_to_use = system_free_ram * autosize_percentage
    db_pages_tentative = pages_to_use * autosize_split_percentage
    if db_pages_tentative > 512mb:
        # cap db_pages
        db_pages = 512Mb
    else:
        db_pages = db_pages_tentative
    entry_pages = pages_to_use - db_pages

The second change would be rather than allocated a dbcachesize and cachememsize by default, we would allocate cache-autosize and cache-autosize-split by default. As a default, I think the following is safe:

    nsslapd-cache-autosize: 10
    nsslapd-cache-autosize-split: 40

For a variety of systems, this would yield the following numbers.

    1Gb ram free
        dbcache: 40Mb
        entrycache: 62Mb
    2Gb ram free
        dbcache: 82Mb
        entrycache: 122Mb
    4Gb ram free
        dbcache: 164Mb
        entrycache: 245Mb
    8Gb ram free
        dbcache: 328Mb
        entrycache: 492Mb
    16Gb ram free # This point the 512Mb max kicks in.
        dbcache: 512Mb
        entrycache: 1126Mb
    32Gb ram free
        dbcache: 512Mb
        entrycache: 2764Mb
    64Gb ram free
        dbcache: 512Mb
        entrycache: 6042Mb
    128Gb ram free
        dbcache: 512Mb
        entrycache: 12596Mb

Despite being conservative (we are under utilising a lot of this hardware) we are very unlikely to run the risk of fragmentation OOM, and each of these numbers is still an improvement over our current "10Mb" defaults. We would still also fix the 10,000 entry work load into ram on the 1Gb host.


What about admins who want to manually tune?
============================================

Because of the design of dse.ldif and cn=config, an admin who has previously, or wants to override these values can and they will be respected.

These settings are only for "out of the box defaults". Existing installs will not be affected or changed. This would only apply to new deployments.

Author
======

wibrown at redhat.com


