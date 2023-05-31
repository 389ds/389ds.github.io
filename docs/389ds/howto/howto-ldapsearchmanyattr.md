---
title: "Howto: Ldap Search Many Attrs"
---

# How to count large number of attribute entries using an anonymous bind
----------------------------------------------------------------------

There are a couple of parameters you can adjust. In cn=config, the attribute nsslapd-sizelimit:

    nsslapd-sizelimit: 2000    

nsslapd-sizelimit is the upper limit on the value set with -z ldapsearch's option. You cannot set a larger sizelimit than this value. You can set a smaller value with -z.

In cn=config,cn=ldbm database,cn=plugins,cn=config, the attributes nsslapd-lookthroughlimit and nsslapd-idlistscanlimit:

    nsslapd-lookthroughlimit: 5000    
    nsslapd-idlistscanlimit: 4000    

In general, nsslapd-lookthroughlimit and nsslapd-idlistscanlimit are much stricter than nsslapd-sizelimit.

For example, let's say a user wants to do an unindexed search for (description=\*something\*), and there are 5000 users and 1000 users who have a description attribute that matches \*something\*. The server will have to search through every entry in sequential (indeterminate) order to find matches.

If you set lookthroughlimit to be 1000, and set sizelimit to be unlimited, the server will look at up to 1000 entries looking for description=\*something\*. Some of them may match, some of them may not, and the server will return 1000 or fewer entries (indeterminate). The server is limited in the amount of work it performs searching through the database.

If you set sizelimit to be 1000, and set lookthroughlimit to be unlimited, the server could look at all 5000 user entries, until it finds 1000 entries which match, at which point it will terminate the search and return the 1000 entries to the user.

If the search is indexed, it is the nsslapd-idlistscanlimit that controls the number of entry IDs the server will load into memory from the index. So even if you set a very high sizelimit, the directory server may restrict the size of the result set based on the idlistscanlimit, so you may have to increase that value as well.

If you have a relatively small database, and want to perform searches that return most or all of the entries in the database, consider raising these limits to the number of entries in your database.

Entry dn for nsslapd-lookthroughlimit and nsslapd-idlistscanlimit, database attributes:

    cn=config,cn=ldbm database,cn=plugins,cn=config    

Entry dn for nsslapd-sizelimit:

    cn=config    

# How to configure limits on a binddn
-------------------------------------

Normally the limits placed on a binddn are the same as the anonymous limits.

However, on a specific account object you may override the limits

    uid=admin,ou=People,dc=example,dc=com
    nsLookThroughLimit:
    nsSizeLimit:
    nsTimeLimit:

This allows you to make service accounts that can do more expensive or larger searches, without allowing anonymous or all other accounts to do the same.


