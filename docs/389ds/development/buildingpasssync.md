---
title: "BuildingPassSync"
---

{% include toc.md %}

# How to build PassSync
----------------------

Pre-requisites
--------------

### Mozilla components (NSPR, NSS, LDAP C SDK)

<https://developer.mozilla.org/En/Windows_Build_Prerequisites>

Most of the Mozilla components use the MozillaBuild environment [<https://wiki.mozilla.org/MozillaBuild>](https://wiki.mozilla.org/MozillaBuild)- the MozillaBuild package contains an msys environment (a bash shell, many standard posix commands, perl, cvs, ssh, hg).

To use this on the 64-bit machine, you should also look at [<http://wiki.mozilla-x86-64.com/How_To_Build_Windows_x64_Build>](http://wiki.mozilla-x86-64.com/How_To_Build_Windows_x64_Build) which shows that you need to use a specific cmd shell (\\windows\\syswow64\\cmd.exe) to be able to use Mozilla-Build on a 64-bit Windows machine.

Start a build environment using the right .bat file. For a 64-bit build environment, use

    c:\mozilla-build\start-msvc9-x64.bat

For a 32-bit build environment, use

    c:\mozilla-build\start-msvc9.bat

Using the Mozilla-Build environment is great because you don't have to figure out how to use mks or cygwin or msys to download and configure a working build environment. Mozilla-Build includes everything you need and "it Just Works."

### Visual C++

Use Microsoft Visual Studio 2008 (aka VC9.0).

Note that you can use the Microsoft Visual C++ Express Edition instead of the full (\$\$\$) edition, but it does not come with the redistributable C++ runtime merge modules, so you can create binaries and redistribute them, you'll have to get the users to go to the Microsoft web site and download and install the correct C++ runtime. When you install C++ and its prerequisites/dependencies, this creates new Start menu items to open cmd windows with the environment set up to use the compiler, linker, etc. from the command line. This is used to build items that do not require the msys environment. Note: this is different from using the Mozilla-Build environment for performing 64-bit builds.

This is nice because you don't have to figure out how to set up your PATH, LIB, INCLUDE, etc. to compile things. It Just Works.

### Windows Support Tools

Some packages can use bitsadmin from the Windows Support Tools package to download dependencies using http (not ftp nor https). This may be installed in \\Program Files\\Support Tools, and in newer systems it may already be in the PATH.

This is nice because some packages used to require an entire mks/cygwin/msys environment just to use wget and unzip. Since http and unzip functionality are included with Windows now, builds are much simpler.

How to build NSPR
-----------------

Start out by visiting the official NSPR build instructions from Mozilla:

[<https://developer.mozilla.org/en/NSPR_build_instructions>](https://developer.mozilla.org/en/NSPR_build_instructions)

How to build NSS
----------------

### NOTES

Unlike NSPR and most other open source software which use autotools (autoconf, libtool, etc), NSS uses something called coreconf. Therefore, building NSS requires a basic understanding of how coreconf works. Instead of passing parameters to configure, core conf uses environment variables or passing parameters to make. Here is a list used by coreconf for NSS builds: [NSS Environment Variables](https://developer.mozilla.org/en/NSS_reference/NSS_environment_variables).

You can find more info on building NSS on the Mozilla Developer website: [NSS Build Instructions](https://developer.mozilla.org/en/NSS_reference/Building_and_installing_NSS/Build_instructions)

### Required Components

[NSPR](https://wiki.idm.lab.bos.redhat.com/export/idmwiki/index.php?title=IDM_Windows_Builds#How_to_build_NSPR)

How to build Mozilla LDAP C SDK
-------------------------------

The latest version is 6.0.6

Here are the individual steps to building.

1) checkout the source

    cvs -d :pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot export -rLDAPCSDK_6_0_6_RTM DirectorySDKSourceC

2) create the built directory

    mkdir $PLATFORM

3) run the configure script to set up the build

    #32-bit Debug
    cd $PLATFORM && ../mozilla/directory/c-sdk/configure -disable-optimize --enable-debug --enable-clu \
     --with-nspr=/i/components/nspr/v4.8/WINNT5.2_DBG.OBJ \
     --with-nspr-inc=/i/components/nspr/v4.8/WINNT5.2_DBG.OBJ/include \
     --with-nss=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_DBG.OBJ \
     --with-nss-inc=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_DBG.OBJ/include
     #32-bit Opt
    cd $PLATFORM && ../mozilla/directory/c-sdk/configure -enable-optimize --disable-debug --enable-clu \
     --with-nspr=/i/components/nspr/v4.8/WINNT5.2_OPT.OBJ \
     --with-nspr-inc=/i/components/nspr/v4.8/WINNT5.2_OPT.OBJ/include \
     --with-nss=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_OPT.OBJ \
     --with-nss-inc=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_OPT.OBJ/include
    #64-bit Debug
    cd $PLATFORM && ../mozilla/directory/c-sdk/configure --enable-64bit --disable-optimize --enable-debug --enable-clu \
     --with-nspr=/i/components/nspr/v4.8/WINNT5.2_64_DBG.OBJ \
     --with-nspr-inc=/i/components/nspr/v4.8/WINNT5.2_64_DBG.OBJ/include \
     --with-nss=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_64_DBG.OBJ \
     --with-nss-inc=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_64_DBG.OBJ/include\
     --target=x86_64-pc-mingw32
    #64-bit Opt
    cd $PLATFORM && ../mozilla/directory/c-sdk/configure --enable-64bit --enable-optimize --disable-debug --enable-clu \
     --with-nspr=/i/components/nspr/v4.8/WINNT5.2_64_OPT.OBJ \
     --with-nspr-inc=/i/components/nspr/v4.8/WINNT5.2_64_OPT.OBJ/include \
     --with-nss=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_64_OPT.OBJ \
     --with-nss-inc=/i/components/nss/NSS_3_12_4_RTM/WINNT5.2_64_OPT.OBJ/include \
     --target=x86_64-pc-mingw32

4) compile

    cd $PLATFORM
    make

Password Synchronization (PassSync)
-----------------------------------

### Steps

Prerequisites:

1.  install VC++, Windows SDK, MozillaBuild, bitsadmin (if not already installed)
2.  download WiX from wix.sourceforge.net
3.  download winsync source code from tagged URL (see below)

### Steps to build

The following Environment needs to included the following: (NOTE: CPU=AMD64 is case sensitive, ugh!) (NOTE: if VERSION is set, it will override the version and use that one.)

    set CPU=AMD64 # for a 64-bit build only
    set BUILD_DEBUG=optimize

1.  open a VC++ or SDK cmd window set up for the 32-bit or 64-bit build environment
2.  cd \\path\\to\\winsync
3.  run set\_envs.bat or manually set environment variables (See Environment above)
4.  kick off the build

        nmake /f winsync.mak passsync >  %PLATFORM%.log 2>&1
        #for example
        nmake /f winsync.mak passsync >  WINNT5.2_64_OPT.log 2>&1

The resultant file will be in dist\\WINNT5.2\_[64\_]OPT.OBJ called 389-PassSync-\${VERSION}-\${ARCH}.msi e.g. 389-PassSync-1.1.4-x86\_64.msi

### Pre-requisites

These must be installed first before doing anything else.

-   Microsoft VC++ and the corresponding Windows SDK
-   MozillaBuild - unzip.vbs is broken for unknown reasons, so we have to use c:\\mozilla-build\\info-zip\\unzip.exe to unzip the packages
-   bitsadmin - This is an optional Windows component, usually available in the Support Tools package on 2003 or included with 2008

### Source

-   the 389 winsync package - <http://git.fedorahosted.org/git/?p=389/winsync.git>
    -   replace TAG with the current release tag
    -   use web browser or wget to download
    -   list the tags - <http://git.fedorahosted.org/git/?p=389/winsync.git;a=tags>
    -   using the MozillaBuild or msys shell:

            cd /c/builds
            tar xfz /c/path/to/winsync-VERSION.tar.gz

### Required Components

-   NSPR - mdheader.jar and mdbinary.jar
-   NSS - xpheader.jar and mdbinary.jar
-   LDAP C SDK - mozldap .zip file for platform
-   WiX - creates the .msi

See winsync\\passwordsync\\build.bat for the specific nspr, nss, etc. paths.

### Environment

Use set to set these in your environment before invoking nmake, or set on the nmake command line

-   BUILD\_DEBUG - build a debug or optimize package - default is optimize
-   CPU - use CPU=amd64 to build the 64-bit build - default is 32-bit

Also look at the winsync\\passwordsync\\build.bat for other environment variables

### Building

1.  open a VC++ or SDK cmd window set up for the 32-bit or 64-bit build environment
2.  cd \\path\\to\\winsync
3.  set BUILD\_DEBUG=optimize
4.  nmake /f winsync.mak passsync \> log.PLATFORM 2\>&1

You can use the MozillaBuild/msys window to *tail -f log.PLATFORM* to see the build progress. The build attempts to download components from SBC and SBV using the bitsadmin command. Downloaded components are put in the components\\PLATFORM subdirectory. Things built by the build process will be put in the built\\PLATFORM subdirectory. The final .msi package will be in the dist\\PLATFORM directory and will be called 389-PassSync-VERSION-PLATFORM.msi e.g. 389-PassSync-1.1.4-x86\_64.msi

