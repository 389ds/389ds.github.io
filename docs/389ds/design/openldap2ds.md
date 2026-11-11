---
title: "OpenLDAP to 389 Directory Server migration - Implementation"
---

# OpenLDAP to 389 Directory Server migration

Overview
--------

As the two major enterprise linux distributions (SUSE and Red Hat) have decided to remove OpenLDAP from their platforms,
there has been and will continue to be interest from major deployments wanting to move from
OpenLDAP to 389 Directory Server on SLE and Red Hat Directory Server on RHEL. We should not only provide supporting tooling to make this
possible, but also document the possible migrations paths and strategies to give customers a long
term, supported, high quality LDAP install.

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
| Inbuilt Schema   | OLDAP Schemas        | 389 Schemas               | ✅ (Complete, some esoteric types not supported) |
| Custom Schema    | OLDAP Schemas        | 389 Schemas               | ✅ (slapd.d via migration plan; legacy `*.schema` via `--convert-schema`) |
| Database Import  | LDIF                 | LDIF                      | ✅ (Data manipulation automated in openldap_to_ds) |
| Password Hashes  | Varies               | Varies                    | 🔨 (Some types may work, some may need development or migration) |
| oldap 2 ds repl  | -                    | -                         | ❌ (No mechanism for openldap to replicate to 389 is possible) |
| ds 2 oldap repl  | -                    | SyncREPL                  | 🔨 (Mostly complete, tests in place, some more QA required.) |
| TOTP             | TOTP Overlap         | -                         | ❌             |
| EntryUUID        | Part of OpenLDAP     | Plugin                    | 🔨 (Accepted, pathway to rust-by-default underway) |

From this snapshot we can hopefully see that it's not possible to mix and match openldap with
389 ds, and that there will always be migration steps required. The only feasible mix and
match will be *if* we develop support for 389-ds syncrepl to impersonate openldap's syncrepl
provider (we will likely not consider delta syncrepl). Even in this scenario, as some plugins
and configurations will have different attribute values,

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

## OpenLDAP acting as proxy to AD

In this scenario, 389-ds would be built in parallel to use winsync plugin. This would use a different
configuration and set of integrations to provide the AD read sync services.

Required Changes
----------------

To support the inbuilt openldap schema, 389-ds is should adopt the rfc2307compat schema, which resolves
a set of schema conflicts that may arise during a migration. There are no other known conflicts with
openldap schema.

A tool called **openldap_to_ds** (`src/lib389/cli/openldap_to_ds`) checks for and migrates content from
OpenLDAP into a 389-ds instance. It supports two independent workflows:

1. **Full instance migration** (default) — reads an OpenLDAP `slapd.d` tree (and optional `slapcat`
   LDIF exports), builds a migration plan, and with `--confirm` applies schema, indexes, selected
   overlay plugins, and database import steps to the target instance.
2. **Legacy `.schema` conversion** (`--convert-schema`) — converts slapd.conf-style `*.schema` files
   (for example `include /etc/openldap/schema/custom.schema`) into 389-ds schema LDIF, optionally
   writing a file, loading via the instance schemadir, or adding over LDAP while the server runs.

Full migration generates a plan that can be reviewed; `--confirm` is required before any change is
applied. Schema from `slapd.d` (`cn=config/cn=schema/*.ldif`, `olcAttributeTypes` / `olcObjectClasses`)
is handled by `lib389/migrate/openldap/config.py` and `lib389/migrate/plan.py` as before.

Openldap_to_ds can also detect some plugins from openldap and configure 389-ds to match. This feature is
limited.

Given an ldif export openldap_to_ds will be able to import an openldap backup into 389ds, performing
needed data manipulation to remove openldap specific attributes.

### Legacy `*.schema` file conversion

Many deployments still ship custom definitions as OpenLDAP **schema** files (multi-line
`attributetype` / `objectclass` blocks referenced from `slapd.conf`). 389-ds expects user schema
as **LDIF** under the instance schemadir (or as `attributeTypes` / `objectClasses` on `cn=schema`).

Implementation lives in `src/lib389/lib389/migrate/openldap/schema.py`.

#### Conversion rules

When converting text (single file or merged directory of `*.schema` files):

