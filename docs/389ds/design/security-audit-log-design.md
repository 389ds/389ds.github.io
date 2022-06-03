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

Provide a tool to parse the new security log into useful reports ?


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

Other "high profile" accounts, how to specify them (multi-valued config attribute?)

### Authorization

- Track ACI failures:  err=50
- Cons: Tricky/incomplete coverage.  Only works for mods, not searches :-(
    - Add new access log keyword when search results are restricted by ACI?  False positives?  Only add keyword when **entire** resource is denied?)
    - Log event when checking filter access, but when if denying filter access expected or malicious?
    - Is this worth pursuing?


### TCP Attack

B1-B3 conn codes

- maxbersize
- Crafted packets
- Data corruption



## Reporting (or not)
--------------------------------------------------------------

- New tool, or part of dsctl, to parse the security log to highlight potential issues
- Track brute force attacks (fast and slow)
    - Be able to find patterns over time, is someone slowly trying to brute force attack someones password (a few attempts per day over time)
- Do weekly/monthly/yearly audits
- Report on entries with the most bind failures
- Failure frequency/regularity - alert when pattern is found
    - check if password fails every day/week/month.  Not just volume but frequency
- General stats
    - Report total "EVENT_TYPE"
- CSV reports a must
- **Or, do we let something like "Splunk" handle most of the reporting needs ???**
  
    
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
        high_profile: true/false, // Include root_dn here?
        msg: ''
    }


    {'date': '13/May/2022:14:19:21.828151054 -0400', 'utc_time': '168485945', 'event': 'FAILED_BIND', 'dn': 'uid=mark,ou=people,dc=example,dc=com', 'bind_method': 'SIMPLE', 'root_dn': 'false', 'high_profile': 'false', 'client_ip': '127.0.0.1', 'server_ip': '127.0.0.1', 'conn_id': '2', 'op_id': '1', 'msg': 'INVALID_PASSWORD'}
    {'date': '13/May/2022:14:19:22.828151058 -0400', 'utc_time': '168499999', 'event': 'FAILED_BIND', 'dn': 'uid=mike,ou=people,dc=example,dc=com', 'bind_method': 'SIMPLE', 'root_dn': 'false', 'high_profile': 'false', 'client_ip': '127.0.0.1', 'server_ip': '127.0.0.1', 'conn_id': '7', 'op_id': '1', 'msg': 'NO_SUCH_ENTRY'}


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

#### High Profile

- If the targeted DN is on a "high profile" list (system admins, Root DN, etc) then flag it as so.

#### MSG

- Detailed info.  Failed bind, account lockout, authorization resource DN - what the user tried to modify (mod_dn="") err=50, etc.


## Configuration

Just like any other DS log

    nsslapd-securitylog: /var/log/dirsrv/slapd-localhost/security
    nsslapd-securitylog-logging-enabled: on
    nsslapd-securitylog-compress: off
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
    nsslapd-securitylog-level: 1
    nsslapd-securitylog-high-profile-dn: <DN>
    nsslapd-securitylog-high-profile-dn: <DN2>
    

### Logging Levels

By default the security log will only log failures or specific events.  For completeness it could be beneficial to record successful binds.  Since this would add much more content to the log it will only be written if a specific log level is selected.

The default level is "1" and it will only record security events.  Level "2" will also include successful binds in the security log.


## CLI security-report ?


**After talking with William, he suggested we let tooling like Splunk handle the reporting, so perhaps we can just provide a simple report based on generic stats of the security log, like logconv.pl ???  If we want to do it all ourselves then we can do reports like the ones below...**

Add this to dsctl or a new tool?  Maybe a new log tool for security and access log (logconv.pl replacement) to parse the logs for the customers and generate meaningful reports.

### Usage

Provide options so we can do checks on, what type of vents to check (--event=AUTH), how what events happened in the last 45 days (--age=45).  Or I want reports at certain intervals.  Give me a report for each week for the last 90 days (--interval=WEEK --age=90).  Or give me a weekly report for the last ten weeks (--interval=WEEK --interval-size=10).

    --interval UNIT   ***
    
        DAY, WEEK, MONTH, ALL (default is ALL the log)

    --interval-size   ***
    
        The number of UNITs to report on.  (default is 1)

    --event EVENT 
    
        BASIC, AUTH, AUTHZ, TCP, ALL (default is ALL)

    --age NUM_OF_DAYS  ***
    
        How far to look into the logs (default is the entire log)

    --start-date

        Date to start parsing the log

    --end-date

        Date to stop parsing

    --verbose ?? ***

        Override default verbose options?  Use different name.  Do we want this?  Shouldn't report always be "verbose"?

    *** Open to other naming suggestions



### Report Examples

Each report should general stats like number of failed binds (expired, lockout, invalid password, etc), maxbersize, etc.  Just get the counts.  Maybe just include this in all events/reports?

