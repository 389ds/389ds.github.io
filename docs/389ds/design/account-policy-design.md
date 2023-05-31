---
title: "Account Policy Design"
---

# Account Policy Plugin - Software Design Specification
-------------------------------------------------------

{% include toc.md %}

Introduction
------------

The Fedora Directory Server equips administrators with a set of features for managing account access, including password policy and account inactivation. However, beyond the ability to lock out an account based on password failures, and being able to specify accounts that should be inactivated, there is a lack of account policy functionality. An example is that roles and class of service can inactivate accounts that were created before a certain date using a filter on the createTimestamp, but it can't inactivate accounts that have existed for more than a certain amount of time because that requires a comparison between the creation time with the current time. Therefore we propose to create an account policy plugin to handle some of the more popular account policy features requested in the past.

Goals and Guidelines
--------------------

Our goals include simple but flexible configuration. For basic usage the required configuration should be trivial with sensible defaults. However, high customization needs to be available. For example, at least until we've settled on a schema, we'll provide attribute mapping.

We also want to provide easy but flexible administration. We don't want to complicate administrators' lives unnecessarily when they want to add or remove a policy for a set of users. It should be simple to define a policy and target a set of users.

Finally we want to provide easy means for auditing the account states where applicable.

## Detailed Design

General Plugin Configuration
----------------------------

When the plugin starts up it will check if it's being started with an argument (nsslapd-pluginarg0). If it has an argument, the value should point to a configuration entry which will be retrieved by DN. If the plugin does not have an argument some defaults will be used. If the entry pointed to be the DN can not be retrieved, plugin initialization will fail and the plugin will not start because assuming defaults when there a configuration entry is indicated would be a security risk. If the configuration entry is retrieved it will be parsed for configuration. Any options missing in the configuration entry will take on defaults. Here is an example configuration:

    dn: cn=Account Policy Plugin,cn=plugins,cn=config    
    objectClass: top    
    objectClass: nsSlapdPlugin    
    objectClass: extensibleObject    
    cn: acct_policy_plugin    
    nsslapd-pluginPath: libacctpolicy-plugin    
    nsslapd-pluginInitfunc: acct_policy_init    
    nsslapd-pluginType: object    
    nsslapd-pluginEnabled: on    
    nsslapd-plugin-depends-on-type: database    
    nsslapd-pluginId: acct-policy    
    nsslapd-pluginarg0: cn=config,cn=Account Policy Plugin,cn=plugins,cn=config    

    dn: cn=config,cn=Account Policy Plugin,cn=plugins,cn=config    
    objectClass: top    
    objectClass: extensibleObject    
    cn: config    
    alwaysrecordlogin: yes    
    stateattrname: lastLoginTime    
    altstateattrname: createTimestamp    
    specattrname: acctPolicySubentry    
    limitattrname: accountInactivityLimit    

<br>

## Detailed Design of Account Inactivity
-------------------------------------

### Introduction

This component of the account policy plugin will inactivate accounts based on their inactivity. It's implemented in two parts, a post-op BIND callback which maintains a timestamp of the last login in the binding entry, and pre-op BIND callback which compares the current time with the last login timestamp and makes an allow or deny decision.

### Logging

The logging subcomponent will record a timestamp in the bind entry after successful binds. The timestamp will be stored in the bind entry in generalized Zulu format like "%Y%m%d%H%M%SZ" (trailing literal 'Z') in the operational attribute lastLoginTime. Unless the configuration has alwaysrecordlogin set to true, the plugin will only maintain the timestamps in bind entries that are covered by an inactivity policy; that is anyone who has an acctPolicySubentry attribute. Here is an example of a person who is covered by an account policy and has a login timestamp:

    dn: uid=scarter,ou=people,dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    title: engineer    
    uid: scarter    
    sn: Carter    
    cn: Sam Carter    
    lastLoginTime: 20060527001051Z    
    acctPolicySubentry: cn=AccountPolicy,dc=example,dc=com    

### Enforcement Method

