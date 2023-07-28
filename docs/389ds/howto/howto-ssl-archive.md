---
title: "Howto: TLS/SSL"
---

**NOTE: SSL is considered insecure - do not use it - use only TLSv1 and later**
In most places below where this document refers to the term "SSL", it usually means "TLSv1".  The term "SSL" is kept around for historical reasons, but SSLv3 should never be used.

See newer documentation here:

- [How to Setup TLS/SSL](howto-ssl.html)
- [RHDS 11 Admin Guide](https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/managing_the_nss_database_used_by_directory_server)

# Configuring TLS/SSL Enabled 389 Directory Server
-------------------------------------------------

{% include toc.md %}


NOTE: key/cert database information
-----------------------------------

In Fedora DS 1.1 and later, the keys and certificates are stored in a server instance specific directory, along with the other server configuration files. By default, this is /etc/dirsrv/slapd-*instancename* e.g.

    /etc/dirsrv/slapd-localhost    
    /etc/dirsrv/admin-serv    

The commands below that use a **-d .** argument assume you are in this directory. You can also specify the directory explicitly e.g.

    certutil -d /etc/dirsrv/slapd-localhost -L    

In Fedora DS 1.0.4 and earlier, the directory /opt/fedora-ds/alias is used to store the key/cert databases for all server instances, and each one has a name like slapd-*instancename*-cert8.db. You are required to specify the database prefix, *including the trailing dash ("-")*. Also, the certutil command is found in /opt/fedora-ds/shared/bin e.g.

    cd /opt/fedora-ds/alias    
    ../shared/bin/certutil -d . -P slapd-localhost- -L    

Basic Information
-----------------

### Script

    WARNING:
    These scripts are only recommended for use in single server applications
    in testing environments.  They are not suitable for generating multiple
    server certs for multi-supplier replicated servers.  They are not suitable
    for production use.
    Please use an actual Certificate Authority (CA) instead.

