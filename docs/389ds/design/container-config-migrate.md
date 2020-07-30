---
title: "Container Configuration Migration and Upgrade"
---

# Container Configuration Migration and Upgrade
-----------------------------------------------

{% include toc.md %}

Overview
========

A necessary part of directory server is the ability to upgrade instances to use new features that
we have developed and provide to our users. However this problem space is far larger than
traditionally we have implemented for.

Previously, directory server has a strong relationship between the application (rpms and the
binaries they provide) and the state (the database, the configuration in /etc). This mean that
changes in the application could be assumed to occur with the state of the instance. Tools like
setup-ds.pl -u certainly did this, to upgrade instance configuration on upgrade of the rpm. We also
provided entries in template-dse.ldif and such to achieve this.

However, that's not sufficent today. Two scenarioes exist that complicate this. One is when you
restore your state (db, config) from a backup to a server that has already completed the rpm
upgrade process. This now relies on the administrator to manually run setup-ds.pl - something we
can not guarantee and poses a risk to stability of the service. The second scenario is containers -
containers by their nature seperate the application (the container image) from the state (the
data volume attached at runtime). In containers, the application may be upgrade in the image, but
this occurs seperate to the state - an administrator would "pull" the new image and run it attached
to the state, with no upgrade process in place.

Approach
========

With this in mind we must consider that as application and state are seperated, the only time our
application can affect the data state and perform an upgrade, is at the time they are first attached
- IE when the ns-slapd process starts. Performing on-startup migrations means that all scenarioes
are correctly handled. In order to do this correctly, we must consider how we design features, and
create migrations.

Avoid configuration if possible
===============================

This is the first strategy - we do not need to migrate anything that does not exist. Having features
that are switched at compile time through define flags, means we have a path to enable and disable
features for development and release, and a path to "rollback" for customers. It also helps that
when we enable features, we guarantee that all upgrades will be consuming these changes in a consitent
and uniform manner.

Default configuration in libglobs.c
===================================

If we can not avoid configuration, we should use the configuration reset mechanism. This is where
we ship "default" values in libglobs.c, that do not need to be in cn=config. This allows admins to
override defaults if they wish, means we do not require any migrations, and can change the default
progressively over time where the upgrade will "take effect" unless an override has been provided.
For more information see:

- [Configuration Reset](configuration-reset.html)

Migrate on startup
==================

If we have a configuration entry that requires creation such as a plugin definition, or some other
more complex change, we should migrate these on start up using the mechanisms in
`config.c slapd_bootstrap_config()`. An example of this is the creation of the PBKDF2 plugin on start
up.

However, these mechanisms have a flaw - they "set" an entry to look a specific way, and overwrite it
each startup meaning that user defined changes are always lost. This has led to issues where people
attempt to disable pbkdf and it re-enables on restarts.

A new upgrade framework was proposed as part of a past patch series that allows for more informed
upgrade decisions to be made during the server startup.

This is called from main.c upgrade_server(), which then calls a series of stateful upgrade handlers.
These are able to use logic such as "entry_exists_or_create" which will create an entry only if it
does not exist meaning that administrator changes won't be removed on future restarts.

In the future other handlers could be added such as "entry_assert_or_create" which would check that
a specific set of attribute-values are defined, or that the entry is created. For example, this could
be used to ensure a set of entries exist in a specific form, but that user defined extensions are still
respected.


