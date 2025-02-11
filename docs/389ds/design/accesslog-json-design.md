---
title: "Access Log JSON Format Design"
---

# Access Log JSON Format
----------------

{% include toc.md %}

Overview
--------

In order to make the access logging more consumable by standard parsing tools there should be an option for writing the log in JSON

JSON Design
------------

Below shows all the possible JSON keys, but only applicable information will be written depending on the operation that is being logged

    {
        "header": {
            "version": "389-Directory/3.1.1 DEVELOPER BUILD B0000.000.0000"
            "instance": "localhost.localdomain:636 (/etc/dirsrv/slapd-localhost)"
        }
    },
    {
        operation: (
            ABANDON, ADD, AUTOBIND, BIND/UNBIND, COMPARE, CONNECTION, DELETE, DISCONNECT, 
            EXTENDED_OP, MODIFY, MODRDN, SEARCH, SORT, STAT, RESULT, VLV
        ),
        key: < epoch_time - conn_id >   example: 1741510357-1
        local_time: <strftime output - customizable>,
        conn_id: ####,
        op_id: ####,
        haproxied: TRUE/FALSE,
        internal: True/False
        internal_op_id: ####,
        internal_op_nexted_count: ####,
        starttls: True/False,
        authzid: DN,
        oid: "",
        oid_name: "",
        request_controls: [
            {
               oid: "",
               criticality: TRUE/FALSE,
               value: "", // base64 encoded
            },
        ],
        response_controls: [
            {
               oid: "",
               criticality: TRUE/FALSE,
               value: "", // base64 encoded
            },
        ],
        // BIND, UNBIND, AUTOBIND
        bind_dn: DN,
        method: "",
        mech: "",
        version: 2/3,
        // ADD, CMP, MOD, DEL, MODRDN
        target_dn: "", 
        // CONN
        client_ip: IP_ADDRESS/local,
        server_ip: IP_ADDRESS//run/slapd-localhost.socket,
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
        sort_attrs: "attr attr"
        // vlv request
        vlv_req_before_count: ###,
        vlv_req_after_count: ###,
        vlv_req_index: ###,
        vlv_req_content_count: ###,
        vlv_req_value: "",
        vlv_req_value_len: ###,
        vlv_sort_str: ""
        // vlv response
        vlv_res_target_position;
        vlv_res_content_count;
        vlv_res_result;
        // ABANDON
        msgid: ####,
        target_op: "",
        // EXTENDED_OP
        name: "",
        // STAT
        stat_attr: "",
        stat_key; "",
        stat_key_value: "",
        stat_count: ####,
        stat_etime: ####
        // RESULT
        err: ####,
        nentries: ####,
        optime: ####,
        wtime: ####,
        etime: ####,
        csn: "",
        notes: [
            {
                note: "",
                description: "",
                // Notes = U/A
                base_dn: "",
                filter: "",
                scope: ##,
                client_ip: ""
            },
        ],
        tag: ####,
        details: "",
        msg: "",
        pr_idx: ####,
        pr_cookie: ####,
        sid: "",
    },
]
```

The **key** is a unique id for each connection which avoids issues with server restarts where the connection id counter gets reset.  This allows for accurately tracking individual connections.

Most events will have the expected key/values, while the RESULT operations will be very verbose: ip address, bind dn, etc
All event operations will also include things like the client & server IP addresse,the bind dn, etc.

This is up for debate, but I don't think we need all the client info in every log event.  I think it is most useful in just the RESULT event.


Configuration
------------------------

Added a new configuration setting for access logging under **cn=config**

```
nsslapd-accesslog-log-format: default | json | json-pretty
```

For now set this to "default", but in a next major release it should be set to "json" by default.

When switching to a new logging format the current log will be rotated.

You can also customize the "local_time" format using strftime conversion specifications.  The default would be **%FT%TZ**

    nsslapd-accesslog-time-format: {strftime specs}
    
Examples
-----------------------

#### Add

```
    {
      "local_time":"2025-02-10T13:41:53.166697090 -0500",
      "operation":"ADD",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":16,
      "target_dn":"uid=user1,dc=example,dc=com"
    }
    {
      "local_time":"2025-02-10T13:41:53.267737397 -0500",
      "operation":"RESULT",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":16,
      "msg":"",
      "tag":105,
      "err":0,
      "nentries":0,
      "wtime":"0.000164202",
      "optime":"0.101043160",
      "etime":"0.101204241"
    }
