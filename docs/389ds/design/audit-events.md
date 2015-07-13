---
title: "Audit Events"
---

# Parsable audit events from access logs
----------------------------------------

Overview
--------
A utility is required to parse 389/directory server access logs whose
output is a well defined record (event) of the LDAP request and any resultant
responses. Each event would contain the initiating host address and the
current authenticated DN to make subsequent entity access analysis more efficient.

In essence, generate a single event for every operation (common op=) performed
for a unique connection. The events need to be well formed and consideration
given to further downstream parsing. As the access log records are well
documented, the output event should minimize changes to the content (if changed
at all).

The utility would need to support time based queries. That is, generate events
between a given start and end time. Note that if the connection and
authentication occurs BEFORE the given start time, this detail still needs to
decorate the event output.

The utility would need to indicate if the authenticated DN or initiating
client could not be ascertained. That is, the information is NOT in the
file(s) processed.

Optionally can ignore internal operations.

Use Cases
---------

The following cases show a logfile extract and resultant parsed output.  The
output is in XML. Other well formed and parsable output could be chosen (eg
JSON) - the intent is that downstream capability needs to parse the
information.

#1
Extract:

    [21/Apr/2009:11:39:51 -0700] conn=11 fd=608 slot=608 connection from 207.1.153.57 to 192.18.122.139
    [21/Apr/2009:11:39:51 -0700] conn=11 op=0 BIND dn="cn=Directory Manager" method=128 version=3
    [21/Apr/2009:11:39:51 -0700] conn=11 op=0 RESULT err=0 tag=97 nentries=0 etime=0
    [21/Apr/2009:11:39:51 -0700] conn=11 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(mobile=+1 123 456-7890)"
    [21/Apr/2009:11:39:51 -0700] conn=11 op=1 RESULT err=0 tag=101 nentries=1 etime=3 notes=U
    [21/Apr/2009:11:39:51 -0700] conn=11 op=2 UNBIND
    [21/Apr/2009:11:39:51 -0700] conn=11 op=2 fd=608 closed - U1

Resultant sub-extract and Event output:

    [21/Apr/2009:11:39:51 -0700] conn=11 fd=608 slot=608 connection from 207.1.153.57 to 192.18.122.139
    [21/Apr/2009:11:39:51 -0700] conn=11 op=0 BIND dn="cn=Directory Manager" method=128 version=3
    [21/Apr/2009:11:39:51 -0700] conn=11 op=0 RESULT err=0 tag=97 nentries=0 etime=0
    <Event>
      <DateTime>21/Apr/2009:11:39:51 -0700</DateTime>
      <Client>207.1.153.57</Client>
      <Server>192.18.122.139</Server>
      <Connection>11</Connection>
      <Operation>0</Operation>
      <AuthenticatedDN>cn=Directory Manager</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;cn=Directory Manager&quot; method=128 version=3</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=97 nentries=0 etime=0</Response>
      </Responses>
    </Event>

    [21/Apr/2009:11:39:51 -0700] conn=11 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(mobile=+1 123 456-7890)"
    [21/Apr/2009:11:39:51 -0700] conn=11 op=1 RESULT err=0 tag=101 nentries=1 etime=3 notes=U
    <Event>
      <DateTime>21/Apr/2009:11:39:51 -0700</DateTime>
      <Client>207.1.153.57</Client>
      <Server>192.18.122.139</Server>
      <Connection>11</Connection>
      <Operation>1</Operation>
      <AuthenticatedDN>cn=Directory Manager</AuthenticatedDN>
      <Action>SRCH</Action>
      <Requests>
       <Request>SRCH base=&quot;dc=example,dc=com&quot; scope=2 filter=&quot;(mobile=+1 123 456-7890)&quot;</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=101 nentries=1 etime=3 notes=U</Response>
      </Responses>
    </Event>

    [21/Apr/2009:11:39:51 -0700] conn=11 op=2 UNBIND
    [21/Apr/2009:11:39:51 -0700] conn=11 op=2 fd=608 closed - U1
    <Event>
      <DateTime>21/Apr/2009:11:39:51 -0700</DateTime>
      <Client>207.1.153.57</Client>
      <Server>192.18.122.139</Server>
      <Connection>11</Connection>
      <Operation>2</Operation>
      <AuthenticatedDN>cn=Directory Manager</AuthenticatedDN>
      <Action>UNBIND</Action>
      <Requests>
        <Request>UNBIND</Request>
      </Requests>
      <Responses>
        <Response>fd=608 closed - U1</Response>
      </Responses>
    </Event>

