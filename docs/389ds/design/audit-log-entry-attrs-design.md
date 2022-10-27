---
title: "Audit Log Display Entry Attributes"
---

# Audit Log Display Entry Attributes
----------------

Overview
--------

Add a new config settings for the audit/auditfail log that will display specific, or all, attributes from the entry being modified

Use Cases
---------

There are cases where the DN of the entry does not contain useful identifying information about the entry being modified.  Being able to add other attributes from the entry, like **cn**, might be more useful in some cases.  It could also be useful to see the current state of certain attributes in the entry being modified to give a clearer picture about the update and perhaps why its being done.

Design
------

Add a new configuration setting **nsslapd-auditlog-display-attrs** that accepts a space or comma separated list of attributes that should be displayed in the audit log.  This attribute should also accept **"*"** to display all the attributes from the entry.

The unhashed userpassword attribute **unhashed#user#password**, used by winsync, is also automatically blocked from the output.

Implementation
--------------

Any additional requirements or changes discovered during the implementation phase.

Major configuration options and enablement
------------------------------------------

    cn=config
    nsslapd-auditlog-display-attrs: [ATTR ATTR ATTR] | *



Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=2136610>
<https://github.com/389ds/389-ds-base/issues/5502>

Author
------

<mreynolds@redhat.com>

