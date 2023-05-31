---
title: "Howto: BuildonEtch"
---

# Building FDS on Debian Etch
-----------------------------

This document describes howto build FDS 1.1.0 on Debian Etch using the dsbuild script.

{% include toc.md %}

Getting dsbuild
---------------

    cvs -d :pserver:anonymous@cvs.fedoraproject.org:/cvs/dirsec co dsbuild

or if you don't want the CVS directories

    cvs -d :pserver:anonymous@cvs.fedoraproject.org:/cvs/dirsec export -rHEAD dsbuild

if you need to cvs through a proxy this might help

    :pserver;proxy=proxy.server.com;proxyport=8080:username:password@cvs.server

Check out the dsbuild scripts to /usr/src/dsbuild

FDS Components
--------------

During the build, we will be using as many of the Debian supplied packages as possible to build against.

Debian supplied packages that we will be using are NSS, NSPR, libicu, net-snmp, Berkley db and SASL.

We will be building mozldap, perldap, svrcore, and all ldapserver and adminserver components.

We WILL NOT be building any java components \*currently\*.

Debianisms
----------

We will need to make a few changes to our Debian install in order for dsbuild to find the proper libraries on our system.

1. We will need to make sure we have all the appropriate packages installed.

        apt-get install build-essential bzip2 pkg-config
        apt-get install libdb4.4++ libdb4.4++-dev
        apt-get install libicu36 libicu36-dev
        apt-get install libsnmp-base libsnmp9 libsnmp9-dev lm-sensors
        apt-get install libpam0g-dev
        apt-get install libapr1-dev
        apt-get install apache2-dev apache2-threaded-dev apache2-mpm-worker libaprutil1-dev libldap2-dev
        apt-get install libnss3-0d libnss3-tools libnss3-dev
        apt-get install libnspr4-dev  libnspr4-0d
        apt-get install libsasl2-dev

2. Symlink pkg-config files. Debian provides nss and nspr from the xulrunner package, and it's pkg-config files are named for xulrunner. We need to fix this.

        ln -s /usr/lib/pkgconfig/xulrunner-nss.pc /usr/lib/pkgconfig/nss.pc
        ln -s /usr/lib/pkgconfig/xulrunner-nspr.pc /usr/lib/pkgconfig/nspr.pc

3. Modify dsbuild files. We need to make a few changes to the dsbuild defaults.

edit /usr/src/dsbuild/ds/ldapserver/Makefile and add the following around line 21

    CONFIGURE_ENV += CPPFLAGS=-DNETSNMP_USE_INLINE=1

so the file looks like (without newlines)

    ...
    LIBDEPS =
    DESCRIPTION = Fedora Directory Server (base)
    CONFIGURE_ARGS = $(DS_CONFIGURE_ARGS) --enable-bundle
    CONFIGURE_ENV += CPPFLAGS=-DNETSNMP_USE_INLINE=1
    CONFIGURE_SCRIPTS = $(WORKSRC)/configure
    BUILD_SCRIPTS = $(WORKSRC)/Makefile
    INSTALL_SCRIPTS = $(WORKSRC)/Makefile
    ...

edit /usr/src/dsbuild/ds/adminserver/Makefile and add the following around line 14

    APXS=/usr/bin/apxs2
    HTTPD=/usr/sbin/apache2

so the file looks like (without newlines)

    ...    
    ifdef USE_CVS    
    CVSMODULES=adminserver    
    else    
    DISTFILES = $(GARNAME)-$(GARVERSION).tar.bz2    
    endif    
    APXS=/usr/bin/apxs2    
    HTTPD=/usr/sbin/apache2    
    LIBDEPS =    
    DESCRIPTION = Fedora DS Admin Server    
    ...    

edit /usr/src/dsbuild/ds/mod\_nss/Makefile and add the following around line 14

    APXS=/usr/bin/apxs2    
    HTTPD=/usr/sbin/apache2    

so the file looks like (without newlines)

    ...    
    ifdef USE_CVS    
    CVSMODULES=mod_nss    
    else    
    DISTFILES = $(GARNAME)-$(GARVERSION).tar.gz    
    endif    
    APXS=/usr/bin/apxs2    
    HTTPD=/usr/sbin/apache2    
    LIBDEPS =    
    DESCRIPTION = mod_nss    
    ...    

