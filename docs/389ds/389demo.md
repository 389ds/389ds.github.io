---------
title: "DS Handoff for RHEL 9.2"
---------

## RFE's
----------

### Log Compression

    # dsconf slapd-localhost config replace nsslapd-accesslog-compress=on nsslapd-accesslog-logrotationtimeunit=minute nsslapd-accesslog-maxlogsize=1
    # ldclt -h localhost -p 389 -b 'dc=example,dc=com' -e esearch -f '(objectClass=*)'
    # ls -l /var/log/dirsrv/slapd-localhost/access*
    # cat /var/log/dirsrv/slapd-localhost/access.rotationinfo


### Security Audit Log

<https://www.port389.org/docs/389ds/design/security-audit-log-design.html>

    # ldapsearch -xLLL  -H ldap://localhost:389 -D "uid=mreynolds,ou=people,dc=example,dc=com" -w WRONG -s base -b ""
    # ldapsearch -xLLL  -H ldap://localhost:389 -D "uid=DOES_NOT_EXIST,ou=people,dc=example,dc=com" -w password -s base -b ""
    # vi /var/log/dirsrv/slapd-localhost/security

### Full DN Case Preserved

<https://www.port389.org/docs/389ds/design/store-case-sensitive-dn-design.html>

    # ldapsearch -xLLL -b dc=example,dc=com uid=mreynolds -H ldap://localhost:389 dn
    # dsconf slapd-localhost config replace nsslapd-return-original-entrydn=off
    # dsctl localhost restart   --> to clear entry cache
    # ldapsearch -xLLL -b dc=example,dc=com uid=mreynolds -H ldap://localhost:389 dn


### Audit Log Identifying Entry Attributes

<https://www.port389.org/docs/389ds/design/audit-log-entry-attrs-design.html>

    # dsconf localhost config replace nsslapd-auditlog-logging-enabled=on
    # dsconf localhost config replace nsslapd-auditlog-display-attrs=cn
    # dsidm localhost -b dc=example,dc=com user modify 123456789 replace:description:new
    # vi /var/log/dirsrv/slapd-localhost/audit


### Password Policy Debug level (RHDS only)

    # dsconf localhost config replace passwordchecksyntax=on 
    # dsconf localhost config replace nsslapd-errorlog-level=1048576
    # ldapmodify -D "uid=mreynolds,ou=people,dc=example,dc=com" -H ldap://localhost:389 -w Secret123
dn: uid=mreynolds,ou=people,dc=example,dc=com
replace: userpassword
userpassword: 2short

    # vi /var/log/dirsrv/slapd-localhost/errors


### Extend log of operations statistics in access log

<https://www.port389.org/docs/389ds/design/log-operation-stats.html>

    # dsconf localhost config replace nsslapd-accesslog-logbuffering=off
    # dsconf localhost config replace nsslapd-statlog-level=1
    # ldapsearch -xLLL -b dc=example,dc=com uid=mreyn* -H ldap://localhost:389 dn
    # ldapsearch -xLLL -b dc=example,dc=com uid=mreynolds -H ldap://localhost:389 dn
    # vi /var/log/dirsrv/slapd-localhost/access

    



