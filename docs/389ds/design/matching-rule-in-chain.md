---
title: "Matching rule in chain"
---

# Matching rule in chain"
----------------

{% include toc.md %}

# Overview
---------

Matching rule in chain, LDAP_MATCHING_RULE_IN_CHAIN (1.2.840.113556.1.4.1941), is an *extensible match* for search filter. It is used to lookup ancestry of an LDAP entry. For doing this it walks the chain of ancestry and so reveal all direct or indirect membership, like 

	- (member:1.2.840.113556.1.4.1941:=uid=foo,dc=com)   # all direct or indirect groups, 'foo' is member of
	- (manager:1.2.840.113556.1.4.1941:=uid=bar,dc=com)  # all direct or indirect users 'bar' is manager of
	- (parentOrganization:1.2.840.113556.1.4.1941:=ou=baz,dc=com) # all direct or indirect organization 'baz' belongs to
	- (memberof:1.2.840.113556.1.4.1941:=cn=grp1,dc=com) # all direct or indirect members of 'grp1' group

The benefits is that with a single search request, a ldap client can retrieve the ancestry without the need to iterate thru transveral group membership.

The matching rule is limited to distinguished Names attribute.


# Use cases
-----------

	A ldap client application that retrieves all 'groupOfNames' that the user 'foo' is member of. It will use the extensible filter component
	(member:1.2.840.113556.1.4.1941:=uid=foo,dc=com)

	Note that both OID '1.2.840.113556.1.4.1941' and name 'inchainMatch' are supported.

# Configuration changes
--------------------------------------------

A Matching Rule, in 389-ds, is delivered via the syntax plugin (*/usr/lib64/dirsrv/plugins/libsyntax-plugin.so*). To register a new matchine rule, a syntax plugin (i.e. *'nsslapd-plugintype: syntax'*) is registered in the configuration of the instance (dse.ldif). The configuration entry is looking like

    dn: cn=In Chain,cn=plugins,cn=config
    objectclass: top
    objectclass: nsSlapdPlugin
    objectclass: extensibleObject
    cn: In Chain
    nsslapd-pluginpath: libsyntax-plugin
    nsslapd-plugininitfunc: inchain_init
    nsslapd-plugintype: syntax
    nsslapd-pluginenabled: on

For new installation this entry is added in *ldap/ldif/template-dse-minimal.ldif.in*.
For upgrade, the function *upgrade_server()* (*ldap/servers/slapd/upgrade.c*) creates it if it does not already exist.



# Design
--------

## description of matching rules

A matching rule defines, for a given OID/name/alias, callbacks to identify candidates that match an assertion value and callbacks to check if a given entry matches or not a give filter component.

During a search, a filter component selects (via the attribute syntax or the extensible match OID) a given matching rule. The matching rule is first called to compute the database keys that matches the assertion value (mr_values2keys). Then the searches looks from the index files, to transform each database key into a set of database IDs. So if there are a set of db keys, then it creates equivalent number of set of IDs.
In case of extensible match, the final candidate list of database ID is the **intersection** of the sets of db IDs.

In the final phase of the search, before returning a given entry, the matching rule is called to verify if filter component matches the entry.

## "In chain" matching rule

The plugin init function **inchain_init**, registers the matching rules (via *syntax_register_matching_rule_plugins*) via the names/alias **inchainMatch** and **1.2.840.113556.1.4.1941**. A consequence is that the "*In chain*" matching rule is added to the supported matching rules in the schema.

The new matching rule is defined in *ldap/servers/plugins/syntaxes/inchain.c*.

Regarding *mr_plugin_def* structure, *in chain* matching rule, 

 - mr_filter_create  NULL because it uses new style factory function
 - mr_indexer_create NULL because it uses new style factory function
 - mr_filter_ava     always return 0, matching any entries in the IDlist
                     set by the in chain mr_values2keys (see below)
 - mr_filter_sub     NULL because *in chain* only support equality match
 - mr_values2keys    returns the set of ancestry ID
 - mr_assertion2keys_ava NULL because *in chain* is not a syntax and can only
                     be called with the value of an extensible match.
                     (TBC)
 - mr_assertion2keys_sub NULL because *in chain* is not a syntax and can only
                     be called with the value of an extensible match.
                     (TBC)
 - mr_compare        NULL because *in chain* is not a syntax and can only
                     be called with the value of an extensible match.
 - mr_normalize      NULL because it is not a syntax

### mr_values2keys

*mr_values2keys* is a callback that is responsible to build, from an **assertion value** of an *extended match* filter component, the set of keys that matches the assertion.

