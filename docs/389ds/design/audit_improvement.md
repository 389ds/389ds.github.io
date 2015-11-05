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

Major configuration options and enablement (single configuration design)
------------------------------------------------------------------------

A current audit log configuration is:

    nsslapd-auditlog: log_dir/audit
    nsslapd-auditlog-mode: 600
    nsslapd-auditlog-maxlogsize: 100
    nsslapd-auditlog-logrotationtime: 1
    nsslapd-auditlog-logrotationtimeunit: day
    nsslapd-auditlog-logging-enabled: on

We would add another set of options to mirror this such as:

    nsslapd-auditfailurelog: log_dir/audit-failure
    nsslapd-auditfailurelog-mode: 600
    nsslapd-auditfailurelog-maxlogsize: 100
    nsslapd-auditfailurelog-logrotationtime: 1
    nsslapd-auditfailurelog-logrotationtimeunit: day
    nsslapd-auditfailurelog-logging-enabled: on

We would then duplicate auditlog.c to auditfailurelog.c and update it to support various status codes != LDAP_SUCCESS. We would add another configuration item:

    nsslapd-auditfailurelog-status: STATUS

This would be multivalued, and would define that return codes to clients that we are auditing for.

This would not create a large performance hit as we are reducing the number of events for selection based on the status codes we recieve, and we are using the existing buffered log writing implementation, despite the large number of events that would potentially be processed.

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

This would be altered to be:

    rc = (*be->be_add)(pb);
    ...

    if (rc == 0)
    {
        ...
        write_audit_log_entry(pb);
        ...
    } else {
        ...
        write_auditfailure_log_entry(pb);
        ...
    }

NOTE: The name auditfailure is up for discussion, it's just an example.

Implementation
--------------

Audit logging code is often security sensitive, and required for forensic analysis after a security event. As a result, it is imperative that this code is well tested and operational.

lib389 should be extended to support montioring and interpretation of audit logs so that we can unit test this functionality extensively.

Documentation will need to be created for the Administration manuals for 389.

Updates and Upgrades
--------------------

No upgrade changes are required.

External Impact
---------------

The format of the audit log may change due to the potential addition of extra fields. We would like to add the bind dn that triggered the event, as well as the IP and connection details of the client that triggered the event.

Other Ideas
-----------

[Audit Future Ideas Discussion](audit_future_discussion.html)

Author
------

<wibrown@redhat.com>

