---
title: "Replication Diff Tool Design Page"
---

# Replication Diff Tool
----------------

{% include toc.md %}

## Overview
--------

This tool checks the synchronization status between two replicas.  It checks for missing entries & and inconsistencies between entries.  There are two modes to can run the tool under: *online* and *offline*.  "Offline" mode compares two LDIF files (ideally exported using "*db2ldif -r*" to get the replication state information, but either a regular *db2ldif*, or a ldapsearch of the entire database redirected to a file, can also be used.

Since "*online mode *" is run on live servers technically they will never be in sync at the same time if they are under steady load.  To combat this pitfall a "lag" allowance is used.  By default the lag time is set to 5 minutes (300 seconds), but it can be set to any value.  So if an inconsistency is detected, and it is within this lag allowance it will *NOT* be reported.  While this is not perfect due to the nature of the replication, it will help reduce false positives.  Setting the lag time to 0 disables this feature.


## Design
---------------

So the tools sees the two replicas as a "Master" and a "Replica", but it could really just be "ReplicaA" and "ReplicaB".  So when the tool finds a problem it reports what Master has, and what Replica has.

The "lag" algorithm looks at the state information in each entry using the **nscpentryWSI** attribute.  When evaluating an attribute value inconsistency the tool will take the most recent csn timestamp from the state information (it checks vucsn, vdcsn, mdcsn, and adcsn).  This timestamp is then subtracted from the time the tool was started to determine if the inconsistency is within the lag allowance.

The entry gathering is done using a search with the "paged result control" to bring in 500 entries at a time until all the entries are returned and processed.  The batch processing works as follows.  Each entry from the Master entries is checked if it exists in the Replica entries.  If they both exist in this page result group, then they are compared.  Any remaining entries without matches on either side (temporarily missing entries), are rolled into the next paged result set.  After all the paged result searches complete any "temporarily missing" entries become "definitely missing" entries and are listed in the final report.



## Usage
---------------

```
Usage: repl-diff.py [options]

Replication Comparison Tool (v1.2).  This script can be used to compare two
replicas to see if they are in sync.

Options:
  -h, --help            show this help message and exit
  -o FILE, --outfile FILE
                        The output file
  -D BINDDN, --binddn BINDDN
                        The Bind DN (REQUIRED)
  -w BINDPW, --bindpw BINDPW
                        The Bind password (REQUIRED)
  -m MURL, --master_url MURL
                        The LDAP URL for the Master server (REQUIRED)
  -r RURL, --replica_url RURL
                        The LDAP URL for the Replica server (REQUIRED)
  -b SUFFIX, --basedn SUFFIX
                        Replicated suffix (REQUIRED)
  -l LAG, --lagtime LAG
                        The amount of time to ignore inconsistencies (default
                        300 seconds)
  -Z CERTDIR, --certdir CERTDIR
                        The certificate database directory for secure
                        connections
  -i IGNORE, --ignore IGNORE
                        Comma separated list of attributes to ignore
  -p PAGESIZE, --pagesize PAGESIZE
                        The paged result grouping size (default 500 entries)
  -M MLDIF, --mldif MLDIF
                        Master LDIF file (offline mode)
  -R RLDIF, --rldif RLDIF
                        Replica LDIF file (offline mode)


```

## Understanding the Report
-----------------------

### Tombstone Entries

Displays the number of tombstone entries on each replica.  These entries are added to the total entry count.

### Conflict Entries

Lists the DN's of each conflict entry, the conflict type, and the date it was created.

### Missing Entries

Lists the DN's of each missing entry and the creation date from the replica where the entry resides.

### Entry Inconsistencies

Lists the DN of the entry, then it displays the "Attribute" that is different and what those values are on each replica.  If state information is available it is also displayed.  If there is no state information for an attribute it is listed as an **Origin value**.  This means the value has not been touched since replication was first initialized, in other words it means the value is pristine and was never updated.



## Usage Examples
---------------

### LDAP connection

```
python repl-diff.py -D "cn=directory manager" -w PASSWORD -m ldap://myhost.domain.com:389 -r ldap://otherhost.domain.com:389 -b "dc=example,dc=com"
```

### LDAP with StartTLS

```
sudo python repl-diff.py -D "cn=directory manager" -w PASSWORD -m ldap://myhost.domain.com:389 -r ldap://otherhost.domain.com:389 -b "dc=example,dc=com" -Z /etc/dirsrv/slapd-myinstance
```

### LDAPS

```
sudo python repl-diff.py -D "cn=directory manager" -w PASSWORD -m ldaps://myhost.domain.com:636 -r ldaps://otherhost.domain.com:636 -b "dc=example,dc=com" -Z /etc/dirsrv/slapd-myinstance
```

### LDAPI

```
sudo python repl-diff.py -D "cn=directory manager" -w PASSWORD -m ldapi://%2fvar%2frun%2fslapd-ID.socket -r ldap://otherhost.domain.com:389 -b "dc=example,dc=com" -Z /etc/dirsrv/slapd-myinstance

sudo python repl-diff.py -D "cn=directory manager" -w PASSWORD -m ldapi://%2fvar%2frun%2fslapd-ID.socket -r ldap://otherhost.domain.com:389 -b "dc=example,dc=com"
```

### LDIF

```
sudo python repl-diff.py -b dc=example,dc=com -M /tmp/replicaA.ldif -R /tmp/replicaB.ldif
```

## Output Example
---------------------------

```

# repl-diff.py -m ldap://localhost:389 -r ldap://localhost:5555 -D "cn=directory manager" -w password -b dc=example,dc=com

Performing online report...

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

Master:  12
Replica: 10


Tombstones
=====================================================

Master:  10
Replica: 10


Conflict Entries
=====================================================

Master Conflict Entries: 2

 - nsuniqueid=48177227-2ab611e7-afcb801a-ecef6d49+uid=steve038,dc=example,dc=com
    - Conflict:   namingConflict (add) uid=steve038,dc=example,dc=com
    - Glue entry: no
    - Created:    Wed Apr 26 20:27:40 2017

 - nsuniqueid=48177228-2ab611e7-afcb801a-ecef6d49+uid=steve039,dc=example,dc=com
    - Conflict:   namingConflict (add) uid=steve039,dc=example,dc=com
    - Glue entry: no
    - Created:    Wed Apr 26 20:27:40 2017


Replica Conflict Entries: 2

 - nsuniqueid=48177227-2ab611e7-afcb801a-ecef6d49+uid=steve038,dc=example,dc=com
    - Conflict:   namingConflict (add) uid=steve038,dc=example,dc=com
    - Glue entry: no
    - Created:    Wed Apr 26 20:27:40 2017

 - nsuniqueid=48177228-2ab611e7-afcb801a-ecef6d49+uid=steve039,dc=example,dc=com
    - Conflict:   namingConflict (add) uid=steve039,dc=example,dc=com
    - Glue entry: no
    - Created:    Wed Apr 26 20:27:40 2017


Missing Entries
=====================================================

  Entries missing on Master:
   - uid=bbrown850,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=asmith993,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=breynolds994,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=grose995,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=bmegginson1002,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=bmorris71,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)
   - uid=akinder422,dc=example,dc=com (Created on Replica at: Wed Apr 12 14:43:24 2017)

  Entries missing on Replica:
   - uid=hrose803,dc=example,dc=com (Created on Master at: Wed Apr 12 14:43:24 2017)
   - uid=adugan870,dc=example,dc=com (Created on Master at: Wed Apr 12 14:43:24 2017)
   - uid=hrose75,dc=example,dc=com (Created on Master at: Wed Apr 12 14:43:24 2017)
   - uid=hsholl122,dc=example,dc=com (Created on Master at: Wed Apr 12 14:43:24 2017)
   - uid=hrose280,dc=example,dc=com (Created on Master at: Wed Apr 12 14:43:24 2017)


Entry Inconsistencies
=====================================================

cn=group2,dc=example,dc=com
---------------------------
Replica missing attribute "objectclass":

 - Master's State Info: objectClass;vucsn-58e53baa000000020000: top
 - Date: Wed Apr  5 14:47:06 2017

 - Master's State Info: objectClass;vucsn-58e53baa000000020000: groupofuniquenames
 - Date: Wed Apr  5 14:47:06 2017


uid=bmullen463,dc=example,dc=com
--------------------------------
 - Attribute 'cn' is different:
      Master:
        - State Info: cn;adcsn-58ee5357000000010000;vucsn-58ee5357000000010000: Brad Mulleny
        - Date:       Wed Apr 12 12:18:31 2017

      Replica: 
        - Origin value: Brad Mullen

cn=group1,dc=example,dc=com
---------------------------
 - Attribute 'cn' is different:
      Master:
        - State Info: cn;vucsn-58e53baa000000020000;mdcsn-58e53baa000000020000: My value
        - Date:       Wed Apr  5 14:47:06 2017

      Replica:
        - State Info: cn;adcsn-58e7e0de000000020000;vucsn-58e7e0de000000020000: My value
        - Date:       Fri Apr  7 14:56:30 2017

        - State Info: cn;vucsn-58e7e0de000000020000: Another value
        - Date:       Fri Apr  7 14:56:30 2017

 - Attribute 'description' is different:
      Master:
        - State Info: description;vucsn-58e53bd9000000020000: okay
        - Date:       Wed Apr  5 14:47:53 2017

      Replica:
        - State Info: description;adcsn-58e7d61c000000020000;vucsn-58e7d61c000000020000: Replica is now different
        - Date:       Fri Apr  7 14:10:36 2017
```





