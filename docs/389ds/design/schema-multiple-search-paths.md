---
title: "Schema with Multiple Search Paths"
---

# Schema with Multiple Search Paths
-----------------------------------

Overview
--------

As ns-slapd has been incorporated into other projects such as FreeIPA, the requirements for schema handling have changed. No longer does slapd provide all the schema for standalone instances, we often draw upon and have schema from other projects included in installations.

However, the model of schema handling still acts like slapd is a standalone system, isolated from other services. This means projects like FreeIPA have to copy in and validate schema in their service. We also see systems like containers where the schema has to become a data-volume rather than just being part of the base layer, adding further complexity to the installation.

We should allow schema to be loaded from a variety of layered paths. This will simplify the access to schema for third party applications, and our upgrade tools greatly.

Use Cases
---------

slapd upgrade will no longer need to copy schema into instance directories as part of the upgrade process.

FreeIPA will be able to simplify their schema management, and store their schema in a shared system directory.

Administrators will be able to more easily distinguish between system and custom schema elements.

Implementation
--------------

slapd will be altered to search the following paths in this order.

    /usr/lib64/dirsrv/schema
    /etc/dirsrv/schema
    /etc/dirsrv/slapd-inst/schema

slapd core schema and external projects can use /usr/lib64/dirsrv/schema for their ldifs. Custom site schema will be placed into /etc/dirsrv/schema, and custom instance schema as well as 99user.ldif will be in /etc/dirsrv/slapd-inst/schema

Question: Should these be overlaid at the file level? (IE 00core.ldif overrides 00core.ldif in another directory?) or at the schema element OID level? The later is somewhat more reliable, but also more work to develop.

Updates and Upgrades
--------------------

No change is necessary on upgrade, as the schema in the instance will still override the contents of the system. Admins may choose to remove the schema in /etc/dirsrv/slapd-inst/schema allowing /usr/lib64/dirsrv/schema to be system managed and primary.

setup-ds.pl will no longer need to copy in or manipulate schema on upgrade as this is part of the rpm.

New installations will take advantage of this new layout immediately.

Dependencies
------------

There are no dependencies for this change.

External Impact
---------------

Minimal external impact, as well known existing schema paths are still relevant and utilised.

Author
------
firstyear@redhat.com