Enforcement is implemented as a SLAPI\_PLUGIN\_PRE\_BIND\_FN and performs the inactivity check using the lastLoginTime value and the current date, compared to the limit specified in the account policy that covers the bind entry. Example account policy:

    dn: cn=AccountPolicy,dc=example,dc=com    
    objectClass: top    
    objectClass: ldapsubentry    
    objectClass: extensibleObject    
    objectClass: accountpolicy    
    # 86400 seconds per day * 30 days = 2592000 seconds    
    accountInactivityLimit: 2592000    
    cn: AccountPolicy    

If successful the plugin returns 0 and the bind proceeds like normal. If the inactivity limit has been exceeded an LDAP error and a message are sent to the client and the plugin returns -1 which ends the bind attempt.

If the lastLoginTime is missing then the user has never logged in and the administrator didn't provision one. An alternate attribute is used in this case, the createTimestamp by default.

However, this method will not work well with older releases of Directory Server because bind preop functions are not currently called from SASL binds, which makes SASL bind a loophole around our inactivity enforcement.

### Schema Changes

Registered schema used by the account policy plug-in.

    #    
    # Schema for the account policy plugin    
    #    
    dn: cn=schema    
    ##    
    ## lastLoginTime holds login state in user entries (GeneralizedTime syntax)    
    attributeTypes: ( 2.16.840.1.113719.1.1.4.1.35 NAME 'lastLoginTime'    
      DESC 'Last login time'    
      SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE USAGE directoryOperation    
      X-ORIGIN 'Account Policy Plugin' )    
    ##    
    ## acctPolicySubentry is an an account policy pointer (DN syntax)    
    attributeTypes: ( 1.3.6.1.4.1.11.1.3.2.1.2 NAME 'acctPolicySubentry'    
      DESC 'Account policy pointer'    
      SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE USAGE directoryOperation    
      X-ORIGIN 'Account Policy Plugin' )    
    ##    
    ## accountInactivityLimit specifies inactivity limit in accountPolicy objects    
    ## (DirectoryString syntax)    
    attributeTypes: ( 1.3.6.1.4.1.11.1.3.2.1.3 NAME 'accountInactivityLimit'    
      DESC 'Account inactivity limit'    
      SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE    
      X-ORIGIN 'Account Policy Plugin' )    
    ##    
    ## accountPolicy is the objectclass of account policy subentries    
    objectClasses: ( 1.3.6.1.4.1.11.1.3.2.2.1 NAME 'accountPolicy'    
      DESC 'Account policy entry'    
      SUP top AUXILIARY MAY ( accountInactivityLimit )    
      X-ORIGIN 'Account Policy Plugin' )    

### Outstanding Issues

1.  User Interface
    1.  Will we need support in the GUI? Both enforcement methods require the use of Roles and CoS, maybe we can leverage the existing stuff. But the Account Inactivation feature has full UI that adds all the required roles and stuff, and so does Local PWP.
    2.  If we add UI, should we also touch replication? When adding account inactivity policy we could search for agreements and offer to add lastLoginTime to the excluded attribute list, if they don't want to replace last login state.

2.  Standards compliance
    1.  Should we inquire with the current maintainer of the password policy draft if we can sneak account inactivity into the same draft? <http://directory.fedora.redhat.com/wiki/Account_Policy_Design#Bibliography> Although the password policy draft deals with some account related stuff like account lockout time after password failures, account inactivity falls into an area less gray and more dark, so maybe not. Is there an account policy draft?
    2.  As of 2010-09-29, <http://tools.ietf.org/html/draft-behera-ldap-password-policy-10> talks about a policy for "idle passwords" but it's been indicated on ldapext mailing list that this might be changed later on to act on individual passwords, while a future account policy would be more in line with what my plug-in implements. Keep an eye on "idle passwords" in future password policy drafts, and for any account policy draft that might surface.

### Additional features

#### New attribute alwaysRecordLoginAttr
	
<b>Update lastLoginTime in Account Policy plugin if account lockout is based on passwordExpirationTime.</b>

