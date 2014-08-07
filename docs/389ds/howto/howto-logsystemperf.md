---
title: "Howto:LogSystemPerf"
---

# DS Logging and System Performance
-----------------------------------

Do I need to turn off access log to improve system performance
--------------------------------------------------------------

If your server generates several dozens of mega bytes of logs per hour, although the system is designed for minimal impact of processing and disk i/o's, depending of your system resources, it may be recommended to disable access logging in some situations.

Turning on the access log buffering is expected to improve performances:

[nsslapd-accesslog-logbuffering (Log Buffering)](http://www.redhat.com/docs/manuals/dir-server/cli/config.htm#pgfId-17719)

When set to off, the server writes all access log entries directly to disk.

    Entry DN: cn=config    
    Valid Values: on | off    
    Default Value: on    
    Syntax: DirectoryString    
    Example: nsslapd-accesslog-logbuffering: off    

Example:

    /opt/fedora-ds/shared/bin/ldapsearch -D "cn=directory manager" -w <some-pw> -s base -b cn=config cn=config nsslapd-accesslog-logbuffering
    version: 1
    dn: cn=config
    nsslapd-accesslog-logbuffering: on

    /opt/fedora-ds/shared/bin/ldapmodify -D "cn=directory manager" -w <some-pw>
    dn: cn=config
    changetype: modify
    replace: nsslapd-accesslog-logbuffering
    nsslapd-accesslog-logbuffering: off

    /opt/fedora-ds/shared/bin/ldapsearch -D "cn=directory manager" -w <some-pw> -s base -b cn=config cn=config nsslapd-accesslog-logbuffering
    version: 1
    dn: cn=config
    nsslapd-accesslog-logbuffering: off
