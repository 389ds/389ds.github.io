---
title: "Maximum Controls Per Operation Design"
---

# Maximum Controls Per Operation Design
----------------

Overview
--------

The Directory Server did not previously put a limit on the number of controls it would process during a single operation.  This can leads to high CPU, high memory usage, and DOS. To avoid this the server needs to implement a configurable limit on the number of controls that it will process before rejecting the operation.

Design
------

Add a new configuration settings to fine tune what control limit should be. The server will default to **10** as the maximum number of controls to accept.  If the controls exceed this limit then an error 53 (UNWILLING_TO_PERFORM) will be returned to the client.


Major configuration options and enablement
------------------------------------------

A new configuration attribute **nsslapd-maxcontrolsperop** is now available under *cn=config* and accepts values between 1 and 1000.  The default is **10**.

    dn: cn=config
    ...
    nsslapd-maxcontrolsperop: 10


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/7503>
<https://access.redhat.com/security/cve/cve-2026-9064>
<https://bugzilla.redhat.com/show_bug.cgi?id=2480093>


Author
------

<mreynolds@redhat.com>

