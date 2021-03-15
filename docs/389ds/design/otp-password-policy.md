---
title: "OTP password policy"
---

# One-Time Password password policy
----------------

Overview
--------

One of the more popular options to increase authentication security is to use one-time password (OTP). Such passwords are typically used for a unique registration. The purpose of this document is to describe a OTP support in 389-ds password policy with the following constraint:
 - The user entry **must** have a password policy with attribute 'passwordMustChange: **on**' and OTP attributes (see below) are set.
 - Only administrator can set OTP userpassword
 - Authentication attempts (successfull or failing) with OTP password are allowed a fixed number of times (typically one time)
 - Authentication attempts (successfull or failing) with OTP password are allowed a within a maximum delay (for example withing 10min)
 - On successfull authentication with OTP password the only autorized operation in the connection is to reset the account password with a new password

Use cases
---------

A user account inherit from a password policy that supports OTP. The administrator sets a registration password (userpassword)
and communicates that registration password to the end user. The end user can authenticate with its user account using the registration password.
The number of attempts to authenticate is limited and/or the period of time the registration password is valid.

Major configuration options and enablement
------------------------------------------

The password policy contains two new configuration attributes:

 - passwordOTPMaxUse (default: -1): It is the number of time the OTP password can be used to authenticate
 - passwordOTPExpirationDelay (default: -1): It is the number of seconds, after it has been set by administrator, that the OTP password can be used to authenticate

By default OTP setting are disabled and no limit (#use / expiration) is enforced

Those new limits are enforced at the condition that the password policy force the change of the 'userpassword' after a reset by administrator: 'passwordMustChange: **on**'

Design
-------

# Schema Changes

The password policy ('passwordPolicy') contains two new attributes:

- **passwordOTPMaxUse** : It is the number of times the OTP password can be used to authenticate
- **passwordOTPExpDelay** : It is the number of seconds, after password reset, that the OTP password can be used to authenticate

A user entry may contains OTP related operational attributes:

- **pwdOTPUseCount** : It is the number of times that the OTP password has been used
- **pwdOTPExpTime** : It is the expiration time of the OTP password
- **pwdOTPReset** : It is a flag indicating that the 'userpassword' is a OTP password

    attributeTypes: ( 2.16.840.1.113730.3.1.2378 NAME 'pwdOTPReset' DESC '389 Directory Server password policy attribute type' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2379 NAME 'pwdOTPUseCount' DESC '389 Directory Server password policy attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2380 NAME 'passwordOTPMaxUse' DESC '389 Directory Server password policy attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2381 NAME 'pwdOTPExpTime' DESC '389 Directory Server password policy attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation X-ORIGIN '389 Directory Server' )
    attributeTypes: ( 2.16.840.1.113730.3.1.2382 NAME 'passwordOTPExpDelay' DESC '389 Directory Server password policy attribute type' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE X-ORIGIN '389 Directory Server' )
    objectClasses: ( 2.16.840.1.113730.3.2.12 NAME 'passwordObject' DESC 'Netscape defined password policy objectclass' SUP top MAY ( pwdpolicysubentry $ passwordExpirationTime $ passwordExpWarned $ passwordRetryCount $ retryCountResetTime $ accountUnlockTime $ passwordHistory $ passwordAllowChangeTime $ passwordGraceUserTime $ pwdReset $ pwdOTPReset $ pwdOTPUseCount $ pwdOTPExpTime) X-ORIGIN 'Netscape Directory Server' )
    objectClasses: ( 2.16.840.1.113730.3.2.13 NAME 'passwordPolicy' DESC 'Netscape defined password policy objectclass' SUP top MAY ( passwordMaxAge $ passwordExp $ passwordMinLength $ passwordKeepHistory $ passwordInHistory $ passwordChange $ passwordWarning $ passwordLockout $ passwordMaxFailure $ passwordResetDuration $ passwordUnlock $ passwordLockoutDuration $ passwordCheckSyntax $ passwordMustChange $ passwordStorageScheme $ passwordMinAge $ passwordResetFailureCount $ passwordGraceLimit $ passwordMinDigits $ passwordMinAlphas $ passwordMinUppers $ passwordMinLowers $ passwordMinSpecials $ passwordMin8bit $ passwordMaxRepeats $ passwordMinCategories $ passwordMinTokenLength $ passwordTrackUpdateTime $ passwordAdminDN $ passwordDictCheck $ passwordDictPath $ passwordPalindrome $ passwordMaxSequence $ passwordMaxClassChars $ passwordMaxSeqSets $ passwordBadWords $ passwordUserAttributes $ passwordSendExpiringTime $ passwordOTPMaxUse $ passwordOTPExpDelay) X-ORIGIN 'Netscape Directory Server' )


External Impact
---------------

Building the server on platforms other than RHEL and Fedora would need to have some form of tcmalloc (libtcmalloc) available on that system.

Origin
-------------

https://bugzilla.redhat.com/show_bug.cgi?id=1186512

Author
------

<tbordaz@redhat.com>
