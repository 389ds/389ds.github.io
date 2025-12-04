---
title: "Install Guide"
---

# Install Guide
---------------

{% include toc.md %}

Get the packages
------------------------

Ok - just go to [Download](../download.html)

Deployment/Installation Guide
-----------------------------

-   [Deployment Guide](https://access.redhat.com/sites/default/files/attachments/red_hat_directory_server-9.0-deployment_guide-en-us_0.pdf) - planning your new directory server deployment
-   [Installation Guide](https://access.redhat.com/sites/default/files/attachments/red_hat_directory_server-9.0-installation_guide-en-us_0.pdf) - step-by-step instructions for installation, upgrade, and migration

The manual is for Red Hat Directory Server, and some of the information is different for 389. The differences are described below.

Installation Prerequisites
--------------------------

### Java is required for the console

389 no longer bundles its own web server and java runtime, so the following are required

1.  Apache 2, worker model. This binary is generally available on RHEL and Fedora platforms as /usr/sbin/httpd.worker. It is provided via the httpd package (e.g. up2date httpd or yum install httpd). HP provides a free depot format download which includes the correct version of Apache. For other operating systems, you might have to build it yourself, if there is no pre-built Apache 2.x which uses the worker (multi-threaded) model. Especially for Solaris - the binary available from sunfreeware.com is not the worker model. 
2.  Java runtime. A JRE is required in order to use the Console. On Fedora, the IcedTea Java should work just fine. This package is called **java-1.7.0-icedtea** or **java-1.6.0-openjdk**- you should be able to yum install java-1.7.0-icedtea (or java-1.6.0-openjdk) on Fedora. On other platforms, either the Sun or the IBM JRE version 1.6.0 or later is required.

The console uses the java from your PATH. Use **java -version** to see what version of java you are using. If you see something that says *gcj* or *GCJ* you're using the wrong version. If you use **389-console -D 9** it will also tell you what version of java you're using.

-   Enterprise Linux (Red Hat, CentOS, and derivatives of those) - You can use any Java 1.6 - OpenJDK should now be available
    -   **yum install java-1.6.0-openjdk** should work - if not, see below
    -   Enable the channel from the RHN -\> Channels -\> Red Hat Supplementary Server 5 -\> Subscribe
    -   **yum install java-1.6.0-ibm** or download the rpm from the channel and do **rpm -Uvh java-1.6.0-ibm**

If you want the hassle of using a non-OS provided Java, you can go to the IBM or Sun websites and download a pre-built binary package for your operating system, or find an OpenJDK pre-built binary, or built it yourself.

NOTE: You need to use JRE version 1.6 for 389 versions 1.2.0 and later

If you want to install the Sun java command in /usr/bin/java, please follow the directions found here - <http://fedoranews.org/mediawiki/index.php/JPackage_Java_for_FC4> NOTE: The instructions do not work for Java 6 on Fedora Core 6.

We know it's annoying to have to do all the click throughs, licenses, registration, etc. when downloading from a vendor website. Now that OpenJDK is available, this will all hopefully be easier.

NOTE: If you are installing Java from a pre-built binary from Sun or IBM, note that Java requires the package 'xorg-x11-deprecated-libs'. You will need to either

    yum install xorg-x11-deprecated-libs    

on Fedora Core or

    up2date xorg-x11-deprecated-libs    

on RHEL.

NOTE: Some Java versions have a problem with window order/focus. This means that when you run 389-console, you will see only the splash screen and not the login dialog. If this occurs, please use

    389-console -x nologo ... other args ...    

to skip the splash screen and go straight to the login dialog.

### Admin Server Issues

Please read [manage Admin Server](../howto/howto-adminserverldapmgmt.html)  to diagnose any firewall or DNS issues with running the Admin Server. It is a good idea to review this before installation to avoid any problems which might be caused by firewalls or DNS configuration.

Installation via yum
--------------------

389 1.1 and later are split into discrete packages with inter-dependencies. The best and easiest way to install these packages is with yum. Fedora packages are available with yum.

Enterprise Linux packages are available from EPEL - see [Download](../download.html) for more information

### Upgrading

If you already have installed 389 DS 1.1 or later, just use

    yum upgrade [--enablerepo=repo] ...    

to upgrade your installation. See [Download](../download.html) for information about repos. NOTE that this will also upgrade OS packages. See *man yum* to see how to include/exclude packages/repos from the update. NOTE that you must use **upgrade** *not update* in order for the 389 packages to obsolete and replace the fedora ds packages.

If you want to install the testing packages:

    yum upgrade [--enablerepo=testingrepo] ... [package to update] ....    

See [Download](../download.html) for information about repos. After the upgrade is complete, use

    setup-ds-admin.pl -u    

to update your installation. **You must use setup-ds-admin.pl -u in order to refresh your admin server and console information.**

### New Install

-   Fedora/EPEL

        yum install [--enablerepo=repo] 389-ds    

    See [Download](../download.html) for information about repos. If you want to install the testing packages:

        yum install 389-ds [--enablerepo=testingrepo] ...    

    See [Download](../download.html) for information about repos. After install is complete, run

        setup-ds-admin.pl    

-   Run /usr/sbin/setup-ds-admin.pl to set up the new directory server and admin server
-   Fedora DS 1.0.x users can use /usr/sbin/migrate-ds-admin.pl to migrate existing directory and admin server data

NOTE: If you are upgrading from 1.0, DO NOT USE setup-ds-admin.pl - use migrate-ds-admin.pl instead

-   Console - the console command is /usr/bin/389-console - startconsole and fedora-idm-console have been removed

### Installation of just base DS

Just install the 389-ds-base package.

    yum install 389-ds-base    

Use setup-ds.pl to create an instance of directory server, or use migrate-ds.pl to migrate existing data.

Removing Packages
-----------------

### Removing the directory server instances

First, remove any directory server instances and un-register them from the console. **Make sure you back up your data first**

    ls /etc/dirsrv    

This will list your directory server instances. The directory will begin with *slapd-*. A path whose name ends with *.removed* has already been removed. Then, for each instance, run

    ds_removal -s slapd-INSTANCENAME -w admin_password    

where slapd-INSTANCENAME is the name of the sub-directory under /etc/dirsrv, and *admin\_password* is the password you use with the console.

If you are not using the console, you can use

    remove-ds.pl -i slapd-INSTANCENAME    

to remove instances.

Using ds\_removal or remove-ds.pl will remove all of the instance specific files and paths except for the slapd-INSTANCENAME directory, which is just renamed to slapd-INSTANCENAME.removed. If you don't want to keep any of your configuration or key/cert data, you can erase this directory.

If you are using the console/admin server, and the machine is the one hosting the configuration directory server (i.e. this is the first machine you ran setup-ds-admin.pl on), and you just want to wipe out everything and start over, use *remove-ds-admin.pl*

    remove-ds-admin.pl [-y] [-f]    

You must specify -y in order to actually do anything. Use -f to force removal.

### Removing the packages

    yum erase 389-ds-base-libs 389-adminutil idm-console-framework    

yum will remove all packages that depend on these packages as well. 389-ds-base-libs is for 389-ds-base and -devel - 389-adminutil will pick up 389-admin and 389-dsgw - idm-console-framework will pick up the console packages.

### Extra cleanup

After removing all of the packages, you can do something like this to make sure your system is back to a clean state:

    rm -rf /etc/dirsrv /usr/lib*/dirsrv /var/*/dirsrv /etc/sysconfig/dirsrv*    

Installation via RPM
--------------------

**NOTE: This only applies to Fedora DS 1.0.4 or earlier**. This installation method is not supported for Fedora DS 1.1 and later on those platforms that use yum.

Download the file fedora-ds-1.0.4-1.PLATFORM.ARCH.opt.rpm from the [Download](../download.html) site, where PLATFORM is one of RHEL3, RHEL4, FC4, FC5, or FC6 (use RHEL4 for FC3, and RHEL3 for FC2), and ARCH is either i386 or x86\_64. You can install it with the browser (it may prompt you to install it when you click on the link) or with the rpm command like this:

    rpm -Uvh fedora-ds-1.0.4-1.PLATFORM.ARCH.opt.rpm    

After the installation, you must run setup to configure or upgrade your servers. To run setup, open a command window and do the following:

    cd /opt/fedora-ds ; ./setup/setup    

This will give you several prompts. [Here](oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of dc=example,dc=com during setup. This will allow you to load the example database files which demonstrate the basic functions of the server as well as more advanced features such as Roles, Virtual Views, and i18n handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called /opt/fedora-ds/setup/install.inf. You can edit this file and use it to perform a silent install using

    ./setup/setup -s -f /path/to/myinstall.inf    

Note: if you are using password syntax checking, you must disable it to avoid a Constraint Violation error running setup after upgrading:

    ldapmodify -x -D "cn=directory manager" -w password    
    dn: cn=config    
    changetype: modify    
    replace: passwordCheckSyntax    
    passwordCheckSyntax: off    

Then, run setup as follows:

    cd /opt/fedora-ds ; ./setup/setup    

Then, if you are using password syntax checking, enable it again:

    ldapmodify -x -D "cn=directory manager" -w password    
    dn: cn=config    
    changetype: modify    
    replace: passwordCheckSyntax    
    passwordCheckSyntax: on    

### Upgrading from the 7.1 release

**NOTE:** The migrate-ds-admin.pl script in Fedora DS 1.1 and later will migrate everything including the console information. So the steps outlined below should only be used if you are using Fedora DS 1.0.4.

Upgrading from 7.1 to 1.x will break the console. After doing an upgrade installation (see above), you must do the following steps in order to use the console:

    cd /opt/fedora-ds/slapd-yourhost    
    ./db2ldif -U -s o=netscaperoot -a /tmp/nsroot.ldif    

The -U argument is important because you need to disable LDIF line wrapping for parsing purposes. Then, edit /tmp/nsroot. You will need to make the following replacements:

-   replace ou=4.0 with ou=1.0
-   replace ds71.jar with ds10.jar
-   replace admserv70.jar with admserv10.jar

For example, the following sed command:

    sed -e s/ou=4.0/ou=1.0/g -e s/ds71\\.jar/ds10.jar/g -e s/admserv71\\.jar/admserv10.jar/g /tmp/nsroot.ldif > /tmp/nsrootfixed.ldif    

Then, re-import the ldif file - use ldif2db.pl for on-line import:

    cd /opt/fedora-ds/slapd-yourhost    
    ./ldif2db.pl -D "cn=directory manager" -w password -s o=netscaperoot -i /tmp/nsrootfixed.ldif    

Installation from a developer build
-----------------------------------

If you built using the BUILD\_RPM=1 flag (see [Building](../development/building.html)), you will create the Fedora DS RPM. This gives you the same RPM that is described above. For example, if you used the dsbuild/One Step Build method using

    make BUILD_RPM=1    

you will have the following RPM:

    dsbuild/ds/ldapserver/work/fedora-ds-1.0.3-1.RHEL4.i386.opt.rpm    

This is for RHEL4 x86 32bit. Depending on your platform, you may have Linux instead of RHEL or RHEL3 or RHEL4. But the packages should end in .opt.rpm at any rate. You can install directly from the location:

    rpm -ivh dsbuild/ds/ldapserver/work/fedora-ds-1.0.3-1.RHEL4.i386.opt.rpm    

Then run setup as follows:

    cd /opt/fedora-ds ; ./setup/setup    

[Here](oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of dc=example,dc=com during setup. This will allow you to load the example database files which demonstrate the basic functions of the server as well as more advanced features such as Roles, Virtual Views, and i18n handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called /opt/fedora-ds/setup/install.inf. You can edit this file and use it to perform a silent install using

    ./setup/setup -s -f /path/to/myinstall.inf    

Installation via setuputil
--------------------------

There is no "make install" per se. The Directory Server build and packaging process puts the files in a directory at the same level as the ldapserver build directory. That is, if you have ldap/ldapserver, the build process will put the installable files in ldap/MM.DD/PLATFORMDIR where MM.DD are the two digit month and day, respectively, and the PLATFORMDIR represents the OS platform. On RHEL4, this looks like the following:

     RHEL4_x86_gcc3_DBG.OBJ    

For Fedora Core 4, and other Linux platforms, this will look something like this:

     Linux2.6_x86_gcc4_DBG.OBJ    

So the whole thing would be something like

     ldap/11.15/RHEL4_x86_gcc3_DBG.OBJ    

You can override this naming convention by specifying the INSTDIR=/full/path definition on the make command line.

In the package directory, either the MM.DD/PLATFORMDIR or overridden with INSTDIR, there will be an executable called "setup". Just run the program as "./setup" and follow the prompts to install and set up the directory server. For example:

    cd ldap/12.08/RHEL4_x86_gcc3_DBG.OBJ ; ./setup    

[Here](oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of dc=example,dc=com during setup. This will allow you to load the example database files which demonstrate the basic functions of the server as well as more advanced features such as Roles, Virtual Views, and i18n handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called setup/install.inf in your server root directory. You can edit this file and use it to perform a silent install using

    ./setup -s -f /path/to/myinstall.inf    

Verifying the Installation
--------------------------

To test the basic operation of the server, use the ldapsearch command:

    /usr/bin/ldapsearch -x [-h <your host>] [-p <your port>] -s base -b "" "objectclass=*"    

If you do not have /usr/bin/ldapsearch, try /usr/lib/mozldap/ldapsearch or /usr/lib64/mozldap/ldapsearch - as above, but omit the -x argument:

    /usr/lib/mozldap/ldapsearch [-h <your host>] [-p <your port>] -s base -b "" "objectclass=*"    

If you are using Fedora DS 1.0.4 or earlier, ldapsearch is bundled with the server in the release directory under shared/bin.

    cd /opt/fedora-ds/shared/bin    
    ./ldapsearch [-p <your port>] -s base -b "" "objectclass=*"    

(The -p <your port> may be omitted if you are using the standard LDAP port 389). This should produce the contents of the root DSE entry, which lists server vendor, version, supported extensions, controls, and naming contexts.

You can also use the console. You must first set your JAVA\_HOME environment variable so that the console can find the java runtime e.g.

    export JAVA_HOME=/opt/j2sdk_1_4_2_07    

or wherever you have installed your jdk. You must also make sure the java command you want to run is in your PATH:

    export PATH=/opt/j2sdk_1_4_2_07/bin:$PATH    

Then

    /usr/bin/389-console    

If you are running Fedora DS 1.0.4 or earlier, do the following instead:

     cd /opt/fedora-ds ; ./startconsole    

For the admin username and password, provide the values that you specified during setup. For the admin server url, if the field is blank, just use [http://localhost:adminserverport/](http://localhost:adminserverport/) where adminserverport is the port number you specified (default 9830) for the admin server during setup. If you forget what your admin server port number is, do this:

    grep \^Listen /etc/dirsrv/admin-serv/console.conf    

or on Fedora DS 1.0.4 and earlier:

    grep \^Listen /opt/fedora-ds/admin-serv/config/console.conf    

If you used a suffix of dc=example,dc=com, you can load one of the example database files. Follow the [directions here](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Populating_Directory_Databases.html) for importing from the console or the command line. Here are the files you can use:

-   Example.ldif - a simple database to use to test basic server functionality
-   Example-roles.ldif - illustrates how Roles work and how to use them
-   Example-views.ldif - illustrates how Virtual Views work and how to use them
-   European.ldif - shows how the server handles 8bit character sets

Installing just the core directory server
-----------------------------------------

An instance is one complete set of configuration files and databases for the Directory Server. It is possible to run multiple instances from one set of binaries.

Instance creation involves creating a base directory (a file system directory, not a directory server) that lives under the release directory, called "slapd-name" where name is usually the hostname, but it can be whatever is desired. By default, all of the server specific scripts, configuration files, and database data are placed in this directory.

Instance creation is performed using the perl script     ds_newinst.pl    . The input to this script is a .inf file, the format of which is described below. This file lets you set the FQDN, the port to listen on, the default suffix, the directory manager DN and password, and the userid of the server process, as well as several other optional settings.

    ds_newinst.pl /full/path/to/install.inf    

You can find an example .inf file in /usr/share/doc/fedora-ds-<version> (currently 1.1.0). You should make a copy of this file in another directory and edit it to suit your taste.

The script uses the information in the .inf file to create the initial configuration files, copy in several other configuration files, create many server administration scripts (e.g. ldif2db, db2ldif, etc.), create the initial database, and create the default suffix, and start up the server. See below for more information about the .inf file format.

Once this is done, the script should output a "Success" message if all went well. See [FHS_Packaging](../development/fhs-packaging.html) for more information about where the instance specific files are created by ds\_newinst.pl.

### inf File Format for core directory server installation

A sample .inf file is listed below

    [General]    
    FullMachineName=   myhost.mydomain.tld    
    SuiteSpotUserID=   nobody    
    ServerRoot=        /usr/lib/fedora-ds    
    [slapd]    
    ServerPort=        389    
    ServerIdentifier=  myhost    
    Suffix=   dc=myhost,dc=mydomain,dc=tld    
    RootDN=   cn=Directory Manager    
    RootDNPwd=   password    

The [General] and [slapd] sections are there for historical reasons and are required.

|Name|Required?|Description|Example|
|----|---------|-----------|-------|
|SuiteSpotUserID|required|the Unix user that the Directory Server will run as|nobody (possibly ldap)|
|FullMachineName|required|the fully qualified host and domain name|oak.devel.example.com|
|ServerRoot|required|the base directory where the runtime files are installed|/usr/lib/fedora-ds|
|ConfigDirectoryAdminID|optional|user ID for console login|admin|
|ConfigDirectoryAdminPwd|optional|password for ConfigDirectoryAdminID|password|
|ConfigDirectoryLdapURL|optional|LDAP URL for the Configuration Directory
the suffix is required and will usually be o=NetscapeRoot|[ldap://host.domain.tld:port/o=NetscapeRoot](ldap://host.domain.tld:port/o=NetscapeRoot)|
|AdminDomain|optional|the administrative domain this instance will belong to|devel.example.com|
|UserDirectoryLdapURL|optional|the user/group directory used by the Console|[ldap://host.domain.tld:port/dc=devel,dc=example,dc=com](ldap://host.domain.tld:port/dc=devel,dc=example,dc=com)|

|Name|Required?|Description|Example|
|----|---------|-----------|-------|
|ServerPort|required|the port number the server will listen to|389|
|ServerIdentifier|required|the base name of the directory that contains the instance
of this server - will have "slapd-" added to it|oak|
|Suffix|required|the primary suffix for this server (more can be added later)|dc=devel,dc=example,dc=com|
|RootDN|required|the DN for the Directory Administrator|cn=Directory Manager|
|RootDNPwd|required|the password for the RootDN|itsasecret|
|InstallLdifFile|optional|use this LDIF file to initialize the database
the suffix must be specified in the Suffix directive|/full/path/to/Example.ldif|
|SlapdConfigForMC|optional|if true (1), configure this new DS instance as a
Configuration Directory Server|1|
|UseExistingMC|optional|if true (1), register this DS with the Configuration DS|1|
|UseExistingUG|optional|if true (1), do not configure this DS as a user/group directory
but use the one specified by UserDirectoryLdapURL|1|


