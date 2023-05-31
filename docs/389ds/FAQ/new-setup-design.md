---
title: "New Setup Design"
---

# New Setup Design
-------------------

Introduction
------------

[SetupUtil](setuputil.html) was originally created to:

-   Install files on the target machine using packages in zip format
-   Manage files and directories to allow upgrades, patches, and uninstallation
-   Do server set up
    -   Run a pre-install phase consisting of a curses based UI to ask the user a series of questions
    -   Allow the user via .inf files to specify additional pre-install curses based programs
    -   Run a post-install phase that actually set up the servers, including server specific ones specified in .inf files
-   Register servers with the configuration directory server, to allow them to be managed via the console and admin server
    -   create/manage the product and server instance specific entries under the o=NetscapeRoot tree

Some of this work was done by directory server instance creation. The code in the old cfg\_sspt.c and configure\_instance.cpp was a mix of directory server specific code and code needed by setuputil to create the initial o=NetscapeRoot tree and database.

Setuputil also provides a (woefully incomplete) C++ wrapper class around the LDAP C SDK which somewhat simplifies LDAP interactions. It also provides native charset \<-\> UTF8 conversion.

Plan
----

Remove setuputil. Replace its existing functionality.

-   File installation and management are now provided by the operating system package manager (RPM, PKG, DPKG, etc.).
-   Replace C++ curses UI with a command line perl interface
-   Use perl I18N::Langinfo and Encode modules for native charset <-> UTF8 conversion
-   Use perl-Mozilla-LDAP for LDAP functionality
-   Almost all of the o=NetscapeRoot entry creation can be done with LDIF templates with key values replaced at set up time by perl scripts

DS base package
---------------

Add perl modules for setup. These modules will handle the command line interactive UI phase. This will allow us to have an interactive UI for setting up base directory server instances, and act as a wrapper around ds\_newinst.

-   $libdir/fedora-ds/perl - this directory will contain the perl modules. There will have to be an additional autoconf token - @perldir@ - and scripts which use these modules will need to have `use lib @perldir@` at the top so that all of the modules are found.
-   $bindir/setup-ds.pl - perl script that is used to interactively create an instance of a base directory server
-   $propertydir/setup-ds.res - Resource file for setup-ds.pl text and dialog (used with the Resource.pm module)

DS admin package
----------------

The DS admin package will extend the base perl modules to add support for configuration DS instance creation and configuration, for registering instances with the config DS, and for admin server configuration.

### o=NetscapeRoot entry creation ###

This section shows how to make this happen: "Almost all of the o=NetscapeRoot entry creation can be done with LDIF templates with key values replaced at set up time by perl scripts."

Perl script `register_server.pl` processes the tasks. The script uses the Setup Inf module as well as PerLDAP.

        Usage: $bindir/register_server.pl [ -Fv ] [ -h `<host>` ] [ -p `<port>` ] [ -D `<rootdn>` ]`
                                  -w `<rootdnpw>` [ -d `<default_infdir>` ]`
                                  -i `<inffile(s)>` ... -m `<mapfile>` `<ldiffile>` ...`
        Description: Store server info stored in the ldiffiles to the Configuration`
                     Directory Server replacing the macros with the defined values`
                     in the map file.`
        -H: help (print this message)`
        -v: verbose`
        -F: Fresh registration; i.e., removing the existing server info.`
        -h `<host>`: configuration server host (localhost, by default)`
        -p `<port>`: configuration server port (389)`
        -D `<rootdn>`: configuration server's rootdn ("cn=Directory Manager")`
        -w `<rootdnpw>`: configuration server's rootdn password`
        -d `<default_infdir>`: the directory where static .inf files are located ("$infdir")`
        -i `<inffile(s)>`: dynamic .inf file(s)`
        -m `<mapfile>`: map file name`
        <ldiffile>` ...: ldif files or template ldif files to be stored in the Configuration Directory Server`

map file: `$infdir/register_param.map` needs to be specified, which defines the key - value pairs replaced at the run time. This file is a .in file in the adminserver source tree. The @...@ parameters are processed at the build time.

        This file is used by the register_server.pl script to register the server
        info to the Configuration Directory Server.  The server info is stored in
        the (template) ldif files located in @ldifdir@. In case a server entry has
        %...% format parameters, this map table is used to resolve it and replace
        the parameter with the value defined in this file.
        [Parameter resolution rules]
        * If the right-hand value is in ` (backquote), the value is eval'ed by perl. 
          The output should be stored in $returnvalue to pass to the internal hash.
        * If the right-hand value is in " (doublequote), the value is passed as is.
        * If the right-hand value is not in any quote, the value should be found
          in either of the setup inf file (static) or the install inf file (dynamic).
        * Variables surrounded by @ (e.g., /export/servers/ds72/etc/fedora-ds/admin-serv) are replaced with the
          system path at the compile time.
        * The right-hand value can contain variables surrounded by % (e.g., %asid%)
          which refers the right-hand value (key) of this map file.

ldif template files: `$ldifdir/[0-9][0-9]filename.ldif.tmpl`
The ldif tmpl files contain ldif formatted entries including %...% style parameters. All the parameters must be defined in the map file. sample entry in a ldif tmpl file:

        dn: ou=%domain%, o=NetscapeRoot
        objectClass: top
        objectClass: organizationalUnit
        objectClass: nsadmindomain
        ou: %domain%
        description: Standard branch for configuration information
        nsAdminDomainName: %domain%

In addition, two kinds of .inf files are needed to fill in the parameters.
static .inf files: installed at \$infdir in the adminserver installation
dynamic .inf file(s): temporary file created by the Setup module dynamically; one file per Directory Server

Sample usages:

        Clean Configuration Directory Server; register one server
        register_server.pl -m infdir/register_param.map -w rootdnpasswd -i /dir/for/dynamic/inf/setup###0.inf ldifdir/*.ldif.tmpl


        Register 2 more servers' info to the Configuration Directory Server
        register_server.pl -m infdir/register_param.map -w rootdnpasswd -i "/dir/for/dynamic/inf/setup###1.inf \
        /dir/for/dynamic/inf/setup###2.inf" ldifdir/*.ldif.tmpl

        Register 3 servers' info to the Configuration Directory Server overriding the existing o=netscaperoot if any
        register_server.pl -F -m infdir/register_param.map -w rootdnpasswd -i "/dir/for/dynamic/inf/setup###0.inf \
        /dir/for/dynamic/inf/setup###1.inf /dir/for/dynamic/inf/setup###2.inf" ldifdir/*.ldif.tmpl


