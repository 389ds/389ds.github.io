---
title: "Admin Server"
---

# Admin Server
--------------

{% include toc.md %}

Introduction
============

Admin Server is the http based administration engine used by the Directory Server to run the console and the web based applications such as Admin Express, DS Gateway, Org Chart, and others. It consists of a collection of CGI binary programs and scripts, HTML pages and Javascript code, the adminserver console module, setuputil modules and programs, and config files. It was formerly based on the Netscape Enterprise Server but has been ported to use the [Apache](http://httpd.apache.org) 2.x webserver using the Worker model (multi-threaded mode, not multi process). The main http functionality consists of the Apache module [mod_admserv](mod-admserv.html), and the TLS/SSL functionality is provided by the Apache module [mod_nss](mod-nss.html). Support for starting up servers on low port numbers is provided by [mod_restartd](mod-restartd.html).

Build Preparation
=================

To build Admin Server, see the [Directory Server Building](../development/building.html) page and get Compilers and Tools you need.

To build Admin Server including the dependent components manually, you will need ICU, AdminUtil, mod\_nss, and the mozilla.org components. Their build instructions are available on the [Directory Server Building](../development/building.html) page as well as [AdminUtil](adminutil.html), [Mod_nss](mod-nss.html), [Mod_admserv](mod-admserv.html) and [Mod_restartd](mod-restartd.html). The Admin Server source is found at [Source](../development/source.html).

-   [Source](../development/source.html)

<a name="build"></a>

Building
========

The recommended build layout is to create a directory called "BUILD" on the same level as the the root directory fort the source code

    /home/user1/source/admin  -> Admin Server source code is under here
    /home/user1/source/BUILD

Then run your **configure** and **make** commands from this directory.  It keeps the source tree clean, and makes it easier to sumbit patches, etc.

**Optimized Build**

    ../admin/configure --with-selinux --with-systemdsystemunitdir=/usr/lib/systemd/system --with-fhs --libdir=/usr/lib64 --with-openldap
    make install

**Debug Build**

    CFLAGS='-g -pipe -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' CXXFLAGS='-g -pipe -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../admin/configure --with-selinux --with-systemdsystemunitdir=/usr/lib/systemd/system --enable-debug --with-fhs --libdir=/usr/lib64 --with-openldap
    make install

There are 3 configure options that control where the files go during the install phase:

    --with-fhs  - this tells configure to use the standard FHS layout - see [FHS_Packaging](../development/fhs-packaging.html) for details
    --with-fhs-opt  - this tells configure to use the FHS /etc/opt, /var/opt, and /opt hierarchy
    --prefix=/path  - the default value of prefix is /opt/dirsrv

The build also honors the **DESTDIR=/path** option, which copies the files to a specific location using the FHS hierarchy - this is essentially what rpmbuild does.  Developers will probably want to use something like:

    configure --with-fhs ...
    make DESTDIR=/var/tmp/tmpbuild install

To install the server under a specific directory use the "--prefix" argument:

    configure OPTIONS --prefix=/home/user1/myAdminServer/
    make install

Debugging Admin Server
======================

You should either be using a debug build or have the debuginfo package installed before proceeding.

### Attach to the Process

This assumes the Admin Server is running as *nobody*.  You will use gdb to attach to the admin-serv process that runs as nobody

    # ps -ef | grep admin-serv
    root      4455     1  0 Aug28 ?        00:00:04 /usr/sbin/httpd -k start -f /etc/dirsrv/admin-serv/httpd.conf
    root      4456  4455  0 Aug28 ?        00:00:00 /usr/sbin/httpd -k start -f /etc/dirsrv/admin-serv/httpd.conf
    nobody    4457  4455  0 Aug28 ?        00:00:00 /usr/sbin/httpd -k start -f /etc/dirsrv/admin-serv/httpd.conf

    # gdb -p 4457
    (gdb) set follow-fork-mode child
    (gdb) "set some break points"
    (gdb) c

### Start/run the Admin Server using gdb

    # gdb /usr/sbin/httpd
    (gdb) set args -k start -f /etc/dirsrv/admin-serv/httpd.conf
    (gdb) set follow-fork-mode child
    (gdb) run
    
    
Installation
============

See [Install_Guide](../legacy/install-guide.html) for information about how to set up and configure the admin server.

Architecture
============

To build admin server you need no less than 11 separate components. What are the components and what do they do?

Mozilla libraries

-   NSPR - Portability library that provides threading, string and I/O capabilities.
-   NSS - Provides SSL and crypto operations.
-   LDAPSDK - LDAP toolkit
-   SVRCORE - An SSL Pin manager.

libicu is an i18n library from IBM that simplifies handling different charsets and locales.

adminutil is a library that provides some low-level functions that mod_admserv and adminserver use for doing LDAP queries.

mod_admserv is an Apache module that is a conduit between the Java Console and the Directory Server. It handles authentication and does some URL rewriting so the right CGI's get called.

mod_nss provides crypto for Apache using NSS.

mod_restartd allows CGIs to be run as root.

Admin Server Config Files
=========================

These are the various config files used by adminserver.

adm.conf
--------

### Use

Holds the following information:

-   sie - the DN of the Admin Server entry in the config DS - used by the admin server as its bind DN to the config DS, and also as the base entry for Admin Server configuration (cached in local.conf - see below)
-   ldapurl - The LDAP URL of the configuration directory server - Note that the LDAP URL must be URL escaped - see below

    ldapurl: ldap://localhost.localdomain:10200/o%3DNetscapeRoot

Also note that if you use ldaps instead of ldap, and the secure port instead of the non-secure port, the Admin Server will use SSL to talk to the configuration DS instead of plain LDAP.

-   ldapStart - the command to use to start up the configuration directory server
-   userdn - The DN of the console admin user - will only use this if admldapGetUserDN() cannot find uid=name in the config DS
-   AdminDomain - the admin domain of this admin server
-   sysuser - the admin server userid for the apache process (e.g. nobody)
-   sysgroup - the group to use for sysuser (e.g. nobody)
-   SuiteSpotUserID - the directory server userid for the process (e.g. nobody)
-   SuiteSpotGroup - the group that both sysuser and SuiteSpotUserID must belong to
-   isie - ???
-   sslVersionMin - The minimum SSL version to use:  SSL3, TLS1.0, TLS1.1, TLS1.2
-   sslVersionMax - The maximum SSL version to use:  SSL3, TLS1.0, TLS1.1, TLS1.2

### Location

FHS location - /etc/dirsrv/admin-serv/adm.conf

### Format

The format is keyword ":" whitespace value e.g.

    userdn: uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot
    sysuser: nobody
    sysgroup: nobody
    SuiteSpotUserID: nobody
    SuiteSpotGroup: nobody
    sie: cn=admin-serv-hostname, cn=Fedora Administration Server, cn=Server Group, cn=hostname.example.com, ou=example.com, o=NetscapeRoot
    ldapurl: ldap://hostname.example.com:389/o=NetscapeRoot
    ldapStart: /usr/lib/dirsrv/slapd-hostname/start-slapd
    isie: cn=Fedora Administration Server, cn=Server Group, cn=hostname.example.com, ou=example.com, o=NetscapeRoot
    AdminDomain: example.com
    sslVersionMin: TLS1.1
    sslVersionMax: TLS1.2

### Files

    adminutil/lib/libadminutil/admutil.c
    adminutil/lib/libadmsslutil/admsslutil.c
    adminserver/admserv/cgi-src40/config.c
    adminserver/admserv/cgi-src40/dsconfig.c
    adminserver/admserv/cgi-src40/htmladmin.c
    adminserver/admserv/cgi-src40/admpw.c
    adminserver/admserv/cgi-src40/migrateConfig.c
    adminserver/admserv/cgi-src40/start_config_ds.c
    adminserver/include/libadmin/libadmin.h
    adminserver/lib/libadmin/admserv.c

### Use Cases

This file is generally used by admldapBuildInfo[SSL] to get a connection to and information about the configuration DS.

#### AdminUtil - admldapBuildInfo/admldapBuildInfoSSL

This is the usual way to get a connection to the configuration DS. This function will use the ldapurl in adm.conf for the ldap server host and port, and whether it uses SSL. It will also open a connection and attempt to bind using the credentials passed in by the user/admin. If the LDAP URL begins with ldaps, then admldapBuildInfoSSL must be used instead. admldapBuildInfoSSL will look for the NSS cert and key databases in the same directory as adm.conf. ADMSSL\_Init() or ADMSSL\_InitSimple() must be called before admldapBuildInfoSSL can be used to establish an SSL connection to the LDAP server.

#### Admin Server

Calls admldapGetLocalUserDirectory to figure out what the user/group directory server URL is. The call stack looks like this:

     admldapGetLocalUserDirectory
     +admldapGetUserDirectory(targetDN=NULL)
     ++admldapCreateLDAPHndl - returns DN=cn=configuration,siedn of admin server under o=NetscapeRoot,
                               which is obtained from the sie field in adm.conf
     ++admlapGetUserDirectoryReal
     +++admldapGetUserDirectoryInfo - this function will recursively look for an entry which matches the
                                      search filter (objectclass=nsDirectoryInfo) and has the attribute
                      nsDirectoryURL with a non-empty value.  If nsDirectoryURL is not
                      present, it will look for the attribute nsDirectoryInfoRef in the
                      entry and recursively call itself with the value of that attribute
                      which is a DN until it finds a valid nsDirectoryURL

The entry which it will eventually get by default is this one - note that localdomain will be whatever was specified as the AdminDomain (i.e. the real DNS domain) during setup:

    dn: cn=UserDirectory, ou=Global Preferences, ou=localdomain, o=NetscapeRoot
    objectClass: top
    objectClass: nsDirectoryInfo
    cn: UserDirectory
    nsDirectoryURL: ldap://localhost.localdomain:389/dc=example,dc=com
    nsDirectoryFailoverList:

nsDirectoryFailoverList is a multi-valued attribute which specifies other user/group servers to use in case the primary one (nsDirectoryURL) is unreachable. Other attributes which may be present in this entry:

-   nsBindDN - the bind DN to use to connect to the user/group DS
-   nsBindPassword - the cleartext password to use with the nsBindDN

admpw
-----

### Use

Used by the admin server as the fallback auth in case the config DS is down. That is, when the user authenticates to the admin server, usually the auth is done against the config DS. If it is down, admin server will fallback to password file auth, comparing the password given by the user to the hashed password in admpw.

### Location

FHS location - /etc/dirsrv/admin-serv/admpw

### Format

adminid ":" SHA1 hashed password e.g.

    admin:{SHA}0tPi4uNarrdmDdIU3uwhhQlNqtb=

### Files

    mod_admserv/mod_admserv.c
    adminutil/lib/libadminutil/admutil.c
    adminserver/admserv/cgi-src40/admpw.c
    adminutil/lib/libadminutil/admutil_pvt.h (struct _AdmldapHdnl - admpwFilePath - apparently not used)

local.conf
----------

### Use

This is a read-only cache of the admin server configuration information stored in the admin server's SIE in the configuration DS. When the admin server starts up, and it cannot read its information from the config DS (using adm.conf to bootstrap the connection), it uses local.conf. This configuration is done transparently via the pset interfaces in adminutil.

### Location

FHS location - /etc/dirsrv/admin-serv/local.conf

### Format

Sort of a bastardized ldif format with no DN. The implicit DN is the SIE DN (from adm.conf - sie). Child DN are represented by using name.attribute e.g. configuration.nsServerPort means the nsServerPort attribute in the cn=configuration child entry of the SIE DN. Example:

    nsServerID: admin-serv
    serverProductName: Administration Server
    serverHostName: localhost.localdomain
    uniqueMember: cn=admin-serv-localhost, cn=Fedora Administration Server, cn=Server Group, cn=localhost.localdomain,ou=localdomain, o=NetscapeRoot
    installationTimeStamp: 20060406130914Z
    ...
    configuration.nsServerPort: 10201`

### Files

See the pset interface in adminutil/lib/libadminutil and libadmsslutil

