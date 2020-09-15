---
title: "Releases/1.4.0.6"
---

389 Directory Server 1.4.0.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.6

Fedora packages are available on Fedora 28(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1054739>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=25527997>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-22b60d45df>

The new packages and versions are:

-   389-ds-base-1.4.0.6-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.6.tar.bz2)

### Highlights in 1.4.0.6

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

- Bump version to 1.4.0.6
- Ticket 49545 - final substring extended filter search returns invalid resulta (security fix)
- Ticket 49572 - ns_job_wait race on condvar
- Ticket 49584 - Fix Tickets with paged_results test suite
- Ticket 49161 - memberof fails if group is moved into scope
- Ticket 49447 - PBKDF2 on upgrade
- ticket 49551 - correctly handle subordinates and tombstone numsubordinates
- Ticket 49043 - Add replica conflict test suite
- Ticket 49296 - Fix race condition in connection code with  anonymous limits
- Ticket 49568 - Fix integer overflow on 32bit platforms
- Ticket 48085 - Add encryption cl5 test suite
- Ticket 49566 - ds-replcheck needs to work with hidden conflict entries
- Ticket 49519 - Add more Cockpit UI content
- Ticket 49551 - fix memory leak found by coverity
- Ticket 49551 - v3 - correct handling of numsubordinates for cenotaphs and tombstone delete
- Ticket 49278 - Add a new CI test case
- Ticket 49560 - nsslapd-extract-pemfiles should be enabled by default as openldap is moving to openssl
- Ticket 49557 - Add config option for checking CRL on outbound SSL Connections
- Ticket 49446 - Add CI test case
- Ticket 35 -    Description: Add support for managing automember to dsconf
- Ticket 49544 - cli release preperation
- Ticket 48006 - Add a new CI test case