The Make process
----------------

start the build process and sit back

    make BUILD_DS_ADMIN=1 ADMINUTIL_SOURCE=1 MOD_NSS_SOURCE=1 ADMINSERVER_SOURCE=1 SVRCORE_SOURCE=1 MOZLDAP_SOURCE=1 PERLDAP_SOURCE=1 NOJAVA=1    

It will crank away for a while. It will stop once for the compilation of perldap where it asks you for locations, Hit enter and use the defaults

    make[1]: Entering directory /usr/src/dsbuild/ds/perldap
    [===== NOW BUILDING:     perl-mozldap-1.5.2     =====]    
    [fetch] complete for perl-mozldap.     
    install -d cookies    
    ==> Running checksum on perl-mozldap-1.5.2.tar.gz    
    1f7af40a8ca42f4a8b805942129915e0  download/perl-mozldap-1.5.2.tar.gz    
    file perl-mozldap-1.5.2.tar.gz passes checksum test!    
    [checksum] complete for perl-mozldap.    
    install -d work    
    ==> Extracting download/perl-mozldap-1.5.2.tar.gz    
    [extract] complete for perl-mozldap.    
    [patch] complete for perl-mozldap.    
    ==> Running configure in    
    cd work/perl-mozldap-1.5.2 && NSPRINCDIR= NSPRLIBDIR= NSSLIBDIR= LDAPSDKDIR=/opt/dirsrv LDAPSDKSSL=yes perl Makefile.PL    

    PerLDAP - Perl 5 Module for LDAP    
    ================================    
    Directory containing 'include' and 'lib' directory of the Mozilla    
    LDAP Software Developer Kit (default: /opt/mozldap): /opt/dirsrv    
    Include SSL Support (default: yes)?  yes    
    Directory containing NSPR API 'include' and 'lib'     
    directories for NSPR support (type 'n' or 'none' to omit) (default: ): <-- HIT ENTER    
    Directory containing NSS API 'lib'    
    directories for NSS support (type 'n' or 'none' to omit) (default: ): <-- HIT ENTER    
    Libraries to link with (default:  -lssldap60 -lprldap60 -lldap60 -lssl3):  <-- HIT ENTER    
    ######### before WriteMakefile #############    
    Checking if your kit is complete...    
    Looks good    
    Writing Makefile for Mozilla::    [    LDAP::API    ](LDAP::API)
    ######### after WriteMakefile #############    

It will also fail when installing files to /opt/dirsrv, there's a bug somewhere where one of the binaries is copied to /opt/dirsrv/bin where bin is a file and not a directory. So any additional files that try to get copied into /opt/dirsrv/bin fail. When the make process does fail, just mv /opt/dirsrv/bin /opt/dirsrv/ldappasswd. then rerun the make command to continue on. When done, move /opt/dirsrv/ldappasswd into /opt/dirsrv/bin/

After Make
----------

Almost there. We need to modify a couple more items in order for the admin server to work.

First off, sym-link the libssl3.so library.

    ln -s /usr/lib/libssl3.so.0d /opt/dirsrv/lib/libssl3.so

Then change the admin server's httpd.conf file as Debian builds one of the modules into apache, so it will fail when fds tries to load it. So edit /opt/dirsrv/etc/dirsrv/admin-serv/httpd.conf and comment out line 123

    ...    
    LoadModule authn_file_module /usr/lib/apache2/modules/mod_authn_file.so    
    #LoadModule log_config_module /usr/lib/apache2/modules/mod_log_config.so    
    LoadModule env_module /usr/lib/apache2/modules/mod_env.so    
    ...    

### Creating Debian packages

The above process should work and will install EVERYTHING to /opt/dirsrv. Including etc/dirsrv and usr/dirsrv etc. So we will be changing it to have a more standards compliant file layout.

In the end we will end up with

    /etc/dirsrv    
    /usr/share/dirsrv    
    /var/lib/dirsrv    
    /var/run/dirsrv    
    /var/lock/dirsrv    
    /opt/dirsrv    

But the var directories won't get created until you run the setup-ds-admin.pl or setup-ds.pl, keep that in mind.

The destination for our build will be /usr/src/release, so make sure that directory exists. There currently is a bug in the make install script for mozldap, and I haven't looked for it yet, so run a

    mkdir -p /usr/src/release/ldapserver/opt/dirsrv/bin     

