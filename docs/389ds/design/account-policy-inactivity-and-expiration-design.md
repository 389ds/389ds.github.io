---
title: "Account Policy Plugin Inactivity and Expiration Design"
---

# Account Policy Plugin Inactivity and Expiration Design
----------------

Overview
--------

According to the [Red Hat Directory Server Docs](https://access.redhat.com/documentation/en-us/red_hat_directory_server/11/html/administration_guide/account-policy-plugin) you can setup the Account Policy plugin to either use inactivity or expiration to deny users from authenticating.  This enhancement is to allow both criteria to be applied when a user authenticates.  The change is behavior is configurable via a new setting "**checkAllStateAttrs: yes**".

When this is no set, or set to "no", then the plugin checks for the state attribute (typically *lastLoginTime*).  If this attribute is not present in the entry, then the plugin will check the *alternate state attribute*.  In the case where you want the plugin to handle expiration (based on the *passwordExpirationtime* attribute), you would set the main state attribute to a non-existent attribute, and set the alternate state attribute to **passwordExpirationtime**.

This enhancement, when enabled, will check the main state attribute, and if the account is fine it will then check the alternate state attribute.  The difference here from the password policy password expiration is that with account policy plugin it will completely disable the account if the passwordExpirationtime exceeds the inactivity limit.  While with the password policy expiration the user and can still log in and change their password.  So this new  account policy feature completely blocks the user from doing anything and then an administrator must reset the account.

Warning - this is really desiged to only work when the alternate state attribute is set to "passwordExpiratontime".   Setting it to "createTimestamp" will cause undesired results as most entries will get locked out!


Major configuration options and enablement
------------------------------------------

There is a new config setting for the plugin:

- checkAllStateAttrs:  *on/off* or *yes/no*


Origin
-------------

<https://bugzilla.redhat.com/show_bug.cgi?id=2174161>
<https://github.com/389ds/389-ds-base/issues/5749>

Author
------

<mreynolds@redhat.com>

