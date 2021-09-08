---
title: "Automatic toggle of virtual attributes handling"
---

# Automatic toggle of virtual attributes handling
----------------

{% include toc.md %}

# Overview
---------

The server support virtual attributes in search requests. virtual attributes are supported in the search filter and also in the returned attributes. Virtual attributes are implemented via a list of registered service providers. This mechanism creates performance issues both in terms of CPU consumption and search throughput (contention). The reason is that the mechanism itself is complex and expensive.
By default the server support virtual attributes and so reduce its throughput. This document propose a way to enable the support of virtual attribute only when it is necessary

# Use cases
-----------

# Major configuration options and enablement
--------------------------------------------

The feature change the default value of the configuration attribute nsslapd-ignore-virtual-attrs to **on**.
At startup, if the value is **off** (set by the DS admin) the server does nothing.
If the value is **on** and if it exists virtual attribute definitions then the value is set to **off**

# Design
--------

## Current implementation
Virtual attributes are implemented via *private* registering fonction slapi_vattrspi_regattr and slapi_vattrspi_register. So the only supported virtual attributes use the [COS](https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/advanced_entry_management-assigning_class_of_service) or [ROLES](https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/advanced_entry_management-using_roles) plugins.

### Roles plugin
The Roles plugin is enabled by default and registers a **nsRole** virtual attribute in its startup callback.

The values of the virtual attribute **nsRole** are taken from role definitions that are *ldapsubentry* with the objectclass *nsRoleDefinition*. So even if **nsRole** attribute is systematically registered, it has no impact unless it exists **nsRoleDefinition** entries.

### Cos Plugin
The Cos plugin is enabled by default. It registers virtual attributes (*cosAttribute*) that are defined in **cosSuperDefinition** entries.

## New implementation
The server will be configured to ignore by default virtual attributes (**nsslapd-ignore-virtual-attrs: on**).

If *nsslapd-ignore-virtual-attrs: off* (setting by the DS admin) do nothing, so do lookup for virtual attributes.
In slapi_vattrspi_regattr, if *nsslapd-ignore-virtual-attrs: on* and there is a registered attribute different than *nsRole* then toggle *nsslapd-ignore-virtual-attrs: off*.
Few second after startup (2sec), spawn a virtual-attribute check thread. That thread will do an internal search with the following filter *'(|(objectclass=nsRoleDefinition)(objectclasss=cosSuperDefinition))*'. If it retrieve one or more entries, then it toggles *nsslapd-ignore-virtual-attrs: off*. Before doing the internal search, the thread exits if *nsslapd-ignore-virtual-attrs: off*.


# Tests

## performance

Install the instance with sample entries, then add 20 entries like

    dn: uid=demo[1..20]_user,ou=people,dc=example,dc=com
    objectClass: top
    objectClass: nsPerson
    objectClass: nsAccount
    objectClass: nsOrgPerson
    objectClass: posixAccount
    uid: demo[1..20]_user
    cn: Demo User
    displayName: Demo User
    legalName: Demo User Name
    uidNumber: 99998
    gidNumber: 99998
    homeDirectory: /var/empty
    loginShell: /bin/false

Out of the box virtual attributes are disabled (default value *nsslapd-ignore-virtual-attrs: on*):

  - Check the #workers threads: dsconf localhost config get nsslapd-threadnumber
  - Check that 'dsconf localhost config get nsslapd-ignore-virtual-attrs' returns *on*
  - Run the following commands: searchrate -h localhost -p 389 --bindDN "cn=directory manager" --bindPassword ... --baseDN "dc=example,dc=com" --scope sub --filter "(&(uidNumber=\*)(gidNumber=99998)(displayName=Demo User)(legalName=Demo User Name)(homeDirectory=\*)(cn=Demo User))"  --numThreads *<number workers>*

Enable support of virtual attribute

  - Check the #workers threads: dsconf localhost config get nsslapd-threadnumber
  - Check that 'dsconf localhost config get nsslapd-ignore-virtual-attrs' returns *on*
  - Run the following commands: searchrate -h localhost -p 389 --bindDN "cn=directory manager" --bindPassword ... --baseDN "dc=example,dc=com" --scope sub --filter "(&(uidNumber=\*)(gidNumber=99998)(displayName=Demo User)(legalName=Demo User Name)(homeDirectory=\*)(cn=Demo User))"  --numThreads *<number workers>*

# Reference
-----------------

https://github.com/389ds/389-ds-base/issues/4678
https://bugzilla.redhat.com/show_bug.cgi?id=1974236

# Author
--------

<tbordaz@redhat.com>
