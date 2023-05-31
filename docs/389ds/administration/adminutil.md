---
title: "AdminUtil"
---

# AdminUtil
-------------

Introduction
------------

AdminUtil is a set of utility functions written in C, which are divided into 2 groups: libadminutil and libadmsslutil. They are mainly used in the Admin Server / CGI services to communicate with the configuration Directory Server. It covers, e.g., login to Admin Server using the authentication with the Directory Server. AdminUtil also provides CGI utilities such as parsing GET/POST arguments. AdminUtil is needed to build the Admin Server and DSGW.

Build Preparation
-----------------

To build AdminUtil, see the [Directory Server Building](../development/building.html) page and get Components, Compilers and Tools you need.

The AdminUtil source can be found [here](../development/source.html)

Building
--------

**configure** attempts to find all of the dependent components using pkg-config (e.g. pkg-config --libs nspr) or using the component specific script (e.g. net-snmp-config or icu-config). If that fails, configure will attempt to use the components from the standard system locations. You can override these with either the standard configure --dir options (e.g. --libdir=/path, --includedir=/path) or by overriding specific component paths (e.g. --with-nspr=/path/to/nspr --with-nss=/path/to/nss). Use configure --help to see all of the options.

The recommended build layout is to create a directory called "BUILD" on the same level as the the root directory fort the source code

    /home/user1/source/adminutil  -> Admin Server source code is under here
    /home/user1/source/BUILD

Then run your **configure** and **make** commands from the BUILD directory.  It keeps the source tree clean, and makes it easier to sumbit patches, etc.

**Optimized Build**

    ../adminutil/configure --with-selinux --with-systemdsystemunitdir=/usr/lib/systemd/system --with-fhs --libdir=/usr/lib64 --with-openldap
    make install

**Debug Build**

    CFLAGS='-g -pipe -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic' CXXFLAGS='-g -pipe -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../adminutil/configure --with-selinux --with-systemdsystemunitdir=/usr/lib/systemd/system --enable-debug --with-fhs --libdir=/usr/lib64 --with-openldap
    make install

There are 3 configure options that control where the files go during the install phase:

    --with-fhs  - this tells configure to use the standard FHS layout - see [FHS_Packaging](../development/fhs-packaging.html) for details
    --with-fhs-opt  - this tells configure to use the FHS /etc/opt, /var/opt, and /opt hierarchy
    --prefix=/path  - the default value of prefix is /opt/dirsrv

The build also honors the **DESTDIR=/path** option, which copies the files to a specific location using the FHS hierarchy - this is essentially what rpmbuild does.  Developers will probably want to use something like:

    configure --with-fhs ...
    make DESTDIR=/var/tmp/tmpbuild install

To install the server under a specific directory use the "--prefix" argument:

    configure OPTIONS --prefix=/home/user1/myAdminUtil/
    make install