| OpenLDAP input | 389 LDIF output |
| -------------- | --------------- |
| `#` comment lines | Preserved unchanged |
| Blank lines | A line containing `#` |
| Lines that are not comments and not `attributetype` / `objectclass` (e.g. `objectidentifier`) | Preserved as comments (`# …`) so the file stays valid LDIF |
| `attributetype` / `objectclass` (any case), possibly split across lines | One line each: `attributeTypes:` / `objectClasses:` with the definition parenthesis joined into a single line |
| First converted definition | Preceded once by `dn: cn=schema` |

Example (conceptual):

```
attributetype ( 1.3.6.1.4.1.6152.10.3.1.26
        NAME 'sendmailMTAAliasSearch'
        … SINGLE-VALUE )

objectclass ( 1.3.6.1.4.1.6152.10.3.2.14
        NAME 'sendmailMTAAliasObject'
        … )
```

becomes:

```
dn: cn=schema
attributeTypes: ( 1.3.6.1.4.1.6152.10.3.1.26 NAME 'sendmailMTAAliasSearch' … SINGLE-VALUE )
objectClasses: ( 1.3.6.1.4.1.6152.10.3.2.14 NAME 'sendmailMTAAliasObject' … )
```

API highlights:

- `convert_openldap_schema_text()` — string in, LDIF string out (human-oriented output may include `#` lines between definitions).
- `convert_openldap_schema_files()` — paths to `*.schema` files or directories; merges multiple files into one LDIF document (single `dn: cn=schema`).
- `normalize_schema_ldif_for_schemadir()` — strips comment lines and emits one schemadir-safe entry (`dn: cn=schema`, lowercase `attributetypes` / `objectclasses`). Used automatically when installing to disk because schema reload validates every `*.ldif` in the schemadir and rejects layouts that embed `#` between attributes of the same entry.
- `apply_schema_ldif_online()` — `MOD_ADD` each definition on `cn=schema` via `lib389.schema.Schema`.
- `install_schema_ldif_to_schemadir()` — writes normalized LDIF, sets mode `0o644` on the file, runs a schema reload task against the instance schemadir, waits for completion, and removes the file if reload fails so a bad LDIF does not block the next server start.

Object classes must use syntax the 389 schema parser accepts (for example `MUST ( objectclass $ cn )` and `MAY ( attrName )` rather than bare `MUST cn`). Invalid definitions cause schema reload to fail with LDAP result 65 (`LDAP_OBJECT_CLASS_VIOLATION`).

Regression tests: `dirsrvtests/tests/suites/openldap_2_389/migrate_schema_test.py` (conversion unit checks, schemadir install + restart, online LDAP add).

#### CLI: `--convert-schema` mode

Argument group **OpenLDAP .schema conversion** on `openldap_to_ds`:

| Option | Purpose |
| ------ | ------- |
| `--convert-schema SCHEMA …` | One or more `.schema` files or a directory containing `*.schema` |
| `-o` / `--output` FILE | Write converted LDIF to a file; if omitted and not applying to the server, LDIF is printed to stdout |
| `--apply-online` | Add definitions over LDAP (requires `instance` and a bind to the running server) |
| `--copy-to-schemadir [FILENAME]` | Write normalized LDIF into the instance schemadir and start schema reload; default basename `98openldap-migrated.ldif` |

Rules:

- With `--convert-schema`, `instance` and `slapd_config` are **not** required unless applying schema to 389-ds.
- `--apply-online` and `--copy-to-schemadir` are mutually exclusive.
- Full migration mode still requires `instance`, `slapd_config`, and uses `--confirm` before changes.

Examples:

```bash
# Convert only (no instance)
openldap_to_ds --convert-schema /etc/openldap/schema/custom.schema -o /root/98custom.ldif

# Convert all *.schema in a directory
openldap_to_ds --convert-schema /etc/openldap/schema -o /root/custom.ldif

# Install on disk and reload (run on the 389-ds host as root/dirsrv)
openldap_to_ds standalone1 --convert-schema custom.schema --copy-to-schemadir 98custom.ldif

# Add while the server is running
openldap_to_ds standalone1 --convert-schema custom.schema --apply-online
```

For syncrepl setups that still `include` a file such as `dsee.schema`, convert that file with
`--convert-schema` before placing the result in the instance schemadir or importing via LDAP.

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

We do not support TOTP, so this can not be migrated at this time. The versions of openldap on the
enterprise distros do not support TOTP anyway, so this is likely not to be an issue.

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

The parallel 389-ds instance or topology should be brought up. Test migrations with **openldap_to_ds**
should be performed. openldap_to_ds should be run against each server in the topology OR the migration
commands should be run manually against each node to ensure they are in the same configuration state.

