---
title: "Design Docs"
---

# Feature Design Documents
--------------------------

This page serves as a central collection point for feature design documents. Feature design documents are organized by the release where the feature is implemented.

If you are adding a new design document, use the [template](design-template.html).  Don't forget to add a link under the proper release on this page!

{% include toc.md %}

## Roadmap

-   [Directory Server Roadmap](../FAQ/roadmap.html)

## 389 DIrectory Server 1.4.2 (RHEL 8.2)

-   [Healthcheck Tool](healthcheck-design.html)
-   [Protection of NSS DB password] (protect-NSS-db.html)
-   [Password Upgrade On Bind] (pwupgrade-on-bind.html)
-   [Filter Syntax Validation] (filter-syntax-validation.html)

## 389 Directory Server 1.4.1 (RHEL 8.1)

-   [Container Integration](docker.html)
-   [Replication Agreement Status Message Improvements](repl-agmt-status-design.html)
-   [CLI Tool and Lib389 Design Guide](cli-guide.html)

## 389 Directory Server 1.4.0 (RHEL 8)

-   [Automembership Plugin Postop Modify](automember-postop-modify-design.html)
-   [New Password Poliy Syntax Checks](pwpolicy-syntax-design.html)
-   [New Python CLI Tools](dsadm-dsconf.html)
-   New Web UI (Cockpit plugin)  --> Design doc in the works...

## 389 Directory Server 1.3.9 (RHEL 7.7)

-   [Automembership Plugin Postop Modify](automember-postop-modify-design.html)  (backported from 1.4.0)

## 389 Directory Server 1.3.8 (RHEL 7.6)

-   Just bug fixes

## 389 Directory Server 1.3.7 (RHEL 7.5)

-   [Replication Diff Tool](repl-diff-tool-design.html)
-   [Dynamic Certificate Mapping](certmap-ipa.html)
-   [Pblock Breakup](pblock-breakup.html)
-   [Password Policy Controls](password-controls.html)

## 389 Directory Server 1.3.6 (RHEL 7.4)

-   [Schema with Multiple Search Paths](schema-multiple-search-paths.html)
-   [New Error Log Format and Severity Level](errorlog-format-design.html)
-   [Configuration Reset](configuration-reset.html)
-   [Autotuning Memory and Threads](autotuning.html)
-   [PBKDF2](pbkdf2.html)
-   [Change to tcmalloc for Memory Allocator](tcmalloc-design.html)

------------------------------------------------

## 389 Directory Server 1.3.5 (RHEL 7.3)

-   [Shadow Account Support](shadow-account-support.html)
-   [Password Expiring Control Configuration](password-expiring-design.html)
-   [Disable Instance Script Installation](disable-instance-scripts.html)
-   [Audit Logging Improvements](audit_improvement.html)
-   [Multiple Logging Backends](logging-multiple-backends.html)
-   [High Resolution Logging Timestamps](logging-high-resolution-time.html)
-   [Enhanced Account Tools for Account Policy Plugin](enhanced-account-tools.html)
-   [Allow usage of OpenLDAP libraries that do not use NSS for crypto](allow-usage-of-openldap-lib-w-openssl.html)
-   [Systemd Ask Password](systemd-ask-pass.html)
-   [Replication Convergence Improvement](repl-conv-design.html) - This feature will most likely be backported to previous versions
-   [Extended Op Plug-in Transaction Support](exop-plugin-transactions.html)

-------------------------------------------------

## 389 Directory Server 1.3.4

-   [Nunc Stans](nunc-stans.html)
-   [Audit Events](audit-events.html)
-   [MemberOf Plugin Scoping](memberof-scoping.html)
-   [Retro Changelog Plugin Scoping](retrocl-scoping.html)
-   [MemberOf Plugin Auto Add Objectclass](memberof-auto-add-oc.html)

-------------------------------------------------

