---
title: "Howto: Password Reset"
---

# How to Reset Passwords
----------------------

### How To Reset an Account After Too Many Login Attempts

The short answer is - just delete the operational attributes passwordRetryCount and accountUnlockTime in the user's entry.

-   From the console, edit the user's entry, and select the Advanced editor. Delete those attributes from the list.
-   From the command line, you can use ldapmodify:

    ldapmodify -D "cn=directory manager" -w password
    dn: DN of user e.g. uid=scarter,ou=people,dc=example,dc=com
    changetype: modify
    delete: passwordRetryCount
    -
    delete: accountUnlockTime

There are 3 operational attributes in the user's entry that deal with this:

-   **passwordRetryCount** - this is the number of unsuccessful BIND attempts the user has made - if the user tries to BIND, and this number is greater than the max failure count, the user will be locked out. This number is reset to 0 upon a successful BIND.

When the user is locked out, there are two additional attributes that come into play:

-   **accountUnlockTime** - datetime in GMT - this is the time at which the account will become unlocked. A value of 0 means the account must be unlocked by an administrator.
-   **retryCountResetTime** - datetime in GMT - this is the time after which the **passwordRetryCount** will be reset to 0.

