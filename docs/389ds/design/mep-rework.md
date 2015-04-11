---
title: "Managed Entries Plugin Rework"
---

# Managed Entries Plugin Rework
------------

# Overview

The Managed Entries Plugin arose from the need for FreeIPA to create user-personal groups. However the plugin was designed heavily with the FreeIPA use cases in mind, so as a result, the only time that Managed Entries were created was on Origin Entry creation. As other groups have attempted to retrofit managed entries into their existing ldap, the need to be able to generate the Managed Entry from an Origin on MOD operations on the origin has arisen. This is being addressed in the interim by https://fedorahosted.org/389/ticket/48140 , but during the development of this a number of shortcomings were found (Potentially recursive operations, inability to delete managed entries easily when an origin goes out of scope).

Before reading this document, please read and be familiar with the original Managed Entry Design.

http://www.port389.org/docs/389ds/design/managed-entry-design.html

# Use Cases

A Managed Entry Definition is created and a Managed Entry Template created.

When an object is created that matches the conditions of the Definition, it is converted to an origin entry, and the managed entry is created from the template.

When an object already exists, and is modified to that it is now matching the conditions of the Definition, the entry is converted to an origin entry, and the managed entry is created.

When an origin entry is deleted, the related managed entry will be deleted.

If configured (non-default), when an entry is modified such that it no longer satisfies the conditions of the Definition, the Managed Entry should be deleted, and the Origin Entry should be de-configured from being an origin.

# Configuration

## Definition Entry

The existing Definition Entry design will be retained.

A single attribute will be added to the schema, managedOutOfScopeAction.

    dn: cn=UPG Template,dc=example,dc=com
    ....
    managedOutOfScopeAction: delete

For the optional delete when out of scope, this should be either defined at the dse level via the plugin configuration, or at the Managed Entry Definition level.
If this value is defined as "delete" then when an Origin Entry no longer satisfies the conditions of the Definition, the Managed Entry will be deleted.

If this value is not defined, or is defined to any value that is not "delete", when an Origin Entry no longer satisfies the conditions of the Definition, the Managed Entry will NOT be deleted.

## Template Entry

Will not change from the original design of Managed Entry Templates.

# Behavior

The plugin will behave differently depending on the operation called upon it.

## Add Operation

### Pre-Op Callback

If the new entry is a Managed Entry Definition, the configuration will be validated. If the config is invalid, the operation will be rejected, and an error logged.

If the new entry is not a Managed Entry Definition, the entry will be checked to determine if it falls in scope on a Managed Entry Definition. 

If it does not fall in scope, the add operation is allowed to proceed.

If it does fall in scope, the add operation has the additional attributes added:

    objectClass: mepOriginEntry
    mepManagedEntry: rdn,managedBase

Where the DN is defined by the attributes of the add operation and the Managed Entry Definition attribute "managedBase".

### Post-Op Callback

If the object being added is a Managed Entry Definition, the configuration is reloaded.

The object that was added will be checked. If the object contains the objectClass: mepOriginEntry, and a mepManagedEntry dn, if the mepManagedEntry DN does not exist, it will be created as per the template that defined the mepManagedEntry.

## Delete Operation

### Pre-Op Callback

No action is taken.

### Post-Op Callback

If the entry to be deleted is a Managed Entry Definition, reload the Definition after the deletion has occured.

If the entry to be deleted contains objectClass: mepOriginEntry, the dn defined by mepManagedEntry will be deleted.

## Modify Operation

### Pre-Op Callback

If the entry being modified is a Managed Entry Definition, the Definition will be validated. If the Definition is invalid, the operation will be rejected, and an error logged.

If the new entry is not a Managed Entry Definition, the entry will be checked to determine if it falls in scope of a Managed Entry Definition.

If it does not fall in scope, the add operation is allowed to proceed.

If it does fall in scope, the mod operation has the additional attributes added:

    objectClass: mepOriginEntry
    mepManagedEntry: rdn,managedBase

Where the DN is defined by the attributes of the existing entry, the mod operation and the Managed Entry Definition attribute "managedBase".

### Post-Op Callback

If the object being modified is a Managed Entry Definition, the configuration is reloaded.

The object that was added will be checked. If the object contains the objectClass: mepOriginEntry, and a mepManagedEntry dn, if the mepManagedEntry DN does not exist, it will be created as per the template that defined the mepManagedEntry.

If the object being modified contains objectClass: mepOriginEntry, and a mepManagedEntry: dn, and the Managed Entry Definition contains managedOutOfScopeAction: delete, and the Origin Entry does not meet the requirements of scope for the Managed Entry Definition, then the dn listed by mepManagedEntry: dn will be deleted.

## Rename (modrdn) Operation

### Pre-Op Callback

No action is taken.

### Post-Op Callback

If the object being renamed is a Managed Entry Definition, the configuration is reloaded.

If the object being renamed contains objectClass: mepOriginEntry, and a mepManagedEntry: dn, and the Managed Entry Definition contains managedOutOfScopeAction: delete, and the Origin Entry does not meet the requirements of scope for the Managed Entry Definition, then the dn listed by mepManagedEntry: dn will be deleted.

If the object being renamed is a Managed Origin Entry, and it is remaining in the scope, the Managed Entry is checked to determine if it needs renaming. If so, it is renamed.

If the object being renamed is not a Managed Origin Entry, and it is moving into the Managed Entry Definition scope, the entry is modified to contain the objectClass: mepOriginEntry and the mepManagedEntry dn according to managedBase. As this is a modify operation, the modify post trigger will create the Managed Entry rather than this function.

# Replication

The plugin will not operate on replicated operations, as per the original design. Each ldap server that accepts writes should be configured with an instance of the Managed Entry Plugin, and should hold identical Managed Entry Definitions.

# Potential issues

Origin entries that fall into scope of multiple Managed Entry Definitions are not considered in this design. If an entry is in scope of two Managed Entry Definitions, the action that would put it into scope should be rejected. Alternately, when a Managed Entry Definition is created, if the search base overlaps in any way with an existing Definition, the new Definition should be rejected. At server start up, if dse.ldif was hand edited, and contains overlapping Definitions, then the server should refuse to start and an error logged clearly defining the issue.

# Author

William Brown, william@firstyear.id.au
