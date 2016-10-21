---
title: AD DN bind plugin usage
---

# Introduction
--------------

Ldap binds are often difficult for end users. They involve a syntax like:

    ldapwhoami -x -D 'uid=william,ou=People,dc=example,dc=com' ...

This is normally hard to remember. Additionally, there was no way to remap these to other backends or rewrite these names.

To help with this, we have added an Active Directory style bind plugin. This allows:

    ldapwhoami -x -D 'william' ...
        dn: uid=william,ou=people,dc=example,dc=com
    ldapwhoami -x -D 'william@example.com' ...
        dn: uid=william,ou=people,dc=example,dc=com

# Configuration
---------------

Add the following base config to cn=config. This is an ldif modify file you can use:

    dn: cn=addn,cn=plugins,cn=config
    changetype: add
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: addn
    nsslapd-pluginPath: libaddn-plugin
    nsslapd-pluginInitfunc: addn_init
    nsslapd-pluginType: preoperation
    nsslapd-pluginEnabled: on
    nsslapd-pluginId: addn
    nsslapd-pluginVendor: 389 Project
    nsslapd-pluginVersion: 1.3.6.0
    nsslapd-pluginDescription: Allow AD DN style bind names to LDAP
    addn_default_domain: example.com

    dn: cn=example.com,cn=addn,cn=plugins,cn=config
    changetype: add
    objectClass: top
    objectClass: extensibleObject
    cn: example.com
    addn_base: ou=People,dc=example,dc=com
    addn_filter: (&(objectClass=account)(uid=%s))

Restart the server for the plugin to be loaded and take effect.

# Operation
-----------

When a bind is requested the name is checked to see if it is a valid DN. IE:

    uid=william,ou=People,dc=example,dc=com

If it is valid, we do not alter it. If it is *invalid* we then begin to look.

If the DN has *no* @domain component, we append the default domain from addn_default_domain. IE

    ldapwhoami -x -D 'william' ...
        # Internally becomes william@example.com
        dn: uid=william,ou=people,dc=example,dc=com


With the default domain, or the domain requested we then retrieve a mapping from cn=<domain>,cn=addn,cn=plugins,cn=config.

If no mapping exists, the plugin returns and continues (the bind will fail)

If a mapping does exist, we then get the addn_base and addn_filter.

The addn_base is the subtree we will perform a subtree search under while applying filter.

With the filter, we replace %s with the <username>@domain component. IE

    ldapwhoami -x -D 'william' ...
        # Internally becomes william@example.com
        # username == william, domain == example.com
        # Retrieve mapping cn=example.com,cn=addn,cn=plugins,cn=config
        # ldapsearch -b ou=People,dc=example,dc=com '(&(objectClass=account)(uid=william))'
        dn: uid=william,ou=people,dc=example,dc=com


If the plugin finds ONE and ONLY ONE object, we then replace the dn, for the final result of uid=william,ou=people,dc=example,dc=com.

# Features
----------

You may configure multiple maps. A user may be resolved from any number of mappings. IE

    dn: cn=example.com,cn=addn,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: example.com
    addn_base: ou=People,dc=example,dc=com
    addn_filter: (&(objectClass=account)(uid=%s))

    dn: cn=test.example.com,cn=addn,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: test.example.com
    addn_base: ou=People,dc=example,dc=com
    addn_filter: (&(objectClass=account)(uid=%s))


Then we can test this:

    ldapwhoami -x -D 'william@example.com' ...
        dn: uid=william,ou=people,dc=example,dc=com
    ldapwhoami -x -D 'william@test.example.com' ...
        dn: uid=william,ou=people,dc=example,dc=com


# Limits
--------

There can NOT be multiple matching objects returned. IE

    uid=william,ou=a,ou=people,dc=example,dc=com
    uid=william,ou=b,ou=people,dc=example,dc=com

The addn plugin will immediately fail. We expect to find unique dn's only!

addn_filter may contain ONE and ONLY ONE %s substitution. Use it wisely.

We must return an entry from our search: But this could be from a chained backed, a real backend, or some other means. This is because we need to guarantee the DN we are about to map to is real and exists. We don't want to enable some weird security issue by remapping to dns that don't exist.


# Author
--------

William Brown (wibrown at redhat.com)

