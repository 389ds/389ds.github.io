---
title: "Read Entry Control Design"
---

# Read Entry Controls
----------------

Overview
--------

Added support for RFC 4527 - Read Entry Controls in Directory Server 1.3.2.  The Directory Server now supports the pre & post read entry response controls.  If one of these response controls is requested by a client, an ldap search entry is returned that contains the pre/post changes to the entry.  This entry only contains for the changes for the attribute that was listed in the control.

Use Cases
---------

Now that 389 DS has converted most of its plug-ins that perform internal write operations to betxn plug-ins, we can return an entry that was modified by a plug-in with the post-read control.  This is very useful when using plug-ins like DNA or memberOf.

ldapmodify example showing how the attribute **description** was modified:

    ldapmodify -D "cn=directory manager" -w password  -e \!preread=description -e \!postread=description 
    dn: cn=entry,dc=example,dc=com
    changetype: modify
    replace: description
    description: new description

    modifying entry "cn=entry,dc=example,dc=com"
    control: 1.3.6.1.1.13.1 false MEIEHGNuPWV4YW1wbGUsZGM9ZXhhbXBsZSxkYz1jb20wIjAg
     BAtkZXNjcmlwdGlvbjERBA9uZXcgZGVzY3JpcHRpb24=
    # ==> preread
    dn: cn=entry,dc=example,dc=com
    description: old description
    # <== preread
    control: 1.3.6.1.1.13.2 false MEkEHGNuPWV4YW1wbGUsZGM9ZXhhbXBsZSxkYz1jb20wKTAn
     BAtkZXNjcmlwdGlvbjEYBBZuZXcgZGVzY3JpcHRpb24gZm9yIFFF
    # ==> postread
    dn: cn=entry,dc=example,dc=com
    description: new description
    # <== postread

Design
------

pre-read entry control: 1.3.6.1.1.13.1
post-read entry control: 1.3.6.1.1.13.2

The pre-read control returns a copy of the entry before it was modifed, and the post-read control returns the entry after the modify.  Both controls can be used for the same operation.  The control is added just before the result is returned to the client.

Implementation
--------------

None.

Major configuration options and enablement
------------------------------------------

None.

Replication
-----------

None.

Updates and Upgrades
--------------------

None.

Dependencies
------------

Available on 1.3.2 and up.

External Impact
---------------

None.

Author
------

<mreynolds@redhat.com>