```

### Autobind (LDAPI)

```
    {
      "local_time":"2025-02-10T14:49:41.756271768 -0500",
      "operation":"AUTOBIND",
      "key":"1739216981-1",
      "conn_id":1,
      "bind_dn":"cn=dm"
    }
    {
      "local_time":"2025-02-10T14:49:41.756275809 -0500",
      "operation":"BIND",
      "key":"1739216981-1",
      "conn_id":1,
      "op_id":0,
      "bind_dn":"cn=dm",
      "version":3,
      "method":"sasl",
      "mech":"EXTERNAL"
    }
```


### Bind

```
    {
      "local_time":"2025-02-10T13:49:28.425317898 -0500",
      "operation":"BIND",
      "key":"1739213368-1",
      "conn_id":1,
      "op_id":0,
      "bind_dn":"cn=Directory Manager",
      "version":3,
      "method":"128"
    }
    {
      "local_time":"2025-02-10T13:49:28.503395725 -0500",
      "operation":"RESULT",
      "key":"1739213368-1",
      "conn_id":1,
      "op_id":0,
      "msg":"SASL bind in progress",
      "tag":97,
      "err":0,
      "nentries":0,
      "wtime":"0.000130401",
      "optime":"0.078189513",
      "etime":"0.078315869",
      "bind_dn":"cn=directory manager"
    }
```

### Compare

```
    {
      "local_time":"2025-02-10T15:36:02.741595668 -0500",
      "operation":"COMPARE",
      "key":"1739219762-1",
      "conn_id":1,
      "op_id":6,
      "target_dn":"cn=test_compare,dc=example,dc=com",
      "cmp_attr":"sn"
    }
```

### Connection new

```
    {
      "local_time":"2025-02-10T13:49:28.202404005 -0500",
      "operation":"CONNECTION",
      "key":"1739213368-1",
      "conn_id":1,
      "fd":64,
      "slot":64,
      "tls":false,
      "client_ip":"fe80::91bb:dde8:a08f:ca53%enp34s0u2u1u2",
      "server_ip":"fe80::91bb:dde8:a08f:ca53%enp34s0u2u1u2"
    }
```

### Connection closure

```
    {
      "local_time":"2025-02-10T13:41:53.938965352 -0500",
      "operation":"DISCONNECT",
      "key":"1739212909-1",
      "conn_id":1,
      "fd":64,
      "close_error":"Operation canceled",
      "close_reason":"Connection aborted - A1"
    }
```

### Delete

```
    {
      "local_time":"2025-02-10T13:41:53.815742878 -0500",
      "operation":"DELETE",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":25,
      "target_dn":"cn=user1,dc=example,dc=com"
    }
```


### Extended operation

```
    {
      "local_time":"2025-02-10T14:07:49.302655872 -0500",
      "operation":"EXTENDED_OP",
      "key":"1739214464-4",
      "conn_id":4,
      "op_id":5,
      "oid":"2.16.840.1.113730.3.5.12",
      "oid_name":"REPL_START_NSDS90_REPLICATION_REQUEST_OID",
      "name":"replication-multisupplier-extop"
    }
