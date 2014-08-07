---
title: "Managed Entry Design"
---

# Managed Entry Design
----------------------

{% include toc.md %}

Overview
--------

There is a need from FreeIPA to have an automatically managed user private group entry in Directory Server. The idea is that a plug-in will automatically manage updating a user private group entry that is associated with a user entry. The user private group entry should be considered a managed entry, meaning that it should not be modified by anyone other than the plug-in itself.

This plug-in can be a general-purpose managed entry feature if a generic approach is taken with the design. From this generic standpoint, the entry triggering a managed entry operation will be referred to as the origin entry. The entry that is automatically managed by the server will be referred to as the managed entry.

Configuration
-------------

Configuration will be handled by an entry pair. This entry pair will include a definition entry and a template entry.

### Definition Entry

The definition entry defines what operations require managed entry operations to be performed. It does this by using a search base and a filter. When a write operation comes in where the target entry matches the base and filter, the plug-in will look at the operation to determine what action is necessary. The definition entry also contains a pointer to the template entry that is used to determine the content of the managed entries. Here is an example definition entry:

    dn: cn=UPG Definition,cn=Managed Entries,cn=plugins,cn=config
    objectclass: top
    objectclass: extensibleObject
    cn: UPG Definition
    originScope: ou=people,dc=example,dc=com
    originFilter: objectclass=posixAccount
    managedBase: ou=groups,dc=example,dc=com
    managedTemplate: cn=UPG Template,dc=example,dc=com

The **originScope** and **originFilter** attributes are used by the plug-in to see if an entry being modified requires a managed entry operation to be performed.

The **managedBase** attribute is used to determine where the managed entries will be located.

The **managedTemplate** attribute is a pointer to the template entry to use to determine what needs to be done when updating the managed entries.

The definition entry must be located in **cn=config** beneath the managed entry plug-in configuration entry.

### Template Entry

The template entry is used to determine what a particular managed entry contains. The template entry is a combination of static attribute/value pairs and mapped attributes. The static attribute/value pairs are used as-is when creating a new managed entry. The mapped attributes are used to define attributes where the value(s) in the managed entry come from an attribute in the origin entry.

The template entry can be located anywhere in the DIT since the definition entry has a pointer to it. It is recommended that the template entry be located in the replicated tree if replication is being used. This ensures that all masters are using the same template.

