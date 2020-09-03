---
title: "Content synchronization plugin"
---

# Content Synchronization Plugin
---------------------

{% include toc.md %}

Introduction
------------

This document describes a server side implementation of RFC4533 in RHDS. It is implemented as plugin for two reasons

-   don't overload core server code
-   potential to use the plugin in other directory servers like SunDS

First the concepts of content synchronization are presented, the design of the plugin implementation is explained and a discussion of open topics follows

Concepts in RFC 4533
----------------------

Although everything is fixed in RFC 4533 as always there are interpretations and design choices. This section presents the core elements and concepts of the RFC and how they will be used in the implementation. The RFC specifies a mechanism for a client to synchronize its copy of a database with the, changing, content of a directory server. It can be considered as a consumer initiated replication, where the server has no knowledge about the clients.

In contrast to replication it is not change oriented, but entry centric. Always complete entries (subject to access control and requested attributes) will be sent. Or, in update phases, dns (or uuids) of entries not changed or deleted since the last session.

To achieve this the RFC introduces several new LDAP elements and specifications for their content: messages and controls and defines how client and server exchange information.

    Digression: relation to persistent searches    
    Reading the RFC the similarity with persistent searches is obvious, but there are two important differences:    
    * intermediate messages    
    A persistent search (not changes only) sends the full results of the search and then switches to persistent mode, but the client is not notified when the first phase is completed    
    * session management    
    Each persistent search starts with getting all entries, there is no state information so that a new persistent search can just enhance the results of a previous search    
    These shortcomings are addressed by RFC4533, but the implementation can build on what is available with persistent searches.    

New LDAP elements
----------------------

### controls

There are two new controls, one to initiate a synchronization session and a state control to be sent with any response (result or entry) back to the client

-   sync request control

        controlType is  1.3.6.1.4.1.4203.1.9.1.1    
        syncRequestValue ::= SEQUENCE {    
            mode ENUMERATED {    
                -- 0 unused    
                refreshOnly       (1),    
                -- 2 reserved    
                refreshAndPersist (3)    
            },    
            cookie     syncCookie OPTIONAL,    
            reloadHint BOOLEAN DEFAULT FALSE    
        }    

This initiates the synchronization session and defines one of two potential modes; refreshOnly or refreshAndPersist. The optional cookie can be used to continue a previous synchronization session

-   sync state control

        syncStateValue ::= SEQUENCE {    
            state ENUMERATED {
                present (0),
                add (1),
                modify (2),
                delete (3)
            },
            entryUUID syncUUID,
            cookie    syncCookie OPTIONAL
        }

It has to be sent with each result entry. It is attached to entries in the refresh phase and in the persist phase when updates are sent. Important is the entryUUID, which the client has to use to uniquely identify entries, the dn might have changed. Note that there is no specific state for modrdn operations, it is the task of the client to handle this based on the entryUUID

-   sync done control

        syncDoneValue ::= SEQUENCE {
            cookie          syncCookie OPTIONAL,
            refreshDeletes  BOOLEAN DEFAULT FALSE
        }

This control is sent with a search result done message and will only be sent to complete a refresh only session. It should provide a cookie to the client to be used in further update sessions

### Messages

There is one new message introduced to indicate the completion of the refresh phase when a the client requested a refreshAndPersist session or the separation of two phases in the refresh phase. It defines the responsename and responsevalue of a LDAP intermediate response message as defined in rfc4511

    responseName is 1.3.6.1.4.1.4203.1.9.1.4 and 
    responseValue contains a BER-encoded syncInfoValue.  The criticality is FALSE (and hence absent).
         syncInfoValue ::= CHOICE {
             newcookie      [0] syncCookie,
             refreshDelete  [1] SEQUENCE {
                 cookie         syncCookie OPTIONAL,
                 refreshDone    BOOLEAN DEFAULT TRUE
             },
             refreshPresent [2] SEQUENCE {
                 cookie         syncCookie OPTIONAL,
                 refreshDone    BOOLEAN DEFAULT TRUE
             },
             syncIdSet      [3] SEQUENCE {
                 cookie         syncCookie OPTIONAL,
                 refreshDeletes BOOLEAN DEFAULT FALSE,
                 syncUUIDs      SET OF syncUUID
             }
         }