```

### Internal operation

```
    {
      "local_time":"2025-02-10T14:49:41.756226376 -0500",
      "operation":"SEARCH",
      "key":"1739216981-1",
      "conn_id":1,
      "op_id":0,
      "internal_op":true,
      "op_internal_id":1,
      "op_internal_nested_count":1,
      "base_dn":"cn=dm",
      "scope":0,
      "filter":"(|(objectclass=*)(objectclass=ldapsubentry))",
    }
    {
      "local_time":"2025-02-10T14:49:41.756257039 -0500",
      "operation":"RESULT",
      "key":"1739216981-1",
      "conn_id":1,
      "op_id":0,
      "internal_op":true,
      "op_internal_id":1,
      "op_internal_nested_count":1,
      "tag":48,
      "err":32,
      "nentries":0,
      "wtime":"0.000034142",
      "optime":"0.000031723",
      "etime":"0.000064934"
    }
```

### Invalid attribute in filter

```
    {
      "local_time":"2025-02-10T15:07:52.222076731 -0500",
      "operation":"SEARCH",
      "key":"1739218070-1",
      "conn_id":1,
      "op_id":8,
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(&(a=a))",
      "attrs":[
        "distinguishedName"
      ]
    } 
    { 
      "local_time":"2025-02-10T15:07:52.237548114 -0500",
      "operation":"RESULT",
      "key":"1739218070-1",
      "conn_id":1,
      "op_id":8,
      "msg":" - Invalid attribute in filter - results may not be complete.",
      "tag":101,
      "err":0,
      "nentries":0,
      "wtime":"0.000147900",
      "optime":"0.015471792",
      "etime":"0.015618144",
      "notes":[
        {
          "note":"F",
          "description":"Filter Element Missing From Schema",
          "filter":"(&(a=a))"
        } 
      ]
    }
```

### Modify

```
    {
      "local_time":"2025-02-10T13:41:53.607838929 -0500",
      "operation":"MODIFY",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":19,
      "target_dn":"uid=user1,dc=example,dc=com"
    }
```

### Modrdn

```
    {
      "local_time":"2025-02-10T13:41:53.780814750 -0500",
      "operation":"MODRDN",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":24,
      "target_dn":"uid=user3,dc=example,dc=com",
      "newrdn":"cn=user3",
      "newsup":"ou=people,dc=example,dc=com",
      "deletoldrdn":true
    }
```

### Paged search & Abandon

```
    {
      "local_time":"2025-02-10T14:29:09.484001308 -0500",
      "operation":"SEARCH",
      "key":"1739215749-4",
      "conn_id":4,
      "op_id":6,
      "request_controls":[
        {
          "oid":"1.2.840.113556.1.4.319",
          "oid_name":"LDAP_CONTROL_PAGEDRESULTS",
          "value":"MAYCAQUEATA=",
          "isCritical":true
        }
      ],
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(uid=test*)",
      "attrs":[
        "distinguishedName",
        "sn"
      ]
    }

    {
      "local_time":"2025-02-10T14:29:09.497639220 -0500",
      "operation":"RESULT",
      "key":"1739215749-4",
      "conn_id":4,
      "op_id":6,
      "request_controls":[
        {
          "oid":"1.2.840.113556.1.4.319",
          "oid_name":"LDAP_CONTROL_PAGEDRESULTS",
          "value":"MAYCAQUEATA=",
          "isCritical":true
        }
      ],
      "response_controls":[
        {
          "oid":"1.2.840.113556.1.4.319",
          "oid_name":"LDAP_CONTROL_PAGEDRESULTS",
          "value":"MAUCAQAEAA==",
          "isCritical":false
        }
      ],
      "tag":101,
      "err":0,
      "nentries":5,
      "wtime":"0.000242003",
      "optime":"0.013638581",
      "etime":"0.013873871",
      "pr_cookie":-1,
      "notes":[
        {
          "note":"U",
          "description":"Partially Unindexed Filter",
          "base_dn":"dc=example,dc=com",
          "filter":"(uid=test*)",
          "scope":2,
          "client_ip":"fe80::91bb:dde8:a08f:ca53%enp34s0u2u1u2"
        },
        {
          "note":"P",
          "description":"Paged Search"
        }
      ]
    }


    {
      "local_time":"2025-02-10T14:30:49.058655885 -0500",
      "operation":"SEARCH",
      "key":"1739215848-11",
      "conn_id":11,
      "op_id":2,
      "request_controls":[
        {
          "oid":"1.2.840.113556.1.4.319",
          "oid_name":"LDAP_CONTROL_PAGEDRESULTS",
          "value":"MAUCAQIEAA==",
          "isCritical":true
        }
      ],
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(uid=test*)",
      "attrs":[
        "distinguishedName",
        "sn"
      ]
    } 
    { 
      "local_time":"2025-02-10T14:30:49.058678527 -0500",
      "operation":"ABANDON",
      "key":"1739215848-11",
      "conn_id":11,
      "op_id":3,
      "etime":"0.0000091731",
      "nentries":0,
      "msgid":3,
      "target_op":"2"
    } 
