---
title: "Howto: DebianUbuntu"
---

# Debian/Ubuntu
---------------

{% include toc.md %}

Fedora DS 1.1.1 on Ubuntu Hardy
-------------------------------

If anyone is interested in prebuilt packages of the new release for Ubuntu Hardy, there are instructions on <http://www.opencodes.org/fedora-ds-packages> how to get them.

Fedora DS pre 1.1.0 on Ubuntu/Debian Howto
------------------------------------------

This document describes howto install the Fedora Directory Server (FDS) on Ubuntu 5.10 (Breezy Badger) or Debian GNU/Linux Sarge. I presume you already have done a minimal installation of the OS of choice. Most steps to Ubuntu and Sarge are equal, however this howto is base on the installation of the 'sudo' package. As an alternative you can 'su -' on Debian and skip the sudo part of the commands.

### Get the software

Download a prebuild rpm from [Download](../download.html). Choose the version suitable for Fedora Core 3 and RHEL4. For Debian GNU/Linux Sarge the rpm for RHEL3 is required (Ubuntu has libc6 version 2.3.5 while Sarge has version 2.3.2).

For Dapper Drake (libc 2.3.6) use the Fedora Core 4 RPM.

### Install alien-package

Alien is a tool that supports converting software in 'rpm' format to 'deb' format.

    sudo apt-get install alien    

### Build the fedora-ds .deb package

    sudo alien /YOURPATH/fedora-ds-1.0.1-1.RHEL4.i386.opt.rpm (Ubuntu)    
    sudo alien /YOURPATH/fedora-ds-1.0.1-1.RHEL3.i386.opt.rpm (Debian Sarge)    
    sudo alien /YOURPATH/fedora-ds-1.0.2-1.FC4.i386.opt.rpm (Ubuntu Dapper)    

### Build dependencies

The Fedora Directory Server needs 'libtermcap.so.2', so install it.

    sudo apt-get install termcap-compat    

Install the Sun Java SDK or JRE version 1.4.2. Don't forget to set the JAVA\_HOME and PATH variables! The admin-server of FDS depends on Apache2 compiled conform the worker model, so let's install it

    sudo apt-get install apache2-mpm-worker    

As Fedora calls the daemon 'httpd' while Ubuntu calls it 'apache2' (like Debian), we want to create a symbolic link to satisfy FDS' setup utility.

    sudo ln -s /usr/sbin/apache2 /usr/sbin/httpd    

#### Ubuntu Dapper Drake Packages

The necessary termcap-compat package does not seem to be available for Dapper but the one from Breezy is reported to work fine. termcap-compat depends on the libc5 and ldso packages which aren't available for Dapper either. However Debian repositories still maintains this package.

##### Easy installation of termcap packages

Ubuntu.org no longer supports Breezy repositories, and the termcap-compat package is no available for any later Ubuntu releases. Simply fetch the following debian packages from their mirror and install manually.

    wget http://mirrors.kernel.org/debian/pool/main/t/termcap-compat/termcap-compat_1.2.3_i386.deb

    wget http://mirrors.kernel.org/debian/pool/main/libc/libc/libc5_5.4.46-15_i386.deb

    wget http://mirrors.kernel.org/debian/pool/main/l/ld.so/ldso_1.9.11-15_i386.deb

    dpkg --install ldso\_1.9.11-15\_i386.deb

    dpkg --install libc5\_5.4.46-15\_i386.deb

    dpkg --install termcap-compat\_1.2.3\_i386.deb

#### Ubuntu x86\_64

The termcap-compat package is required for installation of fds on Ubuntu and Debian. Unfortunately, this package is not available for the x86\_64 platform. In order to install fds on a Ubuntu Dapper x86\_64 xen-U this workaround seems to work for me:

-   Get the termcap-5.4-4.noarch.rpm and libtermcap-2.0.8-41.x86\_64.rpm package from the Fedora Core 4 x86\_64 distribution.
-   Convert these two packages to .deb and install them (dpkg -i).

### Install .deb package

    sudo dpkg -i /YOURPATH/fedora-ds_1.0.1-2_i386.deb    

### Create a user and group for the daemon

    sudo groupadd fds    
    sudo useradd -s /bin/false -g fds fds    

### Run the setup program

Now we want to configure the FDS. As the setup utility won't find the Apache2 modules on Debian/Ubuntu by default, we'll have to help it. First we'll create an install.inf file by running the setup utility with the '-k' option.

    sudo /opt/fedora-ds/setup/setup -k    

Choose '1' for as minimal questions as possible. Choose 'fds' when asked which user and group apply. After finalizing the setup wizard the directory server itself will be started as user 'fds'. It listens on the port you just configured (i chose port '389', the default LDAP-port). When done, copy the install.inf file to /opt

    sudo cp /opt/fedora-ds/setup/install.inf /opt    
    sudo chmod 640 /opt/install.inf    

Then add this rule to the [admin] section of the file:

    ApacheDir= /usr/sbin ApacheRoot= /usr/lib/apache2

Afterwards rerun the setup utility with the following options:

    sudo /opt/fedora-ds/setup/setup -s -f /opt/install.inf    

This will generate the required start/stop scripts for apache.

### Adjust the admin-server's httpd.conf

