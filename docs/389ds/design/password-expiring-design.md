---
title: "Password Expiring Control Configuration"
---

# Password Expiring Control Configuration
----------------

Overview
--------

When a client requests the password expiring control the "time to expire" is only returned if the password is within the warning period.  Other LDAP vendors return this value regardless if the password expiration time is within the warning period.  In order to not break existing clients, a new configuration parameter was added that sets the functionality on or off.

Use Cases
---------

Clients that would like to know when passwords are expiring regardless of the warning period.

Design
------

Add a configuration setting that tells the server to always send the expiring control regardless if its within the warning period.  After a successful bind occurs, and password expiration is set, if we are not within the warning period we still send the expiring time control.

Implementation
--------------

None

Major configuration options and enablement
------------------------------------------

A new configuration attribute was added to the **"cn=config"** entry to always return the expiring control.  The default is *"off"*

    passwordSendExpiringTime: on/off

Replication
-----------

Any impact on replication?

Updates and Upgrades
--------------------

None

Dependencies
------------

None

External Impact
---------------

None

Author
------

<mreynolds@redhat.com>
