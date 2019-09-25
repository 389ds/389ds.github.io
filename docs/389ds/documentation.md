---
title: "Documentation"
---

# 389 Directory Server Documentation
------------------------------------

{% include toc.md %}

## Resources

### Directory Server Documentation

The best documentation for use and deployment can be found in the [Red Hat Directory Server documentation](https://access.redhat.com/site/documentation/Red_Hat_Directory_Server/). Although these documents are for Red Hat Directory Server, they apply to 389 DS as well. However, be sure to read the [Release Notes](releases/release-notes.html) and [Install Guide](legacy/install-guide.html) for 389 DS first in case there are important differences.

- [Red Hat Directory Server 10, 1.3.x series](https://access.redhat.com/documentation/en/red-hat-directory-server/?version=10)
- [Red Hat Directory Server 9, 1.2.x series](https://access.redhat.com/documentation/en/red-hat-directory-server/?version=9)

### Design Documents

All our features are initially planned and developed from these documents:

- [Design Docs](design/design.html)

### How Tos

We maintain a number of how to guides for 389 Directory Server

#### Common Server Configuration Tasks

-   [How to Configure Changelog Trimming](FAQ/changelog-trimming.html)
-   [How to Setup TLS/SSL](howto/howto-ssl.html)
-   [How to Reset Root DN password ](howto/howto-resetdirmgrpassword.html) - How to reset the directory manager password
-   [How to Reset a Locked Password](howto/howto-passwordreset.html) - How to reset a password that has been locked out due to excessive failed attempts
-   [How to Certificate Mapping](howto/howto-certmapping.html) - Map a certificate subjectDN to the user's entry when using client certificate based authentication.
-   [How to Chain on Update](howto/howto-chainonupdate.html) - Allow read-only replicas to "follow" referrals on behalf of clients, and enabled global password policy.
-   [How to MMR](howto/howto-multimasterreplication.html) - How to configure multi-master replication without using the administration console.
-   [How to Monitor Replication](howto/howto-replicationmonitoring.html) - How to check replication without using administration console or website
-   [How to Monitor Replication Using CLI](howto/howto-monitor-replication.html) - How to check replication using dsconf CLI
-   [How to SystemD](howto/howto-systemd.html) - How to use 389 with systemd (systemd is the SysV Init replacement in Fedora 15 and later)
-   [How to COS](howto/howto-classofservice.html) - Class of Service (CoS) examples
-   [How to Use Access Control](howto/howto-accesscontrol.html) - How to use access control
-   [How to Operation Attributes](howto/howto-operationalattributes.html) - How to access operational attributes
-   [How to Logging Performance Impact](howto/howto-logsystemperf.html) - Do I need to turn off access log to improve system performances
-   [How to Ldapsearch without line wrapping](howto/howto-unlimitedwidthldapsearch.html) - How do I set an unlimited line width for ldapsearch
-   [How to Sizelimit and Ldapsearch](howto/howto-ldapsearchsizelimit.html) - Why do I get this error message "ldap\_search: Administrative limit exceeded"
-   [How to Ldapsearch and attributes ](howto/howto-ldapsearchmanyattr.html) - How to count large number of attribute entries using an anonymous bind
-   [How to Secure MMR Walkthrough](howto/howto-walkthroughmultimasterssl.html) - Setting up FDS with multi-master replication, TLS/SSL and importing OpenLDAP schema
-   [How to PAM Passthru Authentication](howto/howto-pam-pass-through.html) - Setting up the PAM pass through authentication plugin
-   [How to Use DNA Plugin](howto/howto-dna.html) - How to use Distributed Numeric Assignment to auto-generate uidNumber and gidNumber
-   [How to Host Based Attributes](howto/howto-hostbasedattributes.html) - How to have different values for attributes on different hosts e.g. have a different login shell on certain hosts
-   [How to Clean RUVs](howto/howto-cleanruv.html) - How to get rid of obsolete masters from your replication meta-data (i.e. the database RUV)
-   [How to Copy ACIs](howto/howto-copyacis.html) - How to copy ACIs from one server to another
-   [How to Fix Time Skew](howto/howto-fix-and-reset-time-skew.html) - When the replication CSN time skew grows too large, how to reset the CSN generator everywhere to get rid of time skew
-   [How to Roles as Posix Groups](howto/howto-rolesasgroupsrequirements.html) - Use roles as posix groups
-   [How to Use Named pipe Log Script](howto/howto-use-named-pipe-log-script.html)
-   [How to Use openLdap clients](howto/howto-use-openldap-clients-in-389.html)
-   [How to run lib389 testcases in a Jenkins job](howto/howto-run-lib389-jenkins.html)
-   [How to enable ADDN plugin](howto/howto-addn.html)
-   [How to enable Attribute Uniqueness](howto/howto-uid-uniqueness.html) - Configuration of attribute uniqueness plugin.

#### Directory Server Setup and Management

-   [How to Migrate to 389](howto/howto-migratetoldap.html)
-   [How to Migrate from openLdap](howto/howto-openldapmigration.html)
-   [How to StartTLS](howto/howto-starttls.html)
-   [How to Only Accept TLS/SSL Connections](howto/howto-listensslonly.html)
-   [How to Change UID](howto/howto-changeuid.html)
-   [How to Upgrade DN Format](howto/howto-upgrade-to-new-dn-format.html)
-   [How to Use SSF Restrictions](howto/howto-use-ssf-restrictions.html)
-   [How to Inactivate Accounts using nsAccountLock](howto/howto-account-inactivation.html)

#### Operating System

-   [How to Posix](howto/howto-posix.html)
-   [How to Configure NSS LDAP for TLS/SSL ](howto/howto-ldapnsswithssl.html)
-   [How to PAM](howto/howto-pam.html)
-   [How to Debian Packages](howto/howto-debianpackages.html)
-   [How to Build RPMS on CentOS ](howto/howto-buildrpmsforcentos-rhel.html)
-   [GSSAPI Behind Load Balancer](howto/howto-loadbalance-gssapi.html) - Configuration of SLAPD behind a load balancer with GSSAPI
-   [How to Automount](howto/howto-automount.html)

#### Development processes

-   [Address Sanitizer Testing](howto/howto-addresssanitizer.html) - Using Address Saniziter to find and correct issues.
-   [How to Fedora Release](howto/howto-fedora-release-process.html) - The Fedora release process
-   [How to Write a Wiki Page](howto/howto-write-wiki-page.html)
-   [How to Migrate from Trac to Pagure](howto/howto-migrate-to-pagure.html)
-   [How to Do Pull-Requests in Pagure](howto/howto-do-pull-requests.html)

#### Mail

-   [How to QMail](howto/howto-qmail.html)
-   [How to Sendmail](howto/howto-sendmail.html)
-   [How to Postfix](howto/howto-postfix.html)
-   [How to Dovecot](howto/howto-dovecot.html)

#### DNS

-   [How to BIND](howto/howto-bind.html)


#### Web/Console

-   [How to Apache](howto/howto-apache.html)
-   [How to Subversion Apache](howto/howto-subversion-apache-ldap.html) - How to get your Subversion server to use LDAP for authenticating users
-   [How to use 389 Console with Anonymous Access Disabled](administration/console-login-and-anonymous-access.html)

#### Other

-   [How to openLdap Integration](howto/howto-openldapintegration.html)
-   [How to Kerberos](howto/howto-kerberos.html)
-   [How to Persistent search](howto/howto-persistent-search.html)
-   [How to SNMP Monitoring](howto/howto-snmpmonitoring.html)
-   [How to DS Admin Migration](howto/howto-ds-admin-migration.html)
-   [Zimbra Schema Integration (Spanish)](http://wiki.fedora-ve.org/WilmerJaramillo/ZimbraSchema)
-   [How to Setup SLAMD Performance Benchmarking Tool](howto/howto-setup-slamd.html)

#### Legacy How To's

These are potentially outdated or incorrect for the current DS version.

-   [How to Windows Domain Controller Certificate Enrollment](howto/howto-windows-domain-controller-certificate-enrollment.html)
-   [How to Windows Webserver Certificate Enrollment](howto/howto-windows-webserver-certificate-enrollment.html)
-   [How build on Etch](howto/howto-buildonetch.html)
-   [How to build 389 on Debian Gnu/Linux 4.0 (Etch) ](howto/howto-gentoodsbuildinstallation.html)
-   [How to Use LDAP monitoring tools](howto/howto-cn-equals-monitor-ldap-monitoring.html)
-   [How to Configure MMC](howto/howto-configure-mmc.html) - Configure Microsoft Management Console
-   [How to Debian Ubuntu](howto/howto-debianubuntu.html)
-   [How to Use LdapAdmin tool ](howto/howto-ldapadmin.html)
-   [How to Postfix with IMAP](howto/howto-postfix-imap.html)
-   [How to Samba](howto/howto-samba.html)
-   [How to Fixup-UID-Script](howto/howto-uidfixup.html)
-   [How to Admin Server LDAP Management](howto/howto-adminserverldapmgmt.html) - How to manage the Admin Server using LDAP
-   [How to SysVInit](howto/howto-sysvinit.html) - How to start the directory server automatically at boot time.
-   [How to Set default objectclass in Console](howto/howto-default-console-object-objectclass.html) - How to set the list of default objectclasses the console uses to create new objects (Users, Groups, etc.)
-   [How to Disable SSLv3 in DS and Admin Server (Poodlebleed vulnerability)](howto/howto-disable-sslv3.html)
-   [How to Use Netgroups](howto/howto-netgroups.html)
-   [How to Solaris to 389](howto/howto-solarisclient.html)
-   [How to Use Windows Console](howto/howto-windowsconsole.html)
-   [How to Windows Sync](howto/howto-windowssync.html)
-   [How to One Way AD Sync](howto/howto-one-way-active-directory-sync.html)
-   [How to Deploy From Kickstart](howto/howto-deployfromkickstart.html)
-   [How to Chain to AD](howto/howto-chaintoad.html) - Setting up chaining (database link) to a Windows Active Directory
-   [How to Create Child Domain](howto/howto-create-a-child-domain-in-an-existing-domain-tree.html) - Create a child domain in an existing domain tree
-   [How to Create Domain in Existing Forest](howto/howto-create-an-additional-domain-controller-in-an-existing forest.html) - Create an Additional Domain Controller in an Existing Forest
-   [How to Create Domain in New Forest](howto/howto-create-a-new-domain-tree-in-a-new-forest.html) - Create a New Domain Tree in a New Forest
-   [How to PHP and Admin Server](howto/howto-phpldapadmin.html)
-   [Building Directory Server](development/legacy-building.html)

### FAQ and tech docs

We have some less maintained FAQ's and tech docs related to the server here:

- [FAQ's, Tech docs](tech-docs.html)

## What's New on port389.org?

Check out the latest additions and updates [here](../../whats_new.html)