#2
Extract:

    [07/May/2009:11:43:28 -0700] conn=877 fd=608 slot=608 connection from 207.1.153.32 to 192.18.122.139
    [07/May/2009:11:43:28 -0700] conn=877 op=0 BIND dn="cn=Directory Manager" method=128 version=3
    [07/May/2009:11:43:28 -0700] conn=877 op=0 RESULT err=0 tag=97 nentries=0 etime=0
    [07/May/2009:11:43:29 -0700] conn=877 op=1 SRCH base="(ou=People)" scope=2 filter="(uid=*)"
    [07/May/2009:11:43:29 -0700] conn=877 op=1 SORT uid
    [07/May/2009:11:43:29 -0700] conn=877 op=1 VLV 0:5:0210 10:5397 (0)
    [07/May/2009:11:43:29 -0700] conn=877 op=1 RESULT err=0 tag=101 nentries=1 etime=0

Resultant sub-extract and Event output:

    [07/May/2009:11:43:28 -0700] conn=877 fd=608 slot=608 connection from 207.1.153.32 to 192.18.122.139
    [07/May/2009:11:43:28 -0700] conn=877 op=0 BIND dn="cn=Directory Manager" method=128 version=3
    [07/May/2009:11:43:28 -0700] conn=877 op=0 RESULT err=0 tag=97 nentries=0 etime=0
    <Event>
      <DateTime>07/May/2009:11:43:28 -0700</DateTime>
      <Client>207.1.153.32</Client>
      <Server>192.18.122.139</Server>
      <Connection>877</Connection>
      <Operation>0</Operation>
      <AuthenticatedDN>cn=Directory Manager</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;cn=Directory Manager&quot; method=128 version=3</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=97 nentries=0 etime=0</Response>
      </Responses>
    </Event>

    [07/May/2009:11:43:29 -0700] conn=877 op=1 SRCH base="(ou=People)" scope=2 filter="(uid=*)"
    [07/May/2009:11:43:29 -0700] conn=877 op=1 SORT uid
    [07/May/2009:11:43:29 -0700] conn=877 op=1 VLV 0:5:0210 10:5397 (0)
    [07/May/2009:11:43:29 -0700] conn=877 op=1 RESULT err=0 tag=101 nentries=1 etime=0
    <Event>
      <DateTime>07/May/2009:11:43:29 -0700</DateTime>
      <Client>207.1.153.32</Client>
      <Server>192.18.122.139</Server>
      <Connection>877</Connection>
      <Operation>1</Operation>
      <AuthenticatedDN>cn=Directory Manager</AuthenticatedDN>
      <Action>SRCH</Action>
      <Requests>
        <Request>SRCH base=&quot;(ou=People)&quot; scope=2 filter=&quot;(uid=*)&quot;</Request>
        <Request>SORT uid</Request>
        <Request>VLV 0:5:0210 10:5397 (0)</Request>
      <Responses>
        <Response>RESULT err=0 tag=101 nentries=1 etime=0</Response>
      </Responses>
    </Event>

#3
Extract:

    [21/Apr/2009:11:39:55 -0700] conn=14 fd=700 slot=700 connection from 207.1.153.51 to 192.18.122.139
    [21/Apr/2009:11:39:55 -0700] conn=14 op=0 BIND dn="" method=sasl version=3 mech=DIGEST-MD5
    [21/Apr/2009:11:39:55 -0700] conn=14 op=0 RESULT err=14 tag=97 nentries=0 etime=0, SASL bind in progress
    [21/Apr/2009:11:39:55 -0700] conn=14 op=1 BIND dn="uid=jdoe,dc=example,dc=com" method=sasl version=3 mech=DIGEST-MD5
    [21/Apr/2009:11:39:55 -0700] conn=14 op=1 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=jdoe,dc=example,dc=com"

Resultant sub-extract and Event output:

    [21/Apr/2009:11:39:55 -0700] conn=14 fd=700 slot=700 connection from 207.1.153.51 to 192.18.122.139
    [21/Apr/2009:11:39:55 -0700] conn=14 op=0 BIND dn="" method=sasl version=3 mech=DIGEST-MD5
    [21/Apr/2009:11:39:55 -0700] conn=14 op=0 RESULT err=14 tag=97 nentries=0 etime=0, SASL bind in progress
    <Event>
      <DateTime>21/Apr/2009:11:39:53 -0700</DateTime>
      <Client>207.1.153.51</Client>
      <Server>192.18.122.139</Server>
      <Connection>14</Connection>
      <Operation>0</Operation>
      <AuthenticatedDN>__Anonymous__</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;&quot; method=sasl version=3 mech=DIGEST-MD5</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=14 tag=97 nentries=0 etime=0, SASL bind in progress</Response>
      </Responses>
    </Event>

    [21/Apr/2009:11:39:55 -0700] conn=14 op=1 BIND dn="uid=jdoe,dc=example,dc=com" method=sasl version=3 mech=DIGEST-MD5
    [21/Apr/2009:11:39:55 -0700] conn=14 op=1 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=jdoe,dc=example,dc=com"
    <Event>
      <DateTime>21/Apr/2009:11:39:55 -0700</DateTime>
      <Client>207.1.153.51</Client>
      <Server>192.18.122.139</Server>
      <Connection>14</Connection>
      <Operation>2</Operation>
      <AuthenticatedDN>uid=jdoe,dc=example,dc=com</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;uid=jdoe,dc=example,dc=com&quot; method=sasl version=3 mech=DIGEST-MD5</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=97 nentries=0 etime=0 dn=&quot;uid=jdoe,dc=example,dc=com&quot;</Response>
      </Responses>
    </Event>

