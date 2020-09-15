---
title: "Releases/1.4.0.4"
---

389 Directory Server 1.4.0.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.4

Fedora packages are available on Fedora 28(rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=23262737>

The new packages and versions are:

-   389-ds-base-1.4.0.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.4.tar.bz2)

### Highlights in 1.4.0.4

- Version change

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

- Bump version to 1.4.0.4
- Ticket 49540 - Indexing task is reported finished too early regarding the backend status
- Ticket 49534 - Fix coverity regression
- Ticket 49544 - cli release preperation, group improvements
- Ticket 49542 - Unpackaged files on el7 break rpm build
- Ticket 49541 - repl config should not allow rid 65535 for masters
- Ticket 49370 - Add all the password policy defaults to a new local policy
- Ticket 49425 - improve demo objects for install
- Ticket 49537 - allow asan to build with stable rustc
- Ticket 49526 - Improve create_test.py script
- Ticket 49516 - Add python 3 support for replication suite
- Ticket 49534 - Fix coverity issues and regression
- Ticket 49532 - coverity issues - fix compiler warnings & clang issues
- Ticket 49531 - coverity issues - fix memory leaks
- Ticket 49463 - After cleanALLruv, there is a flow of keep alive DEL
- Ticket 49529 - Fix Coverity warnings: invalid deferences
- Ticket 49509 - Indexing of internationalized matching rules is failing
- Ticket 49527 - Improve ds* cli tool testing
- Ticket 49474 - purge saslmaps before gssapi test
- Ticket 49413 - Changelog trimming ignores disabled replica-agreement
- Ticket 49446 - cleanallruv should ignore cleaned replica Id in processing changelog if in force mode
- Ticket 49278 - GetEffectiveRights gives false-negative
- Ticket 49508 - memory leak in cn=replica plugin setup
- Ticket 48118 - Add CI test case
- Ticket 49520 - Cockpit UI - Add database chaining HTML
- Ticket 49512 - Add ds-cockpit-setup to rpm spec file
- Ticket 49523 - Refactor CI test
- Ticket 49524 - Password policy: minimum token length fails  when the token length is equal to attribute length
- Ticket 49517 - Cockpit UI - Add correct png files
- Ticket 49517 - Cockput UI - revise config layout
- Ticket 49523 - memberof: schema violation error message is confusing as memberof will likely repair target entry
- Ticket 49312 - Added a new test case for "-D configdir"
- Ticket 49512 - remove backup directories from cockpit source
- Ticket 49512 - Add initial Cockpit UI Plugin
- Ticket 49515 - cannot link, missing -fPIC
- Ticket 49474 - Improve GSSAPI testing capability
- Ticket 49493 - heap use after free in csn_as_string
- Ticket 49379 - Add Python 3 support to CI test
- Ticket 49431 - Add CI test case
- Ticket 49495 - cos stress test and improvements.
- Ticket 49495 - Fix memory management is vattr.
- Ticket 49494 - python 2 bytes mode.
- Ticket 49471 - heap-buffer-overflow in ss_unescape
- Ticket 48184 - close connections at shutdown cleanly.
- Ticket 49218 - Certmap - support TLS tests
- Ticket 49470 - overflow in pblock_get
- Ticket 49443 - Add CI test case
- Ticket 49484 - Minor cli tool fixes.
- Ticket 49486 - change ns stress core to use absolute int width.
- Ticket 49445 - Improve regression test to detect memory leak.
- Ticket 49445 - Memory leak in ldif2db
- Ticket 49485 - Typo in gccsec_defs
- Ticket 49479 - Remove unused 'batch' argument from lib389
- Ticket 49480 - Improvements to support IPA install.
- Ticket 49474 - sasl allow mechs does not operate correctly
- Ticket 49449 - Load sysctl values on rpm upgrade.
- Ticket 49374 - Add CI test case
- Ticket 49325 - fix rust linking.
- Ticket 49475 - docker poc improvements.
- Ticket 49461 - Improve db2index handling for test 49290
- Ticket 47536 - Add Python 3 support and move test case to suites
- Ticket 49444 - huaf in task.c during high load import
- Ticket 49460 - replica_write_ruv log a failure even when it succeeds
- Ticket 49298 - Ticket with test case and remove-ds.pl
- Ticket 49408 - Add a test case for nsds5ReplicaId checks
- Ticket 3 lib389 - python 3 support for subset of pwd cases
- Ticket 35 lib389 - dsconf automember support


