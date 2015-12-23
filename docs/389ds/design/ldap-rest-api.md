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

Second is with gssapi. This is a more secure, and the prefered authentication option. The configuration details of ldap to use gssapi are beyond the scope of this document.

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

|Method|Description|JSON Representation|
|-------|----------|----------|------------|
|GET|Request a representation of all the indexes on the server|
| | | | |

### /v1/index/{BACKEND}

- **BACKEND** - The name of the database backend.  E.g. *userRoot*

|Method|Description|JSON Representation|
|-------|----------|----------|------------|
|GET|Request a representation of all the indexes for the **backend**|NULL
| | | | |

### /v1/index/{BACKEND}/{ATTRIBUTE}

- **BACKEND** - The name of the database backend.  E.g. *userRoot*
- **ATTRIBUTE** - The attribute index

|Method|Description|JSON Representation|
|-------|----------|----------|------------|
|GET|Request a representation of the attribute index in the backend|None|
|PUT|Create a new index entry|[Index Representation](ldap-rest-api.html#index)
|POST|Reindex the attribute|None|
|PATCH|Modify the index configuration|[PATCH Representation](#patch)
|DELETE|Delete an index|None|
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

<br>

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

If you are configuring rest389 with freeipa, you must use constrained delegation. Consider that we want to use rest389 on our a 389 instance that is not part of the IPA domain

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



<br>

## JSON Representations
-----------------------

### Generic Result/Response Representation

All the JSON responses, for all the resources, are what the "**msg**" is in the **result** key.  All the following resource representation examples are what becomes the **msg** in the **result** key

        "href": "http link to resource",
        "resultCode": "http result code",
        "resultCount": #####
        "result": msg

<a name="patch"></a>

### PATCH - Update a resource

Every resource that supports PATCH uses the JSON Patch representation: [https://tools.ietf.org/html/rfc6902](https://tools.ietf.org/html/rfc6902)
However, currently we only support "**remove**", "**add**", "**replace**" from rfc6902

    [
        { "op": "remove", "path": "attr" },
        { "op": "add", "path": "attr", "value": [ "somevalue1", "somevalue2" ] },
        { "op": "replace", "path": "attr", "value": "somevalue1" }
    ]

Example

    [
        { "op": "remove", "path": "description" },
        { "op": "add", "path": "uniquemember", "value": [ "uid=mark,dc=example,dc=com", "uid=william,dc=example,dc=com" ] },
        { "op": "replace", "path": "userpassword", "value": "5ecretPa55Phra5e" }
    ]

<a name="suffix"></a>

### Suffix Representation

    GET, PUT
    -----------------------------------------------------
    {
        'dn': Config DN,
        'suffix': 'ou=people,dc=example,dc=com',
        'parent': 'dc=example,dc=com',
        'state':  'backend',
        'backend':  [ BACKEND, BACKEND, ... ],
        'referral': [ LDAP URL, LDAP URL, ... ]
    }

<a name="index"></a>

### Index Representation

    {
        'dn': Config DN,
        'index': ATTR,
        'systemIndex': true/false,
        'indexType': [ type, type, ... ]
        'matchingRule': [ mr, mr, ... ]
    }

### Replication Representations

THe following lists the representations of various components of replication, as well as the representations on how to update/access those resources.

<a name="replica"></a>

#### Replica Representation

    GET
    -----------------------------------------------------
    {
        'dn': DN
        'ReplicaRoot': SUFFIX
        'ReplicaRole': master, hub, consumer
        'ReplicaType': 2
        'ReplicaFlags': 1
        'ReplicaID': 1
        'ReplicaPurgeDelay': 604800
        'ReplicaBindDN': 'uid=replica,cn=config'
        'ReplicaBindDNGroup:' DN
        'ReplicaBindDNGroupCheckInterval': 60
        'ReplicaState': <decode base64 value>
        'ReplicaName': '38475874-sdfdf-...'
        'ReplicaBackoffMin': 5
        'ReplicaBackoffMax': 300
        'ReplicaProtocolTimeout': 120
        'ReplicaReferral': REFERRAL
        'ReplicaTombstonePurgeInterval': 12000
        'ReplicaPreciseTombstonePurging': on
        'ReplicaLegacyConsumer':
        'ReplicaCleanRUV': VALUE
        'ReplicaAbortCleanRUV': VALUE
        'ReplicaChangeCount':
        'ReplicaReapActive': 0/1
    }

    POST - Replica promotion/demotion Representation
    -----------------------------------------------------
    {
        'action': 'promote/demote'
        'newrole': 'master, hub, consumer'
        'rid': 'newrid'  # Only for promotion to master
        'binddn': DN  # Only for promotion to master
        'newrole': 'master, hub, consumer'
    }

<a name="replagmt"></a>

### Replication Agreement Representations

    GET, PUT
    -----------------------------------------------------
    {
        'dn': DN
        'ReplicaName':
        'ReplicaBindMethod': 'SASL/GSSAPI, SIMPLE  '
        'ReplicaBindDN': cn=dm
        'ReplicaBindCredentials': secret
        'ReplicaHost': vm-192.abc.idm.lab.eng.brq.redhat.com
        'ReplicaPort': 389
        'ReplicaRoot': dc=abc,dc=idm,dc=lab,dc=eng,dc=brq,dc=redhat,dc=com
        'ReplicaTransportInfo': LDAP
        'ReplicatedAttributeList':
        'ReplicatedAttributeListTotal':
        'ReplicaConnTimeout': 120
        'ReplicaRefresh': start
        'ReplicaSchedule':
        'ReplicaBusyWaitTime':
        'ReplicaSessionPauseTime':
        'ReplicaEnabled':
        'ReplicaStripAttrs':
        'ReplicaFlowControlWindow':
        'ReplicaFlowControlPause':
        'ReplicaRUV': []
        'ReplicaMaxCSN':
        'ReplicaBeginRefresh':
        'ReplicaLastUpdateStart': 20151109201346Z
        'ReplicaLastUpdateEnd: 20151109201346Z
        'ReplicaChangesSentSinceStartup': base64
        'ReplicaLastUpdateStatus':
        'ReplicaUpdateInProgress':
        'ReplicaLastInitStart':
        'ReplicaLastInitEnd': 20151109201336Z
        'ReplicaLastInitStatus':
        'ReplicaReapActive':
        'ReplicaStatus':
        # Window Sync Attributes
        'WinsyncDirectoryReplicaSubtree': DN
        'WindowsReplicaSubtree': DN
        'WinsyncNewWinUserSyncEnabled': 'on/off'
        'WinsyncNewWinGroupSyncEnabled':'on/off'
        'WinsyncWindowsDomain': VALUE
        'WinsyncDirsyncCookie': BASE64-VALUE
        'WinsyncInterval': INTERVAL
        'WinsyncOneWaySync':
        'WinsyncMoveAction':
        'WinsyncWindowsFilter':
        'WinsyncDirectoryFilter':
        'WinsyncSubtreePair':
    }

    POST
    -----------------------------------------------------
    {
        'action': 'enable/disable/initialize/send_updates'
        'target': 'all (default), winsync, ds'
    }

    POST Error Response - lists agreements that were not updated
    -----------------------------------------------------
    {
        'result_status': TEXT
        'agreements': [agmt_dn, agmt_dn,...]
    }

<a name="replstatus"></a>

### Replication Status Representation

Returns a list of agreements and their current replication status

    GET
    ------------------------------------------------------
    {
        [
            {
                'agreement': name,
                'suffix': replicated suffix,
                'consumer_host': host,
                'consumer_port': port,
                'status_code': 0 = in sync, -1 not in sync,
                'status_text': 'status message'
            },
            {
                'agreement': name,
                ...
                ...
            }
        ]
    }

<a name="changelog"></a>

#### Changelog Representation

    GET
    -----------------------------------------------------
    {
        'dn': DN:
        'ChangelogDir':
        'ChangelogMaxEntries':
        'ChangelogMaxAge':
        'ChangelogCompactDBInterval':
        'ChangelogTrimInterval':
        'ChangelogMaxConcurrentWrites':
        'ChangelogEncryptionAlgorithm':
        'ChangelogSymmetricKey':
    }


<a name="monitor"></a>

### Monitor Representations

    <work in progress>

<a name="entry"></a>

### LDAP Entry Representation

A list of "entries" is returned, even for a single entry.
    [
	{
	   "dn": "DN",
	   "attrs": {
		         "ATTR": ["VALUE", "VALUE"],
		         "ATTR": ["VALUE"],
		         ...,
		         ...
		    }
	},
	{
	   "dn": "DN",
	   "attrs": {
		         "ATTR": ["VALUE", "VALUE"],
		         "ATTR": ["VALUE"]
		         ...,
		         ...
		    }
	}
    ]

