---
title: "Filter Syntax Validation"
---

# Filter Syntax Validation
--------------------------

This is the process of verifying that filter components (for example, uid=foo) request
attributes that are present in the current schema of the directory. If these are unknown
we have a number of options to handle these:

* Reject the invalid query
* Allow the query, but invalid components yield empty results, and warn in the access log
* Allow the query, and warn in the access log (risks below)
* No warning (legacy behaviour)

To understand why this is important, we need to understand how Directory Server has
historically handled filters for attributes that were not in the schema in the past.

## Unknown Attributes / Attribute Indexing

When a filter is evaluated, we attempt to load an index for each component. For example:

    (&(uid=foo)(name=bar))

This would attempt to load equality indexes for uid= and name=, and then based on these indexes
these are combined with logical and to create the result set.

If a value is unindexed, this will return "ALLIDS" or an unindexed result. This is especially
bad for performance with OR queries:

    (|(uid=foo)(unknownattr=bar))

The reason this is bad is that if any member of an OR is unindexed, we must treat the full OR as
unindexed, leading to a full table scan. Despite limits in the directory to prevent these,
they are still costly.

When an attribute is not in the schema (such as objects that use extensible object), or the
filter is requesting something that doesn't exist (MS AD attributes against FreeIPA), then
the queries have no choice but to become "unindexed". This leads to the following risks:

* Entry cache eviction for legitimate resources
* Potentially cause a denial-of-service to the server by consuming query resources.
* Create inconsistent query behaviours based on directory size (small directory will yield results, larger ones may hit limits and error silently).
* Give the "illusion" that a malformed query is working "as intended"

## Validation

To reduce the risk of these attacks, the LDAP RFC 4511 section 4.5.1.7 states:

    A filter item evaluates to Undefined when the server would not be
    able to determine whether the assertion value matches an entry.
    ...
    For example, if a server did not recognize the attribute type
    shoeSize, the filters (shoeSize=*), (shoeSize=12), (shoeSize>=12),
    and (shoeSize<=12) would each evaluate to Undefined.

    A server MUST evaluate filters according to the three-valued logic of
    [X.511] (1993), Clause 7.8.1.  In summary, a filter is evaluated to
    TRUE", "FALSE", or "Undefined".  
    ...
    If the filter evaluates to FALSE or Undefined, then the entry is ignored for the Search.

In technical terms for 389 Directory Server's indexing subsystem, this means that filter
components should become idl_alloc(0) if the attribute is NOT found in the cn=schema
partition.

## Configuration Settings

This feature defines a single configartion value:

    dn: cn=config
    nsslapd-verify-filter-schema: [off,warn,warn-strict,strict]

* reject-invalid: reject the filter with an error if any unknown elements exist.
* process-safe: replace unknown components with idl_alloc(0), and log a warning with notes=F
* warn-invalid: log a warning with notes=F, and continue with full table scan (not recommended)
* off: do not verify filters, proceed with full table scan (not recommended)

## Security Notes

process-safe, and reject-invalid are the "only" two secure settings. Setting this value to warn-invalid or off
may expose you to trivially exploitable denial of service attacks unless you have tuned your
directory to reject full table scans for large searches.

It may also expose you to scaling issues where queries that appear to work in test environments
will fail once you have a number of entries greater than the lookthrough limit in the directory.

If you set warn-invalid or off, it is recommended you also set:

    dn: cn=config,cn=ldbm database,cn=plugins,cn=config
    nsslapd-lookthroughlimit: 16

This will allow some smaller partially unindexed queries to continue, but will reject large
fulltable scans to prevent denial of service.

## Known issue

In version 1.4.1 the configuration option shipped only as:

    nsslapd-verify-filter-schema: [off,warn,strict]

Where "warn" behaved as "process-safe".

