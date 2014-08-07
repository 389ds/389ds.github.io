---
title: "Discrete Packaging"
---

# Discrete Packaging
--------------------

Introduction
============

The next version of the Directory Server will not be packaged as one large package containing all of the subcomponents. Instead, it will be split into discrete packages. Where possible, the directory server will use components already on the operating system if they meet our requirements for functionality (e.g. admin server requires Apache in worker/threaded mode) and robustness (e.g. the DS requires Berkeley DB 4.2.52 + latest patches). For Fedora Core 5/RHEL5 and later, this means using the system NSPR and NSS. Other components will be installed in system locations or in FHS friendly subdirectories that won't conflict with similar files already installed in the OS. The server will always be able to use patched versions of files instead of OS provided ones if necessary.

Benefits
========

-   Smaller disk footprint
-   Faster install
-   Faster, easier build
-   Easy to patch
-   Faster security issue response
-   Native packaging (RPM, etc.) - use familiar OS tools to manage software packages

List of Packages
================

The Directory Server itself will be split into several packages. Each dependent package (except where noted) will have a run time package and a build time package, and a tools package for its command line tools (e.g. NSS tools will contain certutil, etc.; Mozldap tools will contain ldapsearch, etc.).

DS Core
-------

This is just the core LDAP server engine, including plug-ins and command line utilities necessary to manage the server, including db2ldif, db2bak, and other scripts; start/stop init scripts; etc.

The core server depends on these components: NSPR, NSS, svrcore, Mozldap, perl, PerLDAP, bdb, cyrus-sasl, ICU, net-snmp

DS Devel
--------

This is primarily for plug-in developers - contains headers, sample code, Makefiles, autotool files, scripts - depends on DS Core

DS Admin
--------

This contains the admin server, CGI programs, HTML pages, online help, and command line tools used to interface to the admin server and console

DS Admin depends on the following components (in addition to those above): adminutil, setuputil, Apache, mod\_nss, mod\_admserv, mod\_restartd, onlinehelp, dsonlinehelp

DSGW/Phonebook, Org Chart, and DSMLGW
-------------------------------------

Will be split off into their own packages - you will be able to install these against a standalone Apache/Tomcat - you won't have to depend on the Admin Server for these anymore

-   DSGW depends on NSPR, NSS, Mozldap, Apache
-   Org Chat depends on NSPR, NSS, Mozldap, PerLDAP, Apache
-   DSMLGW depends on Java, NSPR, NSS, JSS, ldapjdk, servlet engine (e.g. tomcat), xerces, other web services software

Console, Admin Server Console, and Directory Server Console
-----------------------------------------------------------

Will be split off into their own packages

-   Console depends on Java, NSPR, NSS, JSS, ldapjdk

