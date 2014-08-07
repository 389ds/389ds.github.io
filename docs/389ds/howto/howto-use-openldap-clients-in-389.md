---
title: "Use OpenLDAP Clients In 389"
---

# Use OpenLDAP Clients In 389
-----------------------------

{% include toc.md %}

### Introduction

389 uses the Mozilla LDAP C SDK. The OpenLDAP API is similar, but there are a number of important differences. This page lists the differences and the plan for resolving them in order to use the OpenLDAP API with 389 directory server, admin server, adminutil, etc.

LDAP protocol
=============

This includes APIs that deal with LDAP protocol requests and responses, such as ldap\_search\_\*, ldap\_result, etc. These are mostly the same. There are a few differences such as ldap\_initialize, ldap\_url\_parse.

LDAP API
--------

OpenLDAP supports the BER functions needed to construct and parse the control and extop values. All of the protocol API functions support request and response controls, and extended operation requests and responses. There are a few \#defines which are different.

### Renamed defines

-   LDAP\_CHANGETYPE\_ADD - LDAP\_CONTROL\_PERSSIT\_ENTRY\_CHANGE\_ADD
-   LDAP\_CHANGETYPE\_DELETE - LDAP\_CONTROL\_PERSSIT\_ENTRY\_CHANGE\_DELETE
-   LDAP\_CHANGETYPE\_MODIFY - LDAP\_CONTROL\_PERSSIT\_ENTRY\_CHANGE\_MODIFY
-   LDAP\_CHANGETYPE\_MODDN - LDAP\_CONTROL\_PERSSIT\_ENTRY\_CHANGE\_RENAME
-   LDAP\_CONTROL\_PERSISTENTSEARCH - LDAP\_CONTROL\_PERSIST\_REQUEST
-   LDAP\_X\_CONTROL\_PWPOLICY\_REQUEST - LDAP\_CONTROL\_PASSWORDPOLICYREQUEST
-   LDAP\_X\_CONTROL\_PWPOLICY\_RESPONSE - LDAP\_CONTROL\_PASSWORDPOLICYRESPONSE
-   LDAP\_FILTER\_EXTENDED - LDAP\_FILTER\_EXT
-   LDAP\_ALL\_USER\_ATTRS - LDAP\_ALL\_USER\_ATTRIBUTES

### Missing defines

OpenLDAP does not define these:

-   LBER\_END\_OF\_SEQORSET
-   LDAP\_CHANGETYPE\_ANY
-   LDAP\_CONTROL\_PWEXPIRED
-   LDAP\_CONTROL\_PWEXPIRING
-   LDAP\_URL\_ERR\_NODN - OpenLDAP returns LDAP\_URL\_ERR\_MEM instead if there is no DN in the LDAP URL, but it also uses this value for other, different error cases

### Missing functions

OpenLDAP has deprecated these:

-   ldap\_value\_free() - create slapi\_ldap\_value\_free() wrapper
-   ldap\_count\_values() - create slapi\_ldap\_count\_values() wrapper

### Missing files

MozLDAP has ldap\_ssl.h, this file does not exist and is not needed in OpenLDAP.

### Sort API

The server side sort API is slightly different. MozLDAP declares this structure:

    typedef struct LDAPsortkey {    /* structure for a sort-key */    
           char *  sk_attrtype;    
           char *  sk_matchruleoid;    
           int     sk_reverseorder;    
    } LDAPsortkey;    

But OpenLDAP uses this instead:

    typedef struct ldapsortkey {    
           char *  attributeType;    
           char *  orderingRule;    
           int     reverseOrder;    
    } LDAPSortKey;    

We can just typedef LDAPSortkey LDAPsortkey if HAVE\_OPENLDAP

### URL parsing

The LDAPURLDesc is slightly different. OpenLDAP does not have a lud\_options field or a LDAP\_URL\_OPT\_SECURE flag. Instead, OpenLDAP has a lud\_scheme field which will have a value of "ldap", "ldaps", or "ldapi".

