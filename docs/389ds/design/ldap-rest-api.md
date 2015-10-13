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





