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


Major configuration options and enablement
------------------------------------------

The DN returned to the client can be controlled by the following setting under **cn=config**

    nsslapd-return-original-entrydn:  on/off     Default is "off"

When "on" it will return the DN exactly how it was originally added to the database (what is stored in **dsEntryDN**.  If it's "off" then the base DN of the entry DN will match the database suffix configuration as set under **cn=userroot,cn=ldbm database,cn=plugins,cn=config** via the attribute **nsslapd-suffix**.  Basically when "off" it will continue to return DN as it has since RHDS 10 (389-ds-base-1.3.10)

Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=2075017>
<https://github.com/389ds/389-ds-base/issues/5267>

Author
------

<mreynolds@redhat.com>
