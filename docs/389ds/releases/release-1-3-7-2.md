---
title: "Releases/1.3.7.2"
---
389 Directory Server 1.3.7.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.2

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21401020>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21401182>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.2-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.2.tar.bz2)

### Highlights in 1.3.7.2

- Security fix, bug fixes, and enhancements

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

- Bump version to 1.3.7.2
- Ticket 49038 - Fix regression from legacy code cleanup
- Ticket 49295 - Fix CI tests
- Ticket 48067 - Add bugzilla tests for ds_logs
- Ticket 49356 - mapping tree crash can occur during tot init
- Ticket 49275 - fix compiler warns for gcc 7
- Ticket 49248 - Add a docstring to account locking test case
- Ticket 49445 - remove dead code
- Ticket 48081 - Add regression tests for pwpolicy
- Ticket 48056 - Add docstrings to basic test suite
- Ticket 49349 - global name 'imap' is not defined
- Ticket 83 - lib389 - Fix tests and create_test.py
- Ticket 48185 - Remove referint-logchanges attr from referint's config
- Ticket 48081 - Add regression tests for pwpolicy
- Ticket 83 - lib389 - Replace topology agmt objects
- Ticket 49331 - change autoscaling defaults
- Ticket 49330 - Improve ndn cache performance.
- Ticket 49347 - reproducable build numbers
- Ticket 39344 - changelog ldif import fails
- Ticket 49337 - Add regression tests for import tests
- Ticket 49309 - syntax checking on referint's delay attr
- Ticket 49336 - SECURITY: Locked account provides different return code
- Ticket 49332 - Event queue is not working
- Ticket 49313 - Change the retrochangelog default cache size
- Ticket 49329 - Descriptive error msg for USN cleanup task
- Ticket 49328 - Cleanup source code
- Ticket 49299 - Add normalized dn cache stats to dbmon.sh
- Ticket 49290 - improve idl handling in complex searches
- Ticket 49328 - Update clang-format config file
- Ticket 49091 - remove usage of changelog semaphore
- Ticket 49275 - shadow warnings for gcc7 - pass 1
- Ticket 49316 - fix missing not condition in clock cleanu
- Ticket 49038 - Remove legacy replication
- Ticket 49287 - v3 extend csnpl handling to multiple backends
- Ticket 49310 - remove sds logging in debug builds
- Ticket 49031 - Improve memberof with a cache of group parents
- Ticket 49316 - Fix clock unsafety in DS
- Ticket 48210 - Add IP addr and connid to monitor output
- Ticket 49295 - Fix CI tests and compiler warnings
- Ticket 49295 - Fix CI tests
- Ticket 49305 - Improve atomic behaviours in 389-ds
- Ticket 49298 - fix missing header
- Ticket 49314 - Add untracked files to the .gitignore
- Ticket 49303 - Fix error in CI test
- Ticket 49302 - fix dirsrv importst due to lib389 change
- Ticket 49303 - Add option to disable TLS client-initiated renegotiation
- Ticket 49298 - force sync() on shutdown
- Ticket 49306 - make -f rpm.mk rpms produces build without tcmalloc enabled
- Ticket 49297 - improve search perf in bpt by removing a deref
- Ticket 49284 - resolve crash in memberof when deleting attrs
- Ticket 49290 - unindexed range searches don't provide notes=U
- Ticket 49301 - Add one logpipe test case

