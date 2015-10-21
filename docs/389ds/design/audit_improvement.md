---
title: "Audit Logging Improvements: Filtering and Failed Events"
---

# Audit Logging Improvements: Filtering and Failed Events
----------------

Overview
--------

Audit logging allows a running instance of ns-slapd to log changes to entries, and who performed them. This allows live analysis of changes via log monitoring tools, and post incident review for changes.

However, this does not currently capture attempts to modify the directory contents that are rejected. Rejected changes may reflect an attempt by an attacker or other potential security issues within the directory.

This feature will add the capability of audit logging failed or rejected changes.

At the same time, this may create a lot of noise in the audit log. We will add filtering to limit logging of audit events to definied conditions such as ldap error codes, subtrees, or object filters. 


Use Cases
---------

Logging of all sucessful changes to the directory.

Logging of all attempts to change the directory regardless of ldap status code. (IE rejection, no such object)

Filter logging of sucessful changes to a specific subtree.

Filter logging of all failed changes to entries matching specific ldap filters.

Filter logging of a specific ldap status code (IE rejection) on a security sensitive subtree.


Major configuration options and enablement
------------------------------------------

A current audit log configuration is:

    nsslapd-auditlog: log_dir/audit
    nsslapd-auditlog-mode: 600
    nsslapd-auditlog-maxlogsize: 100
    nsslapd-auditlog-logrotationtime: 1
    nsslapd-auditlog-logrotationtimeunit: day
    nsslapd-auditlog-logging-enabled: on

We would extend cn=config to add configuration of the pattern:

    dn: cn=audit,cn=config

    dn: cn=success,cn=audit,cn=config
    audit-response: LDAP_SUCCESS

    dn: cn=secure_group,cn=audit,cn=config
    audit-response: LDAP_ANY
    audit-filter: '(cn=secure_group)'

    dn: cn=users,cn=audit,cn=config
    audit-response: LDAP_NO_SUCH_OBJECT
    audit-scope: one
    audit-base: ou=people,dc=example,dc=com

    dn: cn=admins,cn=audit,cn=config
    audit-response: LDAP_INSUFFICIENT_ACCESS
    audit-response: LDAP_SUCCESS
    audit-scope: one
    audit-base: ou=people,dc=example,dc=com
    audit-filter: '(memberOf=cn=admins,ou=groups,dc=example,dc=com)'


The behaviour of the current audit log is emulated via the addition of the "audit-response: LDAP_SUCCESS" catch all. (See implementation section regarding upgrade)

The second example shows the filter syntax, that would log any change regardless of status that is attempted on objects with the attribute 'cn=secure_group'.

The third example would log changes that fail as they are attempting to alter non-existant objects under a specific subtree.

The fourth example shows the combination of all of these aspects, as well as a multi-valued definition of responses to log. These are considered to be a list of OR values.


Design
------

There are 4 locations in the DS code base that trigger writes to the audit log.

    ./ldap/servers/slapd/delete.c:342:                                      
    write_audit_log_entry(pb); /* Record the operation in the audit log */
    ./ldap/servers/slapd/modify.c:1065:                                     
    write_audit_log_entry(pb); /* Record the operation in the audit log */
    ./ldap/servers/slapd/modrdn.c:632:                                      
    write_audit_log_entry(pb); /* Record the operation in the audit log */
    ./ldap/servers/slapd/add.c:730:                                 
    write_audit_log_entry(pb); /* Record the operation in the audit log */

Surrounding all 4 calls to the write_audit_log_entry(pb) function the following code pattern exists.

    rc = (*be->be_add)(pb);
    ...

    if (rc == 0)
    {
        ...
        write_audit_log_entry(pb);
        ...
    } else {
        ...
    }

We would rewrite this to be:

    rc = (*be->be_add)(pb);
    ...
    write_audit_log_entry(pb);
    ...
    if (rc == 0)
    {
        ...
    } else {
        ...
    }

Then within write_audit_log_entry, the decision to log the event or not is evaluated. This will involve iterating through the audit logging configurations and evaluating each one to determine if the entry / entries being altered fit the filter candidate.

Entries when logged, the filtering configuration DN that matched them is listed in the event.

If one entry in a set of entries matches the filter, all entries changes will be audit logged.

If any one filtering condition is met, the event will be logged.

In the event of a filtering failure on the entry or change, the event must be logged and an error raised in the log.


Implementation
--------------

Audit logging code is often security sensitive, and required for forensic analysis after a security event. As a result, it is imperative that this code is well tested and operational.

lib389 should be extended to support montioring and interpretation of audit logs so that we can unit test this functionality extensively.

Documentation will need to be created for the Administration manuals for 389.


Updates and Upgrades
--------------------

On upgrade to continue emulation of the current audit logging configuration, will need to add the configuration:

    dn: cn=audit,cn=config

    dn: cn=success,cn=audit,cn=config
    audit-response: LDAP_SUCCESS

External Impact
---------------

The format of the audit log may change due to the potential addition of extra fields.


Author
------

<wibrown@redhat.com>