OpenLDAP does not return LDAP\_URL\_ERR\_NODN if the DN is missing, it will return LDAP\_URL\_ERR\_MEM. Unfortunately, LDAP\_URL\_ERR\_MEM is also returned for other errors. It is up to the caller to determine if there was a problem with the DN by looking at the returned structure.

The slapi function

    int slapi_ldap_url_parse(const char *url, LDAPURLDesc **ludpp, int require_dn, int *secure)    

is used to parse URLs. If require\_dn is set, the url must have a DN or the parse function will return an error. If the secure flag is passed, the function will return secure == TRUE if the url is for a secure protocol (i.e. begins with ldaps:).

### ldap\_sasl\_interactive\_bind\_ext\_s()

OpenLDAP does not have ldap\_sasl\_interactive\_bind\_ext\_s(), only ldap\_sasl\_interactive\_bind\_s(). The only difference is that ldap\_sasl\_interactive\_bind\_ext\_s() has a LDAPControl \*\*\*rctrl parameter which is used to return the response controls from the server. The response controls are useful because without them there is no way to get information about password policy. We could just copy ldap\_sasl\_interactive\_bind\_s() from OpenLDAP into slapi and merge in the \_ext changes to make it ldap\_sasl\_interactive\_bind\_ext\_s(). We could attempt to get ldap\_sasl\_interactive\_bind\_ext\_s() into OpenLDAP. I suspect some resistance due to the response controls parameter, which is sort of a hack, in that it returns the response controls from all of the intermediate ldap\_sasl\_bind responses.

### ldap\_get\_lderrno()

OpenLDAP does not have this function. The way to get the LDAP error code, matched dn, and error message is to use ldap\_parse\_result().

### ldap\_create\_proxyauth\_control()

OpenLDAP does not have this function. We can copy it into slapi, and submit the function for inclusion in OpenLDAP.

### ldap\_str2charray()

Use str2charray() in charray.c - export this and str2charray\_ext() to slapi as slapi\_X.

### ldap\_create\_filter()

referint.c - use PR\_smprintf or similar - need to normalize origDN first?

### ldap\_init()

This is deprecated - have to use ldap\_initialize() (converting host:port to an LDAP URL string) or ldap\_create() (then set the host:port afterwards).

### ldap\_simple\_bind\_s()

This is deprecated - use ldap\_sasl\_bind\_s() with LDAP\_SASL\_SIMPLE as the mech instead.

### ldap\_set\_rebind\_proc()

The callback functions take different parameters.

Mozilla LDAP:

    typedef int (LDAP_CALL LDAP_CALLBACK LDAP_REBINDPROC_CALLBACK)( LDAP *ld,
            char **dnp, char **passwdp, int *authmethodp, int freeit, void *arg);

    LDAP_API(void) LDAP_CALL ldap_set_rebind_proc( LDAP *ld,
            LDAP_REBINDPROC_CALLBACK *rebindproc, void *arg );

OpenLDAP:

    typedef int (LDAP_REBIND_PROC) LDAP_P((
            LDAP *ld, LDAP_CONST char *url,
            ber_tag_t request, ber_int_t msgid,
            void *params ));

    LDAP_F( int ) ldap_set_rebind_proc LDAP_P((
            LDAP *ld,
            LDAP_REBIND_PROC *rebind_proc,
            void *params ));

### ldap\_X deprecated in favor of ldap\_X\_ext

Most of the ldap\_X[\_s] functions have been deprecated e.g. ldap\_unbind(), ldap\_add\_s(), etc. The \_ext versions should be used instead e.g. ldap\_unbind -\> ldap\_unbind\_ext.

LDAP BER
========

OpenLDAP provides BER codecs such as ber\_printf, ber\_scanf, and many others. In general, OpenLDAP provides a superset of the functionality of MozLDAP, so there should be few difficulties here.

-   ber\_special\_alloc, ber\_special\_free - Only used in the operation code - move into operation.c
-   MozLDAP uses LBER\_SOCKET - OpenLDAP uses LBER\_SOCKET\_T
    -   Just use an \#ifndef to define LBER\_SOCKET
