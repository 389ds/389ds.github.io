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
        local_time: <strftime output - customizable>
        gm_time: <gm time - uses a fixed format of **%FT%TZ**>
        target_dn: DN,
        bind_dn: DN,
        client_ip: IP_ADDRESS,
        server_ip: IP_ADDRESS
        conn_id: ####,
        op_id: ####,
        result: ##,
        id_list: [
            {
                attr: value
            },
        }
        add: "objectclass: top/nobjectclass: person\n...",
        delete: {
            dn: DN
        },
        modify: [
            {
                op: add/replace/delete,
                attr: "cn",
                values: [value, value, ...],
            },
        ],
        modrdn: {
            deleteOldRdn: True/False,
            newrdn: "cn=mark",
            newsuperior: "ou=other,dc=example,dc=com"
        }
    },
    {
        ...
    }
]
```

Configuration
------------------------

Added a new configuration setting for audit/auditfail logging under **cn=config**

```
nsslapd-auditlog-json-format: default | json | json-pretty
```

For now set this to "default", but in a next major release it should be set to "json" by default.

When switching to a new logging format the current log will be rotated.

You can also customize the "local_time" format using strftime conversion specifications.  The default would be **%FT%TZ**

    nsslapd-auditlog-time-format: {strftime specs}


Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6115>


Author
-----------------------

<mreynolds@redhat.com>

