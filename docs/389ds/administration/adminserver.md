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

Building
========

The simplest way is to just do

    configure --disable-tests [options]
    make

**configure** attempts to find all of the dependent components using pkg-config (e.g. pkg-config --libs nspr) or using the component specific script (e.g. net-snmp-config or icu-config). If that fails, configure will attempt to use the components from the standard system locations. You can override these with either the standard configure --dir options (e.g. --libdir=/path, --includedir=/path) or by overriding specific component paths (e.g. --with-nspr=/path/to/nspr --with-nss=/path/to/nss). Use configure --help to see all of the options.

There are some tests which can be used if you already have a directory server + admin server set up. To enable these, run configure without --disable-tests.

For the Apache components, there are several ways to tell it where to find them:

-   By default, configure will look for apr-config (or apr-1-config) and apxs in the PATH (usually provided by the httpd-devel and apr-devel packages)
-   You can tell configure where to find apr-config and apxs by using --with-apr-config=/path/to/apr-config and --with-apxs=/path/to/apxs

        configure --with-apr-config=/usr/local/apache2/bin/apr-config --with-apxs=/usr/local/apache2/sbin/apxs

-   You can tell configure where the Apache binary is by --with-httpd=/path/to/httpd.worker

        configure --with-httpd=/usr/local/apache2/sbin/httpd.worker

mod\_nss is provided with Fedora and with EL5 and later. If configure cannot find mod\_nss, you can specify the locations:

    --with-modnss-lib=/path/to/libmodnss.so
    --with-modnss-bin=/path/to/nss\_pcache

For example

    configure --with-modnss-lib=/usr/local/apache2/modules/libmodnss.so --with-modnss-bin=/usr/local/apache2/sbin/nss_pcache

There are 3 configure options that control where the files go during the install phase:

    --with-fhs  - this tells configure to use the standard FHS layout - see [FHS_Packaging](../development/fhs-packaging.html) for details
    --with-fhs-opt  - this tells configure to use the FHS /etc/opt, /var/opt, and /opt hierarchy
    --prefix=/path  - the default value of prefix is /opt/dirsrv

The build honors the DESTDIR=/path option, so you could do something like

    configure --with-fhs ...
    make DESTDIR=/var/tmp/tmpbuild install

to copy the files under /var/tmp/tmpbuild using the FHS hierarchy - this is essentially what rpmbuild does. Developers will probably want to use something like

    configure --prefix=/home/richm/fds11
    make install

to install the server under /home/rich/fds11 for testing purposes.

-   USE\_64=1 is for 64 bit platforms, as for all of the components that you just built.

        configure [options]
        make USE_64=1

### Notes

I find it useful to create a *build* directory and run configure and make in that directory, rather than in the source directory, to keep the source directory clean (e.g. for making development tarball releases, as opposed to doing make dist).

    mkdir build ; cd build
    /path/to/adminserver/configure [options]
    make

This is especially useful if you are using a single source directory for building on multiple architectures:

    mkdir build.f8_i386
    mkdir build.f8_x86_64

and so on.

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
    AdminDomain: example.com`

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

