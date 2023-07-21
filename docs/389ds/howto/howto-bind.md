---
title: "Howto:BIND"
---

# Using BIND
------------

{% include toc.md %}

Introduction
------------

Getting BIND to directly talk to LDAP can be the stuff of nightmares.

Rather I describe a compromise which works as follows:

-   The DNS Domains and DNS Entries are stored in LDAP
-   At a interval of your choosing (I used 5 minutes) the DNS entries are converted into zone files.
-   named is reloaded

This is relatively easy to setup, but obviously there is a \<=5 minute delay between you adding an entry to LDAP, and the DNS entry being known to *named*.

(If you run Samba, you are then in a position to use the *wins hook* option and have a script which add's the client's wins registrations directly to ldap, and hence allow name resolution between many subnets.)

Details
-------

To implement this solution, the following things need to happen:

-   download and compile the *ldap2dns* tool
-   Obtain the correct schema for ''ldap2dns' and give this to FDS.
-   Define your domains in ldap
-   Write a very short script which run's *ldap2dns* and */etc/init.d/named reload*

### Download and compile ldap2dns

-   Ensure you have the openldap-devel libraries on your system
-   Download the ldap2dns tarball from [here](http://freshmeat.net/projects/ldap2dns/)
-   Extract and compile in the normal linux fashion (tar -zxvf , make, make install)

### Installing the schema

-   ldap2dns comes with a schema in ldif format. HOWEVER, if you convert it you will find it doesn't work! It will cause 389 DS to fail to load.
-   [94ldap2dns.ldif](../tools/94ldap2dns-dot-ldif) is a link to a schema which I corrected; this should be placed in the /opt/fedora/slapd-<hostname>/config/schema directory. (If you have another schema starting "94" rename to an unused number.)
-   Restart FDS, and check the /logs/errors file to be sure that the schema has loaded.
-   Don't proceed until FDS is happy with the schema!

### Define your domains in LDAP

-   Now you are ready for some DNS entries.
-   I found it simplest to have an "ou=DNS" in the root of my directory, containing the domains and entries.
-   I use the LdapAdmin (windows) program for this sort of thing.
-   All these examples assume the DNS entries are being stored in ou=DNS,dc=example,dc=com
-   So, to create a dns zone for *foobar.com*, create the following entry:

        dn: cn=foobar.com,ou=DNS,dc=example,dc=com
        dnszonename: foobar.com
        dnsclass: IN
        dnstype: SOA
        dnszonesupplier: tim.foobar.com
        dnsadminmailbox: tim.foobar.com
        dnsminimum: 3600
        objectClass: dnszone
        cn: foobar.com
        dnsserial: 12345
        dnsrefresh: 10800
        dnsretry: 3600
        dnsexpire: 3600

-   The zone entries are stored under this entry, and the attributes are used like this:

        [dnsdomainname]     [dnsclass] [dnstype] [dnspreference]    [[dnsipaddr] | [dnscname]]
         www                IN          A                            192.168.50.50
                            IN          MX       10                                 mail.foobar.com.

-   Remember that all domains need at least one NS record. [Here is a complete example for foobar.com](Here is a complete example for foobar.com "wikilink")
-   Note that the cn of the domain entries can be anything, what matters is the dnsdomainname attribute.
-   Reverse zones can be tricky at first - [here is an example for 0.0.10.in-addr.arpa](here is an example for 0.0.10.in-addr.arpa "wikilink")

### Turning the ldap information into zone files

-   The magic command is:

        ldap2dns -b "ou=DNS,dc=example,dc=com" -o db -h localhost

-   Observe that this creates a zone file for each domain it finds in ou=DNS, and also creates a *named.zones* file containing an appropriate named config file.
-   Create the following script in /usr/local/bin/ , I call mine *updatedns*. (The named.zones file contains an annoying comment which named doesn't like, so is filtered out)

        cd /var/named/chroot/var/named
        logger "Updating DNS from ldap..."
        ldap2dns -b "ou=DNS,dc=example,dc=com" -o db -h localhost

        #modify the named.zones file, as named doesn't like the comment!

        cat named.zones | grep -v "^; Auto" > named.zones.corrected
        /etc/init.d/named reload
        logger "Updated DNS from ldap"

-   That may need adjusting to suit your distribution, in particular if your named doesn't run chroot'd

-   Add the following line to your */etc/named.conf* so these zone db files are loaded by named:

        include "/var/named/named.zones.corrected";

-   Restart named, run *updatedns* and you should be able to query your ldap zones
-   Schedule a cron job to run /usr/local/bin/updatedns as often as you see fit

