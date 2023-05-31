---
title: "cn=config Configuration Reset Design"
---

# cn=config Configuration Reset Design.

Overview
========

Traditionally we have maintained a large stack of values in dse.ldif. This led to the creation of perl scripts for upgrades to be able to change these values. We also maintain many values in libglobs.c, and slap.h for the default configuration.

Overtime these have moved around a bit and have become inconsistent. There have been some odd behaviours.

The biggest challenge, is after you deploy an instance, how do you know what values came with DS? And what did I the admin change? This affects the ability to migrate servers easily, and means a large investment of time to analyse configs to determine what has been changed. Addtionally, it was hard for an admin to know if a value was default or not, and there was no way to reset to the default.

Vision
======

The goal is:

* dse.ldif should only contain "what has been modified in this instance". If it's in dse.ldif, it's because you changed it.
* Easier for us as developers to add default values.
* Encourage us as developers to be able to change and improve our default values.
* Reduce scripts for upgrades / downgrade process.
* Allow admins to "reset to default" incase of error, or change.

Design
======

It turns out all the pieces to achieve the above are already in place in directory server. We could already delete values from cn=config if they were in the nsslapd-allowed-to-delete-attrs attribute. These values would come with a default value in libglobs.c, and it would be set when the MOD_DELETE took place. Most of the values in dse.ldif were just copied straight out of libglobs.c and slap.h.

Cleanup
-------

All the values in libglobs.c and slap.h were centralised into slap.h.

Everything that came with a default, was corrected to have a default correctly setup with slapdFrontendConfig_t and config_get_and_set in libglobs.c.

A large number of values were identified that should *not* be allowed to be deleted or reset. These are marked with a default of NULL in libglobs.c.

Reduce
------

Every value that was duplicated from slap.h to template-dse.ldif was removed from template-dse.ldif. This way the value in "slap.h" is used, and dse.ldif only contains site specific information.

Allow deletion
--------------

Finally, remove the reliance on the nsslapd-allowed-to-delete attribute. If a value defines a proper default, it can be deleted.

Document
--------

Add a guide into libglobs.c about the details of the process, and how to add and manage configurations.

Test
----

Test that deleting everysingle value in cn=config works, and the server can restart. This is now automated into the lib389 testing suite.

Result
======

Look in dse.ldif

    cn=config
    ...
    nsslapd-maxthreads: 2

Start the server, and delete the value, and check it again.

    cn=config
    ...

It's missing from dse.ldif. Do an ldapsearch of cn=config while the server is running.

    cn=config
    ...
    nsslapd-maxthreads: 30

We have the default value from slap.h.

Developers
==========

Provided that the value is *not* in dse.ldif we can now upgrade. Consider:

    version 1.3.6: nunc-stans-enabled: on

So we ship with nunc-stans-enabled in this version. Say we find a bug in nunc-stans. When we push an update to directory server, we can change this:

    version 1.3.6-1: nunc-stans-enabled: off

This would now disable nunc-stans for all instances, provided they have not explicitly enabled it.

Then for 1.3.7 we decide to enable nunc-stans again.

So the admin does a yum upgrade. This would result in:

    version 1.3.7: nunc-stans-enabled: on

The admin isn't happy, so they yum downgrade:

    version 1.3.6-1: nunc-stans-enabled: off

No scripts or other intervention was needed to roll the setting back between the two versions.

Notes
=====

Password Storage Scheme
-----------------------

These configurations include the default password storage scheme for the system password policy. We have chosen the scheme to be the most widely avaliable on all currently
supported versions of Directory Server. This scheme will be upgraded like any other configuration as server requirements change, and older versions EOL. We hope to continually improve our password storage scheme through this function, without need for administrator intervention.

So to be explicit, as of 2017-02-15 we use SSHA512 for 1.3.x and 1.2.x as the "strongest hash on all supported platforms". This way we do NOT introduce replication issues.

In a future date, if we find that 1.3.6 is the lowest supported version, we can lift this to PBKDF2.

Author
======

wibrown at redhat.com

