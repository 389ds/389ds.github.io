---
title: "Password Expiration Controls"
---

# Password Expiration Controls
--------------------------

{% include toc.md %}

## Introduction

When authenticating/binding against the server, and your password is expired, is about to expire, or it needs to be reset, the server can return two types of controls: "expired/expiring" control, and an optional bind response control if requested by the client.  The expired/expiring controls just indicate that the password is expired, or it is about to expire.  The bind response control contains more detailed information about the state of the password that is expired or expiring.

This document applies to later versions of 389-ds-base-1.3.6 and up.  Older versions do not send the EXPIRED control during grace logins.

<br>

## Server Configuration and Process

A client issues a bind.  If a valid password is used then the server checks if that password is expired, or if it is about to expire(expiring).  In such a case the server will return the Expired or Expiring Control, and if requested the bind response control with more detailed information.  There are several configuration settings that impact the behavior of password expiration:

- **passwordExp** - this must be set to "*on*" for password expiration to be enforced.
- **passwordMaxAge** - this specifies how long in seconds a password is valid (non-expired).
- **passwordWarning** - this specifies in the number of seconds before a password is to expire that the server will start sending a warning(EXPIRING CONTROL).  If a password is expired but the warning was not sent, the server will "send the warning", then it will add the warning value to the current expiration time.
- **passwordMustChange** - if set to "on" anytime a password is reset by an administrator it will require the user must change their password before being allowed to any other kind of operation.
- **passwordGracelimit** - this sets the number of logins allowed *after* a password has expired.
- **passwordSendExpiringTime** - When set to "*on*" this tells the server to always return the EXPIRING CONTROL regardless if the  password warning was sent.


<br>

## The Password Policy Request/Response Control:

    1.3.6.1.4.1.42.2.27.8.5.1

This is the control the client sends to the server to request password expiration information.  This is the same control that is returned to the client during the "bind response".  Below is the control that is returned to the client:

    PasswordPolicyResponseValue ::= SEQUENCE {
        warning   [0] CHOICE OPTIONAL {
            timeBeforeExpiration  [0] INTEGER (0 .. maxInt),
            graceLoginsRemaining  [1] INTEGER (0 .. maxInt) }
        error     [1] ENUMERATED OPTIONAL {
            passwordExpired       (0),
            accountLocked         (1),
            changeAfterReset      (2),
            passwordModNotAllowed (3),
            mustSupplyOldPassword (4),
            invalidPasswordSyntax (5),
            passwordTooShort      (6),
            passwordTooYoung      (7),
            passwordInHistory     (8) } }

If you are using ldapsearch, you can use this option to request this control:  ```-e ppolicy```

<br>

## The Expired/Expiring Controls

These controls are *always* returned to the client.  They do not have to be requested.

    2.16.840.1.113730.3.4.4 - EXPIRED CONTROL
    2.16.840.1.113730.3.4.5 - EXPIRING CONTROL


### Expired Control

The expired control (2.16.840.1.113730.3.4.4) is sent under the following circumstances:

- The password is expired, and grace logins have been exhausted.  The BIND is rejected with an error 49.
    - If the password policy response control was requested (1.3.6.1.4.1.42.2.27.8.5.1) control field **error** is *0* (passwordExpired). 


- The password is expired, but there are still grace logins remaining.  The BIND is allowed.
    - If the password policy response control was requested the control field **graceLoginsRemaining** is set to the number of remaining grace logins.


- The password was reset by an administrator and requires the password be reset (passwordMustChange is set to "on").  The BIND is allowed, but any subsequent operation other than changing the password results in an error 53.
    - If the password policy response control was requested the control field **error** is set to *2* (changeAfterReset).

### Expiring Control

The expiring control (2.16.840.1.113730.3.4.5) is sent under the following circumstances:

- The password is going to expire within the password warning period.
    - If the password policy response control was requested (1.3.6.1.4.1.42.2.27.8.5.1) the control field **timeBeforeExpiration** is set to the number of seconds before the password will expire.


- Using a password policy configuration option (*passwordSendExpiringTime: on*), the EXPIRING control is always returned, regardless if the password is within the warning period.
    - If the password policy response control was requested the control field **timeBeforeExpiration** is set to the number of seconds before the password will expire.

<br>

## Examples

Here are some examples using ldapsearch.  With ldapsearch you use a built option for requesting the password policy controls:  "**-e ppolicy**".

**Although these examples use ldapsearch, it is the BIND op, not the SEARCH op, that triggers the controls sent by the server.**

### Expiring

This example shows the expiring and response control in action

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0) (Password expires in 110 seconds)
    dn:
    ...


### Expired

This is a typical expired password example

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Invalid credentials (49); Password expired
	    additional info: password expired!

### Expired password, but remaining grace logins

This shows a sequence of binds showing grace logins in action

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password expired (Password expired, 1 grace logins remain)
    dn:
    ...

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password expired (Password expired, 0 grace logins remain)
    dn:
    ...

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Invalid credentials (49); Password expired
	    additional info: password expired!

### Password reset, user must change password

This example shows when Directory Manager, or a Password Admin, resets someone's password, and **passwordMustChange** is set to *on*.

    ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password must be changed (Password expires in 0 seconds)
    Server is unwilling to perform (53)

This is a really a bind and search.  So the bind was successful, but performing a search is not allowed (error 53) until the password is reset by the user.

<br>


