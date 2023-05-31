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

At the same time, this may create a lot of noise in the audit log. We may add filtering to limit logging of audit events to definied conditions such as ldap error codes, subtrees, or object filters. 


Use Cases
---------

Logging of all sucessful changes to the directory. This is the current behaviour.

Log the bind dn and IP into the audit log for events.

Logging of all attempts to change the directory regardless of ldap status code. (IE rejection, no such object). Log the rejection code.

Major configuration options and enablement (single configuration design)
------------------------------------------------------------------------

A current simple audit log configuration is:

    nsslapd-auditlog: log_dir/audit
    nsslapd-auditlog-mode: 600
    nsslapd-auditlog-maxlogsize: 100
    nsslapd-auditlog-logrotationtime: 1
    nsslapd-auditlog-logrotationtimeunit: day
    nsslapd-auditlog-logging-enabled: on

We would add another set of options to mirror this such as:

    nsslapd-auditfaillog: log_dir/audit-failure
    nsslapd-auditfaillog-mode: 600
    nsslapd-auditfaillog-maxlogsize: 100
    nsslapd-auditfaillog-logrotationtime: 1
    nsslapd-auditfaillog-logrotationtimeunit: day
    nsslapd-auditfaillog-logging-enabled: on

We would then update auditlog.c to support various status codes that are not LDAP_SUCCESS and the auditfaillog handlers. We would add another configuration item:

    nsslapd-auditfaillog-resultcode: STATUS

This would be multivalued, and would define that result codes to clients that we are auditing for. If not specified, we collect all not LDAP_SUCCESS codes.

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
        write_auditfail_log_entry(pb);
        ...
    }

The complete set of configuration options are:

    nsslapd-auditfaillog-maxlogsize
    nsslapd-auditfaillog-logrotationsync-enabled
    nsslapd-auditfaillog-logrotationsynchour
    nsslapd-auditfaillog-logrotationtime
    nsslapd-auditfaillog-logrotationtimeunit
    nsslapd-auditfaillog-logmaxdiskspace
    nsslapd-auditfaillog-logminfreediskspace
    nsslapd-auditfaillog-logexpirationtime
    nsslapd-auditfaillog-logexpirationtimeunit
    nsslapd-auditfaillog-logging-enabled
    nsslapd-auditfaillog-logging-hide-unhashed-pw
    nsslapd-auditfaillog
    nsslapd-auditfaillog-list

These take the same values and semantics as the auditlog options.

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

The format of the audit log has changed due to the addition of extra fields. This is an example of an audit/auditfail message:

    time: 20151111152800
    dn: uid=test,dc=example,dc=com
    result: 65   /* New field */
    changetype: modify
    replace: objectClass
    objectClass: account
    objectClass: posixGroup
    objectClass: simpleSecurityObject
    objectClass: top
    -

Note the result maps to the ldap result code, in this case 65 == 0x41
LDAP_OBJECT_CLASS_VIOLATION     0x41


Other Ideas
-----------

[Audit Future Ideas Discussion](audit_future_discussion.html)

Author
------

<wibrown@redhat.com>

