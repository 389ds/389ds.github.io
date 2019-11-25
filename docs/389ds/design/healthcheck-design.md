---
title: "Directory Server Health Check Tool"
---

# Overview
------------------------------------------

This document is being used to layout the "healthcheck" subcommand of dsctl.  Herein lies the requirements coming from downstream (RHEL) in a larger effort to provide a consistent and complete "healthcheck tool report" across all of the IDM products (FreeIPA, DS, and CS).


# Design
------------------------------------------

Gather and analyze a server for potential issues, and describe how to resolve them.  There will be a human-readable report, and a JSON report available.  Since health checking requires looking at things outside of the server itself, like TLS certificates and system files, the data must be gathered by running **dsctl** on the same system. 


# The Checks
---------------------

Here is a list of checks the tool does:

- Configuration:  Check for old outdated values, or values that are not appropriate (too high/too low).  This really applies to cn=config, and cn=encryption,cn=config (SSL version range)
- Backends:  Check that a mapping tree entry has a backend entry, and visa versa.  This is already present as a "lint" function in lib389.
- Plugins:  Check for common configuration mistakes
- Replication:  Check sync status of agreements, and that changelog trimming is configured
- Security:  Check certs are not expired, or close to expiring
- Disk Space:  Check the available diskspace for each disk mount used by the server (config, logs, db)

# Usage
------------------------

Here is an example running the the output you might see

    dsctl [--json] INSTANCE_NAME healthcheck


    # dsctl slapd-localhost healthcheck
    Beginning lint report, this could take a while ...
    Checking Backends ...
    Checking Config ...
    Checking Encryption ...
    Checking FSChecks ...
    Checking ReferentialIntegrityPlugin ...
    Checking MonitorDiskSpace ...
    Checking Replica ...
    Checking Changelog5 ...
    Checking NssSsl ...
    Healthcheck complete.
    1 Issue found!  Generating report ...


    [1] DS Lint Error: DSELE0001
    --------------------------------------------------------------------------------
    Severity: MEDIUM 
    Affects:
     -- cn=encryption,cn=config

    Details:
    -----------
    This Directory Server may not be using strong TLS protocol versions. TLS1.0 is known to
    have a number of issues with the protocol. Please see:

    https://tools.ietf.org/html/rfc7457

    It is advised you set this value to the maximum possible.

    Resolution:
    -----------
    There are two options for setting the TLS minimum version allowed.  You,
    can set "sslVersionMin" in "cn=encryption,cn=config" to a version greater than "TLS1.0"
    You can also use 'dsconf' to set this value.  Here is an example:

        # dsconf slapd-localhost security set --tls-protocol-min=TLS1.2

    You must restart the Directory Server for this change to take effect.

    Or, you can set the system wide crypto policy to FUTURE which will use a higher TLS
    minimum version, but doing this affects the entire system:

        # update-crypto-policies --set FUTURE


    ===== End Of Report (1 Issue found) =====


<br>
This is the JSON output format

    [
        {
             "dsle": "RESULT CODE", 
             "severity": "HIGH/MEDIUM/LOW", 
             "items": [
                 ITEM,
                 ITEM,
             ], 
             "detail": "PROBLEM DESCRIPTION", 
             "fix": "RESOLUTION"
        }
    ]

<br>
From the example above it would look like this:

    #  dsctl --json slapd-localhost healthcheck 
    [{"dsle": "DSELE0001", "severity": "MEDIUM", "items": ["cn=encryption,cn=config"], "detail": "This Directory Server may not be using strong TLS protocol versions. TLS1.0 is known to\nhave a number of issues with the protocol. Please see:\n\nhttps://tools.ietf.org/html/rfc7457\n\nIt is advised you set this value to the maximum possible.", "fix": "There are two options for setting the TLS minimum version allowed.  You,\ncan set \"sslVersionMin\" in \"cn=encryption,cn=config\" to a version greater than \"TLS1.0\"\nYou can also use 'dsconf' to set this value.  Here is an example:\n\n    # dsconf slapd-localhost security set --tls-protocol-min=TLS1.2\n\nYou must restart the Directory Server for this change to take effect.\n\nOr, you can set the system wide crypto policy to FUTURE which will use a higher TLS\nminimum version, but doing this affects the entire system:\n\n    # update-crypto-policies --set FUTURE"}]

<br>

# The Report Results
----------------------

Here is a table of the types of things the tool checks.  These list will probably expand in future releases of the server.

|Result Code     |Component   |Severity       |Description  |
|---------------|-------------|---------------|-------------|
|DSBLE0001      |Backend      |Medium         |Backend missing mapping tree|
|DSBLE0002      |Server       |High           |Unable to query backend|
|DSBLE0003      |Backend      |Low            |Database not initialized|
|DSVIRTLE0001   |Config       |High           |Virtual attribute is incorrectly indexed|
|DSCLE0001      |Config       |Low            |Logging format should be revised|
|DSCLE0002      |Security     |High           |Insecure password hash configured|
|DSELE0001      |Security     |Medium         |Minimum allows TLS version too low|
|DSRILE0001     |Plugins      |Low            |RI plugin is misconfigured|
|DSRILE0002     |Plugins      |High           |RI plugin missing indexes|
|DSREPLLE0001   |Replication  |High           |Out of synchronization - broken|
|DSREPLLE0002   |Replication  |Low            |Presence of conflict entries|
|DSREPLLE0003   |Replication  |Medium         |Out of synchronization, but not broken|
|DSREPLLE0004   |Replication  |Medium         |Failed to get status - state unknown|
|DSREPLLE0005   |Replication  |Medium         |Replica not reachable|
|DSCLLE0001     |Replication  |Medium         |Changelog trimming is not configured|
|DSCERTLE0001   |TLS Certificates |Medium     |Certificate expiring within 30 days|
|DSCERTLE0002   |TLS Certificates |High       |Certificate expired|
|DSDSLE0001     |OS           |High           |Low disk space|
|DSPERMLE0001   |OS           |Medium         |Bad file permissions on /etc/resolv.conf|
|DSPERMLE0002   |OS/Security  |High           |Bad file permissions on security db password/pin files|