## 389 Directory Server 1.3.3
-   [AES Password Based Encryption](pbe.html)
-   [Referential Integrity Plugin Configuration](ri-plugin-configuration.html)
-   [MemberOf Plugin Shared Configuration](memberof-plugin-configuration.html)
-   [Replication Changelog Trimming Interval](changelog-trimming-interval.html)
-   [Dynamic Plugins](dynamic-plugins.html)
-   [Available NSS Ciphers](nss-cipher-design.html)
-   [Windows Sync Enhancements](winsync-rfe.html)
-   [Account Policy -- alwaysRecordLoginAttr](account-policy-design.html#new-attribute-alwaysrecordloginattr)

-------------------------------------------------

## 389 Directory Server 1.3.2
-   [POSIX Winsync SID Enhancements]( posix-winsync-sid-enhancements.html)
-   [LDAPI and Access Control]( ldapi-and-access-control.html)
-   [DNA Remote Server Setting](dna-remote-server-settings.html)
-   [Fine Grained ID List Size](fine-grained-id-list-size.html)
-   [Content Synchronization Plugin (SyncRepl)](content-synchronization-plugin.html)
-   [Plugin Internal Operation Logging](plugin-logging.html)
-   [Configuring Scope for Referential Integrity](configuring-scope-for-referential-integrity-plugin.html)
-   [Replication of Custom Schema](replication-of-custom-schema.html)
-   [Read Entry Controls](read-entry-controls.html)
-   [Intervals to compact Primary DB and Replication Changelog DB](db-compactdb-interval.html)

-------------------------------------------------

## 389 Directory Server 1.3.1
-   [Plug-in Transaction Support](plugin-transactions.html)
-   [Normalized DN Cache](normalized-dn-cache.html)
-   [Configurable Allowed SASL Mechanisms](sasl-mechanism-configuration.html)
-   [SASL Mapping Improvements](sasl-mapping-improvements-1-dot-3-1.html)
-   [Configurable SASL Buffer](sasl-buffer.html)
-   [Replication Retry Settings](replication-retry-settings.html)
-   [Instance Script Improvements](instance-script-improvements-1-dot-3-1.html)
-   [Access Log Analyzer Improvements](logconv-improvements-1-dot-3-1.html)
-   [Replication Protocol Timeout](replication-protocol-timeout.html)
-   [Password Administrators](password-administrator.html)
-   [Referential Integrity Plugin and Replication](referint-replication-design.html)
-   [MemberOf Plugin - Skip Nested Groups](memberof-skip-nested.html)

-------------------------------------------------

## 389 Administration Server 1.1.36
-   [Register Remote Servers using register-ds-admin.pl](console-remote-reg-design.html)
-   [Using 389 Console with Anonymous Access Disabled](../administration/console-login-and-anonymous-access.html)
-   [Security Modules, Console, and SELinux](../administration/security-module-console.html)

-------------------------------------------------

## Web-based Directory Server Management Console
-   [NEW Web-based Console](389-web-ui-design.html)
-   [LDAP REST API](ldap-rest-api.html)
-   ["o=dmc" Design Page](dmc-design.html)

-------------------------------------------------

## Older Design Documents
-   [64-bit Counters](64-bit-counters-design.html)
-   [Access Control and Moddn](access-control-on-trees-specified-in-moddn-operation.html)
-   [Account Policy](account-policy-design.html)
-   ["aclutil" Design](acl-utility.html)
-   [Attribute Encryption](attribute-encryption-design.html)
-   [Changelog Trimming Interval](changelog-trimming-interval.html)
-   [CLEANALLRUV Design](cleanallruv-design.html)
-   [Creation of Explicit Role Scoping](creation-of-an-explicit-scoping-for-the-roles-ticket-208.html)
-   [Database Architecture](database-architecture.html)
-   [Disable Virtual Attribute Lookups](disable-virtual-attrs.html)
-   [Diskspace Monitoring](disk-monitoring.html)
-   [DNA Plugin Remote Server Settings](dna-remote-server-settings.html)
-   [Dynamic Schema Reload](dynamically-reload-schema.html)
-   [Entry USN](entry-usn.html)
-   [Get Effective Rights](get-effective-rights-design.html)
-   [Get Effective Rights for "not present" Attributes](get-effective-rights-for-non-present-attributes.html)
-   [LDAP Transactions](ldap-transactions.html)
-   [LDAP whoami](ldapwhoami.html)
-   [Legacy Password Policy](legacy-password-policy.html)
-   [Matching Rule API](matching-rule-api.html)
-   [MemberOf Grouping Enhancements](memberof-multiple-grouping-enhancements.html)
-   [Password Migration](password-migration-design.html)
-   [Password Policy API](password-policy-api.html)
-   [Plugin Ordering](plugin-ordering.html)
-   [Plugin Design](plugins.html)
-   [Plugin Bind DN Tracking](plugin-track-bind-dn.html)
-   [POSIX Winsync SID Enhancements](posix-winsync-sid-enhancements.html)
-   [Replication Session Hooks](replication-session-hooks.html)
-   [SASL/GSSAPI/Kerberos](sasl-gssapi-kerberos-design.html)
-   [Server to Server Connections](server-to-server-conn.html)
-   [Simple Paged Results](simple-paged-results-design.html)
-   [Slapi_Task API](slapi-task-api.html)
-   [Static Group Performance](static-group-performance.html)
-   [Subtree Rename](subtree-rename.html)
-   [Syntax Validation](syntax-validation-design.html)
-   [Task Initiation](task-invocation-via-ldap.html)
-   [Task Initiation Design](task-invocation-via-ldap-design.html)
-   [Track Password Updates](track-password-update.html)
-   [Windows Sync Plugin API](windows-sync-plugin-api.html)

---------------------------------------------

## Plugin Design Documents
-   [Auto Membership Plugin](automember-design.html)
-   [DNA Plugin Proposal](dna-plugin-proposal.html)
-   [DNA Plugin](dna-plugin.html)
-   [Linked Attributes Plugin](linked-attributes-design.html)
-   [Managed Entry Plugin](managed-entry-design.html)
-   [MemberOf Plugin](memberof-plugin.html)
-   [Root DN Access Control Plugin](rootdn-access-control.html)
-   [Winsync POSIX Plugin](winsync-posix.html)

-----------------------------------------------

## Design Discussions
-   [Token Auth](token-auth.html)
-   [Entry State Resolution](entry-state-resolution.html)
-   [High Contention with Entry Cache](high-contention-on-entry-cache-lock.html)
-   [Separate Suffix for Tombstones/Conflicts](separate-conflict-and-tombstone-entry.html)
-   [Managed Entry Plug-in Enhancement](mep-rework.html)
-   [Managing Replication Conflicts](managing-repl-conflict-entries.html)
-   [Logging Performance Improvement](logging-performance-improvement.html)
-   [Dsadm and Dsconf](dsadm-dsconf.html)
-   [Nunc Stans Workers](nunc-stans-workers.html)
-   [Cache Redesign](cache_redesign.html)
-   [Plugin Version 4](plugin-v4.html)
-   [Password extensibility](password-extensibility.html)
-   [Transactional Operations](transactional-operations.html)
-   [PAD/PAC anchor cretaino](pad-pac-anchor-creation.html)


