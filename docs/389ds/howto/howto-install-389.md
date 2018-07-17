---
title: "Howto: Install 389 Directory Server"
---

# Install Guide For 389 Directory Server
---------------

{% include toc.md %}

## Install the packages

- 389-ds-base                         
- 389-ds-base-libs
- 389-ds-base-snmp
- 389-ds-base-legacy-tools (deprecated perl scripts replaced by new python CLI tools)
- python3-lib389
- python3-389-ds-base-tests
- cockpit-389-ds (Cockpit UI plugin)

    dnf install 389-ds-base* cockpit-389-ds

## Upgrading

If you are upgrading to **389-ds-base-1.4.x** from **389-ds-base-1.3.x** or **389-ds-base-1.2.11**, you must first upgrade to **389-ds-base-1.3.7**.  Then you simply install the packages and restart the servers.  **389-ds-base-1.4.x** handles any upgrade steps needed during server startup, so there is no need to run an "upgrade" script.

For help upgrading to the latest version of **389-ds-base-1.3.x** see the old [Install\_Guide](../legacy/install-guide.html)

## Create an instance of Directory Server

The new python installer **dscreate** takes a configuration file (INF file) to load the instance configuration settings, or it can be run in an interactive mode using 

    dscreate interactive

The interactive mode only asks for basic configuration settings.  If you need to script the install, or you want to have fine-grained control over installation options then use the INF file installation mode.  Our INF file is very similiar to the silent install file used in previous versions of Directory Server, but the format has slightly changed.

The installation script can also create a template INF file for you.  Then you set the options for your particular set up.

    dscreate create-template   --> Write the template to STDOUT

    dscreate create-template /tmp/instance.inf   --> The script creates the actual file

Here is a snip of the template file

    ...
    ...
    # instance_name: The name of the instance. Cannot be changed post installation.
    # type: str
    instance_name = localhost

    # log_dir: The location where Directory Server will write log files. You should not need to alter this value.
    # type: str
    ; log_dir = /var/log/dirsrv/slapd-{instance_name}

    # port: The TCP port that Directory Server will listen on for LDAP connections.
    # type: int
    ; port = 389
    ...
    ...

Every setting has a default value.  To customize any of the settings remove the preceding semi-colon from the directive, and set the desired value.  Then you are ready to create your instance:

    dscreate fromfile /tmp/instance.inf

### INF File Examples

Here is an example of the bare minimum you need in the install file to create an instance.  If you you just want the defaults then this is all you need:

    [general]
    config_version = 2
    full_machine_name = SYSTEMS_FQDN

    [slapd]
    instance_name = localhost
    root_password = YOUR_PASSWORD_FOR_CN=DIRECTORY_MANAGER


Here's another example with other customizations as well as creating two backends (see \[backend-*YOUR_BACKEND_NAME*\]).  You also have the option to create a self signed certificate database as part of the installation (the default is True).

    [general]
    config_version = 2
    full_machine_name = localhost.localdomain

    [slapd]
    instance_name = localhost
    root_dn = cn=manager
    root_password = YOUR_PASSWORD_FOR_CN=MANAGER
    port = 3890
    secure_port = 636
    self_sign_cert = True

    [backend-userroot]
    suffix = dc=example,dc=com
    sample_entries = yes
    require_index = yes

    [backend-ipaca]
    suffix = o=ipaca


## Removing an instance

For completeness here is how you remove an instance:

    dsctl <YOUR INSTANCE NAME> remove --doit

    dsctl localhost remove --doit


## Installing Cockpit UI Plugin

To start using the new UI you just need to enable the cockpit service:

Open up firewall for port 9090 (if necessary)

    # firewall-cmd --add-port=9090/tcp
    # firewall-cmd --permanent --add-port=9090/tcp

Enable Cockpit

    # systemctl enable cockpit.socket
    # systemctl start cockpit.socket

The UI is using LDAPI for authentication to the Directory Server.  So logging into Cockpit as root is the same as logging in as "cn=Directory Manager".  This also means that if you are upgrading to 389-ds-base-1.4.0, you must enable the LDAPI socket in the Directory Server before you can start using the UI.  For more information please see:

<https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/administration_guide/ldapi-enabling>

Here is an example

    # ldapmodify -D "cn=directory manager" -W
    dn: cn=config
    changetype: modify
    replace: nsslapd-ldapilisten
    nsslapd-ldapilisten: on
    -
    replace: nsslapd-ldapifilepath
    nsslapd-ldapifilepath: /var/run/slapd-localhost.socket
    -
    replace: nsslapd-ldapiautobind
    nsslapd-ldapiautobind: on
    -
    replace: nsslapd-ldapimaprootdn
    nsslapd-ldapimaprootdn: cn=Directory Manager
    
    <press enter twice to send this modification operation>

    # restart-dirsrv

**The Cockpit UI is not fully functional yet and it just in a DEMO mode for now.  We are actively working on finishing it asap as it will be replacing the old Java Console (389-console) in Fedora 28 and up.**

