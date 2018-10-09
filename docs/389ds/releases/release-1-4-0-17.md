---
title: "Releases/1.4.0.17"
---

389 Directory Server 1.4.0.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.17

Fedora packages are available on Fedora 28, 29, and rawhide.

Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30149568>

Fedora 29

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30149637>

Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30149769>

Bodhi

F28 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-2705a7bc42>

F29 <https://bodhi.fedoraproject.org/updates/FEDORA-2018-017b0cf3dd>

The new packages and versions are:

- 389-ds-base-1.4.0.17-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.17.tar.bz2)

### Highlights in 1.4.0.17

Bug and security fixes

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.17-1
- Ticket 49969 - DOS caused by malformed search operation (security fix)
- Ticket 49943 - rfc3673_all_oper_attrs_test is not strict enough
- Ticket 49915 - Master ns-slapd had 100% CPU usage after starting replication and replication cannot finish
- Ticket 49963 - ASAN build fails on F28
- Ticket 49947 - Coverity Fixes
- Ticket 49958 - extended search fail to match entries
- Ticket 49928 - WebUI schema functionality and improve CLI part
- Ticket 49954 - On s390x arch retrieved DB page size is stored as size_t rather than uint32_t
- Ticket 49928 - Refactor and improve schema CLI/lib389 part to DSLdapObject
- Ticket 49926 - Fix replication tests on 1.3.x
- Ticket 49926 - Add replication functionality to dsconf
- Ticket 49887 - Clean up thread local usage
- Ticket 49937 - Log buffer exceeded emergency logging msg is not thread-safe (security fix)
- Ticket 49866 - fix typo in cos template in pwpolicy subtree create
- Ticket 49930 - Correction of the existing fixture function names to remove test_ prefix
- Ticket 49932 - Crash in delete_passwdPolicy when persistent search connections are terminated unexpectedly
- Ticket 48053 - Add attribute encryption test cases
- Ticket 49866 - Refactor PwPolicy lib389/CLI module
- Ticket 49877 - Add log level functionality to UI



