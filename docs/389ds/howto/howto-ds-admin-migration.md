---
title: "Howto: DS Admin Migration"
---

# DS Admin Migration
--------------------

{% include toc.md %}

Introduction
------------

There are two types of migration - same platform and cross platform.

### Same platform

Same means that the new software is installed on the same machine as the old one. For example, you already have a FC4 i386 machine with FDS 7.1 installed on it, and you want to install FDS 1.1 on it. In this case, the old and new software can both be run at the same time on the same machine. Database files and other binary data files can be copied and used directly by the new software. There is no need for any import/export process. This also means all of the replication changelog and other state information can be used directly, so no reinit of replicas is required.

**NOTE about database format change** - Fedora 8 uses Berkeley DB 4.6. The binary database format is incompatible with earlier releases. If upgrading or migrating from an earlier release to Fedora 8, you must export (db2ldif) your databases to LDIF format as described below in the section about 'Remote Source to Local Target'.

### Cross platform

This means that the new software is installed on a machine that is not binary compatible with the old machine. For example, the old machine is FDS 7.1 running on FC4 i386, and the new machine is F7 x86\_64. In this case, the databases must be first be exported from the old machine in LDIF format and imported into the new machine. We don't currently have a way to migrate changelog and other binary replication state information, so replicas will have to be reinitialized. Other binary data is ok though - key and cert databases can just be copied to the new machine and should just work.

There are a couple of different ways to proceed here. All of these assume that the new machine will have the same hostname as the old machine, which means the old machine must first have its hostname reassigned (e.g. ldap.example.com -\> oldldap.example.com). This is required for the following reasons (see below).

### Note about hostnames

NOTE: Migration does not change the hostname. This means if you do cross platform migration from one machine to another, you must assign the new machine the same hostname as the old machine, and you must change the hostname of the old machine. The hostname must not change for a number of reasons:

-   the configuration DS must have the same hostname before and after migration or console clients will fail
-   replication will break - replication agreements and replication metadata (RUV) contain the hostname
-   server certs must have the FQDN in the subjectDN (e.g. cn=foo.example.com,ou=Fedora Directory Server) - changing the hostname will break TLS/SSL clients
-   the Kerberos principal for the server is tied to the FQDN (e.g. ldap/foo.example.com@EXAMPLE.COM) - changing the hostname will break GSSAPI clients

The old machine should still be networked in order for the different migration scenarios to work i.e. you need to have some way to get the old data to the new machine.

#### Terminology

-   Source - the old machine from which the servers are migrated
-   Target - the new machine to which the servers are migrated

#### Remote Source to Local Target

