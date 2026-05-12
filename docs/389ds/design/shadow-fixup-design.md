---
title: "Shadow Account Fix-up Task"
---

# Shadow Account Fix-up Task
----------------------------------

Overview
--------

When updating userPassword in RHDS, the shadowLastChange attribute is automatically generated. This behavior aligns with RFC 2307 and was implemented in [Shawdow Account Support](https://www.port389.org/docs/389ds/design/shadow-account-support.html). AIX systems validate the presence of **shadowLastChange** when both **shadowMin** and **shadowMax** are set, but in databases migrated from ODSEE if **shadowLastChange** is not present then AIX authentication fails. There needs to be a shadow account fix-up task so that after a database import the **shadowlastChange** attribute can be added/updated. There is also an issue where *shadowLastChange* might have an incorrect value because it was manually set. So *shadowLastChange* could be missing, or it could have a stale/incorrect value.

Design
----------------------------------

The fixup task takes a suffix/subtree and searches for all entries that have objectclass **shadowAccount**. If the entry does not have **shadowLastChange** present, then it adds it. If the value is determined to be stale, or out-of-date, it regenerates the value based off of **passwordExpirationtime** operational attribute.

The way the value is determined to be *stale* is to look at *passwordExpirationtime* value, minus the password policy passwordMaxage value, convert it to days, and compare that to the current value of *shadowLastChange*. If they are different then the task resets the value to:  (passwordExpirationtime - maxAge) / SECONDS-PER-DAY   ---> the **ShadowLastChange" value is the number of *days* since January 1, 1970 (epoch). So when we build out the value it needs to be in *days* not *seconds*.

CLI Implementation
--------------

```
# dsconf slapd-localhost pwpolicy fixup-shadow --help 
usage: dsconf [-v] [-j] instance pwpolicy fixup-shadow [-h] [--force] [--watch] suffix

positional arguments:
  suffix         LDAP suffix to search (subtree) for objectClass ShadowAccount

options:
  -v, --verbose  Display verbose operation tracing during command execution
  -j, --json     Return result in JSON object
  -h, --help     show this help message and exit
  --force        Update all users under the suffix regardless if shadowLastChange is set.
  --watch        Watch the task's status and wait for it to finish.

Examples:

# dsconf localhost pwpolicy fixup-shadow dc=example,dc=com --watch

# dsconf localhost pwpolicy fixup-shadow ou=people,dc=example,dc=com 

# dsconf localhost pwpolicy fixup-shadow dc=example,dc=com --force

```

Task Entry
-------------

The task is created under

    cn=fixup shadow attributes,cn=tasks,cn=config

Task entry looks like

    dn: cn=my fixup task,cn=fixup shadow attributes,cn=tasks,cn=config
    objectclass: top
    objectclass: extensibleObject
    cn: my fixup task
    suffix: ou=people,dc=example,dc=com
    force: off


Origin
-------------

<https://github.com/389ds/389-ds-base/issues/7493>

Author
------

<mreynolds@redhat.com>