We have to make some changes to the '/opt/fedora-ds/admin-serv/config/httpd.conf' file. Some modules do not have to be loaded as they are compiled in statically. So un-comment these lines:

    ...    
    #LoadModule access_module /usr/lib/apache2/modules/mod_access.so    
    #LoadModule auth_module /usr/lib/apache2/modules/mod_auth.so    
    #LoadModule log_config_module /usr/lib/apache2/modules/mod_log_config.so    
    #LoadModule env_module /usr/lib/apache2/modules/mod_env.so    
    ...    
    #LoadModule setenvif_module /usr/lib/apache2/modules/mod_setenvif.so    
    #LoadModule mime_module /usr/lib/apache2/modules/mod_mime.so    
    ...    
    #LoadModule negotiation_module /usr/lib/apache2/modules/mod_negotiation.so    
    #LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so    
    ...    
    #LoadModule alias_module /usr/lib/apache2/modules/mod_alias.so    
    ...    

### Now try to start the admin-server

    sudo /opt/fedora-ds/start-admin    

If it works, Good :-) If not, you probably didn't have enough coffee!

Cheers, Olivier Brugman

Building on Debian - One Step Build
-----------------------------------

These instructions are for Debian 3.1.

### Install prerequisite packages

The following is a list of packages I had to install on my system to make dsbuild work. I used synaptic to install them, and that automatically installed many dependent packages as well. I think apt-get or aptitude will do the same thing:

    apache2 2.0.54-5sarge1
    apache2-common 2.0.54-5sarge1
    apache2-doc 2.0.54-5sarge1
    apache2-mpm-prefork 2.0.54-5sarge1
    apache2-threaded-dev 2.0.54-5sarge1
    apache2-utils 2.0.54-5sarge1
    cpp 3.3.5-3
    cpp-3.3 3.3.5-13
    diff 2.8.1-11
    g++ 3.3.5-3
    g++-3.3 3.3.5-13
    gcc 3.3.5-3
    gcc-3.3 3.3.5-13
    gcc-3.3-base 3.3.5-13
    gcc-3.4-base 3.4.3-13sarge1
    gzip 1.3.5-10sarge2
    libapr0 2.0.54-5sarge1
    libapr0-dev 2.0.54-5sarge1
    libc5 5.4.46-15
    libc6 2.3.2.ds1-22sarge4
    libc6-dev 2.3.2.ds1-22sarge4
    libncurses5 5.4-4
    libncurses5-dev 5.4-4
    libncursesw5 5.4-4
    libpam0g 0.76-22
    libpam0g-dev 0.76-22
    libsasl2 2.1.19.dfsg1-0sarge2
    libsasl2-dev 2.1.19.dfsg1-0sarge2
    libsasl2-gssapi-mit 2.1.19-1.1
    libsasl2-modules 2.1.19.dfsg1-0sarge2
    libsensors-dev 2.9.1-1sarge3
    libsensors3 2.9.1-1sarge3
    libsnmp-base 5.1.2-6.2
    libsnmp-perl 5.1.2-6.2
    libsnmp5 5.1.2-6.2
    libsnmp5-dev 5.1.2-6.2
    libstartup-notification0 0.8-1
    libstdc++5 3.3.5-13
    libstdc++5-3.3-dev 3.3.5-13
    libstdc++6 3.4.3-13sarge1
    make 3.80-9
    ncurses-base 5.4-4
    ncurses-bin 5.4-4
    ncurses-term 5.4-4
    perl 5.8.4-8sarge5
    perl-base 5.8.4-8sarge5
    perl-modules 5.8.4-8sarge5
    termcap-compat 1.2.3
    unzip 5.52-1sarge4
    wget 1.9.1-12
    zip 2.31-1

### Configure some symlink'd commands

You need to "alias" some system commands to make dsbuild happy.

    mkdir $HOME/bin # if you don't have this already    
    cd $HOME/bin    
    ln -s /usr/bin/make gmake # dsbuild expects a "gmake" (gnu make) command, which is just make on linux systems    
    ln -s /usr/bin/apxs2 apxs # looks for apxs not apxs2    

Then, make sure \$HOME/bin is in your path e.g.

    export PATH=${PATH}:$HOME/bin    

Or put this in your \$HOME/.bash\_profile for safekeeping.

### Get the One Step Build file

[Building\#One-Step\_Build](../development/building.html) shows how to download, unpack, and use the one step build makefile.

### Some patches are required

Start the build. It should go through quite a bit until mod\_nss. Then, using [this patch]({{ site.baseurl }}/binaries/fds104.mod_nss.debian31.patch), do this:

    cd dsbuild-fds104/ds/mod_nss/work/mod_nss-1.0.5    
    patch -p0 < /path/to/patchfile    

Then continue the build

    cd dsbuild-fds104/meta/ds    
    make ... make args ... # continue one step build as above    

The next stop is in mod\_restartd. Using [this patch]({{ site.baseurl }}/binaries/fds104.mod_restartd.debian31.patch), do this:

    cd dsbuild-fds104/ds/mod_restartd/work/mod_restartd-1.0.3    
    patch -p0 < /path/to/patchfile    

Then, remove the configure cookie:

    cd dsbuild-fds104/ds/mod_restartd/cookies    
    rm -rf configure-work    

Then, resume the one step build

    cd dsbuild-fds104/meta/ds    
    make ... make args ... # continue one step build as above    

