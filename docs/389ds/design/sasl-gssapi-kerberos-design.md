---
title: "SASL GSSAPI Kerberos Design"
---

# SASL GSSAPI Kerberos Design
-----------------------------

{% include toc.md %}

Background
==========

SASL
----

[SASL](http://www.faqs.org/rfcs/rfc2222.html) is an on-the-wire framework for authentication and optionally session encryption that is designed to be added to existing network protocols that lack strong authentication support. SASL is widely used with the SMTP mail transfer protocol, for example. SMTP itself lacks any support for client or server authentication. SASL is also designed to add support for strong authentication, requiring multiple client/server round-trips, and challenge/response mechanisms, to protocols that lack support for those capabilities. For example SASL can be used to add support for Kerberos authentication to the IMAP mailbox access protocol. IMAP itself supports only simple username/password authentication. SASL itself is an abstract specification: it does not specify the on-the-wire. For more background on SASL see [the SASL FAQ](http://www.faqs.org/faqs/kerberos-faq/general/section-85.html).

The use of SASL in LDAP is defined in the following standards: [Use of SASL in LDAP](http://rfc.net/rfc2829.html) [Update to RFC2829](http://www.ietf.org/internet-drafts/draft-ietf-ldapbis-authmeth-10.txt).

GSS-API
-------

[GSS-API](http://www.faqs.org/rfcs/rfc2078.html) is a generic API for security services. However, in reality it is almost exclusively used with [Kerberos](http://web.mit.edu/kerberos/www/). GSS-API is the native way to access Kerberos services on Unix-like OSes. The primary deployed platform for Kerberos however is Microsoft's Windows Servers. On Windows GSS-API is not part of the base API (Microsoft supports an equivalent but different API).

In addition to Kerberos authentication, the GSS-API also supports session encryption via function calls that may be used to wrap and unwrap payload data (encrypt and decrypt). GSS-API is a supported SASL authentication and encryption mechanism, as defined in [this document](http://www.ietf.org/internet-drafts/draft-ietf-sasl-gssapi-00.txt).

Most GSS-API/SASL implementations however do not support encryption, as discussed in this [href="<http://groups.google.com/groups?hl=en&lr>=&ie=UTF-8&safe=off&frame=right&th=e9515a36a61574c1&seekm=3DB3FBDA.1481773D%40india.hp.com\#link12 Usenet thread].

Requirements
============

Because both SASL and GSS-API are generic interfaces that can support multiple different specific authentication and encryption mechanisms, the requirements will be separated into generic ones, and specific profiles that must be tested and supported. This is necessary because it is not possible to predict all the potential combinations of mechanisms that might be encountered in the field.

Generic Requirements
--------------------

-   Add support to the Directory Server for SASL authentication mechanism 'GSS-API', on those platforms where GSS-API is available.
-   Add support to the Directory Server for LDAP PDU encryption using GSS-API's security functions.

Specific Supported Profiles
---------------------------

-   Support KerberosV authentication for LDAP client connections using SASL and GSS-API.
-   Support \$KerberosV LDAP client connection PDU encryption using GSS-API.

Restrictions
------------

GSS-API functionality will not be available on those platforms where it is not supported (Windows), nor on machines where it has not been installed (GSS-API/Kerberos is an additional install package for most operating systems, for example SEAM for Solaris). GSS-API encryption is not supported over SSL connections.

The OpenLDAP implementation supports GSSAPI encryption over SSL/TLS but this is unlikely to be of significant benefit.

Implementation
==============

Directory Server uses the open source Cyrus-Sasl library for its sasl support. Code within the Directory Server processes LDAP SASL BIND requests and arranges to call the appropriate Cyrus-Sasl library functions. The library then makes calls back to Directory Server functions as necessary.

This existing code will be enhanced to support the 'GSS-API' SASL authentication mechanism. Any enhancements necessary for the existing sasl library to support GSS-API will also be made.

In addition, code will be added to the Directory Server's Network connection handling code to support the use of GSS-API for payload encryption.

Finally, it will be necessary for to enhance the Netscape/Mozilla LDAP SDK and associated client tools to support Kerberos authentication and encryption, at least for testing purposes. The OpenLDAP clients (version 2.2 and later) already have support.

UI Support
----------

GSS-API authentication will have some associated configuration data (specify the kerosene realm and enable/disable for example). This configuration will be supported in the Java Administration console.

Interoperability Testing
========================

Test in the development phase of the project against at least one other implementation. Both Microsoft and OpenLDAP support both authentication and encryption, but Microsoft's implementation is broken in that it requires clients to set both the confidentiality and integrity bits in its requests, but only the confidentiality bit should be needed since confidentiality implies integrity. See [<http://lists.andrew.cmu.edu/pipermail/cyrus-sasl/2010-February/001957.html> this Cyrus-SASL post].

QA Test Cases
=============

Test the following functionality:

1.  Establish an LDAP connection, perform a successful Kerberos V SASL BIND operation.
2.  Establish an LDAP connection, perform a successful Kerberos V SASL BIND operation. Specify Kerberos Encryption. Verify that the session is indeed encrypted.

