---
title: "Howto: TLS/StartTLS"
---

**NOTE: SSL is considered insecure - do not use it - use only TLSv1 and later**
In most places below where this document refers to the term "SSL", it usually means "TLSv1".  The term "SSL" is kept around for historical reasons, but SSLv3 should never be used.

# Configuring TLS/SSL Enabled 389 Directory Server
-------------------------------------------------

{% include toc.md %}

Configuring the certificates
============================

This section will assume you have an external CA that must sign your certificates. This is a standard configuration, and what we will explore here.

Assess your current certificates and hosts
------------------------------------------

To know what you will need to make the certificate request, you must examine your server setup and topology. At the end of this section you will have a list of hosts and their hostnames.

If you have a single node, you will only require the name of the CNAME, and/or the A/AAAA of the node.

Another important decision is if you will share the private key / certificate between systems, or if you will individually sign them. We highly advise you create a unique private key and certificate for each Directory Server.

If you have multiple nodes, you will need to understand the network topology including load balancers. I highly recommend that you do NOT terminate SSL/TLS on the load balancer. This means that your load balancers should pass through TCP/IP only to to the LDAP servers. The LDAP servers then are responsible to use the certificate and key to negotiate the SSL/TLS connection. To be clear, this means *do not* put your certificates and keys on the load balancer.

You should have a list of hostnames for your servers. For example:

    host.example.com. A 10.0.0.2
    ldap01.example.com. CNAME host.example.com.
    ldap.example.com. CNAME host.example.com.

On the systems, you will need to determine their current certificate settings. Look for the value:

    ldapsearch -H ldap://localhost:389 -D 'cn=Directory Manager' -W -Z -b 'cn=encryption,cn=config' -x

If the nsCertfile and nsKeyfile attributes are present, you should go to the location listed and view the certificates. If nsCertFile and nsKeyFile are not specified, the certificates are in the location:

    /etc/dirsrv/slapd-<instance name>/

To view your existing certificates use the command:

    certutil -L -d /etc/dirsrv/slapd-<instance name>/

An example output if the certificates exist is:

    Certificate Nickname                                         Trust Attributes
                                                                 SSL,S/MIME,JAR/XPI

    BH_LDAP_CA                                                   C,,  
    Server-Cert                                                  u,u,u

To view your existing keys, use the command:

    certutil -K -d /etc/dirsrv/slapd-<instance name>/

An example output if the keys exist is:

    < 0> rsa      79187d744c73cd2f098edc80ce261e5ad94c4db2   NSS Certificate DB:Server-Cert

Note the "NSS Certificate DB:Server-Cert", which defines the certificate which matches with this key.

To view the certificates in detail to display their subject alternate names, you must use:

    certutil -L -d /etc/dirsrv/slapd-<instance name>/ -n <certificate nickname>

Once you know what certificates already exist on the Directory Servers, you can decide if you need to create new certificates or not.

Plan the requests
-----------------

Now that you have the set of hosts, and you understand the topology and where you want SSL/TLS to be terminated, you must plan the set of requests you will make. You also will want to determine your certificate expiry, key size and other factors.

If you have a single server with CNAMES, you will make a single request, ie.

    Key Size: 4096
    Expiry: 2 years
    Common Name: ldap.example.com
    Subject Alt Names (IE cname): ldap.example.com, ldap01.example.com, host.example.com

Note these all down, and get ready.

Create the requests
-------------------

Now we can actually create the requests. To translate the above request into a suitable request for certutil, we must break down the parts.

* -g manages the bits in the key.
* -v manages the number of months validity.
* -8 manages subjectaltnames.
* -s manages the subject line, which contains common name.
* -o the output file for the request. The database will retain the private key.
* -a output the request as ascii PEM.

So to translate the above request into a command:

    certutil -R -d /etc/dirsrv/slapd-<instance name>/ -o ldap.example.com.req -a -g 4096 -v 24 -s "CN=ldap.example.com,O=organisation,L=location,ST=state,C=country code" -8 "ldap.example.com,ldap01.example.com,host.example.com"

You now have a request that can be sent to your CA for signing.

Import the certificate
----------------------

Once your CA has signed your request, and you have the certificates back. Assume that we have,

    ldap.example.com.crt  # ascii PEM signed certificate from the CA
    ca.crt  # The issuers CA certificate.

You can now import these to the database for use in Directory Server. When you import, you must assign a "nickname" to the certificate. This is how directory server will find the certificate you are using. I recommend you stick to "Server-Cert" unless you have a strong reason to change. Consistency across your fleet is important!

