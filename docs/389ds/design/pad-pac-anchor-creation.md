---
title: "PAD/PAC anchor extraction and creation"
---

# PAD/PAC extraction and creation

## Overview
-----------

In the FreeIPA trust to AD, and even the proposed FreeIPA to FreeIPA trust case, we need to extract trusted members groups. Instead of contacting a remote DC, the TGT for the user contains a PAC/PAD (Privilege Attribute Certificate, Posix authorisation data).

By extracting this data, we can create "anchor" entries in our local domain, and then bind them to LDAP, use our resources and more.

## Anchor entries
-----------------

Anchor entries are needed in Directory Server because without these we are unable to complete a bind operation. This is because bind operations currently rely on contacting
the backend which expects a real entry to exist within it. The reason for this is chaining db: a chained bind, must contact a remove backend to do the bind, so this design
has to stay.

As a result, if we have a new PAD/PAC from gssapi presented, we may not have it's anchor entry, and so the bind would fail.

During the GSSAPI bind (and only GSSAPI), as we perform the ids_sasl_canon_user step, we need to have the possibility to create these anchors.

### Anchor creation
-------------------

Today, FreeIPA manually creates these anchor entries, and they are associated with trust-groups. An example entry is:

    dn: ipaanchoruuid=:SID:S-1-5-21-1356309095-650748730-1613512775-500,cn=Default Trust View,cn=views,cn=accounts,dc=xs,dc=ipa,dc=cool
    ipaanchoruuid: :SID:S-1-5-21-1356309095-650748730-1613512775-500
    description: Cool Administrator
    gecos: IMCOOL
    loginshell: /bin/bash
    usercertificate: <some certificate>
    ipaoriginaluid: administrator@ad.ipa.cool
    objectClass: ipaOverrideAnchor
    objectClass: top
    objectClass: ipaUserOverride
    objectClass: ipasshuser
    objectClass: ipaSshGroupOfPubKeys

During the call to ids_sasl_user_to_entry(), we should extract the relevant PAD/PAC data from SASL, and use this to create these anchors.

This should *not* be a plugin, but a core server feature. It's just quite a complex interaction so we should keep this internal.

We should have a configuration such as:

nsslapd-gssapi-pad-pac-extract: on/off
nsslapd-gssapi-pad-pac-map: dn=template,cn=views,dc=...

The template would be similar to mep, mapping PAC/PAD fields into entry fields with minimal work.

Alternately, we may just choose to completely contain the template in the code, rather than allowing this to be configured.

A final option, would be to have a plugin call in ids_sasl_user_to_entry(), performed in a write transaction that can complete this, so that IPA could make and maintain their own plugin.

### Anchor groups
-----------------

PAD/PAC's provide a list of SIDs to which groups they are members of. There are two proposed solutions to handling these. The reason this is important is this affects 389-ds aci evalutation, hbac tests, get effective rights, auditing and more.

#### member attributes
----------------------

During the anchor creation, based on the list of SIDs, we examine the db for group anchors that match. FreeIPA provides these with their associated external sid. If we find the SID in the PAC/PAD, we add the anchor as a member to the group. 

If a SID in the PAC/PAD is not found in the external group map, we do not use it.

We perform this check each bind operation, to ensure that any change in the external members groups are reflected in our understanding of the mappings. As the external user may only bind via GSSAPI, we can "trust" that each bind must be reflective of the valid state.

We write the "issue time" of the ticket to the entry. If an older ticket is presented, we do not procees the PAD/PAC. If we have already seen the ticket at issue time X, we do not reprocess it. This way an *old* TGT would be denied access if a newer PAC/PAD had been presented that removes a membership(or added it).

A signifigant benefit to this approach is that our anchor entry would have complete and correct memberOf attributes, even through nested groups to IPA. Consider:

    anchor: x -> external_group: y -> ipa_group: z

anchor would contain:

    memberOf: external_group
    memberOf: ipa_group

Additionally, any other changes to ipa_group, or external group would be reflected correctly on the anchor. This allows correct and complete auditing of changes and how group memberships will affect external domain members (as well as potentially which external users are affected).

Another benefit is this change is replicated through out the domain, so we save PAC/PAD processing time on ticket reuse, or when the memberships don't change.

We also don't need to do anything else. ACIs and all other directory server features "just work", because we have use the existing, correct, and proved membership features of the server. This will aid us as we use memberOf further in the future. Another example of this is get effective rights (which is normally performed by another account, rather than the bind account itself). We would also have a correct audit chain in the audit log as the PAC/PAD memberships are added/removed (even via internal ops).

#### dynamic extraction
-----------------------

An alternative to the above is that on each *bind* we resolve the SIDs to a list of groups, and we place these in the connection's bind credentials.

We would then have to have another path in all group membership checks that looks at the entries groups *and* checks the connection's groups.

This would affect the membership resolution of many parts of the code, potentially including nsRoles, COS, memberOf, aci and others.

To aleviate this, we could introduce a "slapi_dn_memberof" api that allowed resolving and extracting these groups, as well as performing the PAD/PAC extraction as needed.

The advantage is that there is "less" written the backend, and that we only need to check what's in the PAD/PAC. However, it does mean much more edge case processing throughout the codebase to handle this. In some cases, because we may have out-of-order PAC/PAD's, if any other plugins during anchor processing called dn_memberof(), it may cause write thrashing (if the two PAC/PAD have a differening membership list). This would largely affect memberOf.

Alternately, we do not do *any* processing of the PAC/PAD group data *except* for ACI evaluation. This would mean that we only get the groups "per bind". This risk is that many other features which do not have access to the PAC/PAD data now won't work as expected, and this may interfer with auditing.

In this case, we would at bind, list the SIDs of the PAC/PAD into the audit log, to allow a complete audit chain for security reasons.

## Author
---------

wibrown at redhat.com

