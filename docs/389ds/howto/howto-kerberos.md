---
title: "Howto:Kerberos"
---

# How to use Kerberos with 389 Directory Server
-----------------------------------------------

{% include toc.md %}

Read Me First
-------------

Please refer to <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/SASL.html> and <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Configuring_Kerberos.html> before continuing.

How do I configure 389 to use SASL and GSSAPI to authenticate against a local Kerberos realm?
---------------------------------------------------------------------------------------------

This describes how to configure 389 to allow users to present their Kerberos credentials (their ticket) to 389 for authentication, using the SASL GSSAPI mechanism. This allows 389 to participate in Single Sign On - a user acquires his/her ticket via kinit or login and can use it to authenticate to various services, including 389.

This requires a previously configured Kerberos realm. We've tested this with MIT Kerberos 5, but other implementations such as Heimdal should also work. You need a key for the LDAP service, an appropriate SASL mapping for GSSAPI, and the cyrus-sasl-gssapi package. 389 uses the cyrus-sasl package to interface to Kerberos.

DNS/hostnames
-------------

Kerberos relies heavily on the fully qualified host and domain name (FQDN) for service hosts and service principal names. Make sure all of your clients can resolve the Kerberos server host and LDAP server host by their FQDN. This usually means getting DNS working correctly on all of your server and client machines, but for testing or evaluation purposes you can usually hack /etc/hosts and /etc/nsswitch.conf to make it work correctly. When configuring aliases for hosts, the **FQDN MUST COME FIRST BEFORE ANY ALIASES**. That is, when IP to hostname or hostname to canonical hostname resolution is done, the very first result must be the FQDN, before any aliases. So if you have "ldap.example.com" and an alias for it called "ldap", you must make sure any IP address or hostname resolution for "ldap" or "ldap.example.com" always returns "ldap.example.com" first.

Time Sync
---------

Kerberos works best if all of your servers and clients are in time sync. This doesn't mean you must use something like NTP, but you need to ensure that your machines are not wildly out of time sync.

krb5.conf
---------

Consult your system documentation for Kerberos configuration, usually the file /etc/krb5.conf. There is usually a default one, and you should be able to use **man krb5.conf** to get additional information.

Keys
----

First, make sure that you have created a kerosene principal *ldap/FQDN* or *ldap/FQDN@REALM*. If you do not specify the *@REALM* part, it will use the default value from your krb5.conf (which must be the same on all clients and servers).

    kadmin -q "add_principal -randkey  ldap/FQDN@REALM"    

or

    kadmin -q "add_principal -randkey  ldap/FQDN"    

Then, export that key to a keytab file. If you've deployed other services which also authenticate users using Kerberos on the same system, it's recommended that you give each one its own keytab file.

    kadmin -q "ktadd -k  /etc/dirsrv/ds.keytab ldap/FQDN" # or ldap/FQDN@REALM    

The keytab file needs to be readable by the account under which the directory server runs (i.e dirsrv):

    chown dirsrv:dirsrv /etc/dirsrv/ds.keytab    
    chmod 600 /etc/dirsrv/ds.keytab    

Next, set the KRB5\_KTNAME environment variable, so your Directory Server can find the keytab file. For FDS 1.1 and later, edit the file

    /etc/sysconfig/dirsrv    

and add the line below, replacing INSTANCE appropriately:

    KRB5_KTNAME=/etc/dirsrv/ds.keytab ; export KRB5_KTNAME    

For a systemd system, omit the "; export KRB5\_KTNAME" part.

For FDS 1.0 and earlier, you can edit the start-slapd shell script in /etc/init.d/dirsrv and set KRB5\_KTNAME in there:

    export KRB5_KTNAME=path_to_service_keytab    

### Using Windows to generate a service keytab

-   Step 1 - Create a user account on AD to use for the principal - this should be a "pseudo" account, not a real user account - make sure the password never expires, and use a really long, random password (you will never actually use this password)
-   Step 2 - use ktpass to map the user account you created to the ldap service principal and export the keytab

        ktpass -princ ldap/<fqdn of the 389 server>@DOMAIN.COM
          -mapuser <user on AD> -crypto rc4-hmac-nt -ptype KRB5_NT_SRV_HST -pass <password> -out
          ldap.keytab

Copy ldap.keytab to the directory server machine and change mode and ownership as above.

Maps
----

The directory server already has some default SASL/GSSAPI maps as described in <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/SASL.html>. So you might not have to do anything to get identity mapping working.

However, if you want/need to do your own mapping, see below.

Let's assume your entry in the DS has the DN "dn: uid=uid,o=realm.edu", and assume your Kerberos realm is *REALM.EDU*. Then, the map would be something like this (as seen in "Managing SASL" in the [Administrator's Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/SASL.html)):

    dn: cn=mapname,cn=mapping,cn=sasl,cn=config    
    objectclass: top    
    objectclass: nsSaslMapping    
    cn: mapname    
    nsSaslMapRegexString: \(.*\)@\(.*\)
    nsSaslMapBaseDNTemplate: uid=\1,o=\2    
    nsSaslMapFilterTemplate: (objectclass=inetOrgPerson)    

This assumes the Kerberos principal name being sent to the DS is in the form "username@REALM". If this is not the case, and the realm is not being sent, you may have to use something like the following:

    nsSaslMapRegexString:     \(.*\)
    nsSaslMapBaseDNTemplate: uid=\1,dc=myorg,dc=tld    

where myorg and tld correspond to your domain and top level domain.

You can use a regex of the form \([^/]+\)/\(.+\) to map kerosene principals with an instance, like service/fqdn or user/admin. For example if you want to map all services from hostname.domain to the uid=hostname.domain,ou=hosts,dc=domain you can use [\^/]+/\(.+\) and a map base of uid=\\1,ou=hosts,dc=domain or you might want to map all principals with an admin instance to uid=user,ou=Managers,dc=domain so you'll use \([^/]+\)/admin and a mapbase of uid=\\1,ou=Managers,dc=domain.

