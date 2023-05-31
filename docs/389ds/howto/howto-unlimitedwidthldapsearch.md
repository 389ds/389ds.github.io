---
title: "Howto: Unlimited Line Width for LdapSearch"
---

# How do I set an unlimited line width for ldapsearch
---------------------------------------------------

You need to tune the line-width used to implement filter with long strings 'OU' in perl scripts, but shared/bin/ldapsearch only show an output of 80 chars max per line, including an attribute name, a semi column, and a carriage return.

You can disable line wrapping with the ldapsearch bundled with Fedora DS (cd /opt/fedora-ds/shared/bin ; ./ldapsearch), use the -T option. It will makes it easier to pass the output to scripts such as grep/sed/awk/perl without using a separate LDIF parser. The command line options are very similar to /usr/bin/ldapsearch from openldap, just omit the -x.

    -T          don't fold (wrap) long lines (default is to fold)    

Example:

    /opt/fedora-ds/shared/bin/ldapsearch -b dc=mstest uid=guest2018 sn    
    version: 1    
    dn: uid=guest2018,ou=People,dc=mstest    
    sn: guest2018-MoreThan80chars-0123456789-0123456789-0123456789-0123456789-0123    
     456789-0123456789-0123456789-0123456789-0123456789-0123456789    

    /opt/fedora-ds/shared/bin/ldapsearch -T -b dc=mstest uid=guest2018 sn    
    version: 1    
    dn: uid=guest2018,ou=People,dc=mstest    
    sn: guest2018-MoreThan80chars-0123456789-0123456789-0123456789-0123456789-0123456789-0123456789-0123456789-0123456789-0123456789-0123456789    
