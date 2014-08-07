---
title: "Howto: LegacyWindowsConsole"
---

# Legacy Windows Console
----------------------

**NOTE: On December 14, 2007 FedoraConsole.msi was released.** This is a Windows Installer package containing the console for Fedora DS 1.1. It might work with Fedora DS 1.0.4 too. See [Release\_Notes](Release_Notes "wikilink") for more details. See [Download](Download "wikilink") to download the msi. You will still need to install Java 1.4 or 1.5 separately.

{% include toc.md %}

### How to get the Administration Console working on Windows

We have tested with and recommend IBM 1.4.2 JRE and Sun JRE 1.4.2\_05+. Sun JDK 1.5.x has been reported to work.

-   Make a c:\\fedora folder on the Windows box and copy /opt/fedora-ds/java and /opt/fedora-ds/lib from your Fedora Core or Red Hat box to the Windows box. Copy all files, directories, and sub-directories (e.g. cp -r).
-   Open /opt/fedora-ds/startconsole in a text editor and copy the line that launches the console at the end of the file.
-   Create a .bat file, such as "startconsole.bat",in the c:\\fedora\\java folder on the Windows box. Paste the line copied in the last step into the .bat file.
-   Edit the .bat file to:
    -   modify paths to specified files where necessary
    -   replace ':' in the -cp option with ';'
    -   replace the / in the paths with \\ (except for the admin server url)

You should end up with a .bat file that looks something like this:

    java  -ms8m -mx64m -cp jss3.jar;ldapjdk.jar;fedora-base-1.0.jar;
    fedora-mcc-1.0.jar;fedora-mcc-1.0_en.jar;fedora-nmclf-1.0.jar;
    fedora-nmclf-1.0_en.jar -Djava.library.path=..\lib\
    com.netscape.management.client.console.Console 

This assumes that the java executable is in the PATH and the .bat is run from the c:\\fedora\\java folder.

Linked files copied from a Linux machine might not work properly on a Windows machine. To fix this, replace any shortcut you find in the c:\\fedora\\java folder and subfolders with a renamed copy of the file the shortcut points to. For instance, replace fedora-mcc-1.0\_en.jar.lnk, which points to fedora-mcc-1.0.3\_en.jar, with a copy of fedora-mcc-1.0.3\_en.jar and rename it fedora-mcc-1.0\_en.jar.

The following shell script was submitted to the fedora-directory-users mailing list by Gary Tay to create the Windows BAT file based on startconsole -D output (this method seems to be outdated for fds 1.0.2 though):

    #!/bin/sh
    #
    # cr_startconsole_bat.sh
    #
    # input: startconsole.txt
    # output: startconsole.bat
    #
    sed -e 's/\/opt\/fedora-ds\/bin\/base\/jre\/bin\///' \
        -e 's/\/opt\/fedora-ds\/java/./g' \
        -e 's/\/opt\/fedora-ds\/lib/..\\lib/g' \
        -e 's/:/;/g' \
        -e 's/\//\\/g' \
        -e 's/http;\\\\/http:\/\//' \
        -e 's/https;\\\\/https:\/\//' \
        -e 's/ldap1.example.com;/ldap1.example.com:/' \
        startconsole.txt > startconsole.bat

To use this:

-   Copy the first line of output of 'startconsole -D' and put it into a file name startconsole.txt
-   Replace /opt/fedora-ds in the cr\_startconsole\_bat.sh script to match the path you have Directory Server installed in (could also be /opt/redhat-ds)
-   Replace ldap1.example.com with the fully-qualified hostname that is running the admin server.
-   Copy the output, startconsole.bat, to your Windows machine and put it into c:\\fedora\\java. It expects to run from that directory.

### Firewall Information

On Red Hat Enterprise Linux 4 or Fedora Core FDS Server, you may have to punch two holes in the FireWall (iptables) before the Windows FDS Console will work.

This can happen when SELINUX is set to "disabled" but SELINUXTYPE is set to "targeted" in /etc/sysconfig/selinux, not sure why?

    # cat /etc/sysconfig/selinux    
    SELINUX=disabled    
    SELINUXTYPE=targeted    

One hole for port 389 (ldap), the other for the admin server port (38900 in this example).

    # vi /etc/sysconfig/iptables    

Add two lines:

    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 389 -j ACCEPT
    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 38900 -j ACCEPT

Then restart the firewall:

    # service iptables restart    

### SSL

Copying over the jar files will get the Administration Console going, but SSL will not be functional. If you point it at an Administration Server listening with https you'll see an exception thrown like this one:

    Exception in thread "main" java.lang.UnsatisfiedLinkError: no jss3 in java.library.path    

The Administration Console is implemented with java but depends on three native components for SSL and certificate management. NSS is used in all areas of FDS for security, NSPR is a platform runtime dependency of NSS, and JSS is the bridge between the java code of the Administration Console and the native code of NSS.

Prebuilt packages of all three components can be downloaded. They can also be built from source following instructions on www.mozilla.org. There are several versions of each component to choose from. The following instructions were tested with versions used by the Administration Console in the past. The latest may also work.

-   Download the JSS 3.3 jar file from [this link](ftp://ftp.mozilla.org/pub/mozilla.org/security/jss/releases/JSS_3_3_RTM/jss33.jar) and save it as "jss3.jar" in c:\\fedora\\java (the path created in the first section of this howto). It will replace the existing jss3.jar. It's important to use matching versions of the jar and native library.
-   Download the JSS 3.3 native library from [this link](ftp://ftp.mozilla.org/pub/mozilla.org/security/jss/releases/JSS_3_3_RTM/WINNT4.0_OPT.OBJ/lib/jss3.dll) and save it in c:\\fedora\\lib\\jss or the location pointed to by the "java.library.path" option in your Administration Console launch script.
-   Download the NSPR 4.2.2 package from [this link](ftp://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.4.1/WINNT5.0_OPT.OBJ/nspr-4.4.1.zip). Extract the contents of the "lib" directory from this archive to c:\\fedora\\lib\\jss.
-   Download the NSS 3.7.3 package from [this link](ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_7_3_RTM/WINNT4.0_OPT.OBJ/nss-3.7.3.zip). Extract the contents of the "lib" directory from this archive to c:\\fedora\\lib\\jss. Optionally you can also extract the contents of the "bin" directory if you want access to command-line utilities such as certutil.
-   Add c:\\fedora\\lib\\jss to your path. The easiest way is to add a line like this to the Administration Console launch script created in the first section of this howto:

    set PATH=c:\fedora\lib\jss;%PATH%

By default, the console expects your key and cert database files in \$HOME/.mcc. On Windows, this is usually something like C:\\Documents and Settings\\<username>\\.mcc. So when you use the NSS command line utilities like certutil and pk12util, use the -d argument like

    pk12util -i servercert.pfx -d C:\Documents and Settings\<username>\.mcc

Now your FDS Administration Console running on Windows should be able to use https and ldaps.

