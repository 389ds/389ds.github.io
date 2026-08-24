---
title: "OR Filter Equality Lookup"
---

# OR Filter Equality Lookup
---------------------------

Overview
--------

Applications often send searches that are one big OR of equality tests on
the same attribute:

    (|(uid=user1)(uid=user2)(uid=user3) ... (uid=user1000))

This is how a sync job fetches a batch of accounts, how an inventory system
checks a list of hostnames, and how an org chart tool finds everyone who
reports to a set of managers.

These searches are usually fully indexed, and the index side is quick. The
slow part hides somewhere else. Before returning an entry the server has to
prove the entry really matches the filter, and that filter test walks the
OR from left to right, every branch, for every candidate. Each branch
scans the entry's attributes and normalizes its values all over again.
With 1000 branches and 1000 candidates, that's a million branch evaluations
for a single search.

The lookup replaces the walk: the server builds a sorted table from the
OR's assertion values, once per search, and each candidate entry
normalizes its values once and finds the matching branch with a binary
search. A 355-branch search over 612 candidates drops from 0.24 seconds
to 0.09 seconds, and a 10,000 candidate case from 2.6 seconds to 0.19
seconds; measured against current main, which carries neither this
feature nor the companion Issue 7655 fix beneath it, the same
10,000-candidate case starts at 9.0 seconds (details in the Performance
section). Search results are identical, and anything the table can't 
handle simply falls back to the classic walk.

Use Cases
---------

-   The case from issue 6275: an application keeps its user list in sync
    with the directory and fetches all the accounts it cares about in one
    search, a thousand uids in a single OR:

        (|(uid=jsmith)(uid=mjones)(uid=bwilson)...)

-   An inventory or configuration management system keeps its machines in
    LDAP and checks a batch of hostnames in one query:

        (|(cn=web01.example.com)(cn=web02.example.com)(cn=db03.example.com)...)

-   A backup or quota tool walks a filesystem, collects the numeric owners
    it found, and maps them back to accounts:

        (|(uidNumber=1004)(uidNumber=1027)(uidNumber=1263)...)

Clients that send small ORs, like SSSD with its handful of branches, aren't
affected. The lookup doesn't even wake up below 16 branches; a table
wouldn't pay for itself there. The one shape that pays above the
threshold is a large OR returning almost nothing - a few milliseconds
for the table (details in the Performance section).

Design
------

When a search needs the per-entry filter test, the backend creates its own
normalized copy of the filter, walks it, and looks at every OR node. When
an OR contains at least 16 equality branches on the same attribute, and
the attribute qualifies, the server builds a sorted table of the branch
values and attaches it to that OR node. Duplicate assertion values
collapse to a single key.

During the per-entry filter test, an OR node that has a table does not walk
its branches. The entry's values are normalized once, with the same
normalizer that was applied to the branch values, and looked up in the
table.

The table only decides which branch to test; it's a shortcut to the right
branch, never a substitute for testing it. When a value is found in the
table, the server still runs the normal access check and the normal matching
call for that branch. A branch the client is not allowed to read still never
counts as a match, which has been the rule since ticket 48275. If no table
branch matches, branches outside the table (other attributes, substrings,
and so on) are evaluated by the classic walk.

An attribute qualifies when:

-   its syntax is Directory String, IA5 String, Integer, Numeric String,
    Telephone Number, or DN. For these, two values are equal exactly when
    their normalized forms are the same bytes.
-   its equality matching rule, when one is registered, is one of the
    eight standard rules (caseIgnoreMatch, caseExactMatch,
    caseIgnoreIA5Match, caseExactIA5Match, integerMatch,
    numericStringMatch, telephoneNumberMatch, distinguishedNameMatch).
-   the filter uses the plain attribute, without options. `uid` qualifies,
    `uid;lang-en` does not.

When an OR mixes several attributes, the largest qualifying group gets the
table and the remaining branches are evaluated normally. On a tie, the group
that appears first in the filter wins.

The classic walk runs unchanged when:

