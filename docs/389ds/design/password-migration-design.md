---
title: "Password Migration Design"
---

# Password Migration Design
----------------------------

{% include toc.md %}

Overview
--------

When migrating from a different identity store to 389 DS, there may be no easy way to migrate user's existing passwords. If one is moving from a different LDAP server, the password hashes might be able to just be moved over directly. This does not work in cases where 389 DS does not support the hashing scheme that the passwords are stored in, or if it is impossible to get the hashed passwords for technical or policy reasons. In this latter scenario, one is forced to make all of their users reset their passwords, which is not desirable.

This problem is often seen when one first configures 389 DS synchronization with Active Directory. What happens is that the initial sync brings all of the user entries over from AD to 389 DS without their passwords. One needs to then force a reset of all of the user passwords in AD to trigger our PassSync plug-in to capture the new passwords and send them to 389 DS.

This design document describes a way that we would be able to avoid the need to force a password reset of all users to initially migrate passwords to 389 DS from another identity store.

Approach
--------

The existing Pass-Through Authentication and PAM Pass-Through Authentication plug-ins of 389 DS can be leveraged to ease password migration from an external identity store. Typically, the Pass-Through Authentication plug-ins are configured to use an external authentication source as a long-term or permanent basis. The addition of a password migration mode option to both the Pass-Through Authentication and PAM Pass-Through Authentication plug-ins would allow us to use pass-through authentication when we need to migrate a password, but to use locally stored credentials once they have been migrated. The decision of doing pass-through authentication vs. local authentication is determined by the existence of the userPassword attribute in the bind target entry. If no userPassword value exists locally, we use pass-through authentication. If the pass-through authentication is successful, we then hash the clear-text password that was provided as a part of the incoming BIND operation and store it locally in the userPassword attribute. The next time this user does a BIND, we simply authenticate by comparing against the local userPassword value instead of doing pass-through authentication.

This approach is best illustrated by an example of how this would work when using AD synchronization:

-   Sync agreement is set up and initialized. User entries are created in 389 DS at this point, but they will have no userPassword attribute since we can't extract password from AD.
-   Pass-Through authentication is configured in password migration mode on 389 DS for the user subtree.
-   A newly synchronized user makes their first simple bind attempt against 389 DS. The Pass-Through Authentication plug-in finds no userPassword attribute in the user's entry, so we do a pass-through authentication against AD.
-   The Pass-Through Authentication plug-in checks the result of the BIND operation against AD. If it was successful, we hash the clear-text password that was provided by the client performing the initial BIND operation, then store it locally as the user's userPassword attribute value.
-   The user later attempts to do another BIND operation against 389 DS. The Pass-Through Authentication plug-in detects that the user's entry has a userPassword value and does a local authentication instead of using pass-through to AD.

The end result of this approach is that users can immediately authenticate to either Active Directory or 389 DS after synchronization takes place without the need for a password reset. This also isn't limited to Active Directory, as any other authentication source that can be used with the Pass-Through Authentication and PAM Pass-Through Authentication plug-ins would work.

Implementation Details
----------------------

The following plug-ins would need to be modified:

-   Pass-Through Authentication
-   PAM Pass-Through Authentication

Both of these plug-ins would need support for a new config switch that enables password migration mode. The PAM Pass-Through Authentication plug-in is currently more flexible in the way that it can be applied to entries, as it allows filters to be used to target entries. The Pass-Through Authentication plug-in is not as flexible, as it only can be configured to operate at the subtree level. Ideally, we would make this allow a filter to be used to target entries in the same way that the PAM Pass-Through Authentication plug-in works.

Potential corner-cases that need to be considered during implementation are:

-   The 389 DS password policy does not allow the password to be migrated. Options are:
    -   Let the bind succeed and override the password policy.
    -   Let the bind succeed and skip storing the password locally.
    -   Let the bind succeed and force the password to be reset as if it were expired.
-   Others?

