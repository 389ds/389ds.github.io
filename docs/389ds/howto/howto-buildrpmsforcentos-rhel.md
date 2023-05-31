---
title: "Howto: BuildRPMsForCentOS RHEL"
---

# Build RPMs For CentOS/RHEL
------------------------

{% include toc.md %}

Overview
--------

Some individuals may wish to build and utilise their own RPMs for 389-ds. It is possible to build these from our git repositories or source tars.

Dependancies
------------

You will need to install:

    rpmdevtools
    rpm-build
    nspr-devel
    nss-devel
    svrcore-devel
    openldap-devel
    mozldap-devel
    db4-devel
    libdb-devel
    cyrus-sasl-devel
    icu
    libicu-devel
    pcre-devel
    gcc-c++
    net-snmp-devel
    lm_sensors-devel
    bzip2-devel
    zlib-devel
    openssl-devel
    tcp_wrappers
    pam-devel
    systemd-units
    nspr-devel
    nss-devel
    svrcore-devel
    openldap-devel
    mozldap-devel
    db4-devel
    libdb-devel
    cyrus-sasl-devel
    libicu-devel
    pcre-devel
    libtalloc-devel
    libevent-devel
    libtevent-devel
    valgrind-devel


Preparing
---------

Fetch the revelant source tar that you wish to build from.

    wget http://www.port389.org/binaries/389-ds-base-<version>.tar.bz2

    git clone https://github.com/389ds/389-ds-base.git
    git checkout tags/<version>

    export SRCDIR=`pwd`

Building
--------

You can now create a seperate build directory. DS can be built in a seperate build root, keeping the host and source directory clean.

    cd /path/to/buildroot
    mkdir build-ds
    cd build-ds

Configure the project and build the rpms;

    $SRCDIR/configure
    make rpms

This should place the rpms in /path/to/buildroot/build-ds/rpmbuild/RPMS/


