---
title: "Password Policy API"
---

# Password Policy API
---------------------

Requirements
------------

The main need that FreeIPA has from the password policy API is to allow a plug-in writer to specify the policy to use for password changes. Ideally, the policies would be defined using the same LDAP attributes that DS itself does, but the policy would be set elsewhere than the user or subtree entry.

Implementation Proposal
-----------------------

The cleanest way to implement the requirements is to provide a public function that returns an opaque pointer to a password policy object that is stored in a passed in DN. This policy object can then be set in the pblock associated with a password change operation. When the DS does it's password checking, it would use the policy set in the pblock if it exists, otherwise it would locate the policy as usual. We need to make sure that the policy object is consumed by the server, or released when the pblock is destroyed at a minimum.

To ensure that the same policy object is used for all password policy related operations, one would need to set the policy pb in the pre-op phase for the following operations:

-   bind (for tracking failed attempts, lockout, etc.)
-   modify
-   add

Implementation Problems
-----------------------

There are some issues blocking the proposed implementation. The main problem is that the current password policy code is embedded in the core server code, not in a plug-in. The password policy code is executed prior to the pre-operation plug-ins. This means that we have no way of setting the policy to use in the pblock before it is checked.

To deal with this problem, we could pull the password policy code up into a pre-op plug-in. This would require quite a bit of work since the code is a bit spread out right now, and we'd need to ensure that it doesn't cause any regressions around password policy functionality. The current code has knowledge about the internals of opaque structures (pb-\>pb\_conn-\>c\_needpw for example), so we'd need to make some changes for these things to use the public API only.

The other issue that we would still need to deal with is that plug-in order is undefined, meaning we wouldn't be guaranteed that we have a chance for a plug-in to set the policy in the pblock before the policy plug-in itself is called. One way of dealing with this is to use the API broker interface to allow the password policy plug-in to provide it's own API.
