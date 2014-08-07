---
title: "Get Effective Rights Design"
---

# Get Effective Rights Design
-----------------------------

{% include toc.md %}

Overview
========

GetEffectiveRights is an LDAP Control defined in ietf draft [Access Control Model for LDAPv3](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt). This control allows access control information to be retrieved for a given directory entry(s) for a given subject during a ldap\_search operation. Its purpose is to allow an administrator or application to query the server about the rights of another user of the directory.

This document specifies the functionality, related changes and the unit tests to implement GetEffectiveRights control.

Functionality
=============

GetEffectiveRights control consists of a request control and a response control.

Request Control
---------------

This control may only be included in the ldap\_search message as part of the controls field of the LDAPMessage.

### Control Type (OID)

    #define LDAP_CONTROL_GET_EFFECTIVE_RIGHTS "1.3.6.1.4.1.42.2.27.9.5.2"

-- Note: The OID is defined in Sun DS 5.2, but not in [the AC Model draft](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt).

### Control Criticality

It MAY be either TRUE or FALSE (default) at the client's option.

### Control Value

According to [the AC Model draft](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt), it is an OCTET STRING, whose value is the BER encoding of a value of the following SEQUENCE:

       GetEffectiveRightsRequest ::= SEQUENCE {    
           gerSubject [0] GERSubject    
       }    

       GERSubject ::= SEQUENCE {    
           gerOneSubject       [0] OneSubject, OPTIONAL    
           germachineSubject   [1] GERMachineSubject,    
           gerAuthnLevel       [2] AuthnLevel    
       }    

       OneSubject ::= CHOICE {    
           dn      DistinguishedName,    
           user        UTF8String    
       }    

In our design, however, GetEffectiveRightsRequest is simplified to support dnAuthzId (defined in section 4.1.1 in [the AC Model draft](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt)) only:

       GetEffectiveRightsRequest ::= SEQUENCE {    
           gerSubject [0] dnAuthzId    
       }    

       dnAuthzId ::= "dn:" dn    

The current DS has made the similar simplification for Proxy Authorization Control.

### Command Line Interface

The request control can be submitted via the existing -J option of the Mozilla LDAP C SDK ldapsearch as follows:

       -J <control OID>:<boolean criticality>:<dnAuthId>|<BER encoded SEQUENCE of dnAuthId>

where plain text of dnAuthId is supported for convenience. Here is an example:

       ldapsearch -D "cn=Directory Manager" -w password -b "ou=Accounting,ou=HR,dc=corp,dc=com" \
       -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tmorris,ou=Accounting,ou=HR,dc=corp,dc=com" "(objectClass=*)"

Response Control
----------------

This control may only be included in the ldap\_search\_response message as part of the controls field of the LDAPMessage.

### Control Type (OID)

It is the same as the OID in the request control.

### Control Criticality

There is no need to set the criticality on the response.

### Control Value

It is an OCTET STRING, whose value is the BER encoding of a value of the following SEQUENCE:

       GetEffectiveRightsResponse ::= {    
           result ENUMERATED {    
               success             (0),    
               operationsError         (1),    
               unavailableCriticalExtension    (12),    
               noSuchAttribute         (16),    
               undefinedAttributeType      (17),    
               invalidAttributeSyntax      (21),    
               insufficientRights      (50),    
               unavailable         (52),    
               unwillingToPerform      (53),    
               other               (80)    
           }    
       }    

### Effective Rights

The effective rights are returned with each entry returned by the search result.

       PartialEffectiveRightsList ::= SEQUENCE {    
           entryLevelRights    [0] EffectiveRights,    
           attributeLevelRights    [1] AttributeLevelRights    
       }    

       AttributeLevelRights ::= SEQUENCE OF {    
           attr    [0] SEQUENCE OF Attribute,    
           rights  [1] EffectiveRights    
       }    

       EffectiveRights ::= CHOICE {    
           rights          [0] Permissions,    
           noRights        [1] NULL,    
           errorEvaluatingRights   [2] GerError    
       }    

       Permissions ::= CHOICE {    
           PermissionsOnEntries,    
           PermissionsOnAttributes    
           (CONSTRAINED BY { -- at least one bit must be set -- })    
       }    

       PermissionsOnEntries ::= BIT STRING {    
           add         (0),    /; "a"    
           delete          (1),    /; "d"    
           export          (2),    /; "e", not supported in FDS    
           import          (3),    /; "i", not supported in FDS    
           renameDN        (4),    /; "n"    
           browseDN        (5),    /; "b", not supported in FDS    
           viewEntry       (6),    /; "v"    
           returnDN        (7),    /; "t", not supported in FDS    
           unveil          (15),   /; "u", not supported in FDS    
           getEffectiveRights  (16)    /; "g", see section "g permission" below    
       }    

-- Note: See p.14-15 [the AC Model draft](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt) for details.

       PermissionsOnAttributes ::= BIT STRING {    
           read            (8),    /; "r"    
           search          (9),    /; "s"    
           searchPresence      (10),   /; "p", not supported in FDS    
           write           (11),   /; "w" (mod-add)    
           obliterate      (12),   /; "o" (mod-del)    
           compare         (13),   /; "c"    
           make            (14)    /; "m", not supported in FDS    
       }    

-- Note: See p.13-14 [the AC Model draft](http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-ldapext-acl-model-08.txt) for details.

       GerError ::= ENUMERATED {    
           generalError        (0),    
           insufficientAccess  (1)    
       }    

### The Scope of Returned Results

