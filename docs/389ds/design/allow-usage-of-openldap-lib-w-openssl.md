---
title: "Allow usage of OpenLDAP libraries that do not use NSS for crypto"
---

# Design for "Allow usage of OpenLDAP libraries that do not use NSS for crypto"
------------------

{% include toc.md %}

Overview
========

There are numerous places in the Directory Server code that assume that 
NSS is being used beneath the OpenLDAP libraries (389-ds-base-1.3.4 and older). 
This means operations the server executes as a client, e.g., replication, over SSL did not work 
if server was built against OpenLDAP that used a different crypto implementation, 
such as OpenSSL or GnuTLS.

Supporting crypto other than NSS is available on 389-ds-base-1.3.5 and newer.

Files in PEM Format
===================

The Directory Server still uses the NSS library for the server side crypto.
The NSS key/cert DB's are located in the directory specified by nsslapd-certdir in cn=config.
To allow non NSS crypto library to access,
the keys and certificates need to be extracted from the DB files and placed as a pem format file, respectively.

To guarantee these files are located in the expected directory, the Directory Server extract the key/cert DB files
and overrides them when the server starts up.

By default, the pem files are located in the same nsslapd-certdir directory.

### New Configuration

<b>Configuration parameter nsslapd-extract-pemfiles</b>

      dn: cn=config
      nsslapd-extract-pemfiles: on | off

When the value is "on", the certs/keys are extracted as pem files. 
Currently (389-ds-base-1.3.5.x), it is set to off, by default.

<b>Configuration parameters CACertExtractFile, ServerKeyExtractFile and ServerCertExtractFile</b>

The config entry cn=encryption,cn=config newly takes an attribute CACertExtractFile,
with which the CA certificate pem file path is specified. 

    dn: cn=encryption,cn=config
    CACertExtractFile: full_path

If the attribute value pair does not exist, 
the full path to the extract CA cert pem file is added
to the cn=encryption,cn=config entry as "CAcertExtractFile: full_path".
The full_path is /etc/dirsrv/slapd-INSTANCE/CA_CERT_NAME.pem, 
where the filename part is Certificate Nickname + ".pem".  
If the Certificate Nickname contains white spaces they are converted to its hex value "20".
For instance, a cert having a nickname "CA certificate" has the file name "CA20certificate.pem".
(See also the section "Pem file names extracted from NSS cert db")

The full_path is necessary for the utilities that internally call 
openldap client tools to connect to the server over SSL/startTLS.  
The path is passed to the openldap client tools via environment variable LDAPTLS_CACERT.
The environment variable is currently set in DSUtil.pm, monitor, and ldif2ldap.

The config entry cn=<i>CIPHER</i>,cn=encryption,cn=config newly takes 
attributes ServerKeyExtractFile as well as ServerCertExtractFile 
to specify the filename.  These pairs are not automatically added to the entry

    dn: cn=RSA,cn=encryption,cn=config
    ServerKeyExtractFile: filename
    ServerCertExtractFile: filename

The filename could be a full path or just a file name.
If it is a file name without the preceded path, 
the files are considered to be in nsslapd-certdir.

To summarize the behaviour, 
if the Directory Server is configured with security on and finds no key and certificate
pem files in the expected place in the startup, the server extracts them from the NSS cert db,
generates pem files and place them in the configured directory.
That is, an existing Directory Server as well as the openldap client library are upgraded, 
it is supposed to work without any configuration changes.

### Pem file names extracted from NSS cert db

When automatically retrieved, the pem file names are based on the nickname.
If white spaces are in the nickname, they are replaced with the hex value string "20".

Sample certificates:

    ---------------------+--------------------
    Certificate Nickname   Trust Attributes
                           SSL,S/MIME,JAR/XPI
    ---------------------+--------------------
    CA certificate         CTu,u,u
    CA certificate 2       CTu,u,u
    Server-Cert            u,u,u
    ---------------------+--------------------

