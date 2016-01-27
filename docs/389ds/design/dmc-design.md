---
title: "Directory Management Configuration Suffix Design (o=dmc)"
---

# Directory Management Configuration Suffix Design (o=dmc)
---------------------------------

{% include toc.md %}

## Introduction

As part of the design for a new Web-based Directory Server Console/UI, a new suffix will be replacing what was "**o=netscaperoot**".  The original design of "*o=netscaperoot*" was not flexible, was installation host specific, and could not be replicated.  A new configuration suffix is needed that can exist and be used on any server on the network.  This suffix will contain information on every "registered" Directory Server instance.  It also contains all the configuration settings found in the new UI.  This allows for the UI to easily be updated as configuration attributes are added/removed.  This removes the need to build a new UI package as configurations change.  A simple LDAP modify operation is all that is needed to keep the server configuration forms up-to date.

------------------------------

## DMC Schema

The new "o=dmc" suffix requires new schema attributes/objectclasses.  This new schema will make finding particular types of hosts and configurations easy.

### Attributes

    dmcConfigSuffixTemplate - Directory String
    dmcConfigInstanceTemplate - Directory String
    dmcConfigReplicaTemplate - Directory String
    dmcConfigReplAgmtTemplate - Directory String
    dmcConfigPluginTemplate - Directory String
    dmcConfigVersion - Integer syntax
    dmcConfigAttr - Directory String - <attribute>:<value/default>
    dmcConfigIndex - Directory String - <attr>:<index types>:<matching rules>:<idlscanlimit>
    dmcInstanceType - Directory String - <data|config>
    dmcHost - Directory String
    dmcPort - Integer syntax
    dmcSecurePort - Integer syntax
    dmcConnProtocol - Directory String - LDAP/LDAPS/TLS/LDAPI?
    dmcAuthMethod - Directory String-  SIMPLE,GSSAPI,SSL(client cert),DIGEST-MD5?
    dmcUserLDAPUrl - Directory String - LDAP URL
    dmcAdminServerURL - Directory String - Admin Server HTTP Address
    dmcSSLVersionMin - Directory String 
    dmcSSLVersionMax - Directory String 

### Objectclasses

    dmcConfig:      MAY (cn $ description $ dmcConfigAllowedAttrs $ dmcConfigAttr $ dmcConfigIndex $ dmcConfigVersion)
    dmcInstance:    MAY (cn $ description $ dmcConfigSuffixTemplate $ dmcConfigInstanceTemplate $ dmcConfigReplicaTemplate $ dmcConfigReplAgmtTemplate $ dmcConfigPluginTemplate $ dmcHost $ dmcPort $ dmcSecurePort $ dmcConnProtocol $ dmcAuthMethod $ dmcAdminServerURL $ dmcInstanceType $ dmcSSLVersionMin $ dmcSSLVersionMax)
    dmcAdminServer: MAY (cn $ description $ dmcUserLDAPUrl $ dmcAdminServerURL $ dmcHost $ dmcPort $ dmcSSLVersionMin $ dmcSSLVersionMax)

----------------------

## ou=Administration,o=dmc

This container holds the admin account and admin group.  This is part of the delegated admin feature

### cn=Administrators,ou=Administration,o=dmc

This container holds locals administration users and groups

- **uid=admin,cn=Administrators,ou=Administration,o=dmc**

This is a local account in o=dmc that can be used to log into DMC(UI)

- **cn=Administrators Group,cn=Administrators,ou=Administration,o=dmc**

This group uniquemembers can/might exist in other suffixes like "*dc=example,dc=com*"

    dn: cn=Administrators Group,cn=Administrators,ou=Administration,o=dmc
    objectclass: top
    objectclass: groupofuniquenames
    cn: Administrators Group
    uniquemember: uid=mreynolds,dc=example,dc=com
    uniquemember: uid=wbrown,dc=redhat,dc=com
    uniquemember: uid=admin,cn=Administrators,ou=Administration,o=dmc

<br>

### cn=Administration Servers,ou=Administration,o=dmc

This container holds all the registered HTTP Admin Servers(REST servers).  Each local Admin Sever have a **dmc-adm.conf** file.  The Admin server uses directives in **dmc-adm.conf** so it knows where to send its authentication requests.

    dmc-adm.conf
    ------------

    port: 9830
    security: on
    SecurityDir: /etc/dirsrv/slapd-inst1/
    SSLVersionMin: TLS1.1
    SSLVersionMax: TLS1.2
    AuthMethods: SIMPLE, kerberos, ....
    AuthProtocol:  LDAP, STARTTLS (no LDAPS)
    LocalConfgServer: cn=hostB.example.com,cn=Administration Servers,ou=Administration,o=dmc