-   the OR has fewer than 16 qualifying branches
-   the attribute is not in the schema, or uses generalizedTime, Boolean,
    Bit String, or Name And Optional UID syntax
-   the matching rule is a collation rule or a plugin rule outside the
    eight above
-   the search is a tombstone or RUV search
-   the search skips the per-entry filter test entirely (a fully indexed
    filter that needs no test builds no normalized copy and no table)
-   the attribute may be supplied by CoS or Roles for the entry being tested
-   a DN-valued entry has more values than the table has distinct keys,
    where the classic walk is cheaper
-   a stored DN value cannot be parsed
-   the evaluation is an access-only pass, which must visit every branch

One more restriction, and it's the subtle one. A filter branch can evaluate
to true, false, or undefined, where undefined usually means "you're not
allowed to read this attribute". Normal searches treat false and undefined
the same, so when all table lookups miss, the server can mark the entry as a
non-match right away.
NOT and VLV are the two places that can tell false and undefined apart, so
under a NOT, and in VLV searches, this shortcut is disabled and the classic
walk decides.

One side effect: the server does not ask the ACL plugin about branches
whose values the entry does not have. This is only visible with ACL debug
logging enabled, where large OR searches produce far fewer lines than the
classic walk would. Nothing changes about who can see what.

Implementation
--------------

New file `ldap/servers/slapd/filter_or_lookup.c` holds the eligibility
checks, the table build, the probe, and the free function. The per-entry
lookup path is `vattr_test_filter_or_lookup()` in
`ldap/servers/slapd/filterentry.c`. The build is called from the filter
pre-digest block in `ldap/servers/slapd/back-ldbm/ldbm_search.c`. The
configuration attribute is wired in `libglobs.c` like the other `cn=config`
switches.

The table hangs off the OR node of the backend's private filter copy and is
freed together with it in `slapi_filter_free()`. `slapi_filter_dup()` does
not copy tables. Filters parsed for other purposes (plugins, persistent
search, ACL evaluation, `cn=config` searches) never get tables. The table is
read-only after the build, so later pages of a paged search can read it
safely.

The build stays cheap by construction: a search whose candidate list is
empty skips it entirely (no entry would ever probe the table), and key
extraction runs in a single pass per OR node, so DN branches are parsed
and case-normalized once. Memory cost is about 40 bytes per branch for
the lifetime of the search: a 10,000-branch OR allocates around 400 KB.

Configuration
-------------

    dn: cn=config
    nsslapd-enable-or-filter-lookup: on

The default is on. The setting is dynamic and needs no restart:

    dsconf <instance> config replace nsslapd-enable-or-filter-lookup=off

The server reads the setting when it prepares a search's filter, so a change
applies to new searches. A paged search that's already running keeps its
tables until the client finishes paging; don't expect a search in flight to
change course.

Troubleshooting
---------------

One line is logged when tables are built, at a debug level that is off by
default. Add 524288 (SLAPI_LOG_BACKLDBM) to `nsslapd-errorlog-level` and
look for:

    DEBUG - ldbm_back_search - OR filter equality lookup engaged: 1 node(s), largest 355 branches

The line means tables were built for the search, nothing more. It doesn't
say how many entries used them. There's no counter in `cn=monitor` and no
`notes=` keyword in the access log.

To confirm the lookup is really deciding, also enable filter logging (add
32) and check that the per-branch `test_ava_filter - => AVA:` lines
disappear for the attribute. Do that on a test system; at these log levels a
busy server spends more time logging than searching.

If the feature does not engage, check that the setting is on, that the OR
has at least 16 equality branches on one attribute, that the attribute's
syntax and equality matching rule are in the supported lists above, that
the search is not a tombstone or RUV search, and that candidate generation
produced at least one entry (a search with an empty candidate list skips
the build).

Performance
-----------

