---
title: "Linked Attributes Design"
---

# Linked Attributes Design
--------------------------

{% include toc.md %}

Overview
--------

There is a need to have the ability to bi-directionally link two attributes together across entries. The values of these attributes are DN pointers between the entries. The LDAP client is responsible for updating one (and only one) of these attributes, whose value points to another entry. The linked attribute plug-in will be responsible for updating the entry that is pointed to with a value pointing back to the first entry used as the other attribute. This is very similar to the way that the memberOf plug-in work with the "member" and "memberOf" attributes.

Configuration
-------------

The configuration of the linked attributes plug-in will be implemented as an entry beneath the linked attribute plug-in entry in **cn=config** for each linked attribute pair. This will allow multiple unrelated linked attribute pairs to be configured.

Each configuration entry will represent one pair of linked attributes. One attribute will be defined at the "link" attribute and the other will be defined as the "managed" attribute. The "link" attribute is the attribute whose values are managed by the LDAP client. The "managed" attribute is the attribute whose values are managed by the linked attribute plug-in. These attributes are defined in the following configuration attributes in the linked attribute pair config entry:

-   linkType
-   managedType

It would also be generally useful to have the ability to restrict a linked attribute pair to a particular portion of the DIT. This will be configured by setting the suffix that the linked attribute pair should be applied to as the value of the following optional configuration attribute in the linked attribute pair config entry:

-   linkScope

If a **linkScope** setting is not set, the linked attribute pair will be managed for the entire DIT. The scope check is applied against the both the **linkType** and the **managedType**. If the **linkType** is updated to point to an entry outside of the scope, the plug-in will allow the operation but will not add a backlink.

### Configuration Validation

When a linked attribute pair configuration entry is added or modified, it needs to be validated. Validation needs to ensure that both the **linkType** and **managedType** configuration attributes are present. We also need to ensure that both of the values are valid attributes in the schema whose syntax is Distinguished Name.

The **managedType** will also be checked to ensure that it is a multi-valued attribute. If a single-value attribute was allowed for the managed attribute, setting a link attribute to point to an entry that is already pointed to by another entry's link attribute would cause the first link to be broken.

A violation of the Distinguished Name syntax check will simply be treated as a warning, while violations of the rest of the validation checks will result in that configuration entry being skipped.

The scope will also be validated. Having multiple configuration entries for the same link type for the same scope is not allowed. Nested scopes will not be allowed for the same type as well.

### Sample Configuration Entry

Let's assume that we want to configure a linked attribute pair for two attributes named **directReport** and **manager**. We want to have the LDAP client define manager/employee relationships by managing the "directReport" attribute values in a manager's entry. We want the employee entries to have their **manager** attribute automatically updated by the linked attribute plug-in when changes are made to the **directReport** attribute. The following configuration entry would be added to define this linked attribute pair:

    dn: cn=Manager Link, cn=Linked Attributes, cn=plugins, cn=config
    objectclass: top
    objectclass: extensibleObject
    cn: Manager Link
    linkType: directReport
    managedType: manager

Usage
-----

When a client updates the "link" attribute to add a new value, the linked attribute plug-in will find the entry that is pointed to by the new value. If the entry being pointed to exists, a value will be added to the "managed" attribute pointing back to the entry the client modified. If the entry that is being pointed to doesn't exist, the plug-in will do nothing and just let the operation go through.

When a client updates the link attribute to remove a value, the entry that is referred to in the value being deleted will have the "managed" attribute value pointing back to the modified entry removed. If the entry or back-pointer value doesn't exist, the plug-in will do nothing and just let the operation go through.

If an entry is deleted, any entries that it is pointing to will have their pointer to the deleted entry. This will occur for both forward and backward links.

If a MODRDN operation is made to an entry that has either a link type or managed type present, the links pointing to the renamed entry will be updated to use the new DN.

If a client attempts to update the "managed" attribute, the linked attribute plug-in will allow this. It is recommended to use an ACI to not allow the manual creation of a backpointer.

### Fixup Task

A fixup task should be provided to fix any broken links (or to populate the managed attribute after an import where only the "link" attribute exists). This will work in a similar fashion as the memberOf fixup task.

The task entry can optionally contain a link dn, which is the dn of a linked attribute pair configuration entry that the administrator wants to fix up. If no link dn is provided, all configured linked attribute pairs will be fixed up.

The fixup task will first remove all managed values within the scope (or within all backends if no scope is set). It will then find all link attribute values and create the proper backpointers.

A command line script will be provided named fixup-linkedattrs.pl that creates a task entry for you.

#### Example Task Entry

    dn: cn=example task,cn=fixup linked attributes,cn=tasks,cn=config
    changetype: add
    objectclass: top
    objectclass: extensibleObject
    cn: example task
    ttl: 5
    linkdn: cn=Example Link,cn=Linked Attributes,cn=plugins,cn=config

### Replication

Multi-supplier replication will be handled by having each supplier be responsible for updating the managed attributes. This will require the linked attribute pairs to be defined the same on all suppliers and fractional replication to be setup to exclude the managed attributes. This is the same approach that is used with the memberOf plug-in.

Implementation
--------------

The linked attributes plug-in will be made up of both pre-operation and post-operation callbacks, though most of the real work will be done in the post-operation phase.

### Pre-Operation Callback

The pre-operation callback will be used to allow dynamic configuration of linked attributes. The callback will watch for the addition, removal, or modification of a linked attribute pair configuration entry. The entry that would result from the operation will be checked for validity and rejected if it is found to be invalid. If the resulting configuration entry is found to be valid, the operation will be allowed to continue. The actual application of new configuration settings will be handled in the post-operation callback.

### Post-Operation Callback

The post-operation callback is where the real work will be done with regards to maintaining the linked attributes.

The post-operation callback will first look to see if an operation is a change to a linked attribute pair configuration entry. The changes have already been validated in the pre-operation callback, so we only need to load the new config into memory. This will require a read/write lock to ensure that the configuration cache is not being read while the configuration is being modified.

The post-operation callback will then see if an operation is subject to any of the configured linked attribute pairs. If it is, the backpointers will be updated accordingly.