Failures:
- FAILED_BIND (err=49) - Bad password
- NO_SUCH_ENTRY (err=49) - The bind DN did not match any entry (discovery attempt?)
- ACCOUNT_LOCKED (err=19) - Account is locked out (pwp policy issue)


#### AUTH

Stats specific to BINDS.   Bursts, brute force, account lock out.

    Failed Binds (530) (4 users)
    =========================================================
    - [500] uid=mark,ou=people,dc=example,dc=com
        - [490] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - op=1 - method=simple - FAILED_BIND
            - 10/10/2022 12:32:21 - conn=12 - op=1 - method=simple - FAILED_BIND
            - ...
        - [10] 10.10.10.2
            - 10/10/2022 13:18:21 - conn=23 - op=1 - method=simple - FAILED_BIND
            - 10/10/2022 13:18:21 - conn=33 - op=1 - method=simple - FAILED_BIND
            - ...
    - [20] uid=jamie,ou=people,dc=example,dc=com
        - [20] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - op=1 - method=simple - ACCOUNT_LOCKED (any other info available?)
            - ...
    - [10] uid=mark.reynolds,ou=people,dc=example,dc=com
        - [10] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - op=1 - method=simple - NO_SUCH_ENTRY
            - ...


#### Burst Events (password spraying)

```
12:00:00 - 12:59:00: 0
13:00:00 - 13:59:00: 1
14:00:00 - 14:59:00: 0
15:00:00 - 15:59:00: 6
16:00:00 - 16:59:00: 0
17:00:00 - 17:59:00: 245 (245 entries)
    - [1] uid=mark,ou=people,dc=example,dc=com
        - [1] 20.20.20.167
            - 10/10/2022 17:01:21 - conn=1 - op=1 - method=simple - FAILED_BIND
    - [1] uid=thierry,ou=people,dc=example,dc=com
        - [1] 220.21.21.101
            - 10/10/2022 17:07:21 - conn=41 - op=1 - method=simple - FAILED_BIND
    - [1] uid=simon,ou=people,dc=example,dc=com
        - [1] 220.21.21.101
            - 10/10/2022 17:07:21 - conn=341 - op=1 - method=simple - FAILED_BIND
    ...
    ...
    ...
18:00:00 - 18:59:00: 178  (1 entry)
    - [178] uid=pierre,ou=people,dc=example,dc=com
        - [178] 20.20.20.167
            - 10/10/2022 18:32:21 - conn=190 - op=1 - method=simple - FAILED_BIND
            - ...
            - 10/10/2022 18:32:21 - conn=270 - op=1 - method=simple - ACCOUNT LOCKED
            - 10/10/2022 18:32:22 - conn=271 - op=1 - method=simple - ACCOUNT LOCKED
19:00:00 - 19:59:00: 0
20:00:00 - 20:59:00: 3
21:00:00 - 21:59:00: 0
22:00:00 - 22:59:00: 0
23:00:00 - 23:59:00: 5
```

#### Discovery Attacks

Trying to bind as entries to discover if that user/DN exists


    Discovery Binds (530)
    =========================================================
    - [1] uid=mark.reynolds,ou=people,dc=example,dc=com
        - [1] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - op=1 - method=simple - NO_SUCH_ENTRY
    - [1] uid=mreynolds,ou=people,dc=example,dc=com
        - [1] 10.10.10.1
            - 10/10/2022 12:32:22 - conn=3 - op=1 - method=simple - NO_SUCH_ENTRY
    - [1] uid=mark reynolds,ou=people,dc=example,dc=com
        - [1] 10.10.10.1
            - 10/10/2022 12:32:23 - conn=4 - op=1 - method=simple - NO_SUCH_ENTRY
    - [1] cn=mark reynolds,ou=people,dc=example,dc=com
        - [1] 10.10.10.1
            - 10/10/2022 12:32:23 - conn=5 - op=1 - method=simple - NO_SUCH_ENTRY


#### Slow brute force

Single entry attack that occurs over time.

daily, weekly, monthly?


#### AUTHZ (authorization)

Entries trying to modify (add, mod, delete, modrdn) data that they should not.

    - [3] uid=mark,ou=people,dc=example,dc=com
        - [2] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - op=1 - MOD dn="uid=admin,ou=privledged users,dc=example,dc=com"
            - 10/10/2022 12:32:21 - conn=12 - op=1 - DEL dn="cn=customers,ou=groups,dc=example,dc=com"
        - [1] 10.10.10.2
            - 10/10/2022 13:18:21 - conn=23 - op=1 - MOD dn="cn=service_account,ou=special users,dc=example,dc=com"


#### TCP Attacks

maxbersize, data corruption, crafted packets, etc

- B1 (SLAPD_DISCONNECT_BAD_BER_TAG)
- B2 (SLAPD_DISCONNECT_BER_TOO_BIG)
- B3 (SLAPD_DISCONNECT_BER_PEEK)

Do the security logging in:  disconnect_server_nomutex_ext()



## UI

Allow the UI to view the logs, and generate these reports?  Should the UI view the results as text, or in a tree (lot of work)!?


