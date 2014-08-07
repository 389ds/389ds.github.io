---
title: "Howto: GentooDsbuildInstallation"
---

# Fedora DS on Gentoo Linux Howto
-------------------------------

This Howto explains how to use the [One-Step Build](../development/building.html) instructions to install Fedora DS on a [Gentoo Linux](http://www.gentoo.org/) system.

{% include toc.md %}

### Prerequisites

#### Portage Packages

The following packages are required:

    sys-libs/libtermcap-compat
    app-arch/zip

The following packages are optional:

    dev-libs/cyrus-sasl
    net-analyzer/net-snmp
    dev-java/ant

`dev-libs/cyrus-sasl` and `net-analyzer/net-snmp` are required, but if you do not wish to install them on your system, the `dsbuild` script can download and compile the sources for it's own use, but not install them. `dev-java/ant` is required if you wish to compile the console and other Java code. While the console is not a requirement, you should install it unless you have a good reason not to.

    % emerge -av --oneshot libtermcap-compat zip cyrus-sasl net-snmp dev-java/ant

#### Link libtermcap

The build process requires the following link be created:

    % ln -s /lib/libtermcap.so.2 /lib/libtermcap.so

### Building Fedora DS

Next we will follow the One Step Build process detailed here: [One-Step Build](../development/building.html).

Download the [dsbuild]({{ site.baseurl }}/binaries/dsbuild-fds104.tar.gz) utility and extract it: (Refer to the [One-Step Build](../development/building.html) page for the latest version of dsbuild.)

    % tar xzf dsbuild-fds104.tar.gz

Now, cd to the build directory and `make`:

    % cd dsbuild-fds104/meta/ds
    % PATH="/usr/local/apache2/bin:${PATH}" make [SNMP_SOURCE=1] [SASL_SOURCE=1] [NOJAVA=1] 

If you chose to not install either the `dev-libs/cyrus-sasl` or `net-analyzer/net-snmp` packages, use the optional parameters `SASL_SOURCE=1` or `SNMP_SOURCE=1` respectively. Use `NOJAVA=1` if you chose not to install Ant.

The `PATH` variable is needed to force the Mozilla components to use the newly created Apache2 installation at `/usr/local/apache2`

### Setup

At the end of a successful build process, Fedora DS will give you a short list of instructions for running the setup utility.

First change your working directory to the setup utility's directory and then run setup:

    % cd /usr/src/dsbuild-fds104/ds/ldapserver/work/pkg
    % ./setup

Please note, your specific setup working directory may be different. You must read and follow the instructions at the end of the build process.

Please refer to [Fedora DS Setup](../legacy/oldsetup.html) instructions for help getting Fedora DS installed on your system.

