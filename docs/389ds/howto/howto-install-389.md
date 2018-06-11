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

The new python installer **dscreate** takes a configuration file (INF file) to load the isntance confiruation settings.  This INF file is very similiar to the silent install file used in previous versions of Directory Server, but the format has changed.

The setup can can create a template INF file for you and then you must set the options for your set up.

    dscreate example > /tmp/instance.inf

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

    dscreate --fromfile /tmp/instance.inf

For completeness here is how you remove an instance:

    dsctl <YOUR INSTANCE NAME> remove --doit

    dsctl localhost remove --doit