In this example, if CACertExtractFile is configured, the value is used for the CA cert pem file.  
Otherwise, the nick name of the first CA certificate is used for the file name
by replacing the white spaces with hex characters as follows <b>CA20certificate</b>.pem.  
The extracted CA certificate pem file would contain all the CA certs found in the cert DB
(in this case, "CA certiricate" as well as "CA certificate 2".

Key of Server-Cert is stored in <b>Server-Cert-Key</b>.pem and its certificate is in <b>Server-Cert</b>.pem.

We do not allow to modify or replace the extracted pem files. 
For clarity, we put a header in the extracted file noting it is auto-generated as follows,
always overwritten and possible with the nss name of the certificate, plus the cert Subject and Issuer.

    This file is auto-generated by 389-ds-base.
    Do not edit directly.
    
    Issuer: CN=CAcert
    Subject: CN=CAcert


Key/Cert Retrieval at the Server Startup
========================================

When the Directory Server starts up, the following steps are executed when nsslapd-security is on.

* Extract CA certs from NSS cert db, convert them into the PEM format and store them into a file.
  If the CACertExtractFile is configured in cn=encryption,cn=config, the filename is used.
  If it is not given, the nickname of the first CA certificate is used and the filename
  is set to CACertExtractFile.
  (See slapd_extract_cert with isCA = true in ldap/servers/slapd/ssl.c)
* Extract key and cert from NSS key/cert db, convert them into the PEM format and store them individually.
  If ServerKeyExtractFile and ServerCertExtractFile are configured in cn=<i>CIPHER</i>,cn=encryption,cn=config,
  use the values for the file names.  Otherwise, the nickname of the certificate is used.
  (See slapd_extract_key and slapd_extract_cert with isCA = false in ldap/servers/slapd/ssl.c)
* Add PEM file header

  For clarity, we put a header in the extracted file noting it is auto-generated,
  always overwritten and possible with the nss name of the certificate, plus the
  cert Subject and Issuer.  (Search "DONOTEDIT" macron in ldap/servers/slapd/ssl.c)

       ==> CA20certificate.pem <==
       This file is auto-generated by 389-ds-base.
       Do not edit directly.
       Issuer: CN=CAcert
       Subject: CN=CAcert
       -----BEGIN CERTIFICATE-----
                [.....]
       -----END CERTIFICATE-----

       ==> Server-Cert1.pem <==
       This file is auto-generated by 389-ds-base.
       Do not edit directly.
       Issuer: CN=CAcert
       Subject: CN=test.localdomain1,OU=389 Directory Server
       -----BEGIN CERTIFICATE-----
                [.....]
       -----END CERTIFICATE-----

       ==> Server-Cert1-Key.pem <==
       This file is auto-generated by 389-ds-base.
       Do not edit directly.

       -----BEGIN PRIVATE KEY-----
                [.....]
       -----END PRIVATE KEY-----

<b>Notes:</b> I borrowed the crypto-utils code to extract the keys from the cert db.

Implementation Details
======================
- Added an api slapi_client_uses_openssl, 
  in which if the server is linked with OpenLDAP library and LDAP_OPT_X_TLS_PACKAGE value is "OpenSSL",
  the api returns true; otherwise false.
  (See ldap/servers/slapd/ldaputil.c)
- Added an api slapi_client_uses_non_nss, 
  in which if the server is linked with OpenLDAP library and LDAP_OPT_X_TLS_PACKAGE value is NOT "MozNSS",
  the api returns true; otherwise false.
  (See ldap/servers/slapd/ldaputil.c)
- If a configuration parameter nsslapd-extract-pemfiles is on,
  PEM files are always extracted from the cert db at the server's startup regardless of the LDAP_OPT_X_TLS_PACKAGE value.
  But the PEM files are passed to OpenLDAP by ldap_set_option only when the the LDAP_OPT_X_TLS_PACKAGE
  value is "OpenSSL".  That is, the code is supposed to work with NSS as well as OpenSSL without
  a configuration switch.  (Note: GnuTLS is not tested yet.)
- If slapi_client_uses_openssl is true, cacert file name is set in setup_ol_tls_conn which is called
  by slapi_ldap_init_ext/slapi_ldap_init.
- Also, if slapi_client_uses_openssl is true, server cert and key are set to LDAP_OPT_X_TLS_CERTFILE
  and LDAP_OPT_X_TLS_KEYFILE in slapd_SSL_client_auth, respectively.

  CLIENTAUTH test:

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
- Plug-ins share the centralized CA cert PEM file.

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
ds/dirsrvtests/tests/tickets/ticket47536_test.py

      Set up 2way MMR:
        supplier_1 ----- startTLS -----> supplier_2
        supplier_1 <-- TLS_clientAuth -- supplier_2

      Check CA cert, Server-Cert and Key are retrieved as PEM from cert db
      when the server is started.  First, the file names are not specified
      and the default names derived from the cert nicknames.  Next, the
      file names are specified in the encryption config entries.

      Each time add 5 entries to supplier 1 and 2 and check they are replicated.

CRL (Not Implemented Yet!!)
===========================
Set value LDAP_OPT_X_TLS_CRL_ALL to the option LDAP_OPT_X_TLS_CRLCHECK with the openldap API ldap_set_option.  
If the CRL file exists in the cert dir, it is supposed to be checked by this setting.

Comment by Rich:

- There is one more implicit use of NSS that just happens - revocation checking. 
  If you are using NSS for everything, the certs are automatically checked against 
  any CRLs or OCSPs that NSS knows about. We also need to consider how openldap+
  openssl clients will check server certs (or CA certs too?) for revocation.

What we need:

      1) Get CRL DPs from a cert
         (example:https://hg.python.org/cpython/file/tip/Modules/_ssl.c#l1070)
      2) Download CRL to a temporary directory
      3) verify that the CRL is correct and has been signed by a trusted party.
      4) move CRL to its final destination

This tool fetch-crl looks promising.  But the package is available only for Fedoras not for RHELs.

      https://wiki.nikhef.nl/grid/FetchCRL3

Possible solutions:

  - Build our own similar tool (possibly get the CRL from NSS?)
  - Ship fetch-crl in RHEL (approval might be tricky, maybe not though)

To Dos
======
- Testing with winsync (priority high), dna (high), and chaining (low) to use the feature.

- After 389-ds-base, investigate 389-admin
  - PEM file retrieval in the admin server
  - Set Environment variable (LDAPTLS_CACERT) for the server and CGIs.
  - etc.

- In addition to the softoken cryptographic module, 
  it needs to test with HSM (Hardware Security Module).

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

Tickets
=======
* Ticket [\#47536](https://fedorahosted.org/389/ticket/47536) - Allow usage of OpenLDAP libraries that don't use NSS for crypto
* Ticket [\#48756](https://fedorahosted.org/389/ticket/48756) - if startTLS is enabled, perl utilities fail to start.
