---
title: "Dynamic Certificate Mapping"
---

# Dynamic Certificate Mapping

## Overview
-----------

Today, we support authentication via x509 certificates through a SASL EXTERNAL bind. Because the content of the x509 certificate is validated by a known trusted CA, we are able to trust it's content.

However, the certificate data, such as common name or other subject related data, does not correlate to LDAP DN's.

Right now we support static certificate maps, that express mappings of these certificate attributes to LDAP object attributes, but this is not very expressive.

The FreeIPA project have developed a [dynamic mapping](http://www.freeipa.org/page/V4/Certificate_Identity_Mapping) scheme, that allows the maps to be replicated, and apply with different rules.

## Mapping process
------------------

The current mapping process is performed in two steps. First is during post TLS/SSL handshake in ./ldap/servers/slapd/auth.c handle_handshake_done(). This calls ldapu_cert_to_ldap_entry(), which takes the current certificate information and returns an entry that is valid for the bind. The client DN is extracted from the entry and placed the pblock via the call to bind_credentials_set_nolock. The bind is "authenticated" at this point, but we still expect a SASL EXTERNAL request to complete the process.

The second part is during bind.c (the first message to an ldap server is always a bind request), we recieve the SASL_EXTERNAL request. We look in the pb_conn for the c_external_dn we were provided during cert_to_ldap_entry(). We now call bind_credentials_set(), and the TLS bind is complete.

This means that any change to allow dynamic mapping must occur in auth.c, because this is where we have the certificate information.

## Allowing dynamic mapping
---------------------------

To enable this "quickly and easily", we propose making this process plugable. This way, we can retain our current certmap.conf details, and the IPA project can add their mapper in addition.

During this design, we must consider [plugin v4](plugin-v4.html). As such, every plugin here should consider itself a betxn plugin of some form.

### Plugin hooks
----------------

A new plugin type of:

    SLAPI_PLUGIN_PRE_TLS_BIND: pretlsbind

This will have the following function pointer:

    SLAPI_PLUGIN_RO_PRE_TLS_MAP_FN

This function may only perform read operations during it's execution. This is inline with the plugin v4 design.

The function signature shall be:

    slapi_certmap_result plugin_map_callback(Slapi_PBlock *pb)

TBD: What do we provide in the PB for the cert details? Do we want to make a "new pb" type instead? Or sub-pblock struct?

The slapi_certmap_result is an enum of:

    0: SUCCESS, operation was correct and complete
    1: CONTINUE, operation was ignored, continue to the next plugin
    2: INVALID_DN, the mapping worked, but we resolved an invalid dn / entry.

On SUCCESS, the callback shall provide the pblock with the entry that was mapped to. This will be set in:

    slapi_pblock_set_tls_map_entry(Slapi_PBlock *pb, Slapi_Entry, *e)

### Plugin Call
---------------

We will add a new plugin_call function:

    plugin_call_tls_map_plugin()

TBD: What do we provide to this call for cert details that will be passed to the plugins?

### Executing the callback
--------------------------

The call to plugin_call_tls_map_plugin() will be called from auth.c during the handle_handshake_done() function. The current SASL extern operation in bind.c should be un-affected.

## Author
---------

wibrown at redhat.com

