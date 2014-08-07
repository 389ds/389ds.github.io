---
title: "Howto: WindowsConsole"
---

# Windows Console
---------------

389 Directory Server provides a console package for use on Windows. See [Download](../download.html) for the current installable package.

{% include toc.md %}

### Building

Prerequisites:

-   Microsoft Visual C++ and corresponding Windows SDK - the Express Edition or the Full Edition
-   MozillaBuild - an msys based build environment - <https://developer.mozilla.org/En/Developer_Guide/Build_Instructions/Windows_Prerequisites#MozillaBuild>
-   Windows Installer XML (WiX) toolset - <http://wix.sourceforge.net/>
-   NSPR DLL libraries
-   NSS DLL libraries, and the certutil and pk12util commands
-   JSS DLL and JAR
-   LDAPJDK JAR
-   idm-console-framework JAR files
-   389-console JAR file
-   Optional - The Windows Support Tools package for your platform
    -   The build will use the bitsadmin program from this package to download packages if available
-   The nmake command - usually provided with the Visual Studio or Visual C++ or Windows SDK packages

Source: [Source](../development/source.html)

Build: The build uses a regular CMD shell - no cygwin, msys, etc. are required, but NOTE: the unzip.vbs unzipper is currently broken, so the build by default will use unzip.exe from MozillaBuild info-zip - you can provide another unzip.exe tool if desired

-   open a CMD window
-   cd to the directory containing the source, then to the "win" subdirectory
-   set CPU=amd64 \# for 64-bit builds
-   nmake help - will give you some basic instructions as well as information about how to specify the local path to NSPR, NSS, etc. if the download fails
-   nmake download - will attempt to download the prerequisites listed above using bitsadmin from the Support Tools package - it tries to use c:\\program files\\support tools\\bitsadmin
-   nmake layout - will create the layout used for packaging
-   nmake all - will create the 389 Console.msi package

The 389 Console.msi and other files built by nmake will be found in the build.PLATFORM directory. The PLATFORM will usually be something like WINNT5.X\_OPT.OBJ for 32-bit or WINNT5.X\_64\_OPT.OBJ for 64-bit.

### Firewall Information

You may have to punch two or three holes in the FireWall (iptables) before the Windows Console will work.

This can happen when SELINUX is set to "disabled" but SELINUXTYPE is set to "targeted" in /etc/sysconfig/selinux, not sure why?

    # cat /etc/sysconfig/selinux    
    SELINUX=disabled    
    SELINUXTYPE=targeted    

One hole for port 389 (ldap), one hole for port 636 (ldaps - only if using TLS/SSL with the console -see below), and the other for the admin server port (9830 by default).

    # vi /etc/sysconfig/iptables    

Add two lines:

    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 389 -j ACCEPT    
    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 636 -j ACCEPT    
    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 9830 -j ACCEPT    

Then restart the firewall:

    # service iptables restart    

### TLS/SSL

By default, the console expects your key and cert database files in \$HOME/.389-console. On Windows, this is usually something like C:\\Documents and Settings\\<username>\\.389-console. So when you use the NSS command line utilities like certutil and pk12util, use the -d argument like this:

    certutil -A -d "C:\Documents and Settings\<username>\.389-console" -n "CA Certificate" -t CT,, -i cacert.asc -a    

for example, to add the CA cert from the file cacert.asc encoded in ASCII (PEM) format. Now your Console running on Windows should be able to use https and ldaps.

