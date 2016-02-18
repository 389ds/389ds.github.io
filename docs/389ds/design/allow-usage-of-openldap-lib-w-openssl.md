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

The pem files are extracted from the NSS cert db every time the server starts and
overridden by the extracted keys and certs.

### Configuration

To allow place in the different location, cn=encryption,cn=config
could take optional attributes as follows:

    dn: cn=encryption,cn=config
    CACertExtractFile: filename

    dn: cn=RSA,cn=encryption,cn=config
    ServerKeyExtractFile: filename
    ServerCertExtractFile: filename

The filename could be a full path or just a file name.
If it is a file name without the path preceded, 
the files are supposed to be in nsslapd-certdir.

The Directory Server is configured with security on and finds no key and certificate
pem files in the expected place, the server retrieves them from the NSS cert db,
generates pem files and place them following the configuration.  
That is, an existing Directory Server is upgraded, it is supposed to work without
any configuration changes.

### Pem file names extracted from NSS cert db

When automatically retrieved, the pem file names are based on the nickname.
If white spaces are in the nickname, they are removed.

Sample certificates:

    ---------------------+--------------------
    Certificate Nickname   Trust Attributes
                           SSL,S/MIME,JAR/XPI
    ---------------------+--------------------
    CA certificate         CTu,u,u
    CA certificate 2       CTu,u,u
    Server-Cert            u,u,u
    ---------------------+--------------------

In this example, if CACertExtractFile is configured, the path and filename is being used for the CA 
cert pem file.  Otherwise, the nick name of the first CA certificate is used for the file name
by removing the white spaces as follows <b>CAcertificate</b>.pem.  
The CA certificate pem file contains all the extracted CA certs (in this case, "CA certiricate" as
well as "CA certificate 2".

Key of Server-Cert is stored in <b>Server-Cert-Key</b>.pem and its certificate is in <b>Server-Cert</b>.pem.

We do not allow to modify or replace the extracted pem files. 
For clarity, we put a header in the extracted file noting it is auto-generated,
always overwritten and possible with the nss name of the certificate, plus the cert Subject and Issuer.

Key/Cert Retrieval at the Server Startup
========================================

When the Directory Server starts up, the following steps are executed when nsslapd-security is on.

* Scan NSS cert db.
* Extract CA certs, convert them into the PEM format and store them into a file.
  If the CACertExtractFile is configured in cn=encryption,cn=config, the filename is used.
  If it is not given, the nick name of the first CA certificate is used and
  the filename is set to CACertExtractFile.
* Extract key and cert, convert them into the PEM format and store them individually.
  If ServerKeyExtractFile and ServerCertExtractFile are configured in cn=CIPHER,cn=encryption,cn=config,
  use the values for the file names.  Otherwise, the nickname of the certificate is used.

<b>Note:</b> To extract the private key, password is required as follows.

      $ pk12util -d $secdir -o nickName.p12 -n nickName -w $secdir/pwdfile.txt -k $secdir/pwdfile.txt

Also, to convert the p12 file into PEM file, I could not find the NSS utility to do the job and used openssl.

      $ openssl pkcs12 -in nickName.p12 -out nickName.pem -nodes

Do we have NSS library functions that allow the Directory Server to do the above 2 steps?

Implementation Details
======================
- Plug-ins share the centralized CA cert PEM file.
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

    1) nsDS5ReplicaBindMethod: SIMPLE
       The operation to the master is successfully replicated to the consumer using the CA cert in the pem file

    2) nsDS5ReplicaBindMethod: SSLCLIENTAUTH
       Configure the server with the server cert.  Then place pem files:
       # ls *pem
       cacert.pem  Server-Cert0-Key.pem  Server-Cert0.pem
       Verified the replication works.

To Dos
======
- Allowing winsync (priority high), dna (high), and chaining (low) to use the feature.

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

- NSS APIs to extract key and convert it into the pem format.

  As noted in "Key/Cert Retrieval at the Server Startup", need to learn how to do the job in the Directory Server.

- PEM file header

  For clarity, we put a header in the extracted file noting it is auto-generated,
  always overwritten and possible with the nss name of the certificate, plus the
  cert Subject and Issuer.

  It is also nice if we have a handy helper function in the NSS library.

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
