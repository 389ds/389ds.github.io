---
title: "Database Monitor in dsconf"
---

# Database Monitor
----------------

### Overview

We need to port all the old Perl and shell scripts to our new python CLI.  dbmon.sh was a legacy tool to gather all the database stats into a single report.  This is the new **dsconf** version of that tool.   It provide a human friendly report, as well as a JSON report for easy parsing.  The new tool provides similar functionality like **dbmon.sh** had where you can specify which backends you want to check, the default is all the backends, and finally you can choose if you want to see the individual index statistics.

### Usage

    dsconf INSTANCE_ID monitor dbmon [--backends="BACKEND BACKEND"] [--incr INCR_NUMBER] [--indexes]

- "**\-\-backends**" - A space separated list of the backends or suffixes to get stats on

- "**\-\-indexes**" - Report individual index statistics

### Previous dbmon.sh output

    # BINDDN="cn=directory manager" BINDPW="superSecret" VERBOSE=2 INDEXLIST="aci id2entry"  dbmon.sh

    Thu 02 Apr 2020 06:04:46 PM EDT
    # dbcachefree - free bytes in dbcache
    # free% - percent free in dbcache
    # roevicts - number of read-only pages dropped from cache to make room for other pages
    #            if this is non-zero, it means the dbcache is maxed out and there is page churn
    # hit% - percent of requests that are served by cache
    # pagein - number of pages read into the cache
    # pageout - number of pages dropped from the cache
    dbcachefree 416096256 free% 99.933 roevicts 0 hit% 96 pagein 20 pageout 16
    # dbname - name of database instance - the row shows the entry cache stats
    # count - number of entries in cache
    # free - number of free bytes in cache
    # free% - percent free in cache
    # size - average size of date in cache in bytes (current size/count)
    # DNcache - the line below the entry cache stats are the DN cache stats
    # count - number of dns in dn cache
    # free - number of free bytes in dn cache
    # free% - percent free in dn cache
    # size - average size of dn in dn cache in bytes (currentdncachesize/currentdncachecount)
    # hit_ratio - cache hit ratio
    # under each db are the list of selected indexes specified with INDEXLIST
          dbname      count          free  free%    size  hit_ratio
      global:ndn        158      25140463   99.9   160.4       79.0

    userroot:ent        5 pagein 1140832132 pageout       99
    userroot:dn         5 pagein 134217389 pageout       99
               +      aci pagein        0 pageout        0
               + id2entry pagein        0 pageout        1


### The New **dsconf** Output

    # dsconf slapd-YOUR_INSTANCE monitor dbmon --indexes

    DB Monitor Report: 2020-04-02 20:30:16
    --------------------------------------------------------
    Database Cache:
     - Cache Hit Ratio:     96%
     - Free Space:          396.82 MB
     - Free Percentage:     99.9%
     - RO Page Drops:       0
     - Pages In:            20
     - Pages Out:           16

    Normalized DN Cache:
     - Cache Hit Ratio:     79%
     - Free Space:          23.98 MB
     - Free Percentage:     99.9%
     - DN Count:            158
     - Evictions:           0

    Backends:
      - dc=example,dc=com (userroot):
        - Entry Cache Hit Ratio:        42%
        - Entry Cache Count:            5
        - Entry Cache Free Space:       1.06 GB
        - Entry Cache Free Percentage:  100.0%
        - Entry Cache Average Size:     3.62 KB
        - DN Cache Hit Ratio:           0%
        - DN Cache Count:               5
        - DN Cache Free Space:          128.0 MB
        - DN Cache Free Percentage:     100.0%
        - DN Cache Average Size:        67.0 B
        - Indexes:
          - Index:      aci.db
          - Cache Hit:  3
          - Cache Miss: 0
          - Page In:    0
          - Page Out:   0

          - Index:      id2entry.db
          - Cache Hit:  13
          - Cache Miss: 0
          - Page In:    0
          - Page Out:   1

          ...


The JSON output looks like:


    {
        "date": "2020-04-02 20:32:53",
        "dbcache": {
            "hit_ratio": "96",
            "free": "396.82 MB",
            "free_percentage": "99.9",
            "roevicts": "0",
            "pagein": "20",
            "pageout": "16"
        },
        "ndncache": {
            "hit_ratio": "79",
            "free": "23.98 MB",
            "free_percentage": "99.9",
            "count": "158",
            "evictions": "0"
        },
        "backends": {
            "userroot": {
                "suffix": "dc=example,dc=com",
                "entry_cache_count": "5",
                "entry_cache_free": "1.06 GB",
                "entry_cache_free_percentage": "100.0",
                "entry_cache_size": "3.62 KB",
                "entry_cache_hit_ratio": "42",    
                "dn_cache_count": "5",
                "dn_cache_free": "128.0 MB",
                "dn_cache_free_percentage": "100.0",
                "dn_cache_size": "67.0 B",
                "dn_cache_hit_ratio": "0",
                "indexes": [
                    {
                        "name": "aci.db",
                        "cachehit": "3",
                        "cachemiss": "0",
                        "pagein": "0",
                        "pageout": "0"
                    },
                    {
                        "name": "id2entry.db",
                        "cachehit": "13",
                        "cachemiss": "0",
                        "pagein": "0",
                        "pageout": "1"
                    },
                ]
            }
        }
    }

### Origin

<https://github.com/389ds/389-ds-base/issues/3601>

### Author

<mreynolds@redhat.com>