#4
Extract:

    [02/Sep/2014:11:05:56 -0400] conn=35 op=1 fd=64 closed - U1
    [02/Sep/2014:11:05:56 -0400] conn=36 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 BIND dn="" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn=""
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 RESULT err=0 tag=101 nentries=1 etime=0
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 BIND dn="uid=scarter,ou=people,dc=example,dc=com" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=scarter,ou=people,dc=example,dc=com"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 fd=64 closed - U1

Resultant sub-extract and Event output:

    [02/Sep/2014:11:05:56 -0400] conn=36 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 BIND dn="" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn=""
    <Event>
      <DateTime>02/Sep/2014:11:05:56 -0400</DateTime>
      <Client>127.0.0.1</Client>
      <Server>127.0.0.1</Server>
      <Connection>36</Connection>
      <Operation>0</Operation>
      <AuthenticatedDN>__Anonymous__</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;&quot; method=128 version=3</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=97 nentries=0 etime=0 dn=&quot;&quot;</Response>
      </Responses>
    </Event>

    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 RESULT err=0 tag=101 nentries=1 etime=0
    <Event>
      <DateTime>02/Sep/2014:11:05:56 -0400</DateTime>
      <Client>127.0.0.1</Client>
      <Server>127.0.0.1</Server>
      <Connection>36</Connection>
      <Operation>1</Operation>
      <AuthenticatedDN>__Anonymous__</AuthenticatedDN>
      <Action>SRCH</Action>
      <Requests>
        <Request>SRCH base=&quot;dc=example,dc=com&quot; scope=2 filter=&quot;(uid=scarter)&quot; attrs=&quot;c&quot;</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=101 nentries=1 etime=0</Response>
      </Responses>
    </Event>

    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 BIND dn="uid=scarter,ou=people,dc=example,dc=com" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=scarter,ou=people,dc=example,dc=com"
    <Event>
      <DateTime>02/Sep/2014:11:05:56 -0400</DateTime>
      <Client>127.0.0.1</Client>
      <Server>127.0.0.1</Server>
      <Connection>36</Connection>
      <Operation>2</Operation>
      <AuthenticatedDN>uid=scarter,ou=people,dc=example,dc=com</AuthenticatedDN>
      <Action>BIND</Action>
      <Requests>
        <Request>BIND dn=&quot;uid=scarter,ou=people,dc=example,dc=com&quot; method=128 version=3</Request>
      </Requests>
      <Responses>
        <Response>RESULT err=0 tag=97 nentries=0 etime=0 dn=&quot;uid=scarter,ou=people,dc=example,dc=com&quot;</Response>
      </Responses>
    </Event>

    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 fd=64 closed - U1
    <Event>
      <DateTime>02/Sep/2014:11:05:56 -0400</DateTime>
      <Client>127.0.0.1</Client>
      <Server>127.0.0.1</Server>
      <Connection>36</Connection>
      <Operation>3</Operation>
      <AuthenticatedDN>uid=scarter,ou=people,dc=example,dc=com</AuthenticatedDN>
      <Action>UNBIND</Action>
      <Requests>
        <Request>UNBIND</Request>
      </Requests>
      <Responses>
        <Response>fd=64 closed - U1</Response>
      </Responses>
    </Event>

Design
------
Assuming an extension to the logconv.pl script

New options:
* `-A`, `--audit` - emit audit events - default is to print regular logconv
  report output
* `--audit-format XML|JSON|etc.` - format to write audit events - default is TBD
* `--audit-internal yes|no` - audit internal events - default is no

Generate well formed events of operations found in the access log(s).  Events
will contain the identified connected client address and authenticated DN
performing the operation. Internal operations, if logged, will be ignored by
default. Specify no to emit events for internal operations.

Logic flow:
for every "active" connection (ie not closed) maintain a list of client, server and current authenticated DN.
for every operation for which we have an "active" connection, emit an event at the close of the operation.

Implementation
--------------
Extend the logconv.pl command as it contains existing access log file management.