The set of entries and attributes that are returned are those visible to the requester, not the gerSubject. This means that it is possible that if gerSubject could see an entry that the requester could not then the requester could not retrieve the effective rights of gerSubject on that entry. However, the idea here is that the requester will typically be a powerful administrator whose access rights will be a superset of those of other users.

The attribute list contained in a AttributeLevelRights field consists the attributes either returned as part of the search operation or explicitly requested but not returned.

### "G" Permission

Once a given subject has "g" permission on a given entry then he has the right to see the effective rights of any subject on that entry.

Fedora DS does not support any granting or revocation of "g" permissions. It assumes that the "root" user has "g" permission on any entry, and others have "g" permission" only on their own entries.

### Scenarios

Below lists the expected response of the server in various scenarios:

       if (server does not support this control)    
       {    
           if (TRUE == requester's controlCriticality field)    
           {    
               server MUST return unavailableCriticalExtension    
               as a return code in the searchResponse message    
               and not send back any other results;    
           }    
       }    
       else /* server supports this control */    
       {    
           if (search request failed)    
           {    
               server SHOULD omit the GetEffectiveRightsResponse control    
               from the searchResult message;    
           }    
           else if (server cannot process the control for some reason)    
           {    
               if (TRUE == requester's controlCriticality field)    
               {    
                   server SHOULD return error code    
                   as a return code in the searchResult message;    
               }    
               else    
               {    
                   server should include the error code in the entry and attribute level rights    
                   and return GetEffectiveRightsResponse message with a result of success;    
               }    
           }    
           else if (server can return the rights information)    
           {    
               server should include the GetEffectiveRightsResponse control    
               in the searchResult message with a result of success;    
           }    
       }    

Command Line Interface

    version: 1
    dn: uid=scarter,ou=accounting,ou=hr,dc=mcom,dc=com
    l: Sunnyvale
    userPassword: {SSHA}DT6pYJTYHl jE1tyCMEhxNXBekv9TtwBG7KyNQ==
    entryLevelRights: vadn
    attributeLevelRights: l:rscwo, street:rscwo, userPassword:wo

Server Changes
==============

Define new OID if it has not been defined already in C SDK;

Register the new control to root DSE: This might be done in control.c::init\_controls().

Invoke the new control:

-   Define a new op flag OP\_FLAG\_GET\_EFFECTIVE\_RIGHTS;
-   opshared.c::op\_shared\_search() sets OP\_FLAG\_GET\_EFFECTIVE\_RIGHTS bit for the current operation if LDAP\_CONTROL\_GET\_EFFECTIVE\_RIGHTS presents in pblock's SLAPI\_REQCONTROLS
-   result.c::send\_ldap\_search\_entry\_ext(), which is called once for every entry to be returned as search results, invokes the acl plugin to get the effective rights if the proper flag is set in the current operation;

Send the response of the new control back to LDAP clients: This is done in result.c::send\_ldap\_search\_entry\_ext():

-   If the control is critical but fails, the function sends the error code and text back;
-   Otherwise the function appends the entry and attribute level effective rights to the end of the BER stream of the attribute list sent back to the clients. Note that the rights may not be added directly to the entry in memory since the entry is shared. Moreover, the function sends the response control back as well.

Get effective rights
--------------------

This is implemented as a new acl function. The core acl evaluation function is acl\_access\_allowed(). It has two relevant restrictions: one is that it can only evaluate one type of rights at one time, the other is that all evaluation context is kept in two extensions: aclcb of the current connection, and aclpb of the current operation. The major job of the new GetEffectiveRights function is to construct the proper context for gerSubject and repetitively call acl\_access\_allowed() to evaluate various rights.

Console Changes
===============

Right-Click Menu of Each Entry Shown Under [Directory] Tab

-   Add new item [View Effective Rights...] to pop up EffectiveRightsRequest window described below.

New EffectiveRightsRequest Window The window should provide the following information and functions:

-   Title [Effective Rights Request on 'dn: <dn>']
-   Toggle buttons to specify the subject as [Requester], [Anonymous] or [Other], where [Other] is accompanied by an input field and a [Browse...] button
-   Check box for the entry level effective rights, default is checked;
-   List of all allowable attributes of the entry, each of them is associated with a check box;
-   Buttons to check/uncheck the attributes in the attribute list: [Check All], [Check None] or [Check Existing];
-   Button [Get Effective Rights] to issue an ldapsearch request with this control, and pop up EffectiveRightsResponse window upon the response of the ldapsearch.
-   Button [Help] to explain all aspects of View Effective Rights.
-   Button [Cancel] to close the window.

New EffectiveRightsResponse Window The window should provide the following information and functions:

-   Title [Effective Rights on 'dn: <dn>']
-   Entry level effective rights shown as a list of check boxes;
-   Attribute level effective rights shown as a list of check boxes;
-   Button [Help] to explain the permissions.
-   Button [Close] to close the window.

Mozilla LDAP C SDK Client Tool Changes
======================================

Add the new OID in ldap-extension.h

Modify ldapsearch.c to interpret the response control.

Unit Test
=========

Check server DSE Server should now list the OID of the GetEffectiveRights control in the attribute supportedControl in the root DSE;

ldapsearch

-   with subject being requester, anonymous, existing dn and non-existing dn;
-   with existing and non-existing attributes;
-   with various roles and access privileges (those could be set up by the startup of the current acl acceptance test);

Console

-   Repeat similar tests done with ldapsearch
-   Test every button in two new windows

