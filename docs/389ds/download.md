---
title: "Download"
---

# Download 389 Directory Server
-------------------------------

Below you will find links to download the binary packages and source files. Please see the [FAQ section on Open Source](FAQ/faq.html#open-source) for more information.

{% include toc.md %}

<div style="text-align: left;">
<span style="display:inline-block;padding:1px;border:1px solid #000;font-size:80%;">
EXPORT CONTROL. As required by U.S. law, you (Licensee) represents and warrants that it: (a) understands that the Software is subject to export controls under the U.S. Commerce Department's Export Administration Regulations ("EAR"); (b) is not located in a prohibited destination country under the EAR or U.S. sanctions regulations (currently Cuba, Iran, Iraq, North Korea, Sudan and Syria); (c) will not export, re-export, or transfer the Software to any prohibited destination, entity, or individual without the necessary export license(s) or authorizations(s) from the U.S. Government; (d) will not use or transfer the Software for use in any sensitive nuclear, chemical or biological weapons, or missile technology end-uses unless authorized by the U.S. Government by regulation or specific license; (e) understands and agrees that if it is in the United States and exports or transfers the Software to eligible end users, it will, as required by EAR Section 740.17(e), submit semi-annual reports to the Commerce Department's Bureau of Industry & Security (BIS), which include the name and address (including country) of each transferee; and (f) understands that countries other than the United States may restrict the import, use, or export of encryption products and that it shall be solely responsible for compliance with any such import, use, or export restrictions.
</span>
</div>
<br>

## Binary Packages
------------------

After you have installed packages for your system as below, see our [install guide](/docs/389ds/howto/howto-install-389.html) for what's next.

### Fedora (ds 2.x)

    dnf install 389-ds-base

If you want to use the cockpit web ui:

    dnf install cockpit-389-ds

### OpenSUSE LEAP (ds 2.x)

    zypper install 389-ds

### CentOS Stream 8/9, EL8/EL9 (ds 2.x)

`389-ds-base` is part of AppStream repository and can be installed by running
```
dnf install 389-ds-base
```

`cockpit-389-ds` is not distributed in AppStream. We provide 2 separate copr repositories that contain both `389-ds-base` and `cockpit-389-ds`:
* [`@389ds/389-directory-server`](https://copr.fedorainfracloud.org/coprs/g/389ds/389-directory-server/) - rebuild of 389-ds-base package from the latest of the [currently supported releases](https://fedoraproject.org/wiki/Releases#Current_Supported_Releases) of Fedora.
* [`@389ds/389-directory-server-next`](https://copr.fedorainfracloud.org/coprs/g/389ds/389-directory-server-next/) - rebuild of 389-ds-base package from Fedora Rawhide, bleeding edge development version. **NOT RECOMMENDED** to be used in production, for testing purposes only.

```
dnf copr enable @389ds/389-directory-server
dnf install 389-ds-base cockpit-389-ds
```

If you're upgrading from EPEL8 modular packages, enable copr repository and reset the old module:

```
dnf copr enable @389ds/389-directory-server
dnf update 389-ds-base cockpit-389-ds
dnf module reset 389-directory-server
```

### CentOS 8.1+ (ds 1.4.x)

Instructions below are outdated since EPEL Modular repository was deprecated, please use copr repository from the section above.
<details>
<summary>Old instructions for 389-directory-server module</summary>

In CentOS 8.1+ directory server is distributed as a module in EPEL 8 (see [Modularity](https://docs.fedoraproject.org/en-US/modularity/) documentation for more information).
There are three streams available:
* `stable` - rebuild of 389-ds-base package from the *oldest* of the [currently supported releases](https://fedoraproject.org/wiki/Releases#Current_Supported_Releases) of Fedora. Recommended version to use.
* `testing` - rebuild of 389-ds-base package from the *latest* of the [currently supported releases](https://fedoraproject.org/wiki/Releases#Current_Supported_Releases) of Fedora. A preview of the new features that will be in the next stable release.
* `next` - rebuild of 389-ds-base package from Fedora Rawhide, bleeding edge development version. **NOT RECOMMENDED** to be used in production, for testing purposes only.

`stable` and `testing` streams have 3 profiles:
* `default` - 389-ds-base and cockpit web ui
* `minimal` - just 389-ds-base
* `legacy` -  same as default plus legacy perl tools and scripts

`next` has only `default` and `minimal`.

```
yum install epel-release
# make sure you have the latest epel-release that contains modular repositories
yum update epel-release
yum module install 389-directory-server:stable/default
```

</details>

#### Upgrade an existing system:

Do a system upgrade as advised by your vendor. That's it!

### Windows Password Synchronization

This is an Active Directory "plug-in" that intercepts password changes made to AD Domain Controllers
and sends the clear text password over an encrypted connection (SSL/TLS) to 389 DS to keep the passwords
in sync. It works in conjunction with the Windows Sync feature of 389. You must install this on every
Writable Domain Controller. RODCs do not function the same way, so you should not install
this plugin on them.

Tested with Windows 2008 and 2012 Server 32-bit and 64-bit.

|Platform|File|SHA1SUM|SSLv3|>=TLSv1.1|
|--------|----|-------|-----|---------|
|Windows 2003/2008 32-bit|[389-PassSync-1.1.5-i386.msi]({{ site.binaries_url }}/binaries/389-PassSync-1.1.5-i386.msi)|4b79578e3d4bf9cdaada70e5c1212290a4e5ce3c|yes|no [*]|
|Windows 2003/2008 64-bit|[389-PassSync-1.1.5-x86\_64.msi]({{ site.binaries_url }}/binaries/389-PassSync-1.1.5-x86_64.msi)|ddac9705d305b14fa217af2f264d3529d3f3edb8|yes|no [*]|
|Windows 2003/2008/2012/2016 32-bit|[389-PassSync-1.1.7-i386.msi]({{ site.binaries_url }}/binaries/389-PassSync-1.1.7-i386.msi)|780e403335a74ea58dc097fb60fd481c8457e105|no [**]|yes|
|Windows 2003/2008/2012/2016 64-bit|[389-PassSync-1.1.7-x86\_64.msi]({{ site.binaries_url }}/binaries/389-PassSync-1.1.7-x86_64.msi)|0d598943ecdd17eeca2d66174de18d9885951699|no [**]|yes|

[*] 389-PassSync-1.1.5 has no support TLSv1.1 and newer.

[**] 389-PassSync-1.1.7 disables SSLv3 by default.

### Windows Console

NOTE: You must use 64-bit Java 7 with the 64-bit version.

Tested with Java 7 on Windows 2008/2012 Server.

|Platform|File|SHA1SUM|
|--------|----|-------|
|Windows 2008/2012 32-bit|[389-Console-1.1.18-i386.msi]({{ site.binaries_url }}/binaries/389-Console-1.1.18-i386.msi)|eff6e9c34300fa9bd2141944655925aaf5c0b431|
|Windows 2008/2012 64-bit|[389-Console-1.1.18-x86\_64.msi]({{ site.binaries_url }}/binaries/389-Console-1.1.18-x86_64.msi)|39357d69fd45df28657f1f2c73e23dbc552ecd31|

NOTE: You must have Java in your PATH in order for this to work. Or you can just edit the batch file to tell it where to find Java.


## Source Code Packages
-----------------------

Check out our [Build](development/building.html) page to find out how to build from source. The source packages are available [here](development/source.html).

## Scripts
----------

Checkout our scripts page [here](scripts.html)

## Schema
----------

Checkout our schema page [here](schema.html)

## Artwork and logos
--------------------

We maintain a the project logos and some other nice images. 


-   [Logo Small]({{ site.baseurl }}/images/logo389.png)
-   [Wallpaper 16:9 svg]({{ site.baseurl }}/images/389-logo-wallpaper-1080p.svg)

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />These <span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/StillImage" rel="dct:type">works</span> are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
