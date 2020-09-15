---
title: "Releases/1.4.1.5"
---

389 Directory Server 1.4.1.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.5

Fedora packages are available on Fedora 30 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36139436> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=36137973> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-cc5eaae53e>


The new packages and versions are:

- 389-ds-base-1.4.1.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.5.tar.bz2)

### Highlights in 1.4.1.5

- Bug fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### New UI Progress (Cockpit plugin)

The new UI is broken up into a series of configuration tabs.  Here is a table showing the current progress

|Configuration Tab|Finished|Written in ReactJS |
|-----------------|--------|-------------------|
|Server Tab|Yes|No|
|Security Tab|No (coming soon)|No|
|Database Tab|Yes|Yes|
|Replication Tab|Yes|No|
|Schema Tab|Yes|No|
|Plugin Tab|Yes|Yes|
|Monitor Tab|Yes|Yes|


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.1.5
- Issue 50431 - Fix regression from coverity fix (crash in memberOf plugin)
- Issue 49239 - Add a new CI test case
- Issue 49997 - Add a new CI test case
- Issue 50177 - Add a new CI test case, also added fixes in lib389
- Issue 49761 - Fix CI test suite issues
- Issue 50474 - Unify result codes for add and modify of repl5 config
- Issue 50472 - memory leak with encryption
- Issue 50462 - Fix Root DN access control plugin CI tests
- Issue 50462 - Fix CI tests
- Issue 50217 - Implement dsconf security section
- Issue 48851 - Add more test cases to the match test suite.
- Issue 50378 - ACI's with IPv4 and IPv6 bind rules do not work for IPv6 clients
- Issue 50439 - fix waitpid issue when pid does not exist
- Issue 50454 - Fix Cockpit UI branding
- Issue 48851 - investigate and port TET matching rules filter tests(index)
- Issue 49232 - Truncate the message when buffer capacity is exceeded




