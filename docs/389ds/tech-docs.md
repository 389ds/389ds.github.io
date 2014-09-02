---
title: "FAQs and Tech Docs"
---

# Tech Docs, FAQ's, and How To's
-------------

{% include toc.md %} 

### Design Documents
---------------------

Documents describing new features that were introduced in each release, as well as existing pluigns and features.  Go to the [Design Documents](design/design.html "Feature Design Documents")

<br>
<a name="tech-docs"></a>

### Technical Documents
----------------------
-   [Common FAQs](FAQ/faq.html) - Common Frequently Asked Questions
-   [Troubleshooting](FAQ/faq.html#Troubleshooting) - How to use the directory server error log levels to diagnose problems
-   [Debugging Crashes](FAQ/faq.html#debug_crashes) - How to get the right information for reporting crashes
-   [Debugging Hangs](FAQ/faq.html#debug_hangs) - How to get the right information for reporting hangs (server unresponsive, server won't shutdown cleanly)
-   [Architecture](design/architecture.html) - LDAP 101 architecture
-   [Fedora DS to 389 DS](FAQ/389-change-faq.html) - Why the name changed from **Fedora DS** to **389 DS**
-   [Anonymous Access Switch](FAQ/anonymous-access-switch.html) - Switch to turn off anonymous access
-   [Anonymous Resource Limits](FAQ/anonymous-resource-limits.html) - Set the anonymous resource limits
-   [LDAP Books](FAQ/books.html) - Good LDAP books
-   [File Bugs/Tickets](FAQ/bugs.html) - Links to the bug reporting tools
-   [Changelog Encryption](FAQ/changelog-encryption.html) - Description of how userpasswords are stored in the changelog
-   [Client Software](FAQ/client-software.html) - Various API/tools for access a LDAP server
-   [ESC Guide](FAQ/esc-guide.html) - Smart Card Manager
-   [Features](FAQ/features.html) - Features of 389 Directory Server 
-   [LDAPI and AUTOBIND](FAQ/ldapi-and-autobind.html) - Description of LDAPI and AUTOBIND
-   [Memory Usage Research](FAQ/memory-usage-research.html) - High memory usage investigation
-   [New Setup Design](FAQ/new-setup-design.html) - Post setupUtil design
-   [Password Syntax Checking](FAQ/password-syntax.html) - Password syntax checking
-   [Performance Tuning](FAQ/performance-tuning.html) - Performance tuning for various platforms
-   [RDN values](FAQ/rdn-value.html) - Description of the RDN
-   [Product Roadmap](FAQ/roadmap.html) - 389 Directory Server Roadmap
-   [SELinux Policy](FAQ/selinux-policy.html) - SE Linux discussion
-   [SetupUtil](FAQ/setuputil.html) - Description of setupUtil
-   [Thread Aware Regex](FAQ/thread-aware-regex.html) - Discussion about the move to a thread safe regex library
-   [Update Resolution Protocol](FAQ/update-resolution-for-single-valued-attributes.html) - Description of the URP protocol for single values attributes
-   [Upstream Testing Framework](FAQ/upstream-test-framework.html) - Continuous integration testing and lib389
-   [Ways to Contribute](FAQ/ways-to-contribute.html) - Ways to contribute to the 389 project
-   [Winsync Move Action](FAQ/winsync-move-action.html) - Discussion of the winSyncMoveAction configuration attribute

<br><a name="web-apps"></a>

### Web Applications
--------

-   [Admin Server](administration/adminserver.html)
-   [Admin Util](administration/adminutil.html)
-   [Admin Express](administration/adminexpress.html)
-   [DS Express](administration/dsexpress.html)
-   [DSGW](administration/dsgw.html)
-   [DSGW Installation Guide](administration/dsgw-install-guide.html)
-   [Building DSGW](administration/dsgw-building.html)
-   [DSML Gateway Docs](administration/dsml.html)
-   [Mod Admserv](administration/mod-admserv.html)
-   [Mod NSS](administration/mod-nss.html)
-   [Mod restartd](administration/mod-restartd.html)
-   [OrgChart](administration/orgchart.html)
-   [Using and configuring 389 web apps](administration/webapps-overview.html) - including the DSGW, DS Express, Org Chart, and Admin Express
-   [Installing the web apps](administration/webapps-install.html)

<br><a name="howto"></a>

### How To's
---------

#### Common Server Configuration Tasks

-   [How to Reset Root DN password ](howto/howto-resetdirmgrpassword.html) - How to reset the directory manager password
-   [How to Reset a Locked Password](howto/howto-passwordreset.html) - How to reset a password that has been locked out due to excessive failed attempts
-   [How to Certificate Mapping](howto/howto-certmapping.html) - Map a certificate subjectDN to the user's entry when using client certificate based authentication.
-   [How to Chain on Update](howto/howto-chainonupdate.html) - Allow read-only replicas to "follow" referrals on behalf of clients, and enabled global password policy.
-   [How to MMR](howto/howto-multimasterreplication.html) - How to configure multi-master replication without using the administration console.
-   [How to Monitor Replication](howto/howto-replicationmonitoring.html) - How to check replication without using administration console or website
-   [How to Admin Server LDAP Management](howto/howto-adminserverldapmgmt.html) - How to manage the Admin Server using LDAP
-   [How to SysVInit](howto/howto-sysvinit.html) - How to start the directory server automatically at boot time.
-   [How to SystemD](howto/howto-systemd.html) - How to use 389 with systemd (systemd is the SysV Init replacement in Fedora 15 and later)
-   [How to COS](howto/howto-classofservice.html) - Class of Service (CoS) examples
-   [How to Use Access Control](howto/howto-accesscontrol.html) - How to use access control
-   [How to Operation Attributes](howto/howto-operationalattributes.html) - How to access operational attributes
-   [How to Logging Performance Impact](howto/howto-logsystemperf.html) - Do I need to turn off access log to improve system performances
-   [How to Ldapsearch without line wrapping](howto/howto-unlimitedwidthldapsearch.html) - How do I set an unlimited line width for ldapsearch
-   [How to Sizelimit and Ldapsearch](howto/howto-ldapsearchsizelimit.html) - Why do I get this error message "ldap\_search: Administrative limit exceeded"
-   [How to Ldapsearch and attributes ](howto/howto-ldapsearchmanyattr.html) - How to count large number of attribute entries using an anonymous bind
-   [How to Secure MMR Walkthrough](howto/howto-walkthroughmultimasterssl.html) - Setting up FDS with multi-master replication, SSL and importing OpenLDAP schema
-   [How to PAM Passthru Authentication](howto/howto-pam-pass-through.html) - Setting up the PAM pass through authentication plugin
-   [How to Use DNA Plugin](howto/howto-dna.html) - How to use Distributed Numeric Assignment to auto-generate uidNumber and gidNumber
-   [How to Set default objectclass in Console](howto/howto-default-console-object-objectclass.html) - How to set the list of default objectclasses the console uses to create new objects (Users, Groups, etc.)
-   [How to Host Based Attributes](howto/howto-hostbasedattributes.html) - How to have different values for attributes on different hosts e.g. have a different login shell on certain hosts
-   [How to Clean RUVs](howto/howto-cleanruv.html) - How to get rid of obsolete masters from your replication meta-data (i.e. the database RUV)
-   [How to Copy ACIs](howto/howto-copyacis.html) - How to copy ACIs from one server to another
-   [How to Fix Time Screw](howto/howto-fix-and-reset-time-skew.html) - When the replication CSN time skew grows too large, how to reset the CSN generator everywhere to get rid of time skew
-   [How to Roles as Posix Groups](howto/howto-rolesasgroupsrequirements.html) - Use roles as posix groups
-   [How to Use Named pipe Log Script](howto/howto-use-named-pipe-log-script.html)
-   [How to Use openLdap clients](howto/howto-use-openldap-clients-in-389.html)

#### Directory Server Setup and Management

-   [How to Migrate to 389](howto/howto-migratetoldap.html)
-   [How to Migrate from openLdap](howto/howto-openldapmigration.html)
-   [How to PHP and Admin Server](howto/howto-phpldapadmin.html)
-   [How to Setup SSL](howto/howto-ssl.html)
-   [How to StartTLS](howto/howto-starttls.html)
-   [How to Only Accept SSL Connections](howto/howto-listensslonly.html)
-   [How to Change UID](howto/howto-changeuid.html)
-   [How to Use LdapAdmin tool ](howto/howto-ldapadmin.html)
-   [How to Use LDAP monitoring tools](howto/howto-cn-equals-monitor-ldap-monitoring.html)
-   [How to Upgrade DN Format](howto/howto-upgrade-to-new-dn-format.html)
-   [How to Use SSF Restrictions](howto/howto-use-ssf-restrictions.html)

#### Operating System

-   [How to Posix](howto/howto-posix.html)
-   [How to Configure NSS LDAP for SSL ](howto/howto-ldapnsswithssl.html)
-   [How to PAM](howto/howto-pam.html)
-   [How to Use Netgroups](howto/howto-netgroups.html)
-   [How to Debian Packages](howto/howto-debianpackages.html)
-   [How to Debian Etch](howto/howto-debianetch.html)
-   [How to Debian Ubuntu](howto/howto-debianubuntu.html)
-   [How to Solaris to 389](howto/howto-solarisclient.html)
-   [How to Use Windows Console](howto/howto-windowsconsole.html)
-   [How to Windows Sync](howto/howto-windowssync.html)
-   [How to One Way AD Sync](howto/howto-one-way-active-directory-sync.html)
-   [How to Build RPMS on CentOS ](howto/howto-buildrpmsforcentos-rhel.html)
-   [How to Deploy From Kickstart](howto/howto-deployfromkickstart.html)
-   [How to Chain to AD](howto/howto-chaintoad.html) - Setting up chaining (database link) to a Windows Active Directory
-   [How to Configure MMC](howto/howto-configure-mmc.html) - Configure Microsoft Management Console
-   [How to Create Child Domain](howto/howto-create-a-child-domain-in-an-existing-domain-tree.html) - Create a child domain in an existing domain tree
-   [How to Create Domain in Existing Forest](howto/howto-create-an-additional-domain-controller-in-an-existing forest.html) - Create an Additional Domain Controller in an Existing Forest
-   [How to Create Domain in New Forest](howto/howto-create-a-new-domain-tree-in-a-new-forest.html) - Create a New Domain Tree in a New Forest
-   [How to Fedora Release](howto/howto-fedora-release-process.html) - The Fedora release process

#### Mail

-   [How to QMail](howto/howto-qmail.html)
-   [How to Sendmail](howto/howto-sendmail.html)
-   [How to Postfix](howto/howto-postfix.html)
-   [How to Postfix with IMAP](howto/howto-postfix-imap.html)
-   [How to Dovecot](howto/howto-dovecot.html)
-   [How to OpenWebmail](howto/howto-openwebmail.html)

#### Filesystem

-   [How to Automount](howto/howto-automount.html)
-   [How to Samba](howto/howto-samba.html)

#### DNS

-   [How to BIND](howto/howto-bind.html)

#### Database

-   [How to Oracle](howto/howto-oracle.html)

#### Web

-   [How to Apache](howto/howto-apache.html)
-   [How to Subversion Apache](howto/howto-subversion-apache-ldap.html) - How to get your Subversion server to use LDAP for authenticating users

#### Other

-   [How to write a wiki page](howto/howto-write-wiki-page.html)
-   [How to openLdap Integration](howto/howto-openldapintegration.html)
-   [How to Kerberos](howto/howto-kerberos.html)
-   [How to Java on FedoraCore](howto/howto-javaonfedoracore.html)
-   [How to Daemon Tools](howto/howto-daemontools.html)
-   [How to Persistent search](howto/howto-persistent-search.html)
-   [How to SNMP Monitoring](howto/howto-snmpmonitoring.html)
-   [How to DS Admin Migration](howto/howto-ds-admin-migration.html)
-   [How to Fixup-UID-Script](howto/howto-uidfixup.html)
-   [Zimbra Schema Integration (Spanish)](http://wiki.fedora-ve.org/WilmerJaramillo/ZimbraSchema)

#### Legacy How To's

-   [How to Windows Domain Controller Certificate Enrollment](howto/howto-windows-domain-controller-certificate-enrollment.html)
-   [How to Windows Webserver Certificate Enrollment](howto/howto-windows-webserver-certificate-enrollment.html)
-   [How build on Etch](howto/howto-buildonetch.html)
-   [How to build 389 on Debian Gnu/Linux 4.0 (Etch) ](howto/howto-gentoodsbuildinstallation.html)

