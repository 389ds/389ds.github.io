---
title: "Releases/2.1.4"
---

389 Directory Server 2.1.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.1.4

Fedora packages are available on Fedora 36

<http://koji.fedoraproject.org/koji/buildinfo?buildID=2038470>

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-233e21f455> - Bodhi


The new packages and versions are:

- 389-ds-base-2.1.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.1.4.tar.gz)

### Highlights in 2.1.4

- Bug fixes & RFE for allowing ECDSA private keys
- Transition from BDB(libdb) to LMDB begun.  BDB is still the default backend, but it can be changed to LMDB for early testing.

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 2.1.4
- Issue 5383 - UI - Various fixes and RFE's for UI
- Issue 4656 - Remove problematic language from source code
- Issue 5380 - Separate cleanAllRUV code into new file
- Issue 5322 - optime & wtime on rejected connections is not properly set
- Issue 5375 - CI - disable TLS hostname checking
- Issue 5373 - dsidm user get_dn fails with search_ext() argument 1 must be str, not function
- Issue 5371 - Update npm and cargo packages
- Issue 3069 - RFE - Support ECDSA private keys for TLS (#5365)

