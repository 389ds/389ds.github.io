---
title: "LDAP REST API"
---

{% include toc.md %}

# LDAP REST API
-------------

This document describes the 389 Directory Server RESTful API

# Introduction
--------------

As part of the new web-based server management console initiative, a RESTful API has been developed to handle LDAP operations/tasks over HTTP.  The following document describes the RESTful characteristics of each resource.  First, here is a brief background on what REST means to us.  **REST** stands for **RE**presentational **S**tate **T**ransfer, and it is a design concept for modern HTTP/HTML services.  The idea is that you have resources on a server that you can read or update.  These resources are accessed via HTTP URLs, and that various HTTP methods should behave in a certain way(some methods are safe, others are not).  Each method acts upon these resources through their respective representations (in our case we use JSON for our resource representations - more on this later).  Here is a basic description of our LDAP RESTful methods

-   **OPTIONS** - This HTTP method returns all the available HTTP methods that the particular resource allows.  This is like a discovery method to see what a client can do with the resource

-   **HEAD** - Returns the headers for that resource

-   **GET** - Returns a representation of the resource (*idempotent*)

-   **PUT** - Create a resource, and return a representation of that new resource (*idempotent*)

-   **POST** - Update a resource, or perform an action on resource, and return a representation of the action performed or the updated resource

-   **PATCH** - Update a resource, and return a representation of the newly modified resource

-   **DELETE** - Delete a resource (*idempotent*)

The term **idempotent** means that no matter how many times you send the same request, the result is the same as if you issued the command only once.  So if you issue the same PUT request to create a resource, and send it 5 times, there will only be one new resource, not 5.  So if you send a PUT operation, and you don't get a response back, you can safely resend it without worrying about creating multiple identical resources(or changing the state of that resource with each attempt).  Basically you can keep resending the same request until you get a successful response.  This can not be said for the other methods which are not *idempotent*.

So for PUT we slightly stray from the pure RESTful design, but in our case when we use it add a resource(instead of using POST), it is safe to try and re-add an entry as many times as you want, the same goes for DELETE.  Once a resource is deleted, it's gone, and there are no changes if you continue to try and DELETE that resource.  Finally, GET is idempotent because it does not(should NOT) modify the state of a resource, but only return its current representation.

# Authentication
----------------

Keeping our ldap servers safe is a top priority in an admin system like this. We decided the best course of action was to have a minimal rest layer, and to allow the ldap server to continue to dictate the aci and controls. This way, every part of rest is accessible to anyone, but the ldap server itself will reject your attempts to use it.

There are two ways to authenticate to the rest server.

First is with classic, http basic authentication. The details from this authentication are passed as a binddn and password to the ldap server.

    curl -u 'cn=Directory Manager:password'  always http://ldapkdc.example.com:5000/v1/whoami
    {
      "href": "http://ldapkdc.example.com:5000/v1/whoami", 
      "result": "dn: cn=directory manager", 
      "resultCode": 200, 
      "resultCount": 1
    }

Second is with gssapi. This is a more secure, and the preffered authentication option. The configuration details of ldap to use gssapi are beyond the scope of this document.

This way a client only needs a krb5 ccache and the credentials are passed through.

    klist
    Ticket cache: KEYRING:persistent:1000:krb_ccache_1BEqTm7
    Default principal: admin@EXAMPLE.COM

    Valid starting     Expires            Service principal
    25/11/15 09:32:22  26/11/15 09:32:00  HTTP/ldapkdc.example.com@EXAMPLE.COM
    25/11/15 09:32:00  26/11/15 09:32:00  krbtgt/EXAMPLE.COM@EXAMPLE.COM

    curl -u ':' --negotiate --delegation always http://ldapkdc.example.com:5000/v1/whoami
    {
      "href": "http://ldapkdc.example.com:5000/v1/whoami", 
      "result": "dn: uid=admin,ou=people,dc=example,dc=com", 
      "resultCode": 200, 
      "resultCount": 1
    }

