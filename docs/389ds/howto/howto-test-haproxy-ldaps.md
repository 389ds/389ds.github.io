---
title: "Testing HAProxy with 389 DS over LDAP/LDAPS"
---

# Testing HAProxy with 389 DS
-----------------

{% include toc.md %}

## Introduction

A simple guide for HAProxy with LDAP configuration for testing purposes. If used in production, make sure to use valid certificates (as opposed to self-signed used in the guide).

**This guide covers LDAP/LDAPS configuration only.** GSSAPI/EXTERNAL and LDAP with StartTLS may be covered later in a separate document.

## Step 1: Create Virtual Machines
We will need to create three Fedora (i.e. F38) virtual machines for our setup:

1. HAProxy server: `haproxy.example.com`
2. 389 DS client: `client.example.com`
3. 389 DS server: `server.example.com`

Configure the hostnames and `/etc/hosts` file as needed on all these machines so they are discoverable between each other.

## Step 2: Setup HAProxy Server with LDAPS or LDAP
On the HAProxy server machine, perform the following steps:

1. Install HAProxy:

```
dnf install haproxy
```

2. Configure HAProxy by editing the `/etc/haproxy/haproxy.conf` file with the following:

```
global
    log 127.0.0.1 local2
    chroot /var/lib/haproxy
    pidfile /var/run/haproxy.pid
    maxconn 4000
    user haproxy
    group haproxy
    daemon
    stats socket /var/lib/haproxy/stats

defaults
    log global
    mode tcp
    option tcplog
    option dontlognull
    option redispatch
    retries 3
    timeout connect 5s
    timeout client 1m
    timeout server 1m
    maxconn 3000

frontend ldaps_front
    bind *:636 ssl crt /etc/haproxy/haproxy.pem
    default_backend ldaps_back

backend ldaps_back
    balance roundrobin
    server ldap1 server.example.com:636 send-proxy-v2 ssl verify required ca-file /etc/pki/tls/certs/server-cert-ca.pem
```

You can replace the last part with this code if you want to use non-secure port, **but it's not recommended**. Always consider the security.

```
frontend ldaps_front
    bind *:389
    default_backend ldap_back

backend ldap_back
    balance roundrobin
    server ldap1 server.example.com:389 send-proxy-v2
```

3. Generate the `haproxy.pem` certificate using the following steps:

    a. Generate the private key for the self-signed CA:

    ```bash
    openssl genpkey -algorithm RSA -out ca.key -pkeyopt rsa_keygen_bits:2048
    ```

    This creates a 2048 bit RSA private key for the self-signed CA.

    b. Generate the self-signed CA certificate:

    ```bash
    openssl req -new -x509 -key ca.key -out ca.crt -days 365
    ```

    You will be prompted for various details to include in the certificate, such as the common name (CN), organization name, and location.

    c. Generate a private key for the server:

    ```bash
    openssl genpkey -algorithm RSA -out server.key -pkeyopt rsa_keygen_bits:2048
    ```

    d. Generate a certificate signing request (CSR) for the new server key:

    ```bash
    openssl req -new -key server.key -out server.csr
    ```

    You will be prompted for various details to include in the request. The common name should match the name that clients will use to connect to your server (i.e., haproxy.example.com)

    e. Sign the CSR with the self-signed CA:

    ```bash
    openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
    ```

    This signs the CSR using the self-signed CA's private key and certificate, producing a signed certificate.

    f. Finally, create the `haproxy.pem`:

    ```bash
    cat server.key ca.crt server.crt > haproxy.pem
    ```

## Step 3: Configure 389 DS Client
On the Client machine, perform the following steps:

1. Copy the `haproxy.pem` certificate to the client machine to `/etc/pki/tls/certs/`:

2. Edit the `/etc/openldap/ldap.conf` file to include this line:

```
TLS_CACERT      /etc/pki/tls/certs/haproxy.pem
```

## Step 4: Configure 389 DS Server
On the Server machine, perform the following steps:

1. Create an instance with the hostname set to `server.example.com` (you can set it in INF file created by dscreate create-template).

2. Export the CA certificate in `.pem` format and copy it to the HAProxy machine at `/etc/pki/tls/certs/server-cert-ca.pem`. It can be done through the Cockpit Web UI.

3. Set `nsslapd-haproxy-trusted-ip` to the HAProxy IP address.

## Step 5: Final Steps on HAProxy Machine
Back on the HAProxy machine, perform the following steps:

1. Run `setenforce 0` to disable SELinux for testing purposes only:

```bash
setenforce 0
```

2. Start the HAProxy service:

```bash
systemctl start haproxy
```

## Step 6: Testing
You can now test the setup by running the following command on your client machine:

```bash
ldapsearch -H ldaps://haproxy.example.com:636 -D "cn=directory manager" -W -s base -b ""
```

This should connect to the 389 DS server and the server should log the correct client IP address.
