---
title: "Error JSON Logging Design"
---

# Error JSON Logging
----------------

Overview
--------

In order to make the error logging more consumable by standard parsing tool it will written in a JSON format.


JSON Design
------------

```
    {
        local_time: <strftime output - customizable>
        severity: "ERR | INFO | WARNING | ..."
        subsystem: ""
        msg: ""
    },
    {
        ...
    }
```

Configuration
------------------------

Added a new configuration setting for error logging under **cn=config**

```
nsslapd-errorlog-json-format: default | json | json-pretty
```

For now set this to "default", but in a next major release it should be set to "json" by default.

When switching to a new logging format the current log will be rotated.

You can also customize the "local_time" format using strftime conversion specifications.  The default would be **%FT%T**

    nsslapd-errorlog-time-format: {strftime specs}


Origin
-----------------------

<https://github.com/389ds/389-ds-base/issues/6663>


Author
-----------------------

<mreynolds@redhat.com>

