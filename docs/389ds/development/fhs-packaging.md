---
title: "FHS Packaging"
---

# FHS Packaging
---------------

{% include toc.md %}

Links
-----

The proposed new layout is based on FHS (Filesystem Hierarchy Standard) and Fedora Packaging.
Fedora Packaging Guidelines <http://fedoraproject.org/wiki/Packaging/Guidelines>
FHS (Filesystem Hierarchy Standard) <http://www.pathname.com/fhs/>

New packages
------------

-   389-ds-base - just the core directory server engine and command line tools - no admin or console
-   389-ds-base-devel - files for plugin writers
-   389-admin - the admin server http engine and CGI programs/scripts
-   idm-console-framework - the core console jar files shared with other products
-   389-console - the Fedora branded text/graphics for the console
-   389-ds-console - the console jars for managing fedora-ds-base
-   389-admin-console - the console jars for managing fedora-ds-admin

Core 389
--------

The layout of the next version of Directory Server is going to look much different from previous versions. We will be using system locations for:

-   utilities (scripts & binaries)
-   libraries
-   log files
-   lock files
-   default schema
-   certificate databases?

Directory Server instances will each have their own directory on the filesystem that will contain instance specific files such as:

-   custom schema
-   configuration files
-   database files

These instance directories can exist wherever the user wants them to on the filesystem.

Below is a proposal for how the Directory Server layout will look. A \* denotes a file or directory created by new instance creation - not part of the RPM.

     /usr/    
       lib[64]/ - lib on 32 bit systems, lib64 on 64 bit systems    
         dirsrv/    
           - shared libs only used by ns-slapd and command line tools, such as libslapd, libds-nshttpd, libds_admin    
           *slapd-INSTANCE/    
             - instance specific command line and CGI programs used for server management (db2ldif, ldif2db, etc.)    
           plugins/    
             - plugin shared libs (e.g. libreplication-plugin.so)    
       sbin/    
         ns-slapd    
         setup-ds-admin.pl - replaces the old setup command    
         migrate-ds-admin.pl - used for upgrade/migration    
         setup-ds.pl - replaces ds_newinst.pl    
         migrate-ds.pl - does not upgrade/migrate admin server or console information    
       bin/    
         - command line utilities which are not instance specific - dsktune, logconv.pl, etc.    
         - load generating tools - dbgen, infadd, rsearch, ldclt    
       share/    
         dirsrv/    
           ldif/ - sample LDIF files    
           script-templates/ - templates for scripts used during instance creation    
           properties/ - property/resource files    
           inf/ - server brand/version information files    
     /var/    
       log/    
         dirsrv/    
           *slapd-INSTANCE/ - access logs - error logs    
       lock/    
         dirsrv/    
           *slapd-INSTANCE/ - lock files    
       run/    
         dirsrv/    
           slapd-INSTANCE.pid - pid file - used by the init script as well as start-slapd and stop-slapd    
           slapd-INSTANCE.startpid - startpid file    
           slapd-INSTANCE.stats - SNMP statistics for the agent    
           slapd-INSTANCE.socket - LDAPI socket    
       lib/    
         dirsrv/    
           *slapd-INSTANCE/    
             db/ - database files    
             bak/ - database backups    
             ldif/ - default location for LDIF database dumps    
     /etc/    
       init.d/ - rc init scripts    
         dirsrv - operates on all instances by default, or can specify instance to use    
         dirsrv-admin - admin server init script    
       sysconfig/ or default/ - most linux distros use sysconfig, other OSes use default    
         dirsrv - used to set environment (keytab, ulimit, etc.) for directory server    
         dirsrv-admin - used to set environment (keytab, ulimit, etc.) for admin server    
       dirsrv/ - default config files    
         schema/ - default schema files    
         *slapd-INSTANCE/ - instance specific dynamic config, security (cert8.db) files    
           schema/ - instance specific dynamic schema    
         admin-serv/ - admin server config directory, security (cert8.db) files    

For the 389-ds-base-devel package:

     /usr/include/dirsrv/slapi-plugin.h - the plug-in API interface file    
     /usr/lib[64]/dirsrv/libslapd.so - the plug-in API library    

Possible enhancements:

