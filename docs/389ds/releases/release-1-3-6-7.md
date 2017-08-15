---
title: "Releases/1.3.6.7"
---
389 Directory Server 1.3.6.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.7

Fedora packages are available from the Fedora 26.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-431f07f52a

The new packages and versions are:

-   389-ds-base-1.3.6.7-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.6.7.tar.bz2)

### Highlights in 1.3.6.7

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

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.6.7-1
- Ticket 49330 - Improve ndn cache performance
- Ticket 49298 - fix missing header
- Ticket 49298 - force sync() on shutdown
- Ticket 49336 - SECURITY: Locked account provides different return code
- Ticket 49334 - fix backup restore if changelog exists
- Ticket 49313 - Change the retrochangelog default cache size
- Fix error log format in add.c
- Ticket 49287 - fix compiler warning for patch 49287
- Ticket 49287 - v3 extend csnpl handling to multiple backends
- Ticket 49288 - RootDN Access wrong plugin path in template-dse.ldif.in
- Ticket 49291 - slapi_search_internal_callback_pb may SIGSEV if related pblock has not operation set
- Ticket 49008 - Fix MO plugin betxn test
- Ticket 49227 - ldapsearch does not return the expected Error log level
- Ticket 49028 - Add autotuning test suite
- Ticket 49273 - bak2db doesn't operate with dbversion
- Ticket 49184 - adjust logging level in MO plugin
- Ticket 49257 - only register modify callbacks
- Ticket 49257 - Update CI script
- Ticket 49008 - Adjust CI test for new memberOf behavior
- Ticket 49273 - crash when DBVERSION is corrupt.
- Ticket 49268 - master branch fails on big endian systems
- Ticket 49241 - add symblic link location to db2bak.pl output
- Ticket 49257 - Reject nsslapd-cachememsize & nsslapd-cachesize when nsslapd-cache-autosize is set
- Ticket 48538 - Failed to delete old semaphore
- Ticket 49231 - force EXTERNAL always
- Ticket 49267 - autosize split of 0 results in dbcache of 0


