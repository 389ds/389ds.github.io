---
title: "Building"
---

# Building The Server
---------------------

{% include toc.md %}

Compilers
---------

-   Linux - gcc
-   Solaris - Sun Workshop compiler 6.x or higher (aka Forte C compiler - the free one works just fine)
-   Windows - Visual C++ 6.0 (later versions should also work)
-   HP/UX - ANSI-C compliant compiler (cc, usually found in /opt/ansic), and aC++ (aCC, usually found in /opt/aCC)

gcc may work on platforms other than Linux but it has not been tested.

Tools you need
--------------

### Most components and the core DS

-   Perl 5.8 or later
-   git (for checking code out of git - not required for building from srpm or tarball)
-   GNU make 3.79.1 or later ("gmake", or just "make" on Linux systems)

### Console and other Java components

-   java 1.4.2 or later - Must be OpenJDK (IcedTea), or the Sun or IBM JDK - see [Install Guide](../legacy/install-guide.html) for more details - GCJ 4.1 or later may be used to build, but it will not run the console
-   ant 1.6.1 or later

### Admin Server

-   Apache 2 developer files
    -   Linux - the httpd-devel and/or apr-devel packages - you need the apr-config and apxs binaries in your PATH at build time
    -   Solaris - this may be /usr/local/apache2
    -   HP/ux - There is a free depot web services download which includes Apache2 and Tomcat

In general, you'll need to have the compilers and tools listed above in your PATH for your operating system. The following are some OS specific settings required to be made to PATH.

### Fedora/RHEL

No special tools are required. Most everything is included with the OS. Just make sure you have installed the programming and/or the development packages that contain git, gcc, make, etc.

Among the required packages are:

-   gcc
-   gcc-c++
-   libdb-devel if available, or db4-devel
-   krb5-devel
-   icu and libicu-devel
-   net-snmp-devel
    -   The following are needed to build the snmp ldap-agent:
    -   lm\_sensors-devel
    -   bzip2-devel
    -   zlib-devel
    -   openssl-devel
    -   tcp\_wrappers
    -   libselinux-devel
-   cyrus-sasl
    -   cyrus-sasl-devel
    -   cyrus-sasl-gssapi is required in order to use GSSAPI/Kerberos
    -   cyrus-sasl-md5 is required in order to use Digest-MD5
-   pam-devel
-   pcre-devel
-   openldap-devel if version 2.4.23 or later is available, otherwise, mozldap-devel
-   svrcore-devel
-   nss-devel
-   nspr-devel

For the console

-   java (java-1.7.0-icedtea, or ibm or sun jdk 1.4.2 or later)
-   ant (1.6.1 or later)

For the admin server

-   httpd-devel
-   apr-devel

NOTE: Fedora uses OpenJDK (IcedTea) Java (java-1.7.0-openjdk) by default. This version can build and run the console. The java that comes by default on many other older Linux distros is GNU gcj/classpath. The 389 java code cannot use this, so you will need to install the IBM or Sun JDK in order to build the java code. On RHEL, the IBM JDK is in RHEL Extras. For other distros, you will have to go to the IBM or Sun web site, download, and install it.

### Solaris

Make sure /usr/ccs/bin comes first in your PATH. This directory contains some tools used by the compilers and build process (e.g. ar). Also, the Workshop compilers are usually installed in /opt/SUNWspro. An example PATH:

    export PATH=/usr/ccs/bin:/opt/SUNWspro/bin:/usr/ucb:/paths/to/other/tools:/bin:/usr/bin

Make sure java, ant, apr-config, and apxs are also in your PATH.

### HP-UX

The ANSI-C compiler is usually found in /opt/ansic; the HP aC++ compiler in /opt/aCC. If you also have gcc installed you may need to export CC=cc so that the configure scripts will not try to use it.

    export PATH=/opt/ansic/bin:/opt/aCC/bin:/paths/to/other/tools:/bin:/and/other/system/paths

Make sure java, ant, apr-config, and apxs are also in your PATH.

### Windows

The build process doesn't currently support Cygwin - we welcome help with this porting effort. MKS is required for now. Be sure to put the paths to the other tools **before** MKS so that the MKS versions of those programs are not used. Make sure the MSVC cl.exe and link.exe tools are in your PATH.

