---
title: "Online certificate refresh design"
---

# Online certificate refresh design

{% include toc.md %}

# Goal

 As described in [https://issues.redhat.com/browse/RHEL-86320](https://issues.redhat.com/browse/RHEL-86320):

* Support updating/renewing TLS certificate without restarting slapd  
  * Presently we require a service restart for the update: [https://docs.redhat.com/en-us/documentation/red\_hat\_directory\_server/12/pdf/securing\_red\_hat\_directory\_server/Red\_Hat\_Directory\_Server-12-Securing\_Red\_Hat\_Directory\_Server-en-US.pdf](https://docs.redhat.com/en-us/documentation/red_hat_directory_server/12/pdf/securing_red_hat_directory_server/Red_Hat_Directory_Server-12-Securing_Red_Hat_Directory_Server-en-US.pdf)  
    Sections 1.3 and 1.4

# Why

Explanation of Cu case:  
I'm hoping however that it would be possible for RHDS to support some method of reloading the TLS certificate/key without stopping and restarting the service. If not via something simple like SIGHUP, perhaps a task entry like reloading the schema could trigger slapd to reload the TLS key & certificate and then use it for new client connections.

(This would enable something using a ACME renewal process to call a helper script to easily update the certificate and make it active without needing to coordinate the process across the pool of load-balanced replicas and wait to drain connections from the instance.)

# Constraints

The work on [https://github.com/389ds/389-ds-base/pull/6952](https://github.com/389ds/389-ds-base/pull/6952) that allows to perform a single online change of the server certificate on non root installation provided several interesting pieces of knowledge:  

* It is possible to change the server certificate as the test case is working in a non root environment but you can switch the certificate only in a non root environment and only once. Both limits are because there is no API to reread the certificate from the new database and the work-around I used (deleting the internal db (to force reloading it) has these limitations)  
* There is no reliable API to resync the nss in memory data if the cert/key databases have been changed by another process (like certutil one) but there are API to change the database within the process that will work around this problem.  
* Although the secure connections are not explicitly closed, it finally gets closed if the CA certificate is changed because the server certificate change triggers a new handshake on open connections using the new server certificate and the client will reject it because it does not trust the new CA  
* Unable to decrypt the encrypted data after changing the server private key which mean:  
  * Having to export all databases to ldif with decrypt option before replacing the key   
  * Having to reset the replication agreements credentials

# Solution:

## dsconf interface change:

Some of the dsconf standalone1 security subcommands nows have a different behavior  
 whether the server is online or not.  
updating the nss db as before when the server is offline  
adding/modifying the certificate through 389ds server using the dsconf cli

Notes: 

* Should probably check that dsconf connection URI is not ldap:// before sending anything over the wire and log an error:  
  “ The server certificates should not be updated through unsecure connection. Use ldaps URI or ‘dsconf instanceName security certificate …’ (In case of doubt, the instance names can be listed with ‘dsctl \-l’ )”  
* The nickname may have the tokenname:nickname format

### Add a certificate to the NSS database

dsconf standalone1 security certificate add \--help  
usage: dsconf *instance* \[-v\] \[-j\] security certificate add \[-h\] \--file *FILE* \--name *NAME* \[--primary-cert\] \[--do-it\]

options:  
  \-h, \--help      show this help message and exit  
  \--file *FILE*     Sets the pkcs12 file name of the certificate  
  –pkcs12-pin-text    The pkcs12 password.  
  –pkcs12-pin-stdin  The pkcs12 password is silently read from stdin  
  –pkcs12-pin-path   A path to a file containing the pkcs12 password.  
  \--name *NAME*     Sets the name/nickname of the certificate  
  \--primary-cert  Sets this certificate as the server's certificate

–do-it is required if trying to add a certificate that cannot be verified  
 (to incite the user to add the CA chain first (starting up from the root CA))

### Add a certificate to the NSS database

dsconf *instance* security ca-certificate add \--file *FILE* \--name *NAME* \[--do-it\]

  \--file *FILE*           Sets the file name of the CA certificate  
  \--name *NAME* \[NAME ...\]

### Modify a certificate in the NSS database

dsconf *instance* security certificate set-trust-flags *nickname trustvalue*

### Rename a certificate in the NSS database

dsconf *instance* security certificate rename *nickname newnickname*

### Delete a server certificate in the NSS database

dsconf *instance* security certificate del *nickname*

### List the certificates

dsconf *instance* security certificate list

### Show a certificate

dsconf *instance* security certificate show *nickname*

## Core server changes

### Alternative 1: internal virtual backend

     Implement another virtual internal backend (i.e like the monitoring backend) that provides a view of the in memory NSS database   

  as a backend backed up on nss db allowing to add / modify / rename / delete certificate / search certificate  (Note: some attributes from add operation are not visible like the private key  
 (only its presence is displayed)

#### Search operation

the search entry contains:

| Attribute                                | FLAGS          | NSS API                                                                                                                                           | Description                                                                    |
|:---------------------------------------- |:-------------- |:------------------------------------------------------------------------------------------------------------------------------------------------- |:------------------------------------------------------------------------------ |
| cn                                       | CIS, A, R, r   | cert-\>nickname                                                                                                                                   | certificate nickname aka SSLpersonality                                        |
| objectclass                              | CIS, A,R       |                                                                                                                                                   | Top, extensibleobject (unless a new schema class is added)                     |
| dsDynamicCertificateStartDate            | TIME, R        | CERT\_GetCertTimes                                                                                                                                | Certificate start time got from                                                |
| dsDynamicCertificateStartDate            | TIME, R        | CERT\_GetCertTimes                                                                                                                                | Certificate start time got from                                                |
| dsDynamicCertificateSubject              | DN, R          | cert-\>sbjectuName                                                                                                                                | Certificate Subject DN                                                         |
| dsDynamicCertificateIssuer               | DN, R          | cert-\>issuerName                                                                                                                                 | Certificate Issuer DN                                                          |
| ~~dsDynamicCertificatePrivateKey~~       | ~~OS, A~~      |                                                                                                                                                   | ~~The private key encrypted with  the db pin~~                                 |
| dsDynamicCertificateDER                  | OS, A, R,      | CERT\_GetCertificateDer                                                                                                                           | Certificate binary encoding (without private key)                              |
| dsDynamicCertificateSerialNumber         | INT, R         | cert-\>serialNumber                                                                                                                               | Certificate serial number                                                      |
| dsDynamicCertificateAltName              | CIS, R         | cert-\>extensions                                                                                                                                 | Certificate AltName containing the hostname                                    |
| ~~dsDynamicCertificateExtendedKeyUsage~~ | ~~CIS, R, MV~~ | ~~cert-\>keyUsage cert-\>extensionsCERT\_FindKeyUsageExtension~~                                                                                 |                                                                                |
| dsDynamicCertificateType                 | CIS, R, MV     | cert-\>nsCertType                                                                                                                                 | SSL CLIENT SSL SERVER EMAIL OBJECT SIGNING SSL CA EMAIL CA OBJECT SIGNING CA   |
| dsDynamicCertificateTrustSSL             | CES, A, W, R   | CERT\_GetCertTrustUnfortunately the trus to string is not exported by nssCopy EncodeFlags and CERT\_EncodeTrustString from lib/certdb/certdb.c |                                                                                |
| dsDynamicCertificateIsCA                 | BOOL, R        | CERT\_IsCACert                                                                                                                                    |                                                                                |
| dsDynamicCertificateIsRootCA             | BOOL, R        | cert-\>isRoot                                                                                                                                     |                                                                                |
| dsDynamicCertificateValidity             | CIS, R         | CERT\_VerifyCertificate we may use CERT\_VerifyCertName/CERT\_VerifyCerNow/CERT\_VerifyCertChain to explain why the certificate is invalid      | The status of validity:VALID, INVALID TIME, INVALID CA, INVALID HOST, INVALID |
| dsDynamicCertificateFamilly              | DN, A          | PK11\_GetTokenName(cert-\>slot)                                                                                                                   | dn of config entry dse.ldif                                                    |
| dsDynamicCertificateToken                | CES            | PK11\_GetTokenName(cert-\>slot)                                                                                                                   | Family Token name (i.e: slot token in NSS API)                                 |
| dsDynamicCertificateHasPrivateKey        | BOOL, R        |                                                                                                                                                   |                                                                                |

Here are the above table flags meaning:

| Code | Description                                       | OID                           |
|:---- |:------------------------------------------------- |:----------------------------- |
| A    | Attribute should be present when adding the entry |                               |
| BOOL | Boolean Syntax                                    | 1.3.6.1.4.1.1466.115.121.1.7  |
| CES  | Case exact string                                 | 1.3.6.1.4.1.1466.115.121.1.26 |
| CIS  | CaseIgnoreString syntax                           | 1.3.6.1.4.1.1466.115.121.1.15 |
| DN   | Distinguish Name                                  | 1.3.6.1.4.1.1466.115.121.1.12 |
| OS   | Octet String syntax                               | 1.3.6.1.4.1.1466.115.121.1.40 |
| INT  | Integer Syntax                                    | 1.3.6.1.4.1.1466.115.121.1.27 |
| MV   | Attribute is Multi valued                         |                               |
| R    | Attribute may be present when searching the entry |                               |
| r    | Attribute may be modified in modrdn               |                               |
| TIME | Generalized time syntax                           | 1.3.6.1.4.1.1466.115.121.1.24 |
| W    | Attribute can an be modified                      |                               |

#### Add operation

The add/modify operation will fail if:

* server certificate already exists (in add case)   

* the certificate cannot be fully verified  
  
       (hostname \+ date \+ trust \+ CA trust chain \+ valid keys)

add operation attributes are:

| Attribute                         | Description                                                          | Required | Comment                                                                                                                                                                                                                      |
|:--------------------------------- |:-------------------------------------------------------------------- |:-------- |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dsDynamicCertificateDER           | Certificate DER                                                      | Yes      | Note: NSS provide support to convert PEM format with ATOB\_ConvertAsciiToItem function but not pkcs12 formatAnyway using plain binary format (DER) seems easier                                                             |
| dsDynamicCertificatePrivateKeyDER | Private Key DER                                                      | No       | I wondered about encrypting the key but I am not sure that the server will have the data to decrypt it even if we provide the password ⇒ it is easier to use plain key (and the communication through unix socket is secure) |
| CN                                | Certificate nickname                                                 | Yes      |                                                                                                                                                                                                                              |
| dsDynamicCertificateTrust         | Trust flags                                                          | No       | default set according to the certificate type:CT,, if SSL CAu,u,u if SSL CLIENT or SERVER                                                                                                                                  |
| dsDynamicCertificateForce         | If true the certificate is still added even if it cannot be verified | No       |                                                                                                                                                                                                                              |

#### Modrdn operation

modrdn is used to rename the certificate:  
mordn limitations:

* no newparentdn (or its value is the base dn entry parent)  
* whether deleteoldrdn is set or not the old rdn will be deleted  
* new rdn must only contain a single cn=value  
* newnickname should not exists

#### Modify operation

The add/modify operation will fail if:

* server certificate already exists (in add case)   

* the certificate cannot be fully verified  
  
       (hostname \+ date \+ trust \+ CA trust chain \+ valid keys)

The following attributes may be changed:

* dsDynamicCertificateDER  
* dsDynamicCertificatePrivateKeyDER  
* dsDynamicCertificateTrust  
* dsDynamicCertificateForce

Modifiers should always be “replace” and with a single value  
If dsDynamicCertificatePrivateKeyDER is replaced then dsDynamicCertificateDER must be replaced   

Delete operation  
delete is used to remove the certificate

#### The base entry

cn=dynamiccertificates entry is:

| Attribute                            | Value                            | Comment                                                                                                                                                                                                         |
|:------------------------------------ |:-------------------------------- |:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dn                                   | cn=dynamiccertificates           |                                                                                                                                                                                                                 |
| cn                                   | dynamiccertificates              |                                                                                                                                                                                                                 |
| objectclass                          | topnsContainerextensibleobject |                                                                                                                                                                                                                 |
| aci                                  |                                  | A copy of cn=encryption,cn=config aci attribute. Modifying it change cn=encryption,cn=config aci                                                                                                                |
| dsDynamicCertificateSwitchInProgress | False                            | Indicate if the server is trying to switch its certificate (SSL request are blocked during this time)Can be turned on to force a switchValue is then reset to False by the server once the switch is complete |

only the aci and dsDynamicCertificateSwitchInProgress attributes can be modified

### Alternative 2: Task

Easier to implement than a virtual backend but does not provide a way to see the in memory certificates 

### Alternative 3: Extended Operation

More complex to panhandle at client side that task and same drawback

## Switching the server certificate

The switch is performed when

* successfully adding or replacing the server certificate  
* performing an operation that impact server certificate verification status (i.e moving from a failure to success)  
* Changing dsDynamicCertificateSwitchInProgress attribute in the container entry

Then to perform the switch similarly to what is done in PR  [https://github.com/389ds/389-ds-base/pull/6952](https://github.com/389ds/389-ds-base/pull/6952)  
(i.e. block the accept and listeners threads then reinitialize 389 security layers)

## lib389 changes:

Should add:

* new mapped object to list and search the certificates   
* dsconf [changes](#dsconf-interface-change:) to support certificate subcommands to:  
  * List certificates  
  * Display certificates  
  * Add certificate  
  * Rename certificate  
  * Modify certificate trust  
  * Remove certificate

To extract the certificate DER and the private key from pkcs12, something similar to the following code could be used:

```
\#\!/usr/bin/python3
\# \--- BEGIN COPYRIGHT BLOCK \---
\# Copyright (C) 2025 Red Hat, Inc.
\# All rights reserved.
\#
\# License: GPL (version 3 or any later version).
\# See LICENSE for details.
\# \--- END COPYRIGHT BLOCK \---

from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import pkcs12
import ldap
import sys
p12path \= '/home/progier/sb/i0dyncert/389-ds-base/dirsrvtests/tests/data/tls/server-export.p12'
uri \= 'ldapi://%2fhome%2fprogier%2fsb%2fi0dyncert%2ftst%2fci-install%2fvar%2frun%2fslapd-i.socket'
SUFFIX='cn=dynamiccertificates'
p12pw=b"secret12"
p12pw=None
\# Read the PKCS12 file
with open(p12path, "rb") as f:
      p12\_data \= f.read()
privkey, cert, cas \= pkcs12.load\_key\_and\_certificates(p12\_data, p12pw)
dercert \= cert.public\_bytes(serialization.Encoding.DER)
derpkey \= privkey.private\_bytes(encoding=serialization.Encoding.DER,
                                format=serialization.PrivateFormat.PKCS8,
                                encryption\_algorithm=serialization.NoEncryption())
for ca in cas:
    derca \= ca.public\_bytes(serialization.Encoding.DER)
ldc \= ldap.initialize(uri)
sasl\_auth \= ldap.sasl.external()
ldc.sasl\_interactive\_bind\_s("", sasl\_auth)
nickname='Cert1'
dn=f'cn={nickname},{SUFFIX}'
entry \= \[
    ('cn', \[ nickname.encode(encoding="utf-8"), \] ),
    ('objectclass', \[ b'top', b'extensibleobject' \] ),
    ('dsDynamicCertificateDER', \[ dercert, \] ),
    ('dsDynamicCertificatePrivateKeyDER', \[ derpkey, \] ),
    ('dsDynamicCertificateForce', \[ b"TRUE", \] ), \]
try:
   ldc.add\_s(dn, entry);
except ldap.LDAPError as exc:
    print (f'Add {dn} fail: {exc}')
    sys.exit(1)
```

## Schema changes:

In the first step no schema change will be done and extensibleobject will be used.  
We may later add new schema class for cn=certificates,cn=config subentries in 50ns-directory.ldif

# Tests

Plan to reuse the dirsrvtests/tests/suites/tls/ecdsa\_test.py::test\_refresh\_ecdsa test from   
[https://github.com/389ds/389-ds-base/pull/6952](https://github.com/389ds/389-ds-base/pull/6952) to test the context switch after modifying the way the tester install the certificate  
to use the LDAP interface

will need some new tests  to test lib389 and ldap interface changes:  
 to add/search/rename/replace/delete certificates

# Documentation change:

Warning:   
  Although modifying directly the NSS database with certutil is still possible, doing that will     
  require a server restart to be able to resync the 389 server in memory database with the NSS db file  
 So using dsconf is a good idea  
Should better have ldapi interface (i.e using linux socket) to have a secure way to set the certificate   
 in case of problem with the security configuration

# Discarded ideas

* Using pkcs12 to add the certificate and private keys discarded because it is hard to decode on the server side (would have to duplicate lots of pk12util code) so it is better to directly use der and key which are directly handled by NSS API  
* Using 50-certificate.ldif for the schema discarded because it is related to another application (netscape certificate management)  
* Reading again the nss discarded (as tried in [https://github.com/389ds/389-ds-base/pull/6952](https://github.com/389ds/389-ds-base/pull/6952)) because I have not been able to find a reliable way to do that. Removing/Resetting the internal module does not work. Fully resetting the nss with SECMOD\_RestartModules leads to a crash around the authentication mechanism.

# Ideas for future

Once this feature is implemented we may want to improve the attribute encryption key renewal (which probably means keeping the old keys until everything is encrypted properly and keeping trace of what is still encrypted with which keys.  
If we are able to verify the certificate, we may check certificate validity in healthcheck

# A few finding on the prototype

* Should avoid using a subsuffix of cn=config otherwise the search will be triggered by every internal searches under cn=config to find a configuration value  
  ⇒ Better use something as cn=dynamicCertificates as suffix  
* Should we keep the entries in memory or recreate them  
  My feeling is that we seldom access to the certificates and performance when reading/modifying certificates is not so important so it is better to keep the memory footprint as small as possible and rebuild the list of entries when doing a search

# Example of output:

## Search

```
ldapsearch \-Q \-LLL \-Y EXTERNAL \-H ldapi://%2fvar%2frun%2fslapd-i.socket \-b cn=dynamiccertificates \+ '\*'
dn: cn=dynamiccertificates
objectClass: top
objectClass: nsContainer
cn: dynamiccertificates

dn: cn=Server-Cert,cn=dynamiccertificates
objectClass: top
objectClass: extensibleobject
cn: Server-Cert
dsdynamiccertificatesubject: CN=progier-thinkpadt14gen5.rmtfr.csb,givenName=1e
 df41a2-77ad-4de7-ba64-36c4573bcdbe,O=testing,L=389ds,ST=Queensland,C=AU
dsdynamiccertificateissuer: CN=ssca.389ds.example.com,O=testing,L=389ds,ST=Que
 ensland,C=AU
dsdynamiccertificateisca: FALSE
dsdynamiccertificateisrootca: FALSE
dsdynamiccertificatehasprivatekey: TRUE
dsdynamiccertificateisservercert: TRUE
dsdynamiccertificatekeyalgorithm: RSA
dsdynamiccertificatenotbefore: 20251003134154Z
dsdynamiccertificatenotafter: 20271003134154Z
dsdynamiccertificatetrustflags: u,u,u
dsdynamiccertificatetype: SSL CLIENT
dsdynamiccertificatetype: SSL SERVER
dsdynamiccertificatetokenname: Internal (Software) Token
dsdynamiccertificateder:: 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
dsdynamiccertificateserialnumber: 00c8561c1b
dsdynamiccertificateverificationstatus: SUCCESS
dsdynamiccertificatesubjectaltname: mylaptop.example.com

dn: cn=Self-Signed-CA,cn=dynamiccertificates
objectClass: top
objectClass: extensibleobject
cn: Self-Signed-CA
dsdynamiccertificatesubject: CN=ssca.389ds.example.com,O=testing,L=389ds,ST=Qu
 eensland,C=AU
dsdynamiccertificateissuer: CN=ssca.389ds.example.com,O=testing,L=389ds,ST=Que
 ensland,C=AU
dsdynamiccertificateisca: TRUE
dsdynamiccertificateisrootca: TRUE
dsdynamiccertificatehasprivatekey: FALSE
dsdynamiccertificateisservercert: FALSE
dsdynamiccertificatekeyalgorithm: RSA
dsdynamiccertificatenotbefore: 20251003134103Z
dsdynamiccertificatenotafter: 20271003134103Z
dsdynamiccertificatetrustflags: CT,,
dsdynamiccertificatetype: SSL CLIENT
dsdynamiccertificatetype: SSL SERVER
dsdynamiccertificatetype: EMAIL
dsdynamiccertificatetype: SSL CA
dsdynamiccertificatetype: EMAIL CA
dsdynamiccertificatetokenname: Internal (Software) Token
dsdynamiccertificateder:: MIIFZjCCA06gAwIBAgIFAMhWG7kwDQYJKoZIhvcNAQELBQAwZTEL
 MAkGA1UEBhMCQVUxEzARBgNVBAgTClF1ZWVuc2xhbmQxDjAMBgNVBAcTBTM4OWRzMRAwDgYDVQQKE
 wd0ZXN0aW5nMR8wHQYDVQQDExZzc2NhLjM4OWRzLmV4YW1wbGUuY29tMB4XDTI1MTEwMzEzNDEwM1
 oXDTI3MTEwMzEzNDEwM1owZTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClF1ZWVuc2xhbmQxDjAMBgN
 VBAcTBTM4OWRzMRAwDgYDVQQKEwd0ZXN0aW5nMR8wHQYDVQQDExZzc2NhLjM4OWRzLmV4YW1wbGUu
 Y29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAq34UQh9L3VPqhhLO6qnx3geiQJYf5
 Q2r5oiuJEn6RGLSknbuGFIOLEg0VtrYVa+LoSdabVyPGcZit8dxRCbNbn8lvS7XbE2+iMxKYaQyIV
 R86wCX4d3daziETW4LVqCl8V16bJNkyNhP6SSSga+d/5cVTs8DkoFtG2yUsZ2PFKKrgR/1VFu2fZY
 KoeUBHeKtOksJqWcCKUavH3xvStQZBtipYBjk8OdFksG0FxkRKAQq4NxMCQymb18KD6ah1lBBUrCI
 sy6tFkCWzS8+VWCRhLin10U1tP3lVQBn/YUuPzj5JOnC5olX3LipquPq3fNwY431IEnvD4GLfrcMJ
 jgsbB5OJq7hKrAuYk2fixMEHdurme8f+b44XAebv8s0wJ8SzHQsXnvc7seUfiTUAictuHyl9KAEK6
 iBIB6TRt7lxPnCf7QILizbqdRq1asvMF9//VpNjNNfXh0RXSlJDl8LwEPSE9Bm6s3XbWwc0JavB7+
 lB/MYlm5fmt7TYHyfpW3TRLaaWnURLpBk8FXtOj4lrmJL1bfmXtK52c/hR02HqDRKzQkubaB7zsXK
 gLCdjf8IJVlbQ+P8w9H4yjV98ZQZV/K/I6ew8FJfPE5q6nUJm0EASVTCPpPOScoYUg8RnQBzsr7EE
 jo2ZS8h+8jGmToD1krvx5uGLgDYJJhOvCB4+LkCAwEAAaMdMBswDAYDVR0TBAUwAwEB/zALBgNVHQ
 8EBAMCAgQwDQYJKoZIhvcNAQELBQADggIBAHVjZfHngc1hDwkcFZUzA74jHZxIvqIjp8W0NByyU0p
 NjBQnbd2B23DeZGhWJBpDCNddMjRYYUEJqOVb4jwyvBiW1lujN2MfgPwRZbM1gHHziFOfXI/CEK4G
 hksvd/qwGcwth+8I7aeqsugUR+aXpBbvxEXGp+OZkyqdPKVkk09UHpj3QUXAn3IbA0/04r8ql6lPF
 7GJ9EDHjPdEeUt1J6OV5O88c7kTLqjDoNW99bJyvURB5VONTZKk6GbREVLOhWEa+rb28PHiFmY/lR
 wGr3kr9+QrQzTFw3r0FGG2E/JL9sQo/ffFxjabYyKYnLhHcPpYoxuZBzNR+3Q/JgYe2/N7lKzikJN
 T6GSxpNnt+eo14i379aYGddlBv8COZKkvSPDnECFm+WZUSADwatirzkCR9f/l2AqpTEGFbiQfcPzH
 X/BdvWHWgOZMvULIHSVvM8xDzQ/HEaDlQGE62VXLdfeLxxP6MsZgsPnwSr6e/oQPXK5RIlGZ1VcB+
 nJQ49da+9VsAXbasbLBgcEa5Sc2l/TJrqs/VtiaggMfjG8hUq7PQ+SxTO7r2lVC8iaSPNssriC45E
 XKmHjoyYD/xYdUEBpKnDNAH4tPOlCPiU0KN+UMVhsKbR1sG/AXg5RNcQgXAO/SqXTrzl+yHCKpE8A
 oHg62CUpz59+UVF6A0f/xD0A2
dsdynamiccertificateserialnumber: 00c8561bb9
dsdynamiccertificateverificationstatus: SUCCESS

dn: cn=Cert1,cn=dynamiccertificates
objectClass: top
objectClass: extensibleobject
cn: Cert1
dsdynamiccertificatesubject: CN=leaf.example.com,O=testing,L=389ds,ST=Queensla
 nd,C=AU
dsdynamiccertificateissuer: CN=inter.example.com,O=testing,L=389ds,ST=Queensla
 nd,C=AU
dsdynamiccertificateisca: FALSE
dsdynamiccertificateisrootca: FALSE
dsdynamiccertificatehasprivatekey: TRUE
dsdynamiccertificateisservercert: FALSE
dsdynamiccertificatekeyalgorithm: RSA
dsdynamiccertificatenotbefore: 20220111025711Z
dsdynamiccertificatenotafter: 20420111025711Z
dsdynamiccertificatetrustflags: u,u,u
dsdynamiccertificatetype: SSL CLIENT
dsdynamiccertificatetype: SSL SERVER
dsdynamiccertificatetype: EMAIL
dsdynamiccertificatetokenname: Internal (Software) Token
dsdynamiccertificateder:: MIIDXTCCAkWgAwIBAgIFALr2pxswDQYJKoZIhvcNAQELBQAwYDEL
 MAkGA1UEBhMCQVUxEzARBgNVBAgTClF1ZWVuc2xhbmQxDjAMBgNVBAcTBTM4OWRzMRAwDgYDVQQKE
 wd0ZXN0aW5nMRowGAYDVQQDExFpbnRlci5leGFtcGxlLmNvbTAeFw0yMjAyMTEwMjU3MTFaFw00Mj
 AyMTEwMjU3MTFaMF8xCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpRdWVlbnNsYW5kMQ4wDAYDVQQHEwU
 zODlkczEQMA4GA1UEChMHdGVzdGluZzEZMBcGA1UEAxMQbGVhZi5leGFtcGxlLmNvbTCCASIwDQYJ
 KoZIhvcNAQEBBQADggEPADCCAQoCggEBAOS672+WBtOa5ehJwCESHjk4HpRdHlCsAQiKpKyykdDZM
 9kpsZT+becyNc6zHORcduehsjY46vQDXrMN4Q8AjoFFK0qTA0DeZleWeQMa0cBnqt9bCkIJzwCuTY
 8zNHlLiA5iYUhwCvDQNegnjSonLiSm19earxyy75etklFDeiEij+KdHN6MKFloJ/0L4u3ckNCHTun
 nGjIfdNUT92Ignxt5KAN2bT6hbSbf9PCx1A2Cyyt4DsVCSIqjIfalkMPXGY2M0a5GvMayhpf1yvRP
 25uAEQZwn+ahpic+qwk6YXdBXUgsbBcFoT8HkG/EmSYrlwAxlroq6FvL3n0RlfcMzf0CAwEAAaMfM
 B0wGwYDVR0RBBQwEoIQbGVhZi5leGFtcGxlLmNvbTANBgkqhkiG9w0BAQsFAAOCAQEA27IS76HxwA
 nJH/8tEPjDDnJw9zsmkHX6skhVfFYlkpfukl0Lm0DGmfeeqYfTBU1g2x5NTxeUBip104gES0iXeq7
 Yr+7pdvnV6pB42EAeWRDN9DGDpTL/9/aO8Vm+O28SdILYjuGqXnoPbuUgYLPOnO/8REbQp7jk6kwj
 e1eJ81JyYINXCwzEEpq0ycwaU6aIcCP3BY5c9PV5DStN+ddVesI2SkVABd8b0zmh+aw1zzACpUnBg
 NX60jfbPIr+UqCwlW8LMKmHuL9NkN/mLEyVhH3v8CpSpTWB+cOntmuK7sESgO8c/u/6ohYPyrEsNB
 TJgmXeHO8rsYNQAiRkpkvQPA==
dsdynamiccertificateserialnumber: 00baf6a71b
dsdynamiccertificateverificationstatus: FAILURE: error \-8179 \- Peer's Certific
 ate issuer is not recognized.
dsdynamiccertificatesubjectaltname: leaf.example.com
```
