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

Log the bind dn and IP into the audit log for events.

Logging of all attempts to change the directory regardless of ldap status code. (IE rejection, no such object)

Filter logging of sucessful changes to a specific subtree.

Filter logging of all failed changes to entries matching specific ldap filters.

Filter logging of a specific ldap status code (IE rejection) on a security sensitive subtree.

Major configuration options and enablement (multiple configuration design)
--------------------------------------------------------------------------

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

    dn: cn=success,cn=audit,cn=config
    audit-response: !LDAP_SUCCESS

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

The second example shows how we can use a ! as a not LDAP_SUCCESS, in other words, all failures to make a change.

The third example shows the filter syntax, that would log any change regardless of status that is attempted on objects with the attribute 'cn=secure_group'.

The fourth example would log changes that fail as they are attempting to alter non-existant objects under a specific subtree.

The fifth example shows the combination of all of these aspects, as well as a multi-valued definition of responses to log. These are considered to be a list of OR values.

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

Plugin
------

A discussion point was raised about the possibility of moving this out to a plugin rather than in server core. This adds quite a large amount of complexity. We do not advice the plugin is a suitable solution.

First, the plugin would need a way to write to the disk without blocking events in the operation thread. Without a helper thread or something in the core this would be extremely troublesome to implement.

Additionally, at this point, certain parts of the core DS instance rely on being able to interact with logging handlers, for example the disk space monitoring system. This would mean the core depends (optionally) on a plugin, and the plugin would need to interact potentially heavily with the core ds. This alone signals that the system should be part of the core ns-slapd instance.

A point was raised that the plugin would be easier to disable, yet we already have nsslapd-auditlog-enabled: [true or false]. This is sufficient for our needs.

In summary, a plugin form of this, would be more complex to implement, and would not yield signifigant benefits.


Implementation
--------------

Audit logging code is often security sensitive, and required for forensic analysis after a security event. As a result, it is imperative that this code is well tested and operational.

lib389 should be extended to support montioring and interpretation of audit logs so that we can unit test this functionality extensively.

Documentation will need to be created for the Administration manuals for 389.

Updates and Upgrades
--------------------

On upgrade to continue emulation of the current audit logging configuration, will need to add the configuration in the multiple configuration design:

    dn: cn=audit,cn=config

    dn: cn=success,cn=audit,cn=config
    audit-response: LDAP_SUCCESS

Future Goals
------------

Add the ability to log out to unique audit log files per-configuration item.

Author
------

<wibrown@redhat.com>

