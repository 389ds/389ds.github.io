---
title: "Security Audit log"
---

Security Audit log
======================================================

## Why
------------------------------------------------------
To properly track issues over time as the normal DS logs can rotate too quickly.  Instead we can have a more specialized/condensed log that will maintain this data for longer since it's not consuming as much disk resources.

The access logs do have all the info this security audit log would maintain, but it requires expensive parsing to get all the info.  As stated above, logs can get rotated very fast, and critical audit information can be lost due to the log rotation/deletion policy.

The security audit log would not be as busy, and would not rotate nearly as fast, allowing for months/years of audit information to be kept without consuming a lot of disk space.

Provide a tool to parse the new security log into useful reports 


## What
-----------------------------------------------------

Track authentication/authorization failures.  The most important attacks are on passwords.  These attacks can come in different forms: brute force and password spraying.

- Brute force is targeting a single user with many bind attempts.  This can be done in bulk or spread over time (to avoid account lockout)
- Password Spraying is where an attacker tries a common password(s) against many entries (to avoid detection/account lock out as well).

Need to check for bursts of failed logins (on any entry), failed binds on a single entry (in bursts or spread out over months).

Discovery/phishing - binds that fail with error 32 (internally) could be someone trying to discover user DN values.  We return error 49 to client, but internally we can detect the error 32 and log a security audit event.

DOS/injection/encoding/maxbersize issues?  Not sure how detectable this would be.

 
## Events
-----------------------------------------------------

### Authentication:

- Track error 49 
- Track error 53 - account lockout?


### Authorization

- Track ACI failures:  err=50
- Cons: Tricky/incomplete coverage.  Only works for mods, not searches :-(
    - Add new access log keyword when results are restricted by ACI?  False positives?  Only add keyword when entire resource is denied?)
    - Is this worth pursuing?


### Injection Attack

- maxbersize
- Other encoding errors?


## Reporting
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
  
    
## Log Format
--------------------------------------------------

### Text format 

Let's *not* do this, or even have this as an config option, but as an exmaple here it is:

    <TIMESTAMP> <EVENT> <IP> <CONN ID> <DN> <MSG>
    
    
    [13/May/2022:14:19:21.828151054 -0400 utc_time=16774847578] event=FAILED_BIND ip=127.0.0.1 conn=2 dn="uid=mark,ou=people,dc=example,dc=com" msg=INVALID_PASSWORD
    [13/May/2022:14:19:22.828151058 -0400 utc_time=16383747834] event=FAILED_BIND ip=127.0.0.1 conn=7 dn="uid=mike,ou=people,dc=example,dc=com" msg=NO_SUCH_ENTRY


### JSON format 

Yes preferred format!

    {
    	date: '', // Human readable
    	utc_time: '', // For easy sorting/reporting
    	event: '',
    	ip: '',
    	conn_id: '',
    	dn: '',
    	msg: ''
    }


    {'date': '13/May/2022:14:19:21.828151054 -0400', 'utc_time': '168485945', 'event': 'FAILED_BIND', dn: 'uid=mark,ou=people,dc=example,dc=com', 'ip': '127.0.0.1', 'conn_id': '2', 'msg': 'INVALID_PASSWORD'}
    {'date': '13/May/2022:14:19:22.828151058 -0400', 'utc_time': '168499999', 'event': 'FAILED_BIND', dn: 'uid=mike,ou=people,dc=example,dc=com', 'ip': '127.0.0.1', 'conn_id': '7', 'msg': 'NO_SUCH_ENTRY'}
        
        
#### Date

Friendly date format

#### UTC time

Convenient time for sorting and building reports
    
#### EVENT

 - authentication FAILED_BIND  --> INVALID_PASSWORD, NO_SUCH_ENTRY, ACCOUNT_LOCKED
 - authorization UNAUTH_ACCESS --> err=50  mod dn=""
 
#### DN

- Bind DN

#### IP

- client IP address

#### MSG

Detailed info.  Failed bind, account lockout, authorization resource DN - what the user tried to modify (mod_dn="") err=50, etc.



## Configuration
-------------------------------------------------------

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



## dsctl security-report

Provide a tool to parse the logs for the customers and generate meaningful reports

