---
title: "Howto: MigrateToLDAP"
---

# How To Migrate To LDAP From Other Data Sources
----------------------------------------------

This page describes ways to migrate your user/authentication/group/other data from whatever source you currently use to LDAP using Fedora Directory Server. This page is intended to be a clearinghouse for other data and may reference other How To's.

### Passwd/Shadow file migration

-   [LdapImport](http://wiki.babel.com.au/index.php?area=Linux_Projects&page=LdapImport) is a script which can be used to migrate /etc/passwd, /etc/shadow, and /etc/group data into LDAP.
-   [UidFixup](howto-uidfixup.html) is a script that will change a users uid/gid in /etc/passwd and fix up any files that belong to them, useful to prepare for migration when your users have different uids on different servers
-   There is a comprehensive set of [migration tools](http://www.padl.com/OSS/MigrationTools.html) from Padl. They are bundled with OpenLDAP server. If you have OpenLDAP installed, they should be in `/usr/share/openldap/migration/`. You can use them to produce LDIF files to import into your directory.

### Other LDAP servers

-   [LdapImport](http://wiki.babel.com.au/index.php?area=Linux_Projects&page=LdapImport) is a script which can be used to migrate data from another LDAP server into Fedora DS. It migrates data and can also migrate schema if the source LDAP server makes the schema available via the subSchemaSubEntry.
-   Read [Howto - OpenLDAPMigration](howto-openldapmigration.html) lists migration information specific to OpenLDAP

