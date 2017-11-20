---
title: "Releases/1.4.0.3"
---

389 Directory Server 1.4.0.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.3

Fedora packages are available on Fedora 28(rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=23262737>

The new packages and versions are:

-   389-ds-base-1.4.0.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.3.tar.bz2)

### Highlights in 1.4.0.3

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

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.0.3
- Ticket 49457 - Fix spal_meminfo_get function prototype
- Ticket 49455 - Add tests to monitor test suit.
- Ticket 49448 - dynamic default pw scheme based on environment.
- Ticket 49298 - fix complier warn
- Ticket 49298 - Correct error codes with config restore.
- Ticket 49454 - SSL Client Authentication breaks in FIPS mode
- Ticket 49453 - passwd.py to use pwdhash defaults.
- Ticket 49427 - whitespace in fedse.c
- Ticket 49410 - opened connection can remain no longer poll, like hanging
- Ticket 48118 - fix compiler warning for incorrect return type
- Ticket 49451 - Add environment markers to lib389 dependencies
- Ticket 49325 - Proof of concept rust tqueue in sds
- Ticket 49443 - scope one searches in 1.3.7 give incorrect results
- Ticket 48118 - At startup, changelog can be erronously rebuilt after a normal shutdown
- Ticket 49412 - SIGSEV when setting invalid changelog config value
- Ticket 49441 - Import crashes - oneline fix
- Ticket 49377 - Incoming BER too large with TLS on plain port
- Ticket 49441 - Import crashes with large indexed binary  attributes
- Ticket 49435 - Fix NS race condition on loaded test systems
- Ticket 77 - lib389 - Refactor docstrings in rST format - part 2
- Ticket 17 - lib389 - dsremove support
- Ticket 3 - lib389 - python 3 compat for paged results test
- Ticket 3 - lib389 - Python 3 support for memberof plugin test suit
- Ticket 3 - lib389 - config test
- Ticket 3 - lib389 - python 3 support ds_logs tests
- Ticket 3 - lib389 - python 3 support for betxn test

