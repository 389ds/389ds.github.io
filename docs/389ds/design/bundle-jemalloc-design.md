---
title: "jemalloc Bundled with Directory Server"
---

# jemalloc Bundled with Directory Server
----------------

Overview
--------

Starting in 389-ds-base-1.3.5(f24) the jemalloc(alternative memory allocator) library will be shipped with the 389-ds-base-libs rpm package.  Currently jemalloc is not available in RHEL - this is one of the reasons why we are shipping jemalloc with the product.

Use Cases
---------

jemalloc focuses on reducing/avoiding memory fragmentation, and it has a very impressive impact on the DS memory footprint, especially growth.  See [jemalloc testing results](../FAQ/jemalloc-testing.html)

Design
------

Updated the spec file to download a supported/tested version of jemalloc's source code.  Then build the source, and extract the jemalloc library files to the Directory Server's library directory: **/usr/lib64/dirsrv/**

Major configuration options and enablement
------------------------------------------

A new section was added to **/etc/sysconfig/dirsrv** that describes jemalloc and provides a custom generated commented line for setting LD_PRELOAD on that particular system/install:

    # jemalloc is a general purpose malloc implementation that emphasizes
    # fragmentation avoidance and scalable concurrency support.  jemalloc
    # has been shown to have a significant positive impact on the Directory
    # Server's process size/growth.
    #LD_PRELOAD=/usr/lib64/dirsrv/jemalloc.so.1 ; export LD_PRELOAD

To start using jemalloc just uncomment the LD_PRELOAD line at the bottom of the file, and restart the Directory Server.

You can also set this to use any jemalloc library if others are available.  This is just being bundled with Directory Server because some systems that do not have jemalloc available.

Replication
-----------

None

Updates and Upgrades
--------------------

None

Dependencies
------------

None

External Impact
---------------

None

Author
------

<mreynolds@redhat.com>
