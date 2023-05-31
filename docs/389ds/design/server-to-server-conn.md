---
title: "Server To Server Connection Design"
---

# Server To Server Connection Design
------------------------------------

{% include toc.md %}

### Introduction

There are many places in the server that use LDAP connections to other servers, such as replication, chaining (Database Links), Windows Sync, and pass through authentication. These now support starting up a secure connection with the startTLS extended operation, and using SASL mechanisms in many cases.

Replication/Windows Sync
------------------------

There are two attributes in the replication/winsync agreement entry which control how replication connects to the other server.

-   nsds5ReplicaTransportInfo
    -   *empty* or **LDAP** - connection used plain non-secure LDAP - requires nsds5ReplicaPort to be the regular LDAP port (default 389)
    -   **SSL** - connection used LDAPS - requires nsds5ReplicaPort to be the secure LDAPS port (default 636)
    -   new option - **TLS** - connection uses startTLS on the regular LDAP port - requires nsds5ReplicaPort to be the regular LDAP port (default 389)
-   nsds5ReplicaBindMethod
    -   *empty* or **SIMPLE** - use LDAP Simple Bind (uses nsds5ReplicaBindDN and nsds5ReplicaCredentials)
    -   **SSLCLIENTAUTH** - uses the server's SSL server cert to authenticate - requires nsds5ReplicaTransportInfo **SSL** or **TLS** - also requires the remote server to have a certmap to map the cert subjectDN to a real entry in the server - see [Howto:CertMapping](../howto/howto-certmapping.html)
    -   new option - **SASL/GSSAPI** - use SASL/GSSAPI (i.e. Kerberos) - requires nsds5ReplicaTransportInfo **LDAP** (server does not yet support SASL/GSSAPI over SSL/TLS connection) - requires that the server has a keytab and the remote server has a SASL mapping to map the principal to a real entry - see [\#Server\_to\_Server\_Kerberos](#kerb)
    -   new option - **SASL/DIGEST-MD5** - use SASL/DIGEST-MD5 - uses nsds5ReplicaBindDN and nsds5ReplicaCredentials

NOTE: Active Directory in Windows Server 2003 and later supports startTLS. Fedora DS does not support SASL/GSSAPI SPNEGO, which means GSSAPI auth to AD will probably not work (would appreciate any information about this).

Chaining (Database Link)
------------------------

### Server to Server

There are two new attributes in the chaining backend configuration entry (e.g. cn=*backendname*,cn=chaining database,cn=plugins,cn=config) that control how the multiplexer server connects to the farm servers

-   nsUseStartTLS - **on** or **off** (default: off) - connection uses startTLS on the regular LDAP port - requires ldap: (not ldaps:) in the nsFarmServerURL
-   nsBindMechanism - the bind mechanism to use - default is *empty* which is simple bind (requires nsMultiplexorBindDn and nsMultiplexorCredentials)
    -   EXTERNAL - uses the server's SSL server cert to authenticate - requires ldaps: in nsFarmServerURL or nsUseStartTLS set to **on** - also requires the remote server to have a certmap to map the cert subjectDN to a real entry in the server - see [Howto:CertMapping](../howto/howto-certmapping.html)
    -   DIGEST-MD5 - uses SASL/DIGEST-MD5 - requires nsMultiplexorBindDn and nsMultiplexorCredentials
    -   GSSAPI - use SASL/GSSAPI (i.e. Kerberos) - requires ldap: in nsFarmServerURL (server does not yet support SASL/GSSAPI over SSL/TLS connection) - requires that the server has a keytab and the remote server has a SASL mapping to map the principal to a real entry - see [\#Server\_to\_Server\_Kerberos](#kerb)

The value of nsBindMechanism is passed to LDAP BIND directly, so if an invalid value is chosen, there will be bind errors and invalid mechanism errors in the client and other server logs.

### Client to Server

If you want to authenticate to a suffix whose backend is a chained database, there is some additional configuration required in order to properly chain the SASL Bind requests. Specifically, the chaining backend must allow the sasl and password policy components to be chained. This is controlled by the nsActiveChainingComponents in the chaining backend plugin configuration entry:

    dn: cn=config,cn=chaining database,cn=plugins,cn=config
    ...
    nsActiveChainingComponents: cn=password policy,cn=components,cn=config
    nsActiveChainingComponents: cn=sasl,cn=components,cn=config

Pass Through Authentication
---------------------------

Pass Through Authentication (PTA) does not support SASL bind or cert bind - it supports LDAP SIMPLE bind only. In order to configure PTA to support startTLS, an additional value must be added to the list of optional attributes - <http://www.redhat.com/docs/manuals/dir-server/ag/8.0/Using_the_Pass_through_Authentication_Plug_in-Configuring_the_PTA_Plug_in.html#Configuring_the_PTA_Plug_in-Configuring_the_Optional_Parameters> For example, if you had something like this:

    nsslapd-pluginarg0: ldap://dirserver.example.com/o=NetscapeRoot

You could make this use startTLS by adding a **,1** to the end of this list:

    nsslapd-pluginarg0: ldap://dirserver.example.com/o=NetscapeRoot

NOTE: In order to use startTLS, you must use ldap:, not ldaps:.

<a name="kerb"></a>Server to Server Kerberos
-------------------------

### Using Server's Keytab

This usually means the server has a keytab assigned to it that is set in the environment in a startup script (e.g. /etc/sysconfig/dirsrv):

    KRB5_KTNAME=/etc/dirsrv/ds.keytab ; export KRB5_KTNAME

The server will use these server credentials to authenticate to other servers using the SASL/GSSAPI method. The directory server has special Kerberos code that will automatically authenticate using these credentials i.e. the server does the equivalent of

    kinit -k -t /etc/dirsrv/ds.keytab ldap/FQDN@REALM

This requires that the server has been built with direct Kerberos API support. This is provided on most platforms, but some platforms notably do not provide this (e.g. Solaris 9). The other server will need to have a SASL mapping that maps the server principal (usually something like ldap/*serverfqdn*@*REALM*) to a real entry DN (e.g. for replication, usually to the replication bind DN - something like cn=replication manager,cn=config).

### Using External Credentials

If the platform does not support the direct use of the Kerberos API, but the platform does support Kerberos via GSSAPI (e.g. Solaris 9), or if you just want to use a different principal than the server principal, you can do an external kinit and have the server use the cached credentials. For example, in /etc/sysconfig/dirsrv:

    KRB5CCNAME=/tmp/krb_ccache ; export KRB5CCNAME
    kinit principalname # how to provide the password here is left as an exercise
    # or kinit -k -t /path/to/file.keytab principalname
    chown serveruid:serveruid $KRB5CCNAME # so the server process can read it
    # start a cred renewal "daemon"
    ( while XXX ; do sleep NNN ; kinit ..... ; done ) &
    # the exit condition XXX and sleep interval NNN are left as an exercise
    ... rest of server startup stuff ...

The server will see that KRB5CCNAME is set and will use those credentials. The server has no way to renew them, so that process must be external, or you will eventually get SASL BIND failures as the server attempts to use expired credentials.

### Identity Mapping

This doc covers the basics of SASL Identity Mapping - [SASL Identity Mapping](http://www.redhat.com/docs/manuals/dir-server/ag/8.0/Introduction_to_SASL-SASL_Identity_Mapping.html)

There is a special consideration when using a service principal to authenticate to another server. The default SASL mappings won't work because the principal is not a regular user entry. Another problem is that there is no way to specify the order in which the SASL mappings are applied - so the first match is taken. However, the server currently evaluates the maps in reverse ASCII order. So we can create mappings like this, in order to use the LDAP service principal for replication. The example assumes you already have replication set up, and have created the cn=replication manager,cn=config user. This mapping would be set on ldap2.example.com, and would allow replication from machine ldap1.example.com using its LDAP service principal.

    dn: cn=z,cn=mapping,cn=sasl,cn=config
    objectclass: top
    objectclass: nsSaslMapping
    cn: z
    nsSaslMapRegexString: ldap/ldap1.example.com@EXAMPLE.COM
    nsSaslMapBaseDNTemplate: cn=replication manager,cn=config
    nsSaslMapFilterTemplate: (objectclass=*)

This will map a Kerberos service principal of ldap/ldap1.example.com@EXAMPLE.COM to the replication manager user. Because *z* will usually come last, this mapping will be applied first. It will match the full principal name, including the realm. However, because of the way principal names are treated by the SASL/GSSAPI code, the realm may be removed. So we also need the map below:

    dn: cn=y,cn=mapping,cn=sasl,cn=config
    objectclass: top
    objectclass: nsSaslMapping
    cn: y
    nsSaslMapRegexString: ldap/ldap1.example.com
    nsSaslMapBaseDNTemplate: cn=replication manager,cn=config
    nsSaslMapFilterTemplate: (objectclass=*)

Which is the same as cn=z but without the realm. Since the name is *y*, it will be applied after the one named *z*, which is what we want - the pattern is less specific, so we want it applied after. Both of these mappings are required in order to map a service principal to a specific user.

**NOTE: If you add these maps over LDAP they will not work until you restart the server.** This is because maps added via LDAP are added to the end of the list, so the other default maps will take precedence. You can also add these maps when you create your instance using the ConfigFile directive. See [FDS\_Setup](../legacy/-fds-setup.html) for more information about ConfigFile.
