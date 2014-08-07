---
title: "Require Secure Binds Switch"
---

# Require Secure Binds Switch
-----------------------------

This document describes the implementation of a feature to require simple binds to be performed over a secure channel.

Overview
--------

When performing a LDAP simple BIND operation, the cleartext password is sent from the client to the directory server. It would be desirable to require all BIND operations to have some sort of confidentiality protection over the wire by rejecting any BIND attempts over an insecure channel.

Usage
-----

A new config switch has been added to the **cn=config** entry named **nsslapd-require-secure-binds**. When this attribute is set to **on**, the server will only allow simple binds for SSL/TLS established connections or connections using SASL privacy layers. Any attempts to bind over an insecure channel will result in an result of LDAP\_CONFIDENTIALITY\_REQUIRED being sent to the client.

The exception to the above are anonymous and unauthenticated BIND operations. Since this feature is designed to prevent credentials from being sent over an insecure channel, there is no benefit for anonymous and unauthenticated BIND operations since no credential is sent. This new switch will not prevent these BIND operations from going through successfully.
