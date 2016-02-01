---
title: "Howto: GentooDsbuildInstallation"
---

# Fedora DS on Gentoo Linux Howto
-------------------------------

This Howto explains how to install Directory Server on a [Gentoo Linux](http://www.gentoo.org/) system.

{% include toc.md %}

### Building 389 Directory Server

389 Directory Server has been ported to gentoo as of Feburary 2016.

It can be installed with:

    sudo emerge -atv net-nds/389-ds-base

If you wish to install our git-master branch for testing purposes:

    sudo emerge -atv =net-nds/389-ds-base-9999

### Setup

At the end of a successful build process, emerge will give you a short list of instructions for running the setup utility.

Please note, your specific setup working directory may be different. You must read and follow the instructions at the end of the build process.

