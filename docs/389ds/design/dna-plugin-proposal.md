---
title: "DNA Plugin Proposal"
---

# DNA Plugin Proposal
---------------------

### Overview

The DNA (distributed Numeric Assignment) plugin has been created to address the problem of how to assign unique numeric IDs across a multisupplier environment without clashes and without introducing a single point of failure that coordinates the release of unique ids.

Currently it does this by simply partitioning the id space base on the number of servers you plan to have in your environment with a simple formula. The ID space is sliced, so that each server can allocate 1 id every N with N being the number of servers configured. Each server is identified by a different number \< N

So if you have 10 servers and a base of 1000 server 1 will always allocate only 1001, 1011, 1021, etc., server 2 will do 1002,1012,1022, etc...

This way no server can allocate numbers that are outside of it's assigned slice.

### Problems with DNA Plugin

This formula is quite simple and technically works but it comes short under some more careful analysis. One of the problems is that this formula assumes all Suppliers allocate IDs at the same pace, this is not true in some cases. For example if you use DNA to allocate uidNumbers at user creation, and the same server (the one close to the administrator) is used to create all users, we end up with consuming all the space allocated to the sepcific server in 1/Nth of the total ID space, and the ID space will basically be full of holes (1 ID every N is allocated and the others are free). This consumes the ID space fast and in an uneven way.

Mighty ASCII art with 4 servers and only SRV 1 creating users, each server has one vertical slice:

    ...   .   .   .   .   .
          -----------------
    1008  | X |   |   |   |
          -----------------
    1004  | X |   |   |   |
          -----------------
    1000  | X |   |   |   |
          -----------------
    SRV     1   2   3   4

The server can be rotated (change server number to start using a different slice) but this works only if the number of servers is constant. As soon as the number of servers change the slices change as well and it becomes quickly a mess (even not counting the current implementation problem where the DNA plugin does not check if the next available ID is actually really free, it just assumes so).

Last but not least this plugin requires all suppliers to be up and talking to make any configuration changes or possible conflict can easily come up if only some of the suppliers get the configuration update (think of network split case).

### Requirements

It must be possible to spread ID allocation between servers in a way that makes reconfiguring allocation ranges more easy. It must be possible to reconfigure suppliers even if not all of them are online at the same time.

### Possible Solutions

It is certainly important to retain the ability to allocate IDs from a range or slice so that communication with other DCs is kept to a minimum and necessary only when ranges are depleted and reconfiguration is needed.

Using ranges of IDs instead of an algorithm to split a uniquely available space would make this easier.

Manually splitting the ID space into ranges would be easy. And assigning a range to each server too. The advantage of using a range is that if one server is running low on IDs all is needed is only one other supplier available that has a big enough range assigned. The 2 servers can in fact be reconfigured so that half of the range previously assigned to one server can be reassigned to the other without the need for other suppliers to be online. The change of ownership information will be replicated to them as soon as they come up. There is no possibility that one supplier will steal ranges from another one as communication between the new and the old owner is required to allow the transfer of ownership.

Example:

    ID space defined as 1000-9999
    Supplier 1 owns 1001-3000 (1001-2900 allocated)
    Msster 2 owns 3001-7000 (3001-3200 allocated)
    Supplier 3 owns 7001-10000 (7001-8000 allocated)
    -
    Supplier 3 goes offline
    Supplier 1 is running low on uids (<100 left)
    -
    Supplier 1 contacts Supplier 2 and ask for half of the free IDs
    -
    Supplier 1 owns 1001-3000 and 5101-7000
    Supplier 2 owns 3001-5100
    Supplier 3 owns 7001-10000

Result: All suppliers now have again plenty of free IDs Supplier 1 and Supplier 2 were able to reconfigure their ID spaces even if Supplier 3 was down

### How servers own ranges

The prerequisite is that the ownership of the ranges is actually held as ldap attributes and the information is shared (replicated) between all server. Servers also mark the used Ids. To avoid too much replication traffic the DNA plugin marks chuncks of ranges as reserved as soon as any ID in that chunk is used. The chunk size is defined to be equal or greater than the threshold size.

Example:

    The chunk size is defined as 100 Ids like the threshold
    Supplier 1 owns 1001-5000, the last allocated ID was 2345, the reserved ID range is 1001-2400, the free range is 2401-5000.
    As soon as ID 2401 is allocated, the reserved ID range becomes 1001-2500 and so on 100 by 100.

Each server keeps a count of the unused chunks in all of the assigned ID ranges.

### How to request a new range

This operation can be completely automated. The trigger should be a threshold under which the available number of IDs is considered low (ex. 100) Once a server DNA plugin finds out it is running low on uids (or it is just installed) it should run a task to increase the number of available IDs by borrowing from servers that have large chunks available.

First of all the plugin search the database to find out which server has the biggest number of available chunks, it then finds out the range it wants to split with the original server. Once a reasonable range is found the plugin contacts the owner and modifies the range entry to reflect the change in ownership (reduces the owner range and allocates the new range to itself).

If a server is unreachable or the operation fails, the plugin will try with another server. The order in which servers are contact is directly correlated with the number available of chunks. Starting with the server that has the biggest amount available.

The direct connection is to avoid races where the plugin is operating on outdated information or the server that has been contacted was actually in the process of allocating a huge number of users and depleted the range before the plugin received new information via replication.

The plugin will wait for a grace period before checking again if the server is running low on IDs, to account for replication time for the propagation of the changes to reach back.

Example:

    dn: cn=otherserver,cn=ranges,...
    changetype: modify
    delete: range
    range: 1001-3400
    add: range
    range: 1001-2300

    dn: cn=ownserver,cn=ranges,...
    add: range
    range: 2301-3400

The first operation will fail if the range has already been manipulated by someone else, the second operation will not be operated if the first fails.

### Considerations

What happen if the server is directly reachable but the replication topology is broken and the changes do not reach back the original server ? After the first change the plugin will have outdated information, when the grace period expires the plugin will, probably, try again with the same server and fail to the operation to grab a new range, at this point it will switch to another server. The Supplier requesting the new ranges cannot use them until the replication is over and its db has been changed accordingly to inform it of the new ownership.