```

### Persistent search

```
    {
      "local_time":"2025-02-10T14:59:41.807166095 -0500",
      "operation":"SEARCH",
      "key":"1739217581-1",
      "conn_id":1,
      "op_id":5,
      "request_controls":[
        {
          "oid":"2.16.840.1.113730.3.4.3",
          "oid_name":"LDAP_CONTROL_PERSISTENTSEARCH",
          "value":"MAkCAQ8BAQABAQE=",
          "isCritical":true
        }
      ],
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(objectClass=*)",
      "psearch":true,
      "attrs":[
        "*",
        "aci"
      ]
    }
```


### Search

```
    {
      "local_time":"2025-02-10T13:41:53.896201226 -0500",
      "operation":"SEARCH",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":28,
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(uid=scarter)",
      "attrs":[
          "cn",
          "sn"
      ]
    }
    {
      "local_time":"2025-02-10T13:41:53.907432812 -0500",
      "operation":"RESULT",
      "key":"1739212909-1",
      "conn_id":1,
      "op_id":28,
      "msg":"",
      "tag":101,
      "err":0,
      "nentries":1,
      "wtime":"0.000068080",
      "optime":"0.011231946",
      "etime":"0.011299283"
    }
```

### Session tracking

```
    {
      "local_time":"2025-02-10T15:35:57.606347011 -0500",
      "operation":"DELETE",
      "key":"1739219756-1",
      "conn_id":1,
      "op_id":4,
      "request_controls":[
        {
          "oid":"1.3.6.1.4.1.21008.108.63.1",
          "oid_name":"LDAP_CONTROL_X_SESSION_TRACKING",
          "value":"MEkECTEwLjAuMC4xMAQQaG9zdC5leGFtcGxlLmNvbQQfMS4zLjYuMS40LjEuMjEwMDguMTA4LjYzLjEuMTIzNAQJREVMIHNob3J0",
          "isCritical":false
        }
      ],
      "target_dn":"cn=test_del,dc=example,dc=com"
    }
    {
      "local_time":"2025-02-10T15:35:57.642974196 -0500",
      "operation":"RESULT",
      "key":"1739219756-1",
      "conn_id":1,
      "op_id":4,
      "msg":"",
      "request_controls":[
        {
          "oid":"1.3.6.1.4.1.21008.108.63.1",
          "oid_name":"LDAP_CONTROL_X_SESSION_TRACKING",
          "value":"MEkECTEwLjAuMC4xMAQQaG9zdC5leGFtcGxlLmNvbQQfMS4zLjYuMS40LjEuMjEwMDguMTA4LjYzLjEuMTIzNAQJREVMIHNob3J0",
          "isCritical":false
        }
      ],
      "tag":107,
      "err":0,
      "nentries":0,
      "wtime":"0.000092637",
      "optime":"0.036631771",
      "etime":"0.036723021",
      "sid":"DEL short"
    }
