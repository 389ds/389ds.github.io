---
title: "Building Svrcore"
---

# Building Svrcore
------------------

### Checkout the source

    git clone https://pagure.io/svrcore.git

### Prepare the build environment

    autoreconf
    ./configure --prefix=/opt/svrcore

Optionally, you may choose to enable systemd support.

    ./configure --prefix=/opt/svrcore --with-systemd

### Build

    make
    sudo make install

### Testing the New Build
-------------------------

#### Examples.

You can build the example clients, and use these to test the build.

#### Directory Server

To build directory server with this Svrcore:

    ./configure --with-svrcore=/opt/svrcore

To run directory server with this svrcore, you may need to add /opt/svrcore to /etc/ld.so.conf.d/svrcore.conf

    /opt/svrcore

Alternately, you can use LD_LIBRARY_PATH with ns-slapd.




