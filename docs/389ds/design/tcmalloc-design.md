---
title: "Changing Default Memory Allocator to tcmalloc"
---

# Changing Default Memory Allocator to tcmalloc
----------------

Overview
--------

Starting in 389-ds-base-1.3.6 (and RHEL 7.4) the Directory Server will be using tcmalloc as its default memory allocator.  The benefits of using tcmalloc are a significant smaller virtual memory size & growth, and a slight performance increase.  Due to the way the Directory Server is using memory internally the standard glibc allocator created a much larger memory footprint.  This caused issues like the server's memory footprint not matching the cache settings, and ultimately running out of memory (OOM). 

Major configuration options and enablement
------------------------------------------

There is no server configuration.  This is enabled at compile time by using the ``configure`` option "--with-tcmalloc".

Dependencies
------------

**gperftools-libs** package on RHEL/Fedora contains the tcmalloc libraries, and are needed to run Directory Server.

External Impact
---------------

Building the server on platforms other than RHEL and Fedora would need to have some form of tcmalloc (libtcmalloc) available on that system.

Origin
-------------

https://bugzilla.redhat.com/show_bug.cgi?id=1186512

Author
------

<mreynolds@redhat.com>
