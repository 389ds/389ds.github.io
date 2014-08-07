---
title: "WebApps Install"
---

# Installing Directory Server Web Apps
--------------------------------------

{% include toc.md %}

Introduction
----------------

The three 389 web apps (Directory Server Gateway, Directory Express, and Org Chart) are installed separately from the Directory Server itself. After installing and configuring the Directory Server and Administration Server, then you can set up the web applications.

Supported Platforms for Directory Server Web Apps
-------------------------------------------------

The Directory Server web apps are supported on Fedora 7 and later.

Before Installing the Gateway
-----------------------------

There are two security issues when using the web apps: the bind credentials used for accessing the Directory Server Gateway and the user as which the Directory Server Gateway HTTP server process runs.

-   The web app configuration files can use a `binddnfile` parameter which gives the bind DN and bind password used to permit non-anonymous searching of the directory. The `binddnfile` should not be stored in the configuration directory (such as `/etc/dirsrv/dsgw`) or in any directory that can be accessed over HTTP.
-   Do not run any web applications on an Administration Server that is running as `root`. This may expose sensitive information about the configuration of the Directory Server.

Additionally, the Administration Server must be local to the web applications.

Installing the Directory Server
-------------------------------

Installing the Directory Server is described in the FDS [Install Guide](Install_Guide "wikilink"); the basic procedure is outlined here. Both the Directory Server and Administration Server must be set up before you can set up the web apps.

1.  Install the Directory Server packages.

    yum install 389-ds

2.  After the Directory Server packages are installed, run the `setup-ds-admin.pl` script to set up the default Directory Server instance and the Administration Server.

    /usr/sbin/setup-ds-admin.pl

Setting up the Web Apps
-----------------------

After the Directory Server is configured and a local Administration Server is available, then install and configure the web apps. The web apps packages include the Directory Server Gateway, Directory Express, and Org Chart.

1.  If not already installed, install the Directory Server Gateway package.

    yum install 389-dsgw

2.  Run the `setup-ds-dsgw` script to set up the default instances of the Directory Server Gateway, Directory Express, Org Chart, and Admin Express. The `setup-ds-dsgw` script is in the `/usr/sbin` directory.

    setup-ds-dsgw

This shell script will configure the Directory Server Gateway, Phonebook and Org Chart web applications to work with the Administration Server.

    Reading parameters from Administration Server config . . .   Using Administration Server URL http://ldap.example.com:9830...
    Reading parameters from Directory Server /etc/dirsrv/slapd-ldap . . .
    Using Directory Server URL ldap://ldap.example.com:389/dc=example, dc=com . . .
    Generating config file /etc/dirsrv/dsgw/dsgw.conf . . .
    Generating config file /etc/dirsrv/dsgw/pb.conf . . .
    Generating config file /etc/dirsrv/dsgw/orgchart.conf . . .
    Generating config file /etc/dirsrv/dsgw/default.conf . . .
    Generating the credential database directory . . .
    Adding configuration to httpd config file /etc/dirsrv/admin-serv/httpd.conf . . .
    Enabling links to web apps from Administration Server home page . . .

    The Directory Server Gateway web applications have been successfully configured.<br>You will need to restart your Administration Server.

3.  Restart the Administration Server. For example:

    service dirsrv-admin restart

Opening the Web Apps
--------------------

To open a menu of every web application, go to the Administration Server URL. For example:
    
    http://ldap.example.com:9380/

Then, select the web app from the list.
To access a specific gateway instance, use the Administration Server URL with the gateway instance directory. For example:

    http://ldap.example.com:9380/dsgwcmd/lang?context=example

Looking at Web App Configuration Files
--------------------------------------

The command `/usr/sbin/setup-ds-dsgw` configures the Directory Server Gateway and the other web apps to use the Administration Server. This script also writes all of the we app configuration files to `/etc/dirsrv/dsgw`. The setup script attempts to determine the appropriate Directory and Administration Servers to use from the files in `/etc/dirsrv/slapd-*` and `/etc/dirsrv/admin-serv`.
There are four main web app configuration files for the Directory Server Gateway, Directory Server Express, and Org Chart applications. (Admin Express uses the Admin Server configuration, not a separate configuration file.)