-   We could move the instance specific scripts from \_libdir/dirsrv/slapd-INSTANCE to \_bindir. When used, they would by default operate on the first installed instance only (since in the vast majority of cases there will be only 1 instance per machine). If another slapd-INSTANCE is created on the system, it will not replace or add scripts/programs in \_bindir. The user will be able to specify an instance to operate on, or set the default instance to operate on, in cases where there are more than one instance. Maybe using the alternatives system.
-   Another option is to create new links with an instance specific suffix e.g. db2ldif-slapd-INSTANCE
-   Another option is to allow the tools to have the instance name as parameter, and automatically use the first installed instance if not argument was given

* * * * *

Work in progress

Sub packages:

dirsrv-admin
------------

-   admin-serv/logs/ -\> /var/log/dirsrv/admin-serv - Apache logs for 389 admin server
-   admin-serv/config/ -\> /etc/dirsrv/admin-serv
-   java/jars/\* -\> /usr/share/dirsrv/html/java/
-   java/html/ -\> /usr/share/dirsrv/html/
-   %doc manual/en/admin

389-console
-----------

-   /usr/share/java

Old paths vs. New
=================

The old paths are listed as relative to the server root directory (e.g. /opt/fedora-ds). Fedora RPM build macros are listed [here](http://fedoraproject.org/wiki/Extras/RPMMacros) - they will be referred to below instead of the hard code path

|Old Path|New Path|New Package|Description|
|--------|--------|-----------|-----------|
|dist|%{\_datadir}/dirsrv/html|389-admin|admin server|
|plugins|N/A|389-ds-base-devel|N/A|
|lib|%{\_libdir}/dirsrv/plugins|389-ds-base|Server plug-ins|
|lib/perl|%{\_perlsitelib}|perl-Mozilla-LDAP|installed into system perl as a site package (now in Fedora)|
|shared/lib|%{\_libdir}|Various|NSPR, NSS, LDAPSDK, etc. will be in separate packages (or part of Fedora)|
|shared/bin|%{\_bindir}|Various|NSPR, NSS, LDAPSDK, etc. will be in separate packages - %{\_libdir}/mozldap for ldapsearch, etc.|
|shared/config|%{\_sysconfdir}/dirsrv/admin-serv|389-admin|All of the disparate config files have been combined into adm.conf|
|shared/config/template|%{\_datadir}/dirsrv/template|389-admin|config file templates used to produce real config files at setup time|
|manual/help|%{\_datadir}/dirsrv/manual, %{\_libdir}/fedora-ds-admin|389-admin|The help CGI binary will go in \_libdir|
|manual/en/admin|%{\_datadir}/dirsrv/manual/admin/en|389-admin-console|on-line help (not man pages)|
|manual/en/console|%{\_datadir}/dirsrv/manual/console/en|idm-console-framework|on-line help (not man pages)|
|manual/en/slapd|%{\_datadir}/dirsrv/manual/console/en|389-ds-console|on-line help (not man pages)|
|java|%{\_datadir}/java|console packages|note ldapjdk.jar, jss.jar are in their respective packages - see jpackage.org|
|java/jars/ds\*, java/jars/fedora-ds\*|%{\_datadir}/dirsrv/java|389-ds-console|console jar files for managing fedora-ds-base|
|java/jars/admserv\*, java/jars/fedora-admserv\*|%{\_datadir}/dirsrv/java|389-admin-console|console jar files for managing 389 admin server 389-admin|
|setup|%{\_sbindir}/setup-ds-admin.pl|389-admin|The setup program/script (note - ds\_newinst.pl has been replaced with setup-ds.pl)|
|admin-serv|Various|389-admin|**see admin server package description**|
|clients/dsgw|Various|dsgw|**see dsgw package description**|
|clients/orgchart|Various|orgchart|**see orgchart package description**|
|clients/dsmlgw|%{\_datadir}/java/dsmlgw|dsmlgw|Will be simply a standard WAR file|
|clients/lib|%{\_libdir}|Various|NSPR, NSS, LDAPSDK, ICU, AdminUtil will be in separate packages|
|alias|%{\_sysconfdir}/dirsrv/{slapd-instance,admin-serv}|389-ds-base, 389-admin|crypto data is instance specific - see also admin server package description|
|bin/admin|see admin server|389-admin|**see admin server package description**|
|bin/slapd/lib|%{\_libdir}/dirsrv, others|389-ds-base, others|Only libns-dshttpd is in 389-ds-base, the rest are in their own packages|
|bin/slapd/server|%{\_sbindir} - ns-slapd; %{\_bindir} - other command line tools; %{\_libdir}/dirsrv - libslapd.so|389-ds-base||
|bin/slapd/authck|dsgw|dsgw|dsgw cookie dir - see dsgw description|
|bin/slapd/property|%{\_datadir}/dirsrv/properties|389-ds-base|localized messages from ns-slapd (libns-dshttpd)|
|bin/slapd/install/schema|%{\_sysconfdir}/dirsrv/schema|389-ds-base|default schema, config files; sample ldif files; legacy config for migration assistance|
|bin/slapd/install/ldif|%{\_datadir}/dirsrv/ldif|389-ds-base|sample ldif files|
|bin/slapd/install/config|%{\_sysconfdir}/dirsrv/config|389-ds-base|default config files|
|bin/slapd/admin/scripts|%{\_datadir}/dirsrv/script-templates|389-ds-base|templates for instance specific scripts|
|bin/slapd/admin/dsml|moved to dsmlgw package|dsmlgw|**see dsmlgw description**|
|bin/slapd/admin/version\*|N/A|N/A|legacy schema used for migration - not present in 389|
|bin/slapd/admin/bin|%{\_bindir}|389-ds-base, 389-admin|programs and scripts for command line and CGI/console server management|
|slapd-instance|%{\_sysconfdir}/dirsrv/slapd-instance|389-ds-base|**see slapd instance table**|

slapd instance specific paths
-----------------------------

These paths are instance specific, usually found under /opt/fedora-ds/slapd-INSTANCE, where INSTANCE is localhost or the machine hostname. Package is 389-ds-base unless noted in the Description.

|Old Path|New Path|Description|
|--------|--------|-----------|
|.|%{\_libdir}/dirsrv/slapd-INSTANCE|Instance specific scripts|
|bak|%{\_localstatedir}/lib/dirsrv/slapd-INSTANCE/bak|database backups|
|db|%{\_localstatedir}/lib/dirsrv/slapd-INSTANCE/db|database files|
|ldif|%{\_localstatedir}/lib/dirsrv/slapd-INSTANCE/ldif|default location for database LDIF exports|
|locks|%{\_localstatedir}/lock/dirsrv/slapd-INSTANCE|server/db lock files|
|logs|%{\_localstatedir}/log/dirsrv/slapd-INSTANCE|access, errors, and rotated log files|
|logs/pid|%{\_localstatedir}/run/dirsrv/slapd-INSTANCE.pid, %{\_localstatedir}/run/dirsrv/slapd-INSTANCE.startpid|The pid files|
|config|%{\_sysconfdir}/dirsrv/slapd-INSTANCE|instance specific dynamic config (dse.ldif)|
|config/schema|%{\_sysconfdir}/dirsrv/slapd-INSTANCE/schema|instance specific dynamic schema|
|ldif|%{\_datadir}/dirsrv/data|sample ldif files - not instance specific anymore|
|dsml|**see dsmlgw package**|moved to dsmlgw package|

Admin Server
------------

Note that mod\_nss is a separate package, so we need to figure out where the Apache module and the nss\_pcache program are.

|Old Path|New Path|Description|
|--------|--------|-----------|
|bin/admin|%{\_bindir}|command line utilities for managing admin server|
|bin/admin/property|%{\_datadir}/dirsrv/properties|localized properties for admin server|
|bin/admin/lib|%{\_libdir}/dirsrv/modules, others|libmodadmserv.so, libmodrestartd.so - the others are in their own separate packages (NSPR, NSS, etc.)|
|bin/admin/admin/icons|%{\_datadir}/dirsrv/icons|icons/images for html pages|
|bin/admin/admin/html|%{\_datadir}/dirsrv/html|html pages for admin server web app|
|bin/admin/admin/bin|%{\_bindir}|command line and CGI programs and scripts|
|bin/admin/admin/bin/property|%{\_datadir}/dirsrv/properties|localized properties for admin server|
|admin-serv/config|%{\_sysconfdir}/dirsrv/admin-serv|config files|
|admin-serv/logs|%{\_localstatedir}/log/dirsrv/admin-serv|log files|
|admin-serv/ldif|%{\_datadir}/dirsrv/data|ldif templates for admin server configuration|


