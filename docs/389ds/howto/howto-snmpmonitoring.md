---
title: "Howto: SNMPMonitoring"
---

# SNMP Monitoring of FDS
----------------------

{% include toc.md %}

### Introduction

Monitoring a FDS server with SNMP is relatively simple. FDS uses the Agent Extensibility Protocol (AgentX) to extend SNMP. In essence a FDS SNMP Agent collects the data from FDS and passes the information to net-snmp.

FDS is already configured to use SNMP out of the box, the install provides a copy of the FDS mib and the RHDS documentation covers the installation well enough to get you started (even if it is a little light on details).

Here's a quick run down of the steps involved...

-   Ensure you have a working version of net-snmp running on your FDS box.
-   Edit your snmpd.conf file (on Fedora its `/etc/snmp/snmpd.conf`) and add master agentx to activate agentx support in your instance of net-snmp.

        ###### Added for AgentX Access - Allows FDS to pass SNMP to net-snmp ######
        master agentx

-   FDS is ready configured to use SNMP. This can be disabled if required, but...
-   Create and configure a FDS Agent config file (`/opt/fedora-ds/ldap-agent.conf`)

        # Config file for AgentX access so FDS can pass snmp variables to net-snmp
        # This is the agent config file.
        #
        # Start the agent with /opt/fedora-ds/bin/slapd/server/ldap-agent /opt/fedora-ds/ldap-agent.conf
        #
        #
        ## AgentX Master ##
        #
        # Where the agent communicates with the AgentX Master (net-snmp).
        # If not specified uses the net-snmp default of a UNIX socket
        # at /var/agentx/master. RTFM if you decide to use a differing location...
        #
        ## AgentX Logdir ##
        #
        # Where the agent logs its logfile...
        #
        agent-logdir /opt/fedora-ds/ldap-agent
        #
        ## Server ##
        #
        # Which FDS instance you wish to monitor.
        # This should be the absolute path to the log dir of the FDS instance.
        #
        server /opt/fedora-ds/slapd-fds/

-   Start the FDS agent (if you wish to view extra debugging use -D. eg `.../ldap-agent -D ..../ldap-agent.conf`

        [username@fds ~]# /opt/fedora-ds/bin/slapd/server/ldap-agent /opt/fedora-ds/ldap-agent.conf`

-   Test it is working by doing a quick snmpwalk over the FDS OIDs.

        [username@fds ~]# snmpwalk -v 1 -c `<community>` `<host>` `<oid>

To find out the simple auth binds, use the OID of .1.3.6.1.4.1.2312.6.1.1.3.389 (dsSimpleAuthBinds)

    [root@prospero ~]# snmpwalk -v 1 -c xxxxxxxx localhost .1.3.6.1.4.1.2312.6.1.1.3.389`
    RHDS-MIB::dsSimpleAuthBinds.389 = Counter32: 405210`

That's it :)

Please note that I use FDS v1.0.2 at the moment. Versions \>=1.0.3 now use the native net-snmp that comes with your distro, rather than its own. I have no idea how or if this will affect the steps above. YMMV.

Integrating with Cacti
----------------------

[Cacti](http://www.cacti.net) is a deceptively complex yet simple to use web based monitoring application. It uses rrdtool, php and mysql to create some actually pretty decent graphs and stats of all manner of devices that can be monitored. Naturally it can do SNMP. Cacti works by setting up a series of data access, graph and host templates that bind together and produces a clean easy to use **pack**. It works well, however template creation is in that **deceptively complex** category. Fortunately I stumbled across a couple of templates for OpenLDAP that I hacked about with to get the desired effect. The original versions and locations are at the bottom of this page.
For brevity I have also included my ready FDS-friendly version of the template and the accompanying perl script, tarred-up below.

-   Download, and untar the file `fds_cacti_template.tar.gz` below to your FDS box.
-   Copy the perl script to the scripts dir of your Cacti installation (usually `/var/www/html/cacti/scripts/`
-   Import the xml file into Cacti using the **Import Templates** function of Cacti
-   Create hosts and graphs as normal.

### Download Cacti Template

[Click Here To Download the README file](http://directory.fedora.redhat.com/download/README.snmp-cacti)

[Click Here To Download the Cacti Template](http://directory.fedora.redhat.com/download/cacti_host_template_fedora_directory_server.xml)

[Click Here To Download the perl script helper for the Cacti Template](http://directory.fedora.redhat.com/download/openldap_response_time.pl)

Acknowledgments
----------------

My template is heavily borrowed from the following sources.

Cacti OpenLDAP response time - Linagora.org - <http://www.linagora.org/article125.html>

Templates for SunONE Directory Server - <http://forums.cacti.net/about16638.html>

Thats it. Hope its of use to someone :)

[Dan](User:Danhawker "wikilink")

