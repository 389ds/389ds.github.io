---
title: "Client software"
---

# Client Software
-----------------

Interacting with the 389 Directory Server is a matter of making use of one the following:

### Software Development Kits

LDAP SDK packages designed for your language of choice that you could use for your application:

-   [LDAP C SDK](http://www.mozilla.org/directory/csdk.html)
-   [LDAP Java SDK](http://www.mozilla.org/directory/javasdk.html)
-   [PerLDAP](http://www.mozilla.org/directory/perldap.html)
-   [Net::LDAP](http://ldap.perl.org/)
-   [Python LDAP](http://python-ldap.sourceforge.net/)
-   [PHP LDAP](http://www.php.net/manual/en/ref.ldap.php)

### Operating Systems

Direct integration into the operating system.

-   [Red Hat Login](http://www.redhat.com/docs/manuals/linux/RHL-9-Manual/install-guide/s1-authconfig.html)

### Tools

We don't advocate the use of any one of these tools over another. It is up to the individual to determine the utility of a given tool.

#### General LDAP Browsing and Administration Tools

##### Command Line Tools

-   [fdstools.pm](https://www.redhat.com/archives/fedora-directory-users/2009-February/binwXGyLHrNEa.bin) (Perl Net::LDAP) - configure and monitor replication with encryption across several servers
    -   [Read here](https://www.redhat.com/archives/fedora-directory-users/2009-February/msg00119.html) for more information

##### Web LDAP Clients

-   [phpLDAPAdmin](http://phpldapadmin.sourceforge.net/) (PHP)
-   [web2ldap](http://www.web2ldap.de/) (Python)

##### GUI LDAP Clients

-   [Directory Administrator](http://diradmin.open-it.org/index.php) (GTK)
-   [GQ](http://sourceforge.net/projects/gqclient/) (GTK)
-   [JXplorer](http://www.jxplorer.org) (Java)
-   [Luma](http://luma.sourceforge.net/) (PyQt)

##### Commercial GUI LDAP Clients

-   [LDAP Admin Tool](http://www.ldapsoft.com/ldapadmintool.html)
-   [LDAPBrowser](http://ldapbrowser.com/) (Windows only)

##### Migration Tools

-   [Migration To LDAP tools](http://www.padl.com/OSS/MigrationTools.html) (Perl)

##### Interoperability

-   [pGina](http://www.pgina.org/) provides a way to make Windows login use an LDAP server (Unmaintained as of September, 2008)

#### Tools provided by the Fedora Directory Server

-   Administrative Tasks
    -   [Management Console](http://www.redhat.com/docs/manuals/dir-server/pdf/console60.pdf)
    -   [Admin Guide](http://www.redhat.com/docs/manuals/dir-server/ag/8.0/index.html)
-   Editing & Browsing LDAP Entries
    -   [ldapsearch](http://www.redhat.com/docs/manuals/dir-server/cli/utilities.htm#pgfId-19555) Search an LDAP server
    -   [ldapmodify](http://www.redhat.com/docs/manuals/dir-server/cli/utilities.htm#pgfId-27417) Modify entries in an LDAP server
    -   [ldapdelete](http://www.redhat.com/docs/manuals/dir-server/cli/utilities.htm#pgfId-19549) Remove entries from an LDAP server
-   Export & Import LDAP Databases
    -   [dsctl <instance> db2ldif](http://www.redhat.com/docs/manuals/dir-server/cli/scripts.htm#pgfId-23620) Export database contents to LDIF
    -   [dsctl <instance> ldif2db](http://www.redhat.com/docs/manuals/dir-server/cli/scripts.htm#pgfId-23739) Import database contents from LDIF
-   Backup & Restore
    -   [bak2db](http://www.redhat.com/docs/manuals/dir-server/cli/scripts.htm#pgfId-23510) Restore database from backup
    -   [db2bak](http://www.redhat.com/docs/manuals/dir-server/cli/scripts.htm#pgfId-23561) Create backup of database