Both of these are supported by curl, and browsers.

# Our Resources
---------------

The following lists the currently implemented resources - this is a work in progress at the moment.  Note, all the resource have OPTIONS and HEAD methods available so they will not be listed for each resource.

<br>

## "Index" Resources
--------------------

### /v1/index

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of all the indexes on the server|**justdn**=*yes* - Returns just the DN of the index, instead of the full entry|curl -X GET -G "http://localhost:5000/v1/index" <br>curl -X GET -G "http://localhost:5000/v1/index" -d 'justdn=yes'|
| | | | |

### /v1/index/{BACKEND}

- **BACKEND** - The name of the database backend.  E.g. *userRoot*

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of all the indexes for the **backend**|**justdn**=*yes* - Returns just the DN of the index, instead of the full entry|curl -X GET -G "http://localhost:5000/v1/index/userroot" <br> curl -X GET -G "http://localhost:5000/v1/index/userroot" -d 'justdn=yes'|
| | | | |

### /v1/index/{BACKEND}/{ATTRIBUTE}

- **BACKEND** - The name of the database backend.  E.g. *userRoot*
- **ATTRIBUTE** - The attribute index

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of the attribute index in the backend|None|curl -X GET "http://localhost:5000/v1/index/userroot/cn"|
|PUT|Create a new index entry|**types**=*indexing_type* - Specify an indexing type.  Multivalued paramter<br>**mr**=*matching_rule* - specfiy a matching rule|curl -X PUT -G "http://localhost:5000/v1/index/userroot/newattr" -d 'types=eq' -d 'types=pres' -d 'mr=2.5.13.2'
|POST|Reindex the attribute|None|curl -X POST -G "http://localhost:5000/v1/index/userroot/newattr"|
|PATCH|Modify the index configuration **Not Implemented yet**|n/a|n/a|
|DELETE|Delete an index|None|curl -X DELETE "http://localhost:5000/v1/index/userroot/newattr"
| | | | |

<br>

## "Suffix" Resources
---------------------

### /v1/suffix

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of all the suffixes|**justdn**=*yes* - Return just the suffix names|curl -X GET -G "http://localhost:5000/v1/suffix" -d 'justdn=yes'|
| | | | |

### /v1/suffix/{SUFFIX}

- **SUFFIX** - The suffix to engage

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of the suffix entry|None|curl -X GET "http://localhost:5000/v1/suffix/dc=example,dc=com"|
|PUT|Create a new suffix entry and backend|**backend**=*be_name*|curl -X PUT -G "http://localhost:5000/v1/suffix/dc=example,dc=com" -d 'backend=newUserRoot'|
|PATCH|Modify a suffix configuration **Not Implemented yet**|n/a|n/a|
|DELETE|Delete a suffix and its associated backend(if selected)|**deletebackend**=*backend*|curl -X DELETE -G "http://localhost:5000/v1/suffix/dc=example,dc=com" -d "deletebackend=newUserRoot"|
| | | | |


<br>

## LDAP Operation Resources
---------------------------

### /v1/ldapmod/{DN}

- **DN** - the DN of the entry

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|PUT|Add an LDAP entry|**attribute**=*value*|curl -X PUT -G 'http://127.0.0.1:5000/v1/ldapmod/uid=mreynolds,dc=example,dc=com' -d 'objectclass=top' -d 'objectclass=person' -d 'objectclass=inetorgperson' -d 'objectclass=inetuser' -d 'uid=mreynolds' -d 'givenname=Mark' -d 'cn=Mark_Reynolds' -d 'sn=Reynolds'|
|PATCH|Modify an entry (also yused for MODRDN)|**changetype**=*modify/modrdn*<br>**op**=*add/replace/delete*<br>**attribute**=*value*<br>**newrdn**=*new_rdn*<br>**newsuperior**=*new_superior*<br>**deleteoldrdn**=*True/False*|curl -X PATCH -G 'http://127.0.0.1:5000/v1/ldapmod/uid=mreynolds,dc=example,dc=com' -d 'changetype=modify' -d 'op=replace' -d 'description=test'<br>curl -X PATCH -G 'http://127.0.0.1:5000/v1/ldapmod/uid=mreynolds,dc=example,dc=com' -d 'changetype=modrdn' -d 'newrdn=cn=mreynolds' -d 'deloldrdn=True'|
|DELETE|Delete an ldap entry|None|curl -X DELETE -G 'http://127.0.0.1:5000/v1/ldapmod/cn=mreynolds,dc=example,dc=com'|
| | | | |