|**Web App**|**Configuration File**|**Purpose**|**More Info** |
|-----------|----------------------|-----------|--------------|
|Directory Server Gateway|dsgw.conf|Configuration file. You can edit this file if necessary. This file is derived from `/usr/share/dirsrv/dsgw/config/dsgw.tmpl` by `setup-ds-dsgw`.|["Configuring General Gateway Behavior (dsgw.conf)](dsgw.html#config-dsgw) |
|Directory Server Gateway|dsgw-httpd.conf|Contains the Apache config for the Directory Server Gateway CGI programs and scripts, the static HTML pages and templates, and the help files. `setup-ds-dsgw` makes the Admin Server's `httpd.conf` include this file. *You should not touch this file.*|
|Directory Server Express|pb.conf|Configuration file. You can edit this file if necessary. This file is derived from `/usr/share/dirsrv/dsgw/pbconfig/pb.tmpl` by `setup-ds-dsgw`.|["Directory Express Configuration File (pb.conf)](dsexpress.html#dsexpress-pbconf) |
|Org Chart|orgchart.conf|Configuration file. You can edit this file if necessary. This file is derived from `/usr/share/dirsrv/dsgw/orghtml/orgchart.tmpl` by `setup-ds-dsgw`.|["Changing Org Chart Behavior"](orgchart.html#chart-behavior) |

Creating Multiple Gateway Instances
-----------------------------------

There can be more than one Directory Server Gateway instance; multiple Directory Server Gateway instances can access the same directory data without conflicts or multiple instances can run on the same Administration Server and contact different Directory Server instances.
To access a specific gateway instance, use the Administration Server URL with the gateway instance directory. For example:
`<nowiki>http://ldap.example.com:9380/dsgwcmd/lang?context=example</nowiki>`
To create a new instance of the Directory Server Gateway, copy the configuration files for an existing instance (the `/usr/share/dirsrv/dsgw/html` and `/usr/share/dirsrv/dsgw/config` directories and `/etc/dirsrv/dsgw/dsgw.conf` file), and then edit a few parameters in the `/etc/dirsrv/dsgw/dsgw.conf` file to reflect the new locations:

1.  Copy and rename the `dsgw.conf` file.
2.  Set the `gwnametrans` parameter so that it provides a mapping reference to the new HTML directory. For example:
    `gwnametrans /example/`
3.  Set up the configuration file, such as setting the login timeout length, anonymous searching (`binddnfile`), and localization. Also, edit the Directory Server parameters if the new Gateway will access a different Directory Server instance.
4.  Copy an HTML directory, such as `/usr/share/dirsrv/dsgw/html`, for the new instance.
5.  Copy a configuration directory, such as `/usr/share/dirsrv/dsgw/config`, for the new instance.
6.  Edit the `htmldir` and `configdir` parameters in the new `.conf` to point to the new HTML and configuration directories.
    
        htmldir /usr/share/dirsrv/dsgw/example-html
        configdir /usr/share/dirsrv/dsgw/example-config

Restoring the Default Configuration
-----------------------------------

If the configuration is changed in a way that keeps the web apps from working, or if you just want to restore the default settings, it is possible to run the setup script again. By default, `setup-ds-dsgw` will not overwrite an existing installation. However, if you remove the configuration files (`dsgw.conf`, `pb.conf`, and `orgchart.conf` in `/etc/dirsrv/dsgw`), the the setup script will restore the defaults.
Alternatively, run the `setup-ds-dsgw` script again with the `-r` option, which overwrites the edited configuration files with the default settings. For example:

    setup-ds-dsgw -r

See Also
========

-   Back to the [overview](webapps-overview.html)
-   [ Directory Server Gateway](dsgw.html)
-   [ Directory Express](dsexpress.html)
-   [ Org Chart](orgchart.html)
-   [ Admin Express](adminexpress.html)
-   Help with [ basic HTML editing](htmlediting.html)
-   [DSML gateway](dsml.html)

