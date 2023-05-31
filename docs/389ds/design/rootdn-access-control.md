---
title: "RootDN Access Control"
---

# Root DN Access Control
----------------------

{% include toc.md %}

Purpose
-------

Have the ability to control where and when the Root DN account can bind to the Directory Server

New Plugin
----------

dn: cn=RootDN Access Control,cn=plugins,cn=config

Disabled by default

Details
-------

    rootdn-open-time: (4 digit 24 hour time scheme: 0800 = 8:00am)

Specifies the time the root DN is allowed to bind.

    rootdn-close-time: (4 digit 24 hour time scheme: 1700 = 5:00pm)

Specifies the time the root DN is no longer allowed to bind.

    rootdn-days-allowed: (Mon, Tue, Wed, Thu, Fri, Sat, Sun)

Specifies the days of the week that the root DN is allowed to bind.

    rootdn-allow-host: (hostname, accepts wildcards in the left most domain component)

Specifies the hostname from which the root DN can bind from.  This is a multivalued attribute.
    
    rootdn-deny-host: (hostname, accepts wildcards in the left most domain component)

Specifies the hostname that the root DN can not bind from.  This is a multivalued attribute.

    rootdn-allow-ip: (IP address, accepts wildcards in the right most section)

Specifies the IP address that the root DN can not bind from.  This is a multivalued attribute.

    rootdn-deny-ip: (IP Address, accepts wildcards in the right most section)

Specifies the IP address that the root DN can not bind from.  This is a multivalued attribute.

- Note: deny rules always override allow rules

Plugin Config Example
---------------------

       dn: cn=RootDN Access Control,cn=plugins,cn=config
       objectclass: top
       objectclass: nsSlapdPlugin
       objectclass: extensibleObject
       cn: RootDN Access Control
       nsslapd-pluginpath: librootdn-access-plugin.so
       nsslapd-plugininitfunc: rootdn_init
       nsslapd-plugintype: rootdnpreoperation
       nsslapd-pluginenabled: on
       nsslapd-plugin-depends-on-type: database
       nsslapd-pluginid: rootdn-access-control
       rootdn-open-time: 0800
       rootdn-close-time: 1700
       rootdn-days-allowed: Mon, Tue, Wed, Thu, Fri
       rootdn-allow-host: internal.redhat.com
       rootdn-allow-host: *.fedora.com
       rootdn-deny-host: *.public.com
       rootdn-allow-ip: 127.0.0.1
       rootdn-allow-ip: 2000:db8:de30::11
       rootdn-deny-ip: 192.168.1.*

Result
------

Regardless if the password is correct, an error 53 will always be returned if access is denied by this plugin.

