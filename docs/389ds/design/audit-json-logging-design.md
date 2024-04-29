---
title: "Audit JSON Logging Design"
---

# Audit JSON Logging
----------------

Overview
--------

In order to make the audit logging more consumable by standard parsing tool it will written in a JSON format instead of using a partial LDIF format which not LDAP compliant in its current form.

While the old format, after a bit of data massaging, could be replayed using a LDAP client (e.g. ldapmodify), this is most likely not used by most customers.  Instead, customers are looking for actual audit information that can by consumed by well known log parsers.

JSON Design
------------

```
[
    {
        date: <strftime output>
        target_dn: DN,
        bind_dn: DN,
        client: IP_ADDRESS,
        haproxy: IP_ADDRESS,
        conn_id: ####,
        op_id: ####,
        result: ##,
        add: {
            "attr1": [value, value, ...],
            "attr2": [value, value, ...],
        },
        delete: DN,
        modify: [
           {
             op: add/replace/delete,
             attr: "cn",
             value: "name",
           },
        ],
        modrdn: {
            deleteOldRdn: True/False,
            newRdn: "cn=mark",
        }
    },
    {
        ...
    }
]
```

Configuration
------------------------

Add a new configuration setting for audit logging under **cn=config**

```
nsslapd-auditlog-json-format: on/off
```

For now set this to "off", but in a next major release it should be set to "on" by default.

When switching to a new logging format the current log will be rotated

You can also adjust the time format using strftime conversion specifications.  The default would be **%FT%TZ**

    nsslapd-auditlog-time-format: {strftime specs}


Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6115>


Author
-----------------------

<mreynolds@redhat.com>

