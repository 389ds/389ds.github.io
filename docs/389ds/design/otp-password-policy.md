---
title: "OTP password policy"
---

# One-Time Password password policy
----------------

{% include toc.md %}

# Overview
---------

One of the more popular options to increase authentication security is to use one-time password (OTP). Such passwords are typically used for a unique registration. The purpose of this document is to describe a OTP support in 389-ds password policy with the following constraint:
 - Only administrator can set OTP userpassword, with appropriate password policy.
 - Authentication attempts (successfull or failing) with OTP password are allowed a fixed number of times (typically one time)
 - Authentication attempts (successfull or failing) with OTP password are allowed a within a maximum delay (for example withing 10min)
 - On successfull authentication with OTP password the only autorized operation in the connection is to reset the account password with a new password

# Use cases
-----------

A user account inherit from a password policy that supports OTP. The administrator sets a registration password (userpassword)
and communicates that registration password to the end user. Then the end user can authenticate with its user account using the registration password.
The number of attempts to authenticate is limited and/or the period of time the registration password is valid.

# Major configuration options and enablement
--------------------------------------------

The password policy contains two new configuration attributes:

 - passwordOTPMaxUse (default: -1): It is the number of time the OTP password can be used to authenticate
 - passwordOTPExpirationDelay (default: -1): It is the number of seconds, after it has been set by administrator, that the OTP password can be used to authenticate

By default OTP setting are disabled and no limit (#use / expiration) is enforced

Those new limits are enforced at the condition that the password policy force the change of the 'userpassword' after a reset by administrator: 'passwordMustChange: **on**'

# Design
--------

### Implementation
During a bind (*do_bind*), similarly to account lockout policy, OTP policy should be enforced against the target entry. If OTP limits are overpass then bind returns *LDAP_CONSTRAINT_VIOLATION*. A difference with account lockout policy is that there is **no** delay (password policy 'passwordLockoutDuration') to unlock the account. If OTP limits have been overpassed, the account can no long successfully bind until adminstrator assignes a new OTP registration password.

When the 'userpassword' is updated (*update_pw_info*) by an administrator and it exists a OTP policy, then the server flags that the entry has a OTP password with 'pwdOTPReset: TRUE'. In addition it updates 'pwdOTPExpTime' and 'pwdOTPUseCount' according the password policy.

When the 'userpassword' is updated (*update_pw_info*) by a regular user, if 'pwdOTPReset: TRUE' then 'pwdOTPExpTime', 'pwdOTPUseCount' are removed.

Once 'pwdOTPExpTime' is set, it is enforced during further bind but does not need to be updated during enforcement.
In the opposite 'pwdOTPUseCount' needs to be udpated on each bind. When a non admin user binds (*need_new_pwd*), the server increases 'pwdOTPUseCount'.
When bind fails (*do_bind* or *send_ldap_results_ext* ?), the server checks if the account has a OTP related attribute 'pwdOTPUseCount' and increase it.

### OTP policy

OTP policy is set in the password policy with **passwordOTPMaxUse** and **passwordOTPExpDelay**. The password policy can be global or local ('pwdpolicysubentry'). The OTP policy trigger is that the administrator sets a temporary password that, once bound, the user must change. As a consequence the OTP policy also requires **passwordMustChange: on**. The password policy may look like:

    dn: cn="cn=nsPwPolicyEntry,uid=jdoe,ou=people,dc=example,dc=com",
         cn=nsPwPolicyContainer,ou=people,dc=example,dc=com
    objectclass: top
    objectclass: extensibleObject
    objectclass: ldapsubentry
    objectclass: passwordpolicy
    passwordMustChange: on
    passwordOTPMaxUse: 3
    passwordOTPExpDelay: 3600

A bind, with the account using this policy, is allowed 3 times maximum. The bind being successful or not.
The bind must be done within one hour after the administator set the OTP password.
After these limits any bind, using this account, will fail.


### Schema Changes

The password policy ('passwordPolicy') contains two new attributes:

- **passwordOTPMaxUse** : It is the number of times the OTP password can be used to authenticate
- **passwordOTPExpDelay** : It is the number of seconds, after password reset, that the OTP password can be used to authenticate

A user entry may contains OTP related *operational* attributes:

- **pwdOTPUseCount** : It is the number of times that the OTP password has been used
- **pwdOTPExpTime** : It is the expiration time of the OTP password
- **pwdOTPReset** : It is a flag indicating that the 'userpassword' is a OTP password


    attributeTypes: ( 2.16.840.1.113730.3.1.2378 NAME 'pwdOTPReset' DESC '389 Directory Server password policy attribute type'
        EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation 
        X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2379 NAME 'pwdOTPUseCount' DESC '389 Directory Server password policy attribute type' 
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation 
        X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2380 NAME 'passwordOTPMaxUse' DESC '389 Directory Server password policy attribute type' 
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2381 NAME 'pwdOTPExpTime' DESC '389 Directory Server password policy attribute type' 
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2382 NAME 'passwordOTPExpDelay' DESC '389 Directory Server password policy attribute type' 
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    objectClasses: ( 2.16.840.1.113730.3.2.12 NAME 'passwordObject' DESC 'Netscape defined password policy objectclass' SUP top 
        MAY ( pwdpolicysubentry $ passwordExpirationTime $ passwordExpWarned $ passwordRetryCount $ retryCountResetTime $ 
        accountUnlockTime $ passwordHistory $ passwordAllowChangeTime $ passwordGraceUserTime $ pwdReset $ pwdOTPReset $ 
        pwdOTPUseCount $ pwdOTPExpTime) X-ORIGIN 'Netscape Directory Server' )
    objectClasses: ( 2.16.840.1.113730.3.2.13 NAME 'passwordPolicy' DESC 'Netscape defined password policy objectclass' SUP top 
        MAY ( passwordMaxAge $ passwordExp $ passwordMinLength $ passwordKeepHistory $ passwordInHistory $ passwordChange $ 
        passwordWarning $ passwordLockout $ passwordMaxFailure $ passwordResetDuration $ passwordUnlock $ passwordLockoutDuration $ 
        passwordCheckSyntax $ passwordMustChange $ passwordStorageScheme $ passwordMinAge $ passwordResetFailureCount $ 
        passwordGraceLimit $ passwordMinDigits $ passwordMinAlphas $ passwordMinUppers $ passwordMinLowers $ passwordMinSpecials $ 
        passwordMin8bit $ passwordMaxRepeats $ passwordMinCategories $ passwordMinTokenLength $ passwordTrackUpdateTime $ 
        passwordAdminDN $ passwordDictCheck $ passwordDictPath $ passwordPalindrome $ passwordMaxSequence $ passwordMaxClassChars $ 
        passwordMaxSeqSets $ passwordBadWords $ passwordUserAttributes $ passwordSendExpiringTime $ passwordOTPMaxUse $ 
        passwordOTPExpDelay) X-ORIGIN 'Netscape Directory Server' )


# External Impact
-----------------


# Origin
--------

https://bugzilla.redhat.com/show_bug.cgi?id=1626633

# Author
--------

<tbordaz@redhat.com>
