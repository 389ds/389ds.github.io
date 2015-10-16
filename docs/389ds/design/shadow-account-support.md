---
title: "Shadow Account Support Design"
---

# Shadow Account Support Design
------------------

{% include toc.md %}

Overview
========

ShadowAccount objectclass and its attribute type belonging to the objectclass is defined in RFC 2307, 389-ds-base schema file 10rfc2307.ldif.
Currently, shadowAccount is not explicitely supported.  
For instance, one of the attribute type shadowLastChange is supposed to be updated when the password of the account is modified, but it is not.
The shadowAccount attribute types are mapped to the subset of Password Policy attribute types.  
This design doc proposes to support shadowAccount based upon the existing Password Policy values.

Description of shadowAccount
============================

### Schema

shadowAccount objectclass and the attribute types are defined in 10rfc2307.ldif.

    objectClasses: ( 1.3.6.1.1.1.2.1 NAME 'shadowAccount' DESC 'Standard LDAP objectclass' SUP top AUXILIARY MUST uid MAY ( userPassword $ shadowLastChange $ shadowMin $ shadowMax $ shadowWarning $ shadowInactive $ shadowExpire $ shadowFlag $ description ) X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.5 NAME 'shadowLastChange' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.6 NAME 'shadowMin' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.7 NAME 'shadowMax' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.8 NAME 'shadowWarning' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.9 NAME 'shadowInactive' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.10 NAME 'shadowExpire' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )
    attributeTypes: ( 1.3.6.1.1.1.1.11 NAME 'shadowFlag' DESC 'Standard LDAP attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN 'RFC 2307' )

### shadowAccount attribute values v.s. /etc/shadow 

    :AbcDefgHijkLMnOP:13654:0:99999:7: : :0
     ---------------- ----- - ----- - - - -
           |            |   |   |   | | | └ shadowFlag
           |            |   |   |   | | └ shadowExpire
           |            |   |   |   | └ shadowInactive
           |            |   |   |   └ shadowWarning
           |            |   |   └ shadowMax
           |            |   └ shadowMin
           |            └ shadowLastChange
           └ userPassword (hashed)

### Attributes

<b>shadowLastChange</b> - Indicates the number of days between January 1, 1970 and the day when the user password was last changed. (single-valued)

<b>shadowExpire</b> - Indicates the date on which the user login will be disabled. (single-valued)

<b>shadowFlag</b> - not currently in use.

<b>shadowInactive</b> - Indicates the number of days of inactivity allowed for the user. (single-valued)

<b>shadowMax</b> - Indicates the maximum number of days for which the user password remains valid. (single-valued)

<b>shadowMin</b> - Indicates the minimum number of days required between password changes. (single-valued)

<b>shadowWarning</b> - The number of days of advance warning given to the user before the user password expires. (single-valued)

Implementation
==============

Only if the entry has the auxiliary objectclass shadowAccount, the following operations are executed.

The shadowAccount attributes could be devided into 2 classes: shadowLastChange and the others.  
ShadowLastChange needs to be dynamically updated when the user password is changed, 
while the other attributes are static which could be derived from the password policy values.

### shadowLastChange
When an entry having a user password is added, 0 is set if passwordMustChange is on in the password policy that the entry follows.  Otherwise, the number of days between January 1, 1970 and the day when the entry is added is set.

    dn: cn=cn\3DnsPwPolicyEntry\2Cou\3DPeople\2Cdc\3Dexample\2Cdc\3Dcom,cn=nsPwPolicyContainer,ou=People,dc=example,dc=com
    passwordMustChange: on
    
    dn: uid=tuser,ou=People,dc=example,dc=com
    shadowLastChange: 0

When a user password is updated, the value of shadowLastChange is replaced with the number of days between January 1, 1970 and the day when the user password is updated.

    dn: uid=tuser,ou=People,dc=example,dc=com
    shadowLastChange: 16724

If an entry being added does not contain a user password, even if it is a shadowAccount entry, shadowLastChange is not added.

If an entry being added already contains the shadowLastChange, the value is not updated in the add operation.

### Other shadowAccount attributes
When ldapsearch sends the search result in "iterate", add_shadow_ext_password_attrs is called.  
In the function, it checks if the entry contains an auxiliary objectclass shadowAccount.
If it does, it retrieves password policy and fills the shadowAttributes as follows:

    shadowMin = passwordMinAge / (60 * 60 *24)
    shadowMax = passwordMaxAge / (60 * 60 *24)
    shadowWarning = passwordWarning / (60 * 60 *24)
    shadowExpire = (current_time() + passwordMaxAge) / (60 * 60 *24)
    shadowFlag = 0 ## not currently in use.

    shadowInactive is not auto-filled since there is no corresponding policy.

Tickets
=======
* Ticket [\#548](https://fedorahosted.org/389/ticket/548) - RFE: Allow AD password sync to update shadowLastChange
