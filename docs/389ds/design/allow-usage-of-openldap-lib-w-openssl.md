---
title: "Allow usage of OpenLDAP libraries that do not use NSS for crypto"
---

# Design for "Allow usage of OpenLDAP libraries that do not use NSS for crypto"
------------------

{% include toc.md %}

Overview
========

There are numerous places in the 389 DS code that assume that 
NSS is being used beneath the OpenLDAP libraries. This means 
things like replication over SSL will not work if 389 DS is 
build against OpenLDAP that uses a different crypto implementation, 
such as OpenSSL or GnuTLS.

Files in PEM Format
===================

The Directory Server still uses the NSS library for the server side crypto.
The NSS cert db is located in the directory specified by nsslapd-certdir in cn=config.
To allow non NSS crypto library to access the keys and certificates,
they are stored as a pem format.

By default, the pem files are located in the same nsslapd-certdir directory.

### Configuration

To allow place in the different location, cn=encryption,cn=config
could take optional attributes as follows:

    dn: cn=encryption,cn=config
    CACertFile: filename
    ServerKeyFile: filename
    ServerCertFile: filename

The filename could be a full path or just a file name.
If it is a file name without the path preceded, 
the files are supposed to be in nsslapd-certdir.

The Directory Server is configured with security on and finds no key and certificate
pem files in the expected place, the server retrieves them from the NSS cert db,
generates pem files and place them following the configuration.  
That is, an existing Directory Server is upgraded, it is supposed to work without
any configuration changes.

#### Special requirement per plug-in

For each case that calls the openldap client library via SSL/startTLS,
there could be a special requirement.  For instance, Windows Sync may need to
connect to the Active Directory with the server certificate issued by a CA
which is not in common with the one that issued the server side certificates.
To support such requirement, each plug-in is expected to handle its own
certificates.  

Example:

    Replication/Windows Sync agreement:
    nsDS5ReplicaCACert: /path/to/cacert.pem or cacert.pem

### Pem file names retrieved from NSS cert db

When automatically retrieved, the pem file names are based on the nickname.
If white spaces are in the nickname, they are removed.

Sample certificates:

    ---------------------+--------------------
    Certificate Nickname   Trust Attributes
                           SSL,S/MIME,JAR/XPI
    ---------------------+--------------------
    CA certificate         CTu,u,u
    Server-Cert            u,u,u
    ---------------------+--------------------

In this example, CA certificate will be named <b>CAcertificate</b>.pem and
Key of Server-Cert will be <b>Server-Cert-Key</b>.pem and certificate will be <b>Server-Cert</b>.pem.

Key/Cert Retrieval at the Server Startup
========================================

When the Directory Server starts up, the following steps are executed when nsslapd-security is on.

    1) CACertFile, ServerKeyFile, and ServerCertFile are defined in cn=encryption.
    1.1) CACertFile, ServerKeyFile, and ServerCertFile are defined as a full path.
    1.1.1) CACertFile, ServerKeyFile, and ServerCertFile exist.
           No need to do anything.  Done.
    1.1.2) CACertFile, ServerKeyFile, and ServerCertFile do not exist.
    1.1.2.1) CAcert and Server cert are in NSS cert db.
    1.1.2.1.1) CAcert and Server cert nickname match the CACertFile, ServerCertFile.
               Retrieve the CAcert and Server key and cert from the NSS cert db and 
               put them in the specified path.
    1.1.2.1.2) CAcert and Server cert nickname do not match the CACertFile, ServerCertFile.
               Log configuration error.  Server does not start.
    1.1.2.2) CAcert and Server cert are not in NSS cert db.
             Log configuration error.  Server does not start.
    
    1.2) CACertFile, ServerKeyFile, and ServerCertFile are defined as a simple file name.
    1.2.1) CACertFile, ServerKeyFile, and ServerCertFile exist in nsslapd-certdir.
           No need to do anything.  Done.
    1.2.2) CACertFile, ServerKeyFile, and ServerCertFile do not exist.
    1.2.2.1) CAcert and Server cert are in NSS cert db.
    1.2.2.1.1) CAcert and Server cert nickname match the CACertFile, ServerCertFile.
               Retrieve the CAcert and Server key and cert from the NSS cert db and 
               put them in nsslapd-certdir.
    1.2.2.1.2) CAcert and Server cert nickname do not match the CACertFile, ServerCertFile.
               Log configuration error.  Server does not start.
    1.2.2.2) CAcert and Server cert are not in NSS cert db.
             Log configuration error.  Server does not start.
    
    2) CACertFile, ServerKeyFile, and ServerCertFile are not defined in cn=encryption.
    2.1) CAcert(s) and Server cert(s) are in NSS cert db.
         Retrieve the CAcert and Server key and cert from the NSS cert db and 
         put them in nsslapd-cert.
         Note: If the certs are more than two, retrieve all of them.
    2.2) CAcert and Server cert are not in NSS cert db.
         Log configuration error.  Server does not start.

