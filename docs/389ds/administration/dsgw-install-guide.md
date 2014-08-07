---
title: "DSGW Install Guide"
---

# Install Guide for Directory Server Gateway (DSGW), Phonebook, and Org Chart
-----------------------------------------------------------------------------

Installation
------------

The package fedora-ds-admin is required. You should have already installed fedora-ds-admin and fedora-ds-base.

    yum install fedora-ds-dsgw

Setup
-----

The command /usr/sbin/setup-ds-dsgw is used to configure the DSGW and the other web apps for use in the Administration Server. This writes config files to /etc/dirsrv/dsgw. The setup script attempts to determine the appropriate directory server and administration servers to use from the files in /etc/dirsrv/slapd-\* and /etc/dirsrv/admin-serv. You must have already run setup-ds-admin.pl to configure your directory and administration servers. There are 4 main config files:

-   dsgw-httpd.conf - This file contains the Apache config for the DSGW CGI programs and scripts, the static HTML pages and templates, and the help files. setup-ds-dsgw will make the admin server httpd.conf include this file. You should not touch this file.
-   dsgw.conf - The config file for the DSGW (Directory Server Gateway) web application. You can edit this file if necessary. This file is derived from /usr/share/dirsrv/dsgw/config/dsgw.tmpl by setup-ds-dsgw.
-   pb.conf - The config file for the Phonebook (pb) web application. You can edit this file if necessary. This file is derived from /usr/share/dirsrv/dsgw/pbconfig/pb.tmpl by setup-ds-dsgw.
-   orgchart.conf - The config file for the Org Chart web application. You can edit this file if necessary. This file is derived from /usr/share/dirsrv/dsgw/orghtml/orgchart.tmpl by setup-ds-dsgw.

By default, setup-ds-dsgw will not overwrite an existing installation. If you want to re-run setup-ds-dsgw, you must either remove the files dsgw.conf, pb.conf, and orgchart.conf in /etc/dirsrv/dsgw, or use setup-ds-dsgw -r.

The setup script will also enable the use of these web applications from the main Admin Server HTML home page.
