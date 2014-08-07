---
title: "Howto: BuildRPMsForCentOS RHEL"
---

# Build RPMs For CentOS/RHEL
------------------------

{% include toc.md %}

Overview
--------

If you're like me, then you like having a copy of everything you install on your servers somewhere you'll know you'll be able to get to them. This howto will describe how to get fedora-ds packages built for your CentOS/RHEL systems, so you can dump them in your kickstart repository, add them to a deployment CD, or whatever. I used a CentOS 5.2 Build to test it.

There are two approaches to building packages that will be described here:

-   Doing it with mach (much simpler)
-   Doing it by hand

Doing it with mach
------------------

[mach](http://thomas.apestaart.org/projects/mach/) is a tool that "allows you to set up clean build roots from scratch for any distribution or distribution variation supported." Among other things, it will fetch dependencies for you (or rather, yum will), which simplifies the process considerably. Packages are available for [RHEL, CentOS and Fedora](http://dag.wieers.com/rpm/packages/mach/), and there are a few places that explain the setup process:

-   [HOWTOForge.com](http://www.howtoforge.com/building-rpm-packages-in-a-chroot-environment-using-mach)
-   [The Fedora Project Wiki](http://fedoraproject.org/wiki/UsingMach)
-   and, of course, [mach's own documentation](http://mach.cvs.sourceforge.net/*checkout*/mach/mach2/README?revision=1.45).

There's one problem with the SRPMs for Fedora 6 that we use: the "fedora-admin-console" package was renamed to "fedora-ds-admin-console"; the SRPM for this packages was not updated, but the spec file for fedora-ds *was*. That means that fedora-ds requires the new package name, but we only have the old package name. To get around this, you need to modify the spec file for fedora-admin-console and rebuild the SRPM.

Here's how I did this:

-   Put this into \~/.rpmmacros:

        %packager %(echo "$USER")    
        %_topdir %(echo "$HOME")/rpmbuild    

-   Create the necessary directories:

        for i in BUILD RPMS SOURCES SPECS SRPMS ; do mkdir -p ~/rpmbuild/${i} ; done    

-   Install the fedora-admin-console SRPM:

        $ rpm -ivh     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-admin-console-1.1.0-4.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-admin-console-1.1.0-4.src.rpm)

-   Re-pack the tarball:

        $ cd ~/rpmbuild/SOURCES    
        $ tar xvjf fedora-admin-console-1.1.0.tar.bz2    
        $ mv fedora-admin-console-1.1.0 fedora-ds-admin-console-1.1.0    
        $ tar cvjf  fedora-ds-admin-console-1.1.0.tar.bz2  fedora-ds-admin-console-1.1.0    

-   Rename the spec file:

        $ mv ~/rpmbuild/SPECS/fedora-admin-console.spec ~/rpmbuild/SPECS/fedora-ds-admin-console.spec    

-   Edit the spec file and change the "Name:" line:

        # Before:    
        # Name: fedora-admin-console    
        # After:    
        Name: fedora-ds-admin-console    

-   Rebuild the SRPM:

        $ rpmbuild --nodeps -bs rpmbuild/SPECS/fedora-ds-admin-console.spec    
        Wrote: ~/rpmbuild/SRPMS/fedora-ds-admin-console-1.1.0-4.src.rpm    

-   Install mach (left as an exercise for the reader)

-   Build the RPMs using mach:

        mach -k rebuild     [    http://mirror.steadfast.net/fedora/extras/6/SRPMS/jss-4.2.5-1.fc6.src.rpm    ](http://mirror.steadfast.net/fedora/extras/6/SRPMS/jss-4.2.5-1.fc6.src.rpm)
        mach -k rebuild     [    http://mirror.steadfast.net/fedora/extras/6/SRPMS/adminutil-1.1.5-1.fc6.src.rpm    ](http://mirror.steadfast.net/fedora/extras/6/SRPMS/adminutil-1.1.5-1.fc6.src.rpm)     # devel    
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/idmcommon/fedora/6/noarch/SRPMS/idm-console-framework-1.1.0-2.src.rpm    ](http://directory.fedoraproject.org/yum/idmcommon/fedora/6/noarch/SRPMS/idm-console-framework-1.1.0-2.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-base-1.1.3-2.fc6.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-base-1.1.3-2.fc6.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-admin-1.1.6-1.fc6.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-admin-1.1.6-1.fc6.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-ds-console-1.1.0-5.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-ds-console-1.1.0-5.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/idmcommon/fedora/6/i386/SRPMS/fedora-idm-console-1.1.0-5.src.rpm    ](http://directory.fedoraproject.org/yum/idmcommon/fedora/6/i386/SRPMS/fedora-idm-console-1.1.0-5.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-1.1.2-1.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-1.1.2-1.src.rpm)
        mach -k rebuild     [    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-dsgw-1.1.1-1.fc6.src.rpm    ](http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-dsgw-1.1.1-1.fc6.src.rpm)
        # Don't forget your rebuilt fedora-ds-admin-console package:    
        mach -k rebuild ~/rpmbuild/SRPMS/fedora-ds-admin-console-1.1.0-4.src.rpm    

The RPMs should now be in /var/tmp/mach.

Doing it by hand
----------------

### Prerequisites

Install a base CentOS system. I usually start with a completely clean kickstart install that has only the following for a %packages section:

    %packages
    @Base
    dhcp
    sendmail-cf
    cfengine
    -gpm

But you probably won't need dhcp,sendmail-cf, or cfengine for this example. If you already have a pretty clean install, then that will do too. You'll also need to have a yum repository set up on your system so you can pull some additional packages. These should all be on the CentOS/RHEL install media.

### Install packages needed to build rpms

    #### Install Build Prerequisites
    /bin/cat<<EOPKGS>/tmp/pkglist
    # From CentOS repository
    screen rpm-devel rpm-build openssl-devel gcc gcc-c++ libXp libXtst
    nspr-devel nss-devel svrcore-devel mozldap-devel libicu-devel icu
    db4-devel cyrus-sasl-devel net-snmp-devel lm_sensors-devel bzip2-devel
    pam-devel cyrus-sasl-gssapi cyrus-sasl-md5 mozldap-tools perl-Mozilla-LDAP
    ant ldapjdk jpackage-utils httpd-devel apr-devel mod_nss libXmu
    compat-libstdc++-33 xorg-x11-xauth xterm
    strace screen
    EOPKGS

    PKGS=$(/bin/sed -e 's/#.*//g' /tmp/pkglist|grep .|\
        while read line; do echo -n "${line} "; done)
    /usr/bin/yum install -y ${PKGS}

### JDK

You'll need one **(but not both)** of these JDKs. You'll have to navigate around the vendor's website to find and scavenge them. (Which is usually a nightmarish proposition, but it's necessary.) It's best if you think of it as a game, like a scavenger hunt. You know, to stay sane while in those websites... I've provided sha256sums of the ones I found...

#### Sun JDK

Either Build and Install Sun's JDK (I had better luck with this)

    # SCAVENGE:: /usr/src/redhat/SOURCES/jdk-1_5_0_16-linux-i586.bin
    # 7cb486cf797304b44dcb2389e35ca5fd52de7e0a4a24b14b1f6a281a86e93871

    SOURCES="/opt/local/src"; if [ ! -d ${SOURCES} ]; then mkdir -p ${SOURCES};fi
    ### Move the jdk-1_5_0_16-linux-i586.bin you've found to usr/src/redhat/SOURCES/jdk-1_5_0_16-linux-i586.bin
    (cd SOURCES; wget http://mirrors.dotsrc.org/jpackage/5.0/generic/non-free/SRPMS/java-1.5.0-sun-1.5.0.15-1jpp.nosrc.rpm)
    sed -e 's/%define buildver.*15/%define buildver 16/' /usr/src/redhat/SPECS/java-1.5.0-sun.spec | \
       awk '{ if($0~/^%changelog/){ \
    print $0"\n* Wed Jul 30 2008 Your Name <your.name@gmail.com> - 0:1.5.0.16-1jpp\n- 1.5.0.16-1jpp\n"; \
    }else{ \
    print $0; \
    }}' > /usr/src/redhat/SPECS/java-1.5.0-sun.patched.spec
    rpmbuild -ba /usr/src/redhat/SPECS/java-1.5.0-sun.patched.spec

Install the resulting RPMs

#### IBM JDK

Or Build and Install IBM's JDK ( I had better luck with Sun's, even with the patching)

    # SCAVENGE:: /usr/src/redhat/SOURCES/ibm-java2-sdk-5.0-8.0-linux-i386.tgz
    # (32b999d37190be1ca7f5553c84faa70fd5c1da2011e860a609f8a0a458534a4e)
    # SCAVENGE /usr/src/redhat/SOURCES/ibm-java2-javacomm-5.0-8.0-linux-i386.tgz
    # (b7f826f780db6a345fd2f3d9f7c4259a4a7f7c18a4e958d26bc104999e361d14)

    SOURCES="/opt/local/src"; if [ ! -d ${SOURCES} ]; then mkdir -p ${SOURCES};fi
    ### Put the sources you scavenged in /usr/src/redhat/SOURCES
    wget -O /opt/local/src/java-1.5.0-ibm-1.5.0.5.0-2jpp.nosrc.rpm \
        http://mirrors.dotsrc.org/jpackage/5.0/generic/non-free/SRPMS/java-1.5.0-ibm-1.5.0.5.0-2jpp.nosrc.rpm
    rpm -Uvh /opt/local/src/java-1.5.0-ibm-1.5.0.5.0-2jpp.nosrc.rpm
    /bin/cat /usr/src/redhat/SPECS/java-1.5.0-ibm.spec | \
        sed -e 's/-\%{buildver}-lin/-%{patchver}-lin/g' /usr/src/redhat/SPECS/java-1.5.0-ibm.spec | \
      awk '{ if($0~/^%changelog/){ \
    print $0"\n* Wed Jun 13 2007 Your Name <your.name@gmail.com> - 1:1.5.0.5.0-2jpp\n- 1.5.0.8.0\n"; \
    }else{ \
    print $0; \
    } \
    if($0~/^%define buildver/){ print "%define patchver 8.0\n"; }\
    }' > /usr/src/redhat/SPECS/java-1.5.0-ibm.patched.spec
    rpmbuild -ba --target i386 /usr/src/redhat/SPECS/java-1.5.0-ibm.patched.spec 2>&1 | \
       grep "error: Bad file:" | awk '{print $4}' | sed -e's/://'| while read bfile; do touch ${bfile} ;done
    rpmbuild -ba --target i386 /usr/src/redhat/SPECS/java-1.5.0-ibm.patched.spec

Install the resulting RPMs

    rpm -Uvh /usr/src/redhat/RPMS/i386/java-1.5.0-ibm-1.5.0.5.0-2jpp.i386.rpm
    rpm -Uvh /usr/src/redhat/RPMS/i386/java-1.5.0-ibm-devel-1.5.0.5.0-2jpp.i386.rpm
    rpm -Uvh /usr/src/redhat/RPMS/i386/java-1.5.0-ibm-javacomm-1.5.0.5.0-2jpp.i386.rpm

### Fetch the Source and Build

Make a list of the srpms you want to fetch and from where

    /bin/cat<<EOSRPM>/tmp/srpmlist
    http://mirror.steadfast.net/fedora/extras/6/SRPMS/jss-4.2.5-1.fc6.src.rpm
    http://mirror.steadfast.net/fedora/extras/6/SRPMS/adminutil-1.1.5-1.fc6.src.rpm # devel
    http://directory.fedoraproject.org/yum/idmcommon/fedora/6/noarch/SRPMS/idm-console-framework-1.1.0-2.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-base-1.1.3-2.fc6.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-admin-1.1.6-1.fc6.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-admin-console-1.1.0-4.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/noarch/SRPMS/fedora-ds-console-1.1.0-5.src.rpm
    http://directory.fedoraproject.org/yum/idmcommon/fedora/6/i386/SRPMS/fedora-idm-console-1.1.0-5.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-1.1.2-1.src.rpm
    http://directory.fedoraproject.org/yum/dirsrv/fedora/6/i386/SRPMS/fedora-ds-dsgw-1.1.1-1.fc6.src.rpm
    EOSRPM

Optionally fetch these (for windows)

    http://directory.fedoraproject.org/download/FedoraConsole.msi # md5sum 55d98a8633c879ebdbb33fb73782c286
    http://directory.fedoraproject.org/download/PassSync-20060330.msi # md5sum 54c33a6e665bb2526f1f286e505cc0ff

Write out the script that will loop through them and fetch and build them...

    if [ ! -d /root/bin/ ]; then mkdir -p /root/bin; fi
    /bin/cat<<EOGO>/root/bin/rpmgo
    #!/bin/bash
    rpm=\$1
    rpm -Uvh \${rpm} >/dev/null 2>&1
    specfile=\$(rpm -qlp \$rpm 2>/dev/null | grep ".spec\$")
    rpmbuild -ba /usr/src/redhat/SPECS/\${specfile} | tee /tmp/rpmbuild.out 2>&1
    /bin/grep "Wrote:" /tmp/rpmbuild.out|/bin/egrep -v "src.rpm"| \
    /bin/sed -e 's/Wrote: //g' | while read package; do
        rpm -Uvh \${package};
    done
    echo
    EOGO
    chmod 755 /root/bin/rpmgo

Crank 'em out.

    export SOURCES="/opt/local/src"
    if [ ! -d ${SOURCES} ]; then mkdir -p ${SOURCES};fi
    if [ -d ${SOURCES} ]; then
    for url in `sed -e 's/#.*//g' /tmp/srpmlist|grep .`;do
    file=$(echo ${url}| sed -e 's/.*\///g';)
            if [ ! -f ${SOURCES}/${file} ];then
    wget -O ${SOURCES}/${file} "${url}"
            fi
            (cd ${SOURCES}; /root/bin/rpmgo ${file})
        done
    fi
    export newrpms=$(find /usr/src/redhat/RPMS -name "*.rpm" | grep -v "src.rpm" | tr "\n" " ")
    clear; echo ${newrpms}

### Resulting RPMs

The resulting rpms you will have: IBM:

    java-1.5.0-ibm-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-demo-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-devel-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-javacomm-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-jdbc-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-plugin-1.5.0.5.0-2jpp.i386.rpm
    java-1.5.0-ibm-src-1.5.0.5.0-2jpp.i386.rpm

Sun

    java-1.5.0-sun-1.5.0.16-1jpp.i586.rpm
    java-1.5.0-sun-devel-1.5.0.16-1jpp.i586.rpm
    java-1.5.0-sun-fonts-1.5.0.16-1jpp.i586.rpm

fedora-ds

    adminutil-1.1.5-1.i386.rpm
    adminutil-devel-1.1.5-1.i386.rpm
    fedora-admin-console-1.1.0-4.noarch.rpm
    fedora-ds-1.1.2-1.i386.rpm
    fedora-ds-admin-1.1.6-1.i386.rpm
    fedora-ds-base-1.1.3-2.i386.rpm
    fedora-ds-base-devel-1.1.3-2.i386.rpm
    fedora-ds-console-1.1.0-5.noarch.rpm
    fedora-idm-console-1.1.0-5.i386.rpm
    idm-console-framework-1.1.0-2.noarch.rpm
    jss-4.2.5-1.i386.rpm

Put these in your repositories CentOS/RPMS directory and re-run createrepo and you'll be ready to [deploy from kickstart](howto-deployfromkickstart.html)

