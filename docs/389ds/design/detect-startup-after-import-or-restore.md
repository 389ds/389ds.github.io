---
title: "Detect import or restore at startup"
---

# Detect import or restore at startup
------------------

{% include toc.md %}

Overview
========

After a database restore or a ldif import the MMR changelog and the RetroChangelog are not guranteed to match the state of the database. There is no way for plugins
to detect that the server was started after an import or a restore.
Note: After an online initialization a plugin can handle the backend state change.

Current solution
================

For the MMR changelog at startup a comparison of the changelog RUV and the database RUV is performed and the changelog eventually recreated.

For the Retro Changelog no such mechanism exists.

Suggested solution
==================

Use a mechanism similar to the guardian file which is used to detect disorderly shutdowns.


## Resore or Import
In the restore process (bak2db) write a restore file to the database directory:

    <path-to-database>/db/restore

The file needs no content, only the presence will be checked, but could contain a timestamp or reference to the backup directory


In the import process (ldif2db) write an import file:

    <path-to-database>/db/<backend>/import

The file needs no content, only the presence will be checked, but could contain a timestamp or reference to the backup directory

## Startup

### Check for restore

At startup the existence of the "restore" file is checked. If it exists the variable:

    is_restart_after_restore 

is set (like is_disordely_shutdown) and the file removed. The state can be determined via a function

    slapi_is_restore_startup()



### Check for import


When a backend instance is started the existence of an "import" file in the backend directoty is checked. A new flag

    SLAPI_BE_FLAG_POST_IMPORT

is set in the backend and the file is removed. The flag can be detected by calling:

    slapi_be_is_flag_set(be, SLAPI_BE_FLAG_POST_IMPORT)


Tickets
=======
* Ticket [\#48402](https://fedorahosted.org/389/ticket/48402) allow plugins to detect a restore or import
