---
title: "Plugin Ordering"
---

# Plugin Ordering
-----------------

This document describes the design and implementation of a feature to allow Plug-in execution order to be defined.

Background
----------

The current implementation of the SLAPI plug-in interface does not allow the execution order of plug-ins to be defined within the same plug-in type. It would be useful to plug-in developers to be able to define an order for plug-in execution. This would allow for more complex plug-in interaction, such as having a pre-operation plug-in that relies on another pre-operation plug-in completing it's job first.

Design
------

To define plug-in execution order, it will be possible to set a plug-in precedence in a plug-in configuration entry. This precedence value will then be used to determine the order in which to call the plug-ins within a given plug-in type. The precedence will be defined as an integer value between **1-99** with **1** being the highest priority and **99** being the lowest priority. The precedence value will be stored in the **nsslapd-pluginPrecedence** attribute within a plug-in configuration entry. If the precedence attribute is not set for a particular plug-in, the value will default to **50** internally. Here is an example configuration entry:

    dn: cn=ACL Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: ACL Plugin
    nsslapd-pluginPath: libacl-plugin
    nsslapd-pluginInitfunc: acl_init
    nsslapd-pluginType: accesscontrol
    nsslapd-pluginEnabled: on
    nsslapd-plugin-depends-on-type: database
    nsslapd-pluginId: acl
    nsslapd-pluginVersion: 1.2.3
    nsslapd-pluginVendor: 389 Project
    nsslapd-pluginDescription: acl access check plugin
    nsslapd-pluginPrecedence: 50

The precedence of a plug-in will only order plug-ins within the same plug-in type. The available plug-in types are:

-   preoperation
-   postoperation
-   bepreoperation
-   bepostoperation
-   internalpreoperation
-   internalpostoperation
-   extendedop
-   accesscontrol
-   matchingrule
-   syntax
-   object
-   pwdstoragescheme
-   reverpwdstoragescheme
-   vattrsp
-   ldbmentryfetchstore
-   index

It should be noted that the ability to set a precedence doesn't make sense for all of the plug-in types. Some examples of where precedence do not make sense are the syntax, matchingrule, and extendedop plug-in types, since these are implementing callbacks to add support for specific datatypes or operations. The types where precedence is really desirable are for the six preoperation and postoperation plug-in types.

It is important to not confuse plug-in dependencies with plug-in precedence. Dependencies are used to determine plug-in startup and shutdown order, not execution order when they are called to process LDAP operations. The precedence setting will not affect the plug-in startup and shutdown order. Precedence will only be used to define execution order when processing LDAP operations.

Implementation
--------------

The plug-in structures are currently stored in a set of lists, with one list for each plug-in type. The execution order is the same as the list order, so the order can be set properly by adding a plug-in to the list in the proper place based off of the value of the precedence attribute.

### Tasks

-   Add support for the new **nsslapd-pluginPrecedence** attribute to the plug-in code. A new member will need to be added to **struct slapdplugin** for the precedence and we will need to set a default value if the precedence attribute is not present.
-   Modify **add\_plugin\_to\_list()** to insert a **struct slapdplugin \*** into the list based on the precedence value instead of simply adding it to the end of the list.
-   Write 2 simple test plug-ins to test and debug the feature.

