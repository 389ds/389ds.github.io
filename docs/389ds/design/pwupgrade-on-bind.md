---
title: Password Upgrade on Bind
---

# Password Upgrade on Bind
--------------------------
{% include toc.md %}

## Overview
-----------

As passwords have to be stored in a secure manner, this is a really important aspect of
389 Directory Server's secure operation goals. It's important that we continue to improve
and provide the "best" storage of credentials for administrators and their users so that
their accounts are secure from various types of attack.

## Password storage best practices over time
--------------------------------------------

Overtime we have seen a lot of changes in password storage practice from:

* crypt - 8 char max
* md5 - often used with challenge response protocols
* sha - password stored with 'secure' hashing algorithms
* salted sha - passwords stored with 'salt' to prevent attacks by rainbow tables
* kdf - key derivation functions that have known work factors

Today's best practice (2019) is kdf - the reason is that an algorithm like SHA is designed
for hardware performance and effeciency. Awesome for verifying TLS packets are correct
from the wire, but not so good with passwords as attackers can brute force passwords offline
at a high rate.

KDF's are intended to require *at least* some minimum work factor, so that an attacker
with the password list must spend a great deal of resources to attack the passwords offline.

To make it clear, in 389 Directory Server the current only secure password storage mechanism
is PBKDF2_SHA256 or if this is not possible, SSHA512. All other algorithms are considered
insecure, and should NOT be used in any circumstance.

## How we improve this situation
--------------------------------

As a project we still have to support these older algorithms like MD5 as deployments may
have long-running service accounts that have not had their passwords rotated in a long time
(Which is fine, password rotation is harmful based on modern advice).

To help improve this, we can upgrade the quality of the password hash on login. During a
simple bind, we have access to the plaintext password due to the nature of the bind operation
allowing us to "rehash" it and save it.

A high level overview is:

    client              server

    simple_bind(pw)  ->  conn->pw (the plaintext pw)
                             if entry->hash == hash(conn->pw)
                                  if entry->hash != pwd-storage-scheme
                                       entry-> hash = new_hash(pw)
                                  return success
                             else
                                  return failure

## How to alter this behaviour
------------------------------

We believe this is a setting that you should leave enabled due to the benefits it provides.

If you have a special scenario that precludes this, you can disable the behaviour with:

    dn: cn=config
    nsslapd-enable-upgrade-hash: off

It's worth noting that the common reasons to want to disable this all have security issues. For
example:

* crypt passwords from other systems may have character limits and are likely not to be a kdf
* plaintext passwords for RADIUS, should have a seperate RADIUS pw rather than using the account primary password
* md5 for SASL-CRAM or other SASL mechanisms are able to be attacked trivially on the wire.
* "compliance" to security auditor standards that claim SHA is the only secure password mechanism (this is flatly incorrect).

In almost all cases the only secure option is LDAPS (TLS) with simple bind or SASL PLAIN, and
using the strongest hash type and allow enable-upgrade-hash to remain on.

Due to 389's "config improvement on upgrade" policy, as we add better options for password hash
types these will continue to improve "over time" with no action required from you.

## Extra: Threat Modeling of the Risks
--------------------------------------

It's always worth looking at the threat models that exist and how we face and solve these. This
setting helps by:

* Preventing password disclosure from compromised backups (on disk, on tape etc)
* Preventing password disclosure from an access control violation or high privilege account breach that can read userPassword
* By preventing the MITM of insecure SASL mechanisms (IE SASL-CRAM) by removing MD5 hashes. These SASL types provide a false sense of security
* Encouraging the use of LDAPS(TLS) due to requiring ldap simple bind or SASL-PLAIN.
* To "delay" bruteforce attacks by having minor delays to calculate each password hash on the server via the kdf
* Allowing proactive improvements to your credential storage security, rather than reactive
* Lowering time and mental pressure on administrative teams when deployment security-sensitive products

Author
------

William Brown <wbrown at suse.de>