Import the CA.

    certutil -A -d /etc/dirsrv/slapd-<instance name>/ -n "ca_cert" -t "C,," -i ca.crt

Now import the server certificate.

    certutil -A -d /etc/dirsrv/slapd-<instance name>/ -n "Server-Cert" -t ",," -i ldap.example.com.crt


Configuring Directory Server
============================

If you have followed the steps above you should have properly configured certificates for your instances. Now you must enable SSL/TLS on your servers.

Directory Server has two methods for secure transport. The first is ldaps. This is on port 636. The client connection is initialised as "SSL/TLS" from the start, and always encrypted. The second is StartTLS. StartTLS is run on the standard ldap port 389. Initially a cleartext connection is made. At that point the server and client agree to "negotiate" and upgrade to TLS over the connection.

The steps here will configure both.

Collect your certificate details
--------------------------------

You should know this from previous steps. You will need to know the path to your certificate database, and the nickname of the certificate used for the server. IE

    Location: /etc/dirsrv/slapd-<instance>
    Nickname: Server-Cert

Assess your security requirements
---------------------------------

Your organisation or site may have requirements around SSL/TLS protocols in use, and/or the ciphers presented by services. You must contact other groups and users to determine the requirements you should follow. If not such requirements are provided (we hope this is the case!) we recommend that you use the defaults here.

Note down the requirements, and have them available as needed.

Again, if at all possible, attempt to use the "default" settings the 389 Directory Server provides. We regularly assess and upgrade the defaults to ensure that deployments are always following good practice. This means less work for you as the Administrator!

Deploy the settings
-------------------

This step will not actually enable SSL/TLS, but lays out the ground work for it.

In dse.ldif cn=config, there are two objects that control encryption for the system.

### cn=config

In cn=config, this determines if SSL/TLS is activated in the server. The option for this is:

    nsslapd-security: off

When the server is first configured this value will be off. Modifications to other settings as below will not activate until this value is set to "on".

### cn=encryption,cn=config

This object controls the available protocols of the server (SSLv2, SSLv3, TLS1.0, TLS1.1, TLS1.2) and controls the encryption ciphers available.

We recommend that the object contain the following.

    dn: cn=encryption,cn=config
    objectClass: top
    objectClass: nsEncryptionConfig
    cn: encryption
    nsSSLSessionTimeout: 0
    nsSSLClientAuth: off
    nsSSL3: off
    nsSSL2: off

Note the abscence of the sslVersionMin, sslVersionMax and nsSSL3Ciphers parameters. We set this to a secure default within the code if they are absent, so if possible remove them from this object.

### cn=RSA,cn=encryption,cn=config

This object controls the certificate database access and selection. It is used to pick the certificate the server will present durint SSL/TLS negotiations.

We recommend that this object (given the default nick name as above) contains:

    dn: cn=RSA,cn=encryption,cn=config
    objectClass: top
    objectClass: nsEncryptionModule
    nsSSLPersonalitySSL: Server-Cert
    nsSSLActivation: on
    nsSSLToken: internal (software)
    cn: RSA

Remember to make nsSSLPersonalitySSL match the certificate nickname you provided in the certification configuration. You do not need to specify which CA signed the certificate. Directory Server and NSS are smart enough to work out this chain correctly provided all ca and chain elements are in the certificate database.

### pin.txt

Not part of dse.ldif, but important. NSS has a password on the database in most cases: This file allows DS to start, reading the password from the pin.txt, without human interaction. This is optional to provide this. 

NOTE! If you do not provide a pin.txt, it is likely that Directory Server will *not* start without administrator interaction to provide the password.

WARNING: It is bad practice to share the Directory Manager password with the NSS database, due to the necesity to put this in a text file.

The contents of the file should be:

    Internal (Software) Token:password

Note that the value of nsSSLToken and the prefix of this line match. The format if broken down is:

    <nsSSLToken> Token:<password>

There is no advantage to changing the token name in a default configuration, so retain "internal (software)" as the value if possible.

Turn it on
----------

Finally, to enable SSL/TLS, change the value in cn=config:

    nsslapd-security: on

You must now restart the Directory Server instance.

    systemctl restart dirsrv@instance.service

    service dirsrv restart


# Author and Acknowledgement
----------------------------

William Brown, wibrown@redhat.com

Thanks to Crystal for her careful review.
