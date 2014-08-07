---
title: "Howto: Solaris Client"
---

# How to get Solaris to work with 389 Directory Server
------------------------------------------------------

{% include toc.md %}

Basic Information
-----------------

This [document](http://web.singnet.com.sg/~garyttt/Configuring%20Solaris%20Native%20LDAP%20Client%20for%20Fedora%20Directory%20Server.htm) describes, in great detail, how to get Solaris 8 to work with Fedora Directory Server.

Setting up a Solaris native client has a lot of steps, but I didn't find it particularly difficult, and I was happy that I didn't need to mess with building openldap libraries to get things going. Here's what I did on a solaris 9 box.

For Solaris 10, here is some information about how to set up SSL LDAP clients: <http://forum.sun.com/jive/thread.jspa?forumID=13&threadID=101250>

-   Get a console session opened up as root, minimize the window and leave that session alone. This will serve as an emergency window in the event that you do something that makes it otherwise impossible for you to log into the machine.
-   Put your ldap servers in your /etc/hosts file.
-   Make sure your /etc/defaultdomain file is correct. For LDAP, it takes the defaultdomain and breaks it up into dc components, and uses that as a default search base. If you're still relying on nis as well, your nis domain MUST be the same.
-   Import the duaconfigprofile schema into FDS. I used the perl script on the FDS doc site to create the rfc-compliant LDIF for FDS. Mine is copied here straight from my (working!) FDS server/Solaris client setup. Note that it has been altered for readability! Each attributetype: definition takes up a SINGLE LINE in the schema. Make sure the new objectclasses show up in the admin console in the "schema" section after you do the import and restart slapd!

### DUAConfigProfile Schema

Schema is now in the version control system - <http://cvs.fedoraproject.org/viewvc/ldapserver/ldap/schema/60rfc4876.ldif?revision=1.1&root=dirsec&view=markup>

    # 60rfc4876.ldif - Updated from draft-joslin-config-schema    
    ################################################################################    
    #    
    dn: cn=schema    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.0    
     NAME 'defaultServerList'    
     DESC 'List of default servers'    
     EQUALITY caseIgnoreMatch    
     SUBSTR caseIgnoreSubstringsMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.15    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.1    
     NAME 'defaultSearchBase'    
     DESC 'Default base for searches'    
     EQUALITY distinguishedNameMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.12    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.2    
     NAME 'preferredServerList'    
     DESC 'List of preferred servers'    
     EQUALITY caseIgnoreMatch    
     SUBSTR caseIgnoreSubstringsMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.15    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.3    
     NAME 'searchTimeLimit'    
     DESC 'Maximum time an agent or service allows for a search to complete'    
     EQUALITY integerMatch    
     ORDERING integerOrderingMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.4    
     NAME 'bindTimeLimit'    
     DESC 'Maximum time an agent or service allows for a bind operation to complete'    
     EQUALITY integerMatch    
     ORDERING integerOrderingMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.5    
     NAME 'followReferrals'    
     DESC 'An agent or service does or should follow referrals'    
     EQUALITY booleanMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.7    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.6    
     NAME 'authenticationMethod'    
     DESC 'Identifies the types of authentication methods either used, required, or provided by a service or peer'    
     EQUALITY caseIgnoreMatch    
     SUBSTR caseIgnoreSubstringsMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.15    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.7    
     NAME 'profileTTL'    
     DESC 'Time to live, in seconds, before a profile is considered stale'    
     EQUALITY integerMatch    
     ORDERING integerOrderingMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.9    
     NAME 'attributeMap'    
     DESC 'Attribute mappings used, required, or supported by an agent or service'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.10    
     NAME 'credentialLevel'    
     DESC 'Identifies type of credentials either used, required, or supported by an agent or service'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.11    
     NAME 'objectclassMap'    
     DESC 'Object class mappings used, required, or supported by an agent or service'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.12    
     NAME 'defaultSearchScope'    
     DESC 'Default scope used when performing a search'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.13    
     NAME 'serviceCredentialLevel'    
     DESC 'Specifies the type of credentials either used, required, or supported by a specific service'    
     EQUALITY caseIgnoreIA5Match    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
     )    
    #    
    ################################################################################    
    # This was 1.3.6.1.4.1.11.1.3.1.1.8 in the draft    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.14    
     NAME 'serviceSearchDescriptor'    
     DESC 'Specifies search descriptors required, used, or supported by a particular service or agent'    
     EQUALITY caseExactMatch    
     SUBSTR caseExactSubstringsMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.15    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.15    
     NAME 'serviceAuthenticationMethod'    
     DESC 'Specifies types authentication methods either used, required, or supported by a particular service'    
     EQUALITY caseIgnoreMatch    
     SUBSTR caseIgnoreSubstringsMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.15    
     )    
    #    
    ################################################################################    
    #    
    attributeTypes: (    
     1.3.6.1.4.1.11.1.3.1.1.16    
     NAME 'dereferenceAliases'    
     DESC 'Specifies if a service or agent either requires, supports, or uses dereferencing of aliases.'    
     EQUALITY booleanMatch    
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.7    
     SINGLE-VALUE    
     )    
    #    
    ################################################################################    
    #    
    objectClasses: (    
     1.3.6.1.4.1.11.1.3.1.2.5    
     NAME 'DUAConfigProfile'    
     DESC 'Abstraction of a base configuration for a DUA'    
     SUP top    
     STRUCTURAL    
     MUST ( cn )    
     MAY ( defaultServerList $ preferredServerList $ defaultSearchBase $ defaultSearchScope $ searchTimeLimit $ bindTimeLimit $ credentialLevel $ authenticationMethod $ followReferrals $ dereferenceAliases $ serviceSearchDescriptor $ serviceCredentialLevel $ serviceAuthenticationMethod $ objectclassMap $ attributeMap $ profileTTL )    
     )    

