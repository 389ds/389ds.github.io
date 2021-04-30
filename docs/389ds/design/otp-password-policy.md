---
title: "Temporary Password Rules"
---

# Temporary Password Rules password policy
----------------

{% include toc.md %}

# Overview
---------

One of the more popular options to increase authentication security is to use a temporary password. Such passwords are typically used for a unique registration. The purpose of this document is to describe a Temporary Password Rules support in 389-ds password policy with the following constraint:
 - Only administrator can set Temporary Password (i.e. userpassword), with appropriate password policy.
 - Authentication attempts (successfull or failing) with Temporary Password are allowed a fixed number of times (typically one time)
 - Authentication attempts (successfull or failing) with Temporary Password are allowed a within a maximum delay (for example withing 10min)
 - On successfull authentication with Temporary password the only autorized operation in the connection is to reset the account password with a new password

# Use cases
-----------

A user account inherit from a password policy that supports Temporary Password Rules. The administrator sets a registration password (userpassword)
and communicates that registration password to the end user. Then the end user can authenticate with its user account using the registration password.
The number of attempts to authenticate is limited and/or the period of time the registration password is valid.

An administrator wants to specify a same period of registration for a set of accounts. This although it is not possible to reset, at the exact same time, the registration password of all account.

# Major configuration options and enablement
--------------------------------------------

The password policy contains new configuration attributes:

 - passwordTPRMaxUse (default: -1): It is the number of time the registration password can be used to authenticate
 - passwordTPRDelayExpireAt (default: -1): After the administator sets the registration password, it is the number of seconds before the registration password expires 
 - passwordTPRDelayValidFrom (default: -1): After the administator sets the registration password, it is the number of seconds after which registration password starts to be valid for authenticate with

