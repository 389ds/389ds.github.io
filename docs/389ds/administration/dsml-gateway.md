---
title: "DSML Gateway"
---

# DSML Gateway
--------------

{% include toc.md %}

Introduction
-----

DSML v2.0 is a Web Services protocol that closely mirrors LDAP. DSMLv2 is designed to allow arbitrary Web Services clients to access Directory Services using the client's native protocols (SOAP over HTTP). DSMLv2 allows content stored in a Directory Service to be easily accessed by standard off-the-shelf Web Service applications and development tools, removing the need for application developers to use and understand one of the LDAP SDK libraries.

The DSML Gateway (DSMLGW) is a Java based Axis service which runs in a servlet container like Tomcat. This allows DSMLv2 clients to access your directory server data.

Links
-----

-   [Design](dsml-gateway-design.html)
-   [Building](dsml-gateway-building.html)
-   [License - GPLv2 with GNU Classpathx exception](dsml-gateway-license.html)

Setup
-----

### Requirements

-   Java 1.5 or later
-   Tomcat 5.5 or later, or another comparable servlet/web application container

### Already have Axis running?

If you just have the dsmlgw.jar file, you will need to deploy this into your existing Axis. The file deploy-dsmlgw.wsdd is provided in the source distribution.

### Have Tomcat but not Axis?

If you have the dsmlgw.war file, you can deploy this as a web application in a compliant servlet container (like Tomcat).

### Have Tomcat but nothing else?

If you have the full .tar.gz distribution, use these steps, as root:

-   cd /
-   gunzip -c /path/to/dsmlgw.tar.gz | tar xf -

Then, depending on your packaging format, /path/to/sbin may be /usr/sbin or /opt/dirsrv/sbin or \$prefix/sbin:

-   /path/to/sbin/setup-ds-dsmlgw

NOTE: In order for setup-ds-dsmlgw and the other scripts to work, you must have specified tomcat.home and tomcat.cmd correctly when building - see [Building DSMLGW](dsml-gateway-building.html)

This will create the file /etc/dirsrv/dsmlgw/dsmlgw.cfg, based on your existing Fedora Directory Server configuration on the machine. This will also create a CATALINA_HOME like directory layout under share/dirsrv/dsmlgw. The read-only directories will be symlinks to their real locations under your tomcat home (e.g. share/dirsrv/dsmlgw/common -\> /tomcat/home/common). The logs and other writable directories will be symlinked to the appropriate location based on your packaging.

You can edit /etc/dirsrv/dsmlgw/dsmlgw.cfg and /etc/dirsrv/dsmlgw/dsmlgw.env to suit your environment. The start and stop scripts (below) use /etc/dirsrv/dsmlgw/dsmlgw.env for their runtime environment.

Scripts
-------

These scripts are provided with the full package distribution (i.e. not jar or war only):

-   sbin/setup-ds-dsmlgw - sets up the Tomcat app environment and the DSMLGW configuration
-   sbin/start-ds-dsmlgw - start up tomcat + axis + dsmlgw service
-   sbin/stop-ds-dsmlgw - shutdown
-   sbin/restart-ds-dsmlgw - restart
-   bin/dsmlgw-search - a very simple script to use to test DSMLv2 searches via the DSMLGW
-   bin/dsml2ldif - converts DSMLv1 data files to LDIF format
-   bin/ldif2dsml - converts LDIF files to DSMLv1 data files

DSML Samples
------------

Sample DSML data files are provided with the full package distribution in the share/dirsrv/dsmlgw/data directory.

Debugging
---------

In the full package distribution, the log files are written to the directory share/dirsrv/dsmlgw/webapps/logs which will be symlinked to your "real" log file directory.

For Axis debugging, edit the file share/dirsrv/dsmlgw/webapps/axis/WEB-INF/log4j.properties. This uses standard Log4j properties. The file axis.log will contain Axis specific log messages.

For DSMLGW debugging, edit the file share/dirsrv/dsmlgw/webapps/axis/WEB-INF/logging.properties. The log file name is dsmlgw.<date>.log.