Custom schema in legacy `*.schema` files can be converted and loaded separately with
`openldap_to_ds --convert-schema` before or alongside a full `slapd.d` migration.

The openldap_to_ds tool can be run to import and manipulate the openldap database as needed.

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

Syncrepl
--------

A requested feature has been the ability to have 389-ds be able to provide changes to openldap
read-only replicas. It is not feasible to have 389-ds consume from openldap, but to provide is
a simpler matter.

Focusing on syncrepl (not delta-sync repl) makes for a simpler, and easier implementation, as well
as only focusing on the "refreshOnly" mode. This has largely been implemented already, but some
deviations from the current implementation are observed. (See also https://tools.ietf.org/html/rfc4533)

## Initial Repl

The initial replication is initiated by a search request with the syncRequestOID, SyncRequestValue
with a cookie containing the consumers rid and *no* CSN.

     rid=123

The provider then responds with all entries, with a syncStateOID control that has the state add (1)
and the EntryUUID of the entry.

The searchResDone message then provides a SyncDoneOID control with a cookie the rid of the
consumer, and the CSN that was replicated up to. The cookie format

     rid=123,csn=20200525045810.162381Z#000000#000#000000
     rid=123,csn=20200525051329.534174Z#000000#000#000000

The OpenLDAP consumer *will* parse this CSN to order the events that have just been provided, however the consumer
then assigns it's own internal CSN to the events. This CSN is based on the systems localtime and is
not a lamport clock, which means that there may be occasions the generated CSN could be out of
order relative to others.

The OpenLDAP consumer *will* assert that the Ldap Message SyncUUID is equivalent to the EntryUUID
*if* EntryUUID is present (if EntryUUID is not present, it is generated from the SyncUUID).

* Further Replications

The subsequent requests are made with the cookie with the last rid and csn provided in the SyncRequestValue.
This allows the provider to know where to start to "send updates" from. These updates are documented below
based on the causing operation type.

## 389 Already Supported Elements

We can already provide sync repl with the following setup.

    dsconf localhost plugin retro-changelog enable
    dsconf localhost plugin retro-changelog set --attribute nsuniqueid:targetUniqueId
    dsconf localhost plugin retro-changelog add --attribute entryuuid:targetEntryUUID
    dsconf localhost plugin contentsync enable
    dsconf localhost plugin contentsync set --attribute syncrepl-allow-openldap:on
    dsconf localhost backend create --suffix dc=example,dc=com --be-name userRoot
    dsidm localhost initialise

create a sync capable user.

	dn: cn=syncrepl,ou=services,dc=example,dc=com
	objectClass: top
	objectClass: organizationalRole
	objectClass: nsAccount
	cn: syncrepl
	userPassword: password
	nsSizeLimit: -1
	nsLookThroughLimit: -1
	nsTimeLimit: -1
	nsidletimeout: -1
	#
	ldapadd -f 389_sync_acct.ldif -D 'cn=Directory Manager' -w password -x -H ldap://127.0.0.1:3389

We want to limit what can be synced. We achieve this with access controls on the account.

	dn: dc=example,dc=com
	changetype: modify
	add: aci
	aci: (targetattr != "aci || creatorsName || modifiersName || createTimestamp || modifyTimestamp || parentId || entryId || nsAccountLock || numSubordinates || tombstoneNumSubordinates || nsSizeLimit || nsLookThroughLimit || nsTimeLimit || nsidletimeout")(targetfilter="(objectClass=*)")(version 3.0; acl "Enable sync repl full read"; allow (read, search)(userdn="ldap:///cn=syncrepl,ou=services,dc=example,dc=com");)
	#
	ldapmodify -f 389_sync_aci.ldif -D 'cn=Directory Manager' -w password -x -H ldap://127.0.0.1:3389

## OpenLDAP configuration.

Add the dsee schema (legacy file or converted LDIF). Example slapd.conf include:

	include /etc/openldap/schema/dsee.schema

Convert for 389-ds with:

	openldap_to_ds --convert-schema /etc/openldap/schema/dsee.schema -o /path/to/98dsee.ldif

Then install with `--copy-to-schemadir` or merge into your schemadir by hand.

Load MDB

	moduleload back_mdb.la

Configure the database

	database     mdb
	suffix       "dc=example,dc=com"
	rootdn       "cn=Manager,dc=example,dc=com"
	rootpw       password
	directory    /var/lib/ldap
	index        objectClass eq
	index        entryUUID eq

	syncrepl rid=123
			provider=ldap://172.17.0.2:3389
			binddn="cn=syncrepl,ou=services,dc=example,dc=com"
			bindmethod=simple
			credentials=password
			searchbase="dc=example,dc=com"
			# It is likely wise to limit this to objectClasses you are interested in (IE ou, group, account only)
			filter="(objectClass=*)"
			schemachecking=off
			scope=sub
			type=refreshOnly
			retry="3 +" interval=00:00:00:03
	updateref ldap://172.17.0.2:3389

## Troubleshooting

check the changelog:

	ldapsearch -H ldap://172.17.0.2:3389 -b cn=changelog -D 'cn=Directory Manager' -x -w password

Show the current openldap cookie:

	ldapsearch -H ldap://127.0.0.1 -b 'dc=example,dc=com' -s base -x  contextCSN
	# example.com
	dn: dc=example,dc=com
	contextCSN: 21000101110148.000000Z#000000#000#000000

## 389 Changes Required to Allow OpenLDAP Compatible Syncrepl

Due to OpenLDAP's replication being "whole entry" based, and the details in the syncrepl being very
simple, it is easy to emulate with a small number of changes. This allows a "readonly" OpenLDAP
server to exist, however, access control and bind may not work as "expected". It may be the case that
admins do not wish for this functionality to exist, so OpenLDAP sync is enabled per server.

If we detect the initial request with a rid= format, and the value syncrepl-allow-openldap=on is set,
we know that we are in openldap provider mode (compared to other sync repl clients that will provide
an empty sync cookie).

We can generate an OpenLDAP compatible CSN by converting the changenumber into a timestamp via
unix epoch. By adding an offset we can guarantee that the CSN's we generate will "always be
higher" than anything OpenLDAP can generate, preventing conflicts.

This would allow us to construct an openLDAP compatible synccookie, that has the correct timestamps
and that when they come to query us next, we are able to provide "what changed since" and guarantee
correct ordering of events.

No other changes are needed.

## Plugin Configuration

To enable OpenLDAP sync, the following parameter exists:

    cn=Content Synchronization,cn=plugins,cn=config
    syncrepl-allow-openldap: off|on

With dsconf:

    dsconf localhost plugin contentsync enable
    dsconf localhost plugin contentsync set --attribute syncrepl-allow-openldap:on

## EntryUUID

The currently syncrepl plugin uses nsUniqueId to provide the SyncUUID for operations. As OpenLDAP
enforces that SyncUUID must be equal to EntryUUID, when providing to an OpenLDAP client, then
we enforce that EntryUUID must be present. This is ensure the UUID's are stable between
OpenLDAP and 389-ds for consuming applications and to prevent data inconsistency between 389-ds and
OpenLDAP. Consider if we had an entry with NO entryUUID. When sent to OpenLDAP, the SyncUUID would
be from the NsUniqueId, which would cause OpenLDAP to create the EntryUUID as the derivative of the
SyncUUID (nsUniqueId). If the entry then had the EntryUUID attribute added, we would *not* send a
delete of the nsUniqueId, and we would send a present of the EntryUUID as the SyncUUID. This would
cause the OpenLDAP server to reject the SyncRepl due to conflicting DN and mismatching UUID's. As
can be imagined, this is "not fun". Rather than attempt to track these changes to make it "consistent"
it is much simpler to enforce that EntryUUID is required for OpenLDAP syncrepl.

When in OpenLDAP mode, only entries with "EntryUUID=\*" are sent to the requesting client. This
is added internally to the filter.

To support consistent deletes, we must then track the EntryUUID in the retro changelog so that we
can correctly send entry deletes. This is configured in the retro changelog with:

    dsconf localhost plugin retro-changelog enable
    dsconf localhost plugin retro-changelog set --attribute nsuniqueid:targetUniqueId
    dsconf localhost plugin retro-changelog add --attribute entryuuid:targetEntryUUID

Since we only send entries that have "EntryUUID=\*", we can assert that targetEntryUUID must also
then be present in the Retro Changelog. This allows on delete events, for the targetEntryUUID
to be sent and the SyncUUID to be consistent.

## Investigation of the OpenLDAP DSEE Compatible Sync

OpenLDAP 2.5 has a DSEE compatible sync mode that combines syncrepl searches with a cn=changelog search
and interpretation. However, the major enterprise distros are using version 2.4 so this is unlikely
to be an option.

## Author

William Brown wbrown at suse.de