By default TPR setting are disabled and no limit (#use / expiration / validity) is enforced

Those new limits are enforced at the condition that the password policy force the change of the 'userpassword' after a reset by administrator: 'passwordMustChange: **on**'

# Design
--------

### Implementation
During a bind (*do_bind*), similarly to account lockout policy, TPR policy should be enforced against the target entry. If TPR limits are overpass then bind returns *LDAP_CONSTRAINT_VIOLATION*. A difference with account lockout policy is that there is **no** delay (password policy 'passwordLockoutDuration') to unlock the account. If TPR limits have been overpassed, the account can no longer successfully bind until adminstrator assignes a new TPR registration password.

When the 'userpassword' is updated (*update_pw_info*) by an administrator and it exists a TPR policy, then the server flags that the entry has a TPR password with 'pwdTPRReset: TRUE'. In addition it updates 'pwdTPRExpTime' and 'pwdTPRUseCount' according the password policy.

When the 'userpassword' is updated (*update_pw_info*) by a regular user, if 'pwdTPRReset: TRUE' then 'pwdTPRExpTime', 'pwdTPRUseCount' are removed.

Once 'pwdTPRExpTime' is set, it is enforced during further bind but does not need to be updated during enforcement.
In the opposite 'pwdTPRUseCount' needs to be udpated on each bind. When a non admin user binds (*need_new_pwd*), the server increases 'pwdTPRUseCount'.
When bind fails (*do_bind* or *send_ldap_results_ext* ?), the server checks if the account has a TPR related attribute 'pwdTPRUseCount' and increase it.

### TPR policy

TPR policy is set in the password policy with **passwordTPRMaxUse**, **passwordTPRDelayExpireAt** and **passwordTPRDelayValidFrom**. The password policy can be global ('cn=config') or local ('pwdpolicysubentry'). The TPR policy trigger is that the administrator sets a temporary password that, once bound, the user must change. As a consequence the TPR policy also requires **passwordMustChange: on**. The password policy may look like:

    dn: cn="cn=nsPwPolicyEntry,uid=jdoe,ou=people,dc=example,dc=com",
         cn=nsPwPolicyContainer,ou=people,dc=example,dc=com
    objectclass: top
    objectclass: extensibleObject
    objectclass: ldapsubentry
    objectclass: passwordpolicy
    passwordMustChange: on
    passwordTPRMaxUse: 3
    passwordTPRDelayExpireAt: 3600
    passwordTPRDelayValidFrom: 600
    

    dn: uid=mark,dc=example,dc=com
    userpassword: xxx
    pwdTPRReset: true
    pwdTPRUseCount: 0
    pwdTPRValidFrom: 20210325103000Z
    pwdTPRExpireAt: 20210325110000Z

With the account using this policy, the user can bind 3 times maximum. The bind being successful or not.
The user has a *window* of 50 minutes to complete his registration.
After the administrator set the 'userpassword', the user must wait 10 minutes before attempting a first bind and
the user must bind within one hour.

After or before these limits any bind, using this account, will fail.

### update of temporary password attribute

Reseting the password account also sets the TPR attributes  'pwdTPRValidFrom' and 'pwdTPRExpireAt' based on the current time. To allow a set of accounts to have the same values of 'pwdTPRValidFrom' and/or 'pwdTPRExpireAt'. Those attributes, that are **operational** , are modifiable (no *NO_USER_MODIFICATION* in the schema). So an administrator having the rights to update those attributes can overwrite the computed values.

Updatable TPR attributes are: 'pwdTPRUseCount', 'pwdTPRValidFrom' and 'pwdTPRExpireAt'

### Schema Changes

The password policy ('passwordPolicy') offers new TPR releated attributes:

 - **passwordTPRMaxUse** (default: -1): It is the number of time the registration password can be used to authenticate
 - **passwordTPRDelayExpireAt** (default: -1): After the administator sets the registration password, it is the number of seconds before the registration password expires 
 - **passwordTPRDelayValidFrom** (default: -1): After the administator sets the registration password, it is the number of seconds after which registration password starts to be valid for authenticate with

A user entry may contains TPR related *operational* attributes:

- **pwdTPRUseCount** : It is the number of times that the TPR password has been used. -1 means it is not enforced
- **pwdTPRExpireAt** :  It is the absolute time (UTC) before which the 'userpassword' is valid fro autentication. -1 means it is not enforced.
- **pwdTPRValidFrom** : It is the absolute time (UTC) after which the 'userpassword' is valid fro autentication. -1 means it is not enforced.
- **pwdTPRReset** : It is a flag indicating that the 'userpassword' is a TPR password (reset by the administrator). True mean the 'userpassword' is a TPR password (registration password)


    attributeTypes: ( 2.16.840.1.113730.3.1.2378 NAME 'pwdTPRReset' DESC '389 Directory Server password policy attribute type'
     EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation
     X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2379 NAME 'pwdTPRUseCount' DESC '389 Directory Server password policy attribute type' 
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE USAGE directoryOperation 
     X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2381 NAME 'pwdTPRExpireAt' DESC '389 Directory Server password policy attribute type'
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE MODIFICATION USAGE directoryOperation
     X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2381 NAME 'pwdTPRValidFrom' DESC '389 Directory Server password policy attribute type'
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE MODIFICATION USAGE directoryOperation
     X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2380 NAME 'passwordTPRMaxUse' DESC '389 Directory Server password policy attribute type'
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2382 NAME 'passwordTPRDelayExpireAt' DESC '389 Directory Server password policy attribute type'
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2382 NAME 'passwordTPRDelayValidFrom' DESC '389 Directory Server password policy attribute type'
     SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )


    objectClasses: ( 2.16.840.1.113730.3.2.12 NAME 'passwordObject' DESC 'Netscape defined password policy objectclass' SUP top MAY
     ( pwdpolicysubentry $ passwordExpirationTime $ passwordExpWarned $ passwordRetryCount $ retryCountResetTime $
       accountUnlockTime $ passwordHistory $ passwordAllowChangeTime $ passwordGraceUserTime $ pwdReset $ 
       pwdTPRReset $ pwdTPRUseCount $ pwdTPRExpireAt $ pwdTPRValidFrom ) X-ORIGIN 'Netscape Directory Server' )
    objectClasses: ( 2.16.840.1.113730.3.2.13 NAME 'passwordPolicy' DESC 'Netscape defined password policy objectclass' SUP top MAY 
       ( passwordMaxAge $ passwordExp $ passwordMinLength $ passwordKeepHistory $ passwordInHistory $ passwordChange $ 
       passwordWarning $ passwordLockout $ passwordMaxFailure $ passwordResetDuration $ passwordUnlock $ 
       passwordLockoutDuration $ passwordCheckSyntax $ passwordMustChange $ passwordStorageScheme $ passwordMinAge $ 
       passwordResetFailureCount $ passwordGraceLimit $ passwordMinDigits $ passwordMinAlphas $ passwordMinUppers $ 
       passwordMinLowers $ passwordMinSpecials $ passwordMin8bit $ passwordMaxRepeats $ passwordMinCategories $ 
       passwordMinTokenLength $ passwordTrackUpdateTime $ passwordAdminDN $ passwordDictCheck $ passwordDictPath $ 
       passwordPalindrome $ passwordMaxSequence $ passwordMaxClassChars $ passwordMaxSeqSets $ passwordBadWords $ 
       passwordUserAttributes $ passwordSendExpiringTime $ passwordTPRMaxUse $ passwordTPRDelayExpireAt $ 
       passwordTPRDelayValidFrom ) X-ORIGIN 'Netscape Directory Server' )


# External Impact
-----------------


# Origin
--------

https://bugzilla.redhat.com/show_bug.cgi?id=1626633

# Author
--------

<tbordaz@redhat.com>
