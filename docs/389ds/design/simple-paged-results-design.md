---
title: "Simple Paged Results Design"
---

# Simple Paged Results Design
-----------------------------

{% include toc.md %}

Overview
--------

"Simple paged results" is a method which allows clients to receive a paged results (made from the page size of entries) at one search request. The client could continue sending paged search request changing the page size.

RFC: [LDAP Control Extension for Simple Paged Results Manipulation](http://www.ietf.org/rfc/rfc2696)

Here's an example of the simple paged results. The first request sends the paged results control containing the page size 2 (-pg 2), then 2 entries are returned. Next, the request with page size 3 is sent, and 3 entries are returned. Then, page size 1, and one entry is returned.

    $ perl [ldapsearch.pl](http://nhosoi.fedorapeople.org/ldapsearch.pl) -pg 2 "(sn=Se*)" "dn cn"
    dn: uid=MSellwood106, ou=Product Testing, dc=example,dc=com    
    cn : Maryann Sellwood   

    dn: uid=LSergi276, ou=Payroll, dc=example,dc=com    
    cn : Larry Sergi    
    next page size (2): 3    

    dn: uid=MSevilla553, ou=Product Testing, dc=example,dc=com    
    cn : Mikaela Sevillapo0    

    dn: uid=ASeidl575, ou=Human Resources, dc=example,dc=com    
    cn : Arlena Seidl   

    dn: uid=MSellers585, ou=Product Testing, dc=example,dc=com    
    cn : Maribeth Sellers    
    next page size (3): 1    

    dn: uid=JSeiler610, ou=Product Development, dc=example,dc=com    
    cn : Jean-Marie Seiler    
    next page size (1):    

Directory Server supports server side sorting control. Paged results control could be combined with the server side sorting as follows:

    $ perl [ldapsearch.pl](http://nhosoi.fedorapeople.org/ldapsearch.pl) -pg 2 -x -S "sn givenname" "(sn=Se*)" "dn cn"    
    dn: uid=BSeabrook6465, ou=Payroll, dc=example,dc=com    
    cn : Bernie Seabrook    

    dn: uid=MSeager4825, ou=Product Testing, dc=example,dc=com    
    cn : Micky Seager    
    Results are sorted.    
    next page size (2): 3    

    dn: uid=KSeagle2713, ou=Accounting, dc=example,dc=com    
    cn : Khanh Seagle    

    dn: uid=YSeagle5532, ou=Product Development, dc=example,dc=com    
    cn : Yelena Seagle    

    dn: uid=JSeagrove7967, ou=Human Resources, dc=example,dc=com    
    cn : Jacenta Seagroves    
    Results are sorted.    
    next page size (3): 1    

    dn: uid=JSeagrove5000, ou=Product Development, dc=example,dc=com    
    cn : Jolyn Seagroves    
    Results are sorted.    
    next page size (1):    

Note: the server used in this example is implemented with the front-end approach described below.

Implementation
--------------

Two approaches are considered to implement the simple paged results. One is adding the functionality to the front-end side of the search and the other is to the back-end plug-in. The 2 approaches are described here to show their pros and cons. The front-end approach is fully implenented for the current version of the Directory Server. I keep the back-end approach section for the record.

### front-end approach

The searches are roughly made from 2 processes: generating an ID list and returning the entries stored in the ID list. An ID list looks like this:

    ID list    
    +---------+    
    | b_nmax  |    
    +---------+    
    | b_nids  |    
    +---------+---------+---------+--....--+---------+    
    | b_ids[0]| b_ids[1]| b_ids[2]|  ....  | b_ids[n]|    
    +---------+---------+---------+--....--+---------+    
    b_nmax  maximum number of ids in this block. if this is == ALLIDSBLOCK, then this block represents all ids.    
    b_nids  current number of ids in use in this block.  (n+1 in this example)    
    b_id[i] a list of the actual IDs themselves    

To generate an ID list, the back-end module evaluates the requested base DN and the filter, accesses corresponding index files (if necessary) and generates the ID list from the matched IDs. The ID list is passed to the Directory Server front-end. Then, the front-end iterates the IDs in the list and let back-end read each entry from the primary database and return it to the client based upon the request, e.g., if an attribute list is given, choose just the values on the list and return them.

Once an ID list is passed from the back-end to the front-end, the front-end has the control on it, for instance, when to start and stop returning the entries on the list managing how many of them already returned to the client. The ID list and the current position in the ID list are packaged in the back\_search\_result\_set object, which could be stashed in a connection object when it's returned from the first search. As long as the client is on the same connection, the same back\_search\_result\_set could be reused.

back\_search\_result\_set looks like this:

    +---------------------+    +-----------------+    
    | sr_candidates       +--->| ID list         |    
    +---------------------+    +-----------------+    
    | sr_current          |    
    +---------------------+    
    | sr_entry            |    
    +---------------------+    
    | sr_lookthroughcount |    
    +---------------------+    
    | sr_lookthroughlimit |    
    +---------------------+    
    | ...                 |    
    +---------------------+    
    sr_candidates        - the search results    
    sr_current           - the current position in the search results    
    sr_entry             - the last entry returned    
    sr_lookthroughcount  - how many have we examined?    
    sr_lookthroughlimit  - how many can we examine?    

The advantage to use the back\_search\_result\_set to manage paging is it makes easy to combine the simple paged results with the server side sorting. The server side sorting also creates the ID list in the sorted order. The front-end does not have to change the behavior regardless of the existence of the server side sorting control.

Another aspect we should be aware of this approach is that the ID list is generated at the first page request. If the database is modified after the first page request before the following ones, the updates are not included in the following pages. This is good since the results are from one snapshot and have no chance to have missing entries or duplicated entries in paging due to the updates made to the database.

One disadvantage with this approach is it could force the server keep ID lists for a long time. For example, a client could leave the computer without closing the connection in the middle of paging. To workaround this problem, nsslapd-timelimit (cn=config) is applied to the paged results case. At the beginning of the each page request, it sets the time limit in the connection object. Even if there is no activities on the connection, the server checks the time limit periodically. Once it's expired, the server disconnects the connection. On the client side, the paged-search-results command line is still sitting at the prompt (using the openldap ldapsearch command):

    # search result    
    search: 3    
    result: 0 Success    
    control: 1.2.840.113556.1.4.319 false MAYCAQIEATI=    
    pagedresults: estimate=2 cookie=Mg==    
    Press [size] Enter for the next {2|size} entries.    

If I hit return for the next 2 entries, it prints the "Can't contact LDAP server" message since the connection is already closed.

    # extended LDIF    
    #    
    # LDAPv3    
    # base     <dc=example,dc=com>     with scope subtree    
    # filter: (cn=Sel*)    
    # requesting: dn cn    
    # with pagedResults critical control: size=2    
    #    
    ldap_result: Can't contact LDAP server (-1)    

Another issue is the size of the ID list. The length of the ID list is limited by the nsslapd-idlistscanlimit (cn=config,cn=ldbm database,cn=plugin,cn=config). It limits the number of IDs coming from one key of an index file. For instance, if the filter is "(cn=\*)" and the presence index key has more than the nsslapd-idlistscanlimit value (4000, by default), the ID list becomes ALLIDS (b\_nmax==ALLIDSBLOCK), which size is sizeof(IDList) == 12 bytes. On the other hand, let's assume we have a filter "(|(mail=\*er@\*)(mail=\*on@\*))" and assume (mail=\*er@\*) hits 3000 entries and (mail=\*on@\*) does 2500 entries. Both are less than the nsslapd-idlistscanlimit (4000). Thus, the combined ID list, which size is 5500, is successfully returned to the front-end. Directory Server has other size limit configuration parameters nsslapd-sizelimit (cn=config) and nsslapd-lookthroughlimit (cn=config,cn=ldbm database,cn=plugin,cn=config). nsslapd-sizelimit does not restrict the ID list size, but it does the number of entries to be returned to the client. Another configuration parameter nsslapd-lookthroughlimit is checked for the server side sorting and the range search if the bind user is not the Directory Manager. The usage of nsslapd-lookthroughlimit has been expanded for the paged results to restrict the ID list after taking a union as described in the above example.

<b>configuration parameters to limit time and size</b>

<table>
<col width="15%" />
<col width="30%" />
<col width="30%" />
<thead>
<tr class="header">
<th align="left"></th>
<th align="left"><p>Directory Manager</p></th>
<th align="left"><p>ordinary user</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>nsslapd-timelimit<br />default: 3600sec</p></td>
<td align="left"><p>set (-1 -- no limit) internally; never timed out</p></td>
<td align="left"><p>timed out if it reaches the time limit since the previous paging request (*)</p></td>
</tr>
<tr class="even">
<td align="left"><p>nsslapd-idlistscanlimit<br />default: 4000</p></td>
<td align="left"><p>If exceeds the limit, ID list becomes ALLIDS; sort is not performed (LDAP_UNWILLING_TO_PERFORM (53) is returned); All entries are returned -- not like SIZELIMIT or ADMINLIMIT, the search does not stop at the idlistscanlimit count. But &quot;note=U&quot; is logged in the access log even if the filtered attr is indexed. NOTE: minimum allowed value of nsslapd-idlistscanlimit is 100. If smaller value is set, it's changed to 100.</p></td>
<td align="left"><p>If exceeds the limit, ID list becomes ALLIDS; sort is not performed (LDAP_UNWILLING_TO_PERFORM (53) is returned); All entries are returned -- not like SIZELIMIT or ADMINLIMIT, the search does not stop at the idlistscanlimit count. But &quot;note=U&quot; is logged in the access log even if the filtered attr is indexed. NOTE: minimum allowed value of nsslapd-idlistscanlimit is 100. If smaller value is set, it's changed to 100.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>nsslapd-lookthroughlimit<br />default: 5000</p></td>
<td align="left"><p>set (-1 -- no limit) internally</p></td>
<td align="left"><p>If exceeds the limit, ID list becomes ALLIDS; LDAP_ADMINLIMIT_EXCEEDED is returned. Checked in sort, range search and search with a filter containing '|' (or)</p></td>
</tr>
<tr class="even">
<td align="left"><p>nsslapd-sizelimit<br />default: 2000</p></td>
<td align="left"><p>set (-1 -- no limit) internally</p></td>
<td align="left"><p>Even if exceeds the limit, ID list is not affected; LDAP_SIZELIMIT_EXCEEDED is returned.</p></td>
</tr>
</tbody>
</table>

(\*) If timelimit is hit in the search operation -- searching the database or returning the results, LDAP\_TIMELIMIT\_EXCEEDED is returned to the client. If it is hit while the server waiting for the input from the client -- request for the next page, the server disconnect the connection with SLAPD\_DISCONNECT\_IO\_TIMEOUT. It's logged as "closed - T2" in the access log. Once the connection is closed by the server, the client comment fails with LDAP\_OPERATION\_ERROR at the next input.

The server side sorting code is shared with the Virtual List View. VLV stores the sorted list in the VLV index file, thus once it's VLV-indexed, each paging could be done very quickly from the first page. Probably, it'd be useful to gather statistics of the searches. If the same pattern which issues sorted and paged results requests on the ID lists is repeatedly detected, adding the corresponding VLV index would help the performance.

### back-end approach

This back-end approach searches in the indexes every time the paged (search) results request comes in. Not like storing the entire ID list in the connection object, it sends the requested page size number of the matched entries starting from the position to the client and it stashes the current position to prepare for returning the next page.

The biggest advantage of this approach is it does not need to keep the entire ID list while the connection is held. The difficulty is to combine with the server side sorting. To run searching every time, you have to sort the search results every time. Sorting is an expensive operation. It's not realistic to repeat the server side sorting every page just to display some small subset of the results. When we were brainstorming, we thought about applying some limitation to sorting such as allowing only one attribute to sort with and the attribute should be indexed. By the restriction, we tried to get the sorted, paged results with the range search manner from one index. Unfortunately, this attempt does not work for the multi-valued attributes since we have to return one entry just once instead of multiple times when the sorted attribute keys belonging to the entry appear in the index tree. That is, sorting cannot be done partially, but be entirely.

If sorting is not very important, we could support paged results exclusively, not accepting the 2 controls at the same time.
