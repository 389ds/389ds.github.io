---
title: "Static group performance"
---

# Static Group Performance
--------------------------

Overview
--------

Performance of handling attributes with large sets of values degrades for all type of operations, like deleting a specific value, searching for a specific value and even adding new value is impacted since it must be checked if the value already exists. This is most common for large static groups, but also other attribute types could be affected

Use Cases
---------

Walk through one or more full examples of how the feature will be used. These should not all be the simplest cases.

Design
------

The core of the problem is to be able determine if a value exists and if it exists to locate it in the array of values. The proposed solution is to use a sorted array of values when the number of values exceeds a threshold. If the original order of values needs to be preserved (this is not mandatory by the LDAP standard, but could be expected behavior of applications), then the sorting has to be done indirectly in a second layer.

Implementation
--------------

The implementation changes the implementation of the Slapi\_Valueset data structure and the functions operating on this data structure.

A Slapi\_Valuset will be:

    #define VALUE_SORT_THRESHOLD 10    
    struct slapi_value_set    
    {    
            int num; /* The number of values in the array */    
            int max; /* The number of slots in the array */    
            int *sorted; /* sorted array of indices, if NULL va is not sorted */    
            struct slapi_value **va;    
    };    

The functions to search a value does a binary search on the sorted value array.

The addition of a value will append the value to the end of **va** and the insert num++ into the sorted array

The deletion of a value is the most costly operation: It first locates the index: n of the value in va by a binary search in sorted, then removes the value at index n, and then all the indexes i\>n in sorted get decrement to reflect that va was compressed.

NOTE: In some functions a value tree was generated out of the attribute values to search for values, but it was always don on the fly and didn't handle insertions and deletions. It would have been an option to use this structure and make it persistent as long as the entry is in memory, but the binary tree also does binary search to locate a value, has more overhead and the handling of deleted values becomes more complicated. And it would not allow to have an option to keep the sorting persistent.

Major configuration options and enablement
------------------------------------------

Configuration options are or could be:

-   On/Off: with the option off, always a linear search will be done. If it is known that no attributes with large valuesets exist the feature could be turned off completely
-   Threshold: when the feature is on, it could be an option to specify the threshold when the use of the sorted array should start
-   Keep sorting persistent: With any optimization, if the order is not kept in database each reload of an entry from db will have to do the sorting again, there are two options:
    -   Discard the original order, if it is not required this would be optimal
    -   Keep original order, but store the index of the value, eg in an specific subtype: attr;sort-<index>:value, like it is done for csns

Replication
-----------

Any impact on replication? Not known

Updates and Upgrades
--------------------

Not if sorting if is not persistent. If persistent and indexes are stored only a downgrade would have problems

Dependencies
------------


External Impact
---------------

The Slapi plugin API contains functions dealing directly or indirectly with the valueset data structure. Need to investigate if any of these could change the sorting of the valuearray. Eventually the sorting needs to be invalidated in some calls exposing the valuearray.
