---
title: "Scripts"
---

# Scripts
---------

###  OpenLDAP Helper Scripts

[ol2rhds.pl]({{ site.baseurl }}/binaries/ol2rhds.pl) -  This script should convert OpenLDAP schemas to RHDS/FDS schema and it will (hopefully) order things according to RFC 2252.  Apparently RHDS/FDS is really strict about the order folling the RFC, where OpenLDAP isn't.

[ol-macro-expand.pl]({{ site.baseurl }}/binaries/ol-macro-expand.pl) - Expands OpenLDAP schema OID macros

[ol-schema-migrate.pl]({{ site.baseurl }}/binaries/ol-schema-migrate.pl) - Convert OpenLDAP schema files into Fedora DS format with RFC2252 compliant printing

[openLDAP2Fedora.pl]({{ site.baseurl }}/binaries/openLDAP2Fedora.pl) - Converts the userpassword value from an OpenLDAP LDIF file and writes a new LDIF file for use in 389 DS.

[openldap_response_time.pl]({{ site.baseurl }}/binaries/openldap_response_time.pl) - Script designed for cacti <http://www.cacti.net>  Gives the time to do these LDAP operations: bind, RootDSE, and suffix (found in RootDSE)

<br>

### 389 Directory Server Utility Scripts

Coming soon...

