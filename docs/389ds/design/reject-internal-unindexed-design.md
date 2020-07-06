---
title: "Reject Internal Unindexed Searches"
---

# Reject Internal Unindexed Searches
----------------

Overview
--------

Previously there was no way to prevent internal unindexed searches.  There was a setting called "nsslapd-require-index" that could be set for a backend, but this explicitly ignored *internal* unindexed searches.  While typically we don't want plugins to issue unindexed search, we still want plugins to do their tasks so it was allowed.   The problem is that on large databases when a plugin that is already doing a modify (so it already has a write lock on the database), and then it does an unindexed search it can consume all the database locks (libdb locks).  This can actually corrupt the database, or hang the server.  In cases like these we would want to reject internal unindexed searches until the "indexing" issue can be resolved.

Design
------

Added a new configuration setting **nsslapd-require-internalop-index** that be turned on and off (default is "off").  We also log in the errors log the search details that caused the unindexed search so it can be investigated and resolved.  Here is an example of the new option:

    cn=userroot,cn=ldbm database,cn=plugins,cn=config
    ...
    nsslapd-require-internalop-index: on
    

Origin
-------------

<https://pagure.io/389-ds-base/issue/51192>

Author
------

<mreynolds@redhat.com>