If the syntax of *attributeType*, is not *DistinguishedName*, then it returns NULL.

It returns the **nsuniqueid** of ancestors of **assertion value**. For example '*(member:1.2.840.113556.1.4.1941:=uid=foo,dc=example)*' returns the **nsuniqueid** of all groups where *uid=foo,dc=example* is a direct or indirect '*member*'. A **nsuniqueid** is a database *key* used to look up the *nsuniqueid* index.

To implement this, the function **memberof_get_groups** should be moved out from **memberof.c** and implemented into slapi-private function. This function should return either **groupdn** or **nsuniqueids** of the groups.

mr_values2keys calls <a href="#get-the-groups">memberof_get_groups</a> and retrieves **nsuniqueids** of the groups that the target entry belongs to. We need a *database key* to retrieve, from an index, the *database ID* (entryid) of the group. The index **nsuniqueids** being faster that **entryrdn**, it is better to retrieve the **nsuniqueids**.


### mr_filter_ava

This is the callback responsible to verify that the entry matches the filter component. If direct candidate may match (i.e. a group with member '*uid=foo*' has '*member: uid=foo,dc=example*'), indirect candidate will not match. So this callback has not the capacity to check the filter component.

So *mr_filter_ava* will always return *SUCCESS* (0).

### mr_assertion2keys_ava

TBC if it needs to be implemented or not

## InChain plugin

The In chain MR is define as a new *syntax* plugin

    dn: cn=In Chain,cn=plugins,cn=config
    objectclass: top
    objectclass: nsSlapdPlugin
    objectclass: extensibleObject
    cn: In Chain
    nsslapd-pluginpath: libsyntax-plugin
    nsslapd-plugininitfunc: inchain_init
    nsslapd-plugintype: syntax
    nsslapd-pluginenabled: off
    nsslapd-pluginshortcut-member: on

Use of this MR is restricted to uses having read access to 

    dn: oid=1.2.840.113556.1.4.1941,cn=features,cn=config
    objectClass: top
    objectClass: directoryServerFeature
    oid: 1.2.840.113556.1.4.1941
    cn: InChain Matching Rule

Those two entries are present in templates: *ldap/ldif/template-dse-minimal.ldif.in* and *ldap/ldif/template-dse.ldif.in*.  To allow smooth upgrades, *ldap/servers/slapd/upgrade.c* will create those entries.

Because of the potential performance impact, this Matching Rule is **not enabled** by default and its uses is limited user allowed to read the entry **oid=1.2.840.113556.1.4.1941,cn=features,cn=config**. see (<a href="#limitations">limitations</a>)

## Get the groups

It exists in *memberof plugin*, a function that returns for a given target entry, all the direct and indirect groups that the target entry is member of.

This function is moved out of *memberof plugin* to be added as a slapi private function. The function, and all the sub-functions it depends on, are moved **servers/slapd/membership.c**. 


    typedef struct Xmemberofconfig
    {
        char **groupattrs;  /* ie 'member, uniquemember': attributes that are followed to retrieve direct
                             * and indirect members
                             */
        char *memberof_attr; /* like 'memberof': attribute to be added in the target entry */
        int allBackends;
        Slapi_DN **entryScopes; /* to resctict membership to a set of subtrees */
        int entryScopeCount;
        Slapi_DN **entryScopeExcludeSubtrees; /* to exclude some subtrees */
        int entryExcludeScopeCount;
        Slapi_Filter *group_filter;
        Slapi_Attr **group_slapiattrs;
        int skip_nested;
        int fixup_task;
        char *auto_add_oc;  /* used in fixup task */
        PLHashTable *ancestors_cache; /* caches to improve the perf and check loops */
        PLHashTable *fixup_cache;
    } MemberOfConfig;

This function uses a complex configuration structure, that is preserved. Note that this function, retrieves membership groups but also update the target entry, adding the *'memberof: group'* when it is missing. This second part (fixup) is *useless* for *mr_values2keys*, the new function should have a toggle to decide if the '*fixup*' part is needed or not.

This function is reponsible of enforcing **access control**, so that if the bound use has not access to some entries or membership attributes in the entries then the links are not followed. This function will basically behave like *deref_check_access* is doing.

