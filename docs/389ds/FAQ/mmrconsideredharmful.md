---
title: "MMRConsideredHarmful"
---

# Is Multi-Master Replication Really Harmful?
-------------------------------------------

This is in response to <http://www.watersprings.org/pub/id/draft-zeilenga-ldup-harmful-02.txt>

Lightweight Directory Update Protocol (LDUP) was the now defunct IETF LDAP replication working group. Many years of work went into the attempt to create a standard LDAP multi-master replication protocol, but little came of it. The Fedora DS MMR protocol is based on this work.

The author of the paper is technically correct. Any loosely consistent replication model can lead to inconsistencies, including single master replication models. I won't go into too many details, but if you really want to know about different replication consistency models, read this - <http://www2.parc.com/csl/projects/bayou/pubs/uist-97/Bayou.pdf>

In general, the only way to ensure absolute consistency is to use something like two phase commit, used by some RDBMS products. In this case, your write operation does not return a response until that write operation has been successfully propagated to all systems in the replication topology (or rolled back from all in the case of failure).

There is no way for any LDAP loosely coupled replication to guarantee "read your writes" consistency. As an example, consider a single master case with one or more read only replicas. End user clients will typically be pointed to one or more read only replicas to use for searches for load balancing or failover purposes. If the client makes a write request, it will typically be sent a referral to the master, where the write operation will be performed. The write operation will return immediately to the client, without waiting for that write operation to be propagated to the replicas. If the client immediately performs a search request on a replica (which it has been configured to do so), that data may or may not be available, depending on the replication schedule, speed of the master, write performance of the replica, etc., etc.

Any kind of loosely coupled replication breaks ACID:

-   Consistency - the "view" of the data is different depending on which server you talk to
-   Isolation - the update is visible on the master before it is visible on a consumer
-   Durability - it's possible that the change could be lost or refused due to an error condition on a replica

However, the "LDUP harmful" document states the following:

        It is noted that X.500 replication (shadowing) model allows for
        transient inconsistencies to exist between the master and shadow
        copies of directory information.  As applications which update
        information operate upon the master copy, any inconsistencies in
        shadow copies are not evident to these applications.

This would be fine except that almost no real world deployments follow this model. Replicas are used for load balancing, failover, and data locality (e.g. putting a copy of the corporate data in a remote office). Therefore, in almost every LDAP deployment, clients \_use\_ the "shadow copies" directly. In almost every case, load balancing, failover, data locality, "no single point of failure" are the most salient concerns of network architects, and absolute data consistency is secondary.

The "LDUP harmful" document then goes on to give specific examples of where MMR can lead to inconsistencies. In almost every case, the MMR protocol can handle the inconsistency in a logical manner, or flag the inconsistency for operator intervention (with the operational attribute nsds5ReplConflict).

So, knowing that, you have to make your own trade-off between convenience and absolute consistency. MMR gives you the ability to have data locality with writes and no single point of write failure, at the cost of extra administrative overhead - monitoring, looking for conflicts (e.g. search for nsds5ReplConflict=\*), and manually resolving them. MMR has been deployed for years (starting in 3/2001 with iPlanet DS 5.0), and in the vast majority of cases, data inconsistency just doesn't happen.

