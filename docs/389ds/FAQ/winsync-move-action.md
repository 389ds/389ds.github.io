---
title: "WinSync Move Action"
---

# WinSync Move Action
---------------------

{% include toc.md %}

Overview
--------

When DS does the DirSync search to find AD entries to sync, it will search the entire suffix, not just the specified subtree, because it needs to look for deleted entries and entries that have been moved out of scope. For example, if you have

    DS subtree: ou=People,dc=example,dc=com
    AD subtree: cn=Users,dc=example,dc=com

winsync will search under **dc=example,dc=com** not just **cn=Users,dc=example,dc=com**. This means that winsync will find entries that are out of scope of the subtree in the sync agreement.

Windows Sync tries to link AD entries with DS entries by username (AD samaccountname/DS uid) or by the group name (AD samaccountname/DS cn).

In earlier versions of 389 (1.2.6 and earlier), when winsync encountered an AD entry that was out of scope, it would just ignore it. However, when winsync was enhanced to add support for entry move and subtree rename, winsync assumed that AD entries out of scope were moved out of scope, and should therefore delete the corresponding DS entry, even if the entries had not previously been in sync.

With 1.2.11, this is behavior is now configurable with the new **winSyncMoveAction** attribute in the windows sync agreement entry.

Configuration
-------------

    dn: cn=name of sync agreement,cn=replica,cn="your suffix",cn=mapping tree,cn=config    
    objectclass: nsDSWindowsReplicationAgreement    
    winSyncMoveAction: none    

By default, the action is *none*. This means that winsync will do nothing when it finds and out of scope entry.

    winSyncMoveAction: delete    

This is the 1.2.6 and later behavior. If winsync finds an out of scope AD entry, it will delete the corresponding DS entry (corresponding by name/uid as above), even if it has never been in sync.

    winSyncMoveAction: unsync    

This is a new behavior. Some AD admins want "move this entry to another container" to mean "I don't want to sync this attribute any more". The *unsync* option does this. If winsync finds an out of scope AD entry, it will remove the *ntUser* or *ntGroup* objectclass and any sync related attributes from the corresponding DS entry. This means that changes to the DS entry will no longer be in sync with the AD entry, and vice versa. If at some later point you want the entries to be in sync once again, just move the entry back to the sync subtree.

Attempting to set **winSyncMoveAction** to any value other than **none**, **delete**, or **unsync** will cause an error and the value will be set to **none**.

Implementation Details
----------------------

The code in windows\_process\_dirsync\_entry(), beginning at the else case of *if (is\_subject\_of\_agreement\_remote(e,prp-\>agmt))*. Because of the name/uid correspondence, map\_entry\_dn\_inbound() may create a valid existing DS DN from the AD entry. The code looks at windows\_private\_get\_move\_action() to decide what to do at this point.

Consistency Issues
------------------

You almost never want to delete a DS entry without a corresponding AD entry deletion, so don't use **delete** unless you absolutely must for backwards compatibility issues with earlier versions of 389. **unsync** will also cause problems if you unsync the entry then later delete it - the DS entry will still exist.