-   I also found that I had to import the following schema in order to have my client successfully find the profile on the FDS server. This could be due to the fact that I'm also binding to a NIS domain on my Solaris clients. If you tail your access log and see your client searching for a nisdomainobject, import this schema into FDS. Note that this schema is now in the version control system - <http://cvs.fedoraproject.org/viewvc/ldapserver/ldap/schema/60nis.ldif?revision=1.1&root=dirsec&view=markup>

        dn: cn=schema
        attributetypes: ( 1.3.6.1.1.1.1.28 NAME 'nisPublickey' 
        DESC 'nisPublickey'
        EQUALITY caseIgnoreIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 1.3.6.1.1.1.1.29 NAME 'nisSecretkey'
        DESC 'nisSecretkey'
        EQUALITY caseIgnoreIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 1.3.6.1.4.1.1.1.1.12 SUP name NAME 'nisDomain'
        DESC 'NIS domain'
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 2.16.840.1.113730.3.1.30 NAME 'mgrpRFC822MailMember'
        DESC 'mgrpRFC822MailMember'
        EQUALITY caseIgnoreIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 1.3.6.1.4.1.42.2.27.1.1.12 NAME 'nisNetIdUser'
        DESC 'nisNetIdUser'
        EQUALITY caseExactIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 1.3.6.1.4.1.42.2.27.1.1.13 NAME 'nisNetIdGroup'
        DESC 'nisNetIdGroup'
        EQUALITY caseExactIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        attributetypes: ( 1.3.6.1.4.1.42.2.27.1.1.14 NAME 'nisNetIdHost'
        DESC 'nisNetIdHost'
        EQUALITY caseExactIA5Match
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
        objectclasses: ( 1.3.6.1.1.1.2.14 NAME 'NisKeyObject'
        DESC 'NisKeyObject' SUP top
        MUST ( cn $ nisPublickey $ nisSecretkey )
        MAY ( uidNumber $ description ) )
        objectclasses: ( 1.3.1.6.1.1.1.2.15 NAME 'nisDomainObject'
        DESC 'nisDomainObject' SUP top AUXILIARY
        MUST ( nisDomain ) )
        objectclasses: ( 2.16.840.1.113730.3.2.4 NAME 'mailGroup'
        DESC 'mailGroup' SUP top
        MUST ( mail )
        MAY ( cn $ mgrpRFC822MailMember ) )
        objectclasses: ( 1.3.6.1.4.1.42.2.27.1.2.6 NAME 'nisNetId'
        DESC 'nisNetId' SUP top
        MUST ( cn )
        MAY ( nisNetIdUser $ nisNetIdGroup $ nisNetIdHost ) )
    

-   On the ldap server in admin console (or not, if you know what you're doing), open the top level entry of your tree (ie, 'dc=example,dc=com'), and add the nisdomainobject objectclass, \*and then\* the nisDomain attribute.
    -   Select the objectclass attribute
    -   Press the Add Value button
    -   Select nisdomainobject as the value
    -   Press the Add Attribute button
    -   Select the nisDomain attribute
    -   Fill in the value for nisDomain
    -   Press Save to save and dismiss the Properties editor

-   Create a profile entry for your solaris client. I created a new OU called "profile", and here's the (sanitized) ldif for my test machine (which works):

        dn: cn=shades, ou=profile,dc=my,dc=domain,dc=com
        credentialLevel: proxy
        serviceAuthenticationMethod: pam_ldap:tls:simple
        defaultServerList: ldap.my.domain.com ldap2.my.domain.com
        authenticationMethod: tls:simple
        defaultSearchBase: dc=my,dc=domain,dc=com
        objectClass: top
        objectClass: DUAConfigProfile
        cn: shades
        serviceSearchDescriptor: passwd:ou=People,dc=my,dc=domain,dc=com?sub
        serviceSearchDescriptor: shadow:ou=People,dc=my,dc=domain,dc=com?sub
        serviceSearchDescriptor:
        user_attr:ou=People,dc=my,dc=domain,dc=com?sub
        serviceSearchDescriptor:
        audit_user:ou=People,dc=my,dc=domain,dc=com?sub
        serviceSearchDescriptor: group:ou=Group,dc=my,dc=domain,dc=com?sub

You can create this ldif on the solaris client itself by running "ldapclient genprofile". Read the ldapclient man page for details.

-   If your clients will bind to the server using "proxy" authentication (or, not anonymously), then the user they bind as should be in the tree somewhere too. I haven't heard much about \*where\* in the tree this user definition should reside, so I put mine under ou=Profile, since it's only purpose is to grab a profile, and I \*do not\* want the user defined in my ou=People tree. I defined this user in the admin console as a plain old inetorg person (I didn't use any posixAccount attributes).
-   On the solaris client, edit /etc/nsswitch.ldap and make it look like you want. It's not going to take effect just yet, but when you run ldapclient, it will.
-   If you're using tls/ssl on the solaris client, you have to have a cert on the server. To import the cert, fire up /usr/dt/bin/netscape on the solaris client, and go to <http://ldapserver:636>, and choose to accept the certificate forever.
-   When netscape gives you the "no data" error, close it, and then take the cert7.db and key3.db files from your \~/.netscape folder and copy them to /var/ldap.
-   VERY IMPORTANT: chmod 444 on /var/ldap/\*.db. If you don't do this, and use 600 or something else, some stuff will work, but other things (for example, ps -ef) will give you "TLS: bad database" errors.
-   Now it's time to run "ldapclient init", feeding it the arguments it'll need to find the server, bind to it (if you're using proxy authentication), and find the profile. Here's the command I used, based on an assumption that the preceding process outlined in this document was followed:

    ldapclient -v init -a profileName=shades -a proxyDN=uid=sun,ou=profile,dc=my,dc=domain,dc=com \    
    -a proxyPassword=secret myserver    

-   If things are working, you should be able to run "ldaplist -l passwd <username>" and get back a user entry.

Solaris 9 TLS/SSL Client
------------------------

I'm really not sure if this will help, but here are the full instructions I used to get this working on a clean solaris 9 install (I haven't given it a shot on solaris 10 yet)

Download the nspr, and nss packages for Solaris 9 here (http://sourceforge.net/project/showfiles.php?group\_id=19386) and install them.

Get Sun one Resource Kit here: <http://www.sun.com/download/products.xml?id=3f74a0db> And install it.

Next run this command to setup your certificate database:

    # LD_LIBRARY_PATH=/usr/lib:/usr/local/lib ; export LD_LIBRARY_PATH    
    # /opt/sunone/lib/nss/bin/certutil -N -d /var/ldap    

You should have generated your server certificate with the fully qualified host and domain name in the cn attribute of the subjectDN in the cert. If not, and you have used some other value (e.g. cn=server-cert), you'll have to add a hosts entry to /etc/hosts for Ldap server, \*\* matching the certificate name \*\* (in my case, server-cert). You'll get this error, which will let you know the name you need to put in /etc/hosts: (I couldn't 'pull' it from the cert in any way)

    Feb 15 13:31:28 unknown sendmail[2061]: libldap: CERT_VerifyCertName: cert server name 'server-cert'    
    does not match 'corporate-ds': SSL connection denied    

Get CA cert from directory using these commands:

    [root@corporate-ds alias]# pwd    
    /opt/fedora-ds/alias    
    [root@corporate-ds alias]# ../shared/bin/certutil -L -d . -n "CA certificate" -r > /root/cert.der    

Copy it to the solaris server, and import it with this:

    # /opt/sunone/lib/nss/bin/certutil -A -n "CA certificate" -i /export/home/mmont/cert.der -t "CTu,u,u" -d /var/ldap/    

Run this command to set ldap client settings on the machine:

    # ldapclient -v manual -a authenticationMethod=tls:simple -a credentialLevel=proxy \    
    -a defaultSearchBase="dc=inside,dc=yourdomain,dc=com" \    
    -a domainName=yourdomain.com -a followReferrals=false \    
    -a serviceSearchDescriptor="netgroup: ou=netgroup,dc=inside,dc=yourdomain,dc=com" \    
    -a preferredServerList=10.5.1.18 -a serviceAuthenticationMethod=pam_ldap:tls:simple \    
    -a proxyPassword=blahblahblah -a proxyDn=cn=proxyagent,ou=profile,dc=inside,dc=yourdomain,dc=com    

Restart ldap.client:

    # /etc/init.d/ldap.client stop ; sleep 2 ; /etc/init.d/ldap.client start    

That should do it. Test settings with id, getent, or ldaplist: (You must be root, or sudo to use ldaplist)

    # ldaplist -l passwd yournamehere    

(This should list your entry in the ldap dir)

I hope this helps someone, and I'm sure I'll attempt to get solaris 10 working at some point soon.

Solaris 10 LDAP Client
----------------------

For this example the server was on ldapHost01.example.com on the example.com domain. This is a rough guide, but hopefully it will get cleaned up, people can add more detail (or fix mistakes I made!), and at the very least, it might save someone the month or so I spent doing this (it can take a while to get some answers to some of the questions).

Begin by editing the /usr/lib/ldap/idsconfig script to be compatible with Red Hat Directory Server 7.x

Find the line that says:

    if [ "${IDS_MAJVER}" != "5" ]; then    

Change the 5 to 7. Save, exit and run the script:

    /usr/lib/ldap/idsconfig    

**Follow the session below:**

    It is strongly recommended that you BACKUP the directory server before running idsconfig.    
    Hit Ctrl-C at any time before the final confirmation to exit.    
    Do you wish to continue with server setup (y/n/h)? [n] Y    
    Enter the directory server's hostname to setup: ldapHost01    
    Enter the Directory Server's port number (h=help): [389]    
    Enter the directory manager DN: [cn=Directory Manager]    
    Enter passwd for cn=Directory Manager : adminpass    
    Enter the domainname to be served (h=help): example.com    
    Enter LDAP Base DN (h=help): [dc=example,dc=com]     <enter>
    Enter the profile name (h=help): [default]     <enter>
    Default server list (h=help): [192.168.10.61]     <enter>
    Preferred server list (h=help):    
    Choose desired search scope (one, sub, h=help):  [one] sub    
    The following are the supported credential levels:    
      1  anonymous    
      2  proxy    
      3  proxy anonymous    
    Choose Credential level [h=help]: [1] 2    
    The following are the supported Authentication Methods:    
      1  none    
      2  simple    
      3  sasl/DIGEST-MD5    
      4  tls:simple    
      5  tls:sasl/DIGEST-MD5    
    Choose Authentication Method (h=help): [1] 4    
    Do you want to add another Authentication Method? <enter>
    Do you want the clients to follow referrals (y/n/h)? [n] <enter>
    Do you want to modify the server timelimit value (y/n/h)? [n] <enter>
    Do you want to modify the server sizelimit value (y/n/h)? [n] <enter>
    Do you want to store passwords in "crypt" format (y/n/h)? [n] <enter>
    Do you want to setup a Service Authentication Methods (y/n/h)? [n] <enter>
    Client search time limit in seconds (h=help): [30] <enter>
    Profile Time To Live in seconds (h=help): [43200] <enter>
    Bind time limit in seconds (h=help): [10] <enter>
    Do you wish to setup Service Search Descriptors (y/n/h)? [n] <enter>
    Enter config value to change: (1-19 0=commit changes) [0] <enter>
    Enter DN for proxy agent:[cn=proxyagent,ou=profile,dc=example,dc=com] <enter>
    Enter passwd for proxyagent: proxy
    Re-enter passwd: proxy
    WARNING: About to start committing changes. (y=continue, n=EXIT) y

**A few quick notes:**

1.  I have heard (I'm not sure about this), that not storing passwords in the crypt format is more secure because then the passwords are only in the SSH format
2.  The default location for users on the ldap server is in ou=people. If the users are in several locations, such as both in the ou=people level, and at the base level, then you should use sub. If not, you can use one (this will also go for the ldif file that's made later).

Copy the certificates onto the Solaris computer:

     ssh ldapHost01 -l root    
     scp /etc/openldap/cacerts/cacert.pem clientHostName:/tmp/    

Load the certificates needed for SSH:

     cd /usr/sfw/bin    
     mkdir /var/ldap/    
     certutil -N -d /var/ldap    
     chmod 444 /var/ldap/*    
     certutil -A -n "Server-cert" -i /tmp/cacert.pem -t CT -d /var/ldap/    

Verify the certificates loaded by doing a search, note that solaris only accepts port 636 and 389, the default ports.

     ldapsearch -v -h ldapHost01.example.com -p 636 -Z -P /var/ldap/cert8.db -b dc=example,dc=com -s base objectclass=* nisDomain    

This should output:

     version: 1    
     dn: dc=example,dc=com    
     nisDomain: example.com    

Add profile and proxy users if necessary

Search to see if the users are there:

     ldapsearch -h ldapHost01 -D "cn=directory manager" -w ldapadmin -b ou=profile,dc=example,dc=com objectclass=*    

The output should include:

     dn: cn=proxyagent,ou=profile,dc=example,dc=com    
     dn: cn=default,ou=profile,dc=example,dc=com    

If the users do not exist:

     cd /var/ldap/    
     vi SolarisProfile.ldif    

Modify the file so it matches the contents below:

**SolarisProfile.ldif:**

     dn: cn=proxyagent,ou=profile,dc=example,dc=com    
     objectclass: top    
     objectclass: person    
     cn: proxyagent    
     sn: proxyagent    
     userpassword: proxy    
     dn: cn=default,ou=profile,dc=example,dc=com    
     objectclass: top    
     objectclass: DUAConfigProfile    
     profileTTL: 43200    
     bindTimeLimit: 10    
     credentialLevel: proxy    
     searchTimeLimit: 30    
     defaultSearchScope: sub    
     defaultSearchBase: dc=example,dc=com    
     cn: default    
     serviceSearchDescriptor: passwd:dc=example,dc=com?sub    
     serviceSearchDescriptor: shadow:dc=example,dc=com?sub    
     serviceSearchDescriptor: group:dc=example,dc=com?sub    
     serviceSearchDescriptor: netgroup:dc=example,dc=com?sub    
     authenticationMethod: tls:simple    
     defaultServerList: 192.168.10.61    

**READ THE NOTES ABOUT THE IDSCONFIG SCRIPT. SOME VALUES MAY CHANGE**

Save the file by typing in the vi command :wq

     ldapmodify -h 192.168.10.61 -D "cn=Directory Manager" -w ldapadmin -a -c -f /var/ldap/SolarisProfile.ldif    

Run the ldapclient command

     ldapclient -v init -a profileName=default -a domainname=example.com -a proxyDN=cn=proxyagent,ou=profile,dc=example,dc=com -a proxyPassword=proxy 192.168.10.61    

**NOTE:** If the ldapmodify command was use to add the proxyagent and default profile. When I tried it the day I did it, it did not work. The next day I tried it and the changes finally took effect. I guess it may take the server may several hours until allowing the users to be visible using getent passwd <uid> or id <uid>.

### Configure Solaris to use the ldap users

Go here: <http://docs.sun.com/app/docs/doc/816-4556/6maort2tb?a=view>

And use this as the pam.conf file.

Update nsswitch.conf and add the ldap entry (either before or after files) for passwd, shadow, group and netgroup.

### Final Notes

When I was playing around with users, I noticed that I needed to have both the posixAccount variable set, the shadowAccount variable set and the gecos variable set, for each user.

### Error in SSL connection: "libsldap: Status: 81 Mesg: openConnection: simple bind failed - Can't contact LDAP server"

I got this error on a Solaris 10 client when trying to configure a SSL/tls:simple connection to the FDS. Meanwhile, in the access log on the FDS, I saw this error: "conn=497 op=-1 fd=66 closed - SSL peer cannot verify your certificate". This was after importing the CA certificate (using certutil as described above) used to sign the FDS' self-signed certificate.

In the end, the problem was an address mismatch:

-   the CN in the certificate was a hostname ("ld-01.example.com")
-   in the DUAConfigProfile, defaultServerList was set to an IP address ("192.168.0.1")

Thus, the Solaris 10 machine connected via SSL, but refused to deal with the FDS because it expected a CN in the certificate of "192.168.0.1" instead of "ld-01.example.com". This was especially confusing because ldapsearch worked over SSL, and the reason for refusing to continue was not logged anywhere; all I saw was the "simple bind failed" error.

Changing the defaultServerList entry to match what was in the CN (ie, changing it to "ld-01.example.com"), then re-running ldapclient init, made things work flawlessly.

#### Another, simpler method for Solaris 10 prompted by the above error

This method worked for me on Solaris 10/08 (latest version as of November 2008); note that I did *not* have to run idsconfig as described above.

-   Import the CA certificate on the Solaris client:

         mkdir /var/ldap/    
         chmod 755 /var/ldap    
         certutil -N -d /var/ldap    
         chmod 444 /var/ldap/*    
         certutil -A -n "example.com CA" -i /tmp/cacert.pem -t CT -d /var/ldap/    
             

-   Verify with ldapsearch:

        ldapsearch -v -h ld-01.example.com -p 636 -Z -P /var/ldap/cert8.db -b dc=example,dc=com -s sub objectclass=*     

-   Add DUAConfigProfile schema as described above.

-   Add cn=proxyagent to your FDS:

         dn: cn=proxyagent,ou=profile,dc=example,dc=com    
         objectclass: top    
         objectclass: person    
         cn: proxyagent    
         sn: proxyagent    
         userpassword: proxy    

-   Add the default profile to your FDS:

         dn: cn=default,ou=profile,dc=example,dc=com    
         objectclass: top    
         objectclass: DUAConfigProfile    
         profileTTL: 43200    
         bindTimeLimit: 10    
         credentialLevel: proxy    
         searchTimeLimit: 30    
         defaultSearchScope: sub    
         defaultSearchBase: dc=example,dc=com    
         cn: default    
         serviceSearchDescriptor: passwd:dc=example,dc=com?sub    
         serviceSearchDescriptor: shadow:dc=example,dc=com?sub    
         serviceSearchDescriptor: group:dc=example,dc=com?sub    
         serviceSearchDescriptor: netgroup:dc=example,dc=com?sub    
         authenticationMethod: tls:simple    
         defaultServerList: ld-01.example.com    

*Note that the defaultServerList must match the CN in your server's certificate!*

-   Modify /etc/nsswitch.ldap.

This file will be copied over to nsswitch.conf by ldapclient; by default, it has ldap in front of just about everything. I found it simplest to simply copy nsswitch.dns to nsswitch.ldap, and make sure the passwd and group lines were changed like so:

     passwd:     files ldap    
     group:      files ldap    

-   Run ldapclient:

         ldapclient -v init -a domainname=example.com -a proxyDN=cn=proxyagent,ou=profile,dc=example,dc=com  -a proxyPassword=proxy -a certificatePath=/var/ldap ld-01.example.com    

-   Test:

         id hugh    
         uid=30000(hugh) gid=30000    


