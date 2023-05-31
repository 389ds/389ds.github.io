---
title: "Howto: MigrateToLDAP"
---

# How To Migrate To LDAP From Other Data Sources
----------------------------------------------

This page describes ways to migrate your user/authentication/group/other data from whatever source you currently use to LDAP using Fedora Directory Server. This page is intended to be a clearinghouse for other data and may reference other How To's.

### Passwd/Shadow file migration

-   [UidFixup](howto-uidfixup.html) is a script that will change a users uid/gid in /etc/passwd and fix up any files that belong to them, useful to prepare for migration when your users have different uids on different servers
-   There is a comprehensive set of [migration tools](http://www.padl.com/OSS/MigrationTools.html) from Padl. They are bundled with OpenLDAP server. If you have OpenLDAP installed, they should be in `/usr/share/openldap/migration/`. You can use them to produce LDIF files to import into your directory.

### Other LDAP servers

-   Read [Howto - OpenLDAPMigration](howto-openldapmigration.html) lists migration information specific to OpenLDAP

