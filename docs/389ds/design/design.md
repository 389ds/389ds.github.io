---
title: "Design Docs"
---

# Feature Design Documents
--------------------------

This page serves as a central collection point for feature design documents. Feature design documents are organized by the release where the feature is implemented.

If you are adding a new design document, use the [template](design-template.html).  Don't forget to add a link under the proper release on this page!

{% include toc.md %}

## 389 Directory Server 1.3.5
-   [Shadow Account Support](shadow-account-support.html)

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
-   [Design Themes for DS](design-themes-for-ds.html)
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
-   [Entry State Resolution](entry-state-resolution.html)
-   [High Contention with Entry Cache](high-contention-on-entry-cache-lock.html)
-   [Separate Suffix for Tombstones/Conflicts](separate-conflict-and-tombstone-entry.html)
-   [Managed Entry Plug-in Enhancement](mep-rework.html)
-   [Audit Logging Improvements](audit_improvement.html)
-   [Managing Replication Conflicts](managing-repl-conflict-entries.html)
-   [Disable Instance Script Installation](disable-instance-scripts.html)