or else the make will fail.

Edit Makefiles
--------------

When building with dsbuild and using the DESTDIR option, we need to help a couple of the Makefiles recognize where the libs and includes are during build time. So we will be editing a few of them.

First up is dsbuild/ds/ldapserver/Makefile and change the CONFIGURE\_ARGS variable to look like

    CONFIGURE_ARGS = $(DS_CONFIGURE_ARGS) --enable-bundle --localstatedir=/var --sysconfdir=/etc  --datadir=/usr/share    

Then edit dsbuild/ds/adminserver/Makefile and change the CONFIGURE\_ARGS variable to look like

    CONFIGURE_ARGS = $(DS_CONFIGURE_ARGS) --enable-bundle --sysconfdir=/etc --localstatedir=/var --with-ldapsdk=/usr/src/release/ldapserver/opt/dirsrv --datadir=/usr/share    

Then edit dsbuild/ds/adminutil/Makefile and change the CONFIGURE\_ARGS variable to look like

    CONFIGURE_ARGS = $(DS_CONFIGURE_ARGS) --with-ldapsdk=/usr/src/release/ldapserver/opt/dirsrv    

Building ldapserver and adminserver
-----------------------------------

If you ran the dsbuild make script before, we need to remove all the old built files. A quick and easy way to go about that is this

    for i in `ls /usr/src/dsbuild/ds`
    do    
        rm -rf /usr/src/dsbuild/ds/$i/work    
        rm -rf /usr/src/dsbuild/ds/$i/cookies    
    done    

Now on to the building. This time, instead of building everything at once, we will build the ldapserver first, then the admin server, then the console.

    make SVRCORE_SOURCE=1 MOZLDAP_SOURCE=1 PERLDAP_SOURCE=1 NOJAVA=1 PREFIX=/opt/dirsrv DESTDIR=/usr/src/release/ldapserver    

Then run

    make BUILD_DS_ADMIN=1 ADMINUTIL_SOURCE=1 MOD_NSS_SOURCE=1 ADMINSERVER_SOURCE=1 NOJAVA=1 PREFIX=/opt/dirsrv DESTDIR=/usr/src/release/adminserver    

You should now have /usr/src/release/adminserver and ldapserver. With all the files installed to those locations.

Building the console
--------------------

I had some problems building the console components, luckily enough, the components I needed where available as binaries that work on debian, or are cross platform jars.

So we are going to use jss binaries, prebuilt ldapjdk.jar and the fedora-admin-1.1.0.jar and fedora-ds-1.1.0.jar that I ripped out of a fc8 rpm.

Files you need to get save them the /usr/src/ for now

