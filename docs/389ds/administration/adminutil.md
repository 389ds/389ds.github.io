---
title: "AdminUtil"
---

# AdminUtil
-------------

Introduction
------------

AdminUtil is a set of utility functions written in C, which are divided into 2 groups: libadminutil and libadmsslutil. They are mainly used in the Admin Server / CGI services to communicate with the configuration Directory Server. It covers, e.g., login to Admin Server using the authentication with the Directory Server. AdminUtil also provides CGI utilities such as parsing GET/POST arguments. AdminUtil is needed to build the Admin Server and DSGW.

Building AdminUtil
------------------

To build AdminUtil, see the [Directory Server Building](../development/building.html) page and get Compilers and Tools you need.

To build AdminUtil including the dependent components manually, you will need libicu and mozilla.org components. Their build instructions are available on the [Directory Server Building](../development/building.html) page. The AdminUtil source is found [here](../development/source.html).

The simplest way to build is to just do

    configure [options]
    make

**configure** attempts to find all of the dependent components using pkg-config (e.g. pkg-config --libs nspr) or using the component specific script (e.g. net-snmp-config or icu-config). If that fails, configure will attempt to use the components from the standard system locations. You can override these with either the standard configure --dir options (e.g. --libdir=/path, --includedir=/path) or by overriding specific component paths (e.g. --with-nspr=/path/to/nspr --with-nss=/path/to/nss). Use configure --help to see all of the options.

Installation
------------

AdminUtil is a set of libraries and header files, which could be used by the servers such as the Directory Server. Please follow the instructions for each server.

Future Plan
-----------

We are thinking to write down the API documentation and push it to this Wiki. Your contribution would be also very welcome and appreciated!
