---
title: "Building Directory Server"
---

# Building Directory Server
---------------------

{% include toc.md %}


## Building 389 Directory Server

This describes the steps needed to build the Directory Server from source.  You can build rpms or an srpm, or install into existing package (make install).

### Get the source and the download dependencies

    # git clone https://github.com/389ds/389-ds-base.git
    # cd 389-ds-base
    # sudo dnf install `grep "^BuildRequires" rpm/389-ds-base.spec.in | awk '{print $2}' | sed -e "s/%{python3_pkgversion}/3/"`

#### Use specific source tarball

Get a specific source tarball from [here](../development/source.html).

### Build rpms/srpms

The server provides a rpm.mk file to make this easy, from the root of the source tree (389-ds-base directory) run the following:

    # make -f rpm.mk rpms

    or

    # make -f rpm.mk srpms

Both these commands will build npm packages. During this process, by default, we check for JS vulnerabilities.
Sometimes we need to skip audit-ci check because we are doing a bisect, checking older commit, or we just want to skip a known issue. For these purposes, we can use an environment variable SKIP_AUDIT_CI as per following:

    # SKIP_AUDIT_CI=1 make -f rpm.mk rpms

    or

    # SKIP_AUDIT_CI=1 make -f rpm.mk srpms

This creates the rpms/srpms under ~/source/389-ds-base/dist  Here is an example of the entire process

    # rm -rf ~/source/389-ds-base/dist   --> Clean it out first
    # vi SOME_SOURCE_CODE_FILE           --> make code changes if you want
    # make -f rpm.mk rpms
    # cd ~/source/389-ds-base/dist
    # dnf install *

### Build Locally

You can also run something like "make install" to build & install into the current filesystem/package.  We suggest you create a BUILD directory outside of the source tree, and run everything from there:

#### Initial setup

Create the BUILD and source code directories

    # mkdir ~/source
    # cd ~/source
    # mkdir BUILD
    # git clone https://github.com/389ds/389-ds-base.git   --> creates directory **389-ds-base**

#### Make your changes

Switch to your branch of choice, and make code changes.  Then before you build for the first time you need to run **autogen.sh**.  Here is an example:

    # cd 389-ds-base
    # git checkout 389-ds-base-1.3.8   --> this could be any branch, or skip this step to build from the *master* branch
    # vi SOURCE_FILE
    # ./autogen.sh

#### Build It

Now go back to the BUILD directory, and run the configure command

    # cd ~/source/BUILD
    # CFLAGS='-g -pipe -Wall  -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic' CXXFLAGS='-g -pipe -Wall -O2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../389-ds-base/configure --enable-autobind --with-selinux --with-openldap --with-tmpfiles-d=/etc/tmpfiles.d --with-systemdsystemunitdir=/usr/lib/systemd/system --with-systemdsystemconfdir=/etc/systemd/system --enable-debug --with-systemdgroupname=dirsrv.target --with-fhs --libdir=/usr/lib64 --with-systemd
    # make install

#### Building into a Prefix location (non-standard/not root)

You need to add the "**\-\-prefix**" to the configure command, and remove some other options

    $ cd ~/source/BUILD
    $ CFLAGS='-g -pipe -Wall  -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic' CXXFLAGS='-g -pipe -Wall -O2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../389-ds-base/configure --enable-debug --with-openldap --enable-gcc-security  --prefix=/export/389
    $ make install

Then to install the prefix build with **dscreate** you need to disable *selinux*, set the *prefix* location, and set the *user* and *group* to your user.  Here is a generic example of what the INF file should should look like:

    [general]
    config_version = 2
    full_machine_name = localhost.localdomain
    selinux = False
    start = True

    [slapd]
    instance_name = test-instance
    prefix = /export/389
    port = 5555
    secure_port = 5556
    root_dn = cn=directory manager
    root_password = secRet_passWord
    user = mreynolds
    group = mreynolds

    [backend-userroot]
    sample_entries = yes
    suffix = dc=example,dc=com

Then run **dscreate** like this:

    $ PREFIX=/export/389 dscreate from-file ./dssetup.inf


#### Optimized vs Debug Builds

The examples on this page all build DEBUG versions of the server.  To build an optimized version just remove then "**-g**" option from the CFLAGS and CXXFLAG variables.


### Legacy build instructions

FOr older build information please visit the [Legacy Build Page](legacy-building.html)