[jss4.jar](http://ftp.mozilla.org/pub/mozilla.org/security/jss/releases/JSS_4_2_5_RTM/jss4.jar)

[libjss4.so](http://ftp.mozilla.org/pub/mozilla.org/security/jss/releases/JSS_4_2_5_RTM/Linux2.6_x86_glibc_PTH_OPT.OBJ/lib/libjss4.so)

Aswell as the jars from the fedora-admin-console fedora-ds-console rpms. You have a choice here, you can package the jars as their own package, or stick them in the adminserver package. I chose the latter for now.

The rpms are here

[fedora-admin-console-1.1.0-4.fc6.noarch.rpm](http://directory.fedoraproject.org/yum/dirsrv/fedora/8/noarch/RPMS/fedora-admin-console-1.1.0-4.fc6.noarch.rpm)

[fedora-ds-console-1.1.0-5.fc6.noarch.rpm](http://directory.fedoraproject.org/yum/dirsrv/fedora/8/noarch/RPMS/fedora-ds-console-1.1.0-5.fc6.noarch.rpm)

Then use whatever tool you want to pull the jars out. alien -t pkgname will turn it into a tarball and you can get them out that way if you need.

So extract the rpm's jar files to /usr/src/release/adminserver/usr/share/dirsrv/html/java. Make sure the sym links either get preserved or are copied over as files. You want the files to look like

    fdsbuild:/usr/src/release/adminservr/usr/share/dirsrv/html/java# ll    
    total 1660    
    -rw-r--r-- 1 root root  174456 Dec 20 11:42 fedora-admin-1.1.0.jar    
    -rw-r--r-- 1 root root   37521 Dec 20 11:42 fedora-admin-1.1.0_en.jar    
    lrwxrwxrwx 1 root root      22 Feb 28 15:38 fedora-admin-1.1.jar -> fedora-admin-1.1.0.jar    
    lrwxrwxrwx 1 root root      25 Feb 28 15:38 fedora-admin-1.1_en.jar -> fedora-admin-1.1.0_en.jar    
    lrwxrwxrwx 1 root root      22 Feb 28 15:38 fedora-admin.jar -> fedora-admin-1.1.0.jar    
    lrwxrwxrwx 1 root root      25 Feb 28 15:38 fedora-admin_en.jar -> fedora-admin-1.1.0_en.jar    
    -rw-r--r-- 1 root root 1409434 Nov  7 21:59 fedora-ds-1.1.0.jar    
    -rw-r--r-- 1 root root   54302 Nov  7 21:59 fedora-ds-1.1.0_en.jar    
    lrwxrwxrwx 1 root root      19 Feb 28 15:38 fedora-ds-1.1.jar -> fedora-ds-1.1.0.jar    
    lrwxrwxrwx 1 root root      22 Feb 28 15:38 fedora-ds-1.1_en.jar -> fedora-ds-1.1.0_en.jar    
    lrwxrwxrwx 1 root root      19 Feb 28 15:38 fedora-ds.jar -> fedora-ds-1.1.0.jar    
    lrwxrwxrwx 1 root root      22 Feb 28 15:38 fedora-ds_en.jar -> fedora-ds-1.1.0_en.jar    

NOTE:: Because we are using prebiult jars, we will be skipping the last 2 steps on [BuildingConsole](BuildingConsole "wikilink")

Next, grab the tarballs of idm-common-framework and the fedora-idm-console.

[idm-common-framework-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/idm-common-framework-1.1.1.tar.bz2)

[fedora-idm-console-1.1.1.tar.bz2]({{ site.binaries_url }}/binaries/fedora-idm-console-1.1.1.tar.bz2)

and untar them to /usr/src/

I created a simple bash script for building/copying/sym-linking the console files. So you can see how the build goes be checking out the script.

    #!/bin/bash    
    # build java components and copy them to the staging directory to create a package    
    # only building idm-console-framework and fedora-idm-console    
    # assume jss4.jar, ldapjdk.jar are in /usr/src/ when building.  They'll end up in /usr/share/java    
    # remove previous built directory and package directory    
    rm -rf /usr/src/built    
    rm -rf /usr/src/release/console    
    # build framework    
    cd /usr/src/idm-console-framework-1.1.1    
    ant -Dldapjdk.local.location=/usr/src/ -Djss.local.location=/usr/src    
    # symlink jars so the next build doesn't break    
    cd /usr/src/built/release/jars    
    ln -s idm-console-base-1.1.1.jar idm-console-base.jar    
    ln -s idm-console-mcc-1.1.1.jar idm-console-mcc.jar    
    ln -s idm-console-nmclf-1.1.1.jar idm-console-nmclf.jar    
    ln -s idm-console-mcc-1.1.1_en.jar idm-console-mcc_en.jar    
    ln -s idm-console-nmclf-1.1.1_en.jar idm-console-nmclf_en.jar    
    # build console    
    cd /usr/src/fedora-idm-console-1.1.1    
    ant -Djss.local.location=/usr/share/java -Dconsole.local.location=/usr/src/built/release/jars    
    # finished building,  now create the directory structure    
    mkdir -p /usr/src/release/console/usr/share/java    
    mkdir -p /usr/src/release/console/usr/bin    
    cp -l /usr/src/built/release/jars/* /usr/src/release/console/usr/share/java/    
    cp /usr/src/built/fedora-idm-console /usr/src/release/console/usr/bin    
    chmod 755 /usr/src/release/console/usr/bin/fedora-idm-console    
    cp /usr/src/built/fedora-idm-console-1.1.1_en.jar /usr/src/release/console/usr/share/java/    
    # copy over prebuilt jss/ldapjdk    
    cp /usr/src/jss4.jar /usr/src/release/console/usr/share/java/    
    cp /usr/src/ldapjdk.jar /usr/src/release/console/usr/share/java/    
    # create Debian control    
    mkdir -p /usr/src/release/console/DEBIAN    
    cat <    <EOL >     /usr/src/release/console/DEBIAN/control    
    Package: fedora-ds-console    
    Version: 1.1    
    Section: net    
    Priority: optional    
    Architecture: all    
    Essential: no    
    Depends: java-virtual-machine, xbase-clients    
    Installed-Size: 1000    
    Maintainer:  John Smith    
    Description: Fedora Directory server console    
    EOL    

Debianisms pt2
--------------

Now that you've built all 3 major components, we need to tweak a few files for debian specific settings.

in both ldapserver and adminserver you need to fix the init.d structure, so

    mkdir /usr/src/release/ldapserver/etc/init.d    
    mv /usr/src/release/ldapserver/etc/rc.d/dirsrv /usr/src/release/ldapserver/etc/init.d    
    rm -rf /usr/src/release/ldapserver/etc/rc.d    
    mkdir /usr/src/release/adminserver/etc/init.d    
    mv /usr/src/release/adminserver/etc/rc.d/dirsrv /usr/src/release/adminserver/etc/init.d    
    rm -rf /usr/src/release/adminserver/etc/rc.d    

Next, edit /usr/src/release/adminserver/etc/dirsrv/admin-serv/httpd.conf and comment out line 123.

    #LoadModule log_config_module /usr/lib/apache2/modules/mod_log_config.so    

Next, edit /usr/src/release/adminserver/opt/dirsrv/sbin/start-ds-admin change the nss\_libdir variable to /usr/lib and also change libssl3.so to libssl3.so.0d

       if [ $hasol -eq 1 ] ; then    
    #      nss_libdir="/opt/dirsrv/lib"    
           nss_libdir="/usr/lib"    
           if [ -n "$nss_libdir" ] ; then    
               LD_PRELOAD="$nss_libdir/libssl3.so.0d /opt/dirsrv/lib/libldap60.so"    
           else    
               LD_PRELOAD="/opt/dirsrv/lib/libldap60.so"    
           fi    
           export LD_PRELOAD    
       fi    
    fi    

We also need to include libjss4.so that we previously downloaded. I'm not sure if it's a console only dep or the admin server needs it. So I just included it with the adminserver package rather then the console

    mkdir -p /usr/src/release/adminserver/lib    
    cp /usr/src/libjss4.so /usr/src/release/adminserver/lib    

-   -   DOUBLE CHECK THIS \*\*

Packaging
---------

You can now tar up the console adminserver and ldapserver directories in /usr/src/release and distribute them that way, or you can build your own debs. One quick and short way to make some functional debs is this.

    mkdir /usr/src/release/ldapserver/DEBIAN    
    mkdir /usr/src/release/adminserver/DEBIAN    

Next the bare minimum you need to package is a control file in DEBIAN/

so for example here is one I made for ldapserver

    Package: fedora-ds-ldapserver    
    Version: 1.1    
    Section: net    
    Priority: optional    
    Architecture: all    
    Essential: no    
    Depends: libdb4.4++, libicu36, libsnmp9, lm-sensors, apache2-mpm-worker, libnss3-tools, libnss3-0d, libnspr4-0d, libssl0.9.8    
    Installed-Size: 2500    
    Maintainer:  John Smith    
    Conflicts: slapd    
    Description: Fedora Directory Server - ldapserver    

And for admin server

    Package: fedora-ds-adminserver    
    Version: 1.1    
    Section: net    
    Priority: optional    
    Architecture: all    
    Essential: no    
    Depends: libdb4.4++, libicu36, libsnmp9, lm-sensors, apache2-mpm-worker, libnss3-tools, libnss3-0d, libnspr4-0d, libssl0.9.8    
    Installed-Size: 2500    
    Maintainer:  John Smith    
    Description: Fedora Directory Server Administration Server    

There's likely some work to be done tuning proper depends packages and adding postinst preinst etc debian control files. But for now this should work.

Finally, package up all the work.

    dpkg-deb --build /usr/src/release/ldapserver /usr/src/release/fedora-ds-ldapserver.deb    
    dpkg-deb --build /usr/src/release/adminserver /usr/src/release/fedora-ds-adminserver.deb    
    dpkg-deb --build /usr/src/release/console /usr/src/release/fedora-ds-console.deb    