External Requirements
---------------------

### Introduction

The following external components are required to build Directory Server. In most cases, the directory server will use system components installed in e.g. /usr/lib and /usr/include. The directory server configure script will first attempt to find these components using pkg-config (e.g. pkg-config --libs nspr) or the package specific config script (e.g. icu-config or net-snmp-config). If these are not available, configure will look for these components in their standard system locations in /usr/lib and /usr/include. The directory server build now uses autotools, so you can override any and all of these paths on the configure command line. You can also build any component in a private directory and use a configure argument to tell configure to use that private component (e.g. configure --with-nspr=/usr/local). Use configure --help to list all of the available settings.

### Devel packages

Your operating system may provide all of the required packages. On RHEL/Fedora, these are the *pkgname*-**devel** packages. For example: nspr-devel, nss-devel, etc. On Debian/Ubuntu, these are usually called *pkgname*-**dev** e.g. libnspr-dev. To install these on RHEL/Fedora:

    yum install nss-devel cyrus-sasl-devel db4-devel ....

### Building RPMs

These instructions are specific to RHEL/Fedora.

First, set up your environment to build rpms. Install the prerequisite RPM packages:

    yum install redhat-rpm-config rpm-build

You will need an rpm build directory hierarchy for your build files and packages, and tell rpmbuild to use it:

    $ mybuildroot=~/rpmbuild
    $ for dir in BUILD BUILDROOT RPMS SOURCES SPECS SRPMS ; do
        mkdir -p $mybuildroot/$dir
      done
    $ echo "%_topdir $mybuildroot" > ~/.rpmmacros

Find the RPM spec file that is closest to your platform:

