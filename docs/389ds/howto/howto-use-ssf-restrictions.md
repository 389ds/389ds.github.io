---
title: "SSF Restrictions"
---

# SSF Restrictions
------------------

This document describes the implementation of controlling operations based on SSF (security strength factor).

{% include toc.md %}

Overview
--------

In some environments, access to the directory server may want to require that a certain level of encryption is used. To allow this, this feature adds a minimum SSF configuration setting that can be used to define the minimum level of encryption that is required. To allow more granularity, such as requiring a certain level of encryption for password changes only, the ability to set an access control rule based on SSF can be used.

There are two main ways of encrypting an LDAP session. These are SSL/TLS and SASL. The act of simply connecting via LDAPS will start protecting the session without the need for any special LDAP operation. When using the startTLS extended operation, the connection is unprotected until the startTLS operation has been completed successfully. When using SASL, the session is unprotected until a SASL BIND using an appropriate mechanism has been completed (assuming you are not already using SSL/TLS prior to the SASL BIND). We need to allow all of the above operations to occur to give the user a chance to adequately protect their session without turning them away.

Minimum SSF Usage
-----------------

A new configuration setting has been added to the **cn=config** entry named **nsslapd-minssf**. This can be set to a non-negative integer representing the minimum key strength required to process operations. The default setting will be **0**.

The SSF for a particular connection will be determined by the key strength cipher used to protect the connection. If the SSF used for a connection does not meet the minimum requirement, the operation will be rejected with an error code of **LDAP\_UNWILLING\_TO\_PERFORM** (53) along with a message stating that the minimum SSF was not met. Notable exceptions to this are operations that attempt to protect a connection. These operations are:

-   SASL BIND
-   startTLS

These operations will be allowed to occur on a connection with a SSF less than the minimum. If the results of these operations end up with a SSF smaller than the minimum, they will be rejected.

Additionally, we allow UNBIND and ABANDON operations to go through.

Access Control SSF Usage
------------------------

A new **ssf** keyword is available as a bind rule for use in access control rules. This new keyword can be used with the **=**, **!=**, **\<**, **\>**, **\<=**, and **\>=** comparators. The value of the SSF in effect for a particular operation is the higher value between the SSF provided by SASL and SSL/TLS.

Here is an example ACI that requires a SSF of 56 for a user to modify their own password:

    aci: (targetattr="userPassword")(version 3.0; acl "Require secure password
    changes"; allow (write) userdn="ldap:///self)" and ssf>="56";)