There are two different scripts to use. The [first one](http://github.com/richm/scripts/tree/master%2Fsetupssl.sh?raw=true) is for the Fedora DS 1.0.x and earlier layout. This layout stores all of the key/cert databases for all servers in the directory /opt/fedora-ds/alias and identifies each one by a unique prefix e.g. slapd-localhost- or admin-serv-localhost-.

The [second one](http://github.com/richm/scripts/tree/master%2Fsetupssl2.sh?raw=true) is for the Fedora DS 1.1 and later layout. This layout stores the key/cert databases in server specific directories e.g. /etc/dirsrv/slapd-<host>/. This directory will contain a key and cert db file without a unique prefix (e.g. just cert8.db).

Each shell script will create your initial CA certificate, your DS server cert, your AS server cert, your DS pin.txt file for unattended restarts, your AS password.conf file for unattended restarts, will enable the DS to use SSL, and will export your CA cert for use in other (replicas, openldap, openssl) applications.

If the script completes successfully, you can skip to section [Configure LDAP clients](#Configure_LDAP_clients "wikilink")

NOTE: The script makes the following assumptions:

-   IMPORTANT: hostname --fqdn must return a fully qualified host and domain name, and the name that it returns must be resolvable by your clients. This is so that clients can verify the server certificate. If hostname --fqdn doesn't work, but you know what host.domain name you want to use, edit the script and change myhost to whatever "real" host.domain you want to use.
    -   You can override the hostname with the MYHOST env. var. e.g.

    MYHOST=my.real.fqdn setupssl2.sh ...    

-   You also need to specify the path to your 389 directory instance ie. ./setupssl2.sh /etc/dirsrv/slapd-<host>/ and|or ./setupssl2.sh /etc/dirsrv/admin-serv/
-   The script assumes the OpenLDAP ldapmodify is in your PATH. This is usually installed on machines by default, but you may have to install the openldap-clients package.
-   Using the default ports (389, 636)
-   Running the script as root
-   Fresh install
-   No CA certificate named "CA certificate" nor a DS cert named "Server-Cert" nor an Admin Server cert named "server-cert".

### Detailed step-by-step guide

[This page](http://www.csse.uwa.edu.au/~ashley/fedora-ds/fedora-ds-26072006.html) is a graphically illustrated (screenshots) step-by-step guide to setting up your Fedora DS servers to use TLS/SSL. This guide also includes client configuration for many linux and unix systems, and even Mac.

### Basic Steps

It is required to have a self signed certificate, certificate database, and keys. Please see the following link which will guide you through setting that up:

-   <http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/SecureConnections.html>
-   <https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Managing_SSL.html#Enabling_SSL_Only_in_the_DS>

NOTE - In order for the CA certificate to be a real, valid CA certificate, you must add the Basic Constraints option (-2) to the certutil -S command used to create the self signed CA. Adding -2 will cause certutil to prompt you for 3 questions:

-   Is this a CA certificate [y/N]? - answer 'y' to this question
-   Enter the path length constraint, enter to skip [\<0 for unlimited path]: - unless you know what you're doing, just hit Enter/Return here
-   Is this a critical extension [y/N]? - answer 'y' to this question

For example:

    #> certutil -S -n "CA certificate" -s "cn=CAcert" -x -t "CT,," -m 1000 -v 120 -d $secdir \    
       -z $secdir/noise.txt -f $secdir/pwdfile.txt -2    
    Is this a CA certificate [y/N]? y    
    Enter the path length constraint, enter to skip [<0 for unlimited path]:    
    Is this a critical extension [y/N]? y    

NOTE - You must use the fully qualified domain name of your server host as the value of the cn attribute in the subject DN. For example, if your directory server hostname is foo.example.com, use

    cd /etc/dirsrv/slapd-yourinstancename    
    certutil -S -n "Server-Cert" -s cn=foo.example.com -c "CA certificate" \    
    -t "u,u,u" -m 1001 -v 120 -d . -z noise.txt -f pwdfile.txt    

If you are using Fedora DS 1.0.4 or earlier, use this instead:

    cd /opt/fedora-ds/alias    
    ../shared/bin/certutil -S -n "Server-Cert" -s cn=foo.example.com -c "CA certificate" \    
    -t "u,u,u" -m 1001 -v 120 -d . -z noise.txt -f pwdfile.txt    

to generate your server cert. This is the minimum. You may wish to provide your clients with more details about your server. For more information, see RFC 1485. You could choose to specify the subject DN like this:

    certutil ... -s "cn=foo.example.com,ou=engineering,o=example corp,c=us" ...    

Note: **The -m argument to certutil -S must be a unique number every time** - this is the serial number of the certificate. A CA may not issue two certs with the same serial number. If you plan on using this CA to issue more than a few certs, you should save this number somewhere safe and use a different number each time.

Note: **Make sure all of the files in /etc/dirsrv/slapd-instancename are owned by the directory server uid**.

Note: **If you are using Fedora DS 1.0.4 or earlier, make sure the alias/\*.db files are owned by the directory server uid** e.g. if you have chosen slapd to be run as "nobody" or "ldap", make sure the alias directory and the \*.db files in there are owned by that user. The directory server has to open those files in read-write mode.

After following the above instructions, you should save the CA information. You may need this CA to generate other certs at a later date or revoke them.

    pk12util -d . -o cacert.p12 -n "CA certificate"    

Or if you are using Fedora DS 1.0.4 or earlier:

    ../shared/bin/pk12util -d . -P slapd-serverID- -o cacert.p12 -n "CA certificate"    

Note slapd-serverID- ***\<-This trailing dash is crucial!*** Be sure to back up cacert.p12 in a safe place.

Would like to note one thing about the above document. When asked to convert the certificate database to pkcs12 format make sure the following format is used:

    pk12util -d . -o servercert.p12 -n Server-Cert    

or if you are using Fedora DS 1.0.4 or earlier:

    ../shared/bin/pk12util -d . -P slapd-serverID- -o servercert.p12 -n Server-Cert    

Note slapd-serverID- ***\<-This trailing dash is crucial!***

Note the above step is only needed if you want to backup your server key and cert (a good idea), or if you are planning on importing the key and cert into other applications (e.g. use openssl to convert the p12 file into other formats).

### Exporting the certs for use with other apps

Now that you have your server cert, client applications will need to be able to verify that cert when connecting to the server. In order to do that, the TLS/SSL client must have the CA cert to verify that the cert presented by the TLS/SSL server is valid. This includes server to server communication such as replication. The TLS/SSL roles are opposite the supplier/consumer roles. The supplier pushes changes to the slave. So in this instance, the slave is the TLS/SSL server, and the supplier is the TLS/SSL client.

-   In order to be an TLS/SSL server, the slave must have a server cert/key and CA cert.
-   In order to be an TLS/SSL client, the supplier must have just the CA cert.

You can use certutil on the supplier to make a cert for the slave, using the commands below on the supplier. Then, use pk12util to export the slave cert/key, then take that pk12 file to the slave and use pk12util to import it (and use certutil to import the CA cert).

#### Create and Export a Replication Consumer cert

Where "consumer.mydomain.com" is the real FQDN of the replication consumer. The value to the -m argument is the cert serial number - be sure that this value is unique.

    certutil -S -n "consumer-Cert" -s "cn=consumer.mydomain.com" -c "CA certificate" -t "u,u,u" -m UNIQUEVALUEHERE -v 120 -d . -k rsa    
    pk12util -d . -o consumer-cert.p12 -n consumer-Cert    

#### Export the CA cert

-   Works for Fedora 1.0.5+ and RHDS8

        certutil -L -d . -n "CA certificate" -a > cacert.asc    

if you are using Fedora DS 1.0.4 or earlier:

    ../shared/bin/certutil -L -d . -P slapd-serverID- -n "CA certificate" -a > cacert.asc    

##### Note:

Use -a for ASCII RFC 1113 format, or -r for binary DER encoding. Without -a or -r, this will just print out the certificate information in human readable form.

#### Import the Replication Consumer cert into another 389 DS

    pk12util -d . -i consumer-cert.p12    

you will also need to import the CA cert

#### Import the CA cert into another 389 DS

    cd /etc/dirsrv/slapd-otherserverID    
    certutil -A -d . -n "CA certificate" -t "CT,," -a -i cacert.asc    

or if you are using Fedora DS 1.0.4 or earlier:

    cd /opt/fedora-ds/alias (on another machine e.g. the replication consumer)    
    ../shared/bin/certutil -A -d . -P slapd-otherserverID- -n "CA certificate" -t "CT,," -a -i cacert.asc    

Omit the -a if you have a binary DER encoded cert (if you use -r to export the cert). You may be prompted for password you used to secure your database files with. After this, you will have to restart the slapd to have it use the new CA cert.

#### Import the CA cert into the Admin Server

##### 389 DS 1.1 and later

The Admin Server looks for its key and cert databases in the /etc/dirsrv/admin-serv directory. In order for the Admin Server to use TLS/SSL to talk to the directory server, you must have the certificate of the CA that issued the directory server certificate in the cert db of the admin server.

    cd /etc/dirsrv/admin-serv    
    certutil -A -d . -n "CA certificate" -t "CT,," -a -i cacert.asc    

Omit the -a if you have a binary DER encoded cert (if you use -r to export the cert). You may be prompted for password you used to secure your database files with. After this, you will have to restart the admin server to have it use the new CA cert:

    service dirsrv-admin restart    

or

    /usr/sbin/restart-ds-admin    

##### Fedora DS 1.0.4 and earlier

The Admin Server looks for its key and cert databases in the /opt/fedora-ds/alias directory. It uses the prefix admin-serv-hostname- where hostname is your hostname. In order for the Admin Server to use TLS/SSL to talk to the directory server, you must have the certificate of the CA that issued the directory server certificate in the cert db of the admin server.

    cd /opt/fedora-ds/alias    
    ../shared/bin/certutil -A -d . -P admin-serv-hostname- -n "CA certificate" -t "CT,," -a -i cacert.asc    

Omit the -a if you have a binary DER encoded cert (if you use -r to export the cert). You may be prompted for password you used to secure your database files with. After this, you will have to restart the admin server to have it use the new CA cert - /opt/fedora-ds/restart-admin.

Importing an Existing Self Sign Key/Cert or 3rd Party Ca/Cert
-------------------------------------------------------------

-   The following steps can be performed to import a preexisting RSA key and certificate that may or may not be self-signed. RSA key/cert can be from a 3rd party CA.
    -   You will need your PRIVATE-KEY file
    -   You will need your X509 CERTIFICATE file
    -   This will create a out file /tmp/crt.p12

        openssl pkcs12 -export -inkey PRIVATE-KEY -in CERTIFICATE -out /tmp/crt.p12 -nodes -name 'Server-Cert'    

Then import the key/cert:

        cd /etc/dirsrv/slapd-INSTANCE    
        pk12util -i /tmp/crt.p12 -d .    

-   or with Fedora DS 1.0.4 and earlier:

        cd /opt/fedora-ds/shared/bin    
        ./pk12util -i /tmp/crt.p12 -d /opt/fedora-ds/alias/ -P slapd-INSTANCE-    

### Import the CA cert chain

-   You also need to import the CA cert chain. Many times the entire chain is in a single .pem file.

        certutil -d /etc/dirsrv/slapd-INSTANCE -A -n "My Local CA" -t CT,, -a -i /path/to/ca.pem    

-   or with Fedora DS 1.0.4 and earlier:

        certutil -d /opt/fedora-ds/alias/ -P slapd-INSTANCE- -A -n "My Local CA" -t CT,, -a -i /path/to/ca.pem    

-   Note:
    -   If you have more than 1 CA cert file, repeat the above for each one, giving each one a unique name e.g.
        -   My Local CA SubSub, My Local CA Sub, My Local CA Root, etc.
    -   You should now be able to see and manage the certificate you imported via the GUI's Manage Certificates option.
    -   One may have to restart the ldap service and the admin console service to have the changes be reflected in the gui so a stop/start the directory service and admin service may be a good idea.

Replacing a Server Cert
-----------------------

If your cert expires and you need to issue another one, you may have to remove the old one first. This is because some utilities will issue the new cert with the same nickname as the old one, and will not allow you to rename it when you import the new one. You will usually see errors like this if this happens:

    pk12util-bin: PKCS12 decode import bags failed: You are attempting to    
    import a cert with the same issuer/serial as an existing cert, but that    
    is not the same cert.    

If this happens, follow these steps:

### Backup your old server cert/key material

In case something goes wrong, you will want to be able to restore your old server cert.

    cd /etc/dirsrv/slapd-INSTANCE    
    pk12util -d . -o olddscert.p12 -n "Server-Cert"    

or with Fedora DS 1.0.4 and earlier:

    cd /opt/fedora-ds/alias    
    ../shared/bin/pk12util -d . -P slapd-INSTANCE- -o olddscert.p12 -n "Server-Cert"    

You will be prompted for the key/cert db password, and the password to use to encrypt the .p12 file. If you don't know what the name is for your server cert, use

    certutil -L -d .    

or with Fedora DS 1.0.4

    certutil -d . -P slapd-INSTANCE- -L    

to list the contents of your cert db.

### Delete the old server cert

Did I mention to first back it up?

    certutil -D -d . -n "Server-Cert"    

or with Fedora DS 1.0.4

    ../shared/bin/certutil -D -d . -P slapd-INSTANCE- -n "Server-Cert"    

### Import the new cert

This assumes you have the new cert in a .p12 file. Make sure, when you created your p12 file, that you gave the certificate the name "Server-Cert", or whatever the value you have given nsSSLPersonalitySSL in your directory.

    pk12util -d . -i newservercert.p12    

or with Fedora DS 1.0.4

    ../shared/bin/pk12util -d . -P slapd-INSTANCE- -i newservercert.p12    

You will be prompted for the password used to encrypt the newservercert.p12 file as well as the key/cert db password.

Starting the Server with TLS/SSL enabled
------------------------------------

Create an LDIF file called **/tmp/ssl_enable.ldif** with the following data in it. Be sure to change <instance> to the name of your slapd instance and make sure that all of the ciphers are on a single line. The nsSSL3Ciphers that are enabled are lined up against the published standards for disabling SSLv2 cipher suites and should maintain compliance for the PCI Data Security standards.  NOTE: SSLv3 is considered unsafe and should not be used.  The instructions below explicitly disable SSLv3.  SSLv3 should be disabled by default.

    dn: cn=encryption,cn=config
    changetype: modify
    replace: nsSSL3
    nsSSL3: off
    -
    replace: nsSSLClientAuth
    nsSSLClientAuth: allowed
    -
    add: nsSSL3Ciphers
    nsSSL3Ciphers: +all

    dn: cn=config
    changetype: modify
    add: nsslapd-security
    nsslapd-security: on
    -
    replace: nsslapd-ssl-check-hostname
    nsslapd-ssl-check-hostname: off

If using Fedora DS 1.0.4 or earlier, add the following:

    dn: cn=encryption,cn=config
    changetype: modify
    add: nsKeyfile
    nsKeyfile: alias/slapd-<instance>-key3.db
    -
    add: nsCertfile
    nsCertfile: alias/slapd-<instance>-cert8.db

Then, use ldapmodify to apply this to your directory server:

    ldapmodify -x -D "cn=directory manager" -w password -f /tmp/ssl_enable.ldif    

Or, if you cd shared/bin ; ./ldapmodify, you may omit the -x.

Then, create a file called **/tmp/addRSA.ldif** with the following data:

    dn: cn=RSA,cn=encryption,cn=config
    changetype: add
    objectclass: top
    objectclass: nsEncryptionModule
    cn: RSA
    nsSSLPersonalitySSL: Server-Cert
    nsSSLToken: internal (software)
    nsSSLActivation: on

Then use ldapmodify to add it:

    ldapmodify -x -D "cn=directory manager" -w password -a -f /tmp/addRSA.ldif    

Or, if you cd shared/bin ; ./ldapmodify, you may omit the -x.

Restart slapd server instance

    # service dirsrv restart [<instance>]    

If you omit the instance, all instances will be restarted. Or

    # $libdir/dirsrv/slapd-<instance>/restart-slapd    

Where \$libdir is your system lib directory (e.g. /usr/lib or /usr/lib64 or /usr/lib/64 or ???) Or, for Fedora DS 1.0.4 and earlier:

    # /opt/fedora-ds/slapd-<instance>/restart-slapd    

If you do not have PIN file, it will prompt you for the password you used to create the server cert.

### Keys for Kerberos,SASL,GSSAPI

If you are going to use your server with Kerberos + SASL + GSSAPI, then review the [Howto:Kerberos](http://directory.fedoraproject.org/wiki/Howto:Kerberos), particularly the section on "Keys".

Configure LDAP clients
----------------------

The following instructions are for Linux clients, almost all of which use the openldap client libraries that are the standard LDAP client libraries on those systems. This includes the ldapsearch used below, which is not the one included with Fedora DS.

Modify the following in **/etc/openldap/ldap.conf**

    URI     ldap://example.com
    BASE dc=example,dc=com    
    HOST example.com    
    TLS_CACERTDIR /etc/openldap/cacerts/    
    TLS_REQCERT allow    

*Note:* Make sure TLS\_CACERTDIR exists. Next, if you haven't done so, export your CA cert to ASCII (use the -a option above). Then, install it in the cacerts directory like so:

    cacertdir_rehash /etc/openldap/cacerts/    

The file name is the hash of the contents with a ".0" filename extension.

If you can't get it to work with TLS\_CACERTDIR, you can just tell it to use the cacert file directly:

    TLS_CACERT /etc/openldap/cacerts/cacert.asc    

If you have more than 1 CA cert, you will have to concatenate them into a single file.

Verify TLS/SSL is enabled
---------------------

    # ldapsearch -x -ZZ '(uid=testuser)'

Check your access logs /opt/fedora-ds/slapd-\    hostname -s\    /logs/access, should have something similar to

    [18/Jul/2005:20:33:36 -0400] conn=4 op=0 EXT oid="1.3.6.1.4.1.1466.20037" name="startTLS"    
    [18/Jul/2005:20:33:36 -0400] conn=4 op=0 RESULT err=0 tag=120 nentries=0 etime=0    
    [18/Jul/2005:20:33:36 -0400] conn=4 TLSv1.1 256-bit AES    
    [18/Jul/2005:20:33:36 -0400] conn=4 op=1 BIND dn="" method=128 version=3    
    [18/Jul/2005:20:33:36 -0400] conn=4 op=1 RESULT err=0 tag=97 nentries=0 etime=0 dn=""    
    [18/Jul/2005:20:33:36 -0400] conn=4 op=2 SRCH base="dc=example,dc=com" scope=2 filter="(uid=testuser)" attrs=ALL    

Use ldapsearch with TLS/SSL
-----------------------

When used with the -Z option, ldapsearch needs the absolute path to a cert8.db file to know about the certificate chain trust, here are some examples:

If using the openldap-clients package, and if the CA cert is not already imported, either edit /etc/openldap/ldap.conf like above or try this:

    # vi ~/.ldaprc
    # TLS_CACERT <path-to-ca>.pem
    TLS_REQCERT allow

And then, for example:

    /usr/bin/ldapsearch -H ldaps://<some-host> -x -D "cn=directory manager" -w <some-password> -s base -b "" objectclass=*|less    

If running a shell on a current ldap server, e.g. FDS 1.0.4:

    /opt/fedora-ds/shared/bin/ldapsearch -Z -p 636 -P /opt/fedora-ds/alias/slapd-<instance-name>-cert8.db -D "cn=directory manager" -w <some-password> -s base -b "" objectclass=*|less    

or with FDS 1.1

    /usr/lib/mozldap/ldapsearch Z -p 636 -P /etc/dirsrv/slapd-<instance-name>-cert8.db -D "cn=directory manager" -w <some-password> -s base -b "" objectclass=*|less    

Or if using a desktop with Firefox, assuming you can browse to the admin express pages if https had been enabled, to import the server cert, and then, assuming my desktop has the mozldap package, run for example:

    /usr/lib/mozldap/ldapsearch -Z -P /home/<some-uid>/.mozilla/firefox/<some-path>.default/cert8.db -p 636 -h <some-host> -D "cn=directory manager" -w <some-password> -s base -b "" objectclass=*|less    

Client Certificate Based Auth
-----------------------------

See <Howto:CertMapping> to set up Fedora DS to map the subject DN in the cert to the user's LDAP entry.

How to remove the key/cert password
-----------------------------------

The modutil command can be used to change the password, or even change it to an empty password so the password/pin is no longer needed.

    cd /etc/dirsrv/slapd-foo    
    modutil -dbdir . -changepw "NSS Certificate DB"    

or for Fedora DS 1.0.4 and earlier:

    cd /opt/fedora-ds/alias    
    ../shared/bin/modutil -dbdir . -dbprefix slapd-foo- -changepw "NSS Certificate DB"    

Enter the old password then press Enter twice for the new password to blank it out.

Console TLS/SSL Information
=======================

Using the Console
-----------------

Using the console, go into the Directory Server that you want to use TLS/SSL with, then go into the Configuration tab, then go to the Encryption tab in the right hand pane. If you have not already done so, you must have already enabled TLS/SSL for this server by using the steps above.

The check box "Use SSL in Fedora Console" tells the console to use TLS/SSL when communicating with this directory server. The directory server must already be configured to use TLS/SSL before you set this option.  Note that although the term "SSL" is used in this context, it really means "Use the highest strength TLS encryption available".

Using the command line
----------------------

You must first find the entry corresponding to the directory server you want the console to use TLS/SSL with.

    ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot "nsServerID=slapd-yourinstance"

If you have more than one server named "slapd-yourinstance", you can add the hostname of the server to narrow it down:

    ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot \
    "(&(nsServerID=slapd-yourinstance)(serverHostName=myhost.domain.tld))"

The attribute in this entry that controls whether or not TLS/SSL is used is **nsServerSecurity**. Set this to "on" if you want to use TLS/SSL or "off" if not e.g.

    ldapmodify -x -D "cn=directory manager" -w password
    dn: dn of your server instance entry
    changetype: modify
    replace: nsServerSecurity
    nsServerSecurity: on

Manage Certificates
-------------------

The console has a UI that allows you to view, request, and install certificates, for servers and CAs. For some reason, self-signed CA certs show up under Server Certs - this is ok - the cert is still treated as a CA cert, it just shows up in the wrong place in the UI.

### Requesting a cert

The console only generates the cert request. It does not actually create a server cert. You must submit the cert request to a CA and have the CA generate the actual cert, which you can then install using the console.

### Viewing the list of built-in CA certs

NSS has a built-in list of root CAs that it trusts. If you want to view this list in the console, you must make a symlink to the libnssckbi.so file in your security directory. For example, on a 32-bit system:

    cd /etc/dirsrv/slapd-instancename    
    ln -s /usr/lib/libnssckbi.so    

Then, the console Manage Certificates -\> CA Certs will show all of the built-in root CAs in addition to any you have installed. On a 64-bit system, use /usr/lib64 instead. You can do the same thing for the Admin Server console window:

    cd /etc/dirsrv/admin-serv    
    ln -s /usr/lib/libnssckbi.so    

Admin Server TLS/SSL Information
============================

NOTE: Key/Cert database location
--------------------------------

With Fedora DS 1.1, the Admin Server uses /etc/dirsrv/admin-serv as the location of the key and certificate databases. Since this directory is unique and private to the Admin Server, the -P prefix arguments should be omitted e.g.

    cd /etc/dirsrv/admin-serv    
    certutil -d . -L    

If using Fedora DS 1.0.4 and earlier, the directory /opt/fedora-ds/alias is shared by the directory servers and the admin server, so the key/cert database must have a unique prefix, so the -P prefix argument is required.

Using the console
-----------------

The [Managing Servers with Red Hat Console](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/8.2/html/Using_Red_Hat_Console/index.html) manual provides information about setting up and using the console with an TLS/SSL enabled Admin Server.

Command line
------------

The script mentioned above will generate the key/cert db for admin server and install it in the correct place.

There are several files and directory entries which control if/how TLS/SSL is used with Admin Server and Console.

### /etc/dirsrv/admin-serv/nss.conf (or admin-serv/config/nss.conf)

Note: if you used the script above, this section is already done for you.

If you want the admin server to start unattended with TLS/SSL, you must put the pin/password in a file for the admin server to use. First, create a file called /etc/dirsrv/admin-serv/password.conf (or with Fedora DS 1.0.4 /opt/fedora-ds/alias/password.conf). The format is

    internal:password    

Make sure the file is mode 400 and owned by your admin server user (default nobody:nobody)

    chown nobody:nobody password.conf    
    chmod 400 password.conf    

Next, tell admin server to use the password file. Edit the file /etc/dirsrv/admin-serv (or admin-serv/config/nss.conf) and change the directive NSSPassPhraseDialog to point to your password.conf file:

    NSSPassPhraseDialog file:/etc/dirsrv/admin-serv/password.conf

or with Fedora DS 1.0.4:

    NSSPassPhraseDialog file:/opt/fedora-ds/alias/password.conf

Make sure the file is mode 400 and owned by your admin server user (default nobody:nobody)

    chown nobody:nobody nss.conf    
    chmod 400 nss.conf    

### /etc/dirsrv/admin-serv/console.conf (or admin-serv/config/console.conf)

This file should contain the following directives (Apache conf style directives). The value in [brackets] is the default, and you may not need to change it.

-   NSSEngine [off\|on] - set to on to enable the Admin Server to use https (TLS/SSL) instead of http, off otherwise
-   NSSNickname [server-cert] - this is the nickname of the Admin Server cert in it's cert/key database - server-cert is the default and the one created by the script above
-   NSSCertificateDatabase [/etc/dirsrv/admin-serv or /opt/fedora-ds/alias] - the directory containing the key/cert database files
-   NSSDBPrefix [admin-serv-yourhost-] - the prefix of the key/cert database filenames
-   NSSCipherSuite - must be set and should already be set - just use the default setting

The following setting must be omitted with Fedora DS 1.1 and later, and must be used with Fedora DS 1.0.4 and earlier:

-   NSSDBPrefix [admin-serv-yourhost-] - the prefix of the key/cert database filenames

To verify the above settings, try something like this:

    cd /etc/dirsrv/admin-serv    
    certutil -d . -L    

or with Fedora DS 1.0.4 and earlier:

    cd /opt/fedora-ds/alias    
    ../shared/bin/certutil -d . -P admin-serv-yourhost- -L    

you should see server-cert listed as an TLS/SSL server certificate.

### admin-serv/config/adm.conf (Fedora DS 1.0.4 and earlier only)

The following only applies when using Fedora DS 1.0.4 and earlier. When Admin Server TLS/SSL is enabled, the file should have the following 3 additional attributes:

    security: on    
    certDBFile: /opt/fedora-ds/alias/admin-serv-yourhost-cert8.db    
    keyDBFile: /opt/fedora-ds/alias/admin-serv-yourhost-key3.db    

### cn=configuration entry for Admin Server

Some of the admin server configuration is stored in the configuration directory server. To find this entry, first do a search like the following (assuming your configuration directory server is running on the localhost and listening to port 389):

    /usr/bin/ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot \
    '(&(cn=configuration)(objectclass=nsadminconfig))'

There is an attribute in this entry called **nsServerSecurity** - set to "on" to enable TLS/SSL, "off" otherwise (or absent).

### cn=encryption entry for Admin Server

Do the following ldapsearch to find the entry (it should be the child of the cn=configuration entry above):

    /usr/bin/ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot cn=encryption

You should see something like the following (nsCertfile and nsKeyfile are only applicable with Fedora DS 1.0.4 and earlier):

    dn: cn=encryption, cn=configuration, cn=admin-serv-localhost, cn=Fedora Admini
     stration Server, cn=Server Group, cn=localhost.localdomain, ou=localdomain, o
     =NetscapeRoot
    cn: encryption
    objectClass: nsEncryptionConfig
    objectClass: top
    nsCertfile: alias/admin-serv-localhost-cert8.db
    nsKeyfile: alias/admin-serv-localhost-key3.db
    nsSSL2: off
    nsSSL3: off
    nsSSLSessionTimeout: 0
    nsSSL3SessionTimeout: 0
    nsSSLClientAuth: off
    nsSSL2Ciphers: +des,+rc2export,+rc4export,+desede3,+rc4,+rc2
    nsSSL3Ciphers: +rsa_rc2_40_md5,+rsa_rc4_128_md5,+rsa_3des_sha,+rsa_rc4_40_md5,
     +fips_des_sha,+fips_3des_sha,+rsa_des_sha,-rsa_null_md5

### cn=RSA entry for Admin Server

Do the following ldapsearch to find the entry (it should be the child of the cn=encryption entry above):

    /usr/bin/ldapsearch -x -D "cn=directory manager" -w password -b o=netscaperoot cn=RSA

You should see something like the following:

    dn: cn=RSA, cn=encryption, cn=configuration, cn=admin-serv-localhost, cn=Fedor
     a Administration Server, cn=Server Group, cn=localhost.localdomain, ou=locald
     omain, o=NetscapeRoot
    cn: RSA
    objectClass: nsEncryptionModule
    objectClass: top
    nsSSLToken: internal (software)
    nsSSLPersonalitySSL: server-cert
    nsSSLActivation: on

Using SAN Certs (Subject Alt Name)
==================================

(Submitted by pkime [at] Shopzilla.com)

-   [Rich Megginson of Red Hat thoughts on (Subject Alt Name) are preferred over \*.ssl certs](http://lists.fedoraproject.org/pipermail/389-users/2010-March/011156.html)
-   [creating san (Subject Alt Name ) certificates with openssl for hardware load-balancer](http://andyarismendi.blogspot.com/2011/09/creating-certificates-with-sans-using.html)

I just did this and thought others might like to see the procedure if the non-VIPed setup is already running. The issue is the TLS/SSL certs - they won't like the names/IPs of the VIPs and will complain (or depending on your setup, fail completely) when starting TLS/SSL. I assume your VIPs exist - here's how to change the TLS/SSL certs to work with the VIPs

You already have the two servers up and running on TLS/SSL with their certificates working. How do you change the certificates to include the VIP names so things like "ldapsearch -ZZZ" don't die? You have to add an X.509 v3 "SubjectAltName" certificate extension to the certificate. But you can't add it, so you have to create a new certificate. This is how I did it and it has minimal impact - just one quick FDS restart (and even that might not be strictly necessary - please correct me).

My situation was having two ldap servers and needing to put them behind two load-balanced VIPs.

    ldap1.foo.com    
    ldap2.foo.com    

For each server, I did this:

Generate a certificate request from the server. Either in the GUI and paste to a file or go into

    /etc/dirsrv/slapd-instancename    

and do

    certutil -R -d . -s <SUBJECTNAME> -o cert.req -a    

or with Fedora DS 1.0.4 and earlier:

    /opt/fedora-ds/alias    

and do

    /opt/fedora-ds/shared/bin/certutil -R -d /opt/fedora-ds/alias -s <SUBJECTNAME> -o cert.req -a

You may need the "-P" flag if using Fedora DS 1.0.4 and earlier and your cert8.db and key3.db files for the DS are not the default names. I tend to use "-a" for ascii output as I have had problems with binary requests and certs in the past.

Where "<SUBJECTNAME>" is the DN for the Certificate. This is the nice part - make sure that this is \*exactly\* the same as your already-in-use TLS/SSL cert's Subject DN. To find this out what this is, do

    certutil -L -n <CERTNAME> -d /etc/dirsrv/slapd-instancename    

or with Fedora DS 1.0.4 and earlier:

    /opt/fedora-ds/shared/bin/certutil -L -n <CERTNAME> -d /opt/fedora-ds/alias    

Again, you may need the "-P" flag if using Fedora DS 1.0.4 and your cert db files are not the default names. Here "<CERTNAME>" is the name of your server TLS/SSL cert. You can list all the cert names with:

    certutil -L -d /etc/dirsrv/slapd-instancename    

or with Fedora DS 1.0.4 and earlier:

    /opt/fedora-ds/shared/bin/certutil -L -d /opt/fedora-ds/alias    

If you are generating the cert request in the GUI, you can either enter the DN information in the separate fields or choose the DN view and just paste it in. Generate the request, get it into a file called "cert.req" and do this

    certutil -C -d /etc/dirsrv/slapd-instancename -c <CACERT> -i cert.req -o cert.crt -a -m <ID> -v 120 -8 <VIPs>

or with Fedora DS 1.0.4 and earlier:

    /opt/fedora-ds/shared/bin/certutil -C -d /opt/fedora-ds/alias -c <CACERT> -i cert.req -o cert.crt -a -m <ID> -v 120 -8 <VIPs>

This is where you generate the cert with the extensions.

-   <CACERT> is the name of your CA cert that is issuing the certificate - make sure it's the same CAcert that issued your current TLS/SSL cert (that way your clients which have the existing public CAcert wont' break). You can find out the name of it in the same way as described above for the server cert name.
-   <ID> is a unique, arbitrary serial number for the cert. The only restriction is that it must absolutely, positively be unique. You must not reuse a serial number already issued by this CA.
-   <VIPs> - this is a comma-separated list of DNS names (can be IP addresses) of your VIPs. Basically, this option says "these names are valid matches for the hostname of the server too" (e.g. ldap1.example.com,ldap2.example.com).
-   "-v" sets the expiration on the certificate in months. Set it to whatever you want.

You'll be prompted for the internal token to access the certificate database - I tend to use the "-f file" flag to get this from a file where it's stored.

In our example:

    certutil -C -d /etc/dirsrv/slapd-instancename -c <CACERT> -i cert.req -o cert.crt -a -m <ID> -v 120 -8 ldap1.foo.com,ldap2.foo.com    

or with Fedora DS 1.0.4 and earlier:

    /opt/fedora-ds/shared/bin/certutil -C -d /opt/fedora-ds/alias -c <CACERT> -i cert.req -o cert.crt -a -m <ID> -v 120 -8 ldap1.foo.com,ldap2.foo.com    

The resulting certificate is left in the "cert.crt" file.

Then install the certificate in the GUI (copy-paste is easy) - it will tell you that the Subject DN is identical to the certificate already installed and so it will call it by the same name. This is good and by design. So, now you will see two certificates with the same name. Delete the older one without the extensions (easy to do this in the GUI). I restarted the DS at this point in case it had cached the old certificate but this may not be necessary.

That's it. Your certificate now has the extensions to allow it to work with the VIP names and TLS/SSL won't complain. ldapsearch -ZZZ should still work fine. You can check the certificates by the "certutil -L" commands above and you should see this in the certificate:

    Signed Extensions:    
      Name: Certificate Subject Alt Name    
      DNS name: "ldap1.foo.com"    
      DNS name: "ldap2.foo.com"    

The trick with keeping the Subject DN the same (but changing the serial number, which is mandatory), means that you don't have to go into the DS setup and change the certificate name being used ... it just carries on working with minimal impact.

Preparing PIN/password files for the certificate databases
==========================================================

You can store the PIN/password protecting the certificate databases in such a way that the server won't prompt you for them during startup, but will read from from local files instead.

For Admin Server
----------------

Edit /etc/dirsrv/admin-serv/nss.conf and change NSSPassPhraseDialog to read:

    NSSPassPhraseDialog  file://///etc/dirsrv/admin-serv/password.conf

Then create /etc/dirsrv/admin-serv/password.conf:

    touch /etc/dirsrv/admin-serv/password.conf    
    chmod 600 /etc/dirsrv/admin-serv/password.conf    
    chown ldap /etc/dirsrv/admin-serv/password.conf    

Edit /etc/dirsrv/admin-serv/password.conf and place this single line in there:

    internal:adminserv_cert_password    

For Directory Server
--------------------

Create /etc/dirsrv/slapd-instance\_name/pin.txt (substitute slapd-instance\_name for actual server instance's directory name):

    touch /etc/dirsrv/slapd-instance_name/pin.txt    
    chmod 600 /etc/dirsrv/slapd-instance_name/pin.txt    
    chown ldap /etc/dirsrv/slapd-instance_name/pin.txt    

Edit the pin.txt file and place a single line in it (notice the difference in internal token name between this and Admin Server's):

Internal (Software) Token:dirserv\_cert\_password

That's it. Restart the server to test whether it doesn't ask for the PIN anymore and starts up properly with TLS/SSL.

Using Java/JNDI
===============

Simple client
-------------

Java/JNDI uses *keystores* created with the **keytool** program.

Requirements:

-   Java 1.6
-   The **keytool** command (should be provided with the JRE package)
-   A TLS/SSL enabled directory server (see above)
-   A CA cert file in ascii/PEM format (see above)

Steps:

-   Create a directory to hold the keystore

    mkdir ~/javakeystore    

-   Make sure **keytool** can read the cacert

    keytool -printcert -file /path/to/cacert.asc    

-   Use **keytool** to import the CA cert - NOTE: keytool will prompt for a password

    cd ~/javakeystore    
    keytool -import -alias cacert -file /path/to/cacert.asc -keystore cacerts    

-   Run the Java/JNDI client - specify the *javax.net.ssl.trustStore* and *javax.net.ssl.trustStorePassword* properties

    java -Djavax.net.ssl.trustStore=~/javakeystore/cacerts -Djavax.net.ssl.trustStorePassword=password MyMainClass    

Note that the trustStorePassword is the same password that keystore -import asked for.
