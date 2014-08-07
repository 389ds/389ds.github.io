---
title: "Matching Rule API"
---

# Matching Rule API
-------------------

{% include toc.md %}

### Introduction

We need to make the value comparison and index key generation functions matching rule aware. Most places in the server just assume the attribute should just use whatever is provided by the syntax via the syntax plugin, without taking into consideration the EQUALITY, ORDERING, and SUBSTR matching rules defined for the attribute in the schema. The current matching rule plugin API is really only useful for extensible match filters. We need to replace the current server API with one that is matching rule aware.

Functions that deal directly or indirectly with syntax plugins:

slapi\_attr\_type2plugin(const char \*type, void \*\*pi)
--------------------------------------------------------

### called from str2entry\_dupcheck

Used to get the syntax plugin for valuetree\_add\_valuearray() and valuetree\_add\_value()

Used to get the compare function (via plugin\_call\_syntax\_get\_compare\_fn) for duplicate comparison

The syntax plugin is passed to valuetree\_add\_valuearray() and valuetree\_add\_value() - valuetree\_add\_value() just calls valuetree\_add\_valuearray() - valuetree\_add\_valuearray() uses the plugin to call slapi\_call\_syntax\_values2keys\_sv() to get the EQUALITY keys for duplicate checking - so we could just pass in the equality matching rule syntax plugin instead, or better yet, find the right plugin to call based on the given attribute name (first parameter to valuetree\_add\_valuearray() is const char \*type), or if it is too expensive to look up the right plugin to use every time from the attribute type name, have a new function that takes a Slapi\_Attr \* instead, and store the plugin in the Slapi\_Attr.

The compare function is used only for equality - replace with plugin\_call\_syntax\_filter\_ava()

### called from slapi\_attr\_get\_syntax\_oid\_copy

Used to get the oid of the syntax of the given attribute - this function is primarily used to determine if the given attribute has DN syntax.

### called from get\_normalized\_value in filtercmp.c

Used to call slapi\_call\_syntax\_values2keys\_sv() to get the equality keys

### called from ava\_candidates in filterindex.c

Used to call slapi\_call\_syntax\_assertion2keys\_ava\_sv() - looks like only used for EQUALITY or APPROX but not sure

### called from range\_candidates in filterindex.c

Used to call slapi\_call\_syntax\_assertion2keys\_ava() - range implies ORDERING here

### called from substring\_candidates in filterindex.c

Used to call slapi\_call\_syntax\_assertion2keys\_sub\_sv - SUBSTR

### called from vlv\_trim\_candidates\_byvalue

Used to call slapi\_call\_syntax\_values2keys to get the EQUALITY keys, and to call plugin\_call\_syntax\_get\_compare\_fn() to get the compare function. The compare\_fn here must be able to collate - not just used for equality - that implies ORDERING if available, otherwise fallback to syntax compare function

### called from attr\_index\_config

The struct attrinfo has a member ai\_plugin which holds the syntax plugin - we will probably need to add separate plugins for the eq, ord, and sub matching rules - also used to get the compare function if needed (user specified an ordering matching rule in the index config, or the attribute schema def has ORDERING)

### \*called from sort\_candidates

Used to call plugin\_call\_syntax\_get\_compare\_fn to get the compare function for sort ordering for each attribute -

### called from vlvIndex\_init

The vlvIndex structure has a member called vlv\_syntax\_plugin which is an array of syntax plugins, one for each attribute type in the spec

### called from slapi\_dn\_syntax\_check

Used to get the dn syntax plugin for syntax validation

### called from slapi\_mods\_syntax\_check

Used for syntax validation

slapi\_call\_syntax\_values2keys[\_sv]( void \*vpi, Slapi\_Value \*\*vals, Slapi\_Value \*\*\*ivals, int ftype )
----------------------------------------------------------------------------------------------------------------

### called from valuetree\_add\_valuearray

Used to get the equality keys - vpi is passed in as an argument to valuetree\_add\_valuearray - see above valuetree\_add\_valuearray() about how we could find the matching rule plugin instead

### called from valuetree\_find

Used to get the equality keys - vpi is the struct slapi\_attr a\_plugin field which is just the base syntax plugin - could store the eq matching rule plugin in struct slapi\_attr

### called from get\_normalized\_value

Used to get the equality keys - vpi is from the call to slapi\_attr\_type2plugin - lookup eq mr plugin from ava type - or possibly store correct plugin to use in struct slapi\_filter

### called from vlv\_create\_key

Used to get the equality keys - vpi is from vlv\_syntax\_plugin which is from slapi\_attr\_type2plugin from vlvIndex\_init (see above) - the function does ordering using slapi\_berval\_cmp, which assumes the keys returned are normalized, but not necessarily ordered (e.g. could use syntax keys if no ordering matching rule was specified) - could change vlvIndex\_init to lookup ORDERING plugin, error and/or fallback to syntax plugin

### called from index\_addordel\_values\_ext\_sv

Used to generate equality, approx, substr index keys - vpi is from the struct attrinfo ai\_plugin field - change struct attrinfo to add eq, ord, and sub mr syntax plugins

