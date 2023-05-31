---
title: "Howto: Persistent Searches"
---

# Persistent Searches
-----------------

Persistent search is mechanism extending LDAP search operation with ability to track changes in the directory. Client remains connected to the server after "normal" search operation is finished and server provides additional results as data in directory changes. Persistent search has been proposed as [internet draft](http://www3.ietf.org/proceedings/01mar/I-D/ldapext-psearch-03.txt). More information can be found on [Novell eDirectory documentation](http://www.novell.com/documentation/ndsedir86/index.html?page=/documentation/ndsedir86/taoenu/data/acl2ehr.html) website.

### Usage examples

Persistent search is supported by ldapsearch utility but it is not mentioned in documentation. Use

    shared/bin/ldapsearch -H    

and look for option -C. It can be used like this:

    shared/bin/ldapsearch -r -C PS:any -b dc=example,dc=com objectclass=person    

The -r option makes ldapsearch output unbuffered, so you see the results right away.

Persistent search is also supported by the [Net::LDAP API](http://ldap.perl.org). This is slightly modified example from Net::LDAP documentation:

     #!/usr/bin/perl
     use Net::LDAP;
     use Net::LDAP::Control)::PersistentSearch;
     use Net::LDAP::LDIF)
     $ldap = Net::LDAP->new( "ldap.example.com" );
     $persist = Net::LDAP::Control::PersistentSearch->new( changeTypes => 15,
                                                           changesOnly => 1,
                                                           returnECs => 1 );
     $srch = $ldap->search( base     => "dc=example,dc=com",
                            filter   => "(objectClass=person)",
                            callback => \&process_entry, # call for each entry
                            control  => [ $persist ] );
     die "error: ",$srch->code(),": ",$srch->error()  if ($srch->code());
     sub process_entry {
       my $message = shift;
       my $entry = shift;
       print $entry->dn()."\n";  #output entry DN
       $ldif = Net::LDAP::LDIF->new( "", "w", onerror => 'undef');
       $ldif->write_entry ($entry); #output entry in LDIF
       $ldif->done ( );
     }
