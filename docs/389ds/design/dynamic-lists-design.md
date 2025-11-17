---
title: "Dynamic Lists Design"
---

# Dynamic Lists
----------------

Overview
--------

Dynamic lists are designed to perform an internal search to build up an entries content. The most common use case would be for groups, or aka **Dynamic Groups**. There is a new plugin called **cn=Dynamic Lists,cn=plugins,cn=config** where you can configure which objectclass an entry must have to identify it was a dynamic entry, which attribute contains an LDAP URI, and which attribute will get populated with the dynamic data. This attribute that contains the dynamic data will contain the DN of the matching entries, but this can be bypassed to use a different attribute/value from the matching entries by requesting an attribute in the LDAP URI.  More on this later...

Design
------

This feature is implemented as a preoperation entry plugin. When returning the result to the client, if the entry matches the dynamic list parameters (it has the objectclass and URL attribute), it will perform an internal search using the LDAP URI to find the content to populate the resulting entry with:

```
#0  dynamic_lists_pre_entry (pb=0x50800051c020) at ldap/servers/plugins/dynamic_lists/dynamic_lists.c:162
#1  plugin_call_func (list=0x517000023400, operation=operation@entry=410, pb=pb@entry=0x50800051c020, 
    call_one=call_one@entry=0) at ldap/servers/slapd/plugin.c:1996
#2  plugin_call_list (list=<optimized out>, operation=410, pb=0x50800051c020) at ldap/servers/slapd/plugin.c:1939
#3  plugin_call_plugins (pb=0x50800051c020, whichfunction=<optimized out>) at ldap/servers/slapd/plugin.c:414
#4  send_ldap_search_entry_ext (pb=<optimized out>, e=0x510000550640, ectrls=<optimized out>, 
    attrs=0x502000483090, attrsonly=<optimized out>, send_result=send_result@entry=0, nentries=<optimized out>, urls=<optimized out>)
    at ldap/servers/slapd/result.c:1643
#5  send_ldap_search_entry (pb=<optimized out>, e=<optimized out>, ectrls=<optimized out>, attrs=<optimized out>, 
    attrsonly=<optimized out>) at ldap/servers/slapd/result.c:1206
#6  send_entry (pb=0x50800051c020, e=<optimized out>, operation=0x5150000f0300, attrs=<optimized out>, 
    attrsonly=<optimized out>, pnentries=<optimized out>) at ldap/servers/slapd/opshared.c:1204
#7  iterate (send_result=1, pb=0x50800051c020, be=0x5100002c2c40, pnentries=0x7f6cb9b3c090, pagesize=-1, pr_statp=0x7f6cb9b3c060)
    at ldap/servers/slapd/opshared.c:1390
#8  send_results_ext.constprop.0 (pb=pb@entry=0x50800051c020, nentries=nentries@entry=0x7f6cb9b3c090, pagesize=<optimized out>, 
    pr_stat=pr_stat@entry=0x7f6cb9b3c060, send_result=<optimized out>) at ldap/servers/slapd/opshared.c:1607
#9  op_shared_search (pb=pb@entry=0x50800051c020, send_result=send_result@entry=1)
    at ldap/servers/slapd/opshared.c:943
#10 do_search (pb=<optimized out>) at ldap/servers/slapd/search.c:411
...
```

The LDAP URL can only be run locally and will not query a remote server.  This is why we reference it as a URI as the host/port are ignored:

    ldap:/// <_BASE_DN_> ? <_ATTRIBUTE_> ? <_SCOPE_> ? <_FILTER_>
    
    ldap:///ou=people,dc=example,dc=com??one?(&(objectclass=posixAccount)(uid=*))
    
If the *scope* is not specified then a scope of "base" is assumed, and this is probably not desired. So don't forget to set the search scope (base, one, sub)
    
As previously mentioned you can override what attribute/content is added to the resulting entry by specifying an *attribute* in the LDAP URI

    ldap:///ou=people,dc=example,dc=com?mail?one?(&(objectclass=posixAccount)(uid=*))
    
Here we set **mail** as the requested attribute.  The plugin will take the "mail" attribute and value and add it the resulting entry.  Note, the attribute specified in the plugin configuration (*dynamicListAttribute*) is now bypassed and will **not** be written to the dynamic entry.  See the Example section to see how this looks.

WARNING - you can not use a search filter to check what the dynamic content will be because the content is not added until we are already returning the entry to the client. The search filter must match the entry before the content is added.

