---
title: "Expanded Backup Design"
---

#  Expanded Backup Design
----------------

Overview
--------

When taking a backup of the database the server will also backup schema files, dse.ldif, and certificate related files.  These files are **not** restored automatically as it could break the server.  However, they are there if needed. or if they are needed as a reference to the state of the server when the backup was taken.

Design
------

These are the files that are archived during a backup (db2bak)

- /etc/dirsrv/slapd-YOUR_INSTANCE/dse.ldif
- /etc/dirsrv/slapd-YOUR_INSTANCE/key4.db
- /etc/dirsrv/slapd-YOUR_INSTANCE/cert9.db
- /etc/dirsrv/slapd-YOUR_INSTANCE/pin.txt
- /etc/dirsrv/slapd-YOUR_INSTANCE/pwdfile.txt
- /etc/dirsrv/slapd-YOUR_INSTANCE/certmap.conf
- /etc/dirsrv/slapd-YOUR_INSTANCE/slapd-collations.conf
- /etc/dirsrv/slapd-YOUR_INSTANCE/schmea/*

These files are placed in the backup directory as follows:

- /backup_dir/config_files/dse.ldif
- /backup_dir/config_files/key4.db
- /backup_dir/config_files/cert9.db
- /backup_dir/config_files/pin.txt
- /backup_dir/config_files/pwdfile.txt
- /backup_dir/config_files/certmap.conf
- /backup_dir/config_files/slapd-collations.conf
- /backup_dir/config_files/schmea/*


Major configuration options and enablement
------------------------------------------

These files are automatically archived and do require any special CLI commands/usage


Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=2147446>

<https://github.com/389ds/389-ds-base/issues/2562>

Author
------

<mreynolds@redhat.com>