```


### Stat

```
{
  "local_time":"2025-02-10T20:02:26.064632525 -0500",
  "operation":"SEARCH",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "base_dn":"dc=example,dc=com",
  "scope":2,
  "filter":"(cn=user_*)"
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_attr":"ancestorid",
  "stat_key":"eq",
  "stat_key_value":"1",
  "stat_count":33
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_attr":"cn",
  "stat_key":"sub",
  "stat_key_value":"er_",
  "stat_count":24
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_attr":"cn",
  "stat_key":"sub",
  "stat_key_value":"ser",
  "stat_count":25
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_attr":"cn",
  "stat_key":"sub",
  "stat_key_value":"use",
  "stat_count":25
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_attr":"cn",
  "stat_key":"sub",
  "stat_key_value":"^us",
  "stat_count":24
}
{
  "local_time":"2025-02-10T20:02:26.076247475 -0500",
  "operation":"STAT",
  "key":"1739235742-1",
  "conn_id":1,
  "op_id":70,
  "stat_etime":"0.000030363"
}
{
  "local_time":"2025-02-10T20:07:55.569485252 -0500",
  "operation":"RESULT",
  "key":"1739236071-1",
  "conn_id":1,
  "op_id":70,
  "msg":"",
  "tag":101,
  "err":0,
  "nentries":24,
  "wtime":"0.000064752",
  "optime":"0.011642837",
  "etime":"0.011706772"
}
```

### Unbind

```
    {
      "local_time":"2025-02-10T14:49:42.265373670 -0500",
      "operation":"UNBIND",
      "key":"1739216981-1",
      "conn_id":1,
      "op_id":3
    }
```

#### Unindexed search

```
    {
      "local_time":"2025-02-10T13:49:32.533097842 -0500",
      "operation":"SEARCH",
      "key":"1739213372-1",
      "conn_id":1,
      "op_id":2,
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(&(|(objectClass=nsAccount)(objectClass=nsPerson)(objectClass=simpleSecurityObject)(objectClass=organization)(objectClass=person)(objectClass=account)(objectClass=organizationalUnit)(objectClass=netscapeServer)(objectClass=domain)(objectClass=posixAccount)(objectClass=shadowAccount)(objectClass=posixGroup)(objectClass=mailRecipient))(uid=test*))",
      "attrs":[
        "distinguishedName"
      ]
    }
    {
      "local_time":"2025-02-10T13:49:32.912528455 -0500",
      "operation":"RESULT",
      "key":"1739213372-1",
      "conn_id":1,
      "op_id":2,
      "msg":"",
      "tag":101,
      "err":0,
      "nentries":11000,
      "wtime":"0.000254256",
      "optime":"0.379430934",
      "etime":"3.379682490",
      "notes":[
        {
          "note":"A",
          "description":"Fully Unindexed Filter",
          "base_dn":"dc=example,dc=com",
          "filter":"(&(|(objectClass=nsAccount)(objectClass=nsPerson)(objectClass=simpleSecurityObject)(objectClass=organization)(objectClass=person)(objectClass=account)(objectClass=organizationalUnit)(objectClass=netscapeServer)(objectClass=domain)(objectClass=posixAccount)(objectClass=shadowAccount)(objectClass=posixGroup)(objectClass=mailRecipient))(uid=test*))",
          "scope":2,
          "client_ip":"fe80::91bb:dde8:a08f:ca53%enp34s0u2u1u2"
        }
      ]
    }
