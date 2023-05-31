---
title: "Automember Plugin Fixup Improvements"
---

# Automember Plugin Fixup Improvements
----------------

Overview
--------

The rebuild task will first go through all the automember rules and remove all the user memberships from the these groups, then it rebuilds the memberships from scratch.  The problem is that this is often not needed, and it is very expensive (especially if other be_txn plugins are enabled).  The only reason the cleanup operations need to be done is if automember rules are removed.  If rules are added then there is no need to do the cleanup.  So by default we should not do this "cleanup", and instead add an option to the Slapi Task entry to do this cleanup if needed.

Design
------

Added a new attribute to the fixup task "**cleanup**" that be set to "yes/no" or "on/off".  In the CLI/dsconf there is a new "\-\-cleanup" argument that can be passed to trigger this cleansing/cleanup.  BY default we no longer clean up groups.:

    # dsconf slapd-inst plugins automember fixup -f objectclass=posixaccount -s sub --cleanup "ou=people,dc=example,dc=com"


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/5547>

Author
------

<mreynolds@redhat.com>