Note: This automated key and certificate retrieval does not support the individual plug-in configuration.

Implementation Details
======================
- Adding a new config parameter to the agreement:

    nsDS5ReplicaCACert: /path/to/cacert.pem or cacert.pem
- Extending slapi_ldap_init_ext to take the ca cert.

  If cacert variable is given, it is passed to setup_ol_tls_conn(ld,
      0, filename), in which it calls ldap_set_option(ld,
      LDAP_OPT_X_TLS_CACERTFILE, filename);
- CLIENTAUTH

    On the supplier,

      Assume the replication uses the server cert in the NSS cert db.
      Certificate:
        ServerCertNickname.pem (e.g., Server-Cert.pem)
      Key:
        ServerCertNickname-Key.pem (e.g., Server-Cert-Key.pem)

    On the consumer,

      Sample certmap.conf for the replmgr cn=replication manager,cn=config:
      certmap Example        CN=CACert
      Example:DNComps
      Example:FilterComps    cn
      Example:verifycert  on
      Example:CmapLdapAttr    description

      Sample replmgr entry:
      dn: cn=replication manager,cn=config
      objectclass: inetorgperson
      cn: replication manager
      cn: Server-Cert
      sn: RM
      description: CN=test.localdomain,OU=389 Directory Server
      userpassword: Password
      userCertificate;binary:: MIICxzCCAa+gAwIBAgICA+swDQYJKoZIhvcNAQELBQAwE
       ....

      where "CN=test.localdomain,OU=389 Directory Server" is a subject of the
      certificate and the value of userCertificate;binary is base64 encoded
      binary format server cert.

Build
=====

    1) Build openldap with --with-tls=openssl
       make; make install (by default, it is installed in /usr/local)
    2) Build ns-slapd with the following OPENLDAP_FLAG:
       OPENLDAP_FLAG="--with-openldap \
       --with-openldap-inc=/usr/local/include \
       --with-openldap-lib=/usr/local/lib \
       --with-openldap-bin=/usr/local/bin"

Replication Tests
=================
master -> read only replica

Replication Agreement:

    nsDS5ReplicaPort: 389 | 636
    nsDS5ReplicaTransportInfo: TLS | SSL
    nsDS5ReplicaCACert: cacert.pem | /path/to/cacert.pem

    1) nsDS5ReplicaBindMethod: SIMPLE
       The master has no certs in the cert db.  And the cacert pem is placed
       at the random location such as /tmp/nss_pem/cacert.pem.  The operation
       to the master is successfully replicated to the consumer.

    2) nsDS5ReplicaBindMethod: SSLCLIENTAUTH
       Configure the server with the server cert.  Then place pem files:
       # ls *pem
       cacert.pem  Server-Cert0-Key.pem  Server-Cert0.pem
       Verified the replication works.

To Dos
======
- Allowing winsync, dna, and chaining to use the feature.

- Current behavior:
  If pin.txt exists, the server starts with SSL enabled.
  If pin.txt does not exist,
    if the server is started by executing ns-slapd, it prompts for the password.
    if the server is started via systemctl, it does not prompt and the server
    starts with SSL disabled.
  To solve the issue, there is a password agent feature of systemd that is
  designed for this case:
  http://www.freedesktop.org/wiki/Software/systemd/PasswordAgents/
  https://fedorahosted.org/389/ticket/48450 - RFE Systemd passwryd agent support

- After 389-ds-base, investigate 389-admin.

### Need Investigation
- Instead of setting nsDS5ReplicaCACert, tried to extract the path
  to cacert using /etc/openldap/ldap.conf, /root/.ldaprc, as well as
  ~dirsrv/.ldaprc.  But none of them has the impact.

### Lower priority
- An idea not to store password in pin.txt using Deo:
  https://blog-ftweedal.rhcloud.com/2015/09/automatic-decryption-of-tls-private-keys-with-deo/
  http://www.freeipa.org/page/Network_Bound_Disk_Encryption
  https://github.com/npmccallum/deo
  If the authentication with Deo fails, the server prompts for the password.

  <p><b>Input by William Brown</b>:</p>
  I think deo is deprecated. We should consider tang and clevis.
  The good part about clevis is that it can provide the password
  prompting mechanism via systemd and such already for us.

- At the start up, even if the pem files having the expected file name exist,
  by comparing the contents of the key/certs, older key/certs are replaced by
  the corresponding new ones.  It could be cert db --> PEM as well as PEM --> cert db.
  For now, cert db --> PEM could be done by removing PEM files.  
  The other direction is not supported.

- Instead of maintaining the 2 sets of key/certs, NSS on the server side could switch
  to using only the PEM files.  This allows us not to maintain the key/certs in the cert db.

Tickets
=======
* Ticket [\#47536](https://fedorahosted.org/389/ticket/47536) - Allow usage of OpenLDAP libraries that don't use NSS for crypto
* Ticket [\#48450](https://fedorahosted.org/389/ticket/48450) - RFE Systemd passwryd agent support