### /v1/ldapsrch/{DN}/{SCOPE}/{FILTER}

- **DN** - The DN of the entry
- **SCOPE** - Search scope: base, one, sub
- **FILTER** - Search filter

|Method|Description|Parameters|CURL Example|
|-------|----------|----------|------------|
|GET|Request a representation of ldap entry result set|None|curl -X GET -G 'http://127.0.0.1:5000/v1/ldapsrch/dc=example,dc=com/sub/(&(objectclass=person)(cn=*))'|
| | | | |

<br>

## JSON Representations
-----------------------

### Generic Result Representation

    {
        "result": "success|fail",
        "href": "http link to resource - except for DELETEs or failures",  
        "msg": "text"
    }

### LDAP Entry Representation

    {
        "result": "success|fail",
        "href": "http link to resource",
        "msg": {
            "entryCount": COUNT,
            "entries": [
                {
                    "dn": "DN",
                    "attrs": {
                        "ATTR": [
                            "VALUE",
                            "VALUE"
                        ],
                        "ATTR": [
                            "VALUE"
                        ]
                        ...
                        ...
                    }
                },
                {
                    "dn": "DN",
                    "attrs": {
                        "ATTR": [
                            "VALUE",
                            "VALUE"
                        ],
                        "ATTR": [
                            "VALUE"
                        ]
                        ...
                        ...
                    }
                }
            ]
        }
    }


# Configuration
---------------

The rest389 admin server should be deployed on the same server as the ldap server instance. This allows rest389 to perform local instance discovery.

The rest389 server needs r-x access to the /etc/dirsrv/slapd-<inst>/dse.ldif . This may mean the use of a process worker uid that has access from apache (see [WSGIDaemonProcess](https://code.google.com/p/modwsgi/wiki/ConfigurationDirectives#WSGIDaemonProcess) to set a user account that has r-x to this.

If you are using GSSAPI with the server a keytab of the form "HTTP/<hostname>@REALM" and should be extracted to a secure keytab location. If you are running rest389 standalone, you should run:

    KRB5_KTNAME=/path/to/http.keytab python rest389-standalone.py

If you are using apache you should use

    SetEnv KRB5_KTNAME /path/to/http.keytab

# Constrained Delegation
------------------------

If you are configuring rest389 with freeipa, you must use contstrained delegation. Consider that we want to use rest389 on our a 389 instance that is not part of the IPA domain

    master: ipamaster.example.com
    389 server: ds.example.com
    389 principal: ldap/ds.example.com

First, we need to make the keytab for the rest389 service

    ipa service-add HTTP/ds.example.com

Next we need to extra the keytab to the master.

    ipa-getkeytab -s ipamaster.example.com -k /etc/httpd/http.keytab HTTP/ds.example.com

We add the service delegation rules

    ipa servicedelegationrule-add ds-http-delegation
    ipa servicedelegationruletarget-add ds-ldap-target
    ipa servicedelegationrule-add-target --servicedelegationtargets=ds-ldap-target ds-http-delegation
    ipa servicedelegationrule-add-member --principals HTTP/ds.example.com ds-http-delegation
    ipa servicedelegationtarget-add-member --principals=ldap/ds.example.com ds-ldap-target

We can now prove the delegation is working:

    kvno -k /etc/httpd/http.keytab -U admin -P HTTP/ds.example.com ldap/ds.example.com