Major configuration options and enablement
------------------------------------------

```
dn: cn=Dynamic Lists,cn=plugins,cn=config
objectclass: top
objectclass: nsSlapdPlugin
objectclass: extensibleObject
cn: Dynamic Lists
nsslapd-pluginpath: libdynamic-lists-plugin
nsslapd-plugininitfunc: dynamic_lists_init
nsslapd-plugintype: preoperation
nsslapd-pluginenabled: off
nsslapd-pluginDescription: dynamic lists plugin
nsslapd-pluginId: dynamic-lists
dynamicListObjectclass: groupOfUrls
dynamicListUrlAttr: memberUrl
dynamicListAttr: member
```

- **dynamicListObjectclass** specifies the objectclass that an entry must have to be considered a dynamic entry
- **dynamicListUrlAttr** specifies the attribute in the dynamic entry that contains the LDAP URI
- **dynamicListAttr** specifies the attribute that will contain the DN of the entries that match the LDAP URI. This attribute stores the DN of an entry, so the attribute configured **MUST** have a DN syntax. Note - this can be bypassed by requesting an attribute in the LDAP URI (See Examples section)

You can also use a *shared config entry* with this plugin.  The benefit here is that the configuration will replicate to all the servers for easier management.

    nsslapd-pluginConfigArea: cn=dynamic lists config,dc=example,dc=com
    
It is important to note that all configuration changes require *restarting* the server. This was done in favor of performance so the server does not have to take any mutex locks to protect the configuration settings. 
    
CLI Usage
---------

Here are the core options in the CLI
```
usage: dsconf instance [-v] [-j] plugin dynamic-lists [-h] {show,enable,disable,status,set,config-entry} ...

positional arguments:
  {show,enable,disable,status,set,config-entry}
                        action
    show                Displays the plugin configuration
    enable              Enables the plugin
    disable             Disables the plugin
    status              Displays the plugin status
    set                 Edit the plugin settings
    config-entry        Manage the config entry
```

Here are the "set" options

```
usage: dsconf [-v] [-j] instance plugin dynamic-lists set [-h] [--objectclass OBJECTCLASS] [--url-attr URL_ATTR]
                                                          [--list-attr LIST_ATTR] [--config-entry CONFIG_ENTRY]
options:
  -v, --verbose         Display verbose operation tracing during command execution
  -j, --json            Return result in JSON object
  -h, --help            show this help message and exit
  --objectclass OBJECTCLASS
                        Specifies the objectclass to identify entry that has a dynamic list (dynamicListObjectclass)
  --url-attr URL_ATTR   Specifies the attribute that contains the URL of the dynamic list (dynamicListUrlAttr)
  --list-attr LIST_ATTR
                        Specifies the attribute used to store the values of the dynamic list. The attribute must have a DN syntax
                        (dynamicListAttr)
  --config-entry CONFIG_ENTRY
                        The value to set as nsslapd-pluginConfigArea
```

And finally here are the config-entry options

```
usage: dsconf [-v] [-j] instance plugin dynamic-lists config-entry [-h] {add,set,show,delete} ...

positional arguments:
  {add,set,show,delete}
                        action
    add                 Add the config entry
    set                 Edit the config entry
    show                Display the config entry
    delete              Delete the config entry and remove the reference in the plugin entry
```

Examples
--------

Here are some different configurations and how it will impact the search

### Example 1 - Standard configuration

Plugin configuration

```
dynamicListObjectclass: groupOfUrls
dynamicListUrlAttr: memberUrl
dynamicListAttr: member
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

Plugin configuration (same as the last example)

```
dynamicListObjectclass: groupOfUrls
dynamicListUrlAttr: memberUrl
dynamicListAttr: member
```

A dynamic entry that uses an attribute "employeeNumber" in the URL causes **dynamicListAttr** to be ignored. While the LDAP standard allows for multiple attributes to be requested in an LDAP Url the plugin only looks at the first requested attribute.  All other requested attributes are ignored.

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

So this search looks at each matching entry and extracts the employeeNumber attribute value and uses that to populate the dynamic entry.  So the LDAP Url controls how the dynamic content is built.  The plugin configuration mainly just specifies the criteria for what is a dynamic entry.

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
memberUrl: ldap:///ou=people,dc=example,dc=com?employeeNumber?sub?(&(objectclass=posixAccount)(uid=*))
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

