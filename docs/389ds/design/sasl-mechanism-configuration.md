---
title: "Design/SASL Mechanism Configuration"
---

# SASL Mechanism Control Design
--------------------------

Overview
--------

Starting 1.3.1 there is now control over what SASL mechanisms the Directory Server will allow for authentication.

Use Cases
---------

Environments where many SASL mechanisms are available, but only certain ones are preferred. Example, CRAM-MD5 and SCRAM-SHA-1 are available on a server. SCRAM-SHA-1 is more secure and might be the preferred mechanism choice. Setting "nsslapd-allowed-sasl-mechanisms: SCRAM-SHA-1" will only allow SCRAM-SHA-1 SSL authentications, and not CRAM-MD5.

Design
------

Using the new configuration attribute "nsslapd-allowed-sasl-mechanisms", specify the list the mechanisms you wish to allow. Mechanism names must consist of upper-case letters, numbers, hyphens, and underscores. Each mechanism can be separated by commas or spaces. Note, the EXTERNAL mechanism is not actually used by any SASL plugin. It is internal to the server, and is mainly used for SSL client authentication. Hence, the EXTERNAL mechanism can not be restricted or controlled. It will always appear in the supported mechanisms list, regardless of what is set as "allowed".

This setting does not require a server restart to take effect.

Implementation
--------------

No additional requirements.

Feature Management
-----------------

CLI only.

Major configuration options and enablement
------------------------------------------

In the cn=config entry:

    nsslapd-allowed-sasl-mechanisms: <MECHANISM, MECHANISM, ...>

Example:

    nsslapd-allowed-sasl-mechanisms: GSSAPI, DIGEST-MD5
    nsslapd-allowed-sasl-mechanisms: GSSAPI DIGEST-MD5 OTP

Replication
-----------

No impact.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