Measured on Fedora with a 100,000 entry database; every number is the
median of 15 searches. The lookup columns come from one installed build
containing this feature and the companion Issue 7655 fix, with only
`nsslapd-enable-or-filter-lookup` changed between them - so "lookup off"
to "lookup on" is a same-binary measurement. Its noise band, taken from
28 strata where the lookup cannot engage, is +/-4.2 % elapsed and
+/-5.1 % CPU. The "main" column comes from a companion run of the same
workload against current main (which contains neither change); the
identical-binary anchor states shared by the two runs agree within 2 %.

| Search | main | lookup off | lookup on |
|--------|----:|----:|---:|
| 355 DN branches, 612 candidate entries, no matches | 0.61 s | 0.24 s | 0.092 s |
| the same filter over 10,000 candidates | 9.02 s | 2.58 s | 0.19 s |
| the only match on the last of 355 branches | 1.19 s | 0.39 s | 0.11 s |
| 355 branches, nearly all values present | 0.43 s | 0.20 s | 0.10 s |
| 128 branches, all values present | 0.12 s | 0.095 s | 0.088 s |

The "lookup off" column is what the Issue 7655 fix alone does: it makes
each DN branch test cheaper, while the lookup removes the need to walk
the branches at all. The two address the same hot path from different
sides - the fix helps every DN equality test including sub-threshold ORs
and ANDs; the lookup engages at 16 or more same-type equality branches
for every supported attribute type, not just DNs. Turning the lookup on
takes the 10,000-candidate case a further +93 % (2.58 s to 0.19 s), and
main to lookup-on combined is +97.9 %, about 48x.

The saving grows with the number of candidates times the number of
branches. Below 128 branches the live-value difference is within the
noise band; at 128 it clears it (+6.4 % elapsed / +8.2 % CPU), and from
355 branches up it is decisive. Across the full 134-stratum screen, 47
strata improve coherently beyond the band and most of the rest sit
within noise. The cost side is one narrow shape: a large OR where only
a handful of entries reach the filter test pays a few milliseconds for
a table that goes mostly unused. Two things bound even that in
practice. Interactive traffic never sees it: logins, lookups, and short
client filters stay under the 16-branch threshold and never engage the
lookup. And the toll and the wins land on the same clients: the batch
job that pays a few milliseconds on a stale-list pass is the job whose
bulk fetch drops from 9 seconds to 0.19, so any realistic mix is
dominated by the wins - with `nsslapd-enable-or-filter-lookup` as the
per-instance opt-out for a workload that somehow is not.

For context, packaged OpenLDAP on the same data runs the 10,000 candidate
case in about 0.47 seconds; 389 DS with the lookup runs it in 0.19
seconds, and main without either change in 9.0 seconds. Different servers
do different work, so read that as context, not as a scoreboard.

Testing
-------

-   `dirsrvtests/tests/suites/filter/filter_or_lookup_test.py`: the same
    searches with the feature on and off must return the same results.
    Covers all supported matching rules, non-ASCII values, escaped DNs,
    thresholds 15 and 16, mixed attribute groups, subtypes, CoS, referrals,
    paging, VLV with server-side sorting, and proxy authorization.
-   `filter_or_lookup_feature_test.py`: reads the debug log to prove the
    lookup engaged, fell back, or was disabled where expected, including a
    DN-syntax family (`test_or_lookup_dn_family_engages`).
-   `filter_or_union_test.py` and
    `filter_large_filter_interaction_test.py`: OR result sets across
    `idl_set` consumers, and large DN filters combined with substring and
    approximate branches. `filter_large_filter_support.py` is the shared
    workload module these import; it contains no tests itself.
-   `memory_leaks/filter_not_first_lifecycle_test.py`: filter ownership
    under ASan across startup, VLV, paged, and cancelled operations. Needs a
    dedicated ASan build and is not part of the default CI run.

Replication
-----------

No impact. The change is confined to search evaluation.

Updates and Upgrades
--------------------

Nothing to migrate. The attribute has a default, needs no schema or
`dse.ldif` changes, and upgraded servers get the feature enabled. Setting it
to off restores the classic branch walk exactly.


Origin
------

https://github.com/389ds/389-ds-base/issues/7664

Author
------

<simon.pichugin@gmail.com>
