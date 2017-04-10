---
title: "Replication Diff Tool Design Page"
---

# Replication Diff Tool
----------------

Overview
--------

This tool checks the synchronization status between two replicas.  It checks for missing entries & and inconsistencies between entries.  Since this is run on live servers technically they will never be in sync at the same time if they are under constant load.  To combat this pitfall a "lag" allowance is used.  By default the lag time is set to 5 minutes (300 seconds), but it can be set to any value.  So if an inconsistency is detected, and it is within this lag allowance it will *NOT* be reported.  While this is not perfect due to the nature of the replication, it will help reduce false positives.  Setting the lag time to 0 disables this feature.


Design
---------------

So the tools sees the two replicas as a "Master" and a "Replica", but it could really just be "ReplicaA" and "ReplicaB".  So when the tool finds a problem it reports what Master has, and what Replica has.

The "lag" algorithm looks at the state information in each entry using the **nscpentryWSI** attribute.  When evaluating an attribute value inconsistency the tool will take the most recent csn timestamp from the state information (it checks vucsn, vdcsn, mdcsn, and adcsn).  This timestamp is then subtracted from the time the tool was started to determine if the inconsistency is within the lag allowance.

Ideally this tool would be run multiple times to get an accurate picture of the state of replication.


Usage
---------------

```
Usage: repl-check.py [options]

Replication Comparison Tool (v1.0).  This script  can be used to compare two
replicas to see if they are in sync.

Options:
  -v, --verbose         Verbose output
  -o FILE, --outfile=FILE
                        The output file
  -D BINDDN, --binddn=BINDDN
                        The Bind DN (REQUIRED)
  -w BINDPW, --bindpw=BINDPW
                        The Bind password (REQUIRED)
  -h MHOST, --master_host=MHOST
                        The Master host (default localhost)
  -p MPORT, --master_port=MPORT
                        The Master port (default 389)
  -H RHOST, --replica_host=RHOST
                        The Replica host (REQUIRED)
  -P RPORT, --replica_port=RPORT
                        The Replica port (REQUIRED)
  -b SUFFIX, --basedn=SUFFIX
                        Replicated suffix (REQUIRED)
  -l LAG, --lagtime=LAG
                        The amount of time to ignore inconsistencies (default
                        300 seconds)
  -Z CERTDIR, --certdir=CERTDIR
                        The certificate database directory for startTLS
                        connections
```

Example
---------------

```
# python repl-check.py -D "cn=directory manager" -w PASSWORD -h localhost -p 389 -H localhost -P 5555 -b "dc=example,dc=com"


================================================================================
         Replication Synchronization Report  (Fri Apr  7 16:30:29 2017)
================================================================================


Database RUV's
=====================================================

Master RUV:
  {replica 1 ldap://localhost.localdomain:389} 58e53b92000200010000 58e6ab46000000010000
  {replica 2 ldap://localhost.localdomain:5555} 58e53baa000000020000 58e69d7e000000020000
  {replicageneration} 58e53b7a000000010000

Replica RUV:
  {replica 1 ldap://localhost.localdomain:389} 58e53ba1000000010000 58e6ab46000000010000
  {replica 2 ldap://localhost.localdomain:5555} 58e53baa000000020000 58e7e8a3000000020000
  {replicageneration} 58e53b7a000000010000


Entry Counts
=====================================================
Master:  11
Replica: 10


Missing Entries
=====================================================

Replica is missing entries:
  - cn=m1,dc=example,dc=com  (Master's creation date:  Wed Apr  5 19:46:56 2017)


Entry Inconsistencies
=====================================================


cn=group2,dc=example,dc=com
---------------------------
Replica missing attribute "objectclass":

 - Master's State Info: objectClass;vucsn-58e53baa000000020000: top
 - Date: Wed Apr  5 14:47:06 2017

 - Master's State Info: objectClass;vucsn-58e53baa000000020000: groupofuniquenames
 - Date: Wed Apr  5 14:47:06 2017


cn=group1,dc=example,dc=com
---------------------------
 -> Attribute 'cn' is different:
      Master:
        - State Info: cn;vucsn-58e53baa000000020000;mdcsn-58e53baa000000020000: My value
        - Date:       Wed Apr  5 14:47:06 2017

      Replica:
        - State Info: cn;adcsn-58e7e0de000000020000;vucsn-58e7e0de000000020000: My value
        - Date:       Fri Apr  7 14:56:30 2017

        - State Info: cn;vucsn-58e7e0de000000020000: Another value
        - Date:       Fri Apr  7 14:56:30 2017

 -> Attribute 'description' is different:
      Master:
        - State Info: description;vucsn-58e53bd9000000020000: okay
        - Date:       Wed Apr  5 14:47:53 2017

      Replica:
        - State Info: description;adcsn-58e7d61c000000020000;vucsn-58e7d61c000000020000: Replica is now different
        - Date:       Fri Apr  7 14:10:36 2017
```

Future Plans
-----------------------

- Performance testing with large databases
- Work with tombstones and conflict/glue entries



