---
title: "Releases/1.3.7.5"
---

389 Directory Server 1.3.7.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.5

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=974124>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.5-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.5.tar.bz2)

### Highlights in 1.3.7.5

- Bug fixes

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

- Bump version to 1.3.7.5 
- Ticket 49327 - Add CI test for password expiration controls 
- Ticket 48085 - CI tests - replication ruvstore 
- Ticket 49381 - Refactor numerous suite docstrings 
- Ticket 48085 - CI tests - replication cl5 
- Ticket 49379 - Allowed sasl mapping requires restart 
- Ticket 49327 - password expired control not sent during grace logins 
- Ticket 49380 - Add CI test 
- Ticket 83 - Fix create_test.py imports 
- Ticket 49381 - Add docstrings to ds_logs, gssapi_repl, betxn 
- Ticket 49380 - Crash when adding invalid replication agreement 
- Ticket 48081 - CI test - password - Ticket 49295 - Fix CI tests 
- Ticket 49295 - Fix CI test for account policy 
- Ticket 49373 - remove unused header file