-   BER I/O functions - MozLDAP uses struct lextiof\_socket\_private to pass in the I/O functions that the BER layer should use - OpenLDAP uses struct sockbuf\_io
    -   code uses \#ifdef USE\_OPENLDAP - uses sockbuf\_io functions for openldap, and the lber lextiof I/O functions for MozLDAP

ber\_len\_t
-----------

MozLDAP defines this as an int, but OpenLDAP defines this as a long. We will have to check all places where this is used to make sure we do not have any 64-bit issues.

If you see this error, include lber.h before ldif.h:

    /usr/local/include/ldif.h:56: error: expected declaration specifiers or '...' before 'ber_len_t'

ber\_get\_next\_buffer\_ext()
-----------------------------

OpenLDAP does not provide this function - use ber\_get\_next() instead. The openldap\_read\_function will actually "read" from the buffer filled in by connection\_read - the openldap\_write\_function will write to the PRFD. This is why the private data used by the sockbuf IO functions use the Connection\* instead of just the PRFD.

LBER\_OVERFLOW
--------------

If the max incoming BER length is greater than the max, MozLDAP returns LBER\_OVERFLOW. OpenLDAP returns LBER\_DEFAULT and sets sock\_error(ERANGE). Unfortunately, ERANGE is used for other cases as well (e.g. tag specified but length == 0). So it will be a little harder to do max ber detection portably.

LDIF
====