### called from vlv\_build\_candidate\_list\_byvalue

Used to generate the vlv key to look for - vpi is from vlv\_syntax\_plugin[0] from vlvIndex\_Init

### called from vlv\_trim\_candidates\_byvalue

See above

slapi\_call\_syntax\_assertion2keys\_ava\_sv( void \*vpi, Slapi\_Value \*val, Slapi\_Value \*\*\*ivals, int ftype )
-------------------------------------------------------------------------------------------------------------------

### called from ava\_candidates

Used to generate keys based on type of comparison - vpi is from call to slapi\_attr\_type2plugin in same function - probably need to extend slapi\_attr\_type2plugin to return mr plugin based on type needed

### called from range\_candidates

Used to generate equality keys for ordering - vpi is from call to slapi\_attr\_type2plugin in same function - should use ordering plugin if available, or equality, or regular syntax plugin fallback

slapi\_call\_syntax\_assertion2keys\_sub
----------------------------------------

### called from substring\_candidates

Used to get substring keys - vpi is from call to slapi\_attr\_type2plugin in same function

struct slapdplugin \*plugin\_syntax\_find( const char \*nameoroid )
-------------------------------------------------------------------

### attr\_syntax\_create

`a.asi_plugin = plugin_syntax_find( attr_syntax );

### read\_at\_ldif

Used in schema verification, to see if specified syntax is supported

void plugin\_syntax\_enumerate( SyntaxEnumFunc sef, void \*arg )
----------------------------------------------------------------

### read\_schema\_dse

Used with schema\_syntax\_enum\_callback to list all officially supported ldapSyntaxes

struct slapdplugin \*slapi\_get\_global\_syntax\_plugins()
----------------------------------------------------------

### read\_config\_dse

Lists plugins in nsslapd-plugin attribute

char \*plugin\_syntax2oid( struct slapdplugin \*pi )
----------------------------------------------------

### slapi\_attr\_get\_syntax\_oid\_copy

### schema\_attr\_enum\_callback

`syntaxoid = plugin_syntax2oid(asip->asi_plugin);

### read\_at\_ldif

lookup parent syntax for attribute superior

### attr\_index\_config

used to call slapi\_matchingrule\_is\_ordering()

int plugin\_call\_syntax\_get\_compare\_fn(void \*vpi, value\_compare\_fn\_type \*compare\_fn)
----------------------------------------------------------------------------------------------

### str2entry\_dupcheck

for duplicate value checking

### vlv\_trim\_candidates\_byvalue

### attr\_index\_config

For key ordering - implies ORDERING

### valuearray\_minus\_valuearray

used for qsort for values - implies ORDERING

### sort\_candidates

Notes
=====

The server code is mostly hardwired to expect that the equality, ordering, substring, and the corresponding index key generation are handled by the syntax plugin for the attribute. The matching rule plugins are only used with extensible filters, not with regular filters.

I think what we need are parallel functions for each function in plugin\_syntax.c that takes a Slapi\_Attr as an argument instead of the plugin. Some of them already work that way e.g. plugin\_call\_syntax\_filter\_ava(), but some do not e.g. slapi\_call\_syntax\_values2keys(). So for the latter, we would need a function slapi\_call\_syntax\_values2keys\_attr() or something like that which takes as the first argument a Slapi\_Attr \*attr instead of void \*plugin.

The Slapi\_Attr would be extended to have a field not only for the syntax plugin but also for the equality, ordering, and substring plugin. The current behavior would be preserved by having the functions that use these new fields fall back to the syntax plugin if no eq, ord, or sub plugin was specified for the attribute.

struct asyntaxinfo would be extended the same way - fields for asi\_eq\_plugin, asi\_ord\_plugin, and asi\_sub\_plugin would be added. These would be set when the attribute definitions are read in, much the same way as the asi\_plugin field is set based on the syntax oid now.

The tricky part would be changing the way we use functions like valuetree\_add\_valuearray() and valuetree\_add\_value() that take the plugin as a value. These functions always want to use the EQ matching and key generation. We would need to make sure we either pass in the eq plugin, or use a different API that takes the attribute name and dynamically looks up which plugin to use based on the usage. There may be other places in the code that look up the plugin first, without any knowledge of what usage the plugin will have, so those places will probably need to be changed to just pass in the attribute name/slapi\_attr and usage rather than the plugin.

The new eq, ord, and sub plugins will just be plain old syntax plugins. I had considered having them be matching rule plugins, but the matching rule plugin API is really designed for the extensible matching filters and i18n collation. It would be difficult to make it fit in with the way the syntax plugins are used. Using the syntax plugin API, for example, an eq syntax plugin will not provide functions for slapi\_call\_syntax\_assertion2keys\_sub(), only for slapi\_call\_syntax\_assertion2keys\_ava(). Conversely, a sub syntax plugin will not provide slapi\_call\_syntax\_assertion2keys\_ava(), only slapi\_call\_syntax\_assertion2keys\_sub(), etc. That way, we don't need another plugin type, we shouldn't need to extend the current syntax plugin API, and it should be easy for the existing syntax plugin code to register these new "matching rule" syntax plugins using their OID and name.
