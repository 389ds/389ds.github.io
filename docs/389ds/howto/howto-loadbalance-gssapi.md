---
title: "Howto:Load Balancer with GSSAPI"
---

# How to use GSSAPI behind a load balancer
------------------------------------------

Intro
-----

It is a common configuration to have slapd behind a load balancer to help provide high availability. In these configurations it is often hard to make GSSAPI work correctly.

This is because GSSAPI/KRB5 makes the assumption that when you connect to a DNS name foo.example.com, the Service Ticket held by the service matches <service>/foo.example.com@REALM. Of course, behind a load balancer, this is not the case, because the hosts behind the load balancer will be called arbitrary names like ldap1.example.com, ldap2.example.com.


Preparation
-----------

You will need:

    * KDC (FreeIPA or MIT/Heimdal)
    * 2 EL7 servers

Howto
-----

First, prepare the ldap server installs on the hosts. If you have existing ldap server installs, these will suffice. Else, for newer versions of 389 (Likely 1.3.5 or higher) we advise the use of the option:

    General.StrictHostCheck=false


Now install your load balancer. We used haproxy for this demo. The haproxy configuration needs improvement for production use at your site. Other loadbalancers will work in place as TCP balancers (f5, ace, netscaler etc).

    global
        log         127.0.0.1 local2
        chroot      /var/lib/haproxy
        pidfile     /var/run/haproxy.pid
        maxconn     4000
        user        haproxy
        group       haproxy
        daemon
        stats socket /var/lib/haproxy/stats
    listen ldap :3389
        mode tcp
        balance roundrobin
        server ldap 10.0.0.2:389 check
        timeout connect        10s
        timeout server          1m

NOTE: On el7 there are many issues with haproxy and ipv6. Please try to avoid this combination.

You must setup A/AAAA records with PTR to the load balancer IP or Virtual IP. You cannot use CNAMEs in this configuration.

For my demo lab, I now have:

    haproxydemo.ipa.example.com
    ldap1.ipa.example.com

You should be able to search to both hosts with simple binds and retrieve results:

    ldapsearch -H ldap://ldap1.ipa.example.com -x
    ldapsearch -H ldap://haproxydemo.ipa.example.com -x


Next you must prepare the service keytab.

Create the principal on the KDC. For MIT/Heimdal this is an exercise for the reader with kadmin.

For FreeIPA, if your loadbalancer is not part of the domain, or an appliance you will need to add a fake host for this:

    ipa host-add haproxydemo.ipa.example.com --random --force

You can now create the principal for this host.

    ipa service-add --force ldap/haproxydemo.ipa.example.com

You will need to delegate this principal to be extracted to a keytab on the members of the ldap cluster.

    ipa service-add-host ldap/haproxydemo.ipa.example.com --hosts=ldap1.ipa.example.com

On the ldap1 server you should extract this keytab:

    kinit <account with admins privilige>
    ipa-getkeytab -s dc.ipa.example.com -p ldap/haproxydemo.ipa.example.com -k /etc/dirsrv/slapd-localhost/ldap.keytab --retrieve

Important is the --retrieve flag to prevent the keytab contents changing.

You should now reconfigure slapd to be aware of the keytab:

    /etc/sysconfig/dirsrv-<instance>
    KRB5_KTNAME=/etc/dirsrv/slapd-localhost/ldap.keytab

Restart the slapd service and test that you have working GSSAPI

    ldapsearch -H ldap://haproxydemo.ipa.example.com -Y GSSAPI

If you have configured this correctly, and your current ccache's principal maps to a DN, you should see ldap search results.

If your keytab is NOT correct, you will see:

    SASL/GSSAPI authentication started
    ldap_sasl_interactive_bind_s: Local error (-2)
        additional info: SASL(-1): generic failure: GSSAPI Error: Unspecified GSS failure. 

This means you have an issue with your principal name, dns names, or have not setup KRB5_KTNAME correctly.

If the keytab IS correct, but you do not have a DN to map to, you will see this error:

    SASL/GSSAPI authentication started
    ldap_sasl_interactive_bind_s: Invalid credentials (49)
        additional info: SASL(-14): authorization failure:

This means you do not have a dn to bind to. If you look at klist, you will see your ccache. If you don't have one, kinit a ccache. If you have a ccache but you recieve this error, it is because there is no object that matches "uid=<princ name>". IE if your ccache is admin@EXAMPLE.COM, you are missing an object "uid=admin".

Other issues may be due to DNS names (Ensure they are A/AAAA with PTRs, and NOT CNAMEs or in /etc/hosts) or keytab file permissions.

Extra
-----

If you want to use GSSAPI direct to each ldap server in addition to behind the load balancer, ensure you have A/AAAA records correct with corresponding PTR records.

You will need to add another principal name for *each* ldap server.

    ipa service-add ldap/ldap1.ipa.example.com

Now extract these to the keytab that you already have. Make sure you extract ldap1 for server ldap1, ldap2 for ldap2 etc. You DO NOT need to share the per-host keytabs in the cluster.

    kinit <account with admins privilige>
    ipa-getkeytab -s dc.ipa.example.com -p ldap/ldap1.ipa.example.com -k /etc/dirsrv/slapd-localhost/ldap.keytab --retrieve

This will safely merge the two into a single keytab. If you want to confirm this:

    ktutil
    ktutil:  rkt /etc/dirsrv/slapd-localhost/ldap.keytab
    ktutil:  l
    slot KVNO Principal
    ---- ---- ---------------------------------------------------------------------
       1    1 ldap/haproxydemo.ipa.example.com@IPA.EXAMPLE.COM
       2    1 ldap/haproxydemo.ipa.example.com@IPA.EXAMPLE.COM
       3    1 ldap/haproxydemo.ipa.example.com@IPA.EXAMPLE.COM
       4    1 ldap/haproxydemo.ipa.example.com@IPA.EXAMPLE.COM
       5    1 ldap/ldap1.ipa.example.com@IPA.EXAMPLE.COM
       6    1 ldap/ldap1.ipa.example.com@IPA.EXAMPLE.COM
       7    1 ldap/ldap1.ipa.example.com@IPA.EXAMPLE.COM
       8    1 ldap/ldap1.ipa.example.com@IPA.EXAMPLE.COM

Now restart slapd, and you should be able to confirm both commands work:

    ldapsearch -H ldap://haproxydemo.ipa.example.com -Y GSSAPI
    ldapsearch -H ldap://ldap1.ipa.example.com -Y GSSAPI