RFE [\#5156](https://github.com/389ds/389-ds-base/issues/5156) is taking care of that move.

## memberof shortcut

An exstensible search using InChain MR with **member** link attribute, expects to retrieves all the groups a specific user belongs to.

	- (member:1.2.840.113556.1.4.1941:=uid=foo,dc=com)   # all direct or indirect groups, 'foo' is member of

In case **memberof plugin** is enabled, the entry uid=foo contains *'memberof'* attribute with all the groups it belongs to. In such case, using the *'memberof'* value of 'uid=foo' is a shortcut compare to reevaluated <a href="#get-the-groups">memberof_get_groups</a> for the 'uid=foo' entry. It is a pre-computed and stored attribute that 'InChain' can take benefit of.

This approach has a limitation regarding the **access control**. For example if we have the following request/setting


    ldapsearch -D "uid=requestor,ou=people,dc=com" -W -b "cn=com" "(member:1.2.840.113556.1.4.1941:=uid=foo,dc=com)" dn
        
    /* uid=requestor has access to following entries/attr except G1 */
    
    dn: G0
    member: G1
    
    dn: G1	/* uid=requestor has NOT access to that entry */
    member: G2  /* uid=requestor has NOT access to that entry */
    
    dn: G2
    member: foo
    
    dn: foo
    memberof: G0
    memberof: G1
    memberof: G2

If InChain MR uses the shortcut *'memberof'* attribute (that does not enforce ACI), the result of the ldapsearch is: G2, G1 and G0.

If InChain MR calls <a href="#get-the-groups">memberof_get_groups</a>, the result is: G2. Indeed ACI enforcement will allow the retrieval of G2. But G1 being denied, it is not returned and as a consequence neither G0 (G0 is kind of being hidden by G1).

A large set of deployments, grants search/read access rights to group membership attribute. Any bound user being allowed to see group membership of any other user. In such case, using the shortcut is valid. In others deployment, *'memberof* shortcut will be disabled and group membership will go through <a href="#get-the-groups">memberof_get_groups</a> and ACI enforcement.

To toggle those two modes the <a href="#InChain plugin">InChain plugin</a> entry contains **nsslapd-pluginshortcut-member**. Whose value is **on** by **default**. Being on, InChain plugin will use *'memberof'* attribute, else it will compute the groups that 'foo' is memberof.

## Extensible filter

The filter component is used to build a candidate list and then to verify that selected candidates really match the filter component.

When evaluating an *extensible filter* (see filterindex.c:extensible_candidate) with *1.2.840.113556.1.4.1941*, the In chain <a href="#mr_values2keys">callback</a> returns (*SLAPI_PLUGIN_MR_KEYS*) the set of database keys (*nsuniqueid*) that match the direct/nested assertion equality test.

The *nsuniqueid* index is then lookup (*indextype_EQUALITY*) to get for each key (*nsuniqueid*) the ID list. For a given *nsuniqueid*, the ID list contains one ID. The set of database keys (*nsuniqueid*) is then translated into a ID list that is the **union** (*idl_union*) of the corresponding ID of each nsuniqueid.

## limitations

Because such matching rule is expensive to compute, it is not enable by default. To enable it you need to run **dsconf instance schema matchingrules enable inChainMatch** and **dsctl instance restart**. Another option is to enable the MR by default but add a config parameter **dsconf instance config replace nsslapd-inchainmatch-enabled=on**.

The use of the *inChain* matching rule, is limited to bound user having **SLAPI_ACL_READ** access to the entry **oid=1.2.840.113556.1.4.1941,cn=features,cn=config** (similarly to *sync_feature_allowed*). If any users is allowed to use this MR just ADD the following ACI to aci: **(targetattr != "aci")(version 3.0; acl "InChain Matching Rule"; allow( read, search ) userdn = "ldap:///all";)**

For performance reasons, the membership attribute used in the InChain matching rule must be indexed. This can be tested with a new slapi-private function that export *is_indexed*.

# Tests

TBD

# Reference
-----------------

[4678](https://github.com/389ds/389-ds-base/issues/4678) and [1974236](https://bugzilla.redhat.com/show_bug.cgi?id=1974236)<br>
[user releated searches](https://ldapwiki.com/wiki/Active%20Directory%20User%20Related%20Searches)<br>
[group releated searches](https://ldapwiki.com/wiki/Active%20Directory%20Group%20Related%20Searches)<br>
[LDAP_MATCHING_RULE_IN_CHAIN](https://ldapwiki.com/wiki/LDAP_MATCHING_RULE_IN_CHAIN)<br>
[LDAP_MATCHING_RULE_TRANSITIVE_EVAL](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/1e889adc-b503-4423-8985-c28d5c7d4887)<br>

# Author
--------

<tbordaz@redhat.com>
