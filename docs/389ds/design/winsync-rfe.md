---
title: "WinSync Plugin improvements"
---

# WinSync Plugin improvements
-----------------------------

{% include toc.md %}

Overview
--------

This doc describes the enhancements added to the Windows Sync.

### 1. Support multiple subtrees
Windows Sync was originally designed between a subtree on the Directory Server (DS) and the Active Directory (AD), for instance, "ou=People,dc=example,dc=com" on the Directory server and "cn=Users,dc=example,dc=com" on the Active Directory.  But there is a requirements to synchronize between more pairs, which allows to sync entries under ou=People as well as ou=Groups, separately.

### 2. Support filters
There is a requirement to restlict entries under the subtree by filters.  For inctance, by setting (|(cn=*user*)(cn=*group*)), only entries which contain "user" or "group" in the cn value are synchronized.

### 3. Support range retrieval
AD returns up to MaxValRange number of multi-valued attribute values in one search. If more attribute values exist, unless WinSync in DS does not repeat the search with increasing the range, DS cannot retrieve all the values.  The repeated range retrieval is added.

Configuration
-------------

### 1. Support multiple subtrees

    new config parameter in windwows sync agreement:
    winSyncSubtreePair: DS_Subtree:AD_Subtree

    Example:
    winSyncSubtreePair: ou=OU1,dc=DSexample,dc=com:ou=OU1,DC=ADexample,DC=com
    winSyncSubtreePair: ou=OU2,dc=DSexample,dc=com:ou=OU2,DC=ADexample,DC=com
    winSyncSubtreePair: ou=OU3,dc=DSexample,dc=com:ou=OU3,DC=ADexample,DC=com

### 2. Support filters

    new config parameters in windwows sync agreement:
    winSyncWindowsFilter: additional_filter_on_AD
    winSyncDirectoryFilter: additional_filter_on_DS
					     
    Example:
    winSyncWindowsFilter: (|(cn=*user*)(cn=*group*))
    winSyncDirectoryFilter: (|(uid=*user*)(cn=*group*))

### 3. Support range retrieval

    None.

Implementation Details
----------------------
   
### 1. Support multiple subtrees

-  Attribute type "winSyncSubtreePair" is added to the objectclass "nsDSWindowsReplicationAgreement".
-  If "winSyncSubtreePair" is not set, there is not behavioral difference: the AD subtree "nsds7WindowsReplicaSubtree" and the DS subtree "nsds7DirectoryReplicaSubtree" are used for the sync target checks.
-  When "winSyncSubtreePair" is set, the above 2 config parameters are ignored.  To determine if an entry is the target of the synchronization, the DN is examined whether the DN is a descendent of any of the subtrees or not. If it is, the subtree of the counter part is retrieved.  Moving an entry from one subtree to another is synchronized.  Members of a group is synchronized as long as the member entry is in any of the defined subtrees.

### 2. Support filters
-  The filters are set to the windows_userfilter and directory_userfilter in the private area in the windows agreement.  And when each server is searched the filters are added to the internal filter.  For instance, filters shown in the above Example allow synchronizing the entries which CN contains "user" or "group" only.

### 3. Support range retrieval
AD returns up to MaxValRange number of multi-valued attribute values in one search. If more attribute values exist, subtype ";range=0-(MaxValRange-1)" is added to the type.  AD Client (DS in this case) has to repeat the search with ";range=MaxValRange-*" then ";range=(2*MaxValRange)-*" and so on until the values with the subtype ";range=low-*" are returned.  
