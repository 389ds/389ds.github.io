---
title: "Dynamic Plugins"
---

# Dynamic Plugins
-----------------

{% include toc.md %}

Overview
-----------------

Plugins can now be added/deleted(enabled/disabled) without restarting the server. All plugin configuration changes are also dynamically applied. There have been a few new functions added to the Slapi-Plugin API that plugins would need to use in order to work in the dynamic environment. This feature can be turned on or off, the current default for 1.3.3 is "off".

Use Cases
-----------------

Restarting the directory server does take some time to complete. Software applications that use the server, like freeIPA, can take a long time to install due to the many restarts required to enable and configure plugins. Also, in production environments restarting the server is not always an option; allowing for dynamic updates makes server administration easier.

Design
-----------------

### Additions to the API

       slapi_plugin_task_new()                 --> replaces:  slapi_task_new()
       slapi_plugin_task_register_handler()    --> replaces:  slapi_task_register_handler()

So plugins that register tasks need to use these two functions. Using these functions prevents race conditions between disabling a plugin, and a running task that might be using resources that are about to be freed.

       slapi_config_register_callback_plugin() --> replaces:  slapi_config_register_callback()

This new register callback function is also used to prevent a callback from being used while its shutting down or being disabled.

       slapi_unregister_object_extension() --> new!

Previously, there was no way to remove an object extension.

### Internals

Since these feature allows updates to immediately happen, a reference counter(operation counter) was added to each plugin/task. That prevents situations(crashes) where a plugin is being disabled while there are operations using the plugin at the same time. Internal thread storage is used to handle the global plugin list locking, as plugins can call plugins, etc. We simply store the status of the write lock(taken or not). The current dynamic configuration design in 1.3.3 is that when a configuration change is made(library path, precedence, init function, plugin args, etc) the plugin is restarted - internally the plugin is actually deleted, and then re-added with the updated configuration. A future version of this feature might not do a "full" restart of the plugin for every configuration change.

There are now new "tasks" to do when disabling a plugin. Since plugins can now be stopped and started at any time, each plugin needs to have a close function(SLAPI\_PLUGIN\_CLOSE\_FN), and that close function needs to free and unregister everything it did when it was started/initialized: free global locks/config info, reset static flags/variables, remove callbacks, unregister object extensions, etc.

Currently, these plugins are not dynamic, and do require a server restart to take effect

       Replication Plugin    
       Access Control Plugin    
       Chaining database Plugin    
       All "database" plugins    
       Syntax/Matching Rule plugins    

Implementation
----------------

None.

Feature Management
----------------

CLI

Major configuration options and enablement
----------------

The dynamic functionality is set under cn=config

    dn: cn=config
    nsslapd-dynamic-plugins: <on|off>

Currently the default for 1.3.3 is to be "off". This can be turned on and off without a server restart.

Replication
----------------

No impact.

Updates and Upgrades
----------------

No impact.

Dependencies
----------------

No impact.

External Impact
----------------

Document change will be needed.

RFE Author
----------------

Mark Reynolds <mreynolds@redhat.com>

