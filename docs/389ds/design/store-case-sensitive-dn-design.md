---
title: "Store Case Sensitive DN in Entry"
---

# Store Case Sensitive DN in Entry
----------------

Overview
--------

Directory Server switched to a new IDL format where we only stored the RDN of an entry in the database (id2entry) and not the full DN.  This allowed for more efficient moving of entries between subtrees.  However building the DN from the entry's RDN (via entryrdn_lookup_dn()) is very expensive.  It also forces the case of base DN in the entry DN to match its parent - so the case of the entire DN is NOT preserved.  So by additionally storing the full/intact DN in the entry saves us this work and provides a nice performance boost when first loading entries from disk and into the caches.  We are storing this DN in a new operational attribute "**dsEntryDN**".

Some customers prefer to have the case DN preserved to way it was added by the client.  So to return the original DN (case intact) you can enable a new config setting under *cn=config*: **nsslapd-return-original-entrydn=on**.

Use Cases
---------

This boosts performance and the config setting can help customers migrate from other Directory Servers where they need the DN case preserved.

Behavior Change
----------------

It is important to mention how the DN is returned to clients with this setting "on" or "off".  So in previous versions of DS the **entryrdn** index was used to generate the left most portion of the DN (e.g. uid=user,...), while the Base Suffix of the DN comes from the backend configuration (e.g. ...,dc=example,dc=com).  For example, if you define the backend suffix as "dc=EXAMPLE,dc=COM" under cn=config, then regardless of how entries are added or moved, all the DN's will use "dc=EXAMPLE,dc=COM" as the right most portion of the DN.  So the old format would look like this adding an entry with this DN:

    ADD --->   uid=User,ou=people,dc=example,dc=com

However, when you search for this entry it will be returned as:

    dn: uid=User,ou=people,dc=EXAMPLE,dc=COM

So the *previous* behavior basically forced a consistency in the DN, but this was might not be how the entry was created.    Now we have this new setting which is turned "on" by default because it does provide a noticeable performance improvement.  So out of the box the DN's format might unexpectedly change.  That consistency that once existed might not be the same, but it will match exactly how the client wanted it created.

So now when you add an entry like this below, it will be returned to client in the exact same case:

    uid=User,ou=PEople,dc=ExMPlE,DC=COM

**Final Note** DN case sensitivity has been a topic of debate for some time as to what is following the LDAP standard and what is not.  While the DN attribute itself is supposed to be case insensitive, the attributes used in the DN might not be.  Reading both these rules makes things a little fuzzy.  We always recommend that your LDAP clients should not expect the DN, or DN syntax attributes, to maintain their case.  DN's should always be considered case-insensitive despite what attributes are used in the DN itself.


Major configuration options and enablement
------------------------------------------

The DN returned to the client can be controlled by the following setting under **cn=config**

    nsslapd-return-original-entrydn:  on/off     Default is "on"

When "on" it will return the DN exactly how it was originally added to the database (what is stored in **dsEntryDN**.  If it's "off" then the base DN of the entry DN will match the database suffix configuration as set under **cn=userroot,cn=ldbm database,cn=plugins,cn=config** via the attribute **nsslapd-suffix**.  Basically when "off" it will continue to return DN as it has since RHDS 10 (389-ds-base-1.3.10)

Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=2075017>
<https://github.com/389ds/389-ds-base/issues/5267>

Author
------

<mreynolds@redhat.com>
