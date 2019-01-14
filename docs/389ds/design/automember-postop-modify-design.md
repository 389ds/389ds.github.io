---
title: "Allow Automembership Plugin to act on modify operations"
---

# Allow Automembership Plugin to Act on Modify Operations
----------------

Overview
--------

Previously the Automembership Plugin was only invoked for "Add" operations.  But if you modified an entry that put the entry into, or out of, the scope of one of the automemebership rules the groups were not updated.  There is now a configuration option(set to "on" by default) that allows the plugin to process modify operations.  This change also improves the "rebuild" task to also cleanup memberships (add or remove the user from groups).

Use Cases
---------

If a user is changed in a way that would move it to a different automember group then only the rebuild task would add the user to the appropriate group.  However, that user would still belong to the original group.  So the user is incorrectly found in two automember groups when that user is expected to only be in one group.  Now with this enhancement the user is added to the correct group right away (no need for a rebuild task), and the user is removed from the old/previous automemeber group. 

Design
------

During a modify operation (in the post op phase) the plugin now compares the before and after entry to see if any of the automember rules are applicable.  If a membership is updated then updated it also cleans up the other group members, kind of like Referential Integrity Plugin.  Basically it takes a snap shot of the pre and post entry automember groups, and then the group differences are cleaned up from the post entry. 


Major configuration options
------------------------------------------

    dn: cn=Auto Membership Plugin,cn=plugins,cn=config
    ...
    ...
    autoMemberProcessModifyOps: on/off

Replication
-----------

No impact.


Origin
-------------

https://pagure.io/389-ds-base/issue/50077

Author
------

<mreynolds@redhat.com>

