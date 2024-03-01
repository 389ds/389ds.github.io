---
title: "MFA Operation Note For Auditing"
---

# MFA Operation Note For Auditing
----------------

Overview
--------

Create a new **notes** for the access log to indicate if a bind was part of a MFA plugin(e.g. OTP plugin). This does require the plugin itself setting this flag as there is no way to detect this in DS.

Use Cases
---------

Have a way to audit more information about the bind operation. Currently it's import to log/audit as much about an authentication event as possible.

Design
------

In the **access log** there will be a new "**notes=**" value:  **M**

    notes=M details="Multi-factor Authentication"
    
Example:

```
[01/Mar/2024:16:14:09.226235417 -0500] conn=1 op=0 BIND dn="uid=frank,ou=people,dc=example,dc=com" method=128 version=3
[01/Mar/2024:16:14:09.232745250 -0500] conn=1 op=0 RESULT err=0 tag=97 nentries=0 wtime=0.000111632 optime=0.006612223 etime=0.006722325 notes=M details="Multi-factor Authentication" dn="uid=frank,ou=people,dc=example,dc=com"
```

In the **security log**, there is a new value for the bind method "**SIMPLE/MFA**". Note - in the JSON log the forward slash of this value is escaped

```
{ "date": "[01\/Mar\/2024:16:14:09.232748932 -0500] ", "utc_time": "1709327649.232748932", "event": "BIND_SUCCESS", "dn": "uid=frank,ou=people,dc=example,dc=com", "bind_method": "SIMPLE\/MFA", "root_dn": false, "client_ip": "::1", "server_ip": "::1", "ldap_version": 3, "conn_id": 1, "op_id": 0, "msg": "" }
```

Major configuration options and enablement
------------------------------------------

Only the pre-bind authentication plugin can set this flag using the Slapi API:

    slapi_pblock_set_flag_operation_notes(pb, SLAPI_OP_NOTE_MFA_AUTH);


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/6112>

Author
------

<mreynolds@redhat.com>
