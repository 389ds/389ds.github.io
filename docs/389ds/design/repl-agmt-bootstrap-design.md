---
title: "Replication Agreement Bootstrap Credentials Design"
---

# Replication Agreement Bootstrap Credentials
----------------

Overview
--------

When using Bind DN Groups for a replication agreement authentication there are cases where the group is not present, or is outdated.  In such cases having bootstrap credentials can allow replication to start working again.  New replication sessions will always try and use the default credentials first.

Use Cases
---------

This feature is useful under two conditions when using [Bind DN Groups](https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/configuring_replication_partners_to_use_certificate-based_authentication).  The first is **online initialization**, where you need to authenticate to the replica before the database is initialized.  The second, is when using GSSAPI as the authentication mechanism and the kerberos credentials are changed.  In both of there scenarios, the bootstrap credentials will be  used to start the next replication sessions and get everything in sync/initialized.  On the next replication session the server will use the default credentials

Design
------

When a *Supplier* tries to connect to a *Consumer* and it fails to bind due to LDAP_INVALID_CREDENTIALS (err=49), LDAP_INAPPROPRIATE_AUTH (err=48), or LDAP_NO_SUCH_OBJECT (err=32) then if the bootstrap credentials are set it will attempt to bind with those credentials.  If the bootstrap credentials fail then it stops trying the connection is aborted.  If the bind succeeds with the bootstrap credentials then the replication connection is established and a new replication session will begin.  This allows any updates to the Bind DN Group members to be updated.  On the next replication session the agreement will try to use the original default credentials which should now succeed that the replica has been "bootstrapped".

Major configuration options and enablement
------------------------------------------

These are new attributes that can be added to an agreement

- nsds5ReplicaBootstrapBindDN
- nsds5ReplicaBootstrapCredentials
- nsds5ReplicaBootstrapBindMethod
- nsds5ReplicaBootstrapTransportInfo

Replication
-----------

Allows an alternative authentication mechanism to bootstrap replication sessions when Bind DN Groups are being used.

Updates and Upgrades
--------------------

Need to add **nsds5ReplicaBootstrapCredentials** as a reversible password

    dn: cn=AES,cn=Password Storage Schemes,cn=plugins,cn=config
    nsslapd-pluginarg0: nsmultiplexorcredentials
    nsslapd-pluginarg1: nsds5ReplicaCredentials
    nsslapd-pluginarg2: nsds5ReplicaBootstrapCredentials


Origin
-------------

<https://pagure.io/389-ds-base/issue/51156>

Author
------

<mreynolds@redhat.com>

