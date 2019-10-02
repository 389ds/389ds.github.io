---
title: "Token Authentication for Directory Server"
---

# Token Authentication

Overview
--------

In order to support 389-ds-portal, we need to issue cookies to the client that allow the flask
application to rebind as a user. This is so that the flask application holds no state, no
persistent connections, and no need to encrypt data etc. We could even have the flask backend
behind a load balancer without sticky sessions. This means flask can not hold any state.

However, LDAP is modeled so that a connection is "long lived". This doesn't work with the
stateless model that we want to achieve with flask. LDAP does a bind (auth), then changes and
searches are sent over the authenticated connection as a whole session.

What is required is a way to allow the client session (cookie) to contain the needed data to
allow a new connection, bind, operation and unbind to occur.

Current (Insecure) Method
-------------------------

The current proof of concept 389-ds-portal uses fernet tokens in flask. If the bind succeeds we
encrypt the dn and password that were used into a fernet token, that is issued in a cookie to the
client.

This means the cookie can be re-used on other hosts - modern technologies like same-site policies
help to prevent this, but there is still potential for risk as the password contained within
contains no expiry. The risk of someone bruteforcing the fernet token is low however, because
this uses randomised key material in the poc.

Planned Method
--------------

Instead, we should not encrypt user passwords. We should make 389 responsible for issuing the fernet
tokens, that contain randomised or nonce-values instead. 

To achieve this we would:

    simple_bind_s(dn, password)
    token = extop_s(cookie_issue)

To then reauth, the token which is a base64 string would be used in simple_bind_s

    simple_bind_s(dn, token)
    ...

Considerations
--------------

If you have used a token in the simple_bind_s, you should not be able to perform an extop_s to
issue a subsequent token. This is to prevent infinite extension of sessions.

The tokens would be fernet, with a time limit applied - which is effectively the session limit.

The fernet encryption key would be stored in cn=config, and if there are multiple servers
must be the same between them all to allow sessions to be used between servers.

Implementation Details
----------------------

* An extra configuration item needs to be added to dse.ldif as the fernet key. It should be generated and saved if not present.
* A configartion in dse.ldif for token lifetime in seconds.
* Fernet (from Rust :D) should be used to generate the token.
* A flag is added to connection to indicate if the authentication was from token or pw? (Check if there is an existing enum for auth type)
* An extended operation must be added, that takes no parameters (only an OID is required). If conn-auth != token && bind != anonymous we can issue the token.
* An extended operation response which is a base64 string is returned. This should be websafe base64.

Authenticating the Token
------------------------

Fernet tokens are an aes128 + hmac token containing a timestamp. If the token doesn't pass hmac, doesn't decrypt with the key, or the timestamp has passed currenttime + ttl, then the
decryption "fails". If it fails, we reject the auth. If it passes, we accept it as a token session.

This means in simple bind we:

	check if the input is a token
		true:
			if decrypt token:
				auth as tokenand mark conn-auth = token, return
	continue simple bind as normal

To issue the token:


	if conn-auth != token && dn != anonymous:
		create token and return to the client