In this case, the source data must already have been converted to LDIF, and must be available on the target machine. The user must first run db2ldif on the source machine e.g. something like this:

    foreach db /opt/fedora-ds/slapd-instance/db/*
      db2ldif -n db -a /opt/fedora-ds/slapd-instance/db/db.ldif
    end

Then, the configuration and data will be made available on the target in one of two ways:

-   create a tarball - cd /opt/fedora-ds ; tar cfz oldserver.tar.gz * - copy the tarball to the target - untar in a temporary directory, or even in /opt/fedora-ds since this path won't conflict with the new FHS paths
-   network mount the old /opt/fedora-ds on the target machine

Then the user will run the migration script and specify both the physical location of the source server root (e.g. /mnt/opt/fedora-ds) and the actual location on the old source machine (e.g. /opt/fedora-ds) if different. Migration can proceed with almost no user interaction - only the configuration ds admin password must be provided to update/register the migrated servers.

Which method to choose depends on the resources available. The fastest way will be the tarball method. The rate limiting step is usually the ldif2db to import the LDIF file into the target databases, especially for large databases. However, if disk space is tight, the network mount method will be the best approach.

Migration strategy
------------------

Migration works on a per-machine basis. That is, the admin server and all of the directory server instances will have to be migrated at the same time. This is mostly due to how the console works. The o=NetscapeRoot entries used look like this:

    o=NetscapeRoot
    + ou=example.com # admin domain
      + cn=ldap.example.com # machine where software is installed
        + cn=Server Group # this allows you to support multiple software
                          # installations on a machine - almost never used
          + cn=Fedora Directory Server # ISIE for DS
            + cn=slapd-ldap # SIE - Server Instance Entry
          + cn=Fedora Administration Server # ISIE for AS
            + cn=admin-serv-ldap # SIE - Server Instance Entry

The server instances are the leaf entries here, the slapd-ldap and admin-serv-ldap. There may be more than one slapd instance, if for some reason you want to run two or more ldap servers on a single machine. There will only be one admin server in a server group.

Migration will have to handle everything under the cn=ldap.example.com node. The console cannot handle having a cn=slapd-ldap which is a different software version than cn=admin-serv-ldap or another cn=slapd-ldap2 server in the same Server Group. So all of these have to be migrated at the same time.

Configuration Directory Server data
-----------------------------------

The configuration DS will have to be migrated first. The configuration DS must keep the same hostname. So, if doing cross platform migration, the only way to go will be to first "de-commission" the old server, and bring up the new server using the hostname of the old server.

The old o=NetscapeRoot data is just migrated as-is. The only filtering that needs to be done is to make copies of the UserPreferences data for use in the new console. That is, the ou=4.0 or ou=1.0 entries will be copied to ou=1.1. This will make those preferences available for the new console.

In order for the other data under o=NetscapeRoot to be updated, each machine will have to be migrated separately. The data under cn=ldap.example.com will be updated to reflect the new software version when the servers on that machine are migrated. As each server instance is migrated, its ISIE and SIE data will be updated too.

Other Directory Servers
-----------------------

### Configuration files

The data in dse.ldif will be filtered. Most attributes can simply be copied over. Some attributes are deprecated, and some are new. Many will have to be filtered in some way e.g. anything with /opt/fedora-ds in the value will have to be converted to /var/log/fedora-ds or /var/locks/fedora-ds or /var/lib/fedora-ds or whatever. Some special handling will be done with database files. If the server has been configured to store index files and transaction log files in other than the default directories, migration should attempt to preserve this if possible. Otherwise, if the default database directories have been used (e.g. /opt/fedora-ds/slapd-instance/db) then these files will just be copied to the new default location (e.g. /var/lib/fedora-ds/slapd-instance/db).

The security database files will just be copied to the new default location and renamed. So, for example, /opt/fedora-ds/alias/slapd-instance-cert8.db will be copied to /etc/fedora-ds/slapd-instance/cert8.db.

User defined schema files can just be copied from /opt/fedora-ds/slapd-instance/config/schema to etc/fedora-ds/slapd-instance/schema.

### Data files

For same platform migration, the database files can just be copied to their new location e.g. from /opt/fedora-ds/slapd-instance/db to /var/lib/fedora-ds/slapd-instance/db, unless the user has placed the index files and/or transaction logs in a non-default location (for performance, for example), in which case they will be left in place. Same with changelog db files, they will just be copied to their new location. The Berkeley DB code will automatically convert the db 4.2 index files to later versions if needed.

For cross platform migration, the source databases will first have to be converted to LDIF using db2ldif, then copied to the target machine, and an ldif2db performed. There is no such procedure for changelog db data or other replication state information, so all of the replicas will have to be reinitialized once they are all migrated.

Admin Server
------------

### Files to migrate

The 7.1 version of Admin Server uses a couple of config files that are not used in later versions:

-   server.xml - server port number, IP address, listen host, security configuration
-   magnus.conf - root dir, server ID, security on/off, log files, pid files, User, accept languages, admpw file

We don't need these going forward, and all of the pertinent information is already in the local.conf file, so we can just grab this information from local.conf and update console.conf with that information. In addition to these, there are several files which have been consolidated into adm.conf:

-   shared/config/dbswitch.conf
-   shared/config/ldap.conf
-   shared/config/ds.conf
-   shared/config/ssusers.conf

