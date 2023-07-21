---
title: "DNA Plugin"
---

# DNA Plugin Design
-------------------

{% include toc.md %}

Overview
--------

The DNA (distributed numeric assignment) plug-in is designed to manage a set of unique numeric values within a particular range across a group of entries. A common use case would be to automatically assign unique uid numbers to new user entries as they are created.

### Basic Usage

The basic usage of the DNA plug-in is as follows. Let's assume that we want the Directory Server to manage the "uidNumber" attribute for all "objectclass=posixAccount" entries. We want to allow the Directory Server to use numbers in the 500-10000 range. With the DNA plug-in properly configured for this scenario, the following use cases would be supported:

-   Adding a new "posixAccount" entry with no "uidNumber" attribute present in the ADD operation would result in a new free value for the range being added to the entry by the plug-in.
-   Adding a new "posixAccount" entry with a "uidNumber" value defined in the ADD operation would result in the specified value being used, regardless of the range configuration or existing data in the Directory Server.
-   Adding a new "posixAccount" entry with a magic "uidNumber" value would result in a new free value for the range being added to the entry by the plug-in. See the configuration section below for more details on the magic value.
-   Modifying an existing "posixAccount" entry and adding or replacing the value of "uidNumber" with a specified value would result in the specified value being used, regardless of the range configuration or existing data in the Directory Server.
-   Modifying an existing "posixAccount" entry and adding or replacing the value of "uidNumber" with the magic value would result in a new free value for the range being added to the entry by the plug-in.

As you can see, the design allows one some flexibility in being able to override the management of the value range, but it can't totally prevent you from shooting yourself in the foot. The DNA plug-in will check if a value within the range has been used outside of the scope of the plug-in before assigning it. When it detects this, it just skips to the next value. This will prevent problems most of the time, but there is still a window where the DNA plug-in sees that a particular value is available, but another operation manually uses that value immediately after the check. There is also no easy way for the DNA plug-in to prevent one from manually using a value that has already been assigned (with via the DNA plug-in, or manually).

The take-home lesson here is that you should probably avoid manually specifying values that are within the configured managed range. The main use of manually specifying a value within the managed range is for replicated values from another supplier.

### Scoped Range Behavior

The DNA plug-in allows you to confine the management of a particular range to a specific portion of the DIT. This is accomplished with the "dnaScope" configuration attribute. The basics of this are that an entry uses the configured managed range whose scope is closest in the DIT. Note that only one range for a particular attribute type will be used on an entry, but ranges for different attribute types using different scopes will be used on one entry.

It's important to note that you can manage two overlapping ranges for the same attribute type in different portions of the DIT. Take the example of a Directory Server instance being used to service two separate groups of users, possibly for two separate divisions or sub-companies. You could manage a range of "1-1000" for the "uidNumber" attribute for the "ou=company1,dc=megacorp,dc=com". At the same time, you could have a separately managed range for the same attribute with the same range of values for the "ou=company2,dc=megacorp,dc=com". This means that your directory instance as a whole would have duplicated values for "uidNumber", but each separate scope in the tree would have a uniquely managed range.

It is also possible for the scope of the two managed ranges to overlap. If we modify our top example, we would configure one of the ranges at a scope of "dc=megacorp,dc=com" and the other range at a scope of "ou=company1,dc=megacorp,dc=com". This would result in the "company1" organizational unit having it's own managed range while everything else under "dc=megacorp,dc=com" would use the other managed range. Nesting ranges like this could be confusing, so it should really only be used if the structure of your DIT absolutely requires it.

### Multi-Attribute Ranges

Starting with version 1.3.0, we plan to support multi-attribute ranges. A multi-attribute range is a single range that is shared across multiple attribute types.

Consider the scenario where you are creating posixAccount and posixGroup entries. When creating posixAccount entries, let's assume that you want the uidNumber and gidNumber (primary group) attributes to be assigned by DNA, but you also want them to be the same value. In addition, you want DNA to assign the gidNumber attribute from the same range when creating posixGroup entries to avoid the same gidNumber being used twice (for a user primary group as well as an unrelated posixGroup entry). A multi-attribute range would let you handle the above scenario.

To define a multi-attribute range, you would simply set multiple dnaType attribute values in a single range configuration entry. If a range is configured to span multiple attributes, there are a few differences in the usage of DNA. If you want DNA to assign a value from the range, you must specify the magic value for all attributes that you want the value assigned to. Simply omitting any of the managed attributes from the entry will not result in DNA adding them for you. The reasoning behind this behavior is that not all entries may require all of the attributes that the range spans across. If we consider the above scenario, we may have a range configuration entry like this:

    dn: cn=UID and GID numbers,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: UID and GID numbers
    dnatype: uidNumber
    dnaType: gidNumber
    dnamaxvalue: 10000
    dnamagicregen: 0
    dnafilter: (|(objectclass=posixAccount)(objectclass=posixGroup))
    dnascope: dc=example,dc=com
    dnanextvalue: 500

