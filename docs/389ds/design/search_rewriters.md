---
title: "Directory Server extend usability of filter rewriters and computed attributes"
---
    
# filter rewriters and computed attributes
----------------

{% include toc.md %}

This document describes a generic plugins that simplify the use and deployement of filter rewriters and computed attributes

Overview
--------

Directory servers [plugin API](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/index) supports filter rewriters ([slapi_compute_add_search_rewriter](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/plugin_programming_guide-function_reference-slapi_compute_add_search_rewriter) and computed attributes [slapi_compute_add_evaluator](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/plug-in_guide/plugin_programming_guide-function_reference-functions_for_managing_computed_attributes#Plugin_Programming_Guide-Function_Reference-slapi_compute_add_evaluator).
Those functions register callbacks that will be called at specific points of a SRCH request.  In addition to callbacks funtion, a developper needs to write a new plugin shared library (under <i>/usr/lib/dirsrv</i>), registers the callback and configure the plugin.
This document describes a generic plugin that handle all the plugin requirements. Then the developper has only to write the callback and let the plugin registers it (via a simple configuration entry).

Use Cases
---------

DS contains group with <i>'member'</i> attribute as membership attribute. An application (i.e. vsphere) needs to lookup those group assuming those group contains <i>'uniquemember'</i> attributes and expect to receive entries with <i>'uniquemember'</i>. For a developper one option to get this result is to write a new plugin and configure it. The plugin starting function registering filter rewriters (<i>'uniquemember'</i> -> <i>'member'</i>) and computed attributes (<i>'member'</i> -> <i>'uniquemember'</i>) callbacks.
It would be much easier for the developper to simply write the callbacks and let the server know their name.

Another case is a use of shortcut values for in filters. An AD application sends filter with <i>objectCategory=foo</i>. AD application expects the filter to be rewrite into <i>objectCategory=cn=foo,cn=schema,...</i>. The developper will write the callback function and update the generic plugin configuration to register this callback as a filter rewriter.

# Design
------

## Configuration entries
------------------

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

## rewriters subentries

The generic plugin configuration entry have children an each of the children define the application specific rewriters (filter or computed attributes).

cn=ADrewrite,cn=srchRewriter,cn=plugins,cn=config
objectClass: top
objectClass: extensibleObject
cn: objectCategory
nsslapd-libPath: libadrewrite-plugin
nsslapd-filterRewriter: objectcategory_filter_rewrite
nsslapd-filterRewriter: objectSID_rewrite
nsslapd-returnedAttrRewriter: givenname_rewrite
nsslapd-returnedAttrRewriter: objectcategory_returnedAttr_rewrite

## callback registration

At startup, when the generic plugin is enabled, it calls the plugin startup function. It reads the generic plugin children and for each of them,
it retrieves the shared library <b>nsslapd-libPath</b> (either absolute path or relative to /lib/dirsrv/plugin). Then the startup function loads the symbols in <b>nsslapd-filterRewriter</b> or <b>nsslapd-returnedAttrRewriter</b>. <b>nsslapd-filterRewriter</b> callbacks are registered as filter rewriter (slapi_compute_add_search_rewriter) while <b>nsslapd-returnedAttrRewriter</b> are registered as computed attributes (slapi_compute_add_evaluator).


Implementation
--------------

A prototype was discussed with [50931](https://pagure.io/389-ds-base/pull-request/50939)

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

