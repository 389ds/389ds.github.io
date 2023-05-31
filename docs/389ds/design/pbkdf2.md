---
title: ""
---

# PBKDF2
---------

PBKDF2 unlike SSHA and friends is a real password derivation function. This takes the input (the password) and after many rounds of hashing outputs a "derived key" or in this case, the password hash.

## Why?
-------

SHA is a good cryptographic hash, but it is a poor password hash. This is because as a cryptographic hash, it's meant to allow fast checking that the content has not been altered.

The risk of this is that this performance that makes it good for cryptographic verification, makes it poor for password storage, as an attacker with many GPUs can quickly bruteforce the password. This means in a compromise you may risk your passwords being exposed!

Key derivation functions on the other hand are design to force you to expend resources, through multiple rounds (CPU hard), memory usage (memory hard) or others. PBKDF2 is a CPU hard KDF, with variable tuning. Overtime we will adjust the timing in DS as CPU power increases, so that there is no risk of admins "forgetting" and weakening their systems.

## Parameters
-------------

PBKDF2 takes a number of "rounds", or the number of times to apply SHA256 to the input.

Due to the risk of this value being forgotten or incorrectly set by an admin, we retain this value as a compile time value in DS.

As of 1.3.6 this value in 30,000 rounds. This will be incremented in the future, so consult the documentation or code for this.

The number of rounds is encoded to the hash output, so an older hash with fewer iterations will still work on a newer server with a greater value.

## What about scrypt or argon?
------------------------------

I would love to use both! But they are not yet in NSS: Help by raising issues and awareness so that NSS increases the priority to resolve this situation!

Reality is that PBKDF2 is the best KDF they can offer today, so that's what we have to use.

## Challenges
-------------

NSS in EL6 does not support PBKDF2, so the presence of a 1.2.x replica disallows the usage of PBKDF2. 

NSS in EL7 only supports PBKDF2 after NSS 3.22 or higher. As a result, we can only support PBKDF2 in 1.3.6 and higher, which is tied to Fedora and RHEL that supports this version.

