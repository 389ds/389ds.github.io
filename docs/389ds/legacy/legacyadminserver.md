---
title: "LegacyAdminServer"
---
**NOTE: These instructions are for Admin Server 1.0.4 and earlier**. See [AdminServer](../administration/adminserver.html) for current Admin Server information.

# Legacy Admin Server
---------------------

Introduction
============

Admin Server is the http based adminstration engine used by the Directory Server to run the console and the web based applications such as Admin Express, DS Gateway, Org Chart, and others. It consists of a collection of CGI binary programs and scripts, HTML pages and Javascript code, the adminserver console module, setuputil modules and programs, and config files. It was formerly based on the Netscape Enterprise Server but has been ported to use the [Apache](http://httpd.apache.org) 2.x webserver using the Worker model (multi-threaded mode, not multi process). The main http functionality consists of the Apache module [mod\_admserv](../administration/mod-admserv.html), and the TLS/SSL functionality is provided by the Apache module [mod\_nss](../administration/mod-nss.html). Support for starting up servers on low port numbers is provided by [mod\_restartd](../administration/mod-restartd.html).

Build Preparation
=================

To build Admin Server, see the [Directory Server Building](../development/building.html) page and get Compilers and Tools you need.

To build Admin Server including the dependent components manually, you will need ICU, AdminUtil, SetupUtil, Console, Onlinehelp, and the mozilla.org components in <srcroot>. (Let's assume we build Admin Server in <srcroot> - you should use the same source root as for Directory Server i.e. build Admin Server in the same source root since it can share most of the same components).

    <srcroot>/icu
    <srcroot>/mozilla
    <srcroot>/setuputil
    <srcroot>/adminutil
    <srcroot>/mod_admserv
    <srcroot>/mod_nss
    <srcroot>/mod_restartd
    <srcroot>/console
    <srcroot>/onlinehelp
    <srcroot>/adminserver

Their build instructions are available on the [Directory Server Building](../development/building.html) page as well as [AdminUtil](../administration/adminutil.html), [SetupUtil](../FAQ/setuputil.html), [Mod\_nss](../administration/mod-nss.html), [Mod\_admserv](../administration/mod-admserv.html), [BuildingConsole](../development/buildingconsole.html), [Mod\_restartd](../administration/mod-restartd.html) and [Onlinehelp](onlinehelp.html) pages. The Admin Server source is found [here]({{ site.baseurl }}/binaries/fedora-adminserver-1.0.1.tar.gz).

Or you can check out the source code:

    % cd to     <srcroot>
    % cvs -d :pserver:anonymous@cvs.fedora.redhat.com:/cvs/dirsec -z3 co [-r RELEASETAG] adminserver    

The current release tag is **FedoraAdminserver103.**

Special Note about the Console Build Location
---------------------------------------------

Console puts the files it builds into ../imports and ../built. The adminserver looks in console/imports and console/built so you'll need to create a couple of symbolic links otherwise the build will fail looking for some files.

For example, we've checked out and built all of our files in /home/me/source/. So if we look there we'll have something like:

    % ls    
    10.11/        built/    icu-3.4.tgz   mod_nss/     setuputil/    
    adminserver/  console/  imports/      mozilla/    
    ...    

We need to create symbolic links for built and imports into console ala:

    % cd console    
    % ln -s ../built built    
    % ln -s ../imports imports    

We need to create a link for built in adminserver as well. It is import to do this <i>before</i> you run make for the first time:

    % cd adminserver    
    % ln -s ../built built    

Now you are ready to build.

Building
========

Note that adminserver includes the Java code for building the admin server part of the java console, so in addition to setting up your environment to build the regular C/C++ code described in [Building](../development/building.html) you will need to set up your environment to build Java code as described in [BuildingConsole](../development/buildingconsole.html). At some point we will probably move the Java code out of the admin server and into its own adminconsole module.

Then, build Admin Server as follows:

    % cd adminserver ; make [BUILD_DEBUG=optimize] [USE_64=1]    
    make options:    
      BUILD_DEBUG=optimize  - Build optimized version    
      BUILD_DEBUG=full      - Build debug version (default: without BUILD_DEBUG macro, debug version is built)    
      USE_64=1              - Build 64-bit version (currently, for Solaris and HP only)    

The built libraries and setuputil packages are found in adminserver/built/package directory.

Installation
============

Admin Server is currently only installed as part of the Directory Server. [Building](../development/building.html) gives instructions about how to use Admin Server in the Directory Server build.

The binaries end up in built/package/<OS_Release>. One example is:

    % ls built/package/RHEL3_x86_gcc3_DBG.OBJ/    
    admin/  LICENSE.txt*  setup*     svrcore/    
    base/   README.txt*   setup.inf  unzip_wrapper.pl    

You can run the program setup to install a stand-alone admin server. During installation you need to register it with an existing Fedora Directory Server so that console is tied into it. Unless you are working on the adminserver code itself there is little reason to ever do this.

Architecture
============

To build admin server you need no less than 11 separate components. What are the components and what do they do?

Mozilla libraries

-   NSPR - Portability library that provides threading, string and I/O capabilities.
-   NSS - Provides SSL and crypto operations.
-   LDAPSDK - LDAP toolkit
-   SVRCORE - An SSL Pin manager.

libicu is an i18n library from IBM that simplifies handling different charsets and locales.

setuputil is a toolkit for creating setup programs. Admin Server has its own setup installer.

adminutil is a library that provides some low-level functions that mod\_admserv and adminserver use for doing LDAP queries.

mod\_admserv is an Apache module that is a conduit between the Java Console and the Directory Server. It handles authentication and does some URL rewriting so the right CGI's get called.

mod\_nss provides crypto for Apache using NSS.

mod\_restartd allows CGIs to be run as root.

Console is a Java application that provides a GUI interface to the user for administering servers and users. It is a framework that allows plugins. The directory server provides a plugin for management. Similarly adminserver provides its own set of jars for configuring the web server.

Onlinehelp is just that, a set of html files that provides help from within the console and the web-based Admin Express.

Adminserver is the glue that ties all of this together. During the build process it:

-   Builds the libraries under lib/ that are used by the CGI's
-   Builds the CGI's that the admin server uses to modify local configuration files, manage certificates and start and stop the servers.
-   Builds the jar files to register Admin Server in Console
-   Pulls all of the component pieces together and packages them into build/package/

Admin Server Config Files
=========================

These are the various config files used by adminutil/setuputil/adminserver/ldapserver.

dbswitch.conf
-------------

### Use

Contains the LDAP URL of the configuration directory server. The suffix of the URL is usually o=NetscapeRoot which is usually the config suffix.

### Location

serverroot/shared/config/dbswitch.conf

### Format

directory default ldap[s]://host.domain.tld[:portnumber]/suffix Note that the LDAP URL must be URL escaped - see below

    directory default     ldap://localhost.localdomain:10200/o%3DNetscapeRoot

Also note that if you use ldaps instead of ldap, and the secure port instead of the non-secure port, the Admin Server will use SSL to talk to the configuration DS instead of plain LDAP.

### Files

    adminserver/admserv/cgi-src40/dsconfig.c    
    adminutil/lib/libadminutil/admutil.c    
    setuputil/installer/include/global.h - DEFAULT_LDAPSWITCH definition    
    setuputil/installer/include/setupdefs.h - SETUP_DEFAULT_LDAPSWITCH definition    
    adminserver/admserv/newinst/src/ux-update.cc (DEFAULT_LDAPSWITCH)    
    setuputil/installer/lib/setupapi.cpp (SETUP_DEFAULT_LDAPSWITCH)    

### Use Cases

#### AdminUtil - admldapBuildInfo/admldapBuildInfoSSL

This is the usual way to get a connection to the configuration DS. This function will use the LDAP URL in dbswitch.conf for the ldap server host and port, and whether it uses SSL. It will also open a connection and attempt to bind using the DN specified in the sie field in adm.conf (and the cleartext password in the siepid field if present, otherwise it will use the credentials passed in by the user/admin). If the LDAP URL begins with ldaps, then admldapBuildInfoSSL must be used instead. admldapBuildInfoSSL will use the certDBFile and keyDBFile fields in adm.conf for use with NSS. ADMSSL\_Init() or ADMSSL\_InitSimple() must be called before admldapBuildInfoSSL can be used to establish an SSL connection to the LDAP server.

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

adm.conf
--------

### Use

Holds the following information:

-   port - used during Admin Server setup to get the admin server listen port if setup cannot get it from the admin server SIE in the config DS - not used at runtime, console.conf value is used instead
-   sie - the DN of the Admin Server entry in the config DS - used by the admin server as its bind DN to the config DS, and also as the base entry for Admin Server configuration (cached in local.conf - see below)
-   siepid - the cleartext password of the sie DN used to bind to the config DS
-   certDBFile - the file name (no path) of the certificate database (e.g. admin-serv-hostname-cert8.db)
-   keyDBFile - the file name (no path) of the key database (e.g. admin-serv-hostname-key3.db)
-   ldapStart - the command to use to start up the configuration directory server
-   userdn - The DN of the console admin user - will only use this if admldapGetUserDN() cannot find uid=name in the config DS
-   isie - ???

The other fields such as ldaphost and ldapport appear to be unused - dbswitch.conf is used for those values. The port field is the port number that the admin server listens to, but this is unused. Admin Server gets its listen port from console.conf instead.

### Location

admin-serv/config/adm.conf

### Format

The format is keyword ":" whitespace value e.g.

    ldapHost:   localhost.localdomain
    ldapPort:   10200
    sie:   cn=admin-serv-localhost, cn=Fedora Administration Server, cn=Server Group,
     cn=localhost.localdomain, ou=localdomain, o=NetscapeRoot
    siepid:   password
    isie:   cn=Fedora Administration Server, cn=Server Group, cn=localhost.localdomain,
     ou=localdomain, o=NetscapeRoot
    port:   10201
    ldapStart:   slapd-localhost/start-slapd

### Files

    adminutil/lib/libadminutil/admutil.c    
    adminutil/lib/libadmsslutil/admsslutil.c    
    adminserver/admserv/cgi-src40/config.c    
    adminserver/admserv/cgi-src40/dsconfig.c    
    adminserver/admserv/cgi-src40/htmladmin.c    
    adminserver/admserv/cgi-src40/admpw.c    
    adminserver/admserv/cgi-src40/migrateConfig.c    
    adminserver/admserv/cgi-src40/start_config_ds.c (ADMIN_CONFIG_FILE)    
    adminserver/admserv/newinst/src/ux-config.cc    
    adminserver/admserv/newinst/src/ux-update.cc    
    adminserver/include/libadmin/libadmin.h (NSADMIN_CONF definition)    
    setuputil/installer/unix/lib/ux-util.cc    
    setuputil/installer/include/setupdefs.h - SETUP_ADM_CONF definition - not used?    
    adminserver/lib/libadmin/admserv.c (NSADMIN_CONF)    

### Use Cases

This file is generally used by admldapBuildInfo[SSL] in conjunction with dbswitch.conf to get a connection to and information about the configuration DS.

admpw
-----

### Use

Used by the admin server as the fallback auth in case the config DS is down. That is, when the user authenticates to the admin server, usually the auth is done against the config DS. If it is down, admin server will fallback to password file auth, comparing the password given by the user to the hashed password in admpw.

### Location

admin-serv/config/admpw

### Format

adminid ":" SHA1 hashed password e.g.

    admin:{SHA}0tPi4uNarrdmDdIU3uwhhQlNqtb=    

### Files

    mod_admserv/mod_admserv.c    
    adminutil/lib/libadminutil/admutil.c    
    adminserver/admserv/cgi-src40/admpw.c    
    adminserver/admserv/newinst/src/ux-config.cc    
    adminserver/admserv/newinst/src/ux-update.cc    
    adminutil/lib/libadminutil/admutil_pvt.h (struct _AdmldapHdnl - admpwFilePath - apparently not used)    

ldap.conf
---------

### Use

Used during setup to get the LDAP URL of the config DS (falls back to dbswitch.conf if not found), and the DN of the console admin user. Only the host and port in the url are used. Looks like instance creation overwrites this file, so you could end up with this file containing the URL of an LDAP server other than the config DS. Apparently the setupapi code looks for a keyword of ConfigURL, but the DS code that writes the file uses a keyword of url, so the setupapi code always uses the fallback dbswitch.conf for the config ds url. Looks like it is only used to display the defaults for the config ds url and admin user DN - possible get rid of?

### Location

shared/config/ldap.conf

### Format

keyword whitespace value e.g.

    url     ldap://localhost.localdomain:389/dc=example,dc=com
    admnm   uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot

### Files

    ldapserver/ldap/admin/src/cfg_sspt.c    
    ldapserver/ldap/admin/src/create_instance.c    
    setuputil/installer/include/setupdefs.h - SETUP_LDAP_CONF definition    
    setuputil/installer/lib/setupapi.cpp (SETUP_LDAP_CONF)    

ds.conf
-------

### Use

Used during setup to get the default Admin Domain to show to the user. Looks like the setup code (see Files) will look for the value in ldap.conf (see above) first, then in ds.conf if not in ldap.conf. So we might just be able to get rid of this file and just use ldap.conf.

### Location

shared/config/ds.conf

### Format

keyword ":" value e.g.

    AdminDomain:localdomain    

Looks like the only keyword is AdminDomain.

### Files

    adminserver/admserv/newinst/src/ux-update.cc    
    setuputil/installer/include/setupdefs.h - SETUP_DS_CONF definition    
    setuputil/installer/lib/setupapi.cpp (SETUP_DS_CONF)    

local.conf
----------

### Use

This is a read-only cache of the admin server configuration information stored in the admin server's SIE in the configuration DS. When the admin server starts up, and it cannot read its information from the config DS (using adm.conf and dbswitch.conf to bootstrap the connection), it uses local.conf. This configuration is done transparently via the pset interfaces in adminutil.

### Location

admin-serv/config/local.conf

### Format

Sort of a bastardized ldif format with no DN. The implicit DN is the SIE DN (from adm.conf - sie). Child DN are represented by using name.attribute e.g. configuration.nsServerPort means the nsServerPort entry in the cn=configuration child of the SIE DN. Example:

    nsServerID: admin-serv
    serverRoot: /home/rich/102srv
    serverProductName: Administration Server
    serverHostName: localhost.localdomain
    uniqueMember: cn=admin-serv-localhost, cn=Fedora Administration Server, cn=Server Group, cn=localhost.localdomain,    
     ou=localdomain, o=NetscapeRoot
    installationTimeStamp: 20060406130914Z
    ...
    configuration.nsServerPort: 10201

### Files

See the pset interface in adminutil/lib/libadminutil and libadmsslutil