The Admin Server configuration entry just contains attributes for the host name, port, and the authentication ldap URL from which it uses for authentication.  These values can be used to configure the Pass Through Authentication.  You can also specify failover/alternate ldap urls if needed.

    dn: cn=hostB.example.com,cn=Administration Servers,ou=Administration,o=dmc
    description: HTTP Admin Server
    objectClass: top
    objectClass: dmcAdminServer
    cn: hostB.example.com
    dmcHost: hostB.example.com
    dmcPort: 9830
    dmcConnProtocol: SSL
    dmsAuthMethod: SIMPLE
    dmcSSLVersionMin: TLS1.1
    dmcSSLVersionMax: TLS1.2
    dmcAdminServerURL: https://hostB.example.com:9830
    dmcUserLDAPUrl: ldap://hostB.example.com:389/dc=example,dc=com ldap://hostB.example.com:389/dc=redhat,dc=com


----------------------------

## ou=Configuration,o=dmc

This contains the configuration information needed by the Admin & Config Server including the UI.

### cn=Configuration Attributes,ou=Configuration,o=dmc

The following entries are used by the UI for configuration forms for various areas of the server.  This allows the UI to be easily updated as new configuration attributes are added or removed.  When setting a "dmcConfigAttr" you have the option to specify a default value, the value after the colon, that the UI may or may not use in a form.

    dmcConfigAttr: <attr>:<default value>

Here are 5 configuration sections:

    dn: cn=Instance,cn=Configuration Attributes,ou=Configuration,o=dmc
    cn: instance
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsslapd-syntaxcheck:on
    dmcConfigAttr: nsslapd-dn-validate-strict:off
    ...
    ...

    dn: cn=Database,cn=Configuration Attribute,ou=Configuration,o=dmc
    cn: database
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsslapd-lookthroughlimit:5000
    dmcConfigAttr: nsslapd-mode:600
    ...
    ...

    dn: cn=Suffix,cn=Configuration Attribute,ou=Configuration,o=dmc
    cn: suffix
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsslapd-state:backend
    dmcConfigAttr: nsslapd-backend:
    ...
    ...

    dn: cn=Replication,cn=Configuration Attribute,ou=Configuration,o=dmc
    cn: replication
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsslapd-changelogmaxage: 7d
    dmcConfigAttr: nsds5ReplicaProtocolTimeout: 60
    ...
    ...

    dn: cn=Agreements,cn=Replication,cn=Configuration Attribute,ou=Configuration,o=dmc
    cn: Agreements
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsds5ReplicaEnabled: on
    dmcConfigAttr: nsds5ReplicaStripAttrs:
    ...
    ...

Plugins are handled individually under the "plugins" entry

    dn: cn=plugins,cn=Configuration Attributes,ou=Configuration,o=dmc

    dn: cn=MemberOf Plugin,cn=plugins,cn=Configuration Attributes,ou=Configuration,o=dmc
    cn: MemberOf Plugin
    objectclass: top
    objectclass: dmcConfig
    dmcConfigAttr: nsslapd-pluginPath:libmemberof-plugin
    dmcConfigAttr: nsslapd-pluginInitfunc:memberof_postop_init
    dmcConfigAttr: nsslapd-pluginType:betxnpostoperation
    dmcConfigAttr: nsslapd-pluginEnabled:off
    ...
    ...

<br>

### Synchronized Configurations

Synchronized configurations is a feature that allows all subscribed instances to use the same settings that are defined in a template.  Update a an attribute in a template and it is applied on all the servers that subscribe to that template.

The Directory Server's configuration is divided up into several sections.  Each section has its own unique configuration attributes that can be set which are already defined under "*cn=Configuration Attributes,ou=Configuration,o=dmc*".  You can then create as many templates as you want for any configuration section, but each "*instance*" can only use one template per configuration section.

**Configuration Sections**

- Suffix Configurations
- Instance Configurations (general server settings)
- Replication Configurations
- Replication Agreement Configurations
- Plugin Configurations

<br>

#### ou=Suffix Sync Configurations,ou=Configuration,o=dmc

