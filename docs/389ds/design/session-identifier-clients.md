---
title: "Replication using session identifier"
---


# Replication using session identifier

{% include toc.md %}

## Overview
--------

The purpose of this RFE is that replication agreements logs debug messages with a **session tracking identifier** and provide to the consumer the same identifier along with each request it is sending. The consumer will log the provided identifier in the access log (see [server support](https://www.port389.org/docs/389ds/design/session-identifier-in-logs.html) of session identifier).

Replication is a complexe component that makes diagnostic difficult. The goal of the RFE is to reduce complexity of the diagnostic of replication agreements that are responsible to run the supplier side of the replication protocol.

A replication agreement replicates updates from a supplier LDAP instance to a consumer LDAP instance. A replication topology usually contains several suppliers and multiple replicated backends. So the access logs of a consumer typically contains multiple requests all mixed together from multiple suppliers and for multiple backends. This is exactly the same mix of debug logs on the supplier error logs. It is time consuming and difficult (sometime even not possible) to correlate requests in consumer access logs with replication agreements debug logs in the supplier error logs.


To retrieve the operations associated with a given identifier, one can 

- 'grep *session_identifier* /var/log/dirsrv/slapd-consumer/access'
- 'grep *session_identifier* /var/logs/dirsrv/slapd-supplier/errors'

## Design
------------

### Description of the solution
------------

The **session tracking identifier** must be unique. It is sent using control LDAP_CONTROL_X_SESSION_TRACKING (see [Internet draft](https://datatracker.ietf.org/doc/html/draft-wahl-ldap-session-03)). The goal is that the admin, using '/usr/bin/grep <session_id> <log_file>', gets a complete view on the both side (supplier and consumer).

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

389-DS [implementation](https://www.port389.org/docs/389ds/design/session-identifier-in-logs.html) logs **only** *sessionTrackingIdentifier*.  So the client should only set this field in the control.


#### How it is logged

On the client side (supplier) the session identifier is logged in error logs, when the replication debug level is enabled

```
[17/Apr/2025:16:16:12.717536265 +0200] - DEBUG - NSMMReplicationPlugin - repl5_inc_run - "EWBpte8J8Wx   2" - agmt="cn=004" (localhost:39004): State: wait_for_changes -> ready_to_acquire_replica

```

The session identifier is a string of 15 chars. The string contains two fields separated by a blank (' '). The first field is 11 characters. It contains the header of a base 64 encoded value. The second field is a counter [1,999] that identify the number of the opened replication connection. In the above example it is 


```
EWBpte8J8Wx   2
```

#### Session_id string

The string is 15 chars long. 

The First field identifies, in the replicated topology, the supplier host and backend. The initial value is a string "*<replicated_suffix><fqdn_hostname><listen_port><listen_sport>*". This string is hashed (SHA1) then base64 encoded. The final value is the first 11 chars of the b64 string.

The Second field identifier the number of the replication connection from the supplier to the consumer. It ranges from [1,999]. It is reset to 1 when the supplier opens the 1000th connection.




### Implementation
------------

The server side is already [implemented](https://www.port389.org/docs/389ds/design/session-identifier-in-logs.html) so this chapters only details the client side

#### impacted functions

##### initialization

During replication agreement initialization (*agmt_new_from_entry*) (see   [repl5agmt](#data structure))

- *session_tracking_supported* is set to Unknown
  - Unknown: the replication agreement should check if the session tracking control is supported (default value)
  - Disable: the replication agreement checked that the consumer does not support session tracking control
  - Enable: the replication agreement checked that the consumer does not support the session tracking control
- *session_id_prefix* is allocated/initialized
- *session_id_cnt* is initialized .






##### running mode

The supplier code is impacted in two ways

- The supplier sends session identifier (in short, a string) to the consumer so that this one appends the string in the result (access logs) of each replicated operations.
- The supplier logs (error logs) the session identifier in some messages of the replication debugging logs

The supplier sends the control to the consumer within each LDAP operations sent by the replication agreement. Hopefully all these operations are sent by '**perform_operation**' and it is the perfect place to add the session tracking control. This routine uses the '**conn**' parameter that refer to the agreement '**conn->agmt**' where the session tracking value is stored (see [repl5agmt](#data structure)). This routine creates a control (calling *create_sessiontracking_ctrl*) and adds it to the array of controls. Once the operation callback is called (e.g. *ldap_modify_ext*) it frees the control via *ldap_control_free*.

The supplier logs the session identifier in those set of replication debugging messages

- In *repl5_inc_run* to track the RA protocol
- In *replay_update*/*send_updates* to monitor individual update
- ...

##### termination

During replication agreement deletion (*agmt_delete*) *session_id_prefix* is freed (see [repl5agmt](#data structure))

##### Helper

Control.c contains create_sessiontracking_ctrl that creates a session tracking control with *sessionTrackingIdentifier* set with a provided string.

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

To restrict this use, the *userdn* may be replaced with a *groupdn* of all the replication manager accounts.

#### data structure

The session tracking value is stored in the replication agreement itself with 4 new fields

```
    typedef struct repl5agmt
    {
    ...
#define SID_SUPPORT_UNKNOWN 0
#define SID_SUPPORT_NO      1
#define SID_SUPPORT_YES     2
    int session_tracking_supported;        /* does the consumer support the control */
    int session_id_cnt;                    /* use to differentiate connections */
    char *session_id_prefix;               /* use for debugging purpose on server/client sides. Computed once */
#define SESSION_ID_STR_SZ 15
    char session_id[SESSION_ID_STR_SZ + 49];
    ...
    } repl5agmt;
```

*session_tracking_supported* is a flag initialized with SID_SUPPORT_UNKNOWN. When the first replication session occurs it checks if the consumer supports or not the control and set the flag appropriately.

*session_id_cnt* is a counter that range [1,999]. It is incremented up to 999 then reset to 1. It is incremented each time the replication agreement opens a connection to the consumer (*conn_connect_with_bootstrap*).

*session_id_prefix* is a hash that represent a given replication agreement in the all topology. It is computed once when the replication agreement structure is created *agmt_new_from_entry*. It contains the 11 first chars of a base64 encoded value. The value is the result of a SHA-1 hash of the string "*<replicated_suffix><fqdn_hostname><listen_port><listen_sport>*"

*session_id* is the actual *sessionTrackingIdentifier* logged in the **supplier's error** logs and the sent to the consumer (using the *SessiontTrackingControl) to be logged in the **consumer's access** logs. It identifies a connection between the supplier's replication agreement and the consumer.

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

### Using replication

The server side of **session tracking identifier** is available starting in 2.6 and 3.0.

The replication client side is available starting 2.7 and 3.1.

So using 2.7+ (or 3.1+) replication topology, it is suffisant to enable debug replication logs (nsslapd-errorlog-level=8192) to get *session identifier* in both errors/access logs.

## Configuration
------------------------

To enable the session tracking log, the replication debug level must be enabled (nsslapd-errorlog-level=8192).

Origin
-----------------------

[Server side](https://github.com/389ds/389-ds-base/issues/6367) of session tracking

[Client side](https://github.com/389ds/389-ds-base/issues/6755) of session tracking


Author
-----------------------

<tbordaz@redhat.com>

