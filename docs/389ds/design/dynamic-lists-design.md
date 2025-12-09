---
title: "Dynamic Lists Design"
---

# Dynamic Lists
----------------

Overview
--------

Dynamic lists are designed to perform an internal search to build up an entries content. The most common use case would be for groups, or aka **Dynamic Groups**. In the global backend confiruation you can configure which objectclass an entry must have to identify it was a dynamic entry, which attribute contains an LDAP URI, and which attribute will get populated with the dynamic data. This attribute that contains the dynamic data will contain the DN of the matching entries, but this can be bypassed to use a different attribute/value from the matching entries by requesting an attribute in the LDAP URI.  More on this later...

Design
------

This feature is implemented in the backend code when returning entries from a search. The entry is checked if it's a "dynamic entry", and if it is the server will "build up" the entry to include the dynamic content.  When searching/filtering on "dynamic content" the server will check the filter and if it includes the dynamic content attribute (or list attribute) it will update the candidate list to incldue all dynamic entries. Later the search filter and access control will applied to these entries.

```
The LDAP URL can only be run locally and will not query a remote server.  This is why we reference it as a URI as the host/port are ignored:

    ldap:/// <_BASE_DN_> ? <_ATTRIBUTE_> ? <_SCOPE_> ? <_FILTER_>
    
    ldap:///ou=people,dc=example,dc=com??one?(&(objectclass=posixAccount)(uid=*))
    
If the *scope* is not specified then a scope of "base" is assumed, and this is probably not desired. So don't forget to set the search scope (base, one, sub)
    
As previously mentioned you can override what attribute/content is added to the resulting entry by specifying an *attribute* in the LDAP URI

    ldap:///ou=people,dc=example,dc=com?mail?one?(&(objectclass=posixAccount)(uid=*))
    
Here we set **mail** as the requested attribute.  The server will take the "mail" attribute and value and add it the resulting entry.  Note, the attribute specified in the configuration (*nsslapd-dynamic-lists-attr*) is now bypassed and will **not** be written to the dynamic entry.  See the Example section to see how this looks.

Major configuration options and enablement
------------------------------------------

The configuration is set under **cn=config,cn=ldbm database,cn=plugins,cn=config**

- **nsslapd-dynamic-lists-enabled**
- **nsslapd-dynamic-lists-oc** specifies the objectclass that an entry must have to be considered a dynamic entry
- **nsslapd-dynamic-lists-url-attr** specifies the attribute in the dynamic entry that contains the LDAP URI
- **nsslapd-dynamic-lists-attr** specifies the attribute that will contain the DN of the entries that match the LDAP URI. This attribute stores the DN of an entry, so the attribute configured **MUST** have a DN syntax. Note - this can be bypassed by requesting an attribute in the LDAP URI (See Examples section)
    
CLI Usage
---------

Here are the set options in the CLI

```
usage: dsconf instance [-v] [-j] backend config set


    --enable-dynamic-lists           Enables dynamic lists
    --disable-dynamic-lists          Disables dynamic lists
    --dynamic-oc <OBJECTCLASS>       Specifies the objectclass to identify entry that has a dynamic list
    --dynamic-url-attr <LDAP URL>    Specifies the attribute that contains the URL of the dynamic list
    --dynamic-list-attr <ATTRIBUTE>  Specifies the attribute used to store the values of the dynamic list. The attribute must have a DN syntax
```



Examples
--------

Here are some different configurations and how it will impact the search

### Example 1 - Standard configuration

```
cn=config,cn=ldbm database,cn=plugins,cn=config
...
nsslapd-dynamic-lists-enabled: on
nsslapd-dynamic-lists-oc: groupOfUrls
nsslapd-dynamic-lists-url-attr: memberUrl
nsslapd-dynamic-lists-attr: member
```

Dynamic entry

```
cn=my_dynamic_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com??sub?(uid=*)
```

The search

```
$ ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -w PASSWORD -b "dc=example,dc=com" cn=my_dynamic_group
dn: cn=my_dynamic_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com??sub?(uid=*)
member: uid=mreynolds,ou=people,dc=example,dc=com
member: uid=tbordaz,ou=people,dc=example,dc=com
member: uid=spichugi,ou=people,dc=example,dc=com
member: uid=progier,ou=people,dc=example,dc=com
member: uid=jchapman,ou=people,dc=example,dc=com
```

No matter what attribute is configured it is always populated with the DN of the entry returned by the LDAP URL.

### Example 2 - Request a special attribute "employeeNumber"

Configuration (same as the last example)

```
cn=config,cn=ldbm database,cn=plugins,cn=config
...
nsslapd-dynamic-lists-enabled: on
nsslapd-dynamic-lists-oc: groupOfUrls
nsslapd-dynamic-lists-url-attr: memberUrl
nsslapd-dynamic-lists-attr: member
```

A dynamic entry that uses an attribute "employeeNumber" in the URL causes **nsslapd-dynamic-lists-attr** to be ignored. While the LDAP standard allows for multiple attributes to be requested in an LDAP Url the server only looks at the first requested attribute.  All other requested attributes are ignored.

```
cn=dynamic_employee_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com?employeeNumber?sub?(&(objectclass=posixAccount)(uid=*))
```

The search

```
$ ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -w PASSWORD -b "dc=example,dc=com" cn=dynamic_employee_group
dn: cn=dynamic_employee_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com?employeeNumber?sub?(&(objectclass=posixAccount)(uid=*))
employeeNumber: 1001
employeeNumber: 628
```

So this search looks at each matching entry and extracts the employeeNumber attribute value and uses that to populate the dynamic entry.  So the LDAP Url controls how the dynamic content is built.  The configuration mainly just specifies the criteria for what is a dynamic entry.

### Example 3 - Multiple LDAP URLs

If the schema allows it the *dynamicListUrlAttr* attribute could be multi-valued and you can use multiple LDAP urls to build the dynamic content

```
cn=dynamic_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com??sub?(&(objectclass=posixAccount)(uid=*))
memberUrl: ldap:///ou=external_people,dc=example,dc=com??sub?(&(objectclass=posixAccount)(uid=*))
```

The search

```
$ ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -w PASSWORD -b "dc=example,dc=com" cn=dynamic_employee_group
dn: cn=dynamic_group,ou=groups,dc=example,dc=com
objectclass: top
objectclass: groupOfUrls
memberUrl: ldap:///ou=people,dc=example,dc=com??sub?(&(objectclass=posixAccount)(uid=*))
memberUrl: ldap:///ou=external_people,dc=example,dc=com??sub?(&(objectclass=posixAccount)(uid=*))
member: uid=mreynolds,ou=people,dc=example,dc=com
member: uid=tbordaz,ou=people,dc=example,dc=com
member: uid=spichugi,ou=people,dc=example,dc=com
member: uid=progier,ou=people,dc=example,dc=com
member: uid=jchapman,ou=people,dc=example,dc=com
member: uid=msmith,ou=external_people,dc=example,dc=com
member: uid=lkrispenz,ou=external_people,dc=example,dc=com
```

Origin
-------------

[1] <https://github.com/389ds/389-ds-base/issues/1793>
<br>
[2] <https://github.com/389ds/389-ds-base/issues/82>

Author
------

<mreynolds@redhat.com>

