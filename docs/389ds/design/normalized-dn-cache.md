---
title: "Normalized DN Cache"
---

# Normalized DN Cache (v1.0)
----------------------------

Overview
--------

DN normalization is an expensive task. Keeping normalized DN's in memory should be more efficient.

Design
------

When attempting to normalize a DN, first check if that DN has already been normalized(we are currently using the NSPR hash table to store all the DN's - with a bucket size of 2053). If the DN is not in the hash table, then we normalize it and add it to the hash table. Since the hash table size is limited, there is also a LRU list used to determine which DN's can be dropped from the hash when it becomes full. When the hash table fills up, we remove 10000 of the "Least Recently Used" DN's from the table. However, we always maintain a minimum of 1000 DN's in the hash table.

Configuration
-------------

Under cn=config:

     nsslapd-ndn-cache-enabled:  on|off

     nsslapd-ndn-cache-max-size: <value in bytes - default is 20971520 (20mb)>

The server must be restarted for the change to take effect.

Monitoring
----------

Normalized DN cache statistics have also been added to the backend monitor output:

     normalizedDNcachetries: 3613456    
     normalizedDNcachehits: 3587850    
     normalizedDNcachemisses: 25606    
     normalizedDNcachehitratio: 99    
     maxNormalizedDNcachesize: 104857600    
     currentNormalizedDNcachesize: 3578776    
     currentNormalizedDNcachecount: 25606    

In The Future
-------------

- Make the bucket size configurable

- Replace NSPR hash table for a more efficient one


