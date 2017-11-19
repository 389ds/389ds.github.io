---
title: "Mod nss"
---

# Mod nss
---------

{% include toc.md %}

News
----

**Feb 20, 2014**

mod_nss 1.0.9 released

-   Sync with Fedora builds which were basically the defacto upstream.
-   Add nss\_pcache man page
-   Fix CVE-2013-4566
-   Move nss\_pcache to /usr/libexec
-   Fix argument handling in nss\_pcache
-   Support httpd 2.4+

**July 21, 2008**

mod_nss 1.0.8 released

-   Don't allow blank passwords if FIPS is enabled. This is not allowed by the NSS FIPS 140-2 security policy.
-   No need to link with softokn3
-   There seems to be a problem in NSS\_Shutdown() that makes subsequent logins appear to succeed but they actually are skipped causing keys and certs to not be available so force a logout before shutting down.
-   NSS has been modified to not allow a fork after an NSS\_Init() in the soft token. It apparently always required this for hardware tokens as it is part of the PKCS\#11 spec. This is needed to work with NSS \> 3.11.9 (but should continue to work for older versions).
-   See if the certificate has a version before trying to decode it into a CGI variable.
-   If mod\_ssl isn't loaded then register the hooks to mod\_proxy so we can do at least secure proxy in front of an unsecure host.
-   The error message was wrong if NSSPassPhraseHelper pointed to a non-existant file.
-   Don't require a password file <b>and</b> NSSPassPhraseHelper. Only the helper is required.

<b>June 1, 2007</b>

mod\_nss 1.0.7 released

-   Stop processing tokens when a login fails so we can correctly report the failure.
-   Fix an off-by-one error in nss\_pcache that prevented 1 character passwords (not a huge problem but a bug none-the-less).
-   Bring in some updates based on diffs from 2.0.59 to 2.2.4
    -   Do explicit TRUE/FALSE tests with sc-\>enabled to see if SSL is enabled.
    -   Don't depend on the fact that TRUE == 1
    -   Remove some dead code
    -   Minor update to the buffer code that buffers POST data during a renegotation
    -   Optimize setting environment variables by using a switch statement.
-   Fix typo in cipher echde\_rsa\_null (transposed h and d).
-   The way I was using to detect the model being used was incorrect. Now use the \# of threads available. Guaranteed to be 0 for prefork and \> 0 for worker (threaded)

<b>October 27, 2006</b>

mod\_nss 1.0.6

-   If NSSEngine is off then simply don't initialize NSS at all.
-   Add support for setting a default OCSP responder.

<b>October 17, 2006</b>

mod\_nss 1.0.5

Fix for a minor problem introduced with 1.0.4. NSS\_Shutdown() was being called during module unload even if SSL wasn't enable causing an error to display in the log.

<b>October 11, 2006</b>

mod\_nss 1.0.4 is released

Merged in some changes to mod\_ssl:

-   new env variables SSL\_{SERVER,CLIENT}\_V\_REMAIN that contains number of days until certificate expires
-   Attempt to buffer POST data in a SSL renegotiation.

And some changes specific to mod\_nss:

-   Better way to distinguish Apache 2.0.x versus Apache 2.2.x. The old way broke when 2.0.56 was introduced.
-   Fix crash bug if the stored token password doesn't match the database password
-   Add new NSSPassPhraseDialog method, defer, where only the tokens that are found in the file pointed to by this directive are initialized.
-   Fix race condition in initializing the NSS session cache that could cause a core on startup.
-   Update nss.conf.in to contain LogLevel and its own log files
-   A missing initialization when built with ECC support that could cause the server to not start

<b>June 21, 2006</b>

mod\_nss 1.0.3 released.

-   Final ECC support
-   Compiles on Solaris with the Forte Workshop compiler (tested with 6.2 and 11).
-   A number of compilation warnings were addressed
-   gencert now uses bash instead of ksh

<b>March 2, 2006</b>