The Red hat Directory server handles automatic account inactivity through the Account Policy plugin. Through this plugin, one has the flexibility to determine whether an entry should be inactivated depending on the value of a particular attribute (referenced by the value of stateAttrName). Moreover, this plugin also provides the functionality to store the last login time of an entry (also stored in the attribute referenced by the value of stateAttrName). This request is for an improvement in functionality, in which this dual role of the stateAttrName attribute is split into two separate attributes. This would provide functionality that is inachievable with the current semantics.

Example: 

If account lockout is based on passwordExpirationTime under Account Policy plugin then lastLoginTime does not get updated. The configuration used for passwordExpirationTime is given below.

    dn: cn=config,cn=Account Policy Plugin,cn=plugins,cn=config
    objectClass: top
    objectClass: extensibleObject
    cn: config
    alwaysrecordlogin: yes
    stateAttrName: abc
    altStateAttrName: passwordExpirationTime
    specattrname: acctPolicySubentry
    limitattrname: accountInactivityLimit
    accountInactivityLimit: 2592000

In above configration stateAttrName has set with dummy value hence when the dummy is not available then altStateAttrName is checked for alternate value. The above configuration help is implemention account lockout base on passwordExpirationTime and the passwordExpirationTime does not get update with customer login time. But this configuration does not allow lastLoginTime to be updated.

This feature is required because certain account/password policies cannot be implemented with the current semantics. For example, it is impossible to keep a record of user's the last login time and implement an inactivation policy in which accounts are inactivated after a number of days after password expiry. This  requirement is simple to explain and also quite commonly included in organisations' password policy - yet it is impossible to implement. Setting the stateAttrName to passwordExpirationTime would not work because the current semantics would also update the passwordExpirationTime with the user's last login time (resulting in all accounts becoming expired after login).

Here are the attributes of interest in the Account Policy Plugin outlining the changes.

<b>alwaysRecordLogin</b>: yes | no, Whether every entry records its last login time.
                    (NOTE: No changes from current implementation.)

<b>alwaysRecordLoginAttr</b>: (New Attribute) What user attribute will store the last login time of a user.
                        If empty, should have the same value as stateAttrName. 
                        default value: empty

<b>stateAttrName</b>: The primary user attribute to check when evaluating the inactivity policy.
                The attribute referenced by the value of stateAttrName is never changed.
                (NOTE: this user attribute should NO LONGER be updated with with user's
                 last login time whenever a user authenticates with the directory server).

<b>altStateAttrName</b>: The 'backup' attribute to check when evaluating the inactivity policy.
                   The attribute referenced by the value of altStateAttrName is never changed.
                   (NOTE: No changes from current implementation) 

## Detailed Design of Account Expiration
-------------------------------------

### Introduction

This component of the account policy plugin will inactivate accounts based on an expiration date.

### Design

This works in a similar way to Account Inactivation. The account policy in effect for an entry would specify an expiration period for the account and upon login the plugin tests whether the current time minus the time in the createTimestamp is greater than the expiration period. createTimestamp is already automatically added when new entries are added.

    dn: uid=scarter,ou=people,dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    title: engineer    
    uid: scarter    
    sn: Carter    
    cn: Sam Carter    
    createTimestamp: 20060527001051Z    
    acctPolicySubentry: cn=AccountPolicy,dc=example,dc=com    

    dn: cn=AccountPolicy,dc=example,dc=com    
    objectClass: top    
    objectClass: ldapsubentry    
    objectClass: extensibleObject    
    objectClass: accountpolicy    
    # 86400 seconds per day * 30 days = 2592000 seconds    
    expirationPeriod: 2592000    
    cn: AccountPolicy    

### Schema Changes

TBD.

### Outstanding Issues

Mostly same as the Account Inactivation issues.

### Bibliography

(1) Prasanta Behera's password policy draft, 9th iteration (http://www.faqs.org/ftp/internet-drafts/draft-behera-ldap-password-policy-09.txt)
