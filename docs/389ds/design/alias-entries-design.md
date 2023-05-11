---
title: "Alias Entries Plugin Design"
---

# Alias Entries Plugin Design
----------------

Overview
--------

The feature/plugin was implemented to support Object Aliases (or *Alias Entries*) from [RFC 4512](https://www.rfc-editor.org/rfc/rfc4512#section-2.6).  The plugin currently only works for *Base Level* searches.  It will check if the base entry contains the objectclass "**alias**" and has the attribute "**aliasedObjectName**" which contains a DN to another entry (aka an alias to another entry).  The plugin will then change the search base DN to this aliased DN and return that entry instead.

If the defined alias DN does not exist, or there is a failure finding the aliased object, the search wil return an error tothe clinet.  If the a non-base level search is used to try and dereference an alias object then an error 53 (unwilling to perform) error will be returned to the client.

Major configuration options and enablement
------------------------------------------

There is a new plugin:  **cn=Alias Entries,cn=plugins,cn=config**  

It is not enabled by default.


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/152>

Author
------

Original open source contributor:  @anilech

This work was refactored/updated by: <mreynolds@redhat.com>

