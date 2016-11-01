---
title: "Building Nunc-Stans"
---

# Building Nunc-Stans
---------------------

### Checkout the source

    git clone https://git.fedorahosted.org/git/nunc-stans.git

Or download it:

    wget http://www.port389.org/binaries/nunc-stans-0.2.1.tar.xz
    sha256sum nunc-stans-0.2.1.tar.xz
    echo "ee87a1e090e2b06616f3626c14c465226fadcf2d0d42bd4a178771b4a5ecf972"
    tar -xvJf nunc-stans-0.2.1.tar.xz

### Prepare the build environment

For a production system:

    autoreconf -fiv
    ./configure --prefix=/opt/nunc-stans

If you plan to develop against nunc-stans, enable the debug flags to help you
detect issues at runtime.

    autoreconf -fiv
    ./configure --prefix=/opt/nunc-stans --enable-debug

### Build

    make
    make check
    sudo make install

### Examples

Examples can be found in the tests directory. The stress_test.c is a good example
of a client and server usage of nunc-stans.

### Directory Server

To build Directory Server with this nunc-stans:

    cd ds
    autoreconf -fiv
    ./configure ... --with-nunc-stans=/opt/nunc-stans --enable-nunc-stans

Then see the [nunc-stans](/docs/389ds/design/nunc-stans.html) page on how to enable.