[`http://pkgs.fedoraproject.org/cgit/389-ds-base.git/`](http://pkgs.fedoraproject.org/cgit/389-ds-base.git/)

For example, if you are running RHEL6, grab the 389-ds-base.spec file for el6. Also get the \*.sh and \*README files. Copy the 389-ds-base.spec file to \~/rpmbuild/SPECS and copy the other files to \~/rpmbuild/SOURCES

You will need a 389 source tarball - [Source](source.html). Copy the source tarball to \~/rpmbuild/SOURCES

Edit your 389-ds-base.spec file Version: to correspond to the version of the source tarball you want to use.

Install the build prerequisites. These are the packages listed in the BuildRequires in the spec file. You can do something like this:

    yum install `grep \^BuildRequires 389-ds-base.spec|awk '{print $2}'`

You should now be able to build RPMs using rpmbuild:

    rpmbuild -ba ~/rpmbuild/SPECS/389-ds-base.spec

The RPM packages should be in \~/rpmbuild/RPMS/*arch*

### Mozilla.org components

NOTE: It is recommended to use openldap instead of mozldap. These instructions assume you know that and want to use mozldap anyway.

On many platforms (RHEL, Fedora) these components may already be provided as part of the operating system. For example, on Fedora, the package names are nspr, nss, svrcore, mozldap, and perl-Mozilla-LDAP. The first 4 also have -devel packages, and nss and mozldap have a -tools package as well.

Use the following instructions only if you need to build them from source. Each component is available from the mozilla mercurial (hg) repository or from source tarball.

These first 5 can be checked out into the same build tree and built as follows:

-   Get the source code for NSPR (v4.6.7 or later), NSS (v3.11.7 or later), SVRCORE (v4.0.4 or later), LDAPSDK (v6.0.5 or later), and PerLDAP (1.5.2 or later)
-   Build NSPR
-   Build NSS
-   Build SVRCORE
-   Build LDAPSDK
-   Build PerLDAP

You must build the components in this order because each one depends on the previous ones in turn.

#### NSPR

Use the latest stable version from [<ftp://ftp.mozilla.org/pub/mozilla.org/nspr/releases>](ftp://ftp.mozilla.org/pub/mozilla.org/nspr/releases) or the mozilla mercurial (hg) repo.

#### NSS

Use the latest stable version from [<ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/>](ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/) or the mozilla mercurial (hg) repo.

NSS does not currently use autotools, so there is no configure - just use make (or gmake)

-   [General NSS build information](http://developer.mozilla.org/en/docs/NSS_reference:Building_and_installing_NSS)
-   [Build and install information](http://developer.mozilla.org/en/docs/NSS_reference:Building_and_installing_NSS:Installation_guide)
-   [Where the libs and headers go](http://developer.mozilla.org/en/docs/NSS_reference:Building_and_installing_NSS:Sample_manual_installation)
-   [List of make variables you can set on the command line](http://developer.mozilla.org/en/docs/NSS_reference:Building_and_installing_NSS:Build_instructions)

#### SVRCORE

Please see the svrcore [build instructions](development/building-svrcore.html)

#### Nunc-Stans

Please see the nunc-stans [buind instructions](development/building-svrcore.html)

#### LDAPSDK

NOTE: Only if not using OpenLDAP, if you need to use Mozilla LDAP C SDK for some reason.

Use the latest stable version from [<ftp://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/>](ftp://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/) or the mozilla mercurial (hg) repo.

Then see the table below for configure and gmake arguments for your platform. Use the --enable-optimize --disable-debug configure options and BUILD\_OPT=1 make flag to build an optimized build or leave them out for a debug build. You may also need to use --with-nspr=/path and --with-nss=/path to tell it where to find NSPR and NSS.

For 32 bit platforms:

    cd mozilla/directory/c-sdk
    ./configure --enable-clu --with-sasl --with-svrcore [--enable-optimize] [--disable-debug]
    make

For 64 bit platforms:

    cd mozilla/directory/c-sdk; 
    ./configure --enable-clu --with-sasl --with-svrcore --enable-64bit [--enable-optimize] [--disable-debug]
    make USE_64=1 [BUILD_OPT=1]

See also [<http://wiki.mozilla.org/LDAP_C_SDK>](http://wiki.mozilla.org/LDAP_C_SDK) for more information.

#### PerLDAP

NOTE: PerLDAP depends on an LDAP C SDK. If you are using OpenLDAP, tell PerLDAP to use OpenLDAP, otherwise, use Mozilla LDAP C SDK.

Use the latest stable version from [<ftp://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/>](ftp://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/) or the mozilla mercurial (hg) repo. Then to build:

    cd mozilla/directory/perldap
    perl Makefile.PL
    make

See also Makefile.PL for a list of environment variables that you can use to provide paths to NSPR, NSS, and LDAPSDK libraries and include files. The built files will be created in the usual MakeMaker blib directory. There is no need to do a make install unless you want to make PerLDAP part of the perl in your operating system. This won't work unless the shared libraries for the Mozilla components above are installed in a standard location (/usr/lib or using ldconfig) or you set LD\_LIBRARY\_PATH before using it (which comes with its own set of headaches). You can also use the LD\_RUN\_PATH option to make to make perldap use the libraries in another directory at runtime.

### Cyrus SASL

NOTE: 389 can use the bundled version of cyrus-sasl on most linux distributions, so it's quite likely that you do not need to build Cyrus-SASL from source.

You will want version **2.1.22 or later** of [Cyrus SASL](http://asg.web.cmu.edu/cyrus/).

Download the source from upstream at [1](ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-sasl-2.1.22.tar.gz)

    gunzip -c cyrus-sasl-2.1.22.tar.gz | tar xf -
    cd cyrus-sasl-2.1.22
    export CYRUS_SASL_BUILD_PATH=`pwd`

Pick the configure setup for your platform listed below. Note that you will build it but you will **not** need to do a `make install`

|Platform|Configure|Make|Notes|
|--------|---------|----|-----|
|FC and RHEL|`CFLAGS="-O2" ./configure [--enable-gssapi=/usr/kerberos/ <b><font color=red>(*)</font></b>] --enable-static --without-des --without-openssl --without-saslauthd --prefix=$CYRUS_SASL_BUILD_PATH/built`|`make all install`|Use `CFLAGS="-g"` for debug builds - will automatically build 64 bit libs on x86\_64|
|Solaris 9 32 bit|`CC="cc -O" ./configure --enable-gssapi --enable-static --without-des --without-openssl --without-saslauthd --prefix=$CYRUS_SASL_BUILD_PATH/built`|`make all install`|Use `"-g"` for debug builds|
|Solaris 9 64 bit|`CC="cc -O -xarch=v9" ./configure --enable-gssapi --enable-static --without-des --without-openssl --without-saslauthd --prefix=$CYRUS_SASL_BUILD_PATH/built`|`make all install`|Use `"-g"` for debug builds|
|HP/UX 32 bit|`CC="cc +DD32" CFLAGS="-O" ./configure --enable-gssapi --enable-static --without-des --without-openssl --without-saslauthd --prefix=$CYRUS_SASL_BUILD_PATH/built`|`make all install`|Use `-g` instead of `-O` in CFLAGS for debug builds|
|HP/UX 64 bit|`CC="cc +DD64" CFLAGS="-O" <b><font color=red>(**)</font></b> ./configure --enable-gssapi --enable-static --without-des --without-openssl --without-saslauthd --prefix=$CYRUS_SASL_BUILD_PATH/built`|`make all install`|Use `-g` instead of `-O` in CFLAGS for debug builds|

<b><font color=red>(\*)</font></b> Prerequisite: krb5-devel; The package could be installed in /usr/kerberos (e.g., on RHEL 3). If your system has krb5.h in /usr/kerberos/include, please specify "--enable-gssapi=/usr/kerberos/". Otherwise, "--enable-gssapi" is set by default.
<b><font color=red>(\*\*)</font></b> If you see an error message 'ld: Unsatisfied symbol "krb5\_..."', you may need to set LDFLAGS="-L/usr/lib/pa20\_64/gss" or LDFLAGS="-L/usr/lib/hpux64/gss" depending upon your hardware architecture.

### libicu

NOTE: 389 can use the bundled version of libicu on most linux distributions, so it's quite likely that you do not need to build it from source.

libicu is also known as ICU4C or simply ICU. You need version **3.4** or later from [ICU4C download](http://www.icu-project.org/download/) . Once you have the source, please refer to the file readme.html in the source distribution for detailed information about building. For example, here are the build instructions for 3.6 - [build instructions](http://source.icu-project.org/repos/icu/icu/tags/release-3-6/readme.html). The table below for configure and gmake arguments for your platform. Use --enable-debug for debug builds or omit it for optimized builds (the default). Note below that the --prefix requires a full path. Relative paths don't work. You may omit the --prefix argument if you want to build and install in the system locations. **Version 3.4** and later

|Platform|Configure|Make|Notes|
|--------|---------|----|-----|
|Fedora and RHEL 32 bit|`./runConfigureICU [--enable-debug] Linux --enable-64bit-libs=no --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`make all install`||
|Fedora and RHEL 64 bit|`./runConfigureICU [--enable-debug] Linux --enable-64bit-libs --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`make all install`||
|Solaris 9 32 bit|`CC=cc ./runConfigureICU [--enable-debug] Solaris --enable-64bit-libs=no --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`gmake all install`||
|Solaris 9 64 bit|`CC=cc ./runConfigureICU [--enable-debug] Solaris --enable-64bit-libs --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`gmake all install`||
|HP/UX 11i 32 bit|`./runConfigureICU [--enable-debug] HP-UX/ACC --enable-64bit-libs=no --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`gmake all install`||
|HP/UX 11i 64 bit|`./runConfigureICU [--enable-debug] HP-UX/ACC --enable-64bit-libs --enable-rpath --disable-ustdio --prefix=$ICU_BUILD_PATH/built`|`gmake all install`||

### Net-SNMP

NOTE: You can just use the net-snmp built in to most Linux distributions (except FC2/RHEL3 and earlier). So you probably do not need to build net-snmp from source on those platforms.

You want version **5.2.1 or later** of [Net-SNMP](http://www.net-snmp.org).

Get the tarball from the upstream [download page](http://www.net-snmp.org/download.html). Here is a [direct link](http://prdownloads.sourceforge.net/net-snmp/net-snmp-5.2.1.tar.gz?download) to the download that should work.

In the tar command below, use GNU tar (the `tar` included with Solaris will not untar Net-SNMP.)

    gunzip -c net-snmp-5.2.1.tar.gz | tar xf -
    cd net-snmp-5.2.1
    export NET_SNMP_BUILD_PATH=`pwd`

Then see the table below for configure and gmake arguments for your platform. The COMMON\_ARGS for the configure command are as follows:

    --with-default-snmp-version=3  --with-sys-contact="" \
    --with-sys-location="" --with-logfile="" \
    --with-persistent-directory=/var/net-snmp   \
    --prefix="$NET_SNMP_BUILD_PATH/built" \
    --disable-applications --disable-manuals \
    --disable-scripts --disable-mibs

|Platform|Configure|Make|Notes|
|--------|---------|----|-----|
|Fedora and RHEL|`CFLAGS="-O2" ./configure COMMON_ARGS`|`make; make install`|Use `CFLAGS="-g"` for debug builds - automatically builds 64 bit libs on x86\_64|
|Solaris 9 32 bit|`CC=cc CFLAGS="-O2" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `CFLAGS="-g"` for debug builds|
|Solaris 9 64 bit|`CC=cc CFLAGS="-O2 -xarch=v9" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `-g` instead of `-O2` in CFLAGS for debug builds|
|HP/UX 11i 32 bit|`CFLAGS="-O2 +DAportable" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `-g` instead of `-O2` in CFLAGS for debug builds|
|HP/UX 11i 64 bit|`CFLAGS="-O2 +DA2.0w +DChpux -D_LARGEFILE64_SOURCE" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `-g` instead of `-O2` in CFLAGS for debug builds|
|HP/UX IA64 32 bit|`CFLAGS="-O +DD32" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `-g` instead of `-O` in CFLAGS for debug builds|
|HP/UX IA64 64 bit|`CFLAGS="-O +DD64" ./configure COMMON_ARGS`|`gmake; gmake install`|Use `-g` instead of `-O` in CFLAGS for debug builds|

### Berkeley DB

NOTE: You can just use the Berkeley DB built in to most Linux distributions. So you probably do not need to build it from source on those platforms.

You need version **4.2.52 or later** of sleepycat's db library. Whatever version you use, **you must install the patches provided with the source**. The source is from the [download page](http://www.oracle.com/technology/software/products/berkeley-db/db/index.html).

untar and patch the source with the following commands (make sure you're using the GNU patch utility)

    gunzip -c db-4.2.52.NC.tar.gz | tar xf -
    cd db-4.2.52.NC
    patch -p0 < ../patch.4.2.52.1
    patch -p0 < ../patch.4.2.52.2
    patch -p0 < ../patch.4.2.52.3
    patch -p0 < ../patch.4.2.52.4
    patch -p0 < ../patch.4.2.52.5

There is an additional patch that's required on HP/UX and it's available [here](http://port389.org/patches/patch.4.2.52.hpux). If you're not using HP/UX, then you don't need this patch.

    patch -p0 < ../patch.4.2.52.hpux

After unpacking and patching the source make yourself a build directory:

    mkdir built ; cd built

See the table below for the configure arguments for your platform. For debug builds on all platforms, use the `--enable-debug --enable-umrw` arguments instead of the `--disable-debug` argument to the configure command.

|Platform|Configure|
|--------|---------|
|Fedora and RHEL|`../dist/configure --enable-dynamic --disable-debug`|
|Solaris 9 32 bit|`CC=cc ../dist/configure --enable-dynamic --disable-debug`|
|Solaris 9 64 bit|`CC=cc CFLAGS="-xarch=v9" LDFLAGS="-xarch=v9" ../dist/configure --enable-dynamic --disable-debug`|
|HP/UX 11i 32 bit|`CC="cc -O +DAportable" ../dist/configure --enable-dynamic --disable-debug`|
|HP/UX 11i 64 bit|`CC="cc -O +DA2.0w +DChpux -D_LARGEFILE64_SOURCE" ../dist/configure --enable-dynamic --disable-debug`|
|HP/UX IA64 32 bit|`CC="cc -O2 +DD32" ../dist/configure --enable-dynamic --disable-debug`|
|HP/UX IA64 64 bit|`CC="cc -O2 +DD64" ../dist/configure --enable-dynamic --disable-debug`|

Build libdb.a with the following command:

    make LIBDB_ARGS="libdb.a" all

The above command builds command line tools that dynamically link with the libdb shared library. While this may work, it is generally preferred to statically link the command line tools. To do so, first look at your configure line above. If it includes LDFLAGS, you'll need to include them in the build command below. If you didn't have to set LDFLAGS then you don't have to set them in LDFLAGS below, you only need to use the -static.

    rm db_archive db_checkpoint db_deadlock db_dump \
    db_load db_printlog db_recover db_stat \
    db_upgrade db_verify
    make LDFLAGS="-static $LDFLAGS" libdb.a all

### 389 Components

See [Source](source.html) for the list of source tarballs as well as SCM repo information (repo, tag, and module).

Pulling the Directory Server Source
-----------------------------------

See [Source](source.html)

Building the Source
-------------------

The simplest way is to just do

    configure [options]
    make

configure attempts to find all of the dependent components using pkg-config (e.g. pkg-config --libs nspr) or using the component specific script (e.g. net-snmp-config or icu-config). If that fails, configure will attempt to use the components from the standard system locations. You can override these with either the standard configure --dir options (e.g. --libdir=/path, --includedir=/path) or by overriding specific component paths (e.g. --with-nspr=/path/to/nspr --with-nss=/path/to/nss). Use configure --help to see all of the options.

There are 3 configure options that control where the files go during the install phase:

-   --with-fhs - this tells configure to use the standard FHS layout - see [FHS\_Packaging](fhs-packaging.html) for details
-   --with-fhs-opt - this tells configure to use the FHS /etc/opt, /var/opt, and /opt hierarchy
-   --prefix=/path (default) - this is the default - the default value of prefix is /opt/dirsrv
-   You can also specify each directory individually:

        --sbindir=/path/to/sbin --libdir=/path/to/libdir --sysconfigdir=/path/to/sysconfigdir ....

NOTE: On multi-arch systems (e.g. x86\_64), the arch dependent directories (e.g. libdir) will default to the 32-bit directories. This means if you run configure --with-fhs on a 64-bit system to get a 64-bit binary build, it will use libdir==/usr/lib. You must use configure --with-fhs --libdir=/usr/lib64 if you want it to use /usr/lib64 for the libdir.

The build honors the DESTDIR=/path option, so you can copy the files under /var/tmp/tmpbuild using the FHS hierarchy - this is essentially what rpmbuild does. Developers will probably want to use something like

    configure --with-fhs ...
    make DESTDIR=/var/tmp/tmpbuild install


To install the server under /home/user1/389ds for testing purposes.

    configure --prefix=/home/user1/389ds
    make install


### Notes

I find it useful to create a *BUILD* directory and run configure and make in that directory, rather than in the source directory, to keep the source directory clean (e.g. for making development tarball releases, as opposed to doing make dist).

    mkdir BUILD ; cd BUILD
    /path/to/ldapserver/configure [options]
    make

This is especially useful if you are using a single source directory for building on multiple releases/architectures:

    mkdir build.f8_i386
    mkdir build.f8_x86_64

and so on.

### Examples

We are using the above method of using a BUILD directory, and building on Fedora 20

#### Optimized Build

    cd BUILD
    ../ds/configure --enable-autobind --with-selinux --with-openldap --with-tmpfiles-d=/etc/tmpfiles.d --with-systemdsystemunitdir=/usr/lib/systemd/system --with-systemdsystemconfdir=/etc/systemd/system --with-systemdgroupname=dirsrv.target --with-fhs --libdir=/usr/lib64

#### Debug Build

    cd BUILD
    CFLAGS='-g -pipe -Wall  -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic' CXXFLAGS='-g -pipe -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../ds/configure --enable-autobind --with-selinux --with-openldap --with-tmpfiles-d=/etc/tmpfiles.d --with-systemdsystemunitdir=/usr/lib/systemd/system --with-systemdsystemconfdir=/etc/systemd/system --enable-debug --with-systemdgroupname=dirsrv.target --with-fhs --libdir=/usr/lib64


Debug DS
--------

You should either be using a debug build, or have the 389-ds-base debuginfo package installed before debugging.

### Attach to the process

    # gdb -p <pid>
    (gdb) <set some break points>
    (gdb) c

### Start/Run the server using gdb  

Replace INSTANCE with your server instance name

    # gdb /usr/sbin/ns-slapd
    (gdb) set args set args  -D /etc/dirsrv/slapd-INSTANCE -i /var/run/dirsrv/slapd-INSTANCE.pid -w /var/run/dirsrv/slapd-INSTANCE.startpid -d 0
    (gdb) <set some breakpoints if you want>
    (gdb) run


Installation
------------

Congratulations for sticking with us this far! See our [install guide](../legacy/install-guide.html) on how to set up the server.

