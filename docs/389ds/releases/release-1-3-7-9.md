---
title: "Releases/1.3.7.9"
---

389 Directory Server 1.3.7.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.9

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1022742>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-3d60a6932b>

The new packages and versions are:

-   389-ds-base-1.3.7.9-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.9.tar.bz2)

### Highlights in 1.3.7.9

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.9
- CVE-2017-15134 - Remote DoS via search filters in  slapi_filter_sprintf
- Ticket 49546 - Fix broken snmp MIB file
- Ticket 49541 - Replica ID config validation fix
- Ticket 49370 - Crash when using a global and local pw  policies
- Ticket 49540 - Indexing task is reported finished too early regarding the backend status
- Ticket 49534 - Fix coverity regression
- Ticket 49541 - repl config should not allow rid 65535 for masters
- Ticket 49370 - Add all the password policy defaults to a new local policy
- Ticket 49526 - Improve create_test.py script
- Ticket 49534 - Fix coverity issues and regression
- Ticket 49523 - memberof: schema violation error message is confusing as memberof will likely repair target entry
- Ticket 49532 - coverity issues - fix compiler warnings & clang issues
- Ticket 49463 - After cleanALLruv, there is a flow of keep alive DEL
- Ticket 48184 - close connections at shutdown cleanly.
- Ticket 49509 - Indexing of internationalized matching rules is failing
- Ticket 49531 - coverity issues - fix memory leaks
- Ticket 49529 - Fix Coverity warnings: invalid deferences
- Ticket 49413 - Changelog trimming ignores disabled replica-agreement
- Ticket 49446 - cleanallruv should ignore cleaned replica Id in processing changelog if in force mode
- Ticket 49278 - GetEffectiveRights gives false-negative
- Ticket 49524 - Password policy: minimum token length fails  when the token length is equal to attribute length
- Ticket 49493 - heap use after free in csn_as_string
- Ticket 49495 - Fix memory management is vattr.
- Ticket 49471 - heap-buffer-overflow in ss_unescape
- Ticket 49449 - Load sysctl values on rpm upgrade.
- Ticket 49470 - overflow in pblock_get
- Ticket 49474 - sasl allow mechs does not operate correctly
- Ticket 49460 - replica_write_ruv log a failure even when it succeeds

