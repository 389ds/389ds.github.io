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

Use a mechanism similar to the guardian file which is used to detect disorderly shutdowns. The restore or import process
writes a marker file which cna be detected at startup. If the file exists a backend flag is set so that plugin can detect
a previous restore.

## New backend flags

Two new backed flags are defined, they are set during startup:

    SLAPI_BE_FLAG_POST_IMPORT   /* the backend was imported since the last shutdown */
    SLAPI_BE_FLAG_POST_RESTORE  /* the database is restored and this is the first startup */


## Writing Restore or Import File

The mechanism is the same for import and restore. At the beginning of the process an empty file is created.
If the file cannot be created the process is aborted with an error message.

After successful completion of the import or restore a succes message is written to the file.

In the restore process (bak2db) writes a restore file to the database directory:

    <path-to-database>/.restore

Since the db directory is recreated during the restore the initial file creation has to be in the parent directory of "db".
To avoid accidentally delete the file is created as hidden file.
If the restore succeeds, the file is updated. So an attempted restore could be distinguished from a successful restore.

In the import process (ldif2db) writes an import file:

    <path-to-database>/db/.import_<backend>

Since the backend directory is recreated during the import the initial file creation has to be in the parent directory of the backend, the backen is part of the file name.
To avoid accidentally delete the file is created as hidden file.
If the import succeeds, the file is updated. So an attempted import could be distinguished from a successful import.

## Startup Checks

### Check for restore

A restore affects all backends, t startup the existence of the "restore" file is checked and if it exists the flag in all backends has to be set.
It is checked before the backends are started and the state is stored in a private variable:

    is_restart_after_restore 

when the backends are started, the state can be determined via a function

    slapi_is_restore_startup()

and the "post_restore" flag i


    SLAPI_BE_FLAG_POST_RESTORE

will be set. It can be detected by calling:


    slapi_be_is_flag_set(be, SLAPI_BE_FLAG_POST_RESTORE)



### Check for import


When a backend instance is started the existence of an "import" file in the backend directoty is checked and if it exists the flag

    SLAPI_BE_FLAG_POST_IMPORT

is set in the backend and the file is removed. The flag can be detected by calling:

    slapi_be_is_flag_set(be, SLAPI_BE_FLAG_POST_IMPORT)


Tickets
=======
* Ticket [\#48402](https://fedorahosted.org/389/ticket/48402) allow plugins to detect a restore or import
