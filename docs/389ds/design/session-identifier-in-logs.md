---
title: "Support of session identifier in logs"
---


# Support of session identifier in logs

{% include toc.md %}

## Overview
--------

The purpose of this RFE is to support a new control so that the LDAP server can log an identifier defined by the LDAP client.

Let's imagine an application that provides a booking service. A user can request to book resources. The application is servicing multiple users in parallel. Let's the application being implemented in two separated mechanism: checking the rights and updating the impacted entries.

The first mechanism checks the rights of couple user/resource then once completed with a given user/resource it processes another couple. The first mechanism uses an already established/authenticated connection and send a **first set** of LDAP requests like search for the user and the resource, then check membership of the user to the group allowed to get the resource.

The second mechanism updates the impacted entries by a booking of a couple user/resource. The second mechanims uses another already established/authenticated connection and sends a **second set** of LDAP requests like modify users and resource and adding an audit entry.

Looking at the LDAP server logs it is **difficult to correlate** operations from the first set with operations to the second set. While from the application point of view those two sets are related to the **same booking task** (couple user/resource).

The purpose of this RFE is to support the control LDAP_CONTROL_X_SESSION_TRACKING (see [Internet draft](https://datatracker.ietf.org/doc/html/draft-wahl-ldap-session-03)) in a **limited** implementation. The internet draft defines multiple information that can be logged (ip address, hostname, session type, session identifier). For some reasons explained below in the current design, the RFE will **only** log the 'session identifier' 


To retrieve the operations associated with a given identifier, one can 'grep *session_identifier* /var/log/dirsrv/slapd-instance/access'.

## Session identifier in logs Design
------------

### Description of the solution
------------

#### Example of use of the control

The [Internet draft](https://datatracker.ietf.org/doc/html/draft-wahl-ldap-session-03) defines the [control](https://datatracker.ietf.org/doc/html/draft-wahl-ldap-session-03#section-2.1) like

```
    SessionIdentifierControlValue ::= SEQUENCE {
           sessionSourceIp                 LDAPString,
           sessionSourceName               LDAPString,
           formatOID                       LDAPOID,
           sessionTrackingIdentifier       LDAPString
      }
```

For example, the LDAP client a control requesting such string to be added in the log

```
    "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.19=STID_12345"
```

In addition the LDAP client can provide several controls, mostly to track various type of identifiers. A example of multi-control would be

```
    "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.19=STID_12345"
    "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.3=jdoe"
    "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.2=STID_MULTI_54321"
```

#### How it is logged

The session control is logged this way

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931113128 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1 sid="STID_12345"
```

#### Justifications

The known applications that are willing to use this logging ability are around Identity management (389ds replication, Freeipa, sssd, pki, krb5...). The initial needs are related to debug, support and performance monitoring. The size of the information to log is limited and can fit in *sessionTrackingIdentifier*. Because it is limited there is no need to support multiple control. In order to reduce the amount of data to log and the contention it can create, it is better to log a single record (RESULT) and a truncated *sessionTrackingIdentifier*. It is append to the result similarly to the Page Result control.

In short the solution

- it **appends** the identifier to the **RESULT**
- it is logged in access log (buffered)
- it logs a **truncated** (15 chars) of **sessionTrackingIdentifier**
- **sessionTrackingIdentifier** is escaped before printing it. So that not printable char '\r' (i.e. CR 0x13) is displayed '\13'.
- only the last control (**one** control) will be taken into account
- it **does not** log *sessionSourceIp* and *sessionSourceName* as the source ip is logged in connection information.
- it **does not** log of *formatOID*


#### Others alternatives


##### Alternative 1 - full session string / append

This alternative appends the session strings (after keyword '**sid=**') to the RESULT of the operation. The drawback it can be a very long and reduce the readingness of the access logs.

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931113128 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1 sid="15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.19=STID_12345"
```

##### Alternative 2 - full session string / inserted

This alternative insert the session strings in between the operation record and the result record.

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931000000 +0200] conn=2 op=7 SESSION "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.19=STID_12345"
[17/Oct/2024:17:21:51.931000000 +0200] conn=2 op=7 SESSION "15.0.180.201 hostname=my_laptop.example.com 1.3.6.1.4.1.21008.108.63.1.2=STID_MULTI_54321"
[17/Oct/2024:17:21:51.931113028 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1
```

##### Alternative 3 - short session string / append

This alternative appends only the *sessionTrackingIdentifier* (after keyword '**sid=**') to the RESULT of the operation. If *sessionTrackingIdentifier* is short then it does not reduce the readingness of the access logs.

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931113128 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1 sid="STID_12345"
```

##### Alternative 4 - short session string / inserted

This alternative insert the *sessionTrackingIdentifier* strings in between the operation record and the result record.

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931000000 +0200] conn=2 op=7 SESSION "STID_12345"
[17/Oct/2024:17:21:51.931000000 +0200] conn=2 op=7 SESSION "STID_MULTI_54321"
[17/Oct/2024:17:21:51.931113028 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1
```




### Implementation
------------

#### impacted functions

The control LDAP_CONTROL_X_SESSION_TRACKING is registered (init_controls) for all type of operations.

During *get_ldapmessage_controls* (called by each frontend operation), if the control is present (*slapi_control_present*) in an operation and the LDAP client is allowed (see 'Access control') to use such control then it *parse_session_tracking_control*. *parse_session_tracking_control* is a new function that parse the ber (returned by *slapi_control_present*).

*parse_session_tracking_control* extract all the fields of the control. Except *sessionTrackingIdentifier* all fields are ignored. It test that  first 15th chars of *sessionTrackingIdentifier* are printable. Copy them to a string and store the string in the pblock->pb_intop->pb_session_tracking_id. When logging the result (*log_result*) it appends "**sid**=%s" with pblock->pb_intop->pb_session_tracking_id. "**sid**=" stands for **S**ession **ID**entifier.

#### Access control

Because the LDAP client can fill the access log with extra strings, the use of this control is restricted to authenticated users. This is enforced with this acl

```
dn: oid=1.3.6.1.4.1.21008.108.63.1,cn=features,cn=config
objectClass: top
objectClass: directoryServerFeature
oid: 1.3.6.1.4.1.21008.108.63.1
cn: Session Tracking Control
aci: (targetattr != "aci")(version 3.0; acl "Session Tracking Control"; 
 allow (read,search) userdn = "ldap:///all";)
```

#### data structure

To support the control a new string *pb_session_tracking_id* is added to the pblock

```
    typedef struct _slapi_pblock_intop
    {
    ...
    /* For password policy control */
    int pb_pwpolicy_ctrl;

    char *pb_session_tracking_id; /* For session tracking control */ <---- ADDED

    int pb_paged_results_index;  /* stash SLAPI_PAGED_RESULTS_INDEX */
    ...
    } slapi_pblock_intop;
```

## Test
------------------------

### Client application in python

In python it can be tested with

```
   from ldap.controls.sessiontrack import SessionTrackingControl, SESSION_TRACKING_CONTROL_OID
   from  ldap.extop import ExtendedRequest

   st_ctrl = SessionTrackingControl(
      '10.1.2.3'
      'localhost.localdomain',
      SESSION_TRACKING_CONTROL_OID + '.1.2.3.4',
      'debugID 123456'
    )

    extop = ExtendedRequest(requestName = SESSION_TRACKING_CONTROL_OID, requestValue=None)
    (oid_response, res) = topology_st.standalone.extop_s(extop, serverctrls=[st_ctrl])

```

```
[17/Oct/2024:17:21:51.930944766 +0200] conn=2 op=7 SRCH base="dc=example,dc=com" scope=2 filter="(objectClass=*)" attrs="distinguishedName"
[17/Oct/2024:17:21:51.931113128 +0200] conn=2 op=7 RESULT err=0 tag=101 nentries=1 wtime=0.000189515 optime=0.000171470 etime=0.000358345 notes=U,P details="Partially Unindexed Filter,Paged Search" pr_idx=0 pr_cookie=-1 sid="debugID 123456"
```

### Client application in 'C'

TBD

## Configuration
------------------------

None

Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6367>


Author
-----------------------

<tbordaz@redhat.com>