MozLDAP provides a public API for parsing LDIF files. OpenLDAP has almost the same functions (ldif.c), but they are private to the library (liblutil). A patch has been submitted to expose the LDIF functionality to the public (http://www.openldap.org/its/index.cgi/Incoming?id=6194). There are still some differences. The biggest one is that OpenLDAP has no way to generate LDIF files that are not wrapped. OpenLDAP assumes that since the LDIF is defined as a wrapped format, everyone who uses LDIF must wrap/unwrap. There are a number of places where MozLDAP (ldapsearch -T) or 389 (db2ldif -U) generate unwrapped LDIF. ldif\_sput() has a type parameter that takes a bitfield - we could add a LDIF\_PUT\_NOWRAP option which could be OR'd with the type parameter, and change ldif\_sput() to allow unwrapped LDIF output. The initial code in SLAPI will implement the nowrap option as a wrapper around the OpenLDAP function, and will unwrap the LDIF output by ldif\_sput(). Since the string length will decrease with unwrapping, the function can just do the unwrap in place. slapi\_ldif\_put\_type\_and\_value\_with\_options() is the new wrapper function.

These are different

-   LDIF\_MAX\_LINE\_WIDTH - LDIF\_LINE\_WIDTH
-   LDIF\_OPT\_VALUE\_IS\_URL - LDIF\_PUT\_URL

OpenLDAP does not define these:

-   LDIF\_OPT\_NOWRAP - implemented in SLAPI as an option around the OpenLDAP function - will "unwrap" the buffer formatted by OpenLDAP - other apps will need to do something similar
-   LDIF\_OPT\_MINIMAL\_ENCODING - not implemented in the OpenLDAP version, so no minimal encoding there - I don't think this will be a problem
-   ldif\_put\_type\_and\_value - ldif\_sput()
-   ldif\_put\_type\_and\_value\_nowrap - ldif\_sput()
-   ldif\_put\_type\_and\_value\_with\_options - ldif\_sput()
-   ldif\_type\_and\_value - ldif\_sput()
-   ldif\_type\_and\_value\_nowrap - ldif\_sput()
-   ldif\_type\_and\_value\_with\_options - ldif\_sput()
-   ldif\_base64\_decode - this is done automatically
-   ldif\_base64\_encode - looks like with OpenLDAP you first register (ldif\_must\_b64\_encode\_register()) the attributes that must be base64 encoded, then the "put" routines will automatically base64 encode them, then you have to call ldif\_must\_b64\_encode\_release() to "unregister"
    -   userPassword is always encoded
-   ldif\_base64\_encode\_nowrap
-   ldif\_get\_entry - ldif\_read\_record()

UTF-8
=====

MozLDAP provides a public API for doing string manipulation of UTF-8 encoded strings (ldap\_utf8len(), ldap\_utf8strtok\_r(), ldap\_utf8isalnum(), etc.) OpenLDAP has most of these same functions, but the names are slightly different (e.g. ldap\_utf8\_next()), and the interface is private to the library (utf-8.c).

For the directory server, we have two options

-   copy the UTF-8 API into SLAPI
-   export the OpenLDAP utf-8.c and ldap\_pvt\_uc.h UTF-8 APIs
    -   Note that many of the names are different e.g. ldap\_utf8\_next() instead of ldap\_utf8next()

The fastest would be the first option - it would be trivial to make these available via SLAPI. I don't know if there is any motivation in the OpenLDAP community to expose these APIs. A new file - utf8.c - has been added to SLAPI. This is only compiled when using OpenLDAP.

Outside of the server, the only places these are used are adminutil and dsgw. Since both of these also use ICU, and ICU has UTF-8 string functions, one option would be to just use ICU:

-   ldap\_utf8len() - not used
-   ldap\_utf8next() - U8\_NEXT
-   ldap\_utf8prev() - U8\_PREV
-   ldap\_utf8copy() - U8\_APPEND
-   ldap\_utf8characters() - not used
-   ldap\_utf8getcc() - U8\_NEXT
-   ldap\_utf8strtok\_r() - none - there is u\_strtok\_r but that operates on UChar\*, not strings of UTF-8 characters
    -   this is only used in one place - in dsgw config.c - maybe rewrite that code or just do the UTF-8 to UChar conversion and use u\_strtok\_r

The ldap\_utf8isX functions take a char \*, but the u\_isX functions take a UChar32. In most cases these functions are used when iterating through a string (e.g. using isspace to trim leading and trailing spaces). These cases will work well when using U8\_NEXT and U8\_PREV, since those also return the UTF-8 char as a UChar32.

-   ldap\_utf8isalnum - u\_isalnum
-   ldap\_utf8isalpha - u\_isalpha
-   ldap\_utf8isdigit - u\_isdigit with radix 10
-   ldap\_utf8isxdigit - u\_isdigit with radix 16
-   ldap\_utf8isspace - u\_isspace

There are several macros which just wrap the corresponding function. We could just define these in the adminutil and dsgw header files.

-   1.  define LDAP\_UTF8LEN(s) ((0x80 & \*(unsigned char\*)(s)) ? ldap\_utf8len (s) : 1)
-   1.  define LDAP\_UTF8NEXT(s) ((0x80 & \*(unsigned char\*)(s)) ? ldap\_utf8next(s) : ( s)+1)
-   1.  define LDAP\_UTF8INC(s) ((0x80 & \*(unsigned char\*)(s)) ? s=ldap\_utf8next(s) : ++s)
-   1.  define LDAP\_UTF8PREV(s) ldap\_utf8prev(s)
-   1.  define LDAP\_UTF8DEC(s) (s=ldap\_utf8prev(s))
-   1.  define LDAP\_UTF8COPY(d,s) ((0x80 & \*(unsigned char\*)(s)) ? ldap\_utf8copy(d,s) : ((\*(d) = \*(s)), 1))
-   1.  define LDAP\_UTF8GETCC(s) ((0x80 & \*(unsigned char\*)(s)) ? ldap\_utf8getcc (&s) : \*s++)
-   1.  define LDAP\_UTF8GETC(s) ((0x80 & \*(unsigned char\*)(s)) ? ldap\_utf8getcc ((const char\*\*)&s) : \*s++)

Crypto
======

TLS/SSL
-------

OpenLDAP CVS HEAD (2.4.17) has support for MozNSS crypto. This works for apps that use the library as well as standalone apps like ldapsearch, etc. and OpenLDAP in server mode. There are some caveats:

-   The TLS parameters like cacertdir, cacertfile, certfile, and keyfile have been overloaded to provide parameters for NSS:
    -   cacertdir or the directory of cacertfile is used for the NSS key/cert db directory
    -   certfile is used for the name of the cert to use (for server or for client auth)
    -   keyfile is used for the key/cert db pin text (however, openldap only supports unlocked keys)
-   more info [<http://www.openldap.org/faq/data/cache/1514.html>](http://www.openldap.org/faq/data/cache/1514.html)

