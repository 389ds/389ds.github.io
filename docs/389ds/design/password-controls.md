---
title: "Password Expiration Controls"
---

# Password Expiration Controls
--------------------------

## Intro

When authenticating/binding against the server, and your password is expired or is about to expire, or it needs to be reset, the server can return response controls to the client if the client requests such controls.

<br>

## The Controls

The following describes the three controls you need to know about.  The Request control, and the Response controls.

### The Request Control:

    1.3.6.1.4.1.42.2.27.8.5.1

This is the control the client sends to the server to request password expiration information.


### The Response Controls

    2.16.840.1.113730.3.4.5 - EXPIRED CONTROL
    2.16.840.1.113730.3.4.4 - EXPIRING CONTROL

These are the controls the server send if the password is expired, expiring, or needs to be changed.  Below is the response control

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


#### Expired Control

This control is sent under the following curcumstances:

- The password is expired, and grave logins have been exhausted.  The response control error code is 0 (passwordExpired). The BIND is rejected with an error 49.
- The password is expired, but there are still grace logins remaining.  The response control field '*graceLoginsRemaining*' is set to the number of remaining grace logins.  The BIND is allowed.
- The password was reset by an administrator and requires that the password be reset.  The BIND is allowed, but any subsequent operation other than changing the password results in an error 53.  The response control error code is 2 (changeAfterReset).

#### Expiring Control

This control is sent under the following curcumstances.  Note, the response control field '*timeBeforeExpiration*' is set to the number of seconds remaining before the password expires

- The password is going to expire within the password warning period.
- Using a configuration option described below (passwordSendExpiringTime), the EXPIRING control is always returned, regardless of the warning period.  This is an easy way to check when anyone's password will expire.

<br>

## Server Implementation

The 389 Directory Server uses the password policy controls as follows when the client requests them.

Client issues a bind.  If a valid password is used then the server checks if that password is expired, or if it is about to expire(expiring).  There are several configuraton settings that impact the behavior of password expiraton:

- **passwordExp** - this must be set to "*on*" for password expiraton to be enforced.
- **passwordMaxAge** - this specifies how long in seconds a password is valid (non-expired)
- **passwordWarning** - this specifies in the number of seconds before a password is to expire that the server will send a warning(EXPIRING RESPONSE CONTROL)
- **passwordGracelimit** - this sets the number of logins allowed after a password has expired
- **passwordSendExpiringTime** - When set to "*on*" this tells the server to always return the EXPIRING RESPONSE CONTROL regardless if warning was sent.


## Examples

Here are some examples using ldapsearch.  With ldapsearch you use a built option for requesting the password policy controls:  "**-e ppolicy**"

### Expiring

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0) (Password expires in 110 seconds)

### Expired

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Invalid credentials (49); Password expired
	    additional info: password expired!


### Expired password, but remaining grace logins

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password expired (Password expired, 1 grace logins remain)
    dn:
    objectClass: top
    defaultnamingcontext: dc=example,dc=com
    dataversion: 020170920200143
    netscapemdsuffix: cn=ldap://dc=localhost:389

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password expired (Password expired, 0 grace logins remain)
    dn:
    objectClass: top
    defaultnamingcontext: dc=example,dc=com
    dataversion: 020170920200143
    netscapemdsuffix: cn=ldap://dc=localhost:389

    $ ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Invalid credentials (49); Password expired
	    additional info: password expired!

### Password reset, user must change password

    ldapsearch -D "uid=mreynolds,dc=example,dc=com" -xLLL  -w myTestPassword1 -b "" -s base -e ppolicy
    ldap_bind: Success (0); Password must be changed (Password expires in 0 seconds)
    Server is unwilling to perform (53)

