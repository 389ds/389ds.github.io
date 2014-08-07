---
title: "Howto: Ldap Search Size Limit"
---

# LDAP Search Size Limit
------------------------

Why do I get this error message "ldap\_search: Administrative limit exceeded"
-----------------------------------------------------------------------------

Anonymous binds will only return a limit of a 1000 entries by default, this is a security mechanism to avoid simple deny of service attacks. This applies to cli tools as well as the java console.

The error logs will return the following string:

    "ldap_search: Administrative limit exceeded"    

When using the cli with ldapsearch, you can use the -z option when binding as the root DN.

In the access logs, as per described into

[http://www.redhat.com/docs/manuals/dir-server/cli/log.htm](http://www.redhat.com/docs/manuals/dir-server/cli/log.htm)

    - Error 4 for SIZE_LIMIT_EXCEEDED
    - Error 11 ADMIN_LIMIT_EXCEEDED (LDAP v3)

Example:

    [<some-time-stamp>] conn=1 op=51 RESULT err=4 tag=101 nentries=1000 etime=2 notes=U
    [<some-time-stamp>] conn=59 op=0 RESULT err=11 tag=101 nentries=1002 etime=1 notes=U

If you need to return more than a 1000 entries, it is suggested to create a special dedicated user and bind as this user (directory manager will get more than the default limit)

See the documentation or the FAQ for nsslapd-lookthroughlimit and nsslapd-sizelimit.