The template entry can not simply look like a managed entry with substitution variables. This approach would cause problems due to schema and syntax validation (such as an attribute using the INTEGER syntax, which would not allow a substitution variable to be used as it's value). The approach taken is to use some special configuration attributes to define the template. Here is an example template entry:

    dn: cn=UPG Template,dc=example,dc=com
    objectclass: top
    objectclass: mepTemplateEntry
    cn: UPG Template
    mepRDNAttr: cn
    mepStaticAttr: objectclass: posixGroup
    mepMappedAttr: cn: $uid
    mepMappedAttr: gidNumber: $gidNumber
    mepMappedAttr: description: User private group for $uid

The **mepRDNAttr** attribute is used to define the attribute to use as the RDN of the managed entries. The attribute used must be defined as a mapped attribute in the template for obvious reasons (a static value would not be unique and would fail for the second created managed entry). The mapped attribute in the origin entry must be a single-valued attribute so there is no ambiguity with regards to which value to use.

The **mepStaticAttr** attribute is used to define static attribute/value pairs to be used when the managed entries are created. The format of the value is *<attribute>: <value>*. This is only used during creation of the managed entry since there is no need to ever update the static value when a change is made to the origin entry.

The **mepMappedAttr** attribute is used to define attributes whose value is mapped from another attribute in the origin entry. The format is *<attribute>: <value>*, where value must contain only one variable that is substituted with a value from the origin entry. A variable is defined by a *\$* character followed by the attribute name whose value you want to use from the origin entry. If a *\$* character is desired in the attribute value, one can use *\$\$* to escape the character. Attributes that are mapped to each other must have the same syntax in order to prevent the plug-in from encountering syntax violations when trying to update the managed entries.

Behavior
--------

The plug-in will have to behave differently for each operation type. A description of what the plug-in does for each operation type is listed below.

### Add Operation

#### Pre-Op Callback

The plug-in will check if the new entry being added is a definition config entry. If so, the entry will be validated. If the config entry is invalid, an error will be logged and the add will be rejected.

#### Post-Op Callback

If the entry being added is a definition config entry,it will be activated.

When a new entry is successfully added that meets the scope and filter criteria of a definition entry, the plug-in will attempt to create a managed entry that is associated with the new entry. The template entry will be used to determine the contents of the new managed entry.

The managed entry will automatically have the *mepManagedEntry* objectclass added to it along with a *mepManagedBy* attribute whose value is the DN of the associated origin entry. If the add of the managed entry is successful, the origin entry will have the *mepOriginEntry* objectclass added to it along with a *mepManagedEntry* attribute whose value is the DN of the associated managed entry.

If the add of the managed entry fails for any reason (entry already exists, etc.), an error will be logged. The initial operation will still go through since we are catching it at the post-op stage.

### Delete Operation

#### Pre-Op Callback

The plug-in will check if the entry being deleted is a template entry that is referenced by a currently active definition entry. If so, an error will be logged and the delete will be rejected.

The plug-in will also check if someone is attempting to delete a managed entry. This deletion will be rejected if it is not an internal operation being performed by the managed entries plug-in itself. A message will be returned to the client stating that the managed entry must be manually unlinked first.

#### Post-Op Callback

The plug-in will check if the entry being deleted is a definition config entry. If so, the managed entry feature will be deactivated for that definition.

When an entry is deleted that meets the scope and filter criteria of a definition entry, the plug-in will attempt to delete the managed entry that is associated with the entry being deleted. If the managed entry is not found, the plug-in will simply log an error and continue.

### Modify Operation

#### Pre-Op Callback

The plug-in will check if the entry being modified is a definition config entry. If so, it will be validated. If the config entry is invalid, an error will be logged and the change will be rejected.

The plug-in will also check if someone is attempting to modify a mapped attribute in a managed entry. This modify will be rejected if it is not an internal operation being performed by the managed entries plug-in itself. A message will be returned to the client stating that modifying mapped attributes of a managed entry are not allowed.

#### Post-Op Callback

If the entry being modified is a definition config entry, the old config will be deactivated and the newly modified config will be activated.

When an entry is modified that meets the scope and filter criteria of a definition entry, the plug-in will attempt to make the appropriate updates to the managed entry associated with the entry being modified. The logic to determine the required updates is to check if any of the attributes being modified are mapped to attributes in the managed entry. If so, a new modify operation is performed against the managed entry to update the attributes with the new mapped values. If the managed entry is not found, the plug-in will simply log an error and continue.

### Rename Operation

#### Pre-Op Callback

The plug-in will check if the entry being renamed is a template config entry that is referenced by a currently active definition config entry. If so, the rename will be rejected.

The plug-in will also check if someone is attempting to rename a managed entry. This deletion will be rejected if it is not an internal operation being performed by the managed entries plug-in itself. A message will be returned to the client stating that the managed entry must be manually unlinked first.

#### Post-Op Callback

The plug-in will check if the entry being renamed is a definition config entry. If it is, and it is being moved outside of the managed entry config area, the config will be inactivated. If an entry is being moved into the managed entry config area, it will be validated and loaded as a config entry.

When an entry is renamed that meets the scope and filter criteria of a definition entry, the plug-in will attempt to rename the managed entry that is associated with the entry being renamed. If the managed entry is not found, the plug-in will simply log an error and continue.

If the client is moving an origin entry outside of the scope of the managed entry configuration, the associated managed entry will be deleted. The *mepManagedEntry* attribute and the *mepOriginEntry* objectclass will be removed from the origin entry.

If the client is moving an entry into the scope of the managed entry configuration, we want to treat it the same was as if that entry was added as a new origin entry. The plug-in will add a new managed entry and link the origin entry to it.

Replication
-----------

The plug-in will not operate on replicated operations. This means that each master should be configured identically in terms of the managed entry plug-in. Each master will make the proper changes to the managed entry when an associated entry is modified directly by a client. All of these changes will then be replicated to the other masters. Here is an example scenario of how this works:

1.  LDAP client adds user **A** to master **1**. The Managed Entry plug-in on master **1** adds a managed group entry **A**.
2.  Master **1** replicates user **A** to master **2**.
3.  Master **2** does *not* invoke the Managed Entry plug-in for the replicated add of user **A**.
4.  Master **1** replicates managed group entry **A** to master **2**.

