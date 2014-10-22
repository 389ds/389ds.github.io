---
title: "How To Disable SSLv3"
---

# How to Disable SSLv3 
--------------------------

With the recent discovery of the Poodlebleed vulnerabilty bug (2014/10/15), TLS should be used instead of SSLv3.

### Disable SSLv3 in 389 Directory Server

Here is an example of how to use ldapmodify to disable SSLv3 and enable TLS

    ldapmodify -D "cn=directory manager" -W
    dn: cn=encryption,cn=config
    changetype: modify
    -
    replace: nsSSL2
    nsSSL2: off
    -
    replace: nsSSL3
    nsSSL3: off
    -
    replace: nsTLS1
    nsTLS1: on


You need to restart the server for this to take effect.

### Disable SSLv3 in favor of TLSv1.1 in 389 Administration Server

-   Stop the Admin Server
-   Edit /etc/dirsrv/admin-serv/console.conf

        Change: NSSProtocol SSLv3,TLSv1
        To:     NSSProtocol TLSv1.1

-   Start the Admin server

### Verify SSLv3 is Disabled

You can use the openssl client tool to verify the SSL Handshake does NOT take place.

    openssl s_client -connect hostname:389 -ssl3   # DS Port
    openssl s_client -connect hostname:636 -ssl3   # DS Secure Port
    openssl s_client -connect hostname:9830 -ssl3  # Admin Server Port

For more information see <https://access.redhat.com/articles/1232123>

There is also a script available from the above link that will run the openssl client tool and verify the SSL3 status for you.

