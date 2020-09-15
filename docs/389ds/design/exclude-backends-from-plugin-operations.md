---
title: "Exclude Backends From Plugin Operations"
---

# Exclude Backends From Plugin Operations
------------------

{% include toc.md %}

Overview
========

The Retro Changelog (RC) logs all changes into a separate backend: cn=changelog. In contrast to the MultiMaster changelog this is a regular backend and can only be accessed by normal ldap operations.
There is an ADD operation when a change is written and a DEL operation when the changelog is trimmed and a change record is deleted. As a regular backend it can also be searched by ldap clients.

But, like the MMR changelog, the only purpose of the RC is to log changes, provide them as search results and remove when no longer needed. No plugin should interfere with these operations or be able to modify them. Plugin operation on this backend triggers other internal operations and has been the cause of several deadlocks.

The goal is to be able to hide operations for this (or other) backend from plugins.

Current solution
================

The only current possibility to exclude plugins from operating on the Retro Changelog is to modify every plugin and define and handle a scope for the plugin

Suggested solution
==================

-   Define a new backend flag:

        SLAPI_BE_FLAG_DISABLE_PLUGIN_OPERATIONS

-   Define a  parameter for backend configuration entries:

        dn: cn=changelog,cn=ldbm database,cn=plugins,cn=config
        ......
        nsslapd-disable-plugin-operations: on/off

     with default set to off

- In plugin_call_plugins check the backend and backend flags for the operation and if NO_PLUGINS is set return.

Tickets
=======
* Several tickets involving deadlocks or crashes, eg: 48388
* Ticket [\#1872](https://github.com/389ds/389-ds-base/issues/1872) Exclude Backends From Plugin Operations
