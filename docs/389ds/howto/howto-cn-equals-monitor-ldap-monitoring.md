---
title: "Howto:CN=Monitor LDAP Monitoring"
---

# CN=Monitor LDAP Monitoring
----------------------------

{% include toc.md %}

### Quick guide how to install and configure CN=Monitor, performance/LDAP monitoring application for 389 DS.

This guide also covers the installation of necessary web packages. Applicable for the following Linux distributions:

-   Fedora
-   Red Hat Enterprise Linux / CentOs 5.3 or above

Installation
------------

### Download RPM file and documentation

<http://cnmonitor.sourceforge.net/>

### Install dependencies

    yum install openldap-clients
    yum install httpd mod_ssl openssl
    yum install php php-cli php-ldap php-gd

#### Install CN=Monitor 

Replace <version> with downloaded version number.

    # yum install cnmonitor-<version>.noarch.rpm    

Restart Apache HTTPd Web server

    # service httpd restart    

### Install SQL Database

Collect historical monitor events. Optional but recommended. Install and configure either MySQL or PostegreSQL.

**MySQL**

    yum install mysql-server php-mysql
    service mysqld start

Install schema

    mysql -u root -p < /usr/share/cnmonitor/sql/mysql.sql

In this example we are usig root as user for MySQL.

Don't forget to restart httpd

    service httpd restart    

**PostgreSQL**

    yum install postgresql-server php-pqsql     
    service postgresql initdb     
    service postgresql start    

Install schema

    # psql -U postgres -f /usr/share/cnmonitor/sql/postgresql.sql    

In this example we are using postgres as user for PostreSQL.

Don't forget to restart httpd

    service httpd restart

Configuration
-------------

The following example will configure one environment with two servers using MySQL as database for collected performance counters.

Edit the configuration file /etc/cnmonitor/cnmonitor.xml.

    <?xml version="1.0" encoding="UTF-8"?>
    <cnmonitor>
      <general>
        <language>en</language>
        <database>
          <username>root</username>
          <password></password>
          <host>localhost</host>
          <database>cnmonitor</database>
          <type>mysql</type>
        </database>
        <environment>
        </environment>
      </general>
      <environment>
        <name>389 DS Environment</name>
        <server>
          <name>server1.example.com</name>
        </server>
        <server>
          <name>server2.example.com</name>
        </server>
      </environment>
    </cnmonitor>

### Setup Monitoring

Finally setup monitoring scripts.

The following example will collect:

-   Performance statistics every 30 minutes.
-   Check server status / messages every 10 minutes.
-   Summarize statistics for monthly / yearly trends at 4 AM.

        # crontab -e    
        */30 * * * * cd /usr/share/cnmonitor/bin;php collectdb.php    
        */10 * * * * cd /usr/share/cnmonitor/bin;php collectservermessage.php    
        0 4 * * * cd /usr/share/cnmonitor/bin;php collectsummary.php    

### Replication and Cache Monitoring

In order to access the backend database cn=config to view replication and cache status you need to add a monitoring user. In this example we are placing the user at *ou=people,dc=example,dc=com*.

Add a monitoring user:

    dn: uid=monitor.cnmonitor,ou=people,dc=example,dc=com
    uid: monitor.cnmonitor
    givenName: monitor
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetorgperson
    sn: cnmonitor
    cn: monitor cnmonitor
    userPassword: secret

Add the following Access Control Instruction (ACI) with read access to cn=config for the added monitoring user on all 389 servers. Add the following ACI to cn=config:

    aci: (targetattr = "*")(target = "ldap:///cn=config")(version 3.0;acl "CN=Monitor";
    allow (read,compare,search)(userdn = "ldap:///uid=monitor.cnmonitor,ou=people,dc=example,dc=com");)

Now configure CN=Monitor to use this monitoring user.

As CN=Monitor will communicate over non encrypted LDAP sessions you may want to change the configuration later on to use TLS or LDAPS.

    <?xml version="1.0" encoding="UTF-8"?>
    <cnmonitor>
     <general>
       <language>en</language>
       <database>
         <username>root</username>
         <password></password>
         <host>localhost</host>
         <database>cnmonitor</database>
         <type>mysql</type>
       </database>
       <environment>
         <dn>uid=monitor.cnmonitor,ou=people,dc=example,dc=com</dn>
         <password>secret</password>
       </environment>
     </general>
     <environment>
       <name>389 DS Environment</name>
       <server>
         <name>server1.example.com</name>
       </server>
       <server>
         <name>server2.example.com</name>
       </server>
     </environment>
    </cnmonitor>

### Load Balancer / Cluster

If you are using a load balancer or cluster address. Add the option *<loadbalancer>* in the environment section.

     <environment>
       <name>389 DS Environment</name>
       <loadbalancer>cluster.example.com</loadbalancer>
       <server>
         <name>server1.example.com</name>
       </server>
       <server>
         <name>server2.example.com</name>
       </server>
     </environment>

### Multi Master Environment

Shows a recommended configuration for an environment with two masters and two consumer replicas.

     <environment>
       <name>389 DS Masters</name>
       <loadbalancer>clustermaster.example.com</loadbalancer>
       <server>
         <name>servermaster1.example.com</name>
       </server>
       <server>
         <name>servermaster2.example.com</name>
       </server>
     </environment>
     <environment>
       <name>389 DS Consumers</name>
       <loadbalancer>clusterconsumers.example.com</loadbalancer>
       <server>
         <name>serverconsumer1.example.com</name>
       </server>
       <server>
         <name>serverconsumer2.example.com</name>
       </server>
     </environment>