```


### VLV search

```
    {
      "local_time":"2025-02-10T14:07:43.042968887 -0500",
      "operation":"SEARCH",
      "key":"1739214462-2",
      "conn_id":2,
      "op_id":2,
      "request_controls":[
        {
          "oid":"2.16.840.1.113730.3.4.9",
          "oid_name":"LDAP_CONTROL_VLVREQUEST",
          "value":"MA8CAQECAQOgBwICDa0CAQA=",
          "isCritical":true
        },
        {
          "oid":"1.2.840.113556.1.4.473",
          "oid_name":"LDAP_CONTROL_SORTREQUEST",
          "value":"MAYwBAQCY24=",
          "isCritical":true
        }
      ],
      "base_dn":"dc=example,dc=com",
      "scope":2,
      "filter":"(uid=*)",
    }
    {
      "local_time":"2025-02-10T14:07:43.055461161 -0500",
      "operation":"SORT",
      "key":"1739214462-2",
      "conn_id":2,
      "op_id":2,
      "request_controls":[
        {
          "oid":"2.16.840.1.113730.3.4.9",
          "oid_name":"LDAP_CONTROL_VLVREQUEST",
          "value":"MA8CAQECAQOgBwICDa0CAQA=",
          "isCritical":true
        },
        {
          "oid":"1.2.840.113556.1.4.473",
          "oid_name":"LDAP_CONTROL_SORTREQUEST",
          "value":"MAYwBAQCY24=",
          "isCritical":true
        }
      ],
      "sort_attrs":"SORT cn "
    }
    {
      "local_time":"2025-02-10T14:07:43.067672510 -0500",
      "operation":"VLV",
      "key":"1739214462-2",
      "conn_id":2,
      "op_id":2,
      "request_controls":[
        {
          "oid":"2.16.840.1.113730.3.4.9",
          "oid_name":"LDAP_CONTROL_VLVREQUEST",
          "value":"MA8CAQECAQOgBwICDa0CAQA=",
          "isCritical":true
        },
        {
          "oid":"1.2.840.113556.1.4.473",
          "oid_name":"LDAP_CONTROL_SORTREQUEST",
          "value":"MAYwBAQCY24=",
          "isCritical":true
        }
      ],
      "response_controls":[
        {
          "oid":"1.2.840.113556.1.4.474",
          "oid_name":"LDAP_CONTROL_SORTRESPONSE",
          "value":"MIQAAAADCgEA",
          "isCritical":true
        },
        {
          "oid":"2.16.840.1.113730.3.4.10",
          "oid_name":"LDAP_CONTROL_VLVRESPONSE",
          "value":"MIQAAAALAgINrQICE4kKAQA=",
          "isCritical":true
        }
      ],
      "vlv_request":{
        "request_before_count":1,
        "request_after_count":3,
        "request_index":3500,
        "request_content_count":0,
        "request_value_len":0,
        "request_sort":"SORT cn "
      },
      "vlv_response":{
        "response_target_position":3501,
        "response_content_count":5001,
        "response_result":0
      }
    }
    {
      "local_time":"2025-02-10T14:07:43.074158709 -0500",
      "operation":"RESULT",
      "key":"1739214462-2",
      "conn_id":2,
      "op_id":2,
      "msg":"",
      "request_controls":[
        {
          "oid":"2.16.840.1.113730.3.4.9",
          "oid_name":"LDAP_CONTROL_VLVREQUEST",
          "value":"MA8CAQECAQOgBwICDa0CAQA=",
          "isCritical":true
        },
        {
          "oid":"1.2.840.113556.1.4.473",
          "oid_name":"LDAP_CONTROL_SORTREQUEST",
          "value":"MAYwBAQCY24=",
          "isCritical":true
        }
      ],
      "response_controls":[
        {
          "oid":"1.2.840.113556.1.4.474",
          "oid_name":"LDAP_CONTROL_SORTRESPONSE",
          "value":"MIQAAAADCgEA",
          "isCritical":true
        },
        {
          "oid":"2.16.840.1.113730.3.4.10",
          "oid_name":"LDAP_CONTROL_VLVRESPONSE",
          "value":"MIQAAAALAgINrQICE4kKAQA=",
          "isCritical":true
        }
      ],
      "tag":101,
      "err":0,
      "nentries":5,
      "wtime":"0.000168051",
      "optime":"0.031190622",
      "etime":"0.031357876"
    }
```

### Truncated values

Values will and with "..." when they are truncated

```
  "filter":"(&(&(objectClass=account)(objectClass=posixaccount)(objectClass=inetOrgPerson)(objectClass=organizationalPerson))(|(objectClass=tester)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=test)(cn=...",
  
```



Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6368>


Author
-----------------------

<mreynolds@redhat.com>

