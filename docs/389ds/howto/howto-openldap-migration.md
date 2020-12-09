---
title: "OpenLDAP to 389 Directory Server Migration"
---

{% include toc.md %}

As the two major enterprise linux distributions (SUSE and Red Hat) have decided to remove OpenLDAP
from their platforms, the 389 Directory Server project has developed a number of tools and processes
to support migration from OpenLDAP to 389 Directory Server. The migration process is
supported in version 1.4.4 of 389-ds on SLE15-SP3/SUSE Leap 15.3, and version 2.0.0 in a future
Fedora and RHEL release.

# Differences between OpenLDAP and 389 Directory Server
-------------------------------------------------------

While both projects are LDAP servers, the features they support and their approach to data management
differs creating some compatibility issues. In some cases, there is a 1:1 relationship allowing direct
migration, in others some work may be required to perform the migration, and finally some features
are not possible to recreate under 389-ds.

A partial list of major features is:

| Feature          | OpenLDAP             | 389 DS                    | Compatible ? |
| ---------------- | -------------------- | ------------------------- | ------------ |
| 2 way Replication | SyncREPL            | 389 Specific system       | ❌           |
| MemberOf         | Overlay              | Plugin                    | ✅ (simple configs only) |
| External Auth    | SASL Authd           | PTA Plugin                | 🔨 (Config and Data Changes needed) |
| LDAP Proxy       | Proxy                | -                         | ❌           |
| AD Synchronisation | -                  | Winsync Plugin            | ❌           |
| Inbuilt Schema   | OLDAP Schemas        | 389 Schemas               | ✅ (Migration Tool Supports) |
| Custom Schema    | OLDAP Schemas        | 389 Schemas               | ✅ (Migration Tool Supports) |
| Database Import  | LDIF                 | LDIF                      | ✅ (Migration Tool Supports) |
| Password Hashes  | Varies               | Varies                    | ✅ (All Formats Supported excluding ARGON2) |
| oldap 2 ds repl  | -                    | -                         | ❌ (No mechanism for openldap to replicate to 389 is possible) |
| ds 2 oldap repl  | -                    | SyncREPL                  | ✅ (Some config of OpenLDAP may be needed) |
| TOTP             | TOTP Overlap         | -                         | ❌ (May be supported in the future) |
| EntryUUID        | Part of OpenLDAP     | Plugin                    | ✅ * (SLE/SUSE/2.0.0 only due to Rust requirement) |

# Planning your migration
-------------------------

As OpenLDAP is a "box of parts" and highly customisable, it is not possible to prescribe a one size
fits all migration. There will always be work that you must undertake to make this possible.

To plan your migration, you need to assess your current environment and configuration with OpenLDAP
and other integrations. This includes, and is not limited to:

* Replication Topology
* High Availability and Load Balancer configurations
* TLS configuration
* External Data Flows (IGA, HR, AD, etc)
* Configured Overlays
* Client Configuration and Expected server features.
* Customised Schema

Subsequently, you then need to plan what your 389 Directory Server deployment will look like in the
end. This includes the same list, but replace overlays with plugins.

Once you have assessed your current environment, and planned what your 389 DS environment will look
like, you can then form a migration plan to convert this. It is recommended you build the 389-DS
environment in parallel to your OpenLDAP environment to allow you to switch back and forward.

# Testing the Migration
-----------------------

Before performing the migration it is recomended you test the process in an isolated environment.

The OpenLDAP to 389 Directory Server migration tool called "openldap_to_ds" does not require live
access to the production OpenLDAP environment. This guarantees that it is non-intrusive and non-destructive
to your production environment. It requires offline copies of:

* slapd.d configuration directory in ldif/dynamic format
* (optional) ldif file backup of the database from slapcat

If you are not using the dynamic format, you can create it from slapd.conf with:

    slaptest -f /etc/openldap/slapd.conf -F /root/slapd.d

Each ldif of the database must be one ldif per backend suffix. You can create these with:

    # If using slapd.conf config format
    slapcat -f /etc/openldap/slapd.conf -b SUFFIX -l /root/suffix.ldif
    # If using slapd.d config format
    slapcat -F /etc/openldap/slapd.d -b SUFFIX -l /root/suffix.ldif

You need to configure a 389 DS instance with dscreate.

The openldap_to_ds tool will attempt to automatically migrate:

* Custom schema
* Configured indexes
* Backends
* If LDIF's are provided, import data to their backends
* Some overlays

For more details see the tools help. The help is extensive and worth reading:

    openldap_to_ds --help

By default the tool takes no actions and only displays the migration plan it would apply.

Once the migration is complete, the tool will emit a checklist of post migration tasks for you to
complete, including a list of non-migrated overlays.

It is worth documenting your post-migration steps that you take so you can reproduce these in your
production migration procedure.

Following this you should test clients and application integrations to the migrated 389 DS instance
to confirm that applications and plugins are working as intended.

You MUST develop a rollback plan with associated back-out criteria to assess the success of your
migration.

# Performing the Production Migration
-------------------------------------

It is again, difficult to prescribe what to do in this stage. If you have tested the process then
you should now have a good idea of what you need to do in the production migration. Some general
advice for this:

* Lower all hostname/DNS ttls to 5 minutes 48 hours before the change. This allows you to rollback quickly to your existing OpenLDAP deployment.
* Pause all data sync / incoming data processes so that data in the OpenLDAP environment is *not* changing during the migration process.
* Have all 389 DS hosts ready for deployment before the migration.
* Ensure that your test migration documentation is available offline/locally in case of unforseen issues.

# Completing the Migration
--------------------------

Once complete, you are then able to decommision your OpenLDAP infrastructure. It is worth developing
DR plans for your 389 DS infrastructure, and documentation about the differences in administration
of 389 DS.

# References
------------

For internal technical and implementation details, see [Technical Migration Implementation](/docs/389ds/design/openldap2ds.html)

# Author
--------

William Brown (SUSE Labs)
wbrown at suse.de

