---
title: "Password Expiration Controls"
---

# Password Expiration Controls
--------------------------

{% include toc.md %}

## Intro

When authenticating/binding against the server, and your password is expired or is about to expire, or it needs to be reset, the server can return two types of controls: "expired/expiring" control, and a response control if requested by the client 

<br>

## The Password Policy Request/Response Control:

    1.3.6.1.4.1.42.2.27.8.5.1

This is the control the client sends to the server to request password expiration information.  This is the same control that is returned to the client during the "bind response".  Below is the control that is returned to the client:

    PasswordPolicyResponseValue ::= SEQUENCE {
        warning   [0] CHOICE OPTIONAL {
            timeBeforeExpiration  [0] INTEGER (0 .. maxInt),
            remaining  [1] INTEGER (0 .. maxInt) }
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

These controls are always returned to the client.  They do not have to be requested.

    2.16.840.1.113730.3.4.4 - EXPIRED CONTROL

    2.16.840.1.113730.3.4.5 - EXPIRING CONTROL


### Expired Control

This control is sent under the following circumstances:

- The password is expired, and grace logins have been exhausted.  The BIND is rejected with an error 49.

    - If the password policy response control was requested (1.3.6.1.4.1.42.2.27.8.5.1) it will contain the error code *0* (passwordExpired). 

- The password is expired, but there are still grace logins remaining.  The BIND is allowed.

    - If the password policy response control was requested the control field **remaining** is set to the number of remaining grace logins.

- The password was reset by an administrator and requires that the password be reset (passwordMustChange is set to "on").  The BIND is allowed, but any subsequent operation other than changing the password results in an error 53.

    - If the password policy response control was requested the control error field is set to *2* (changeAfterReset).

### Expiring Control

This control is sent under the following circumstances:

- The password is going to expire within the password warning period.

    - If the password policy response control was requested (1.3.6.1.4.1.42.2.27.8.5.1) the control field **timeBeforeExpiration** is set to the number of seconds before the password will expire.

- Using a configuration option described below (*passwordSendExpiringTime: on*), the EXPIRING control is always returned, regardless if the password is within the warning period.

    - If the password policy response control was requested the control field **timeBeforeExpiration** is set to the number of seconds before the password will expire.

<br>

## Server Configuration

The 389 Directory Server uses the password policy controls as follows when the client requests them.

Client issues a bind.  If a valid password is used then the server checks if that password is expired, or if it is about to expire(expiring) the server will return the Expired/Expiring control, and if requested the response control (1.3.6.1.4.1.42.2.27.8.5.1) with more detailed information.  There are several configuration settings that impact the behavior of password expiration:

- **passwordExp** - this must be set to "*on*" for password expiration to be enforced.
- **passwordMaxAge** - this specifies how long in seconds a password is valid (non-expired).
- **passwordWarning** - this specifies in the number of seconds before a password is to expire that the server will start sending a warning(EXPIRING CONTROL).  If a password is expired but the warning was not sent, the server will "send the warning", then it will add the warning value to the current expiration time.
- **passwordGracelimit** - this sets the number of logins allowed after a password has expired.
- **passwordSendExpiringTime** - When set to "*on*" this tells the server to always return the EXPIRING CONTROL regardless if the  password warning was sent.

<br>

## Examples

Here are some examples using ldapsearch.  With ldapsearch you use a built option for requesting the password policy controls:  "**-e ppolicy**"

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

This example shows when Directory Manager, or a Password Admin, resets someones password, and **passwordMustChange** is set to *on*.

    ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password must be changed (Password expires in 0 seconds)
    Server is unwilling to perform (53)

This is a really a bind and search.  So the bind was successful, but performing a search is not allowed (error 53) until the password is reset by the user.


