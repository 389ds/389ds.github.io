---
title: "Anonymous Access Switch"
---

# Anonymous Access Switch
-------------------------

The ability to disable anonymous access via LDAP can be useful in certain environments. This document describes the implementation of this feature.

Overview
--------

The anonymous access restriction needs to apply to more than just BIND operations since LDAPv3 does not require that a BIND operation occur prior to other LDAP operations. When using LDAPv3, the authorization identity is anonymous until you perform a BIND operation that is a true authenticated bind. This means that we need to allow the BIND operation to be processed for an anonymous user. If the attempted BIND is either an anonymous bind (NULL bind DN) or an unauthenticated bind (non-NULL bind DN with a zero-length password), it should be rejected.

In addition to allowing BIND operations to be processed, we also need to allow the startTLS extended operation. The typical use of startTLS is to send the startTLS request as the very first operation, then to perform a BIND. This is preferred so the bind credentials are protected in transport.

Usage
-----

To control anonymous access restrictions, a new config parameter has been added to the **cn=config** entry named **nsslapd-allow-anonymous-access**. This attribute will be set to **on** by default. If this attribute is not specified, it will be treated as if it were set to **on**.

When an operation is rejected, the client will be sent an LDAP error code of **LDAP\_INAPPROPRIATE\_AUTH** (48). The error message will also report that anonymous access is not allowed.

When an anonymous access attempt is rejected for an operation other than an anonymous or unauthenticated bind attempt, the access log will contain a line similar to the following:

    [29/Sep/2009:13:01:28 -0700] conn=1 op=1 UNPROCESSED OPERATION - Anonymous access not allowed    

We do not provide the operation type since we have not started processing the operation. Since anonymous access is disabled, we want to spend as little time processing the request as possible.