### uuid


Since the dn of an entry can change there is the need to have a unique identifier in the entry which is stable and is globally unique. In RHDS nsuniqueid is used and will be used for implementing this RFC

### Cookies

The purpose of a cookie is threefold

-   identify the server.

A client should continue a synchronization session only with the server it received the cookie from to guarantee consistency. In a replicated topology this could probably be relaxed. The fully qualified domainname and ldap port should be sufficient to identify a server

-   identify the client

Continuing a synchronization session makes only sense if the request uses the same searchbase, the same credentials (determined by the client dn), the same search filter and the same list of requested attributes (maybe not mandatory) clientdn:searchbase:searchfilter[:list of req attrs]. This could become quite long, maybe hashing that string is an option state information

-   maintain state info

When a cookie is provided by a client a server the server should only return information about changes since the time indicated by the state in the cookie. This state info could be timestamp, or a csn or a changenumber or a combination of several of these. In the first implementation the content for updates to send is determined using the retro changelog, so the current highest changenumber is used

So the cookie implemented is:

    <nsslapd-localhost>:<nsslapd-port> # <client dn>:<searchbase>:<search filter> # <changenumber>

Synchronization Scenarios
----------------------

There are two modes defined in the SyncRequestControl and both can have a cookie or not, so there are four different scenarios for a synchronization session:

-   refresh only, no cookie
-   refresh only, cookie present
-   refresh and persist, no cookie
-   refresh and persist, cookie present

These scenarios will be detailed now

### Refresh only, no cookie

1.  The server sends all entries matching the search request, with each entry a SyncStateControl with state present is sent.
2.  The server sends a search result done message and a Noncontroversial with a cookie.

### Refresh only, cookie present

1.  The server determines the content which has changed since the cookie was issued.
2.  The server sends all information required for the client to synchronize the database using either a present phase, a delete phase or a present phase followed by a delete phase.
3.  In each phase entries existing and modified are sent in a search\_result\_entry message and with each entry a sync state control is sent in the present phase for all entries which are not changed since the cookie state are sent without attributes. If there are several present, unchanged entries to send these can be sent in one or several sync info messages with a syncidset of the uuids of these entries the delete phase is similar, only that in addition to the present but modified entries all entries which were deleted since the cookie state are sent either as dn only entries or in sync info messages.
4.  If present and delete phase is used they are separated by a sync info message.
5.  The server sends a search result done message and a Noncontroversial with a cookie.

### Refresh and persist, no cookie

1.  The server sends all entries matching the search request, with each entry a SyncStatecControl with state present is sent.
2.  The server sends a sync info message and a Control with a cookie.
3.  Enter persist mode. Wait for changes and for each change send the changed entry and a syncstateControl. For deleted entries the dn only and the control is sent. Modrdn is treated like a modify operation, it is the task of the client to use the provided uuid to resolve the synchronization.

### Refresh and persist, cookie present

1.  The server determines the content which has changed since the cookie was issued.
2.  The server sends all information required for the client to synchronize the database using either a present phase, a delete phase or a present phase followed by a delete phase.
3.  In each phase entries existing and modified are sent in a search\_result\_entry message and with each entry a sync state control is sent. In the present phase all entries which are not changed since the cookie state are sent without attributes. If there are several present, unchanged entries to send these can be sent in one or several sync info messages with a syncidset of the uuids of these entries. The delete phase is similar, only that in addition to the present but modified entries all entries which were deleted since the cookie state are sent either as dn only entries or in sync info messages.
4.  If present and delete phase is used they are separated by a sync info message.
5.  The server sends a sync info message and a Control with a cookie.
6.  Enter persist mode. Wait for changes and for each change send the changed entry and a syncstateControl. For deleted entries the dn only and the control is sent. Modrdn is treated like a modify operation, it is the task of the client to use the provided uuid to resolve the synchronization.

