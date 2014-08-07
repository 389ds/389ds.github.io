---
title: "Howto: OpenLDAPMigration"
---

# Migrating from OpenLDAP to 389 Directory Server
--------------------------------------------------

{% include toc.md %}

### All In One

[LdapImport](http://wiki.babel.com.au/index.php?area=Linux_Projects&page=LdapImport) is a script which can be used to migrate data and schema from OpenLDAP into Fedora DS.

### Schema

The schema is in a slightly different format. Fedora DS uses a strict RFC 2252 and LDIF format while OpenLDAP is slightly different. In OpenLDAP, the attribute type definition begins with "attributetype" while in Fedora DS it begins with "attributetypes:". In OpenLDAP, the objectclass definition begins with "objectclass" while in Fedora DS it begins with "objectclasses:". Continuation lines in OpenLDAP may have more than one space but Fedora DS follows the LDIF convention that the continuation line begins with a single space character. Other than that, the actual text of the schema definition is the same.

[Here](http://directory.fedoraproject.org/download/ol2rhds.pl) is a script that handles the RFC 2252 strictness when converting schema.

The perl script ol-schema-migrate.pl [here](http://www.netauth.com/~jacksonm/ldap/ol-schema-migrate.pl) or [here](http://directory.fedoraproject.org/download/ol-schema-migrate.pl) will convert the schema and also nicely format the schema definitions.

[This](http://directory.fedoraproject.org/download/ol-macro-expand.pl) script will recursively expand the OID macro format used in OpenLDAP schema files. The following Perl script may also be helpful:

    <nowiki>
    #!/usr/bin/perl -w
    #
    # this is a quick perl script to convert OpenLDAP schema files
    # to FDS ldif (schema) files.  it is probably not anywhere near
    # useful, but it did allow me to convert a few of my .schema
    # files and have FDS successfully start with them.
    #
    # -Nathan Benson <tuxtattoo@gmail.com>
    #

    use strict;

    die "usage: $0 <openldap.schema>\n" unless my $file = $ARGV[0];
    die "$! '$file'\n" unless -e $file;

    my $start;

    print "dn: cn=schema\n";

    open SCHEMA, $file;
    while (<SCHEMA>)
    {
            next if /^(#|$)/;


            if (/^(objectclass|attributetype)\s/i)
            {
                    print "\n" if ($start);
                    chomp;


                    $_     =~ s/^objectclass/objectclasses:/i;
                    $_     =~ s/^attributetype/attributetypes:/i;
                    $_     =~ s/(\t|\s)/ /;


                    $start = 1;
                    print;
            }
            elsif ((/^\s*\w/) && ($start))
            {
                    chomp;
                    $_     =~ s/^(\s*)/ /;
                    print;
            }
    }
    close SCHEMA;
    </nowiki>

