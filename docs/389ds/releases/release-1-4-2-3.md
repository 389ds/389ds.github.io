---
title: "Releases/1.4.2.3"
---

389 Directory Server 1.4.2.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.3

Fedora packages are available on Fedora (rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=38746765> - Rawhide


The new packages and versions are:

- 389-ds-base-1.4.2.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.3.tar.bz2)

### Highlights in 1.4.2.3

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

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but every feature is available.

|Configuration Tab|Functional|Written in ReactJS |
|-----------------|----------|-------------------|
|Server Tab       |Yes       |No                 |
|Security Tab     |Yes       |Yes                |
|Database Tab     |Yes       |Yes                |
|Replication Tab  |Yes       |Yes                |
|Schema Tab       |Yes       |No                 |
|Plugin Tab       |Yes       |Yes                |
|Monitor Tab      |Yes       |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.2.3
- Issue 50592 - Port Replication Tab to ReactJS
- Issue 50680 - Remove branding from upstream spec file
- Issue 50669 - Remove nunc-stans in favour of reworking current conn code (add.)
- Issue 48055 - CI test - automember_plugin(part1)
- Issue 50677 - Map subtree searches with NULL base to default naming context
- Issue 50669 - Fix RPM build
- Issue 50669 - remove nunc-stans
- Issue 49850 - cont -fix crash in ldbm_non_leaf
- Issue 50634 - Clean up CLI errors output - Fix wrong exception
- Issue 50660 - Build failure on Fedora 31
- Issue 50634 - Clean up CLI errors output
- Issue 48851 - Investigate and port TET matching rules filter tests(match more test cases)
- Issue 50428 - Log the actual base DN when the search fails with "invalid attribute request"
- Issue 49850 -  ldbm_get_nonleaf_ids() slow for databases with many non-leaf entries
- Issue 50655 - access log etime is not properly formatted
- Issue 50653 -  objectclass parsing fails to log error message text
- Issue 50646 - Improve task handling during shutdowns
- Issue 50627 - Support platforms without pytest_html
- Issue 49476 - backend refactoring phase1, fix failing tests
- Issue 49476 - refactor ldbm backend to allow replacement of BDB
- Issue 50349 - additional fix: filter schema check must handle subtypes
- Issue 48851 - investigate and port TET matching rules filter tests(indexing more test cases)
- Issue 50638 - RecursionError: maximum recursion depth exceeded while calling a Python object
- Issue 50636 - Crash during sasl bind
- Issue 50632 - Add ensure attr state so that diffs are easier from 389-ds-portal
- Issue 50619 - extend commands to have more modify options
- Issue 50499 - Fix npm audit issues




