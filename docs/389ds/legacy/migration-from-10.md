---
title: "Migration From 10"
---

# Migration from 1.0 and earlier versions
---------------------------------------

Because of the new [FHS\_Packaging](../development/fhs-packaging.html) introduced in 1.1, all of the files in /opt/fedora-ds will be moved to new locations. The ones of primary concern are the data, configuration (including schema), and security files that are instance specific.

### Steps

The migration script by default will take no arguments. It will assume that the old instance is under /opt/fedora-ds/slapd-INSTANCE. It will create the new instance using ds\_newinst.pl but will not start the server. Then it will copy all of the old data to their new locations, being careful to preserve the file and directory ownerships and permissions. The script will not remove the old data (or perhaps that will be an option, off by default), nor will it stop the old server or start the new server (or perhaps that will be an option, off by default).

The old data such as port, directory manager, etc. can be extracted from dse.ldif, and fed into ds\_newinst.pl to create the new instance.

### Where to go

The old paths are all relative to the old server instance directory, which is usually /opt/fedora-ds/slapd-INSTANCE.

|Old Path|New Path|Description|
|--------|--------|-----------|
|.|%{\_libdir}/fedora-ds/slapd-INSTANCE|Instance specific scripts - These will be generated anew by ds\_newinst.pl|
|bak|%{\_localstatedir}/lib/fedora-ds/slapd-INSTANCE/bak|database backups - these will just be copied to the new location|
|db|%{\_localstatedir}/lib/fedora-ds/slapd-INSTANCE/db|database files - these will just be copied to the new location|
|logs|%{\_localstatedir}/log/fedora-ds/slapd-INSTANCE|access, errors, and rotated log files - these will just be copied|
|config|%{\_sysconfdir}/fedora-ds/slapd-INSTANCE/|instance specific dynamic config (dse.ldif) - this will be copied and filtered through sed to change any paths, add new config directives, and remove old ones|
|config/schema|%{\_sysconfdir}/fedora-ds/slapd-INSTANCE/schema|instance specific dynamic schema - copy over 99user.ldif, and any non-standard files - the rest are generated via ds\_newinst.pl|
|shared/config|%{\_sysconfdir}/fedora-ds/slapd-INSTANCE|I think only certmap.conf needs to be copied from here|
|alias|%{\_sysconfdir}/fedora-ds/slapd-instance|the key and cert dbs will have to be renamed e.g. alias/slapd-instance-cert8.db to slapd-instance/cert8.db - same with key3.db and pin.txt - will also copy secmod.db|


