---
title: "Legacy Password Policy"
---

# Legacy Password Policy
----------------------

Purpose
-------

**passwordMaxFailure** doesn't behave as expected by newer LDAP clients. DS doesn't return error LDAP\_CONSTRAINT\_VIOLATION until after the retry limit is exceeded. Newer clients are expecting the failure to occur when the limit is reached(like in Sun DS/ODSEE), not when it is exceeded. Since this has always been the behavior it is the legacy behavior.

### Config (cn=config)###

    passwordLegacyPolicy: on|off (default is on)

Details
-------

To have the DS send an error when the limit is reached(not when it is exceeded), set this attribute to **off**
