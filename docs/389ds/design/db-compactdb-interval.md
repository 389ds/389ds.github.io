---
title: "BDB CompactDb interval"
---

# Intervals to compact Primary DB and Replication Changelog DB

Overview
--------

Allow setting the intervals to compact the primary db and changelog db

Use Cases
---------

Berkeley DB does not release free pages unless it explicitly compacts the database.  
This enhancement provides 2 compacting db config parameters for the primary DB and the changelog DB.
Every time the interval is reached, the compact DB API is called.  
If the DB files have free pages, they are released and the size of the DB is shrunken.

Design
------

Berkeley DB provides the API DB->compact.  
For the primary DB, the value of nsslapd-db-compactdb-interval is set to the interval.
Every interval, the primary DBs are compacted.

For the changelog, the value of nsslapd-changelogcompactdb-interval is set to the interval.
Every interval, the changelog DBs are compacted.

Both the default value is 2592000 seconds (30 days)

Implementation
--------------

None.

Feature Management
------------------

CLI

Major configuration options and enablement
------------------------------------------

    Primary DBs:
	dn: cn=config,cn=ldbm database,cn=plugins,cn=config
	nsslapd-db-compactdb-interval: <value in seconds>

	Changelog DBs:
	dn: cn=changelog5,cn=config
	nsslapd-changelogcompactdb-interval: <value in seconds>
						       

Replication
-----------

Impacts the size of changelog DB.

Updates and Upgrades
--------------------

None.

Dependencies
------------

BDB

External Impact
---------------

None.

RFE Author
----------

Noriko Hosoi <nhosoi@redhat.com>