### Usage

    --interval UNIT   ***
    
        DAY, WEEK, MONTH, ALL (default is ALL)
        
    --interval-size   ***
    
        The number of UNITs to report on.  (default is 1)
        
    --event EVENT 
    
        BASIC, AUTH, AUTHZ, INJECT, ALL (default is ALL)
        
    --age NUM_OF_DAYS  ***
    
        How far to look into the logs (default is the entire log)
        
    --verbose ?? ***
    
        Override default verbose options?  Use different name.  Do we want this?  Should report always be "verbose"?
        
    *** Open to other naming suggestions


### Report Examples

Each report should general stats like number of failed binds (expired, lockout, invalid password, etc), maxber, etc.  Just get the counts.  Maybe just include this in all events/reports?

Failures:
- FAILED_BIND (err=49) - Bad password
- NO_SUCH_ENTRY (err=49) - The bind DN did not match any entry (discovery attempt?)
- ACCOUNT_LOCKED (err=53?) - Account is locked out



#### AUTH

Stats specific to BINDS.   Bursts, brute force, account lock out.

    Failed Binds (530) (4 users)
    =========================================================
    - [500] uid=mark,ou=people,dc=example,dc=com
        - [490] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - FAILED_BIND
            - 10/10/2022 12:32:21 - conn=12 - FAILED_BIND
            - ...
        - [10] 10.10.10.2
            - 10/10/2022 13:18:21 - conn=23 - FAILED_BIND
            - 10/10/2022 13:18:21 - conn=33 - FAILED_BIND
            - ...
    - [20] uid=sarah,ou=people,dc=example,dc=com
        - [20] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - ACCOUNT_LOCKED (any other info available?)
            - ...
    - [10] uid=mark.reynolds,ou=people,dc=example,dc=com
        - [10] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - NO_SUCH_ENTRY
            - ...


#### Burst Events (password spraying)
    
12:00:00 - 12:59:00: 0
13:00:00 - 13:59:00: 1
14:00:00 - 14:59:00: 0
15:00:00 - 15:59:00: 6
16:00:00 - 16:59:00: 0
17:00:00 - 17:59:00: 245 (2 entries)
    - [240] uid=mark,ou=people,dc=example,dc=com
        - [235] 20.20.20.167
            - 10/10/2022 17:01:21 - conn=1 - FAILED_BIND
            - ...       
        - [5] 20.20.20.167
            - 10/10/2022 17:01:21 - conn=1 - FAILED_BIND
            - ...
    - [5] uid=scott,ou=people,dc=example,dc=com
        - [5] 220.21.21.101
            - 10/10/2022 17:07:21 - conn=41 - NO_SUCH_ENTRY
            - ...
18:00:00 - 18:59:00: 178  (1 entry)
    - [178] uid=mark,ou=people,dc=example,dc=com
        - [178] 20.20.20.167
            - 10/10/2022 18:32:21 - conn=190 - FAILED_BIND
            - ...
            - 10/10/2022 18:32:21 - conn=270 - ACCOUNT LOCKED
          
19:00:00 - 19:59:00: 0
20:00:00 - 20:59:00: 3
21:00:00 - 21:59:00: 0
22:00:00 - 22:59:00: 0
23:00:00 - 23:59:00: 5


#### Slow brute force

Single entry attack that occurs over time.

daily, weekly, monthly?

#### AUTHZ (authorization)

Entries trying to modify (add, mod, delete, modrdn) data that they should not.

    - [3] uid=mark,ou=people,dc=example,dc=com
        - [2] 10.10.10.1
            - 10/10/2022 12:32:21 - conn=1 - MOD dn="uid=admin,ou=privledged users,dc=example,dc=com"
            - 10/10/2022 12:32:21 - conn=12 - DEL dn="cn=customers,ou=groups,dc=example,dc=com"
        - [1] 10.10.10.2
            - 10/10/2022 13:18:21 - conn=23 - MOD dn="cn=service_account,ou=special users,dc=example,dc=com"

#### INJECT (injection/encoding)

- maxbersize, other data corruption

???



## UI

Allow the UI to view the logs, and generate these reports.  Should the UI view the results as text, or in a tree!!!!  Lot of work


