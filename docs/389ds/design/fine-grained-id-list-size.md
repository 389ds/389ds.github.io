---
title: "Fine Grained ID List Size"
---

# Fine Grained ID List Size
---------------------------

{% include toc.md %}

Overview
--------

With very large databases, some queries go through a lot of work to build huge ID lists for filter components with many matching IDs. For example, a search for "*(&(objectclass=inetorgperson)(uid=foo))*" may build a huge idlist for "*objectclass=inetorgperson*" only to throw it away to intersect it with "*uid=foo*". In these cases, it would be useful to be able to tell the indexing code to use a different idlistscanlimit for certain indexes, or use no idlist at all. In the above case, it would be useful to tell the indexing code to skip building an idlist for objectclass=inetorgperson, but still use the default idlistscanlimit for other objectclass searches (e.g. objectclass=groupOfNames).

Another example of this problem is <https://github.com/389ds/389-ds-base/issues/811> - if there are several million IDs for each of the objectclass= filter components, being able to skip id list generation for the objectclass values would make that query very fast.

Unfortunately, nsslapd-idlistscanlimit is a blunt instrument - it applies to all indexes in the database. We currently have no way to specify a different idlistscanlimit for different types of search filters.

In these cases, we have a search filter which has an attribute with a large number of matching values, and another attribute with a very small number of matching values. We need to have the ability to control the max ID list size for a given index, including the type of index (eq, sub), and even the equality value - a different max ID list size for specific values of objectclass - for example, in the above, a size of 0 for objectclass=inetorgperson, but use the default for objectclass=groupOfNames.

Use Cases
---------

### Reduce large ID lists that are thrown away

If there are 10 million entries that match objectclass=inetorgperson, then a search for (&(objectclass=inetorgperson)(uid=foo)) will build an ID list containing 10m IDs for objectclass=inetorgperson, then throw it away to intersect it with uid=foo. If there are many simultaneous searches like this, the amount of CPU and RAM resources consumed by the server is great, and the performance suffers.

### Allow certain very large ID lists

In some cases, the user may want to allow a very large ID list for some searches, in order that they are indexed and fast, but not increase the nsslapd-idlistscanlimit for all searches. For example, an application wants to be able to search for users by pattern (substring), and wants that search to be as fast as possible (i.e. indexed, not look through).

The user wants the search for (sn=sm\*) to be very fast (indexed), and so wants to have a very high idlistscanlimit for the "sn" "sub" index (there may be hundreds of thousands of users that match "sm\*" - "smith", "small", etc.), but wants to have a very low idlistscanlimit for other searches.

Design
------

We cannot reuse or re-purpose nsslapd-idlistscanlimit, so the proposed solution is to add a new allowed attribute to the nsIndex objectclass: **nsIndexIDListScanLimit**

    nsIndexIDListScanLimit: limit=NNN [type=eq[,sub,...]] [flags=AND[,XXX..]] [values=val[,val...]]

This is a multi-valued, DirectoryString syntax attribute, which is allowed (optional) for the nsIndex objectclass.

-   maxsize - required - the max size of the ID list. The value can be -1 (unlimited), 0 (do not use the index at all), or a number to use for the idlistscanlimit.
-   indextype - optional - the type of index - eq, sub, pres, etc. - must be one of the actual nsIndexType specified for the index definition i.e. you can't use indextype "eq" here if you don't have nsIndexType: eq already defined.
-   flag - optional - flags that alter the behavior of applying the scan limit
    -   AND - apply the scan limit only to searches in which the attribute appears in an AND clause
        -   for example apply the limit to *objectclass=inetorgperson* in *(&(objectclass=inetorgperson)(uid=someuser))* since it will be intersected (AND) with another filter, but not in *(objectclass=inetorgperson)* by itself
-   values - optional - a comma-delimited list of values which must match in the search filter in order for the limit to be applied. Since the matches are done one at a time (we evaluate one filter component at a time), the values will match if any of the values match.
    -   The values must be used with only one type at a time. If values are specified, type must be specified, and type must be a type that deals with values, such as eq or sub. There must be only one type specified - you can't specify values if you use type=eq,pres or otherwise specify more than one type.
    -   The values must correspond to the index type (eq, sub), and must correspond to the syntax of the attribute to which the index is applied - that is, if you have attribute uidNumber (integer) and it is indexed for eq, you can't specify

    type=eq values=abc

because "abc" is not integer syntax.

-   If the values contain spaces, commas, nulls, other values which require escapes, the LDAP filter escape syntax should be used - backslash '\\' followed by the 2 hex digit code for the character. For example, DN syntax values:

        dn: cn=uniquemember,cn=index,cn=userRoot,cn=ldbm database,cn=plugins,cn=config
        changetype: modify
        replace: nsIndexIDListScanLimit
        nsIndexIDListScanLimit: limit=0 type=eq values=uid=kvaughan\2Cou=People\2Cdc=example\2Cdc=com,uid=rdaugherty\2Cou=People\2Cdc=example\2Cdc=com

