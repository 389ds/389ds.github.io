---
title: "Replication of custom schema Design"
---

# Replication of Custom Schema Design
-------------------------------------

Track via ticket 47721

{% include toc.md %}

Overview
========

At the beginning of a replication session, the supplier checks if its schema needs to be sent to the consumer. If the schema needs to be sent (aka *pushed*), the consumer schema is completely overwritten by the supplier schema. This could creates issues if the consumer schema contained definitions (standard or custom) that were used in some entries.

To check that the schema needed to be sent, the **nsSchemaCSN** (a csn) was tested.

The ticket <https://github.com/389ds/389-ds-base/issues/827> introduced an additional controls. As a supplier it checks that the consumer schema is a subset of the supplier schema before *sending* it. As a consumer it checks that the consumer schema is a subset of the supplier schema before *accepting* it.

This creates an issue, if a custom schema (*99user.ldif*) is defined on a *legacy* instance.

In fact, a *legacy* instance will likely contain a *old* definitions of objectclasses/attributes. Those *old* definitions will prevent this schema to be **accepted** by *recent* instances. In the opposite *recent* instances will not push their schema because of the custom definitions.

The purpose of this ticket is to solve this issue

use case
========

Let's assume we have a replication topology containing F19 instances (389-ds 1.3.1) with a custom schema (99users.ldif) that introduces objectclass 'myObjectClass'. Standard F19 schema is a subset of standard F20 schema, for example in F20 'nsRoleScopeDN' attribute is allowed in 'nsRoleDefinition' objectclass but not in F19.

If we create/upgrade a F20 instance in the topology, this instance will not accept the schema coming from F19 instances because F19 schema is a subset of its own schema.

Design
======

I think this issue would be fixed by ticket <https://github.com/389ds/389-ds-base/issues/496>, but it is a longer term solution.

Here are two options to this issue

Using administrative operations
-------------------------------

Stop all the instance and make sure, the custom definition (99users.ldif) is copied then start the instances.

OR

-   on the most recent instance (F20), do a *ldapmodify* of **cn=schema** in order to add the custom objects

        ldapmodify -h ... 
        dn: cn=schema
        changetype: modify
        add: objectclasses
        objectclasses: ( 1.2.3.4.5.6 NAME 'myObjectClass' SUP top AUXILIARY MUST uid X-ORIGIN 'custom schema' )

-   update or create a dummy entry on F20, this will trigger a replication session to the others instances

**This solution is not convenient because it requests customer actions (with the risk of errors) and also can be painful if the task is to merge schema from different sources**

Learn unknown or extended definitions
-------------------------------------

### Acting as a consumer

When a supplier starts a replication session, it checks if its schema is newer than the consumer schema. If it is the case, it will send its schema (there is a limitation due to <https://github.com/389ds/389-ds-base/issues/827> see below 'Acting as a supplier').

Acting as a consumer, the replica will receive the supplier schema. Before accepting this schema, it will check that **ALL** definitions (attributetype and objectclasses) in received schema are a superset of its own schema definitions. This checking is important as entries on the replica conforms to the current schema and if some definitions in the received schema are subset of the current ones, some entries may violate the received schema.

If the received schema is rejected (definitions are subset), the replica will evaluate **ALL** received definitions. If a received definition is a superset of the current one (unknown definition or extension of a definition), it will add it to a list of *definitions to learn*. Then it will trigger an **internal modify** to add those definitions. The *learned* definition will go to the **99user.ldif** schema file.

It uses an **internal modify** because the current modify will fail (the received schema is a subset of the current one). Even if it adds definitions in in memory schema, the schema file will not be updated if the current modify fails.

### Acting as a supplier

#### The problem

When a supplier starts a replication session, it checks if its schema is newer than the consumer schema. If it is the case

-   before ticket *47490* (like 1.2.11 and 1.3.1) it sends its schema
-   after ticket *47490* (like 1.3.2 and after), it checks the supplier schema \> consumer schema. That means that the **ALL** definitions of the supplier schema are superset of the consumer definition and that the **ALL** consumer definitions are also known in the supplier schema. If 'supplier schema' \> 'consumer schema', it sends the schema else it skips sending the schema. Skipping sending the schema is important as it protect old server (1.2.11 and 1.3.1) with custom schema to get their schema overwritten.

So ticket *47490* creates a problem when both implements *47490*. For example, **ALL** definitions of *serverA* are superset of definitions in *serverB* but *serverB* has additional definitions (custom schema). Then both server will skip sending the schema. *serverA* because it misses the custom schema and *serverB* because the *common* definitions in *serverA* are superset of its own schema.

#### The solution

The most realistic solution is that a replica acting as supplier, **learns** from the consumer schema the unknown/extended definitions. In that case, the supplier will make its schema a strict superset of the consumer schema. Then the supplier will update the consumer with its schema.

If the supplier, does not **learns** it creates several constraints:

-   supplier needs to known if the consumer implements *47490* (to not overwrite custom schema of old servers).
-   All servers in the topology are supplier/hub and for each replica agreement 'A' -\> 'B' it also exists 'B' -\> 'A'. In fact if an instance *learns* (unknown/extended definitions) only when it acts as a consumer, any instance must be consumer (RA toward itself) to learn remote definitions and also supplier to make the others learn its own definitions.

#### implementation consideration

### Performance consideration

These additional checking and learn steps may slow down the replication session but as it occurs rarely it should not create an issue.

### Schema timestamp

A schema is timestamped with a CSN: **nsSchemaCSN**. This CSN only contains a timestamp part (no replicaId and subsequence number).

Currently the CSN is updated after a direct ldap client update of the schema or when the schema is updated from a replication session. During a direct ldap client update, the CSN is generated from current time on the machine. During a replication session, it takes the CSN generated on the other server. There is a bug here . If clock on *serverA* is 1min ahead of the clock on *serverB*. The schema is updated on *serverA* with CSN=T1. Then the schema is replicated on *serverB* with CSN=T1. 10 sec later the schema is updated/extended on *serverB* with CSN=T2. But T2 is still less than T1. The consequence is that *serverB* will not send its schema as its CSN is less than *serverA*. In addition, *serverA* will eventually resend its schema because its csn is larger.

For this bug, a simple fix would be to assign a CSN that max(current\_csn()+1, current\_time()).

Now the replica may trigger internal update when it *learns* new definitions. We need to timestamp those learned definitions with a timestamp as the schema changed. To do this it will assign a csn from the local time (like in external update).