Here is a detailed description of **dmcConfigIndex**.  Each index quality is separated by a colon.

    dmcConfigIndex: < Attribute > : < Index types > : < matching rule > : <id scan limit>

    dmcConfigIndex: objectclass:eq,pres:caseIgnoreIA5Match:limit=0 type=eq flags=AND values=posixAccount

Here are two examples of "Suffix" templates.  One for the main user suffix, and one for the configuration server's o=dmc suffix/backend.

    dn: cn=suffix template,ou=Suffix Sync Configurations,ou=Configuration,o=dmc
    description: template for example.com
    objectClass: top
    objectClass: dmcConfig
    cn: suffix template
    dmcConfigAttr: nsslapd-cachesize:10000000
    dmcConfigIndex: uid:eq,pres,sub::limit=0 type=eq flags=AND values=inetOrgPerson
    dmcConfigIndex: entryusn:eq:integerOrderingMatch:
    dmcConfigVersion: 1

    dn: cn=config server template,ou=Suffix Sync Configurations,ou=Configuration,o=dmc
    description: template for the Configuration Server
    objectClass: top
    objectClass: dmcConfig
    cn: config server template
    dmcConfigAttr: nsslapd-cachesize:100000
    dmcConfigIndex: cn:eq,pres,sub::
    dmcConfigIndex: dmcConfigAttr:eq,pres,sub::limit=-1
    dmcConfigIndex: ou:eq,pres,sub::
    dmcConfigVersion: 1

<br>

#### cn=Instance Sync Configurations,ou=Configuration,o=dmc

Instance config attributes are mostly what is found in the top entry cn=config, but it also includes the ldbm backend settings.  ldbm backend settings are applied to all backends/suffixes, hence that makes it an instance configuration attribute set, as opposed to a "suffix" configuration set.


    dn: cn=instance template,ou=Instance Sync Configurations,ou=Configuration,o=dmc
    description: Config for instances under example.com
    objectClass: top
    objectClass: dmcConfig
    cn: instance template
    dmcConfigAttr: nsslapd-sizelimit:1000
    dmcConfigAttr: nsslapd-dynamic-plugins:on
    dmcConfigAttr: nsslapd-schemacheck:on
    dmcConfigAttr: nsslapd-dbcachesize:10000000

    dn: cn=config server template,ou=Instance Sync Configurations,ou=Configuration,o=dmc
    description: template for Configuration Directory Servers
    objectClass: top
    objectClass: dmcConfig
    cn: config server template
    dmcConfigAttr: nsslapd-sizelimit:1000

<br>

#### cn=Replication Sync Configurations,ou=Configuration,o=dmc

    dn: cn=replica template,ou=Replication Sync Configurations,ou=Configuration,o=dmc
    description: Configuration for all the masters for example.com
    objectClass: top
    objectClass: dmcConfig
    cn: replica template
    dmcConfigAttr: nsslapd-changelogmaxage:7d

    dn: cn=config server template,ou=Replication Sync Configurations,ou=Configuration,o=dmc
    description: template for example.com
    objectClass: top
    objectClass: dmcConfig
    cn: config server template
    dmcConfigAttr: nsslapd-changelogmaxentries:10000
    dmcConfigAttr: nsslapd-changelogmaxage:14d

<br>

#### cn=Replication Agreement Sync Configurations,ou=Configuration,o=dmc

    dn: cn=agreement template1,cn=Replication Agreement Sync Configurations,ou=Configuration,o=dmc
    cn: agreement template1
    objectClass: top
    objectClass: dmcConfig
    dmcConfigAttr: nsds5ReplicaEnabled:on
    dmcConfigAttr: nsds5ReplicaProtocolTimeout:60

<br>

#### cn=Plugin Sync Configurations,ou=Configuration,o=dmc

This is just a container for individual plugins.  Instance entries can specify many plugins(see further below)

    dn: cn=MemberOf Plugin,cn=plugins,cn=Plugin Sync Configurations,ou=Configuration,o=dmc
    description: A template entry for the MemberOf plugin
    cn: MemberOf Plugin
    objectclass: top
    objectclass: dmcConfig
    dmcConfigAttr: nsslapd-pluginPath:libmemberof-plugin
    dmcConfigAttr: nsslapd-pluginInitfunc:memberof_postop_init
    dmcConfigAttr: nsslapd-pluginType:betxnpostoperation
    dmcConfigAttr: nsslapd-pluginEnabled:on
    dmcConfigAttr: memberofgroupattr:member
    dmcConfigAttr: memberofattr:memberOf

    dn: cn=Root DN Access Control,cn=plugins,cn=Plugin Sync Configurations,ou=Configuration,o=dmc
    ...
    ...