Update content determination
----------------------

In a refresh phase with a cookie, the server has to determine what has changed since the state provided in the cookie. This has to be done reliably and efficiently and is dependent on the choice of the state information used in the cookie and the change history available in the server. In this first implementation change determination is using the retro changelog, because it is:

-   available, eg. for the real changelog there is no api to access change information
-   simple, each change is logged with targetDN and changetype
-   portable, retro changelog is available on other ldap servers eg. SunDS, even if finally a more efficient implementation is chosen, a working implementation based on retrocl could be useful

Implementation Design
----------------------

The content synchronization is implemented as a plugin for reasons explained above. This requires that the plugin has to control the sending of entries, the appending of controls to entries or messages, the sending of a result message or not.

But so far not everything could completely be implemented in the plugin, there are two exceptions

1.  the sync info message
2.  corrections in the code to prevent crashes or allow cleanup of operations, see below

### Sync info message

The sync info message is a specific case of a ldap intermediate response message, which is defined in RFC4511, but is not supported in RHDS so far. It is implemented in result.c in parallel to functions sending entries, results and referrals. It is exposed in slapi-plugin.h to be used by plugins. Since it is a standard ldap message it should be in the core server. If it would have to be implemented completely in the plugin one would have to rely on methods not available in the api, eg get the connection, guess the address of the SockBuffer encode the message and call ber\_flush directly. Could work and will have to be tried when porting

### Plugin entry point

The plugin requires calls in the preoperation phase for search, entry and result plugin entry points.

The plugin requires calls in the postoperation phase for all modify operations and for searches.

To communicate between plugin calls at different entry points an object extension is used to provide state information

### PRE\_SEARCH plugin

The presearch plugin is the central point to trigger all synchronization events,

-   it checks for the existence of a syncRequestcontrol
-   it parses the control to determine the mode and the presence of a cookie
-   it parses the cookie, creates a current cookie and validates the client cookie
-   if mode is persist initialize the persistent subsystem for this request and start the thread serving updates
-   if mode is persist set the OP\_FLAG\_PS flag to the operation. This hijacks actions done with persistent searches, eg ensuring that the operation is not removed from the connection

the next steps depend on the scenario defined by mode and cookie

-   refresh only, no cookie
    -   set an object extension to notify
        -   the pre entry plugin to add a sync state control to the entry
        -   the post search plugin to add a Noncontroversial to the controls
    -   let search proceed and send all the matching entries

-   refresh and persist, no cookie
    -   set an object extension to notify
        -   the pre entry plugin to add a sync state control to the entry
        -   the post search plugin to send the sync info message
        -   the pre result plugin to return an error to prevent the sending of the result message (sync info was sent)
        -   the post search function to activate the persistent subsystem to start to send updated entries

-   refresh only, with cookie
    -   determine the changed content based on cookie
    -   send changed entries with sync state control
    -   set an object extension to notify
        -   pre\_result to return an error and prevent sending a result
    -   send a result message with sync done control
    -   return an error to prevent execution of search in core server

-   refresh and persist, with cookie
    -   determine the changed content based on cookie
    -   send changed entries with sync state control
    -   set an object extension to notify
        -   pre\_result to return an error and prevent sending a result
    -   send a sync info intermediate message
    -   notify the persist subsystem that sending of content is complete and queued updates can be sent

### PRE\_ENTRY\_PLUGIN

If the initial entries are sent in the core server search operation the sync state control needs to be added to the result message. This is the case if there was no cookie specified and the initial content is sent. The plugin gets the object extension and checks the sync flags to determine what to do. Eventually it creates a sync state control by

-   getting the SEARCH\_RESULT\_ENTRY entry from the pblock
-   getting the nsuniqueid attribute and value
-   encode the control
-   set the control to the pblock: SEARCH\_RESULT\_CTRL

### PRE\_RESULT\_PLUGIN

