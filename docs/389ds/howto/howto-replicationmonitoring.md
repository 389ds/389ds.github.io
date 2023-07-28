---
title: "Howto:ReplicationMonitoring"
---

# Replication Monitoring
------------------------

{% include toc.md %}

### Introduction

Ok, so you have Multi-Supplier-Replication set up and working, perhaps using the mmr.pl script as described in <Howto:MultiSupplierReplication> . It is useful to be able to monitor replication from a bash environment, allowing you to:

-   Perform custom actions if replication fails, possibly alerting you.
-   Provide a custom web page tailored to your environment showing replication status.

DISCLAIMER - I'm not a bash or perl expert, and usually settle for the first method which seems to work! Corrections by experts are welcomed.

#### Documentation

[This document](http://www.redhat.com/docs/manuals/dir-server/cli/8.0/Configuration_Command_File_Reference-Core_Server_Configuration_Attributes_Reference-Replication_Attributes_under_cnReplicationAgreementName_cnreplica_cnsuffixName_cnmapping_tree_cnconfig.html) describes the attributes and values returned by the searches below.

### Background

The basic concept is querying the *cn=config* branch, for any objects of class 'nsDS5ReplicationAgreement '

Most Basic Example
------------------

Assuming you have the openldap-clients package installed, this example shows the concept in action (all one line):

    [root@blob~]# ldapsearch -x -b "cn=mapping tree,cn=config" -D "cn=Directory Manager" -w  YOURPASSWORD objectClass=nsDS5ReplicationAgreement -LL

That will return a lot of information about replication agreements defined on the local server.

Example 2
---------

Run a command if replication isn't working. (This is a very quick and dirty way of doing this!)

    [root@blob]# ldapsearch -x -b "cn=mapping tree,cn=config" -D "cn=Directory Manager" -w YOURPASSWORD 
      objectClass=nsDS5ReplicationAgreement nsds5replicaLastUpdateStatus -LL 
        | grep "nsds5replicaLastUpdateStatus"
        | grep -v "Status: 0"
       && echo "something is wrong"

This finds lines containing nsds5replicaLastUpdateStatus, then finds lines within them that don't have "Status: 0" in them, and if there are any run echo command, which could clearly be anything else.

Something like this could run as a cron script and email you if replication fails.

Example 3 - display replication status on a web page
----------------------------------------------------

If you have perl-LDAP installed, this example is much more useful:

     #!/usr/bin/perl -w
     
     use Net::LDAP;
     use strict;
     print "Content-type: text/html\n\n";
     
     #BIND INFORMATION, and SEARCH BASE
     my $user = "CN=Directory Manager";
     my $passwd = "YOURPASSWORD";
     my $base = "cn=config";
     
     #Attributes
     my $server="nsDS5ReplicaHost";
     my $status="nsds5replicaLastUpdateStatus";
     my $laststart="nsds5replicaLastUpdateStart";
     my $lastend="nsds5replicaLastUpdateEnd";
     
     
     #connect to ldap server
     my $ldap=ConnectLdap(); 
     
     my $result=LDAPSearch($ldap,"objectClass=nsDS5ReplicationAgreement","",$base);
     
     my @entries = $result->entries;
     print "<table>";
     print "<tr><td>Server</td><td>Status</td><td>Last Started</td><td>Last Ended</td></tr>";
     my $entr;
     foreach $entr ( @entries ) {
            my $servername=$entr->get_value($server);
            my $serverstatus=$entr->get_value($status);
     
            my $serverlaststart=$entr->get_value($laststart);
            my $serverlastend=$entr->get_value($lastend);
     
            $serverlaststart =~ s/(....)(..)(..)(..)(..)(..)./$1-$2-$3\ $4:$5:$6/;
            $serverlastend =~ s/(....)(..)(..)(..)(..)(..)./$1-$2-$3\ $4:$5:$6/;
     
            print "<tr>";
            print "<td>$servername</td><td>$serverstatus</td><td>$serverlaststart</td>";
            print "<td>$serverlastend</td>";
            print "\n";
            print "</tr>";
     }
     print "</table>";
     exit;
     
     sub ConnectLdap {
     
         my $ldap = Net::LDAP->new ( "127.0.0.1" ) or die "$@";
     
         my $mesg = $ldap->bind ( "$user", password => "$passwd" , version => 3 );
         $mesg->code && warn "error: ", $mesg->error;
         return $ldap;
     }

     sub LDAPSearch
     {
        my ($ldap,$searchString,$attrs,$base) = @_; 

        my $result = $ldap->search ( base    => "$base",
                                    scope   => "sub",
                                    filter  => "$searchString",
                                    attrs   =>  $attrs
                                  );
     }

Placing that in a cgi-bin directory would allow you to monitor replication very easily.

Monitoring replication with Nagios
----------------------------------

Here is a nagios plugin based on the source above to monitor replication directly from Nagios.

    #!/usr/bin/perl -w

     use Net::LDAP;
     use strict;
     use Getopt::Long;

    # Nagios codes
     my %ERRORS=('OK'=>0, 'WARNING'=>1, 'CRITICAL'=>2, 'UNKNOWN'=>3, 'DEPENDENT'=>4);

     my $ldapserver;
     my $user;
     my $passwd;

     GetOptions(
             'host=s' => \$ldapserver,
             'user=s' => \$user,
             'password=s' => \$passwd,
             'help' => sub { &usage(); },
     );


    &nagios_return("UNKNOWN", "[1] --host not specified") if (!$ldapserver);
    &nagios_return("UNKNOWN", "[1] --user not specified") if (!$user);
    #
     #BIND INFORMATION, and SEARCH BASE
     my $base = "cn=config";

     #Attributes
     my $server="nsDS5ReplicaHost";
     my $status="nsds5replicaLastUpdateStatus";
     my $laststart="nsds5replicaLastUpdateStart";
     my $lastend="nsds5replicaLastUpdateEnd";


     #connect to ldap server
     my $ldap=ConnectLdap();

     my $result=LDAPSearch($ldap,"objectClass=nsDS5ReplicationAgreement","",$base);

     my @entries = $result->entries;
     my $entr;

     my $maxstatcode = 0;
     
     foreach $entr ( @entries ) {
            my $servername=$entr->get_value($server);
            my $serverstatus=$entr->get_value($status);

            my $serverlaststart=$entr->get_value($laststart);
            my $serverlastend=$entr->get_value($lastend);
            my $statuscode = $entr->get_value($status);

            $serverlaststart =~ s/(....)(..)(..)(..)(..)(..)./$1-$2-$3\ $4:$5:$6/;
            $serverlastend =~ s/(....)(..)(..)(..)(..)(..)./$1-$2-$3\ $4:$5:$6/;
            $statuscode =~ s/(^[-0123456789]+) (.*$)/$1/;
            print "Replication to $servername last operation $serverlaststart ";
            print "Status: $serverstatus.\n";
            if ($statuscode)
            {
                &nagios_return("ERROR", "Replication error: " . $serverstatus);
            }

     }
     &nagios_return("OK", "All replicats are OK");

     exit;

     sub ConnectLdap {

       my $ldap = Net::LDAP->new ( $ldapserver ) or die "$@";

       my $mesg = $ldap->bind ( "$user", password => "$passwd" , version => 3 );
       # $mesg->code && warn "error: ", $mesg->error;
       if ($mesg->code)
       {
         &nagios_return("CRITICAL", "Failed to connect to LDAP: " . $mesg->error . " with user $user.");
       }
       return $ldap;
     }

     sub LDAPSearch
     {
        my ($ldap,$searchString,$attrs,$base) = @_;

        my $result = $ldap->search ( base    => "$base",
                                    scope   => "sub",
                                    filter  => "$searchString",
                                    attrs   =>  $attrs
                                  );
     }

     sub nagios_return($$) {
            my ($ret, $message) = @_;
            my ($retval, $retstr);
            if (defined($ERRORS{$ret})) {
                    $retval = $ERRORS{$ret};
                    $retstr = $ret;
            } else {
                    $retstr = 'UNKNOWN';
                    $retval = $ERRORS{$retstr};
                    $message = "WTF is return code '$ret'??? ($message)";
            }
            $message = "$retstr - $message\n";
            print $message;
            exit $retval;
     }

     sub usage() {
        print("Emmanuel BUU <emmanuel.buu\@ives.fr> (c) IVÃ¨S 2008
        http://www.ives.fr/

      --host=<host>   Hostname or IP address to connect to.

      --user=<user>
      --password=<password>

      --help          Guess what ;-)");
    }

--[Neutrino38](User:Neutrino38 "wikilink") 18:07, 12 September 2008 (EDT),

Conclusion
----------

It is fairly simple to obtain replication status from bash or perl, and the above examples could be extended to perform actions if replication was not working.