-------------------------

## ou=Domains,o=dmc

This is a container for all the registered domains on the network.  Each "domain" will have its own set of hosts and slapd instances for that domain.

### ou=example.com,ou=Domains,o=dmc

All the hosts for a particular domain are listed under this entry

#### cn=HOST_NAME,ou=example.com,ou=Domains,o=dmc

Here is an example of host that has two instances of Directory Server.

    dn: cn=hostA.example.com,ou=example.com,ou=Domains,o=dmc
    objectClass: top
    objectClass: nsContainer
    cn: hostA.example.com

<br>

#### cn=slapd-INSTANCE,cn=HOST_NAME,ou=example.com,ou=Domains,o=dmc

Below are two instances on the same host.  One is the entry/user instance(slapd-hostA), and the other is the Configuration Directory Server(slapd-DMC_CONFIG) that is home to **o=dmc**.  Points of interest:

- We can now see the configuration templates in use.  By just the existence of one of these attributes(dmcConfigSuffixTemplate, dmcConfigInstanceTemplate, dmcConfigReplicaTemplate, and dmcConfigPluginTemplate), subscribes this instances to the global configuration synchronize service(aka **Paintbrush**).  Each "template" attribute consists of the "configuration version" followed by the DN of the configuration template DN.
- **dmcInstanceType** - This is either "*data*" for the user database, or "*config*" for the instance being a "Configuration Directory Server" (which is home to o=dmc)
- Authentication/connection preferences are also provided.  This can be used by the admin server/UI when sending REST requests.

Here is the example:

    dn: cn=slapd-hostA,cn=hostA.example.com,ou=example.com,ou=Domains,o=dmc
    objectClass: top
    objectClass: dmcInstance
    cn: slapd-hostA
    dmcConfigSuffixTemplate: 1:cn=suffix template,ou=Suffix Configurations,ou=Configuration,o=dmc
    dmcConfigInstanceTemplate: 1:cn=instance template,ou=Instance Configurations,ou=Configuration,o=dmc
    dmcConfigReplicaTemplate: 1:cn=replica template,ou=Replication Configurations,ou=Configuration,o=dmc
    dmcConfigReplAgmtTemplate: 1:cn=agreement template1,cn=Replication Agreement Sync Configurations,ou=Configuration,o=dmc
    dmcConfigPluginTemplate: 1:cn=MemberOf Plugin,ou=Plugin Configurations,ou=Configuration,o=dmc
    dmcConfigPluginTemplate: 1:cn=Root DN Access Control Plugin,ou=Plugin Configurations,ou=Configuration,o=dmc
    dmcHost: hostA.example.com
    dmcPort: 389
    dmsSecurePort: 636
    dmcConnProtocol: TLS
    dmsAuthMethod: SIMPLE
    dmcAdminServerURL: https://hostA.example.com:9830
    dmcSSLVersionMin: TLS1.1
    dmcSSLVersionMax: TLS1.2
    dmcInstanceType: data

    dn: cn=slapd-DMC_CONFIG,cn=hostA.example.com,ou=example.com,ou=Domains,o=dmc
    objectClass: top
    objectClass: dmcInstance
    cn: slapd-DMC_CONFIG
    dmcConfigSuffixTemplate: 1:cn=config server template,ou=Suffix Configurations,ou=Configuration,o=dmc
    dmcConfigInstanceTemplate: 1:cn=config server template,ou=Instance Configurations,ou=Configuration,o=dmc
    dmcConfigReplicaTemplate: 1:cn=config server template,ou=Replication Configurations,ou=Configuration,o=dmc
    dmcHost: hostA.example.com
    dmcPort: 3890
    dmsSecurePort: 6360
    dmcConnProtocol: TLS
    dmsAuthMethod: SIMPLE
    dmcAdminServerURL: https://hostA.example.com:9830
    dmcSSLVersionMin: TLS1.1
    dmcSSLVersionMax: TLS1.2
    dmcInstanceType: config

<br>

### ou=redhat.com,ou=Domains,o=dmc
  
    *EXAMPLE - other domains can be registered in o=dmc*