the commas in the DN values are replaced with **"\\2C"**

-   The values are processed as if they were filter values - so for "sub" values, values like "values=\*sm\*ith\*" will be processed as if they were values in a substring search filter like (sn=\*sm\*ith\*)

        dn: cn=objectclass,...
        objectclass: nsIndex
        nsIndexType: eq
        nsIndexIDListScanLimit: limit=0 type=eq flags=AND values=inetOrgPerson
        nsIndexIDListScanLimit: limit=1 type=eq values=inetOrgPerson
        nsIndexIDListScanLimit: limit=2 type=eq flags=AND
        nsIndexIDListScanLimit: limit=3 type=eq
        nsIndexIDListScanLimit: limit=4 flags=AND
        nsIndexIDListScanLimit: limit=5

-   If the search filter is (&(objectclass=inetOrgPerson)(uid=foo)) then the limit=0 because all 3 of type, flags, and value match
-   If the search filter is (objectclass=inetOrgPerson) then the limit=1 because type and value match but flag does not
-   If the search filter is (&(objectclass=posixAccount)(uid=foo)) the the limit=2 because type and flags match
-   If the search filter is (objectclass=posixAccount) then the limit=3 because only the type matches
-   If the search filter is (&(objectclass=\*account\*)(objectclass=\*)) then the limit=4 because only flags match but not the types (sub and pres)
-   If the search filter is (objectclass=\*account\*) then the limit=5 because only the attribute matches but none of flags, type, or value matches

For example, in the objectclass case, you might want to have a maxsize of 0 for inetorgperson:

    dn: cn=objectclass,cn=index,...
    objectclass: nsIndex
    nsIndexType: eq
    nsIndexIDListScanLimit: limit=0 type=eq values=inetorgperson

This means, build no ID list ("0") for "objectclass=inetorgperson", but use the default nsslapd-idlistscanlimit value for other objectclass=\$value searches.

Or, to apply the limit only to the use of objectclass=inetorgperson in AND clauses

    dn: cn=objectclass,cn=index,...
    objectclass: nsIndex
    nsIndexType: eq
    nsIndexIDListScanLimit: limit=0 type=eq flags=AND values=inetorgperson

This means, build no ID list ("0") for "objectclass=inetorgperson" when used in an AND clause like *(&(objectclass=inetorgperson)(uid=someuser))*, but use the default nsslapd-idlistscanlimit value for other objectclass=\$value searches, like *(objectclass=inetorgperson)* or in an OR clause like *(\|(objectclass=inetorgperson)(objectclass=posixAccount))*

Or, for a substring example:

    dn: cn=givenName,cn=index,...
    objectclass: nsIndex
    nsIndexType: sub
    nsIndexIDListScanLimit: limit=-1 type=sub values=ab*

This means, use an unlimited max ID list size for (givenname=ab\*) but use the default for other givenname substring searches.

Implementation
--------------

The struct attrinfo used to store per-attribute index information has been extended with a new member ai\_idlistinfo which holds the parsed nsIndexIDListSizeLimit values for the index. This is implemented as a DataList object. ai\_idlistinfo is only created if there is at least one valid nsIndexIDListSizeLimit. There is much additional parsing code added to ldbm\_attr.c. The list of values is first checked for syntax, then converted to index keys (normalized) and stored as a Slapi\_ValueSet. This allows fast value lookup during the indexing.

NOTE: There is no result checking for dynamic index setting over LDAP. The client has no way to know if the change was valid or not. The only way to tell currently is to look at the errors log for errors. Tests should be implemented to examine the errors log.

The server already had support for using a different idlistscanlimit (called allidslimit in the index code) for each lookup. An additional function was inserted into index\_read\_ext\_allids() - index\_get\_allids(). When an index lookup happens, the values from the search filter are converted to keys in the same format. If the index specified nsIndexIDListSizeLimit with values, each index value is looked up in the Slapi\_ValueSet to find a match. The index type (eq, sub) are also compared, and the flags. Each match is scored, and the idlistscanlimit corresponding to the best match is returned.

Major configuration options and enablement
------------------------------------------

If nsIndexIDListScanLimit is not specified for an index, the nsslapd-idlistscanlimit value for the database is used.

The nsIndexIDListScanLimit setting is fully dynamic - live changes take place immediately.

Replication
-----------

There should be no impact on replication.

Updates and Upgrades
--------------------

There should be no impact on update/upgrade.

Dependencies
------------

This will not change any dependencies.

External Impact
---------------

Documentation. We will need to document the new attribute in the various guides to which it is applicable, and in the Release Notes. We will need to advertise this to other groups heavily using 389 such as DogTag and FreeIPA.

