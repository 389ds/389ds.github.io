---
title: "Directory Server Health Check Tool"
---

# Health Check Tool Introduction
------------------------------------------

This dcocument is being used to layout the "healthcheck" subcommand of dsconf.  Herein lies the requirements coming from downstream (RHEL) in a larger effort to provide a consistent "healthcheck tool report" across all of the IDM producets (FreeIPA, DS, and CS).


# Purpose
---------------------

Provide a tool that report on the "health" of a Directory Server instance so Administrators and detect and address varies problems.  This means things like invalid/outdated configuration, backend databases, plugin configuration, TLS certificates(expiration), replication sync status, performance (sanity tests), diskspace, memory usage, etc. 


# The Checks
---------------------

Here is a list of possible checks the tool could do...

- Configuration:  Check for old outdated values, or values that are not appropriate (too high/too low).  This really applies to cn=config, and cn=encryption,cn=config (SSL version range)
- Backends:  Check that a mapping tree entry has a backend entry, and visa versa.  This is already present as a "lint" function in lib389.
- Plugins:  Check for common configuration mistakes
- Replication:  Check sync status of agreements, and that changelog trimming is configured
- Security:  Check certs are not expired, or close to expiring
- Disk Space:  Check the available diskspace for each disk mount used by the server (might require a new monmitor entry - something a client can querying)
- Memory Usage: Check the servers memory size verses available memory
- DB Usage:  Sanity check that the server accepts all the operations andis not hung:  BIND, SRCH, MOD, MODRDN, and DEL
- Performamce:  Sanity check that a search on each backend root node is returned within 5 seconds.


# The Report
----------------------

The report should be in JSON object, which can optionally be written to a custom file.