In persist mode a sync info message was sent instead of a ldap result message, the only way to prevent the sending of a result message is to return an error from the PRE\_RESULT plugin

### POST\_SEARCH\_PLUGIN

If the entries have been sent by performing an normal search this is the place where a sync done control can be added to the pblock to be sent with the result message.

If it is in persist mode and the entries have been sent by the normal search process, this is the place where to send the sync info message, sending of the result message will be prevented in the pre\_result plugin

### BETXN PRE\_MODIFY | ADD |DELETE | MODRDN\_PLUGIN

Because of the need to handle nested operations (see <a href="#queue and pending list">queue and pending list</a>) the callback <b>sync_update_persist_betxn_pre_op</b> adds nested operation at the end of the per thread pending list.

### BETXN POST\_MODIFY | ADD |DELETE | MODRDN\_PLUGIN

These callbacks use to be postop, that are move to <b>BETXN</b> callback to prevent the following scenario (seen in #51190): 

- update A and update B at the same time.
- update A acquire the backend lock and open a txn
- update B is waiting
- update A completes DB update and release backend lock/txn
- update B acquire the backend lock, open the txn, complete DB update and release backend lock/txn
- update B call postop
- update A call postop

WIth this scenario update A is applied before update B in the retroCL but update B is enqueue before A. So the presistent search will send B and possibly skip A. 
For each change operation a change info node is created, containing the

-   a copy pre/post entry
-   changetype

and it is handed over to the persistent subsystem by

-   checking if there is a persistent sync thread handling the subtree of the changed entry
-   enqueueing it

This is modeled after the persistent search implementation

### Update content information

If a cookie has been provided and could be decoded and is valid, the changenumber CNUMBER from the cookie is used to determine the changes applied to the database since the cookie was issued.

An internal search is performed with the search base of "cn=changelog" and a search filter "(changenumber\>=CNUMBER)".

An entry handler function is passed to the internal search and this function is called for each changelog entry and its behavior is dependent on the changetype:

-   changetype: add or modify
    -   check if the entry is in the scope of the synchronization request
    -   get the entry based on targetdn
    -   send the entry

-   changetype: delete
    -   check if the deleted entry was in the scope of the sync request
    -   create a dummy entry from the dn without attributes and send it

-   changetype: modrdn
    -   if the entry was moved out of scope, handle as delete
    -   if the entry was moved into scope, handle as add
    -   if pre and post entry are in scope, get entry based on nsuniqueid
    -   send the entry

-   in all cases add a sync state control with the nsuniqueid

-   error handling

If an entry cannot be retrieved based on its dn or nsuniqueid, this means that it was deleted or renamed by a change not yet processed, so this changelog entry is skipped

### Actual implementation

1.  determine the changenumber in the client cookie: cnr\_min
2.  determine the current max changenumber: cnr\_max
3.  allocate an array of change nodes [cnr\_max-cnr\_min]
4.  search the changelog &((\>= min)(\<=max))
5.  for each cl entry get the targetuniquid (which is the nsuniqueid of the changed entry)
6.  check if the nsuniqueid was already seen in this pass, determine which changetype to use
7.  when all cl entries are processed
    1.  collect all nsuniqueids corresponding to effective delete operations and construct one or more syncinfo messages with uuid lists
    2.  for each modified entry still in scope, find the entry by its nsunique id, add ac'control and send it

### Persistent phase

During that phase it exists a dedicated thread that sends the udpated entries to the client. To know which entries to send, the thread needs a piece of information that it reads from a queue. The post change plugins are responsible to write the information to the queue.

#### queue and pending list

For a simple update, the information identifying the entry is written to the queue and there is no difficulty. If the update is nested  it is more complex. For example U1: ADD userA, automember adds U2: userA in Grp1, then memberof update U3: userA to make it memberof Grp1, then automember adds U4: userA to Grp2,.... so we have an ordered list of updates U1, U2, U3, U4. RetroCL registers those updates in that order. But post change plugin will register them into the queue with U4, U3, U2, U1. There is a risk of sending updates in the invalid order, skipping updates, being unable to identify the next <i>changenumber</i> to set in the cookie.

The solution is to implement a pending list of updates. The pending list is a per threads structure <b>thread_primary_op</b>. A thread running a nested operation register the operation at the end of the pending list. When all operations are completed and successful the updates are written on the queue, in the same order of the pending list.

#### setup of presistent search handler

If a SyncRequestControle is decoded and the mode is persistent, the following actions are performed:

-   initialize the persistent sync subsystem
    -   the pblock of the original search request is copied
    -   the search filter and original search base are preserved
    -   initialize a queue for changes
    -   create and start a thread handling changes

-   run the thread until shutdown or search is abandoned

-   the thread will
    -   wait on a condition variable for notifications from the post change plugins
    -   check if it is in the scope
    -   send the entry and control to the client (using original pblock connection)
    -   in case of delete send dn and control only

Problems and changes to the core server
----------------------

### Abandon operations

The plugin can prevent sending a result to the client by returning an error from the PRE\_RESULT plugin, but it cannot prevent the call to send\_ldap\_result() in any case. So the o\_status is set to RESULT\_SENT and the operation is skipped when operations are abandoned in disconnect\_server(). This is currently handled by abandoning an operation if OP\_FLAG\_PS is set

### Sending deleted entries

In the persist phase the deletion of an entry requires to send the entry without attributes. This is done by explicitly setting the attributes in the call to send\_ldap\_search\_entry to “1.1”, but the original pblock is used to send the entry and it accesses the original attr list and so crashes in send\_specific\_attrs. This can be avoided if the call to send\_specific\_attrs is skipped if “noattrs” is detected. An other would be to generate a dummy entry from the dn without attrs and send this.

### Access to nsuniqueid

For each entry its nsuniqueid has to be sent in the syncstatecontrol, but based on the retro changelog this is not directly available for entries deleted or renamed. The Retro Changelog has to be configured to log the nsuniqueid by adding the following line to the retro changelog config entry

    nsslapd-attribute: nsuniqueid:targetUniqueId

### Connection management

The persistent search code increments the connection reference count when the persistent thread is started and decrements it when it is terminated. This requires direct access to the connection data structure and is not available from the plugin.

In the initial tests the thread could be terminated properly and the server could also be cleanly shutdown, so it is not clear if this direct handling of the connection ref count is required and needs to be further investigated

<br>

Test scenarios
----------------------

These test scenarios should be run to verify the functionality

Initial refresh
---------------

1.  initialize a backend by importing an ldif
2.  run ldapsearch with specific bind dn, search filter and requested attributes
3.  run same ldapsearch adding a SyncRequestControl with refresh only and no cookie
4.  compare results
5.  verify that with each entry a state control containing the nsuniqueid is sent

Refresh with cookies, no modrdns
--------------------------------

1.  run an initial refresh
2.  note the cookie sent in the result messages
3.  run several types of ldap modify operations
    1.  add entries
    2.  modify added and previously existing entries
    3.  modify same entry several times
    4.  delete added and previously existing entries

4.  run ldapsearch with synccontrol and cookie from initial refresh
5.  check result
    1.  entries added and deleted after initial refresh should not show up at all
    2.  for deleted entries which did exist in the initial refresh their nsuniqueids should show up in a sync info message
    3.  for all modified entries still present ONE entry message is expected with the latest state of the entry

Refresh with cookies and modrdns
--------------------------------

Persistent Mode
---------------

## What is missing

There are a few features in the RFC which are not yet implemented

Cancel Operation
----------------

The RFC requests that the server supports the LDAP cancel operation ( RFC 3909 ). This is an abandon operation which the server has to acknowledge by a response message. This can be added if clients need it

Referrals
---------

So far the implementation only handles ordinary entries, but the same mechanism should apply to referral entries. Will not be supported in the first version

Filter and Access check for deleted entries
-------------------------------------------

This will only be possible if the Retro Changelog can be configured to store the full deleted entry