-   Experimental Eliptical Curve Cryptopgraphy (ECC) added. Requires a version of NSS also build with ECC support. Available in the CVS tip.

<b>January 31, 2006</b>

mod\_nss 1.0.2 is released.

-   Add support for Apache 2.2 (contributed by Oden Eriksson)

<b>September 20, 2005</b>

mod\_nss 1.0 is released.

-   Support for SSLv2, SSLv3, TLSv1
-   OCSP and CRLs
-   Client certificate authentication
-   Can run concurrently with mod\_ssl

What is mod\_nss?
-----------------

mod\_nss is an SSL provider derived from the mod\_ssl module for the [Apache](http://httpd.apache.org) web server that uses the Network Security Services ([NSS](http://www.mozilla.org/projects/security/pki/nss/)) libraries. We started with mod\_ssl and replaced the [OpenSSL](http://www.openssl.org) calls with NSS calls.

The [mod\_ssl](http://httpd.apache.org/docs/2.0/mod/mod_ssl.html) package was created in April 1998 by [Ralf S. Engelschall](http://www.engelschall.com/) and was originally derived from the [Apache-SSL](http://www.apache-ssl.org/) package developed by [Ben Laurie](mailto:ben@algroup.co.uk). It is licensed under the [Apache 2.0 license](http://www.apache.org/licenses/).

Why use NSS instead of OpenSSL?
-------------------------------

Use what is best for your needs.

This module was created so the Apache web server can use the same security libraries as the former Netscape server products acquired by Red Hat, notably the Fedora Directory Server (now called 389).

NSS is also used in the Mozilla clients, such as Firefox and Thunderbird. We are co-maintainers of NSS, and it better fits our particular needs.

What features does mod\_nss provide?
------------------------------------

For the most part there is a 1-1 mapping between the capabilities of mod\_nss and mod\_ssl.

In short, it supports:

-   SSLv3
-   TLSv1
-   client certificate authentication
-   hardware accelerators
-   Certificate Revocation Lists (CRLs)
-   OCSP

It does SSLv2 but it is disabled by default. We chose not to include support for SSLv2 since it has some security vulnerabilities and all major web browsers now support SSLv3, so there is no need to provide SSLv2 anymore.

Some mod\_ssl directives have been removed because they don't apply, and some new ones added. The directives dropped are:

-   SSLRandomSeed
-   SSLSessionCache
-   SSLMutex
-   SSLCertificateChainFile
-   SSLCARevocationPath
-   SSLCARevocationFile
-   SSLVerifyDepth
-   SSLCryptoDevice

The mod\_nss directives are all prefixed with NSS. The new directives are:

-   NSSCertificateDatabase
-   NSSNickname
-   NSSSession3CacheTimeout
-   NSSEnforceValidCerts
-   NSSFIPS
-   NSSOCSP

Documentation
-------------

Documentation is included in the mod\_nss package or you can read it [http://git.fedorahosted.org/git/?p=mod\_nss.git;a=blob\_plain;f=docs/mod\_nss.html;hb=HEAD here](http://git.fedorahosted.org/git/?p=mod_nss.git;a=blob_plain;f=docs/mod_nss.html;hb=HEAD here).

Mailing List
------------

For questions, patchs, etc, you can the mod\_nss mailing list is at <https://www.redhat.com/mailman/listinfo/mod_nss-list>

How compatible is mod\_nss to mod\_ssl?
---------------------------------------

Because mod\_nss was derived from mod\_ssl, and actually includes several unmodified source files, it is very compatible. OpenSSL exposes some features that NSS doesn't, and vice versa, but for a consumer of the module they are nearly functionally identical.

It is very simple to convert an existing mod\_ssl configuration for use with mod\_nss, but that isn't really our goal. mod\_nss was created to satisfy our needs for NSS support within Apache, not displace mod\_ssl.

What platforms does it support?
-------------------------------

mod\_nss has been tested on RHEL 5, 6 and 7, Fedora 4-21, Solaris 9 and 10 and some Ubuntu and Debian releases.

It should support Apache 2.0.x, 2.2.x and 2.4.x.

### mod\_nss Patches Compatibility Matrix

For pre 1.0.9 releases only:

**mod_nss Patches (10/21/2013)**

|**RHEL 5** |**RHEL6** |**Fedora 18** |**Fedora 19**|**Fedora 20** |**RHEL 7** |**bz961471** |
|-----------|----------|--------------|-------------|--------------|-----------|-------------|
|mod_nss-1.0.8.tar.gz<br>mod_nss-conf.patch<br>mod_nss-gencert.patch<br>mod_nss-wouldblock.patch<br>mod_nss-negotiate.patch<br><font color="GREEN"><b>mod_nss-reverseproxy2.patch</b></font><br><font color="GREEN"><b>mod_nss-PK11_ListCerts.patch</b></font><br>mod_nss-reseterror.patch|mod_nss-1.0.8.tar.gz<br>mod\_nss-conf.patch<br>mod\_nss-gencert.patch<br>mod\_nss-wouldblock.patch<br>mod\_nss-negotiate.patch<br>mod\_nss-reverseproxy.patch<br>mod\_nss-PK11\_ListCerts\_2.patch<br>mod\_nss-reseterror.patch<br>mod\_nss-lockpcache.patch<br>mod\_nss-overlapping\_memcpy.patch<br><font color="RED">mod_nss-array_overrun.patch</font><br><font color="RED">mod_nss-clientauth.patch</font><br><font color="RED">mod_nss-no_shutdown_if_not_init_2.patch</font><br><font color="RED">mod_nss-proxyvariables.patch</font><br><font color="RED">mod_nss-tlsv1_1.patch</font><br><font color="RED">mod_nss-sslmultiproxy.patch</font><br>|mod_nss-1.0.8.tar.gz<br>mod_nss-conf.patch<br>mod_nss-gencert.patch<br>mod_nss-wouldblock.patch<br>mod_nss-negotiate.patch<br>mod_nss-reverseproxy.patch<br><font color="BLUE">mod_nss-pcachesignal.h</font><br>mod_nss-reseterror.patch<br>mod_nss-lockpcache.patch<br><font color="BLUE">mod_nss-httpd24.patch</font><br>mo\_nss-overlapping\_memcpy.patch<br>|mod\_nss-1.0.8.tar.gz<br>mod_nss-conf.patch<br>mod\_nss-gencert.patch<br>mod_nss-wouldblock.patch<br>mod_nss-negotiate.patch<br>mod_nss-reverseproxy.patch<br><br><font color="BLUE">mod_nss-pcachesignal.h</font><br>mod_nss-reseterror.patch<br>mod_nss-lockpcache.patch<br><font color="BLUE">mod_nss-httpd24.patch</font><br>mod\_nss-overlapping\_memcpy.patch<br>mod\_nss-man.patch<br>|mod\_nss-1.0.8.tar.gz<br>mod\_nss-conf.patch<br>mod\_nss-gencert.patch<br>mod\_nss-wouldblock.patch<br>mod\_nss-negotiate.patch<br>mod\_nss-reverseproxy.patch<br><br><font color="BLUE">mod_nss-pcachesignal.h</font><br>mod\_nss-reseterror.patch<br>mod\_nss-lockpcache.patch<br><font color="BLUE">mod_nss-httpd24.patch</font><br>mod\_nss-overlapping\_memcpy.patch<br>mod\_nss-man.patch<br>|mod\_nss-1.0.8.tar.gz<br>mod\_nss-conf.patch<br>mod\_nss-gencert.patch<br>mod\_nss-wouldblock.patch<br>mod\_nss-negotiate.patch<br>mod_nss-reverseproxy.patch<br><font color="BLUE">mod_nss-pcachesignal.h</font><br>mod\_nss-reseterror.patch<br>mod\_nss-lockpcache.patch<br><font color="BLUE">mod_nss-httpd24.patch</font><br>mod\_nss-overlapping_memcpy.patch<br>mod_nss-man.patch<br>|mod_nss-1.0.8.tar.gz<br>mod_nss-conf.patch<br>mod\_nss-gencert.patch<br>mod_nss-wouldblock.patch<br>mod_nss-negotiate.patch<br>mod_nss-reverseproxy.patch<br><font color="ORANGE"><b>mod_nss-PK11_ListCerts_2.patch</b></font><br><font color="BLUE">mod_nss-pcachesignal.h</font><br>mod_nss-reseterror.patch<br>mod_nss-lockpcache.patch<br><font color="BLUE">mod_nss-httpd24.patch</font><br>mod_nss-overlapping_memcpy.patch<br>mod_nss-man.patch<br><font color="ORANGE"><b>mod_nss-array_overrun.patch</b></font><br><font color="ORANGE"><b>mod_nss-clientauth.patch</b></font><br><font color="ORANGE"><b>mod_nss-no_shutdown_if_not_init_2.patch</b></font><br><font color="ORANGE"><b>mod_nss-proxyvariables.patch</b></font><br><font color="ORANGE"><b>mod_nss-tlsv1_1.patch</b></font><br><font color="ORANGE"><b>mod_nss-sslmultiproxy_2.patch</b></font><br>|

#### Legend ####

**BLACK** = DOWNSTREAM PATCH EXISTS UPSTREAM<br>
<font color="BLUE"><b>BLUE</b></font> = UPSTREAM PATCH DOES NOT NEED TO BE BACK PORTED DOWNSTREAM<br>
<font color="GREEN"><b>GREEN</b></font> = DOWNSTREAM PATCH DOES NOT NEED TO BE PORTED UPSTREAM<br>
<font color="RED"><b>RED</b></font> = DOWNSTREAM PATCH NEEDS TO BE PORTED UPSTREAM<br>
<font color="ORANGE"><b>ORANGE</b></font> = RESOLUTION OF BUGZILLA BUG #961471 (Fedora 18+ & RHEL 7+)<br>

The following bug has been filed to correct this problem:

-   [Bugzilla Bug \#961471 - Port Downstream Patches Upstream](https://bugzilla.redhat.com/show_bug.cgi?id=961471)

This bug has been addressed in the following builds on the following platforms:

-   [mod\_nss-1.0.8-24.fc18 (Fedora 18)](http://koji.fedoraproject.org/koji/buildinfo?buildID=473622)
-   [mod\_nss-1.0.8-24.fc19 (Fedora 19)](http://koji.fedoraproject.org/koji/buildinfo?buildID=473624)
-   [mod\_nss-1.0.8-24.fc20 (Fedora 20)](http://koji.fedoraproject.org/koji/buildinfo?buildID=473627)

What do I need to run mod\_nss?
-------------------------------

mod\_nss requires [NSS](http://www.mozilla.org/projects/security/pki/nss/), [NSPR](http://www.mozilla.org/projects/nspr/) and [Apache](http://httpd.apache.org/) 2.2.x. and 2.4.x. It may support Apache 2.0.x but mod\_nss is no longer tested against it.

Where can I get a binary?
-------------------------

Some older RPMs are available for RHEL4, FC4 and FC5 can be retrieved from [<http://directory.fedoraproject.org/download/mod_nss>](http://directory.fedoraproject.org/download/mod_nss)

Fedora Core 5 and up ship with NSS and NSPR as system libraries so only the mod\_nss RPM is required for that distribution. mod\_nss is available in Fedora Core 5 and higher via:

` yum install mod_nss`

Now start or restart Apache:

`# /etc/init.d/httpd restart`

The mod\_nss configuration file can be found in /etc/httpd/conf.d/nss.conf. By default this RPM of mod\_nss will listen to port 8443 so it doesn't interfere with a current SSL server you may be running.

Most openssl private keys are not password protected, at least by default. In contrast, the NSS certificate database is usually password protected. In order to avoid being prompted at startup, a file may be used to store the token password. This file is configurable and by default is /etc/httpd/conf/password.conf (recommended owner apache, mode 0600).

When the RPM is installed a self-signed CA and server certificate are installed. The output from this generation is stored in /etc/httpd/alias/install.log.

What can I get the source?
--------------------------

You can download the source for mod\_nss from git.fedoraproject.org. To check out the source anonymously use

` git clone `[`http://git.fedorahosted.org/git/mod_nss.git`](http://git.fedorahosted.org/git/mod_nss.git)

If you have commit access, use

` git clone `[`ssh://git.fedorahosted.org/git/mod_nss.git`](ssh://git.fedorahosted.org/git/mod_nss.git)

You will have to apply for commit access - see our [contributing](../development/contributing.html) page on more information on how to get commit access.

A source tarball is available at [mod\_nss-1.0.9.tar.gz]({{ site.binaries_url }}/binaries/mod_nss-1.0.9.tar.gz)

How do I build it?
------------------

Refer to the README included in the distribution. In short you need the NSPR and NSS libraries, the Apache developer kit (apxs and the include headers) and a compiler. We've tested with gcc 3.x and Forte C v6.2 and 11.

You need to pass in the location of NSPR and NSS and if you are using your own build of Apache (as opposed to the system installed one) the path to apxs. The arguments are:

` --with-apr-config       Use apr-config to determine the APR directory`
` --with-apxs=PATH        Path to apxs`
` --with-nspr=PATH        Netscape Portable Runtime (NSPR) directory`
` --with-nspr-inc=PATH    Netscape Portable Runtime (NSPR) include file directory`
` --with-nspr-lib=PATH    Netscape Portable Runtime (NSPR) library directory`
` --with-nss=PATH         Network Security Services (NSS) directory`
` --with-nss-inc=PATH     Network Security Services (NSS) include directory`
` --with-nss-lib=PATH     Network Security Services (NSS) library directory`
` --enable-ssl2           enable the SSL v2 protocol. (default=no)`
` --enable-ecc            enable Elliptical Curve Cyptography (default=no)`

The multiple options for NSS and NSPR are due to the two possible situations. You can have the include and library files under a single directory, say /components/nss/lib and /components/nss/include or you can have them installed in discrete directorys, say /usr/include/nss3 and /usr/lib/nss3. If you have them together you can use --with-nss. If you have them in separate locations, use --with-nss-inc and --with-nss-lib. You will likely use the later.

When building for use with adminserver, try something like this (directory names may change depending on your kernel release, etc). This assumes you are building with the Fedora Directory Server source tree.

This was done on RHEL 3:

`./configure --with-apr-config --with-apxs=/usr/sbin/apxs \`
`--with-nspr-inc=../mozilla/dist/Linux2.4_x86_glibc_PTH_DBG.OBJ/include/ \`
`--with-nspr-lib=../mozilla/dist/Linux2.4_x86_glibc_PTH_DBG.OBJ/lib \`
`--with-nss-inc=../mozilla/dist/public/nss \`
`--with-nss-lib=../mozilla//dist/Linux2.4_x86_glibc_PTH_DBG.OBJ/lib/`

On modern Fedora systems if you are using the system Apache you just need:

`./configure --with-apr-config`

Can I use my existing mod\_ssl/OpenSSL certificates with mod\_nss?
------------------------------------------------------------------

Yes. NSS uses a certificate database rather than discrete files. It is possible to convert the OpenSSL certificate files (these generally have .pem as the extension) for use with mod\_nss. This involves converting the cert and key into a transportable file based on the PKCS \#12 standard, then using an NSS utility to load it into your NSS database.

Here's how:

-   Convert the OpenSSL key and certificate into a PKCS\#12 file

`% openssl pkcs12 -export -in cert.pem -inkey key.pem -out server.p12 -name \"Server-Cert\" -passout pass:foo`

-   Create an NSS database. You just need to specify the database directory, not a specific file. This will create the 3 files that make up your database: cert8.db, key3.db and secmod.db.

`% certutil -N -d /path/to/database`

-   Load the PKCS \#12 file into your NSS database.

`% pk12util pk12util -i server.p12 -d /path/to/database -W foo`

This loads your server certificate and gives it a "nickname." This nickname is a short name for the certificate. This makes it easier to reference in configuration files than the certificate subject. In this case, you would set your NSSNickname value to "Server-Cert"

You will also need to import the CA certificate that issued the server certificate. In this case you don't need the key of the CA, just the public certificate. Assuming you have the ASCII representation of it (e.g. a PEM file) you can load it as follows:

`% certutil -d /path/to/database -A -n "My Local CA" -t \"CT,,\" -a -i /path/to/ca.pem`

certutil and pk12util are both NSS utilities.

Why is SSL 2 disabled by default?
---------------------------------

It has been obsolete since SSL3 was introduced in 1996 but has been kept around because of export restrictions and the fact that many sites still use it. Netcraft [reports](http://news.netcraft.com/archives/2006/05/31/most_sites_ready_for_ssl_progress.html) that usage is down considerably so there is no big hue and cry for it on the server side.

On the client side both [Mozilla](http://weblogs.mozillazine.org/gerv/archives/2005/05/quick_ssl_versi.html) and [IE7](http://blogs.msdn.com/ie/archive/2005/10/22/483795.aspx) are calling for dropping support for the protocol. By not allowing it by default in mod\_nss we are forcing those who want to use it to reconsider.

How do I use the NSS command-line Utilities
-------------------------------------------

Documentation on the NSS tools is available at <http://www.mozilla.org/projects/security/pki/nss/tools/>

Here are some common usages and some basic rules of thumb:

-   The -d argument tells the tool which database to operate on. It defaults to \~/.mozilla which isn't very useful. If your database is in the same directory you are in you can always use -d .
-   There is nothing magical about a certificate nickname. We often use "Server-Cert" but it can be basically any ascii string. Use something that will be meaningful to you. This is the string that is displayed when you list certificates.
-   The -t argument sets the trust of a certificate. It is expressed as 3 values in this order: SSL, email, object signing separated by commas.

The possible values for trust are:

    p    Valid peer
    P    Trusted peer (implies p)
    c    Valid CA
    T    Trusted CA to issue client certificates (implies c)
    C    Trusted CA to issue server certificates (SSL only)
          (implies c)
    u    Certificate can be used for authentication or signing
    w    Send warning (use with other attributes to inclu

### Create a new NSS database

    % certutil -N -d /path/to/database/dir

### List all the certificates in an NSS database

    % certutil -L -d /path/to/database/dir

### Add a CA certificate to an NSS database

    % certutil -A -d /path/to/database/dir -n "nickname" -t "CT,," -i -a < CAcert.txt

### Generate a new Certificate Signing Request (CSR)

    % certutil -R -d /path/to/database/dir -s "certificate DN" -o output_file -g <keysize>

The keysize is the \# of bits in the private key. It can be in the range of 512-8192 bits, with a default of 1024.

In a server certificate DN the common name should have the form of: CN=fully-qualified hostname

When a client gets the certificate it compares the hostname in the URL to the CN in the subject of the certificate and if they don't match a warning is presented to the user.

Examples include:

-   CN=myhost.example.com,o=My Org,c=US
-   CN=myhost.example.com,dc=myorg,dc=com

### Verify that a certificate is valid and trusted

    % certutil -V -u V -d /path/to/database/dir -n "nickname"

### Load a PKCS\#11 Module

    % modutil -add "My Module Name" -libfile /path/to/library.so -dbdir /path/to/database/dir

This creates a pointer in secmod.db which will make the slots and tokens available. Some common commands to use with this:

List all modules:

    % modutil -list -dbdir /path/to/database/dir

List all certificates on all tokens:

    % certutil -L -d /path/to/database/dir -h all

