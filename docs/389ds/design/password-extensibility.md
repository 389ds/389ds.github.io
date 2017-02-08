---
title: "Password Extensibility"
---

### Overview

Directory Server has had a traditional view of passwords: one password to an account.
This has served us well, but with modern security challenges this is now not enough.
We need to potentially support multiple factors of authentication, and storing multiple
hashes of passwords in a variety of formats.

This is a strong barrier to integration and improvement with IPA, so we must address this.

There are 4 areas we need to improve.

#### Considerations

* If possible this should be for the proposed plugin v4 api.
* We will move current pwenc functions and verification into an internal userPassword plugin.

#### Password quality checking

Before a password set operation, there have been requests to customise the password quality checking process in extended ways.

A plugin would register a function as PLUGIN_PASSWORD_QUALITY_FN.

Plugin order is non-determinined, and should not affect this operation.

This function would be called within a write transaction - but should not write to the system.

The plugin is given the parameter block that contains a complete copy of the target entry, and the cleartext password material from the modification (userPassword field or extended operation).

On an error or success the plugin returns a slapi_plugin_result. The server will send the ldap response and log a generic failure message for the plugin. After a plugin
has errored, the operation is aborted, and rolled back.

Only if all plugins succeed (or ignore the operation ie suceed) is the password change operation begun.

The benefit of this is that these plugins can be checked based on policy applied to the entry. They can assert more complex policies than the current password
framework. This allows sites to deploy their own password policy modules that we may not be willing to provide.

#### Password Set Process

During a password set, we need to be able to direct the cleartext password material to multiple backends. Consider, we need to set:

* userPassword
* ntUserNtPassword
* ipaNTPassword
* kerberos credentials

A plugin would register a function as PLUGIN_PASSWORD_STORE_FN, PLUGIN_PASSWORD_STORE_COMMIT_FN and PLUGIN_PASSWORD_STORE_ABORT_FN.

Plugin order is non-determinined, and should not affect this operation.

This function would be called within a write transaction.

The plugin is given the parameter block that contains a complete copy of the target entry, and the cleartext password material from the modification (userPassword field or extended operation).

On an error or success the plugin returns a slapi_plugin_result. The server will send the ldap response and log a generic failure message for the plugin. After a plugin
has errored, the operation is aborted, and rolled back.

If the plugin has registered a STORE_ABORT_FN, this is called during the abort process so that external plugins may undo any changes that the internal write TXN does not cover.

Only if all plugins succeed (or ignore the operation ie suceed) is the change commited. If a plugin has registered a STORE_COMMIT_FN, this is called at this point to single the operation is successful.

The benefit of this is that plugins can:

* See the plaintext material we wish to set
* Make decisions about whether to set (for example, you may wish ntUserNtPassword to only be hashed directory, rather that via a userPassword change)
* We can have multiple attributes each storing password materials in different ways.

#### Password Verification Process

During a verification, we need to be able to have multiple plugins assert the validity of the password in various ways. This could enable:

* Two plugins to check two different hash types.
* Externalising a single verification to an external source (ie kdc)
* Altering the material during the verification (ie stripping an OTP from the tail, and verifying it).

A plugin would register a fenction as PLUGIN_PASSWORD_VERIFICATION_FN

Plugin order is guaranteed based on first priority from lowest to higest (0 to 99), where duplicate priority falls back to alphanumeric sorting of plugin name.

This function is called in a read transaction.

The plugin is given the parameter block that contains a complete copy of the target entry that is attempting a bind, and the cleartext password which the bind is attempted with.

The plugin may alter the bind password material and return it to the pblock.

A plugin may return results of REQUISITE to say the verified their authentication component and to keep checking, DEFERRED to abstain from the process due to not being relevant, or FAILURE indicating that an invalid token of some kind has been recieved, or SUCCESS to indicate that the check has passed and no more attempts are needed.

For example, an authentication may proceed as:

    ldapbind dn='cn=testuser' pw='password123456'
    otp_plugin verifies 123456, returns 'password' to pb. REQUISITE
    ipaNtPassword DEFERED.
    kdc DEFERED.
    userPassword plugin verifies 'password' hashed against userPassword attribute of the entry. SUCCESS

Alternately, we could use kerberos:

    ldapbind dn='cn=testuser' pw='password123456'
    otp_plugin verifies 123456, returns 'password' to pb. REQUISITE
    ipaNtPassword DEFERED
    kdc verifies 'password' against principal. SUCCESS
    userPassword not attempted.

Finally, if we see the following:

    ldapbind dn='cn=testuser' pw='password123456'
    otp_plugin verifies 123456, returns 'password' to pb. REQUISITE
    ipaNtPassword DEFERED
    kdc verifies 'password' against principal. DEFERED
    userPassword DEFERED

This would be a failure case, because no SUCCESS was given.



The benefit of this is:

* Multiple paths to verify a password, based on the entry. For example, if the kdc doesn't have principal data, it can defer without concern of misallowing a bind.
* Multiple optional types of MFA module, in various combinations. May even include out of band data. For example, MFA may apply based on policy for an account.
* Existing single password systems continue to work.
* Detailed auditing of where authentication's are failing or not.


#### Password Hash Upgrade

This behaviour is specific to the proposed userPassword plugin (that wraps the current pwenc functionality).

The current issue with upgrading hashes is that if we change the password storage scheme, the hashes "on disk" do not change until a password change operation occurs.

We should default to a policy of on bind, if the userPassword storage scheme does not match the pwpolicy storage scheme, as we still have the plaintext password we recalculate and set the hash.

This only occurs on a succesful bind attempt, but before we return SUCCESS to the plugin framework.

This requires a write transaction, so we need to start an internal write txn inside of the bind.




