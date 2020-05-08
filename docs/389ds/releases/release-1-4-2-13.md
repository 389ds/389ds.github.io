---
title: "Releases/1.4.2.13"
---

389 Directory Server 1.4.2.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.13

Fedora packages are available on Fedora 31.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=44236196>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2020-43914ebb85>

The new packages and versions are:

- 389-ds-base-1.4.2.13-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.13.tar.bz2)

### Highlights in 1.4.2.13

- Bug fixes, and UI completion

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

The new UI is complete and QE tested.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.2.13
- Issue 50787 - fix implementation of attr unique
- Issue 51078 - Add nsslapd-enable-upgrade-hash to the schema
- Issue 51068 - deadlock when updating the schema
- Issue 51060 - unable to set sslVersionMin to TLS1.0
- Issue 51064 - Unable to install server where IPv6 is disabled
- Issue 51051 - CLI fix consistency issues with confirmations
- Issue 51047 - React deprecating ComponentWillMount
- Issue 50499 - fix npm audit issues
- Issue 51035 - Heavy StartTLS connection load can randomly fail with err=1
- Issue 51031 - UI - transition between two instances needs improvement

