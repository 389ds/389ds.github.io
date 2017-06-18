---
title: "How To Disable SSLv3"
---

# How to Disable SSLv3 
--------------------------

With the recent discovery of the Poodlebleed vulnerabilty bug (2014/10/15), a minimum of TLS1.1 should be used instead of SSLv3.

### Disable SSLv3 in 389 Directory Server

Here is an example of how to use ldapmodify to disable SSLv3 and enable TLS

    # ldapmodify -D "cn=directory manager" -W
    dn: cn=encryption,cn=config
    changetype: modify
    replace: nsSSL2
    nsSSL2: off
    -
    replace: nsSSL3
    nsSSL3: off
    -
    replace: nsTLS1
    nsTLS1: on

Set the SSL version range to enforce TLS1.1 through TLS1.2.

    # ldapmodify -D "cn=directory manager" -W
    dn: cn=encryption,cn=config
    changetype: modify
    replace: sslVersionMin
    sslVersionMin: TLS1.1
    -
    replace: sslVersionMax
    sslVersionMax: TLS1.2

Note: If sslVersionMax is not explicitly set, the supported version by the installed NSS is applied to sslVersionMax. If sslVersionMin is not explicitly set, even if NSS supports SSL3, TLS1.0 is set to sslVersionMin, by default.

You need to restart the server for this to take effect.

### Disable SSLv3 in favor of TLSv1.1(or higher) in 389 Administration Server

-   Stop the Admin Server
-   Edit **/etc/dirsrv/admin-serv/console.conf**

        Change: NSSProtocol SSLv3,TLSv1
        To:     NSSProtocol TLSv1.1

-   Edit **/etc/dirsrv/admin-serv/adm.conf**, and add these two settings

        sslVersionMin: TLS1.1
        sslVersionMax: TLS1.2

-   Start the Admin server


### Enforce TLS verson range in the console

Edit the console preferences file and add the following lines:


    # vi ~/.389-console/Console.1.1.12.Login.preferences

    sslVersionMin: TLS1.1
    sslVersionMax: TLS1.2

### Verify SSLv3 is Disabled

You can use the openssl client tool to verify the SSL Handshake does NOT take place.

    openssl s_client -connect hostname:389 -ssl3   # DS Port
    openssl s_client -connect hostname:636 -ssl3   # DS Secure Port
    openssl s_client -connect hostname:9830 -ssl3  # Admin Server Port

For more information see <https://access.redhat.com/articles/1232123>

There is also a script available from the above link that will run the openssl client tool and verify the SSL3 status for you.

