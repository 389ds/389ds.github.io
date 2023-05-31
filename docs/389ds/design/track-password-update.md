---
title: "Track Password Update"
---

# Track Password Update Time
--------------------------

Purpose
-------

Add attribute to store a timestamp of when the password was last changed.

Config (cn=config)
---------------

    passwordTrackUpdateTime: on|off (off by default)

Details
-------

When enabled the operational attribute **pwdUpdateTime** is updated on the entry after its password has been successfully changed. The timestamp is in GeneralizedTime format.