The above range will apply to both posixAccount and posixGroup entries. The posixAccount objectclass requires both the uidNumber and gidNumber attributes. The posixGroup objectclass requires the gidNumber attribute, but the uidNumber attribute is not allowed. If DNA simply added these attributes when they are omitted while adding an entry, the posixGroup entry would fail with an objectclass violation. For this reason, the magic value must be specified to have DNA assign a value from the range when using multi-attribute ranges.

When the magic value is specified for multiple attributes from the same range, a single value from the range will be assigned to all of the attributes. If you want separate values to be assigned from the same multi-attribute range, you will have to do a separate modify operation to add the magic value to each attribute you want a new value for.

### Usage with Multi-Supplier Replication

The DNA plug-in is designed such that you can guarantee uniqueness among a range across multiple supplier Directory Server instances when you are using multi-supplier replication.

#### Shared Config Method

The way that DNA supports multi-supplier replication is to simply assign a separate range to each supplier. This guarantees uniqueness, but it leaves the problem of being able to exhaust the values on a single supplier while still having plenty of values left on the other suppliers. If value allocation is not evenly distributed across all suppliers, then new value allocation will start being refused by the suppliers who have exhausted their local range. This would then require administrator action to manually redistribute the values evenly amount the suppliers.

To solve the problem of exhausted ranges, a set of shared configuration entries is used to facilitate transferring ranges automatically between suppliers when needed. When a supplier exhausts it's local range, it finds out what other servers service this range and how many values each server has available. It can then ask the server with the most values available to transfer a portion of it's range.

The way the shared configuration entries work is that each supplier sets the dnaSharedCfgDN in it's range configuration entry to point to a container entry in the replicated tree. Each supplier will then create an entry under this container entry that it automatically maintains. This shared entry contains the server hostname and port numbers as well as how many unallocated values it has remaining. Here is an example entry:

    dn: dnaHostname=ldap1.example.com+dnaPortNum=389,cn=Accounts,ou=Ranges,dc=example,dc=com
    objectClass: extensibleObject
    objectClass: top
    dnahostname: ldap1.example.com
    dnaPortNum: 389
    dnaSecurePortNum: 636
    dnaRemainingValues: 1000

When a server exhausts it's range (or reaches it's low-water mark threshold), it will search for these shared config entries and get a prioritized list of servers to request range from based on the number of remaining values.

To request a range to be transferred, the requesting server sends a range extension extended operation to the server it wants values transferred from. This extended operation contains the shared config DN. If the receiving server is managing a range that is configured to use that same shared config DN, and it determines that it has enough values to transfer, then it will respond with a lower and upper value, which define the range that it is transferring. The transferred values will always be from the top-end of the range from the server releasing values. A server will give up to half of it's values away, but it will always keep some values for itself to avoid dropping below it's threshold.

A range request will only be processed if the user requesting the range is bound as the replication bind DN. The requesting server will get the replication bind DN and credentials from the replication agreement to contact another server. If the replication agreement is configured to use SSL or certificate client auth, then DNA will use that method as well.

When a server receives range from another server, it will store it in it's local configuration as the next range to use once it's previous range is fully exhausted. When the previous range is gone, the next range will be made active. It is also possible for an administrator to leverage this approach to manually add new range to a server. One can simply set "dnaNextRange" on a server to add a new range that will be used when the active range is exhausted.

#### Interval Method

This method is unsupported (and disabled at compile time) in the current DNA code. For the reasoning behind this decision, please see the [DNA Plug-in Proposal](dna-plugin-proposal.html) page.

The old way of supporting DNA with MMR was accomplished is by essentially dividing a single contiguous range into smaller ranges by using an interval. Let's assume that you want to split a range of 1-300 across three suppliers. You would configure the plug-in on all three supplier instances like so:

-   Supplier 1
    -   dnaNextVal = 1
    -   dnaMaxVal = 300
    -   dnaInterval = 3
-   Supplier 2
    -   dnaNextVal = 2
    -   dnaMaxVal = 300
    -   dnaInterval = 3
-   Supplier 3
    -   dnaNextVal = 3
    -   dnaMaxVal = 300
    -   dnaInterval = 3

This would result in Supplier 1 assigning the values of "1,4,7,10,etc.", Supplier 2 with values of "2,5,8,11,etc.", and Supplier 3 with values of "3,6,9,12,etc.". You can basically accomplish the same thing by allocating 1-100 to Supplier 1, 101 - 200 to Supplier 2, and 201-300 to Supplier 3. The numeric values assigned by each supplier would just be a bit different.

