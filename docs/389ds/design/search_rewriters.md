---
title: "Directory Server extend usability of filter rewriters and computed attributes"
---
    

{% include toc.md %}

This document describes different ways to simplify the use and deployement of filter rewriters and computed attributes

#Overview
--------

Directory servers [plugin API](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/index) supports filter rewriters ([slapi_compute_add_search_rewriter](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/plugin_programming_guide-function_reference-slapi_compute_add_search_rewriter)) and computed attributes ([slapi_compute_add_evaluator](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/plugin_programming_guide-function_reference-functions_for_managing_computed_attributes#Plugin_Programming_Guide-Function_Reference-slapi_compute_add_evaluator)).
Those plugin-API functions register callbacks that will be called at specific points of a SRCH request. A developper must write the callbacks funtions and in addition a new plugin (init, start, stop, config functions) that registers the callbacks and finally configure the plugin.

This document describes two approaches to simplify the use of those API interfaces

a generic plugin that handle all the plugin requirements. Then the developper only has to write the callbacks and let the plugin registers them (via a configuration entry).

#Use Cases
---------

DS contains group with <i>'member'</i> attribute as membership attribute. An application (i.e. vsphere) needs to lookup those groups assuming those group contain <i>'uniquemember'</i> attributes and expect to receive entries with <i>'uniquemember'</i>. For a developper one option to get this result is to write a new plugin and configure it. The plugin starting function registering filter rewriters (<i>'uniquemember'</i> -> <i>'member'</i>) and computed attributes (<i>'member'</i> -> <i>'uniquemember'</i>) callbacks.
It would be much easier for the developper to simply write the callbacks and configure the server to load them.

Another case is a use of shortcut values in filters. An AD application sends filter with <i>objectCategory=foo</i>. AD application expects the filter to be rewrite into <i>objectCategory=cn=foo,cn=schema,...</i>. The developper will write the callback function and update the generic plugin configuration to register this callback as a filter rewriter.

#Design
------

The slapi_compute_add_search_rewriter and slapi_compute_add_evaluator functions registers callbacks. They are part of plugin API but it can be called from plugin or from core server. A first approach is to create a generic plugin that retrieves callback from its configuration and registers them. A second approach is to enhance core server so that it retrieves callbacks from server config and register them.

## Generic plugin

The advantage of a generic plugin is that it benefit from the plugin framework, such as retrieval/load of entry point, dependencies and enable/disable capability

### Configuration entries

The generic plugin configuration entry is

    cn=srchRewriter,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    nsslapd-pluginPath: libsrchRewrite-plugin
    nsslapd-pluginInitfunc: srchRewriter_init
    nsslapd-pluginType: object
    nsslapd-pluginEnabled: on
    nsslapd-plugin-depends-on-type: database
    nsslapd-pluginId: srchRewriter
    nsslapd-pluginVersion: 1.4.3
    nsslapd-pluginVendor: 389 Project
    nsslapd-pluginDescription: Register filter and computed attribute rewriters
    cn: srchRewriter

### rewriters subentries

The generic plugin configuration entry has children. Each child defines the application specific rewriters (filter or computed attributes).
Rewriters are multivalued attributes. Note that the order of execution of the rewriters is not defined.

    cn=ADrewrite,cn=srchRewriter,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: ADrewrite
    nsslapd-libPath: libadrewrite-plugin
    nsslapd-filterRewriter: objectcategory_filter_rewrite
    nsslapd-filterRewriter: objectSID_rewrite
    nsslapd-returnedAttrRewriter: givenname_returnedAttr_rewrite
    nsslapd-returnedAttrRewriter: objectcategory_returnedAttr_rewrite

### callback registration

At startup, when the generic plugin is enabled, it calls the plugin startup function. The function reads the generic plugin children and for each of them,
it retrieves the shared library <b>nsslapd-libPath</b> (either absolute path or relative to /lib/dirsrv/plugin). Then the startup function loads the callback in <b>nsslapd-filterRewriter</b> or <b>nsslapd-returnedAttrRewriter</b>. Then <b>nsslapd-filterRewriter</b> callbacks are registered as filter rewriter (slapi_compute_add_search_rewriter) while <b>nsslapd-returnedAttrRewriter</b> are registered as computed attributes (slapi_compute_add_evaluator).

## Core server

### Configuration entries

During server startup, children of <b>cn=rewriters,cn=config</b> will be loaded and callback registered

    cn=rewriters,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: rewriters
    
    cn=ADrewrite,cn=rewriters,cn=config
    objectClass: top
    objectClass: rewriterEntry
    cn: ADrewrite
    nsslapd-libPath: /lib/dirsrv/librewriters.so
    nsslapd-filterRewriter: adfilter_rewrite_objectCategory
    nsslapd-filterRewriter: adfilter_rewrite_objectsid
    nsslapd-returnedAttrRewriter: adfilter_return_givenname
    nsslapd-returnedAttrRewriter: adfilter_return_surname
    
    cn=vsphere,cn=rewriters,cn=config
    objectClass: top
    objectClass: rewriterEntry
    cn: vsphere
    nsslapd-libPath: /lib/dirsrv/libvsphere
    nsslapd-filterRewriter: libvsphere_rewrite_uniquememeber
    nsslapd-returnedAttrRewriter: libvsphere_return_member

### callback registration

At server startup, once all plugins have been started, a <b>rewriter_init</b> function reads <b>cn=rewriters,cn=config</b> children and for each of them,
it retrieves/load the shared library <b>nsslapd-libPath</b> (either absolute path or relative to /lib/dirsrv/plugin). Then <b>nsslapd-filterRewriter</b> callbacks are registered as filter rewriter (slapi_compute_add_search_rewriter) while <b>nsslapd-returnedAttrRewriter</b> are registered as computed attributes (slapi_compute_add_evaluator).

## Performance consideration

Implementing rewriter enhance virtual attribute support (in addition to cos, slapi-nis, views, roles..).
It has always been a long debate if an attribute needs to be virtual or real. There is no final decision but advantages/drawback that need to be evaluated for both options

## virtual attributes

Virtual attributes can accelerate the write path of the server. Indeed virtual attribute may be completely ignored during write operation or sometime trigger a cache update that is rapid and do not impact write. The drawback is that there is no index for the attribute.

Virtual attribute makes the search more expensive. Filter can be transformed, components with virtual attribute are not indexed. Virtual attribute need to generated on the fly (service provider or computed attribute) in candidate entries and filter systematically reevaluated.

Virtual attribute allows to give different "views" of a same database. So without the need to modify all the entries virtual attributes allow to match LDAP client needs. This means the admin can avoid a <b>fixup</b> phase to update all the entries to be used by a specific application. It also avoid additional updates (mep, memberof) that impact response time and replication trafic of those additional updates.

It introduces some "magic" in the server that make things more complex to understand, support and maintain.

## real attributes

Real attributes are simple to understand, support and maintain. They impact write response time because it increases the size of the update and possibly trigger additional updates.

The benefit is that real attributes are indexed and accelerate SRCH operations.

If several "views" are required to match some application needs, this is at the cost of extra updates and possibly <b>fixup</b> phase. 

Final database result is larger DB files that can impact disk space and backup/restore tasks.

Implementation
--------------

A prototype (generic plugin) was discussed with [50931](https://github.com/389ds/389-ds-base/pull/3992)

Major configuration options and enablement
------------------------------------------

Updates and Upgrades
--------------------

No impact on update/upgrades

Dependencies
------------

rewriter shared library should be loadable by DS core server

External Impact
---------------

389-ds project is not responsible of external rewriters

Author
------

tbordaz@redhat

