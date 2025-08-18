---
title: "How To Chain Password Policy In Replication"
---

# How To Chain Password Policy In Replication
----------------

## Overview

This page is just a followup to the [chain-on-update doc](https://www.port389.org/docs/389ds/howto/howto-chainonupdate.html), and this page shows exactly how to configure the server to chain & replicate password policy state attributes. As a recap, this feature is used when you have a read-only consumer that needs to keep account lockout failures in sync with other replicas. The following describes the exact configuration you need to get this working correctly.

## Configuration

In this example we have two replicas, a supplier (slapd-supplier on port **389**), and a consumer (slapd-consumer on port **5555**). Both instances are on the same system so all the CLI examples would have to be slightly changed to match the more common mutli-system setup.

### Password policy configuration

You must set "**passwordIsGlobalPolicy**" to "*on*" in all the servers in the replication deployment, and you must have some type of password policy/account lockout enabled. 

    # dsconf slapd-supplier pwpolicy set --pwdisglobal on
    # dsconf supplier pwpolicy set --pwdlockout on

    # dsconf slapd-consumer pwpolicy set --pwdisglobal on
    # dsconf consumer pwpolicy set --pwdlockout on
    
**NOTE** - local password policies (subtree/user policies) override the global policy. So if you have a subtree policy you must also set "**passwordIsGlobalPolicy**" in the local policy (there is a current bug where "nsslapd-pwpolicy-inherit-global" is not working for this particular setting).  So just to be safe just add "*passwordIsGlobalPolicy*" to the local password policy.
    
### Verify account lockout is replicated

We have not setup chaining yet. We are just confirming that everything is working at this step.  Bind on the suppler as a database user with the wrong password. Then **passwordRetryCount** should be updated and replicated to the consumer.

    # ldapsearch -xLLL -H ldap://localhost:389 -D "uid=demo_user,ou=people,dc=example,dc=com" -w wrong-password -s base -b ""
    ldap_bind: Invalid credentials (49)
    
    # ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 1
    
    # ldapsearch -xLLL -H ldap://localhost:5555 -D "cn=directory manager"-b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 1
    
Great everything is working as expected.  At this step if you had an authentication failure on the consumer then the the **passwordRetryCount** would be "2" on the consumer and "1" on the supplier - they would be out of sync. Setting up chaining would prevent this from happening.
    
### Setup Chain-On-Update on the consumer

Now on the consumer we create the chaining backend entry (aka the database link) and update the suffix/mapping tree config entry to point to the chaining entry

    # ldapmodify -x -H ldap://localhost:5555 -D "cn=directory manager" -w password
    dn: cn=chainonupdate,cn=chaining database,cn=plugins,cn=config
    changetype: add
    objectClass: top
    objectClass: extensibleObject
    objectClass: nsBackendInstance
    cn: chainonupdate
    nsslapd-suffix: dc=example,dc=com
    nsfarmserverurl: ldap://localhost:389
    nsmultiplexorbinddn: cn=replication manager,cn=config
    nsmultiplexorcredentials: password


    dn: cn="dc=example,dc=com",cn=mapping tree,cn=config
    changetype: modify
    add: nsslapd-backend
    nsslapd-backend: chainonupdate
    -
    add: nsslapd-distribution-plugin
    nsslapd-distribution-plugin: libreplication-plugin
    -
    add: nsslapd-distribution-funct
    nsslapd-distribution-funct: repl_chain_on_update



## Test that it's working ...

Everything is now set up and it should be working.  Let's try it out.  So now when we have a bind that fails on the consumer both the supplier and consumer should have the same value for **passwordRetryCount**

Attempt to bind to the *consumer* with the wrong password, and check that both servers are in sync

    # ldapsearch -H ldap://localhost:5555 -D "uid=demo_user,ou=people,dc=example,dc=com" -w wrong-password -s base -b ""
    ldap_bind: Invalid credentials (49)

    # ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 2

    # ldapsearch -xLLL -H ldap://localhost:5555 -D "cn=directory manager" -b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 2
    

Attempt to bind to the *supplier* with the wrong password (make sure this is still working in both directions)
    
    # ldapsearch -H ldap://localhost:389 -D "uid=demo_user,ou=people,dc=example,dc=com" -w wrong-password -s base -b ""
    ldap_bind: Invalid credentials (49)
    
    # ldapsearch -xLLL -H ldap://localhost:5555 -D "cn=directory manager" -b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 3
    
    # ldapsearch -xLLL -H ldap://localhost:389 -D "cn=directory manager" -b "uid=demo_user,ou=people,dc=example,dc=com" -w password passwordRetryCount
    dn: uid=demo_user,ou=people,dc=example,dc=com
    passwordRetryCount: 3

And that is it!

