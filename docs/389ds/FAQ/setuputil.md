---
title: "SetupUtil"
---

# SetupUtil
-----------

Introduction
------------

The Setup Util is a collection of C++ APIs used to write programs that install, configure, and uninstall Fedora Server software.

Building SetupUtil
------------------

To build SetupUtil, see the [Directory Server Building](../development/building.html) page and get Compilers and Tools you need.

To build SetupUtil including the dependent component manually, you will need mozilla.org component in <srcroot>. (Let's assume we build SetupUtil in <srcroot>.)

    <srcroot>/mozilla

The build instructions are available on the [Directory Server Building](../development/building.html) page. The SetupUtil source is found [here]({{ site.baseurl }}/binaries/fedora-setuputil-1.0.tar.gz).

Or you can check out the source code:

    % cd to <srcroot>
    % cvs -d :pserver:anonymous@cvs.fedora.redhat.com:/cvs/dirsec -z3 co -r RELEASETAG setuputil

The current release tag is FedoraDirSvr103.

Then, build SetupUtil as follows:

    % cd setuputil ; make BUILD_DEBUG=[optimize|full] [USE_64=1] [BUILD_RPM=1]
    make options:
      BUILD_DEBUG=optimize  - Build optimized version
      BUILD_DEBUG=full      - Build debug version (default: without BUILD_DEBUG macro, debug version is built)
      USE_64=1              - Build 64-bit version (currently, for Solaris and HP only)
      BUILD_RPM=1           - Build RPM package (currently, for RHEL only)

The built libraries and the RPM packages are found in <srcroot>/<MM.DD> directory, where MM is 2 digit month and DD is 2 digit day.

    % ls `<srcroot>`/`<MM.DD>`/*  # build from "make BUILD_RPM=1 BUILD_DEBUG=full" on RHEL4
    fedora-setuputil-1.0.3-1.RHEL4.i386.dbg.rpm
    fedora-setuputil-1.0.3-1.RHEL4.src.rpm
    RHEL4_x86_gcc3_DBG.OBJ:
    bin/  include/  lib/  setuputil.tar.gz

### One-Step Build

One-Step Build [setuputilbuild]({{ site.baseurl }}/binaries/setuputilbuild-0.1.tar) is available on the platform on which GAR is installed.

    % tar xzf setuputilbuild-0.1.tar
    % cd to setuputilbuild/meta/setuputil
    % gmake`

Installation
------------

SetupUtil is a set of libraries and header files plus install/uninstall binaries, which could be used by the servers such as the Directory Server. Please follow the instructions for each server.

Documentation
-------------

Programming Guide is included in the source code. If you have the source code, cd to <srcroot>/setuputil/installer/doc. They are html files. To see the guide, please use a browser on your computer.

Please note that the Programming Guide has sections for the SetupUtil on Windows. The current version does not contain the code.

Prerequisites to use SetupUtil
------------------------------

The current version of SetupUtil uses system perl and unzip. The SetupUtil installer fails if they are not available. If your system does not have perl and unzip installed, please install them first or include them in the install package, set the path to the executables, then launch the installer.

