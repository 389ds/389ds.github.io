---
title: "Mapping Tree Assembly Rework"
---

# Mapping Tree Assembly Rework
------------------------------

{% include toc.md %}

## Introduction

The mapping tree, is a set of entries that is used to route the content of a query to one or more
backends to satisfy the request. It allows the merging of multiple backends into a coherent view
that simulates a single suffix to a client.

The mapping tree is a hierarchial structure, where suffixes are arranged in a tree to determine which
satisfies a query. For example, given the following we can see which backend would service any
request.


                     ┌───────┐
                     │rootDSE│
                     └───────┘
                         │
         ┌───────────────┼──────────────────┐
         │               │                  │
         ▼               ▼                  ▼
    ┌─────────┐     ┌─────────┐    ┌─────────────────┐
    │cn=schema│     │cn=config│    │dc=example,dc=com│
    └─────────┘     └─────────┘    └─────────────────┘
                                            │
                                            ▼
                              ┌───────────────────────────┐
                              │ou=people,dc=example,dc=com│
                              └───────────────────────────┘

Here, if we queried for "dc=example,dc=com", then this suffix would be serviced by the exact
matching backend *and* the child suffix for ou=people. Given a query to cn=schema, this would be
serviced by the cn=schema backend.

## The Problem

Of course, this design doc only exists due to the existance of a problem in this system. The problem
is how these entries are parsed an assembled. At startup cn=config is searched, and entries that are
mapping tree items are examined. For example:

    dn: cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    objectClass: nsMappingTree
    cn: dc=example,dc=com
    cn: dc\=example\,dc\=com
    nsslapd-state: backend
    nsslapd-backend: userRoot

    dn: cn=ou\3Dpeople\2Cdc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    objectClass: nsMappingTree
    cn: ou=People,dc=example,dc=com
    cn: ou\=People\,dc\=example\,dc\=com
    nsslapd-state: backend
    nsslapd-backend: peopleRoot
    nsslapd-parent-suffix: dc=example,dc=com

This would be the config related to the example as defined above. We can see the mapping tree
entries for both backends, and how they relate.

Internally to 389 these are transformed into struct mt_node's defined in ldap/servers/slapd/mapping_tree.c.
These use a set of pointers indicating their child nodes, sibling nodes, and parent nodes. So for
example, our rootDSE would have a childNode pointing at cn=schema, and cn=schema has a sibling of cn=config,
and cn=config has a sibling of dc=example,dc=com. dc=example,dc=com has a child that is ou=People,dc=example,dc=com.

To build this tree, the rootDSE is created and the cn=config/schema/monitor nodes attached. Then
the cn=config is searched for:

    (&(objectclass=nsMappingTree)(!(nsslapd-parent-suffix=*)))

After this, each node that is found has it's suffix searched to find their children with:

    (&(objectclass=nsMappingTree)(|(nsslapd-parent-suffix="<suffix>")(nsslapd-parent-suffix=<suffix>)))

In our example, because dc=example,dc=com does *not* have a nsslapd-parent-suffix, it is assumed
to be anchored at the rootDSE, and then the subsequent search for nsslapd-parent-suffix=dc=example,dc=com
finds the ou=People,dc=example,dc=com to be attached.

In otherwords, the construction of the tree, is based upon the reverse relationship of the nsslapd-parent-suffix
attribute in cn=config.

This opens a very wide door to mis-configuration, as nsslapd-parent-suffix has no constraint to related
correctly or validly to the suffix that is served by the mapping tree node.

## Some Examples ...

Knowing that the tree is constructed in reverse, we can begin to create examples that break this
logic.

For example, consider this mapping tree entry:

    dn: cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    objectClass: nsMappingTree
    cn: dc=example,dc=com
    nsslapd-state: backend
    nsslapd-backend: userRoot
    nsslapd-parent-suffix: dc=com

In this example, we specify a parent-suffix that does *not* exist. Rather than being directly
attached to the rootDSE, in this case due to the nature of the two cn=config queries, instead
this entry is ignored. The backend silently is never able to be routed to. This has been seen in
production from customer cases and is what initiated this investigation.

Another particularly cursed example is:

    dn: cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    objectClass: nsMappingTree
    cn: dc=example,dc=com
    nsslapd-state: backend
    nsslapd-backend: userRoot
    nsslapd-parent-suffix: ou=People,dc=example,dc=com

    dn: cn=ou\3Dpeople\2Cdc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    objectClass: nsMappingTree
    cn: ou=People,dc=example,dc=com
    nsslapd-state: backend
    nsslapd-backend: peopleRoot

In this example, we have a more general suffix *below* the more specific "child" suffix. The end
result is that because the mapping tree assumes a valid and ordered hierarchy, that a query to
dc=example,dc=com can not be routed because the rootDSE connects to ou=People, which is *not* a
subsuffix of dc=example,dc=com.

Any query to ou=People,dc=example,dc=com *also* fails, because the Mapping Tree after routing
to ou=People attempts to see if any descendants are "more specific". But the "more specific" check
is based on is equal OR subsuffix, so the dc=example,dc=com belowe ou=People answers that it is more
specific than ou=People, and it attempts to the serve the query (and yields no results, because all
the ou=People entries are in the suffix above).

## Suggested Resolution

Since the MT today *assumes* that the tree *must* be a correct hierarchy of ordered suffixes, where each
child MUST be a descendant to the parent, then we know that this ordering for existing clients
must exist. There is no valid situation where a "more specific" suffix can exist above a less
specific suffix, or that two equal suffixes can exist.

With this in mind, we can then identify that the issue is that the current creation of the tree
is *inverted* to what it should be. We assemble a tree based on the parent relationship, rather
than determining who are the relevant and correct *child* suffixes.

The proposal is that the server should *ignore* the nsslapd-parent-suffix, and rather should sort
and determine the correct tree relationship from the cn/suffix values that exist.

At startup we would then search for any cn=config entry where objectClass=nsMappingTree. From
this we can then take the first value of cn. We must escape this value, as you can see from the
cn=config, that it may *already* be escaped.


We can then sort the suffixes based on *length* with the shortest first. This would give us for
example:

    dc=example,dc=com
    ou=People,dc=example,dc=com

Next we check there are no duplicate suffixes (we don't do this today, but they would be invalid,
today we would select one or the other, we can not have a query satisfied by multiple backends).

At this point we can then repeatedly call best_matching_child(). This works because on the first
insert, no parent to dc=example,dc=com, so this would return that the best match is the rootDSE. We
can then add the rootDSE to the tree.

When we call best_matching_child() next with ou=People,dc=example,dc=com, this would find the
best match is dc=example,dc=com, so we would then attach this as the parent node.

Because we sorted the names of the suffixes by length, we know that parent DN's are shorter
and would be first in the set.

An important test would be around the handling of cn as the suffix given the escaping, where we have
escaped, and unescaped cn's in the test.

Also testing duplicate suffix detection, and that parent-suffix is ignored (IE we can load invalid
parent suffix configs).

