---
title: "Anonymous Resource Limits"
---

# Anonymous Resource Limits
---------------------------

This document describes the implementation of a feature to impose resource limits on an anonymous bind identity.

Overview
--------

The 389 Directory Server currently has support for bind-based resource limits. This allows you to set limit attributes directly in a user's entry (or via CoS) which will be imposed on that user. If a user does not have any limit attributes set in their entry, the default server settings will be used. It may be desirable to have the limits for an anonymously bound user to differ from the default server limits. Since there is no physical entry to represent the anonymous user, there is currently no way to set limits to only apply to anonymously bound clients.

Usage
-----

This implementation adds a new configuration attribute named **nsslapd-anonlimitsdn**. The value of this config setting should be set to the DN of a template entry that contains the resource limit attributes that you want to impose on anonymously bound clients. It is preferable that this template entry be placed in a suffix that is stored in normal backend for performance reasons. The template entry can be placed in the **cn=config** tree, but performance will suffer due to the lack of an entry cache.

The current supported resource limit attributes are:

-   nsIdleTimeout
-   nsSizeLimit
-   nsTimeLimit
-   nsLookThroughLimit

This implementation approach has the benefit of automatically working with any bind-based resource limits that are added via the slapi\_reslimit\_\* API. This benefit would not be possible with new discrete configuration settings in **cn=config** for each supported limit, which is why the template approach was taken.
