---
title: "Security Audit log"
---

Security Audit log
======================================================

{% include toc.md %}

## Why
------------------------------------------------------
To properly track issues over time as the normal DS logs can rotate too quickly.  Instead we can have a more specialized/condensed log that will maintain this data for longer since it's not consuming as much disk resources.

The access logs do have all the info this security audit log would maintain, but it requires expensive parsing to get all the info.  As stated above, logs can get rotated very fast, and critical audit information can be lost due to the log rotation/deletion policy.

The security audit log would not be as busy, and would not rotate nearly as fast, allowing for months/years of audit information to be kept without consuming a lot of disk space.


## What
-----------------------------------------------------

Track authentication/authorization failures.  The most important attacks are on passwords.  These attacks can come in different forms: brute force and password spraying.

- Brute force is targeting a single user with many bind attempts.  This can be done in bulk or spread over time (to avoid account lockout)
- Password Spraying is where an attacker tries a common password(s) against many entries (to avoid detection/account lock out as well).
- Need to check for bursts of failed logins (on any entry), failed binds on a single entry (in bursts or spread out over months).
- Discovery/phishing - binds that fail with error 32 (internally) could be someone trying to discover user DN values.  We return error 49 to client, but internally we can detect the error 32 and log a security audit event.
- TCP Attacks - DOS/injection/encoding/maxbersize

 
## Events
-----------------------------------------------------

### Authentication:

- Track error 49 
- Track error 19 - account lockout (constraint violation)

Should we track Root DN (cn=directory manager) failed binds differently?  Separate stat/report?

What about replication manager?  Is this easily detectable in code?


### Authorization

- Track ACI failures:  err=50
- Cons: Tricky/incomplete coverage.  Only works for mods, not searches :-(
    - Add new access log keyword when search results are restricted by ACI?  False positives?  Only add keyword when **entire** resource is denied?)
    - Log event when checking filter access, but when if denying filter access expected or malicious?
    - Is this worth pursuing?


### TCP Attack

- maxbersize
- Crafted packets
- Data corruption

- B1 (SLAPD_DISCONNECT_BAD_BER_TAG)
- B2 (SLAPD_DISCONNECT_BER_TOO_BIG)
- B3 (SLAPD_DISCONNECT_BER_PEEK)

Do the security logging in:  disconnect_server_nomutex_ext()
  
    
## Log Format
--------------------------------------------------


    {
        date: '', // Human readable
        utc_time: '', // For easy sorting/reporting
        event: '',
        client_ip: '',
        server_ip: '',
        conn_id: '',
        op_id: '',
        dn: '',
        bind_method: 'SIMPLE, SASL/GSSAPI, SASL/DIGEST-MD5, SSLCLIENTAUTH',
        root_dn: true/false,
        msg: ''
    }


    {'date': '13/May/2022:14:19:21.828151054 -0400', 'utc_time': '168485945', 'event': 'FAILED_BIND', 'dn': 'uid=mark,ou=people,dc=example,dc=com', 'bind_method': 'SIMPLE', 'root_dn': 'false', 'client_ip': '127.0.0.1', 'server_ip': '127.0.0.1', 'conn_id': '2', 'op_id': '1', 'msg': 'INVALID_PASSWORD'}
    {'date': '13/May/2022:14:19:22.828151058 -0400', 'utc_time': '168499999', 'event': 'FAILED_BIND', 'dn': 'uid=mike,ou=people,dc=example,dc=com', 'bind_method': 'SIMPLE', 'root_dn': 'false', 'client_ip': '127.0.0.1', 'server_ip': '127.0.0.1', 'conn_id': '7', 'op_id': '1', 'msg': 'NO_SUCH_ENTRY'}


#### Date

- Friendly date format


#### UTC time

- Convenient time for sorting and building reports


#### EVENT

- authentication FAILED_BIND  --> INVALID_PASSWORD, NO_SUCH_ENTRY, ACCOUNT_LOCKED
- authorization UNAUTH_ACCESS --> err=50  mod dn=""
- tcp attack TCP_ERROR --> closed connection codes:  B1, B2, B3

 
#### DN

- Bind DN

#### Bind Method

- The bind method used: SIMPLE, SASL/GSSAPI, SASL/DIGEST-MD5, SSLCLIENTAUTH

#### IP

- client IP address
- server IP address

#### Conn & Op ID's

- The connection and operation ID's

#### MSG

- Detailed info.  Failed bind, account lockout, authorization resource DN - what the user tried to modify (mod_dn="") err=50, etc.


## Configuration

Just like any other DS log

    nsslapd-securitylog: /var/log/dirsrv/slapd-localhost/security
    nsslapd-securitylog-logging-enabled: on
    nsslapd-securitylog-logexpirationtime: 12
    nsslapd-securitylog-logexpirationtimeunit: month
    nsslapd-securitylog-logmaxdiskspace: 500
    nsslapd-securitylog-logminfreediskspace: 5
    nsslapd-securitylog-logrotationsync-enabled: off
    nsslapd-securitylog-logrotationtime: 1
    nsslapd-securitylog-logrotationtimeunit: month
    nsslapd-securitylog-maxlogsize: 100
    nsslapd-securitylog-maxlogsperdir: 10
    nsslapd-securitylog-mode: 600
    nsslapd-securitylog-logbuffering: on
    nsslapd-securitylog-compress: on


## CLI security-report

We'll let other tooling do the complex parsing (e.g. Splunk).  However, we can still provide a generic report.

Example of basic report we could produce.

    Successful Binds:       ####
    Failed binds:           ####
    Root DN Failed Binds:   ####

    Authentication Events
        Invalid Password:   ####
        Account Locked:     ####
        No Such Entry:      ####

    Authorization Events
        Unauthorized Ops:   ####

    TCP Events
        B1 (BAD_BER_TAG):   ####
        B2 (BER_TOO_BIG):   ####
        B3 (BER_PEEK):      ####


Should we add more information about common IP addresses, or common accounts?  How far down the rabbit hole do we go?

    Top 100 Failed Binds
        uid=mark,ou=people,dc=example,dc=com       179
        cn=directory manager                        89
        ...

    Top 100 Clients
        10.10.10.201              493
          - Failed binds:  400
          - Acount locked: 93

        10.20.10.30               201
          - Failed binds:  150
          - No Such Entry:  51


## UI

Allow the UI to view the logs, and generate these reports?  Should the UI view the results as text, or in a tree (lot of work)!?


