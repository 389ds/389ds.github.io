---
title: "OpenLDAP to 389 Directory Server migration"
---

# OpenLDAP to 389 Directory Server migration

Overview
--------

As the major enterprise linux distributions have decided to remove OpenLDAP from their platforms,
there has been and will continue to be interest from major deployments wanting to move from
OpenLDAP to 389 Directory Server. We should not only provide supporting tooling to make this
possible, but also document the possible migrations paths and strategies.

Note this excludes FreeIPA/RHIDM which has it's own LDAP migration tooling, and that not all
deployments can move to IPA due to their requirements.

This document will serve not only as a technical discussion of the approach, but also as a
reference for downstream documentation teams on possible migration approaches.

Differences and Challenges
--------------------------

389 DS and OpenLDAP while both being LDAP servers, are very different projects, with different
features, configurations and approaches. This means there is not a 1:1 parity between the two,
so there will always be situations or configurations that can not be adapted fully.

| Feature          | OpenLDAP             | 389 DS                    | Compatible ? |
| ---------------- | -------------------- | ------------------------- | ------------ |
| 2 way Replication | SyncREPL            | 389 Specific system       | ❌           |
| MemberOf         | Overlay              | Plugin                    | ✅ (simple configs only) |
| External Auth    | SASL Authd           | PTA Plugin                | 🔨 (Config and Data Changes needed) |
| LDAP Proxy       | Proxy                | -                         | ❌           |
| AD Synchronisation | -                  | Winsync Plugin            | ❌           |
| Inbuilt Schema   | OLDAP Schemas        | 389 Schemas               | 🔨 (Upstream work underway) |
| Custom Schema    | OLDAP Schemas        | 389 Schemas               | ✅ (Migration Required) |
| Database Import  | LDIF                 | LDIF                      | ✅ (Some data manipulation may be needed) |
| Password Hashes  | Varies               | Varies                    | 🔨 (Some types may work, some may need development or migration) |
| oldap 2 ds repl  | -                    | -                         | ❌ (No mechanism for openldap to replicate to 389 is possible) |
| ds 2 oldap repl  | -                    | SyncREPL                  | 🔨 (Investigation on 389 able to emulate OpenLDAP syncrepl metadata is underway) |
| TOTP             | TOTP Overlap         | -                         | ❌             |
| EntryUUID        | Part of OpenLDAP     | Plugin                    | 🔨 (Under Review) |

From this snapshot we can hopefully see that it's not possible to mix and match openldap with
389 ds, and that there will always be migration steps required. The only feasible mix and
match will be *if* we develop support for 389-ds syncrepl to impersonate openldap's syncrepl
provider (we will likely not consider delta syncrepl).

Example Topologies
------------------

This is a set of example topologies we consider we could support migration from

## Single RW Server

In this scenario, we are able to do a "once off" migration, replacing the OpenLDAP with 389-ds

## Multiple Active RW Server

In this scenario, as we have no method of replication sync, we would consider the migration to
be where a parallel 389-ds infrastructure is built, and then the related schema and database
is migrated into the new 389 topology.

## Multiple Active RW with RO replicas

In this scenario, this is the same as the multiple active RW server scenario. If there are many
RO servers, it may not be feasible to buld this fully, so we could have the RO replicas read
from 389-ds instead via syncrepl with some live data manipulation. The scope of this is still
under investigation.

Required Changes
----------------

To support the inbuild openldap schema, 389-ds is should adopt the rfc2307compat schema, which resolves
a set of schema conflicts that may arise during a migration. There are no other known conflicts with
openldap schema.

A tool called openldap2ds is being developed that can check for and migrate schema to 389-ds from
openldap instances. It generates a migration plan which can be reviewed and modified, that then
applies changes to the 389-ds instance, as well as suggesting changes for other instances in the topology.

Openldap2ds can also detect some plugins from openldap and configure 389-ds to match. This feature is
limited.

Given an ldif export openldap2ds will be able to import an openldap backup into 389ds, performing
needed data manipulation to remove openldap specific attributes.

EntryUUID as a plugin for 389-ds - openldap uses this as part of it's replication model, and many
applications are configured to use it as a primary key. If there is an existing parallel 389-ds
and openldap instance that will merge, the nsUniqueId and entryUUID will differ, so EntryUUID is
developed as a plugin seperate to nsunique id. This adds some duplication in the server, but in
return admins do not need to manipulate their entryUUID -> nsuniqueid values, and we don't need
to write another virtual attribute transformer. It also allows admins to post migration change the
entryUUID if required.

Administrator Actions needed
----------------------------

We do not support saslauthd so any site using this will need to configure pam pass through auth
with sssd or other modules.

We do not support TOTP, so this can not be migrated at this time.

389-ds does not function as an LDAP proxy, we prefer to have extra read only servers created.

389-ds can use winsync to consume AD information and changes, rather than acting as a proxy.

Migration Plans
---------------

High Level Workflow

The administrator should inventory their current assets, dataflow and configuration. For example
it could be an external IDM that feeds data into silos of OpenLDAP and AD, or it could be OpenLDAP
in proxy mode to AD. It could also be pure OpenLDAP.

The replication topology should be accounted for in this step.

It should also be noted which plugins are enabled, and how authentication is performed and where
credentials are stored.

The parallel 389-ds instance or topology should be brought up. Test migrations with openldap2ds
should be performed. openldap2ds should be run against each server in the topology OR the migration
commands should be run manually against each node to ensure they are in the same configuration state.

The openldap2ds tool can be run to import and manipulate the openldap database as needed.

If openldap is acting as a proxy to AD, 389-ds should be configured with winsync. It should be
checked that the correct data associations are made to the entries.

It may be required to run both openldap and 389-ds silos in parallel due to the nature of the
data and topology. It is critical that writes are able to be directed to BOTH openldap and 389-ds silos
OR that they only flow to one or the other and a cutover process is defined.

When the cut over is made in a single data flow scenario, when moving the 389-ds as the incoming write silo, then the remaining
openldap stack should be configured to syncrepl from 389-ds OR the entire 389-ds topology should be
pivoted to in a single change (this depends on our ability to improve sync repl). This depends on the
size and scale of your topology to whether a "single action" cutover is possible.

Rollback plans should always be developed and understood as in any migration. Backups should always
be taken as needed (Such as system state backup on windows, ldifs and config on openldap, and
db2ldif on 389-ds).

## Author

William Brown william at blackhats.net.au