The general idea here was to try to avoid gaps in the values, but that is making a big assumption that the allocation of values is evenly distributed across suppliers. This is very likely a false assumption to make in the majority of cases as new entry creation is likely to be most common on a single server at a particular geographical location. It is likely easier to simply assign a different range to each supplier as you can guarantee that there are only gaps between each supplier's configured range. This approach is also easier to deal with when adding a new supplier instance to the mix as you just need to allocate some unused range instead of modifying the interval on all suppliers.

It should be noted that interval support is not compiled into the DNA plug-in by default. If you want to build the DNA plug-in with interval support for some reason, set DNA\_ENABLE\_MACRO=1 when compiling the plug-in.

Configuration
-------------

The configuration for the DNA plug-in allows one to configure multiple separate numeric ranges. For example, you can have configure such that you want a unique numeric range of values for the "uidNumber" attribute across the "dc=example,dc=com" suffix, as well as a separate numeric range of values for the "gidNumber" attribute within the same suffix. You could even have two separate ranges for the same attribute under separate suffixes. Each unique numeric range is represented by a separate entry beneath the main DNA plug-in configuration entry in "cn=config".

All entries beneath the main DNA plug-in configuration entry are assumed to be DNA configuration entries. If the required attributes are not found in an entry when the configuration is being parsed, that entry will be skipped. A DNA configuration entry supports the following attributes:

-   dnaType - The attribute whose range we are managing. (required)
-   dnaNextValue - The next available free value. (required)
-   dnaMaxValue - The maximum allowed value within the range. Defaults to "-1", which is the maximum value allowed by an unsigned 64-bit integer. (optional)
-   dnaInterval - The interval to increment within the range for the next value. (Not supported unless compiled in)
-   dnaFilter - The filter used to identify entries that we want to manage the range for. (required)
-   dnaScope - The base DN used to identify the entries that we want to manage the range for. (required)
-   dnaMagicRegen - A user-defined magic value that instructs the plug-in to use a new value from the range. This should be a value that is outside of your configured range. It also is not required to be a numeric value, so you can use anything you want. This allows you assign a new managed value to an existing entry by setting the managed attribute to this magic value. (optional)
-   dnaPrefix - A prefix string that is used as a part of the managed values. If you wanted to have a managed range of "user1" through "user1000", you would set dnaPrefix to "user". (optional)
-   dnaThreshold - A threshold of remaining values, which causes a server to request range from other servers once it is reached. The default value is 100. (optional)
-   dnaSharedCfgDN - A shared configuration DN used for transferring ranges between servers. Setting this enables range transfers. The entry referred to by this setting must be manually created by the administrator. The server will automatically contain a sub-entry beneath it. (optional)
-   dnaNextRange - The "on-deck" range to use once the currently active range is exhausted. This is automatically set when range is transferred between servers, but it can also be manually set to add range to a server. The syntax is "<lower_val>-<upper_val>". (optional)
-   dnaRangeRequestTimeout - A timeout to prevent stalling when another server can't be contacted during a range request. The default is 10 seconds. (optional)

### Sample Configuration

These two sample configuration entries enable automatic generation of uidNumber and gidNumber attributes for posixAccount entries. This configuration is setup as it would be for a multi-supplier replication environment.

    dn: cn=Account UIDs,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: Account UIDs
    dnatype: uidNumber
    dnainterval: 1
    dnamaxvalue: 1000
    dnamagicregen: 0
    dnathreshold: 100
    dnafilter: (objectclass=posixAccount)
    dnascope: dc=example,dc=com
    dnasharedcfgdn: cn=Account UIDs,ou=Ranges,dc=example,dc=com
    dnanextvalue: 1

    dn: cn=Account GIDs,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: Account GIDs
    dnatype: gidNumber
    dnainterval: 1
    dnamaxvalue: 1000
    dnamagicregen: 0
    dnathreshold: 100
    dnafilter: (objectclass=posixAccount)
    dnascope: dc=example,dc=com
    dnasharedcfgdn: cn=Account GIDs,ou=Ranges,dc=example,dc=com
    dnanextvalue: 1

Thread Synchronization
----------------------

To prevent any thread synchronization issues, the DNA plug-in uses three locks to protect it's shared data.

### Configuration Cache Lock

A reader/writer lock is used to protect the cached configuration data, which is shared among all threads. The writer lock is only obtained when the configuration cache is reloaded by the loadPluginConfig() function. The reader lock is only obtained when we are processing an operation at the pre-op stage in the dna\_pre\_op() function.

### Range Specific Value Lock

The range specific value lock is used to prevent two threads from generating the same value. This lock is part of the in-memory configuration date for each separate managed range.

### Range Extension Lock

Each separate managed range also has a range extension lock. This is used to prevent two range extension operations related to the same range form simultaneously occurring. The thing that we want to avoid is requesting range form another server who is requesting range from us. This would result in locking up that range on each server until the server idletimeout kills the connection.

