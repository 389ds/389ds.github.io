---
title: "WinSync Posix Plugin"
---

# WinSync Posix Plugin
----------------------

The 389 team would like to thank *Carsten Grzemba* for contributing his POSIX Windows Sync plugin to the project.

NOTE: as of now, the Posix Winsync plugin does not work for new entries added to 389. That is, if you add a new user or group entry to 389, the plugin will **not** sync the POSIX attributes. This was due to a limitation in the Winsync Plugin API v1. The API now supports it - see [Windows\_Sync\_Plugin\_API](windows-sync-plugin-api.html) for API functions. We are planning to fix this limitation in the next major release of 389 - see [\#428 posix winsync should support ADD user/group entries from DS to AD](https://pagure.io/389-ds-base/issue/428) for more information.

{% include toc.md %}

Overview
--------

The Posix Winsync plugin will sync POSIX user (objectclass posixAccount) and group (objectclass posixGroup) attributes between 389 and Active Directory. Both the older MS SFU schema and the newer (2003 R2 and later) built-in AD POSIX schema are supported.

For user entries, the following attributes will be synchronized with the corresponding AD attribute: uidNumber, gidNumber, gecos, loginShell, homeDirectory. NOTE: the plugin will **not** try to populate missing attributes. Notably, the plugin will not attempt to derive a value for the gecos field if it is absent. In order to sync these attributes, they **must** be present with valid values. Other attributes such as uid, cn, etc. are already handled by winsync.

For group entries, the gidNumber and memberUid attributes will be synchronized. Many implementations of nss\_ldap no longer require the use of the memberUid field and can instead use member or uniqueMember. If you require memberUid, and this attribute is not present in AD, the plugin can populate the memberUid attribute values in 389 based on the member attribute in AD. See below for the description of the **posixWinsyncMapMemberUID** attribute. The plugin can also update the memberOf attribute by firing off a task to update the group relationships after the group sync is complete. See **posixWinsyncCreateMemberOfTask** below.

Configuration
-------------

To sync a user or group from 389 to AD, AD needs the **nisdomain** attribute. This attribute is defined in the RFC 2307 bis schema, but not the older one. If you want to use **nisdomain** you will have to either use 10rfc2307bis.ldif instead of 10rfc2307.ldif,

    rm /etc/dirsrv/slapd-INSTNAME/schema/10rfc2307.ldif    
    cp /usr/share/dirsrv/data/10rfc2307bis.ldif /etc/dirsrv/slapd-INSTNAME/schema    

or you will need to define the attribute & objectclass like this:

    cat >> /etc/dirsrv/slapd-INSTNAME/schema/99user.ldif <<EOF    
    attributeTypes: (    
     1.3.6.1.1.1.1.30 NAME 'nisDomain'    
     DESC 'NIS domain'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     )    
    objectClasses: (    
     1.3.6.1.1.1.2.15 NAME 'nisDomainObject' SUP top AUXILIARY    
     DESC 'Associates a NIS domain with a naming context'    
     MUST nisDomain    
     )    
    EOF    

That is, copy the definitions from 10rfc2307bis.ldif and add them to your user defined schema.

The **nisdomain** attribute can stored in the 389 subtree entry or any parent entry of the 389 subtree entry. For example, if you have

    dn: cn=name of sync agreement,cn=replica,cn="your suffix",cn=mapping tree,cn=config    
    objectclass: nsDSWindowsReplicationAgreement    
    nsds7DirectoryReplicaSubtree: ou=People,dc=example,dc=com    
    ...    

you can store the nisDomain in ou=People,dc=example,dc=com or dc=example,dc=com, e.g.:

    dn: dc=example,dc=com    
    nisDomain: example    
    objectClass: top    
    objectClass: domain    
    objectClass: nisdomainobject    
    dc: example    

The nisdomainobject objectclass is an AUXILIARY objectclass so you can add it to any existing entry like this;

    ldapmodify ..... <<EOF    
     dn: dc=example,dc=com    
     changetype: modify    
     add: objectclass    
     objectclass: nisdomainobject    
     -    
     add: nisDomain    
     nisDomain: example    
    EOF    

The DN of the posix winsync plugin is **cn=Posix Winsync API,cn=plugins,cn=config**. The attributes you can set are:

-   posixWinsyncMsSFUSchema - this is FALSE by default. Set this to TRUE if AD only supports the MS SFU POSIX schema but not the newer posixAccount/posixGroup schema (probably 2003 before R2 and earlier)
-   posixWinsyncMapMemberUID - this is TRUE by default. This will attempt to populate the memberUid attribute in 389 if it is missing from AD, based on the member attribute. Set this to FALSE if you don't care about memberUid
-   posixWinsyncCreateMemberOfTask - this is FALSE by default. Set this to TRUE if you are using memberOf and you want the memberOf attribute values updated after group sync is complete. The plugin will invoke the memberof fixup task to perform this update.
-   posixWinsyncLowerCaseUID - this is FALSE by default. Some deployments use uppercase letters in samAccountName which is mapped to uid. uid should be case insensitive and works on Unix/Linux for users, but makes problems with supplementary groups (a least on Solaris). If you set this attribute to TRUE, and you have posixWinsyncMapMemberUID set to TRUE, when the plugin populates the memberUid values, they will be all lowercase.

Implementation Details
----------------------

Now that 389 supports having multiple winsync plugins, a plugin that wants to run after any POSIX attributes have been added/updated should have a higher precedence than the posix winsync plugin (by default 50). The Winsync Plugin API v3 has support for a precedence callback. See [Windows\_Sync\_Plugin\_API\#Version\_3\_API\_functions](windows-sync-plugin-api.html#v3-api) for more information.


