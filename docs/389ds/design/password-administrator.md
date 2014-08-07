---
title: "Password Administrators"
---

# Password Administrators
-------------------------

Overview
--------

Previously only the root DN (e.g. cn=Directory Manager) was allowed to do certain password operations. Such operations included resetting userpasswords(forcing the user to reset the password on the next login), changing a users password to a different storage scheme that is defined in the policy, and adding already hashed passwords.

Use Cases
---------

Now directory administrators can define a user, or a group of users, who are "Password Administrators", for example helpdesk employees.

Design
------

In either the global password policy, or a local password policy, you can specify a DN of a group, or a user, that is a password administrator. These entries do need access control permissions to update such attributes as: userPassword, passwordExpirationtime, etc.

The attribute for configuring this is: passwordAdminDN

Example: 

    passwordAdminDN: cn=Passwd Admins,ou=groups,dc=example,dc=com

Implementation
--------------

Since access control rules do need to be set, it is recommended that a group is used for the password administrators. This way only one ACI is needed to manage the password administrators.

Feature Management
-----------------

CLI Only

Use ldapmodify to set passwordAdminDN in the main config entry(cn=config) for in a local password policy container.

Major configuration options and enablement
------------------------------------------

You must set the passwordAdminDN attribute.

Replication
-----------

No impact on replication.

Updates and Upgrades
--------------------

No impact on updates and upgrades.

Dependencies
------------

This feature is new to 1.3.1, and is currently not available on earlier releases of 389 DS.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

