---
title: "Howto: Uid and Attribute Uniqueness"
---

# Introduction
--------------

Within a directory, attributes can have duplicate values in the DIT. However, our world is structured and we need to be able to enforce order and uniqueness on values. Consider email addresses: These must be unique to allow mail to be routed to one and only one recepient.

This is where the uid and attribute uniqueness plugin steps in. It is able to enforce that values of attributes or a set of attributes are unique through the DS.

# Single Attribute Uniqueness
-----------------------------

Single attribute uniqueness will guarantee that a value of an attribute only exists on object in a subtree.

The configuration for cn=config is as such:

    dn: cn=attribute uniqueness,cn=plugins,cn=config
    objectclass: top
    objectclass: nsSlapdPlugin
    objectclass: extensibleObject
    cn: attribute uniqueness
    nsslapd-pluginpath: libattr-unique-plugin
    nsslapd-plugininitfunc: NSUniqueAttr_Init
    nsslapd-plugintype: betxnpreoperation
    nsslapd-pluginenabled: off
    uniqueness-attribute-name: uid
    uniqueness-subtrees: dc=example,dc=com
    uniqueness-across-all-subtrees: off
    nsslapd-plugin-depends-on-type: database


uniqueness-subtrees is a multivalued attribute and can list multiple subtrees for the check. The behaviour of this is determined by altering the value of uniqueness-across-all-subtrees.

If uniqueness-across-all-subtrees is off, only the subtree the object resides in is checked for uniqueness. This means a value attr=X, can exist in multiple subtrees, but will only exist once in it's own subtree.

If uniqueness-across-all-subtrees is on, all subtrees are searched. The value of attr=X can exist only once in the defined subtrees.

The plugin can be defined multiple times, provided each invocation has a unique cn. The behaviour of the plugin if you define uniqueness-attribute-name as having the same value X in multiple plugin invocations is undefined, and will likely cause issues.

# Multi Valued Uniqueness
-------------------------

The value uniqueness-attribute-name can be specified multiple times. Each extra addition is added to be filtered. This can mean that a value X may only exist once in the set of attributes defined. Consider:

    uniqueness-attribute-name: mail
    uniqueness-attribute-name: mailAlternateAddress

If the value of an object containing mail was x@foo.com. The following will happen.

If an operation attempts to add x@foo.com to another object's mail attribute it will be rejected.

If an operation attempts to add x@foo.com to another object's mailAlternateAddress attribute it will be rejected.

This allows sites which have more complex directory systems to enforce that unlinked or unrelated attributes can have uniqueness enforced over the set of attributes to guarantee consistency.



