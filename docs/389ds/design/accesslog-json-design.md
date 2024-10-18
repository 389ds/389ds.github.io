---
title: "Access Log JSON Format Design"
---

# Access Log JSON Format
----------------

Overview
--------

In order to make the access logging more consumable by standard parsing tools there should be an option for writing the log in JSON

JSON Design
------------

    {
        op: (ABANDON, ADD, AUTOBIND, BIND/UNBIND, CLOSE, CMP, CONN, DEL, EXT, MOD, MODRDN, SEARCH, SORT, RESULT, VLV), 
        local_time: <strftime output - customizable>,
        gm_time: <gm time - uses a fixed format of **%FT%TZ**>,
        conn_id: ####,
        op_id: ####,
        internal_op_id: ####,
        internal_op_sub_id: ####,
        client_ip: IP_ADDRESS/local,
        server_ip: IP_ADDRESS//run/slapd-localhost.socket,
        starttls: True/False,
        authzid: DN,
        internal: True/False
        // BIND, UNBIND, AUTOBIND
        bind_dn: DN,
        method: "",
        mech: "",
        version: 2/3,
        // ADD, CMP, MOD, DEL, MODRDN
        target_dn: "", 
        // CONN
        fd: ####,
        slot: ####,
        tls: True/False,
        // SEARCH
        base: DN,
        filter: "",
        scope: ####,
        attrs: [attr, attr,],
        options: "",
        // MODRDN
        newsuperior: DN,
        deleteoldrdn: True/False,
        // VLV & SORT
        sort: [attr, attr,],
        vlv_index: "",
        // ABANDON
        msgid: ####,
        targetop: "",
        // EXT
        oid: "",
        // RESULT
        err: ####,
        nentries: ####,
        optime: ####,
        wtime: ####,
        etime: ####,
        notes: "".
        tag: ####,
        msg: "",
        // Misc/future
        ...,
    },
]
```

All event operations will also include the client & server IP addresses and the bind dn.

Configuration
------------------------

Added a new configuration setting for access logging under **cn=config**

```
nsslapd-accesslog-json-format: default | json | json-pretty
```

For now set this to "default", but in a next major release it should be set to "json" by default.

When switching to a new logging format the current log will be rotated.

You can also customize the "local_time" format using strftime conversion specifications.  The default would be **%FT%TZ**

    nsslapd-accesslog-time-format: {strftime specs}


Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6368>


Author
-----------------------

<mreynolds@redhat.com>

